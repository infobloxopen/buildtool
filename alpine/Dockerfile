ARG GOLANG_IMAGE=golang:1.15.6-alpine
ARG BASE_IMAGE=alpine:3

# The docker image to build the go binaries
FROM ${GOLANG_IMAGE} as mod-cache
ARG WORKDIR
ARG PKG
ARG GODIR
ARG GOPROXY

# GOPATH can not be WORKDIR
WORKDIR ${WORKDIR:-/app}
# Run as separate steps to enable docker image caching
COPY go.mod go.sum ./

ARG GOPATH
ARG GOOS
ARG GOARCH
ARG GOPROXY
ARG GOPRIVATE

ENV GOPATH=${GOPATH:-/go}
ENV GOOS=${GOOS:-linux} GOARCH=${GOARCH:-amd64}
ENV GOPROXY ${GOPROXY:-https://proxy.golang.org}
ENV GOPRIVATE ${GOPRIVATE:-github.com/Infoblox-CTO}

RUN go mod download && go mod verify

FROM ${GOLANG_IMAGE} as build-cache
ARG GOOS
ARG GOARCH
ARG BUILD_FLAGS

WORKDIR ${WORKDIR:-/app}
COPY --from=mod-cache /go/pkg/mod /go/pkg/mod/
COPY . .

ENV CGO_ENABLED=0 GOOS=${GOOS:-linux} GOARCH=${GOARCH:-amd64}
RUN go install ${BUILD_FLAGS}

FROM ${BASE_IMAGE} as runtime
ARG ENTRYPOINT
ENV ENTRYPOINT ${ENTRYPOINT:-/go/bin/app}

# Install updated CA Certs
RUN apk add --no-cache bash curl ca-certificates && update-ca-certificates

ENTRYPOINT ${ENTRYPOINT}
COPY --from=build-cache /go/bin/ /go/bin/