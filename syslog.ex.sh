#!/bin/bash

# Function to log messages with different priority levels
log_message() {
    priority=$1
    description=$2
    logger -p local0.$priority "$description"
}

# Test each syslog priority level
log_message emerg "System is unusable"
log_message alert "Action must be taken immediately"
log_message crit "Critical condition"
log_message err "Non-critical error condition"
log_message warning "Warning condition"
log_message notice "Normal but significant event"
log_message info "Informational event"
log_message debug "Debugging-level message"
