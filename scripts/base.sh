#!/bin/bash

REPOSITORY=i8degrees/nomlib-builder
TAG=0.13.1
ARCH=amd64

docker run --rm -it \
  -v nomlib-libs-v2:/dist \
  -w /dist \
  "${REPOSITORY}:${TAG}-${ARCH}" \
bash
