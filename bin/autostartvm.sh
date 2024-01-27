#!/bin/bash

# Global variables
DESIRED_VMNAME="win11preview"
DESIRED_WORKSPACE=3

# Start the VirtualBox VM
VBoxManage startvm $DESIRED_VMNAME

# Wait for the VM window to appear (adjust sleep duration as needed)
sleep 1

# Find the window ID of the VM window
VM_WINDOW_ID=$(wmctrl -l | grep $DESIRED_VMNAME | awk '{print $1}')

# Move the VM window to the desired workspace
wmctrl -i -r $VM_WINDOW_ID -t $DESIRED_WORKSPACE
