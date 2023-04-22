#!/bin/bash -e

. $(dirname $0)/env.sh

NAME=mpfr
VERSION=4.2.0

CONFIGURE_FLAGS=(
  --prefix=$BUILDER_PREFIX
  --with-gmp=$BUILDER_PREFIX
  --enable-assert
  --enable-float128
  --enable-gmp-internals
)

. $(dirname $0)/build.sh
