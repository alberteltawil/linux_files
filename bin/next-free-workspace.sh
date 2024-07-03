#!/bin/bash

# Find the next available workspace number
next_workspace=$(i3-msg -t get_workspaces | jq '[.[] | .num] | max + 1')

# Move the focused container to the next available workspace
i3-msg "move to workspace $next_workspace"

# Switch to the new workspace
i3-msg "workspace $next_workspace"
