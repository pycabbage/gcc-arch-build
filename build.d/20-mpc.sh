#!/bin/bash -e

. $(dirname $0)/env.sh

NAME=mpc
VERSION=1.3.1

CONFIGURE_FLAGS=(
  --prefix=$BUILDER_PREFIX
  --with-gmp=$BUILDER_PREFIX
  --with-mpfr=$BUILDER_PREFIX
  --enable-valgrind-tests
)

. $(dirname $0)/build.sh
