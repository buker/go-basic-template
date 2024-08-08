ARG GO_VERSION=1.22
FROM golang:${GO_VERSION}-alpine AS builder
RUN apk update && \
    apk add curl \
            git \
            bash \
            make \
            ca-certificates && \
    rm -rf /var/cache/apk/*
WORKDIR /build
COPY . .
RUN ls
RUN go mod download
RUN go mod verify
RUN make build
RUN mkdir -p /app/bin
FROM alpine:latest AS certificates

RUN apk --no-cache add ca-certificates

FROM alpine:latest
WORKDIR /app
ENV PATH=/app/:$PATH
COPY --from=builder /build/bin/main /app/main
ENTRYPOINT ["main"]