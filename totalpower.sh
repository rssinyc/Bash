#!/bin/bash

# Function to get CPU power usage via RAPL (Intel powercap interface)
get_cpu_power() {
    if [ -d "/sys/class/powercap/intel-rapl" ]; then
        # Read initial energy value
        energy_uj_start=$(cat /sys/class/powercap/intel-rapl:0/energy_uj)
        sleep 1  # Wait for 1 second
        # Read final energy value
        energy_uj_end=$(cat /sys/class/powercap/intel-rapl:0/energy_uj)
        
        # Calculate the power usage (Watts)
        energy_diff=$((energy_uj_end - energy_uj_start))  # in microjoules
        power_watts=$(echo "scale=2; $energy_diff / 1000000" | bc)  # Convert to Watts, rounded to 2 decimal places
        echo "$power_watts"
    else
        echo "0"
    fi
}

# Function to get GPU power usage using nvidia-smi (if an NVIDIA GPU is present)
get_gpu_power() {
    if command -v nvidia-smi &>/dev/null; then
        gpu_power=$(nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits)
        if [ -z "$gpu_power" ]; then
            echo "0"
        else
            echo "$gpu_power"
        fi
    else
        echo "0"
    fi
}

# Function to get AC power usage (via upower or ACPI)
get_ac_power() {
    if [ -e "/org/freedesktop/UPower/devices/line_power_AC" ]; then
        # Extract the power value (ignoring extra text, clean only numeric value)
        ac_power=$(upower -i /org/freedesktop/UPower/devices/line_power_AC | grep "power" | awk '{print $2}' | sed 's/[^0-9.]//g')
        # If no power data is found, return 0
        if [ -z "$ac_power" ]; then
            echo "0"
        else
            echo "$ac_power"
        fi
    else
        echo "0"
    fi
}

# Function to get battery power usage (if available)
get_battery_power() {
    if [ -e "/org/freedesktop/UPower/devices/battery_BAT0" ]; then
        # Extract the energy value (ignoring extra characters and new lines)
        battery_power=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep "energy" | awk '{print $2}' | sed 's/[^0-9.]//g')
        # If no battery power data is found, return 0
        if [ -z "$battery_power" ]; then
            echo "0"
        else
            echo "$battery_power"
        fi
    else
        echo "0"
    fi
}

# Run in a while loop
while true; do
    # Get the current timestamp
    current_time=$(date +"%Y-%m-%d %H:%M:%S")

    # Gather power consumption data from various sources
    cpu_power=$(get_cpu_power)
    gpu_power=$(get_gpu_power)
    ac_power=$(get_ac_power)
    battery_power=$(get_battery_power)

    # Check for and clean up any unwanted outputs (like multiple lines)
    cpu_power_clean=$(echo "$cpu_power" | grep -oE '[0-9]+\.[0-9]+')
    gpu_power_clean=$(echo "$gpu_power" | grep -oE '[0-9]+\.[0-9]+')
    ac_power_clean=$(echo "$ac_power" | grep -oE '[0-9]+\.[0-9]+')
    battery_power_clean=$(echo "$battery_power" | grep -oE '[0-9]+\.[0-9]+')

    # If any of the values are missing or empty, default them to 0
    cpu_power_clean=${cpu_power_clean:-0}
    gpu_power_clean=${gpu_power_clean:-0}
    ac_power_clean=${ac_power_clean:-0}
    battery_power_clean=${battery_power_clean:-0}

    # Calculate total power usage by summing up all components
    total_power=$(echo "scale=2; $cpu_power_clean + $gpu_power_clean + $ac_power_clean + $battery_power_clean" | bc)

    # Clean output: only print relevant information
    echo "$current_time CPU Power: $cpu_power_clean W"
    echo "$current_time GPU Power: $gpu_power_clean W"
    echo "$current_time AC Power: $ac_power_clean W"
    echo "$current_time Battery Power: $battery_power_clean W"
    echo "$current_time Total Power Usage: $total_power W"

    # Sleep for a short interval before next reading (e.g., 1 second)
    sleep 1
done
