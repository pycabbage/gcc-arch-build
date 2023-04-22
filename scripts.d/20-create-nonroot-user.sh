#!/bin/bash -e

useradd --comment "" --groups sudo --shell /bin/bash --create-home --groups sudo $1
if [ ! -d /etc/sudoers.d ]; then
  mkdir /etc/sudoers.d -p
fi
echo -e "$1\tALL=NOPASSWD:\tALL" > /etc/sudoers.d/$1
