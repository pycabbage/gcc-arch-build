FROM ubuntu:jammy
ARG NONROOT_USERNAME=builder

RUN \
  mkdir /opt/prefix /opt/builder-prefix /tmp/scripts.d -p && \
  rm -f /etc/apt/apt.conf.d/docker-clean && \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

ENV DEBIAN_FRONTEND=noninteractive
RUN --mount=type=bind,source=scripts.d/00-install-packages.sh,target=/tmp/scripts.d/00-install-packages.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  /tmp/scripts.d/00-install-packages.sh
RUN --mount=type=bind,source=scripts.d/10-unminimize.sh,target=/tmp/scripts.d/10-unminimize.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  /tmp/scripts.d/10-unminimize.sh
RUN --mount=type=bind,source=scripts.d/20-create-nonroot-user.sh,target=/tmp/scripts.d/20-create-nonroot-user.sh \
  /tmp/scripts.d/20-create-nonroot-user.sh ${NONROOT_USERNAME} && \
  chown ${NONROOT_USERNAME} /opt/prefix /opt/builder-prefix && \
  chmod 755 /opt/prefix /opt/builder-prefix

USER ${NONROOT_USERNAME}

COPY --chown=${NONROOT_USERNAME} cache /tmp/cache
ENV PATH=/opt/prefix/bin:/opt/builder-prefix/bin:$PATH

WORKDIR /tmp/cache
ARG TARGET=i686-linux-gnu

COPY --chown=${NONROOT_USERNAME} build.d/build.sh /tmp/build.d/build.sh
COPY --chown=${NONROOT_USERNAME} build.d/env.sh /tmp/build.d/env.sh

RUN --mount=type=bind,source=build.d/00-gmp.sh,target=/tmp/build.d/00-gmp.sh \
  /tmp/build.d/00-gmp.sh
RUN --mount=type=bind,source=build.d/10-mpfr.sh,target=/tmp/build.d/10-mpfr.sh \
  /tmp/build.d/10-mpfr.sh
RUN --mount=type=bind,source=build.d/20-mpc.sh,target=/tmp/build.d/20-mpc.sh \
  /tmp/build.d/20-mpc.sh
RUN --mount=type=bind,source=build.d/30-isl.sh,target=/tmp/build.d/30-isl.sh \
  /tmp/build.d/30-isl.sh
RUN --mount=type=bind,source=build.d/40-zstd.sh,target=/tmp/build.d/40-zstd.sh \
  /tmp/build.d/40-zstd.sh
RUN --mount=type=bind,source=build.d/50-binutils.sh,target=/tmp/build.d/50-binutils.sh \
  /tmp/build.d/50-binutils.sh
RUN --mount=type=bind,source=build.d/60-gdb.sh,target=/tmp/build.d/60-gdb.sh \
  /tmp/build.d/60-gdb.sh
RUN --mount=type=bind,source=build.d/70-gcc.sh,target=/tmp/build.d/70-gcc.sh \
  /tmp/build.d/70-gcc.sh

# export prefix
USER root
RUN --mount=type=bind,source=output,target=/opt/mount,rw \
  --mount=type=bind,source=scripts.d/90-compress-prefix.sh,target=/tmp/scripts.d/90-compress-prefix.sh \
  ARCHIVE=/tmp/prefix.tar.zst \
  /tmp/scripts.d/90-compress-prefix.sh && \
  cp $ARCHIVE /opt/mount/ && \
  ls -lah /opt/prefix /opt/mount

USER ${NONROOT_USERNAME}
ENV color_prompt=yes
