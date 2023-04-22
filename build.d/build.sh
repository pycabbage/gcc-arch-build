#!/bin/bash -e

NAME=${NAME}
VERSION=${VERSION}
PREFIX=${PREFIX:-/opt/prefix}
BUILDER_PREFIX=${BUILDER_PREFIX:-/opt/builder-prefix}
BUILD_IN_SUBDIR=${BUILD_IN_SUBDIR:-true}

tar axf $(ls $NAME-$VERSION.* | tail -n1)

(
  cd $NAME-$VERSION

  BASE=$(pwd)
  if "${BUILD_IN_SUBDIR}"; then
    mkdir build
    cd build
  fi

  ${BASE}/configure ${CONFIGURE_FLAGS[@]}
  make ${FLAG_BUILD:-} -j$(nproc)
  $POSTBUILDING
  make ${FLAG_INSTALL:-install}
  $POSTINSTALLING
)
