#!/bin/bash

# Function to log messages with different priority levels and facilities
log_message() {
    priority=$1
    facility=$2
    description=$3
    logger -p $facility.$priority "<$priority> $description"
}

# Test each syslog priority level with different facilities
log_message emerg kern "Kernel messages"              # Output goes to /var/log/kern.log or similar
log_message alert user "User-level messages"          # Output goes to /var/log/user.log or similar
log_message crit mail "Mail system messages"          # Output goes to /var/log/mail.log or similar
log_message err daemon "System daemon messages"       # Output goes to /var/log/daemon.log or similar
log_message warning auth "Authentication messages"    # Output goes to /var/log/auth.log or similar
log_message notice syslog "Internal syslog messages"  # Output goes to /var/log/syslog or similar
log_message info lpr "Printer messages"               # Output goes to /var/log/lpr.log or similar
log_message debug news "Network news messages"        # Output goes to /var/log/news.log or similar
log_message emerg uucp "UUCP protocol messages"       # Output goes to /var/log/uucp.log or similar
log_message alert cron "Clock daemon messages"        # Output goes to /var/log/cron.log or similar
log_message crit authpriv "Authorization messages"    # Output goes to /var/log/authpriv.log or similar
log_message err ftp "FTP protocol messages"           # Output goes to /var/log/ftp.log or similar
log_message warning local0 "Custom local messages"    # Output goes to /var/log/local0.log or similar
log_message notice local1 "Custom local messages"     # Output goes to /var/log/local1.log or similar
log_message info local2 "Custom local messages"       # Output goes to /var/log/local2.log or similar
log_message debug local3 "Custom local messages"      # Output goes to /var/log/local3.log or similar
log_message emerg local4 "Custom local messages"      # Output goes to /var/log/local4.log or similar
log_message alert local5 "Custom local messages"      # Output goes to /var/log/local5.log or similar
log_message crit local6 "Custom local messages"       # Output goes to /var/log/local6.log or similar
log_message err local7 "Custom local messages"        # Output goes to /var/log/local7.log or similar
