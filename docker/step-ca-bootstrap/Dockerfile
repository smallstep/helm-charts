FROM smallstep/step-cli:0.14.2

ENV CA_NAME="Step CA"
ENV CA_DNS="127.0.0.1"
ENV CA_ADDRESS=":9000"
ENV CA_DEFAULT_PROVISIONER="admin"
ENV CA_URL="https://127.0.0.1:9000"

ENV KUBE_LATEST_VERSION="v1.18.2"

USER root
RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl
RUN apk --update add expect

COPY entrypoint.sh /home/step/
RUN chmod +x /home/step/entrypoint.sh
CMD ["/home/step/entrypoint.sh"]
