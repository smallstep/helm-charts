FROM smallstep/step-cli:0.22.0

ENV CA_NAME="Step CA"
ENV CA_DNS="127.0.0.1"
ENV CA_ADDRESS=":9000"
ENV CA_DEFAULT_PROVISIONER="admin"
ENV CA_URL="https://127.0.0.1:9000"

ENV KUBE_LATEST_VERSION="v1.30.0"

USER root
RUN apk --update add expect && \
    apkArch="$(apk --print-arch)"; \
    case "$apkArch" in \
        armhf) ARCH='arm' ;; \
        armv7) ARCH='arm' ;; \
        aarch64) ARCH='arm64' ;; \
        x86_64) ARCH='amd64' ;; \
        x86) ARCH='386' ;; \
        *) echo >&2 "error: unsupported architecture: $apkArch"; exit 1 ;; \
    esac && \
    curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/${ARCH}/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

COPY entrypoint.sh /home/step/
RUN chmod +x /home/step/entrypoint.sh
CMD ["/home/step/entrypoint.sh"]
