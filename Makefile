VENV ?= .venv
PYTHON := $(VENV)/bin/python
PIP := $(VENV)/bin/pip
ANSIBLE_PLAYBOOK := $(VENV)/bin/ansible-playbook
ANSIBLE_GALAXY := $(VENV)/bin/ansible-galaxy
ANSIBLE_LINT := $(VENV)/bin/ansible-lint
ANSIBLE_SUBDIR := ansible
ANSIBLE_COLLECTIONS_SUBDIR := $(ANSIBLE_SUBDIR)/ansible_collections

PYTHON_REQS_FILE := requirements.txt
ANSIBLE_REQS_FILE := $(ANSIBLE_SUBDIR)/requirements.yaml

# Inline Git config to silence "detached HEAD" advice
GIT_SILENCE_DETACHED = GIT_CONFIG_COUNT=1 \
                       GIT_CONFIG_KEY_0=advice.detachedHead \
                       GIT_CONFIG_VALUE_0=false

TF := terraform
TF_SUBDIR := terraform
TF_PLAN := tfplan

PLAYBOOK ?= $(ANSIBLE_SUBDIR)/playbooks/maas_ops.yaml
TAGS ?= all
VAULT ?= --vault-password-file vault-pass.txt
ARGS ?=

K3S_ANSIBLE_COLLECTION := $(ANSIBLE_SUBDIR)/ansible_collections/techno_tim/k3s_ansible
DEPLOY_K3S_CLUSTER_PLAYBOOK := $(K3S_ANSIBLE_COLLECTION)/site.yml
RESET_K3S_CLUSTER_PLAYBOOK := $(K3S_ANSIBLE_COLLECTION)/reset.yml
REBOOT_K3S_CLUSTER_PLAYBOOK := $(ANSIBLE_SUBDIR)/playbooks/k3s_node_reboot.yaml

.PHONY: check-terraform lint run clean help deploy-k3s-cluster destroy-k3s-cluster reboot-k3s-cluster-nodes

.DEFAULT_GOAL := help

check-terraform:
	@command -v $(TF) >/dev/null 2>&1 || { \
		echo "Terraform is not available on your PATH. Please install it first and put it on your PATH."; \
		exit 1; \
	}
	@echo "Terraform is installed: $$($(TF) version | head -n1)"

init: $(TF_SUBDIR)/.terraform check-terraform

$(TF_SUBDIR)/.terraform: $(TF_SUBDIR)/provider.tf
	@echo "Initialisaing Terraform subdir"
	@$(TF) -chdir=$(TF_SUBDIR) init
	touch $(TF_SUBDIR)/.terraform

venv: $(VENV)

$(VENV): $(PYTHON_REQS_FILE) $(ANSIBLE_REQS_FILE)
	@python3 -m venv $(VENV)
	@$(PIP) install --upgrade pip
	@$(PIP) install -r $(PYTHON_REQS_FILE)
	@if [ -f $(ANSIBLE_REQS_FILE) ]; then \
		echo "Installing Ansible Galaxy roles..."; \
		$(GIT_SILENCE_DETACHED) $(ANSIBLE_GALAXY) role install -r $(ANSIBLE_REQS_FILE); \
		echo "Installing Ansible Galaxy collections..."; \
		$(GIT_SILENCE_DETACHED) $(ANSIBLE_GALAXY) collection install -r $(ANSIBLE_REQS_FILE); \
	fi
	touch $(VENV)

lint: venv init
	@echo "Running terraform fmt check..."
	$(TF) fmt -recursive -check -diff ./terraform/
	@echo "Running terraform validate..."
	$(TF) -chdir=terraform validate
	@echo "Running ansible-lint..."
	@$(ANSIBLE_LINT) $(ANSIBLE_SUBDIR)

run: venv
	@echo "Running playbook: $(PLAYBOOK)"
	@$(ANSIBLE_PLAYBOOK) $(PLAYBOOK) --tags $(TAGS) $(VAULT) $(ARGS)

deploy-k3s-cluster: venv
	$(MAKE) run PLAYBOOK=$(DEPLOY_K3S_CLUSTER_PLAYBOOK)

destroy-k3s-cluster: venv
	$(MAKE) run PLAYBOOK=$(RESET_K3S_CLUSTER_PLAYBOOK)

