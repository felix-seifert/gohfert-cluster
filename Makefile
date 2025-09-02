VENV ?= .venv
PYTHON := $(VENV)/bin/python
PIP := $(VENV)/bin/pip
ANSIBLE_PLAYBOOK := $(VENV)/bin/ansible-playbook
ANSIBLE_GALAXY := $(VENV)/bin/ansible-galaxy
ANSIBLE_LINT := $(VENV)/bin/ansible-lint

PLAYBOOK ?= ansible/playbooks/maas_ops.yaml
TAGS ?= all
VAULT ?= --vault-password-file vault-pass.txt
ARGS ?=

DEPLOY_K3S_CLUSTER_PLAYBOOK := k3s.orchestration.site
RESET_K3S_CLUSTER_PLAYBOOK := k3s.orchestration.reset
REBOOT_K3S_CLUSTER_PLAYBOOK := k3s.orchestration.reboot
UPGRADE_K3S_CLUSTER_PLAYBOOK := k3s.orchestration.upgrade

.PHONY: lint run clean help deploy-k3s-cluster destroy-k3s-cluster reboot-k3s-cluster-nodes upgrade-k3s-cluster-nodes

.DEFAULT_GOAL := help

venv: $(VENV)

$(VENV): requirements.txt ansible/requirements.yaml
	@python3 -m venv $(VENV)
	@$(PIP) install --upgrade pip
	@$(PIP) install -r requirements.txt
	@if [ -f ansible/requirements.yaml ]; then \
		echo "Installing Ansible Galaxy roles/collections..."; \
		$(ANSIBLE_GALAXY) install -r ansible/requirements.yaml; \
	fi
	touch $(VENV)

lint: venv
	@echo "Running ansible-lint..."
	@$(ANSIBLE_LINT) ./ansible/

run: venv
	@echo "Running playbook: $(PLAYBOOK)"
	@$(ANSIBLE_PLAYBOOK) $(PLAYBOOK) --tags $(TAGS) $(VAULT) $(ARGS)

deploy-k3s-cluster:
	$(MAKE) run PLAYBOOK=$(DEPLOY_K3S_CLUSTER_PLAYBOOK)

destroy-k3s-cluster:
	$(MAKE) run PLAYBOOK=$(RESET_K3S_CLUSTER_PLAYBOOK)

reboot-k3s-cluster-nodes:
	$(MAKE) run PLAYBOOK=$(REBOOT_K3S_CLUSTER_PLAYBOOK)

upgrade-k3s-cluster-nodes:
	$(MAKE) run PLAYBOOK=$(UPGRADE_K3S_CLUSTER_PLAYBOOK)

clean:
	@rm -rf $(VENV)
	@echo "Cleaned up virtual environment."

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
	@echo "  reboot-k3s-cluster-nodes   Reboot K3s nodes/machines in data/machines.csv one by one "
	@echo "  upgrade-k3s-cluster-nodes  Upgrade K3s nodes/machines in data/machines.csv one by one to"
	@echo "                             match K3s version in inventory"
	@echo "  clean                      Remove virtual environment"
