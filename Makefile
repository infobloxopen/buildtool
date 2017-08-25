PROJECT  := infoblox/buildtool
PROJECT_APLINE  := infoblox/buildtool-alpine

.PHONY: all clean latest clean-alpine latest-alpine
all: latest


# Create the Docker image with the latest tag.
latest:
	docker build -t $(PROJECT):$@ buildtool


clean:
	docker rmi -f $(PROJECT):latest


latest-alpine:
	docker build -t $(PROJECT_APLINE):latest buildtool-alpine


clean-alpine:
	docker rmi -f $(PROJECT_APLINE):latest
