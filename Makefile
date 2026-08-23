TEMPLATES := go-cue dotnet-node java python ansible-cue extras

.PHONY: help check-contract test test-template test-contract clean docs-dev

.DEFAULT_GOAL := help

help:                                   ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | awk -F ':.*## ' '{printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

check-contract:                         ## Verify every role satisfies the ADR-012 parameter contract
	@bash scripts/check-role-contract.sh

# Mirrors the CI "Prepare test template" step: features are referenced as
# "./<id>" relative to .devcontainer/, so they must be copied in first.
test-template:                          ## Build one template and run its smoke tests (TEMPLATE=python)
	@test -n "$(TEMPLATE)" || { echo "usage: make test-template TEMPLATE=<name>"; exit 1; }
	@for d in test-templates/$(TEMPLATE)/.devcontainer/*/; do [ -d "$$d" ] && rm -rf "$$d"; done; true
	@rm -f test-templates/$(TEMPLATE)/.devcontainer/devcontainer-lock.json
	@# devcontainer up reuses a container with a matching id-label, which would
	@# silently skip the rebuild and test stale features.
	@docker ps -aq --filter "label=test=$(TEMPLATE)" | xargs -r docker rm -f >/dev/null 2>&1; true
	cp -r src/* test-templates/$(TEMPLATE)/.devcontainer/
	cp test-templates/shared/test-lib.sh test-templates/$(TEMPLATE)/
	npx --yes @devcontainers/cli up --workspace-folder "$(CURDIR)/test-templates/$(TEMPLATE)" \
		--id-label "test=$(TEMPLATE)"
	npx --yes @devcontainers/cli exec --workspace-folder "$(CURDIR)/test-templates/$(TEMPLATE)" \
		--id-label "test=$(TEMPLATE)" bash tests.sh

# Idempotency and failure-mode tests. Runs on the host via `docker exec -u 0`,
# because run-feature.sh needs root and `devcontainer exec` only ever gets `dev`.
# Requires the template's container to be running (make test-template first).
test-contract:                          ## Run contract tests against a running template (TEMPLATE=python)
	@test -n "$(TEMPLATE)" || { echo "usage: make test-contract TEMPLATE=<name>"; exit 1; }
	bash test-templates/shared/contract-tests.sh $(TEMPLATE)

test: check-contract                    ## Run everything: contract check, then all templates
	@for t in $(TEMPLATES); do \
		echo "===== $$t ====="; \
		$(MAKE) --no-print-directory test-template TEMPLATE=$$t || exit 1; \
		$(MAKE) --no-print-directory test-contract  TEMPLATE=$$t || exit 1; \
	done

clean:                                  ## Remove test containers and the copied feature trees
	@for t in $(TEMPLATES); do \
		docker ps -aq --filter "label=test=$$t" | xargs -r docker rm -f >/dev/null 2>&1; \
		for d in test-templates/$$t/.devcontainer/*/; do [ -d "$$d" ] && rm -rf "$$d"; done; \
		rm -f test-templates/$$t/.devcontainer/devcontainer-lock.json test-templates/$$t/test-lib.sh; \
	done; true
	@echo "Removed test containers and copied feature trees."

docs-dev:                               ## Run docs site locally in dev mode
	cd docs && bun --bun run dev
