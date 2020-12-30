PROJECT  := infoblox/buildtool
PROJECT_APLINE  := infoblox/buildtool-alpine
REV := $(shell git describe --always)

.PHONY: all clean test
all: clean test

ARCH:=debian alpine
WD:=$(shell pwd)

# Create the Docker image with the latest tag.
test: $(addprefix test-,$(ARCH))

test-%:
	cd $(shell mktemp -d) && \
	go mod init tmp && \
	docker build --label buildtool=test \
		--build-arg ENTRYPOINT=/go/bin/tests \
		-f $(WD)/$(*F)/Dockerfile -t $@:$(REV) $(WD)/tests
	docker run --rm $@:$(REV)

# latest-debian:
# 	docker build -t $(PROJECT):$@ buildtool


# latest-alpine:
# 	docker build -t $(PROJECT_APLINE)-3.9:1.12 buildtool-alpine

clean:
	-docker rmi $(shell docker images -q -f "label=buildtool=test")
