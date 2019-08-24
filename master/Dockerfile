ARG GOBUSTER_VERSION="master"

FROM golang:alpine AS builder

ARG GOBUSTER_VERSION
ENV GOBUSTER_VERSION "${GOBUSTER_VERSION}"
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GO111MODULE=on

RUN	apk upgrade && apk --no-cache add \
	ca-certificates \
    git \
    make \
    && addgroup gobuster \
    && adduser -G gobuster -s /bin/sh -D gobuster

RUN mkdir -p /go/src/gobuster \
	&& git clone --depth 1 --branch "${GOBUSTER_VERSION}" https://github.com/OJ/gobuster.git /go/src/gobuster \
	&& cd /go/src/gobuster \
    && go get && go build \
	&& make \
	&& cp -vr /go/bin/* /usr/local/bin/ \
	&& echo "Build complete."

FROM alpine:edge

COPY --from=builder /usr/local/bin/gobuster /usr/local/bin/gobuster
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/ssl/certs /etc/ssl/certs

USER gobuster

ENTRYPOINT [ "/usr/local/bin/gobuster" ]

LABEL org.opencontainers.image.title="gobuster" \
    org.opencontainers.image.description="gobuster in Docker" \
    org.opencontainers.image.url="https://github.com/westonsteimel/docker-gobuster" \
    org.opencontainers.image.source="https://github.com/westonsteimel/docker-gobuster" \
    org.opencontainers.image.version="${GOBUSTER_VERSION}" \
    version="${GOBUSTER_VERSION}"

