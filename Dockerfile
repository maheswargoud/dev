FROM httpd
COPY . /usr/local/apache2/htdocs/



FROM golang:alpine as builder
COPY --from=builder /build/main /app/

COPY . /usr/local/bin/app/


FROM golang:1.18

WORKDIR /usr/src/app

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
RUN go build -v -o /usr/local/bin/app ./...

CMD ["app"]