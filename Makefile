all: check readme

.PHONY: check
check:
	terraform init -backend=false && terraform validate

readme:
	terraform-docs markdown table --hide requirements --output-file README.md --output-mode inject ./