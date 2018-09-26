# Collection of Docker images to compile the Go projects

This repository provides the set of the Docker images used to compile the Go projects.

## Build

The build of the Docker image require the [docker](https://docs.docker.com/engine/installation/)
engine and the ```make``` utility as pre-requisites. As the requirements are satisfied, use the
following command to compile the ```latest``` version of the Docker image:
```sh
make latest
```

## Usage

To compile the Go binary using one of the provided tools, you could start with the following
command:
```sh
docker run --rm -v $(pwd):/go/src/${project} \
    infoblox/${buildtool-name}:latest go build -o binary
```
Where,
```project``` variable defines the Go project;
```buildtool-name``` variable defines build tool Docker image name (e.g. buildtool, buildtool-alpine).
