VENV ?= .venv-docs
VENV_STAMP := $(VENV)/.stamp
PYTHON := $(VENV)/bin/python
PIP := $(VENV)/bin/pip

MKDOCS := $(VENV)/bin/mkdocs

REQS_FILE := requirements.txt
CONFIG_FILE := mkdocs.yaml

.PHONY: serve clean help

.DEFAULT_GOAL := help

venv: $(VENV_STAMP) ## Set up Python venv with dependencies for mkdocs

$(VENV_STAMP): $(REQS_FILE)
	@python3 -m venv $(VENV)
	@$(PIP) install --upgrade pip
	@$(PIP) install -r $(REQS_FILE)
	touch $@

serve: venv ## Serve local dev deployment of mkdocs with live reloads
	@$(MKDOCS) serve --config-file $(CONFIG_FILE) --dirtyreload

build-site: venv ## Let mkdocs build static documentation site artifacts
	@$(MKDOCS) build --config-file $(CONFIG_FILE) --clean

clean: ## Remove virtual environment with installed Python dependencies
	@rm -rf $(VENV)
	@echo "Cleaned up virtual environment."

help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9._-]+:.*?## / {printf "\033[1m\033[36m%-24s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

print-venv-dir:
	@echo $(VENV)

print-python-requirements-file:
	@echo $(REQS_FILE)
