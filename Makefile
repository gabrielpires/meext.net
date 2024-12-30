SHELL := /bin/bash
VM_SCRIPT_DIR := vms
VM_SCRIPT := $(VM_SCRIPT_DIR)/$(TARGET_VM).sh

.PHONY: check_vm create config start stop destroy

# Function to check TARGET_VM and confirm execution
check_vm:
ifndef TARGET_VM
	$(error TARGET_VM is not set. Please specify it like: make <action> TARGET_VM=<value>)
endif
	@if [ ! -f $(VM_SCRIPT) ]; then \
	    echo "Error: Script $(VM_SCRIPT) does not exist."; \
	    exit 1; \
	fi
	@read -p "Are you sure you want to execute $(VM_SCRIPT)? (yes/no): " CONFIRM && [ $$CONFIRM = "yes" ] || { echo "Cancelled."; exit 1; }

# Targets
create: check_vm
	$(VM_SCRIPT) $(TARGET_VM) create

config: check_vm
	$(VM_SCRIPT) $(TARGET_VM) config

start: check_vm
	$(VM_SCRIPT) $(TARGET_VM) start

stop: check_vm
	$(VM_SCRIPT) $(TARGET_VM) stop

destroy: check_vm
	$(VM_SCRIPT) $(TARGET_VM) destroy
