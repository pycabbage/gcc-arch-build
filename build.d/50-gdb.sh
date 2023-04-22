#!/bin/bash -e

. $(dirname $0)/env.sh

NAME=gdb
VERSION=13.1

CONFIGURE_FLAGS=(
  --prefix=$PREFIX
  --target=$TARGET
  --with-gmp=$BUILDER_PREFIX
  --with-isl=$BUILDER_PREFIX
  --with-mpfr=$BUILDER_PREFIX
  --with-mpc=$BUILDER_PREFIX
  --enable-year2038
  --enable-libada
  --enable-libssp
  --enable-objc-gc
  --enable-vtable-verify
  --with-system-zlib
  --with-zstd
)
BUILD_IN_SUBDIR=false
FLAG_BUILD=all-gdb
FLAG_INSTALL=install-gdb

. $(dirname $0)/build.sh
