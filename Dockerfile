FROM golang:1.12 as builder 
LABEL maintainer="Sang Li <sang.lx@teko.vn>"
WORKDIR /app

#### Cache Vendor ... 
COPY go.mod go.sum /app/

RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /usr/local/bin/echo-identity-test-server .


######## Start a new stage from scratch #######
FROM alpine:latest
RUN apk update && apk add bash && apk add mysql-client
RUN apk add --no-cache ca-certificates openssl
WORKDIR /app
COPY --from=builder /usr/local/bin/echo-identity-test-server .

EXPOSE 1323
ENTRYPOINT [ "./echo-identity-test-server" ]