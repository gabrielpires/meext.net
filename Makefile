SHELL := /bin/bash
VM_SCRIPT_DIR := vms
VM_SCRIPT := $(VM_SCRIPT_DIR)/$(VM).sh

.PHONY: check_vm create config start stop destroy

# Function to check VM and confirm execution
check_vm:
ifndef VM
	$(error VM is not set. Please specify it like: make <action> VM=<value>)
endif
	@if [ ! -f $(VM_SCRIPT) ]; then \
	    echo "Error: Script $(VM_SCRIPT) does not exist."; \
	    exit 1; \
	fi
	@read -p "Are you sure you want to execute $(VM_SCRIPT)? (yes/no): " CONFIRM && [ $$CONFIRM = "yes" ] || { echo "Cancelled."; exit 1; }

# Targets
create: check_vm
	$(VM_SCRIPT) $(VM) create

config: check_vm
	$(VM_SCRIPT) $(VM) config

start: check_vm
	$(VM_SCRIPT) $(VM) start

stop: check_vm
	$(VM_SCRIPT) $(VM) stop

destroy: check_vm
	$(VM_SCRIPT) $(VM) destroy
