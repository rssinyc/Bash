#!/usr/bin/bash

# Script to reject a list of ports by adding the list as rich rules w/ firewalld

# Define variables
FIREWALL_PORTS=(8080 9090)
ZONE="public"

# Add drop rules for specified ports
for port in "${FIREWALL_PORTS[@]}"; do
    firewall-cmd --zone="$ZONE" --add-rich-rule='rule family="ipv4" port port="'$port'" protocol="tcp" reject' --permanent
done

# Reload firewalld
systemctl reload firewalld
