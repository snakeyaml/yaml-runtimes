FROM alpine:3.20

RUN apk update && \
  apk add \
    less \
    vim \
    wget \
    openjdk17 \
  && true

