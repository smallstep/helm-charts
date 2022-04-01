# syntax=docker/dockerfile:1

##
## Build
##
FROM golang:1.18-buster AS build

# Version must match the badger used by step-ca, see helm chart
# ca.db.type: badgerv2
#ENV version=2.2007.4
# defaults to version 1.6.2
ENV version=1.6.2
ENV CGO_ENABLED=0

WORKDIR /go/src/
ADD . /go/src

RUN curl https://github.com/dgraph-io/badger/archive/refs/tags/v$version.tar.gz -L -O

RUN tar xf v$version.tar.gz
WORKDIR /go/src/badger-$version

RUN go get github.com/dgraph-io/badger/v3

RUN go install

WORKDIR /go/src/badger-$version/badger
RUN go build -o /badger

##
## Runtime-image
##
FROM alpine:3.15.3

WORKDIR /

COPY ./backup-restore.sh /usr/local/bin/backup-restore.sh
COPY --from=build /badger /usr/local/bin/badger
