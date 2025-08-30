FROM alpine:3.20

RUN apk update && \
  apk add \
    less \
    busybox \
    openjdk17-jre \
    inotify-tools \
  && true

COPY var/build/java /
COPY docker/java/testers /yaml/bin/

ENV PATH="/yaml/bin:$PATH"

ENV RUNTIME=java
