#!/bin/bash

# Check if powercap directory exists
if [ -d "/sys/class/powercap/intel-rapl" ]; then
    while true; do
        # Get the current timestamp
        current_time=$(date +"%Y-%m-%d %H:%M:%S")

        # Read initial energy value
        energy_uj_start=$(cat /sys/class/powercap/intel-rapl:0/energy_uj)
        
        # Set the time interval (in seconds)
        interval=1
        sleep $interval  # Wait for the interval
        
        # Read final energy value
        energy_uj_end=$(cat /sys/class/powercap/intel-rapl:0/energy_uj)

        # Calculate the power usage (Watts)
        energy_diff=$((energy_uj_end - energy_uj_start))  # in microjoules
        power_watts=$(echo "scale=6; $energy_diff / $interval / 1000000" | bc)  # Convert to Watts
        power_kilowatts=$(echo "scale=6; $power_watts / 1000" | bc) # Convert to Kilowatts

        # Output the current time and power usage with "kw" as a suffix
        echo "$current_time $power_kilowatts kw"
    done
else
    echo "Powercap interface not found. Make sure your system supports powercap."
fi
