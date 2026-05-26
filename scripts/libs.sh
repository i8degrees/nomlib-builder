#!/bin/bash

REPOSITORY=i8degrees/nomlib-builder
TAG=0.13.1
ARCH=amd64

  #-v nomlib-libs-v2:/dist \
docker run --rm -it \
  -v $(PWD)/vendor:/dist:rw
  -w /dist \
  "${REPOSITORY}:${TAG}-${ARCH}"-libs \
bash
