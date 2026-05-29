# syntax=docker/dockerfile:1

REPOSITORY ?= i8degrees/nomlib-builder
TAG ?= 0.13.1

INSTALL_PREFIX ?= /app/vendor
INSTALL_HOST ?= linux
CPU_CORES="$(($(nproc)-1))"

# AMD64 Tasks

amd64-base:
	docker build \
		-t $(REPOSITORY):$(TAG)-amd64 \
		--network=host \
		--push \
		--build-arg CPU_CORES=${CPU_CORES} \
		templates/amd64/base
.PHONY: amd64-base

amd64-run:
	@docker run --rm -it \
		-v $(PWD)/dist/usr/local:/dist \
		-w /tmp/vendor \
		$(REPOSITORY):$(TAG)-amd64 \
				bash
.PHONY: amd64-run

# TODO(JEFF): After a successful build, we need the targets `amd64-copy-libs` and 
# `amd64-build-libs-volume` to be ran
amd64-libs:
	docker build \
		-t $(REPOSITORY):$(TAG)-amd64-libs \
		--network=host \
		--build-arg CPU_CORES=${CPU_CORES} \
		--push \
		templates/amd64/libs

amd64-windows:
	docker build \
		-t $(REPOSITORY):$(TAG)-amd64-windows \
		--network=host \
		--build-arg CPU_CORES=${CPU_CORES} \
	templates/amd64/windows --push

amd64-macos:
	docker build \
		-t $(REPOSITORY):$(TAG)-amd64-macos \
		--network=host \
		--build-arg CPU_CORES=${CPU_CORES} \
	templates/amd64/macos --push
.PHONY: windows

amd64-copy-libs-local:
	@rm -rf "$(PWD)/vendor" && mkdir -p "$(PWD)/vendor"
	@docker run --rm -it \
		-v $(PWD)/vendor:/dist \
		-w "${INSTALL_PREFIX}" \
		$(REPOSITORY):$(TAG)-amd64-libs \
				bash -c 'if findmnt /dist; then rsync -avc ${INSTALL_PREFIX}/* /dist; fi'
	@docker run --rm -it \
		-v $(PWD)/vendor:/dist \
		-w "${INSTALL_PREFIX}" \
		$(REPOSITORY):$(TAG)-amd64-windows \
				bash -c 'if findmnt /dist; then rsync -avc ${INSTALL_PREFIX}/* /dist; fi'
	@docker run --rm -it \
		-v $(PWD)/vendor:/dist \
		-w "${INSTALL_PREFIX}" \
		$(REPOSITORY):$(TAG)-amd64-macos \
				bash -c 'if findmnt /dist; then rsync -avc ${INSTALL_PREFIX}/* /dist; fi'

amd64-copy-libs-volume:
	@docker volume rm nomlib-libs && docker volume create nomlib-libs
	# linux
	@docker run --rm -it \
		-v nomlib-libs:/dist \
		-w "${INSTALL_PREFIX}" \
		$(REPOSITORY):$(TAG)-amd64-libs \
				bash -c 'if findmnt /dist; then rsync --exclude=html/* -avc ${INSTALL_PREFIX}/* /dist; fi'
	#@docker volume rm nomlib-libs-windows && docker volume create nomlib-libs-windows
	# windows
	@docker run --rm -it \
		-v nomlib-libs:/dist \
		-w "${INSTALL_PREFIX}" \
		$(REPOSITORY):$(TAG)-amd64-windows \
				bash -c 'if findmnt /dist; then rsync -avc ${INSTALL_PREFIX}/* /dist; fi'
	# MacOSX
	#@docker run --rm -it \
		#-v nomlib-libs:/dist \
		#-w "${INSTALL_PREFIX}" \
		#$(REPOSITORY):$(TAG)-amd64-macos \
				#bash -c 'if findmnt /dist; then rsync -avc ${INSTALL_PREFIX}/* /dist; fi'

# amd64-run-libs-v2
amd64-run-libs:
	@docker run --rm -it \
		-v nomlib-libs:${INSTALL_PREFIX} \
		-w  "${INSTALL_PREFIX}" \
		$(REPOSITORY):$(TAG)-amd64-libs \
			bash

# Testing Tasks (inside the container)

test-all: test-app
.PHONY: test-all

test-app:
	@echo "Checking Debian version..."
	@cat /etc/debian_version
	@echo
	@echo "Testing cross-compiling application..."
	@clang++ --version
	@echo \
  \
	\
		&& echo "Compiling application (linux-gnu x86_64)..." \
		&& echo "Cross-compiling application (apple-darwin x86_64)..." \
		&& echo "Cross-compiling application (linux-gnu aarch64)..." \
		&& echo "Cross-compiling application (apple-darwin aarch64)..." \
		&& echo
.ONESHELL: test-app

# Use to build amd64 and other target images at the same time.
# WARNING! Will automatically push, since multi-platform images are not available locally.
# Use `REPOSITORY` arg to specify which container repository to push the images to.
buildx:
	#docker run --privileged --rm tonistiigi/binfmt --install linux/amd64
	docker run --rm tonistiigi/binfmt --install linux/amd64
	docker buildx create --name nomlib-builder --driver docker-container --bootstrap
	docker buildx use nomlib-builder
	docker buildx build \
		--platform linux/amd64 \
		--push \
		-t $(REPOSITORY):$(TAG)-amd64 \
		-f templates/amd64/base/Dockerfile .
.PHONY: buildx

run-debian:
	@docker run --rm -it \
		-v $(PWD)/templates:/templates \
		-w /templates \
	debian:13.4 bash
.PHONY: debian


