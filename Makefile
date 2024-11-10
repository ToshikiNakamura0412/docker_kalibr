.PHONY: help setup build

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "  targets:"
	@printf "    setup \e[32m[default]\e[m  create directories for mount\n"
	@echo "    build            build docker image"

setup:
	@if [ -d $(HOME)/data ]; then echo "$(HOME)/data already exists"; else mkdir -v $(HOME)/data; echo "Created $(HOME)/data"; fi

build:
	@docker compose build
