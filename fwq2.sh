#!/bin/bash

# Function to add rich rule to allow the port
add_allow_rule() {
    local port=$1
    local zone=$2

    # We do not want to allow something that we are rejecting so we check if the reject rule already exists, if yes, delete it
    firewall-cmd --zone="$zone" --query-rich-rule="rule family='ipv4' port port='$port' protocol='tcp' reject" && \
    firewall-cmd --zone="$zone" --remove-rich-rule="rule family='ipv4' port port='$port' protocol='tcp' reject" --permanent

    # Add rich rule to allow the port
    firewall-cmd --zone="$zone" --add-rich-rule="rule family='ipv4' port port='$port' protocol='tcp' accept" --permanent
}

# Function to add rich rule to drop the port
add_drop_rule() {
    local port=$1
    local zone=$2

    # We do not want to allow something that we are rejecting so we check if the reject rule already exists, if yes, delete it
    firewall-cmd --zone="$zone" --query-rich-rule="rule family='ipv4' port port='$port' protocol='tcp' accept" && \
    firewall-cmd --zone="$zone" --remove-rich-rule="rule family='ipv4' port port='$port' protocol='tcp' accept" --permanent

    # Add rich rule to drop the port
    firewall-cmd --zone="$zone" --add-rich-rule="rule family='ipv4' port port='$port' protocol='tcp' reject" --permanent
}

# Function to reload firewalld
reload_firewalld() {
    systemctl reload firewalld
}

# Ask user for input
read -p "Enter port number: " port
read -p "Enter firewall zone: " zone
read -p "Enter action (allow/drop): " action

# Validate action
if [[ "$action" != "allow" && "$action" != "drop" ]]; then
    echo "Invalid action. Please enter either 'allow' or 'drop'."
    exit 1
fi

# Add or delete rule based on user input
if [[ "$action" == "allow" ]]; then
    add_allow_rule "$port" "$zone"
else
    add_drop_rule "$port" "$zone"
fi

# Reload firewalld
reload_firewalld
