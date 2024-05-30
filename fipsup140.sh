#!/bin/sh
# fipsup140.sh
#
# requires ubuntu pro 20.04



# need at least v. 27.0 to proceed
apt-cache policy ubuntu-advantage-tools | grep Installed

sudo apt update
sudo apt install ubuntu-advantage-tools

pro status | grep disabled

pro disable livepatch
pro enable fips   
                  # requires manual input :
                  # root@MurphyUPFips140:~# pro enable fips
                  # One moment, checking your subscription first
                  # This will install the FIPS packages. The Livepatch service will be unavailable.
                  # Warning: This action can take some time and cannot be undone.
                  # Are you sure? (y/N) y

reboot

# NOTE:  fips = 1
# root@MurphyUPFips140:~# cat /proc/cmdline
# BOOT_IMAGE=/boot/vmlinuz-5.4.0-1022-azure-fips root=PARTUUID=da8bf00d-e223-42d6-bfa0-c20c97033428 ro console=tty1 console=ttyS0 earlyprintk=ttyS0 nvme_core.io_timeout=240 fips=1 panic=-1

# pro enable fips-updates  # FIPS compliant crypto packages with stable security updates
