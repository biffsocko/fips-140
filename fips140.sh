#!/bin/sh

# *******************   NOT COMPLETE YET ***********************#

#################################
# TR Murphy
# fips140.sh
#
# This downloads and installs the
# necessary tools for fips-140 
# compliance on Debian Linux
#################################

# check to see if crypto-policies is installed
# if now .. install it
which fips-mode-setup  # this is dumb - i'll do better later on
if [ $? -eq 1 ]

  # see if our repository is in sources.list
  # if not - update sources.list
  grep " sid " /etc/apt/sources.list > /dev/null 2&1
  if [ $? -ne 0 ]
  then
    echo "deb http://ftp.de.debian.org/debian sid main"  >> /etc/apt/sources.list
  fi

  apt update
  apt install crypto-policies -y
fi

# install git - we'll probably need it at some point anyway
which git
if [ $? -eq 1 ]
then
  apt install git -y
fi


# check to see if memstrack is installed
# there isn't a debian package that contains this
# so - perhaps we'll make one later on
which memstrack
if [ $? -eq 1 ]
then
  cd /tmp
  # look - we needed git after all
  git clone https://github.com/ryncsn/memstrack.git
  
  cd memstrack
  make
  make install
fi

# install openssl if its not there already
apt install openssl


# figure out sha512 kernel module stuff here
#
