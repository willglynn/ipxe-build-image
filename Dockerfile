FROM alpine

# Install dependencies
RUN apk add --no-cache bash gcc make git perl musl-dev linux-headers xz-dev cdrkit

# Check out the specified iPXE version
ARG IPXE_VERSION=master
RUN mkdir /ipxe && \
  cd /ipxe && \
  git init && \
  git remote add origin https://git.ipxe.org/ipxe.git && \
  git fetch --depth 1 origin "$IPXE_VERISON" && \
  git checkout FETCH_HEAD
LABEL org.ipxe.version=$IPXE_VERSION

# Build some common targets to accelerate later builds
WORKDIR /ipxe/src
ARG JOBS=16
ARG TARGETS="bin/ipxe.kpxe bin/undionly.kpxe bin-x86_64-efi/ipxe.efi bin-x86_64-efi/snponly.efi"
RUN make -j"$JOBS" $COMMON_TARGETS
