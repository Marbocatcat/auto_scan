#!/usr/bin/sh

# Automated Malware/Rootkit checker (Version 1.0) -- by Mar B. 
# A simple script that automates malware & rootkit definition updates and also \
# runs scans automatically.
# Fedora/Redhat Linux Systems. (May 25, 2019)
#
# For Fedora release 30 x86_64


# check if clamav is install and install if needed
rpm --quiet -qa | grep clamav || sudo dnf install clamav -y --quiet
rpm --quiet -qa | grep rkhunter || sudo dnf install rkhunter -y --quiet

# check for new definition then recursively scan /home directory for viruses
clam_av(){

sudo freshclam --quiet 
if [ $? -eq 0 ]; then
  # recursively check home folder and transfer logs when viruses are found
  sudo clamscan -i -r --quiet $HOME --log=/var/log/clamav/viruses.log
else
  exit 1
fi
}

# check for new rootkit definition then check for rootkits

rkhunter(){

sudo rkhunter --quiet --update 
if [ $? -eq 0 ] || [ $? -eq 2 ]; then
  sudo rkhunter --quiet --check --skip-keypress
else
  exit 1
fi
}

clam_av
rkhunter

echo "clam_av & rkhunter scan finished!" | touch /home/bobcat/scan.notice


