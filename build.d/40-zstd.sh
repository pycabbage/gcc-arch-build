#!/bin/bash -e

. $(dirname $0)/env.sh

NAME=zstd
VERSION=1.5.5

PREFIX=""

tar axf $NAME-$VERSION.tar.gz
(
  cd $NAME-$VERSION
  PREFIX="" cmake -S build/cmake -B build-cmake -G Ninja # -DCMAKE_INSTALL_PREFIX=$BUILDER_PREFIX
  PREFIX="" cmake --build build-cmake -j $(noproc)
  PREFIX="" sudo cmake --install build-cmake
)
