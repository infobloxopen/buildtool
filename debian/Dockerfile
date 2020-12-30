ARG GOLANG_IMAGE=golang:1.15-buster
ARG BASE_IMAGE=debian:10-slim

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

# Copy and update CA Certificates from build container
COPY --from=build-cache /usr/share/ca-certificates /usr/share/ca-certificates
COPY --from=build-cache /etc/ca-certificates /etc/ca-certificates
COPY --from=build-cache /usr/sbin/update-ca-certificates /usr/sbin/update-ca-certificates
COPY --from=build-cache /etc/ssl/certs /etc/ssl/certs
COPY --from=build-cache /etc/ca-certificates.conf /etc/ca-certificates.conf
RUN /usr/sbin/update-ca-certificates

ENTRYPOINT ${ENTRYPOINT}
COPY --from=build-cache /go/bin/ /go/bin/
