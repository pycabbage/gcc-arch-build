#!/bin/bash -e

apt-get update
apt-get install -y --no-install-recommends \
  build-essential \
  gawk texinfo libexpat1-dev  curl gnat gdc \
  gcc-multilib g++-multilib gfortran bison flex expect dejagnu m4 llvm sudo help2man libisl-dev automake autoconf file llvm-dev libclang-dev
