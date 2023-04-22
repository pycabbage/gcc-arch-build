FROM ubuntu:jammy
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install build-essential -y --no-install-recommends
RUN apt-get install gawk texinfo libexpat1-dev libgmp-dev curl gnat gdc -y --no-install-recommends
RUN apt-get install gcc-multilib g++-multilib gfortran bison flex expect dejagnu m4 llvm -y --no-install-recommends

COPY cache /tmp/cache

RUN ls /tmp/cache -lah
RUN mkdir /opt/prefix -p
ENV PATH=/opt/prefix/bin:$PATH

WORKDIR /tmp/cache
RUN tar axf gdb-13.1.tar.xz
WORKDIR /tmp/cache/gdb-13.1
RUN ./configure --prefix=/opt/prefix
RUN make -j$(($(nproc)*4))
RUN make install

# # PATH=/opt/prefix/bin:$PATH
# WORKDIR /tmp/cache
# RUN tar axf gcc-12.2.0.tar.xz
# WORKDIR /tmp/cache/gcc-12.2.0
# RUN ./contrib/download_prerequisites
# RUN mkdir build
# WORKDIR /tmp/cache/gcc-12.2.0/build
# # --enable-languages=c,c++ 
# RUN ../configure --prefix=/opt/prefix --enable-libada --enable-libssp --enable-objc-gc --enable-vtable-verify
# RUN make -j$(($(nproc)*4))
# RUN make bootstrap
# RUN make install

# export prefix
RUN --mount=type=bind,source=output,target=/opt/mount,rw \
  cp -r /opt/prefix /opt/mount/
