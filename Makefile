VENV ?= .venv
PYTHON := $(VENV)/bin/python
PIP := $(VENV)/bin/pip
ANSIBLE_PLAYBOOK := $(VENV)/bin/ansible-playbook
ANSIBLE_GALAXY := $(VENV)/bin/ansible-galaxy
ANSIBLE_LINT := $(VENV)/bin/ansible-lint

PLAYBOOK ?= playbooks/maas_ops.yaml
TAGS ?= all
VAULT ?= --vault-password-file vault-pass.txt
ARGS ?=

.PHONY: lint run help

.DEFAULT_GOAL := help

venv: $(VENV)

$(VENV): requirements.txt requirements.yaml
	@python3 -m venv $(VENV)
	@$(PIP) install --upgrade pip
	@$(PIP) install -r requirements.txt
	@if [ -f requirements.yaml ]; then \
		echo "Installing Ansible Galaxy roles/collections..."; \
		$(ANSIBLE_GALAXY) install -r requirements.yaml; \
	fi
	touch $(VENV)

lint: venv
	@echo "Running ansible-lint..."
	@$(ANSIBLE_LINT) .

run: venv
	@echo "Running playbook: $(PLAYBOOK)"
	@$(ANSIBLE_PLAYBOOK) $(PLAYBOOK) --tags $(TAGS) $(VAULT) $(ARGS)

.PHONY: clean
clean:
	@rm -rf $(VENV)
	@echo "Cleaned up virtual environment."

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  venv     Set up Python virtual environment and install Ansible Galaxy dependencies"
	@echo "  lint     Run ansible-lint on the project"
	@echo "  run      Run a playbook (default: maas_ops.yaml)"
	@echo "           You can customise it with:"
	@echo "           make run PLAYBOOK=playbooks/foo.yaml INVENTORY=inventory/dev TAGS=teardown ARGS=-vv"
	@echo "           Supported tags for maas_ops are install, upgrade and teardown"
	@echo "  clean    Remove virtual environment"
