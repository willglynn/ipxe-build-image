# `ipxe-build-image`

A Docker image which builds [iPXE](http://www.ipxe.org). The image contains the required toolchain, an iPXE source checkout, and the results of `make bin/ipxe.kpxe bin/undionly.kpxe bin-x86_64-efi/ipxe.efi bin-x86_64-efi/snponly.efi`.

If you want one of those prebuilt build artifacts, you can extract it from the image:

```console
$ docker create --name build willglynn/ipxe-build-image
7398c0d6f48a35cd33d79e9d47cff15d07a7fa4b22338bf482c181cc2022e316
$ docker cp build:/ipxe/src/bin/undionly.kpxe .
$ docker rm build
```

If you want a custom build artifact, that's easy too:

```console
$ docker create --name build willglynn/ipxe-build-image \
  make bin/undionly.kpxe EMBED=/script.ipxe
94c48ee1c622fb3ef5faff71510940b47b6c36da5c426ff92833a5b57d8f6fa6
$ docker cp script.ipxe build:/
$ docker start -a ipxe
  [DEPS] image/embedded.c
  [BUILD] bin/embedded.o
  [AR] bin/blib.a
ar: creating bin/blib.a
  [VERSION] bin/version.undionly.kpxe.o
  [LD] bin/undionly.kpxe.tmp
  [BIN] bin/undionly.kpxe.bin
  [ZINFO] bin/undionly.kpxe.zinfo
  [ZBIN] bin/undionly.kpxe.zbin
  [FINISH] bin/undionly.kpxe
rm bin/version.undionly.kpxe.o bin/undionly.kpxe.zinfo bin/undionly.kpxe.bin bin/undionly.kpxe.zbin
$ docker cp build:/ipxe/src/bin/undionly.kpxe .
$ docker rm build
```

This is the full output: it built only `bin/embedded.o` and linked a new executable. The rest of the objects were compiled when the Docker image was built and can be reused for this custom build.
