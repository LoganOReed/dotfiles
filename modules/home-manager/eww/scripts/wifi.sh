#!/bin/sh

if nmcli device status | grep -q "connected"; then
    icon=""
    ssid=(nmcli -g name connection show | head -1)
    status="Connected to ${ssid}"
else
    icon="睊"
    status="offline"
fi

echo "{\"icon\": \"${icon}\", \"status\": \"${status}\"}" 
