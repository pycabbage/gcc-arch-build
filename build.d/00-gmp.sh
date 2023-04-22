#!/bin/bash -e

. $(dirname $0)/env.sh

NAME=gmp
VERSION=6.2.1

CONFIGURE_FLAGS=(
  --prefix=$BUILDER_PREFIX
  --enable-assert
  --enable-cxx
)
POSTBUILDING="make check -j$(nproc)"
# FLAG_INSTALL=install-strip

. $(dirname $0)/build.sh
