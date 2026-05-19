REPOSITORY ?= i8degrees/nomlib-builder
TAG ?= 0.13.1

# AMD64 Tasks

amd64-build:
	docker build \
		-t $(REPOSITORY):$(TAG)-amd64 \
		--network=host \
		-f templates/amd64/base/Dockerfile .
.PHONY: amd64-build

amd64-run:
	@docker run --rm -it \
		-v $(PWD)/vendor:/vendor \
		-w /tmp/vendor \
			$(REPOSITORY):$(TAG)-amd64 \
				bash
.PHONY: amd64-run

amd64-test:
	@docker run --rm \
		-v $(PWD):/root/src \
		-w /root/src \
			$(REPOSITORY):$(TAG)-amd64 \
				bash -c 'set -eu; test-app'
.PHONY: amd64-test

amd64-build-libs:
	docker build \
		-t $(REPOSITORY):$(TAG)-amd64-libs \
		--network=host \
		-f templates/amd64/libs/Dockerfile .
.PHONY: amd64-build-libs

amd64-copy-libs:
	@docker run --rm -it \
		-v $(PWD)/vendor:/vendor \
		-w /tmp/vendor \
			$(REPOSITORY):$(TAG)-amd64-libs \
				bash -c 'if findmnt /vendor; then cp -av /tmp/vendor/* /vendor; fi'
.PHONY: amd64-run-libs

amd64-base-push:
	@docker build templates/amd64/base \
		-t $(REPOSITORY):$(TAG)-amd64 --push

amd64-libs-push:
	@docker build templates/amd64/libs \
		-t $(REPOSITORY):$(TAG)-amd64-libs --push

# Testing Tasks (inside the container)

test-all: test-app test-zlib test-openssl
.PHONY: test-all

test-app:
	@echo "Checking Debian version..."
	@cat /etc/debian_version
	@echo
	@echo "Testing cross-compiling application..."
	@rustc -vV
	@echo
	@cd tests/app \
\
		&& echo "Compiling application (linux-gnu x86_64)..." \
		&& cargo build -v --release --target x86_64-unknown-linux-gnu \
		&& if [ "$$(uname -m)" = "x86_64" ]; then \
			target/x86_64-unknown-linux-gnu/release/app-test; \
		fi \
		&& du -sh target/x86_64-unknown-linux-gnu/release/app-test \
		&& file target/x86_64-unknown-linux-gnu/release/app-test \
		&& echo \
\
		&& echo "Compiling application (linux-musl x86_64)..." \
		&& cargo build -v --release --target x86_64-unknown-linux-musl \
		&& if [ "$$(uname -m)" = "x86_64" ]; then \
			target/x86_64-unknown-linux-musl/release/app-test; \
		fi \
		&& du -sh target/x86_64-unknown-linux-musl/release/app-test \
		&& file target/x86_64-unknown-linux-musl/release/app-test \
		&& echo \
\
		&& echo "Cross-compiling application (apple-darwin x86_64)..." \
		&& cargo build -v --release --target x86_64-apple-darwin \
		&& du -sh target/x86_64-apple-darwin/release/app-test \
		&& file target/x86_64-apple-darwin/release/app-test \
		&& echo \
\
		&& echo "Cross-compiling application (linux-gnu aarch64)..." \
		&& cargo build -v --release --target aarch64-unknown-linux-gnu \
		&& if [ "$$(uname -m)" = "aarch64" ]; then \
			target/aarch64-unknown-linux-gnu/release/app-test; \
		fi \
		&& du -sh target/aarch64-unknown-linux-gnu/release/app-test \
		&& file target/aarch64-unknown-linux-gnu/release/app-test \
		&& echo \
\
		&& echo "Cross-compiling application (linux-musl aarch64)..." \
		&& cargo build -v --release --target aarch64-unknown-linux-musl \
		&& if [ "$$(uname -m)" = "aarch64" ]; then \
			target/aarch64-unknown-linux-musl/release/app-test; \
		fi \
		&& du -sh target/aarch64-unknown-linux-musl/release/app-test \
		&& file target/aarch64-unknown-linux-musl/release/app-test \
		&& echo \
\
		&& echo "Cross-compiling application (apple-darwin aarch64)..." \
		&& cargo build -v --release --target aarch64-apple-darwin \
		&& du -sh target/aarch64-apple-darwin/release/app-test \
		&& file target/aarch64-apple-darwin/release/app-test \
		&& echo
.ONESHELL: test-app

test-zlib:
	@echo "Checking Debian version..."
	@cat /etc/debian_version
	@echo
	@echo "Testing cross-compiling zlib application..."
	@rustc -vV
	@echo
	@cd tests/zlib \
\
		&& echo "Compiling application (linux-gnu x86_64)..." \
		&& cargo build -v --release --target x86_64-unknown-linux-gnu \
		&& if [ "$$(uname -m)" = "x86_64" ]; then
			target/x86_64-unknown-linux-gnu/release/zlib-test; \
		fi \
		&& du -sh target/x86_64-unknown-linux-gnu/release/zlib-test \
		&& file target/x86_64-unknown-linux-gnu/release/zlib-test \
		&& echo \
\
		&& echo "Compiling application (linux-musl x86_64)..." \
		&& cargo build -v --release --target x86_64-unknown-linux-musl \
		&& if [ "$$(uname -m)" = "x86_64" ]; then
			target/x86_64-unknown-linux-musl/release/zlib-test; \
		fi \
		&& du -sh target/x86_64-unknown-linux-musl/release/zlib-test \
		&& file target/x86_64-unknown-linux-musl/release/zlib-test \
		&& echo \
