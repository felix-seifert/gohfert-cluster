VENV ?= .venv-docs
VENV_STAMP := $(VENV)/.stamp
PYTHON := $(VENV)/bin/python
PIP := $(VENV)/bin/pip

MKDOCS := $(VENV)/bin/mkdocs
PYMARKDOWN := $(VENV)/bin/pymarkdown

REQS_FILE := requirements.txt
CONFIG_FILE := mkdocs.yaml

DOCS_CONTENT_DIR := content
DOCS_OUTPUT_DIR := site

DOCKER := docker

REGISTRY := ghcr.io
OWNER := felix-seifert
IMAGE := gohfert-cluster-docs
IMAGE_NAME := $(REGISTRY)/$(OWNER)/$(IMAGE)

TIMESTAMP := $(shell date +%Y%m%d-%H%M%S)
TAG_FILE := .latest-image-built

.PHONY: check-docker serve push-image clean help

.DEFAULT_GOAL := help

check-docker:
	@command -v $(DOCKER) >/dev/null 2>&1 || { \
		echo "Docker is not available on your PATH. Please install it first and put it on your PATH."; \
		exit 1; \
	}
	@echo "Docker is installed: $$($(DOCKER) --version)"

venv: $(VENV_STAMP) ## Set up Python venv with dependencies for mkdocs

$(VENV_STAMP): $(REQS_FILE)
	@python3 -m venv $(VENV)
	@$(PIP) install --upgrade pip
	@$(PIP) install -r $(REQS_FILE)
	touch $@

lint: venv
	@echo "Running Markdown linting..."
	@$(PYMARKDOWN) --config pymarkdownlnt.yaml scan $(DOCS_CONTENT_DIR) --recurse

serve: venv ## Serve local dev deployment of mkdocs with live reloads
	@$(MKDOCS) serve --config-file $(CONFIG_FILE) --dirtyreload

build-site: venv ## Let mkdocs build static documentation site artifacts
	@$(MKDOCS) build --config-file $(CONFIG_FILE) --site-dir $(DOCS_OUTPUT_DIR) --clean

build-image: $(TAG_FILE) ## Build Docker image containing static site artifacts

$(TAG_FILE): site Dockerfile Caddyfile
	@$(MAKE) check-docker --no-print-directory
	@$(DOCKER) build --tag $(IMAGE_NAME):$(TIMESTAMP) --tag $(IMAGE_NAME):latest .
	@echo $(TIMESTAMP) > $(TAG_FILE)

push-image: build-image ## Push built Docker image to ghcr.io
	@$(MAKE) check-docker --no-print-directory
	@$(DOCKER) push $(IMAGE_NAME):$(shell cat $(TAG_FILE))
	@$(DOCKER) push $(IMAGE_NAME):latest

clean: ## Remove virtual environment with installed Python dependencies
	@rm -rf $(VENV)
	@echo "Cleaned up virtual environment."

help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9._-]+:.*?## / {printf "\033[1m\033[36m%-24s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: print-venv-dir print-python-requirements-file print-image-name print-image-tag

print-venv-dir:
	@echo $(VENV)

print-python-requirements-file:
	@echo $(REQS_FILE)

print-image-name:
	@echo $(IMAGE_NAME)

print-image-tag:
	@echo $(shell cat $(TAG_FILE))
