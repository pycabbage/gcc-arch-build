#!/bin/bash -e

PREFIX=${PREFIX:-/opt/prefix}
ARCHIVE=${ARCHIVE:-/tmp/prefix.tar.zst}

tar acf $ARCHIVE $PREFIX
