# The docker image to build the go binaries
FROM alpine:3.6
MAINTAINER Uladzimir Trehubenka <utrehubenka@infoblox.com>
WORKDIR /tmp

# Install build tools
ENV PKG bash curl gcc git go go-tools linux-headers make musl-dev openssh unzip

RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache $PKG

# Set up mandatory Go environmental variables
ENV GOPATH=/go
ENV PATH=$GOPATH/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" "$GOPATH/pkg" && chmod -R 777 $GOPATH

# The version and the binaries checksum for the protocol buffers compiler
ENV PROTOC_VERSION 3.4.0
ENV PROTOC_DOWNLOAD_URL https://github.com/google/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip
ENV PROTOC_DOWNLOAD_SHA256 e4b51de1b75813e62d6ecdde582efa798586e09b5beaebfb866ae7c9eaadace4

# Download and install the protocol buffers compiler.
RUN curl -fsSL ${PROTOC_DOWNLOAD_URL} -o protoc.zip \
    && echo "${PROTOC_DOWNLOAD_SHA256}  protoc.zip" | sha256sum -c - \
    && unzip -d /usr/local protoc.zip \
    && rm -rf protoc.zip

# The version and the binaries checksum for the glide package manager
ENV GLIDE_VERSION 0.12.3
ENV GLIDE_DOWNLOAD_URL https://github.com/Masterminds/glide/releases/download/v${GLIDE_VERSION}/glide-v${GLIDE_VERSION}-linux-amd64.tar.gz
ENV GLIDE_DOWNLOAD_SHA256 0e2be5e863464610ebc420443ccfab15cdfdf1c4ab63b5eb25d1216900a75109

# Download and install the glide package manager.
RUN curl -fsSL ${GLIDE_DOWNLOAD_URL} -o glide.tar.gz \
    && echo "${GLIDE_DOWNLOAD_SHA256}  glide.tar.gz" | sha256sum -c - \
    && tar -xzf glide.tar.gz --strip-components=1 -C /usr/local/bin \
    && rm -rf glide.tar.gz

# Install as the protoc plugins as build-time dependencies
COPY glide.yaml .

# Compile binaries for the protocol buffer plugins. We need specific
# versions of these tools, this is why we at first step install glide,
# download required versions and then installing them.
RUN glide up --strip-vendor --skip-test \
    && cp -r vendor/* ${GOPATH}/src/ \
    && go install github.com/golang/protobuf/protoc-gen-go \
    && go install github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger \
    && go install github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway \
    && rm -rf vendor/* ${GOPATH}/pkg/* ${GOPATH}/src/*

# Install the Go linter and Go junit binary
RUN go get github.com/golang/lint/golint \
    && go get github.com/jstemmer/go-junit-report \
    && rm -rf ${GOPATH}/pkg/* ${GOPATH}/src/*

WORKDIR ${GOPATH}
