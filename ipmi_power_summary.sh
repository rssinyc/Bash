#!/bin/bash

# Function to check if ipmitool is installed
check_ipmitool() {
    if ! command -v ipmitool &> /dev/null; then
        echo "Error: ipmitool is not installed. Please install it and try again."
        exit 1
    fi
}

# Function to gather power supply metrics
get_power_supplies() {
    echo "Power Supply Metrics:"
    local total_psu_power=0
    while IFS= read -r line; do
        echo "$line"
        power=$(echo "$line" | awk '{print $NF}' | grep -Eo '[0-9]+') # Extract power in Watts
        if [[ -n $power ]]; then
            total_psu_power=$((total_psu_power + power))
        fi
    done < <(ipmitool sdr type "Power Supply")
    echo "Total Power Supply Power: $total_psu_power W"
    echo ""
    echo "$total_psu_power" # Return total PSU power for summary
}

# Function to gather detailed power sensors
get_power_sensors() {
    echo "Power Sensor Metrics:"
    local total_sensor_power=0
    while IFS= read -r line; do
        echo "$line"
        power=$(echo "$line" | awk '{print $4}' | grep -Eo '[0-9]+') # Extract power in Watts
        if [[ -n $power ]]; then
            total_sensor_power=$((total_sensor_power + power))
        fi
    done < <(ipmitool sensor | grep -i 'power')
    echo "Total Sensor Power: $total_sensor_power W"
    echo ""
    echo "$total_sensor_power" # Return total sensor power for summary
}

# Function to gather DCMI power statistics
get_dcmi_power() {
    echo "DCMI Power Statistics:"
    if ipmitool dcmi power reading &> /dev/null; then
        current_power=$(ipmitool dcmi power reading | awk '/Current Power/ {print $NF}')
        echo "Current Power: $current_power W"
        echo ""
        echo "$current_power" # Return DCMI power for summary
    else
        echo "DCMI power statistics not supported on this system."
        echo ""
        echo "0" # Return 0 if DCMI not supported
    fi
}

# Ensure ipmitool is installed
check_ipmitool

# Collect power usage metrics
total_psu_power=$(get_power_supplies)
total_sensor_power=$(get_power_sensors)
dcmi_power=$(get_dcmi_power)

# Summarize total power usage
echo "Power Usage Summary:"
echo "--------------------------------"
echo "Power from Power Supplies: $total_psu_power W"
echo "Power from Sensors: $total_sensor_power W"
echo "Power from DCMI: $dcmi_power W"

# Determine the best estimate for total power usage
total_power=$((total_psu_power > total_sensor_power ? total_psu_power : total_sensor_power))
total_power=$((total_power > dcmi_power ? total_power : dcmi_power))

echo "Estimated Total Power Usage: $total_power W"
echo "--------------------------------"
