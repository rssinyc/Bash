#!/bin/bash

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Function to extract and normalize routing table information
extract_normalized_routing_table() {
    echo "Normalized routing table for $1:"
    case "$1" in
        "Red Hat 6" | "Red Hat 8")
            route -n | awk '{print $1,$2,$3,$4,$NF}'
            ;;
        "Ubuntu")
            ip route show | awk '{print $1,$3,$5}'
            ;;
        *)
            echo "Unsupported distribution"
            exit 1
            ;;
    esac
}

# Clear the screen
clear

# Detect Linux distribution
if [[ -f /etc/redhat-release ]]; then
    version=$(grep -oP 'release \K\d' /etc/redhat-release)
    case "$version" in
        6)
            extract_normalized_routing_table "Red Hat 6"
            ;;
        8)
            extract_normalized_routing_table "Red Hat 8"
            ;;
        *)
            echo "Unsupported Red Hat version"
            exit 1
            ;;
    esac
elif [[ -f /etc/lsb-release ]]; then
    distribution=$(grep -oP 'DISTRIB_ID=\K\w+' /etc/lsb-release)
    if [[ "$distribution" == "Ubuntu" ]]; then
        extract_normalized_routing_table "Ubuntu"
    else
        echo "Unsupported distribution"
        exit 1
    fi
else
    echo "Unsupported distribution"
    exit 1
fi

exit 0
