#!/bin/bash

# Log the start time
echo "$(date): Starting system update..." >> /var/log/system-update.log

# Update and upgrade the system
apt update && apt upgrade -y >> /var/log/system-update.log 2>&1

# Log the completion time
echo "$(date): System update completed." >> /var/log/system-update.log
