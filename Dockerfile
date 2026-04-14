FROM golang:1.22-alpine AS builder

WORKDIR /laboratorium_5
COPY main.go .

RUN go mod init lab5

ARG VERSION=1.0

RUN CGO_ENABLED=0 go build -ldflags="-X main.version=$VERSION" -o aplikacja

FROM nginx:alpine

RUN apk add --no-cache curl

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /laboratorium_5/aplikacja /aplikacja

CMD ["/bin/sh", "-c", "/aplikacja & nginx -g 'daemon off;'"]

EXPOSE 80 8080

HEALTHCHECK --interval=10s --timeout=3s \
  CMD curl -f http://localhost/ || exit 1