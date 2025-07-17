FROM --platform=$TARGETPLATFORM python:3.11-slim-bullseye as build
LABEL authors="tbadyal"
LABEL copyright="Fidelity International"
ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETOS
ARG SPARKVERSION=4.0.0
ARG HADOOPVARSION=3
ARG OPENJDKVERSION=17
RUN apt-get update && \
    apt-get install -y --no-install-recomends ca-certificates curl && \
    apt-get install openjdk-${OPENJDKVERSION}-jdk-headless && \
    update-ca-certificates && \
    apt-get clean
ENTRYPOINT["python"]