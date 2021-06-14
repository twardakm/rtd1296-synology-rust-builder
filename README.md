# RTD1296 Synology Rust Builder

## Overview

Prepares environment to build rust native binaries on Synology devices with RTD1296 CPU.

## Preparing the environment

Since this Docker build aims to provide cross-platform support, you need to have following packages installed:

* `binfmt-support`
* `qemu-user-static` (on Manjaro I had to install `binfmt-qemu-static-all-arch`)

and check if you have support for `linux/arm64`:

```bash
$ docker buildx inspect         
Name:   default
Driver: docker

Nodes:
Name:      default
Endpoint:  default
Status:    running
Platforms: linux/amd64, linux/386, linux/arm64, linux/riscv64, linux/ppc64le, linux/s390x, linux/arm/v7, linux/arm/v6
```

## Working with Docker

### Build the environment

```bash
$ docker buildx build -t rtd1296 --platform linux/arm64 .
[+] Building 117.2s (10/10) FINISHED
```

### Enter the environment interactively

```bash
$ docker run --platform linux/arm64 -it rtd1296 bash

root@fb4a0e6f8907:/opt/rtd1296-synology-rust-builder# uname -a
Linux fb4a0e6f8907 5.4.0-73-generic #82-Ubuntu SMP Wed Apr 14 17:39:42 UTC 2021 aarch64 GNU/Linux
```

### Build rust application and copy result to host machine

```bash
$ docker buildx build -t rtd1296 --platform linux/arm64 --target debug --output . .

$ file target/arm64v8/debug/rtd1296-synology-rust-builder 
target/arm64v8/debug/rtd1296-synology-rust-builder: ELF 64-bit LSB pie executable, ARM aarch64, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-aarch64.so.1, for GNU/Linux 3.7.0, BuildID[sha1]=ed918a0e45d00621a1e4a80b61172e86136c5e8d, with debug_info, not stripped
```

Now you can copy result file to your Synology NAS:

```bash
$ scp -P 5022 target/arm64v8/debug/rtd1296-synology-rust-builder <user>@<hostname>:~/dev/
```

and run it there:

```bash
$ ./rtd1296-synology-rust-builder 
Hello, world!
```