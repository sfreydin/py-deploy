# Build the application from source
FROM golang:1.19 AS build-stage

WORKDIR /app

COPY ./src/go .
RUN go mod download

RUN CGO_ENABLED=0 GOOS=linux go build -o /go-app

# Deploy the application binary into a lean image
FROM alpine:latest AS build-release-stage

WORKDIR /

COPY --from=build-stage /go-app /go-app

EXPOSE 8080

#USER nonroot:nonroot

ENTRYPOINT ["/go-app"]