reboot-k3s-cluster-nodes: venv
ifeq ($(strip $(USER)),)
	$(MAKE) run PLAYBOOK=$(REBOOT_K3S_CLUSTER_PLAYBOOK) \
		ARGS="--extra-vars 'concurrent_reboots=1 wait_seconds_after_reboot=30'"
else
	$(MAKE) run PLAYBOOK=$(REBOOT_K3S_CLUSTER_PLAYBOOK) \
		ARGS="--extra-vars 'concurrent_reboots=1 wait_seconds_after_reboot=30 ansible_user=$(USER)'"
endif

plan: init
	$(TF) -chdir=$(TF_SUBDIR) plan -out=$(TF_PLAN)

apply: init
	@if [ ! -f $(TF_SUBDIR)/$(TF_PLAN) ]; then \
		$(TF) -chdir=$(TF_SUBDIR) apply; \
	fi
	$(TF) -chdir=$(TF_SUBDIR) apply $(TF_PLAN)

mark-for-redeployment: init
	@if [ -z "$(HOSTNAME)" ]; then \
		echo 'Error: HOSTNAME argument is required. Usage: `make mark-for-redeployment HOSTNAME=dematu01`'; \
		exit 1; \
	fi
	@# Assumes specific Terraform module structure
	@$(TF) -chdir=$(TF_SUBDIR) taint module.servers\[\"$(HOSTNAME)\"\].maas_instance.this

mark-for-recommissioning: init
	@if [ -z "$(HOSTNAME)" ]; then \
		echo 'Error: HOSTNAME argument is required. Usage: `make mark-for-recommissioning HOSTNAME=dematu01`'; \
		exit 1; \
	fi
	@# Assumes specific Terraform module structure
	@for resource in `$(TF) -chdir=$(TF_SUBDIR) state list | grep module.servers'\[\"$(HOSTNAME)\"\]'`; do $(TF) -chdir=$(TF_SUBDIR) taint $$resource; done

clean:
	@rm -rf $(VENV)
	@echo "Cleaned up virtual environment."
	@find $(ANSIBLE_SUBDIR)/roles -maxdepth 1 -mindepth 1 -type d ! -name 'custom_*' -exec rm -rf {} +
	@echo "Cleaned up installed Ansible Galaxy roles."
	@rm -rf $(ANSIBLE_COLLECTIONS_SUBDIR)
	@echo "Cleaned up installed Ansible Galaxy collections."

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  venv                       Set up Python virtual environment and install Ansible Galaxy"
	@echo "                             dependencies from ansible/requirements.yaml"
	@echo "  lint                       Run ansible-lint on the project"
	@echo "  run                        Run a playbook (default: ansible/playbooks/maas_ops.yaml)"
	@echo "                             You can customise it with:"
	@echo "                             make run PLAYBOOK=ansible/playbooks/foo.yaml TAGS=teardown ARGS=-vv"
	@echo "                             Supported tags for maas_ops are install, upgrade and teardown"
	@echo "  deploy-k3s-cluster         Deploy fresh K3s cluster on provisioned machines based on data"
	@echo "                             in data/machines.csv"
	@echo "  destroy-k3s-cluster        Destroy existing K3s cluster on machines in data/machines.csv"
	@echo "  reboot-k3s-cluster-nodes   Reboot K3s nodes/machines in data/machines.csv one by one with waits"
	@echo "                             Optionally pass a USER arg to execute as a different user"
	@echo "  plan                       Check Terraform state objects' intention and store necessary changes"
	@echo "                             in a plan file"
	@echo "  apply                      Perform Terraform changes previously stored in a plan file"
	@echo "  mark-for-redeployment      Mark host in var HOSTNAME for redeployment through Terraform"
	@echo "  mark-for-recommissioning"  "Mark host in var HOSTNAME for recommissioning through Terraform"
	@echo "  clean                      Remove virtual environment and installed Ansible Galaxy collections/roles"

.PHONY: print-venv-dir print-python-requirements-file print-ansible-requirements-file

print-venv-dir:
	@echo $(VENV)

print-ansible-collections-dir:
	@echo $(ANSIBLE_COLLECTIONS_SUBDIR)

print-python-requirements-file:
	@echo $(PYTHON_REQS_FILE)

print-ansible-requirements-file:
	@echo $(ANSIBLE_REQS_FILE)
