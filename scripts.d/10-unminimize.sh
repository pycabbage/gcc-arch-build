#!/bin/bash -e

DEBIAN_FRONTEND=noninteractive
UNMINIMIZE=$(which unminimize)

sed -E -i 's/^(read -p.+$)/# \1\nREPLY=y/' $UNMINIMIZE
sed -E -i 's/(apt-get upgrade)/\1 -y/' $UNMINIMIZE

$UNMINIMIZE

# apt install -y --no-install-recommends sudo
