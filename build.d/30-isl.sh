#!/bin/bash -e

. $(dirname $0)/env.sh

NAME=isl
VERSION=0.15

CONFIGURE_FLAGS=(
  --prefix=$BUILDER_PREFIX
  --with-gmp-prefix=$BUILDER_PREFIX
)
FLAG_INSTALL=install-strip

. $(dirname $0)/build.sh
