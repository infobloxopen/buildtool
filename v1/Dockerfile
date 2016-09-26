# The docker image to build the binaries.
FROM golang:1.5.3
MAINTAINER Yakau Bubnou <ybubnou@infoblox.com>
WORKDIR /tmp

# Set up mandatory Go environmental variables.
ENV GO15VENDOREXPERIMENT=1
ENV CGO_ENABLED=0

# Install zip tool to unpack the protoc compiler, and the npm
# package manager and install the REST API generator.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        unzip \
        nodejs \
        npm \
    && rm -rf /var/lib/apt/lists/*

# Soon, we will switch to the swagger-based documentation, so it could
# not be longer required.
RUN npm install -g apidoc && ln -sf $(which nodejs) /usr/bin/node

# The version and the binaries checksum for the protocol buffers compiler.
ENV PROTOC_VERSION 3.0.0
ENV PROTOC_DOWNLOAD_URL https://github.com/google/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip
ENV PROTOC_DOWNLOAD_SHA256 56e3f685ffe3c9516c5ed1da0aefd3f41010a051e8b36f1b538ac23298fccb30

# Download and install the protocol buffers compiler.
RUN curl -fsSL ${PROTOC_DOWNLOAD_URL} -o protoc.zip \
    && echo "${PROTOC_DOWNLOAD_SHA256} protoc.zip" | sha256sum -c - \
    && unzip -d /usr/local protoc.zip \
    && rm -rf protoc.zip

# The version and the binaries chechsum for the glide package manager.
ENV GLIDE_VERSION 0.12.2
ENV GLIDE_DOWNLOAD_URL https://github.com/Masterminds/glide/releases/download/v${GLIDE_VERSION}/glide-v${GLIDE_VERSION}-linux-amd64.tar.gz
ENV GLIDE_DOWNLOAD_SHA256 edd398b4e94116b289b9494d1c13ec2ea37386bad4ada91ecc9825f96b12143c

# Download and install the glide package manager.
RUN curl -fsSL ${GLIDE_DOWNLOAD_URL} -o glide.tar.gz \
    && echo "${GLIDE_DOWNLOAD_SHA256} glide.tar.gz" | sha256sum -c - \
    && tar -xzf glide.tar.gz --strip-components=1 -C /usr/local/bin \
    && rm -rf glide.tar.gz

# Install as the protoc plugins as build-time dependecies.
COPY glide.yaml .

# Compile binaries for the protocol buffer plugins. We need specific
# versions of these tools, this is why we at first step install glide
# download required versions, and the installin them.
RUN glide up --strip-vendor --skip-test \
    && cp -r vendor/* ${GOPATH}/src/ \
    && go install github.com/golang/protobuf/protoc-gen-go \
    && go install github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger \
    && go install github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway \
    && rm -rf vendor/* ${GOPATH}/pkg/* ${GOPATH}/src/*

# Install the Go linter binary.
RUN go get github.com/golang/lint/golint \
    && rm -rf ${GOPATH}/pkg/* ${GOPATH}/src/*

WORKDIR ${GOPATH}
