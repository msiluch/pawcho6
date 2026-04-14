# syntax=docker/dockerfile:1.4

FROM golang:1.22-alpine AS builder

WORKDIR /laboratorium_5

RUN apk add --no-cache git openssh-client

RUN --mount=type=ssh git clone git@github.com:msiluch/pawcho6.git .

ARG VERSION=1.0

RUN go mod init lab6 || true

RUN CGO_ENABLED=0 go build -ldflags="-X main.version=$VERSION" -o aplikacja

FROM nginx:alpine

RUN apk add --no-cache curl

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /laboratorium_5/aplikacja /aplikacja

CMD ["/bin/sh", "-c", "/aplikacja & nginx -g 'daemon off;'"]

EXPOSE 80 8080

HEALTHCHECK --interval=10s --timeout=3s \
  CMD curl -f http://localhost/ || exit 1