\
		&& echo "Cross-compiling application (apple-darwin x86_64)..." \
		&& CC=o64-clang CXX=o64-clang++ \
			cargo build -v --release --target x86_64-apple-darwin \
		&& du -sh target/x86_64-apple-darwin/release/zlib-test \
		&& file target/x86_64-apple-darwin/release/zlib-test \
		&& echo \
\
		&& echo "Cross-compiling application (linux-gnu aarch64)..." \
		&& CC=aarch64-linux-gnu-gcc \
			cargo build -v --release --target aarch64-unknown-linux-gnu \
		&& if [ "$$(uname -m)" = "aarch64" ]; then \
			target/aarch64-unknown-linux-gnu/release/zlib-test; \
		fi \
		&& du -sh target/aarch64-unknown-linux-gnu/release/zlib-test \
		&& file target/aarch64-unknown-linux-gnu/release/zlib-test \
		&& echo \
\
		&& echo "Cross-compiling application (linux-musl aarch64)..." \
		&& cargo build -v --release --target aarch64-unknown-linux-musl \
		&& if [ "$$(uname -m)" = "aarch64" ]; then \
			target/aarch64-unknown-linux-musl/release/zlib-test; \
		fi \
		&& du -sh target/aarch64-unknown-linux-musl/release/zlib-test \
		&& file target/aarch64-unknown-linux-musl/release/zlib-test \
		&& echo \
\
		&& echo "Cross-compiling application (apple-darwin aarch64)..." \
		&& CC=oa64-clang CXX=oa64-clang++ \
			cargo build -v --release --target aarch64-apple-darwin \
		&& du -sh target/aarch64-apple-darwin/release/zlib-test \
		&& file target/aarch64-apple-darwin/release/zlib-test \
		&& echo
.ONESHELL: test-zlib

test-openssl:
	@echo "Checking Debian version..."
	@cat /etc/debian_version
	@echo
	@echo "Testing cross-compiling openssl application..."
	@rustc -vV
	@echo
	@cd tests/openssl \
\
		&& echo "Compiling application (linux-gnu x86_64)..." \
		&& cargo build -v --release --target x86_64-unknown-linux-gnu \
		&& if [ "$$(uname -m)" = "x86_64" ]; then \
			target/x86_64-unknown-linux-gnu/release/openssl-test; \
		fi \
		&& du -sh target/x86_64-unknown-linux-gnu/release/openssl-test \
		&& file target/x86_64-unknown-linux-gnu/release/openssl-test \
		&& echo \
\
		&& echo "Cross-compiling application (linux-gnu aarch64)..." \
		&& CC=aarch64-linux-gnu-gcc \
			cargo build -v --release --target aarch64-unknown-linux-gnu \
		&& if [ "$$(uname -m)" = "aarch64" ]; then \
			target/aarch64-unknown-linux-gnu/release/openssl-test; \
		fi \
		&& du -sh target/aarch64-unknown-linux-gnu/release/openssl-test \
		&& file target/aarch64-unknown-linux-gnu/release/openssl-test \
		&& echo \
\
		&& echo "Compiling application (linux-musl x86_64)..." \
		&& OPENSSL_STATIC=1 \
			cargo build -v --release --target x86_64-unknown-linux-musl \
		&& if [ "$$(uname -m)" = "x86_64" ]; then \
			target/x86_64-unknown-linux-musl/release/openssl-test; \
		fi \
		&& du -sh target/x86_64-unknown-linux-musl/release/openssl-test \
		&& file target/x86_64-unknown-linux-musl/release/openssl-test \
		&& echo \
\
		&& echo "Cross-compiling application (apple-darwin x86_64)..." \
		&& OPENSSL_STATIC=1 \
			CC=o64-clang CXX=o64-clang++ \
				cargo build -v --release --target x86_64-apple-darwin \
		&& du -sh target/x86_64-apple-darwin/release/openssl-test \
		&& file target/x86_64-apple-darwin/release/openssl-test \
		&& echo \
\
		&& echo "Cross-compiling application (linux-musl aarch64)..." \
		&& OPENSSL_STATIC=1 \
			cargo build -v --release --target aarch64-unknown-linux-musl \
		&& if [ "$$(uname -m)" = "aarch64" ]; then \
			target/aarch64-unknown-linux-musl/release/openssl-test;
		fi \
		&& du -sh target/aarch64-unknown-linux-musl/release/openssl-test \
		&& file target/aarch64-unknown-linux-musl/release/openssl-test \
		&& echo \
\
		&& echo "Cross-compiling application (apple-darwin aarch64)..." \
		&& OPENSSL_STATIC=1 \
			CC=oa64-clang CXX=oa64-clang++ \
				cargo build -v --release --target aarch64-apple-darwin \
		&& du -sh target/aarch64-apple-darwin/release/openssl-test \
		&& file target/aarch64-apple-darwin/release/openssl-test \
		&& echo
.ONESHELL: test-openssl

# Use to build amd64 and other target images at the same time.
# WARNING! Will automatically push, since multi-platform images are not available locally.
# Use `REPOSITORY` arg to specify which container repository to push the images to.
buildx:
	docker run --privileged --rm tonistiigi/binfmt --install linux/amd64
	docker buildx create --name darwin-builder --driver docker-container --bootstrap
	docker buildx use darwin-builder
	docker buildx build \
		--platform linux/amd64 \
		--push \
		-t $(REPOSITORY):$(TAG) \
		-f Dockerfile .
.PHONY: buildx

run-debian:
	@docker run --rm -it \
		-v $(pwd)/templates:/templates \
		-w /templates \
	debian:13.4 bash
.PHONY: debian


