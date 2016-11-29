PROJECT  := infoblox/buildtool

.PHONY: all clean latest
all: latest


# Create the Docker image with the latest tag.
latest:
	docker build -t $(PROJECT):$@ buildtool


clean:
	docker rmi -f $(PROJECT):latest
