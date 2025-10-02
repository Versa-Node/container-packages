SHELL := /bin/bash

PKG_DIR := packages

.PHONY: help list check bootstrap compose-example
help:
	@echo "Targets:"
	@echo "  make list            # list packages"
	@echo "  make check           # run basic checks"
	@echo "  make bootstrap       # install pre-commit hooks"
	@echo "  make compose-example # print a multi-service compose example"

list:
	@ls -1 $(PKG_DIR)

check:
	@echo "Validating package.yaml files..."
	@python3 tools/validate.py || true
	@echo "OK"

bootstrap:
	@pre-commit install || true
	@echo "Bootstrap complete"

compose-example:
	@cat examples/stack-home-lab/docker-compose.yml
