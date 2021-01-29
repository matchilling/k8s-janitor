FROM alpine:3.13.1

MAINTAINER Mathias Schilling <m@matchilling.com>

ARG HELM_VERSION="3.5.0"
ARG KUBE_VERSION="1.15.1"

RUN apk add --update ca-certificates \
 && apk add --update -t deps curl bash

RUN curl -L "https://storage.googleapis.com/kubernetes-release/release/v$KUBE_VERSION/bin/linux/amd64/kubectl" -o "/usr/local/bin/kubectl" && \
    chmod +x "/usr/local/bin/kubectl"

RUN curl -q "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" -o "helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
 && tar -xf "helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
 && mv linux-amd64/helm /usr/local/bin \
 && rm -f "/helm-v${HELM_VERSION}-linux-amd64.tar.gz"

ADD /script  /opt/k8s-janitor/script
