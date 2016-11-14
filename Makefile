PROJECT  := infoblox/buildtool
LATEST   := latest

.PHONY: all clean latest
all: latest


# Create the Docker image with the latest tag.
latest:
	docker build -t $(PROJECT):$@ $(LATEST)


clean:
	docker rmi -f $(PROJECT):$(LATEST)
