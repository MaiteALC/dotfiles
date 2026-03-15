#!/bin/bash

read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat

total1=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle1=$idle

RAM=$(free -h | awk '/Mem:/ {print $3 "/" $2}')

DISK=$(df / | awk 'NR==2 {print $5}')

NVIDIA_PCI_DIR=$(ls -d /sys/bus/pci/drivers/nvidia/0000:* 2>/dev/null | head -n 1)

if [ -n "$NVIDIA_PCI_DIR" ]; then
    GPU_STATUS=$(cat "$NVIDIA_PCI_DIR/power/runtime_status" 2>/dev/null)
    
    if [ "$GPU_STATUS" = "suspended" ]; then
        GPU="Suspended"
    else
        GPU="$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null)%"
        
        [ -z "$GPU" ] && GPU="-" 
    fi
else
    GPU="-"
fi

sleep 0.4

read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat

total2=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle2=$idle

total_diff=$((total2 - total1))
idle_diff=$((idle2 - idle1))

CPU=$(awk "BEGIN {print int(100 * ($total_diff - $idle_diff) / $total_diff)}")

TOOLTIP=$(printf " <b>CPU:</b> %s%% \n <b>RAM:</b> %s \n <b>GPU:</b> %s \n <b>Used Storage:</b> %s " "$CPU" "$RAM" "$GPU" "$DISK")

jq --compact-output -n --arg text "" --arg tooltip "$TOOLTIP" --arg class "default" '{text: $text, tooltip: $tooltip, class: $class}'