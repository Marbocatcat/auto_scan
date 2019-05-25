#!/usr/bin/sh

# Automated Malware/Rootkit checker (Version 1.0) -- by Mar B. 
# A simple script that automates malware & rootkit definition updates and also \
# runs scans automatically.
# Fedora/Redhat Linux Systems. (May 25, 2019)
#
# For Fedora release 30 x86_64


# check if clamav is install and install if needed
rpm -qa | grep clamav || sudo dnf install clamav -y
rpm -qa | grep rkhunter || sudo dnf install rkhunter -y

# check for new definition then recursively scan /home directory for viruses
clam_av():

freshclam 
if [ $? -eq 0 ]; then
  clamscan $HOME
  exit 0
else
  exit 1
fi

# check for new rootkit definition then check for rootkits

rkhunter():

sudo rkhunter --update 
if [ $? -eq 0 ] || [ $? -eq 2 ]; then
  sudo rkhunter --check --skip-keypress
  exit 0
else
  exit 1
fi

clam_av
rkhunter


