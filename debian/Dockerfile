ARG GOLANG_IMAGE=golang:1.15-buster
ARG BASE_IMAGE=buster:10

# The docker image to build the go binaries
FROM ${GOLANG_IMAGE} as mod-cache
ARG PKG
ARG GODIR
ARG GOPROXY

# Run as separate steps to enable docker image caching
COPY go.mod go.sum ./

ARG GOOS
ARG GOARCH
ARG GOPROXY
ARG GOPRIVATE
ENV GOOS=${GOOS:-linux} GOARCH=${GOARCH:-amd64}
ENV GOPROXY ${GOPROXY:-https://proxy.golang.org}
ENV GOPRIVATE ${GOPRIVATE:github.com/Infoblox-CTO}

RUN go mod download && go mod verify

FROM ${GOLANG_IMAGE} as build-cache
ARG GOOS
ARG GOARCH
ARG BUILD_FLAGS

WORKDIR /build
COPY --from=mod-cache /go/pkg/mod /go/pkg/mod/
COPY . .

ENV CGO_ENABLED=0 GOOS=${GOOS:-linux} GOARCH=${GOARCH:-amd64}
RUN go build ${BUILD_FLAGS}

FROM ${BASE_IMAGE} as runtime
COPY --from=build-cache /go/bin/* /go/bin/