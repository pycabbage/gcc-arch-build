#!/bin/bash -e

. $(dirname $0)/env.sh

NAME=binutils
VERSION=2.40

CONFIGURE_FLAGS=(
  --prefix=$PREFIX
  --target=$TARGET
  # --with-gmp=$BUILDER_PREFIX
  # --with-isl=$BUILDER_PREFIX
  # --with-mpfr=$BUILDER_PREFIX
  # --with-mpc=$BUILDER_PREFIX
  --enable-year2038
  --enable-libada
  --enable-libssp
  --enable-objc-gc
  --enable-vtable-verify
  --with-system-zlib
  --with-zstd
)

. $(dirname $0)/build.sh
