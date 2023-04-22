#!/bin/bash -e

export PREFIX=${PREFIX:-/opt/prefix}
export BUILDER_PREFIX=${BUILDER_PREFIX:-/opt/builder-prefix}
export PATH=$PREFIX/bin:$BUILDER_PREFIX/bin:$PATH
