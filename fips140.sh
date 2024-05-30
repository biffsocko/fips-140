#!/bin/sh
#################################
# TR Murphy
# fips140.sh
#
# This downloads and installs the
# necessary tools for fips-140 
# compliance on Debian Linux
#
# https://manpages.debian.org/bookworm/openssl/fips_config.5ssl.en.html
# https://manpages.debian.org/bookworm/openssl/fips_module.7ssl.en.html
# https://manpages.debian.org/unstable/crypto-policies/fips-mode-setup.8.en.html
# https://help.deepsecurity.trendmicro.com/azure/fips-140.html
# https://complianceascode.github.io/content-pages/guides/ssg-debian12-guide-anssi_bp28_intermediary.html
# https://www.open-scap.org/security-policies/scap-security-guide/
# https://www.open-scap.org/security-policies/scap-security-guide/#install
#################################

# check to see if crypto-policies is installed
# if now .. install it
which fips-mode-setup  # this is dumb - i'll do better later on
if [ $? -eq 1 ]

  # see if our repository is in sources.list
  # if not - update sources.list
  grep " sid " /etc/apt/sources.list > /dev/null 2>&1
  if [ $? -ne 0 ]
  then
    echo "deb http://ftp.de.debian.org/debian sid main"  >> /etc/apt/sources.list
  fi

  apt update
  apt -y install crypto-policies git gcc make dracut ncurses-dev openssl libssl-dev
  apt -y upgrade openssl
fi

# install git - we'll probably need it at some point anyway
#which git
#if [ $? -eq 1 ]
#then
#  apt install git -y
#fi


# check to see if memstrack is installed
# there isn't a debian package that contains this
# so - perhaps we'll make one later on
#which memstrack
#if [ $? -eq 1 ]
#then
cd /tmp
  # look - we needed git after all
git clone https://github.com/ryncsn/memstrack.git
  
#  apt -y  install gcc
#  apt -y install make
#  apt -y install ncurses-dev
#  apt -y install dracut
  cd memstrack
  make
  make install
fi

# install openssl if its not there already
apt install openssl


# figure out sha512 kernel module stuff here
#
