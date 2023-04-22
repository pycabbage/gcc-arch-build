#!/bin/bash -e

. $(dirname $0)/env.sh

NAME=gcc
VERSION=12.2.0

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
)

FLAG_BUILD=all-gdb
POSTBUILDING="make all-target-libgcc -j$(nproc)"
FLAG_INSTALL=install-gdb
POSTINSTALLING="make install-target-libgcc"

# . $(dirname $0)/build.sh
tar axf $(ls $NAME-$VERSION.* | tail -n1)
(
  cd $NAME-$VERSION
  mkdir build
  cd build
  ../configure ${CONFIGURE_FLAGS[@]}
  make all-gdb -j$(nproc)
  make all-target-libgcc -j$(nproc)
  make install-gdb -j$(nproc)
  make install-target-libgcc
)
