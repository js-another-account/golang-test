FROM golang:1.12.5-alpine3.9 as build

ENV GO111MODULE=on

RUN  apk update --no-cache && apk add git

COPY ./ /app

WORKDIR /app

RUN go build -o golang-test  .


FROM alpine:3.9

RUN apk update --no-cache

COPY --from=build /app/golang-test .

WORKDIR /app

ENTRYPOINT ["/golang-test"]

EXPOSE 8000
