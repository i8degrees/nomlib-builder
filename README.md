---
created: 2026-05-19T16:26:40+05:00
author: Jeffrey Carpenter <1329364+i8degrees@users.noreply.github.com>
tags:
    - nomlib
    - cross-compile
    - dependencies
    - ttcards
    - docker
---

# nomlib-builder

This repository is derived from [joseluisq/rust-linux-darwin-builder][0] and
has been adapted for cross-compiling [nomlib][1] by leveraging the Docker
platform for streamling the build pipelines.

*WIP*

## usage

- clang from [Debian 13.4][10] for `amd64`
- `x86-64-apple-darwin` using [osxcross][] MacOSX 10.14 SDK
- Windows 10+ using `clang-cl` from [Debian 13.4][10] and the MSVCPP SDK

## related

[0]: https://github.com/joseluisq/rust-linux-darwin-builder.git
[1]: https://github.com/i8degrees/nomlib.git
[2]: https://github.com/i8degrees/ttcards.git
[10]: https://hub.docker.com/r/debian

