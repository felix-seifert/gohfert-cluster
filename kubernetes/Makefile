KUBECTL ?= kubectl
K8S_RESOURCES_DIR := .

# Arg DIR is used to define applying resources only for specific app/subdir
ifdef DIR
  TARGET_DIR := $(K8S_RESOURCES_DIR)/$(DIR)
else
  TARGET_DIR := $(K8S_RESOURCES_DIR)
endif

empty :=
space := $(empty) $(empty)
comma := ,

define replace_commas_with_spaces
  $(subst $(comma),$(space),$(strip $(1)))
endef

# SKIP_DIR (optional) - comma-separated list of dirs to skip under TARGET_DIR
SKIP_DIRS := $(strip $(SKIP_DIR))
SPACE_SEPARATED_SKIP_DIRS := $(call replace_commas_with_spaces,$(SKIP_DIRS))

define generate_skip_dirs_through_prune
	$(foreach dir,$(SPACE_SEPARATED_SKIP_DIRS),-path $(TARGET_DIR)/$(dir) -o) -false
endef

.PHONY: apply-namespaces apply-all apply update-image print-decoded-token help

.DEFAULT_GOAL := help

apply-namespaces: ## Apply all namespaces defined in YAML files (of specific DIR if specified)
	@echo "Applying all manifests with kind Namespace from $(TARGET_DIR)/ (excluding SKIP_DIRS $(SKIP_DIRS))..."
	@find $(TARGET_DIR) \
		\( $(call generate_skip_dirs_through_prune) \) -prune -o \
		\( -type f \( -name "*.yaml" -o -name "*.yml" \) \) -print \
		| xargs grep --files-with-matches "^kind: *Namespace" \
		| xargs --no-run-if-empty --max-args=1 $(KUBECTL) apply --filename

apply-all: ## Apply all resources (also namespaces) defined in YAML files (of specific DIR if specified)
	@echo "Applying all Kubernetes manifests from $(TARGET_DIR)/ (excluding SKIP_DIRS $(SKIP_DIRS))..."
	@find $(TARGET_DIR) \
		\( $(call generate_skip_dirs_through_prune) \) -prune -o \
		\( -type f \( -name "*.yaml" -o -name "*.yml" \) \) -print \
		| xargs --no-run-if-empty --max-args=1 $(KUBECTL) apply --filename

apply: apply-namespaces apply-all ## Apply first namespaces and then all resources defined in YAML files (of specific DIR if specified)

update-image: ## Update tag of given IMAGE to TAG of all resources defined in YAML files (of specific DIR if specified)
	@if [ -z "$(IMAGE)" ] || [ -z "$(TAG)" ]; then \
		echo "Usage: make update-image IMAGE=<image> TAG=<tag> [DIR=<subdirectory>]"; \
		exit 1; \
	fi
	@echo "Updating image '$(IMAGE)' to tag '$(TAG)' in $(TARGET_DIR)/..."
	@find $(TARGET_DIR) -type f -print0 -name "*.yaml" -o -name "*.yml" \
		| xargs -0 grep --files-with-matches "image: *$(IMAGE):" \
		| while read -r file; do \
			old_image=$$(grep --only-matching --extended-regexp "$(IMAGE):[^ \"']+" "$$file" | head -n1); \
			if [ -n "$$old_image" ]; then \
				old_tag=$$(echo "$$old_image" | sed --regexp-extended 's|^$(IMAGE):||'); \
				new_image="$(IMAGE):$(TAG)"; \
				if [ "$$old_tag" = "$(TAG)" ]; then \
					echo " → No change in $$file (already using $(IMAGE):\033[1;32m$(TAG)\033[0m)"; \
				else \
					highlight_old="$$(printf "%s:\033[1;31m%s\033[0m" "$(IMAGE)" "$$old_tag")"; \
					highlight_new="$$(printf "%s:\033[1;32m%s\033[0m" "$(IMAGE)" "$(TAG)")"; \
					sed --in-place --regexp-extended "s|$(IMAGE):[^ \"']+|$$new_image|g" "$$file"; \
					echo " → Updated $$file: $$highlight_old → $$highlight_new"; \
				fi; \
			fi; \
		done

print-decoded-token: ## Print base64 decoded token of secret which is passed as NAME
	@if [ -z "$(NAME)" ]; then \
		echo "Usage: make print-base64-token NAME=<secret-name>"; \
		exit 1; \
    fi
	@NAME=$(NAME) ; \
	NAMESPACE=$$(kubectl get secrets --all-namespaces --output jsonpath='{range .items[?(@.metadata.name=="'"$$NAME"'")]}{.metadata.namespace}{"\n"}{end}') ; \
	if [ -z "$$NAMESPACE" ]; then \
		echo "Secret $$NAME not found in any namespace." >&2 ; exit 1 ; \
	fi ; \
	TOKEN=$$(kubectl get secret $$NAME -n $$NAMESPACE -o jsonpath='{.data.token}' | base64 --decode) ; \
	if [ -z "$$TOKEN" ]; then \
		echo "Token not found in secret $$NAME in namespace $$NAMESPACE." >&2 ; exit 1 ; \
	fi ; \
	echo $$TOKEN

help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9._-]+:.*?## / {printf "\033[1m\033[36m%-24s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
