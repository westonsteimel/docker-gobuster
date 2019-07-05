FROM golang:alpine AS builder

RUN	apk --no-cache add \
	ca-certificates \
    git \
    make

LABEL version="3.0.1"
ENV GOBUSTER_VERSION v3.0.1
ENV GO111MODULE on

RUN mkdir -p /go/src/gobuster \
	&& git clone --depth 1 --branch "${GOBUSTER_VERSION}" https://github.com/OJ/gobuster.git /go/src/gobuster \
	&& cd /go/src/gobuster \
    && go get && go build \
	&& make \
	&& cp -vr /go/bin/* /usr/local/bin/ \
	&& echo "Build complete."

RUN apk upgrade && apk --no-cache add \
    ca-certificates \
    && rm -rf /var/cache \
    && addgroup gobuster \
    && adduser -G gobuster -s /bin/sh -D gobuster

FROM alpine:edge

COPY --from=builder /usr/local/bin/gobuster /usr/local/bin/gobuster
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/ssl/certs /etc/ssl/certs

USER gobuster

ENTRYPOINT [ "/usr/local/bin/gobuster" ]

