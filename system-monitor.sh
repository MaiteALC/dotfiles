#!/bin/bash

CPU=$(top -bn1 | grep "%Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print $1}' )

RAM=$(free -h | awk '/Mem:/ {print $3 "/" $2}')

GPU="-"

if lspci | grep -iE 'vga|3d' | grep -iq nvidia; then
	GPU=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null)
else
	GPU="No Nvidia GPU detected" # Intel and AMD GPUs will be included in the future
fi

DISK=$(df / | awk 'NR==2 {sub(/%/,"",$5); print $5}')

TOOLTIP=$(printf "CPU: %s%%\nRAM: %s\nGPU: %s%%\nUsed Storage: %s%% " "$CPU" "$RAM" "$GPU" "$DISK")

jq --compact-output -n --arg text "" --arg tooltip "$TOOLTIP" --arg class "default" '{text: $text, tooltip: $tooltip, class: $class}'