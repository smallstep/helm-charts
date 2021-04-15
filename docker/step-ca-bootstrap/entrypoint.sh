#!/bin/bash

echo "Welcome to Step Certificates configuration."

STEPPATH=/home/step

# assert_variable exists if the given variable is not set.
function assert_variable () {
  if [ -z "$1" ];
  then
    echo "Error: variable $1 has not been set."
    exit 1
  fi
}

# check required variables
assert_variable "$NAMESPACE"
assert_variable "$PREFIX"
assert_variable "$LABELS"
assert_variable "$CA_URL"
assert_variable "$CA_NAME"
assert_variable "$CA_DNS"
assert_variable "$CA_ADDRESS"
assert_variable "$CA_PROVISIONER"

# check autocert required variables
if [ "$AUTOCERT" == "true" ]; then
  assert_variable "$AUTOCERT_SERVICE"
  assert_variable "$AUTOCERT_LABEL"
fi

# generate password if necessary
CA_PASSWORD=${CA_PASSWORD:-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')}
CA_PROVISIONER_PASSWORD=${CA_PROVISIONER_PASSWORD:-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')}

echo -e "\e[1mChecking cluster permissions...\e[0m"

function permission_error () {
  # TODO: Figure out the actual service account instead of assuming default.
  echo
  echo -e "\033[0;31mPERMISSION ERROR\033[0m"
  echo "Set permissions by running the following command, then try again:"
  echo -e "\e[1m"
  echo "    kubectl create clusterrolebinding autocert-init-binding \\"
  echo "      --clusterrole cluster-admin \\"
  echo "      --user \"system:serviceaccount:default:default\""
  echo -e "\e[0m"
  echo "Once setup is complete you can remove this binding by running:"
  echo -e "\e[1m"
  echo "    kubectl delete clusterrolebinding autocert-init-binding"
  echo -e "\e[0m"

  exit 1
}

# Use the service account context
kubectl config set-cluster cfc --server=https://kubernetes.default --certificate-authority=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
kubectl config set-context cfc --cluster=cfc
kubectl config set-credentials user --token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
kubectl config set-context cfc --user=user
kubectl config use-context cfc

echo -n "Checking for permission to create configmaps in $NAMESPACE namespace: "
kubectl auth can-i create configmaps --namespace $NAMESPACE
if [ $? -ne 0 ]; then
  permission_error "create configmaps"
fi

echo -n "Checking for permission to create secrets in $NAMESPACE namespace: "
kubectl auth can-i create secrets --namespace $NAMESPACE
if [ $? -ne 0 ]; then
  permission_error "create secrets"
fi

if [ "$AUTOCERT" == "true" ]; then
  echo -n "Checking for permission to create mutatingwebhookconfiguration in $NAMESPACE namespace: "
  kubectl auth can-i create mutatingwebhookconfiguration --namespace $NAMESPACE
  if [ $? -ne 0 ]; then
    permission_error "create mutatingwebhookconfiguration"
  fi
fi

# Setting this here on purpose, after the above section which explicitly checks
# for and handles exit errors.
set -e

TMP_CA_PASSWORD=$(mktemp /tmp/autocert.XXXXXX)
TMP_CA_PROVISIONER_PASSWORD=$(mktemp /tmp/autocert.XXXXXX)

echo $CA_PASSWORD > $TMP_CA_PASSWORD
echo $CA_PROVISIONER_PASSWORD > $TMP_CA_PROVISIONER_PASSWORD

step ca init \
  --name "$CA_NAME" \
  --dns "$CA_DNS" \
  --address "$CA_ADDRESS" \
  --password-file "$TMP_CA_PASSWORD" \
  --provisioner "$CA_DEFAULT_PROVISIONER" \
  --provisioner-password-file "$TMP_CA_PROVISIONER_PASSWORD" \
  --with-ca-url "$CA_URL"

rm -f $TMP_CA_PASSWORD $TMP_CA_PROVISIONER_PASSWORD

echo
echo -e "\e[1mCreating configmaps and secrets in $NAMESPACE namespace ...\e[0m"

function kbreplace() {
  kubectl $@ -o yaml --dry-run=client | kubectl replace -f -
}

# Replace secrets created on helm install
# It allows to properly remove them on help delete
kbreplace -n $NAMESPACE create configmap $PREFIX-config --from-file $(step path)/config
kbreplace -n $NAMESPACE create configmap $PREFIX-certs --from-file $(step path)/certs
kbreplace -n $NAMESPACE create configmap $PREFIX-secrets --from-file $(step path)/secrets

kbreplace -n $NAMESPACE create secret generic $PREFIX-ca-password --from-literal "password=${CA_PASSWORD}"
kbreplace -n $NAMESPACE create secret generic $PREFIX-provisioner-password --from-literal "password=${CA_PROVISIONER_PASSWORD}"

# Label all configmaps and secrets
kubectl -n $NAMESPACE label configmap $PREFIX-config $LABELS
kubectl -n $NAMESPACE label configmap $PREFIX-certs $LABELS
kubectl -n $NAMESPACE label configmap $PREFIX-secrets $LABELS
kubectl -n $NAMESPACE label secret $PREFIX-ca-password $LABELS
kubectl -n $NAMESPACE label secret $PREFIX-provisioner-password $LABELS

# Replace webhook if necessary
if [ "$AUTOCERT" == "true" ]; then
  CA_BUNDLE=$(cat $(step path)/certs/root_ca.crt | base64 | tr -d '\n')
  cat <<EOF | kubectl replace -f -
{{- if semverCompare ">=1.16-0" .Capabilities.KubeVersion.GitVersion -}}
apiVersion: admissionregistration.k8s.io/v1
{{- else -}}
apiVersion: admissionregistration.k8s.io/v1beta1
{{- end }}
kind: MutatingWebhookConfiguration
metadata:
  name: $PREFIX-webhook-config
webhooks:
  - name: $AUTOCERT_LABEL
    clientConfig:
      service:
        name: $AUTOCERT_SERVICE
        namespace: $NAMESPACE
        path: "/mutate"
      caBundle: $CA_BUNDLE
{{- if semverCompare ">=1.16-0" .Capabilities.KubeVersion.GitVersion }}
    sideEffects: NoneOnDryRun
    admissionReviewVersions: ["v1beta1"]
{{- end }}
    rules:
      - operations: ["CREATE"]
        apiGroups: [""]
        apiVersions: ["v1"]
        resources: ["pods"]
    failurePolicy: Ignore
    namespaceSelector:
      matchLabels:
        $AUTOCERT_LABEL: enabled
EOF
  kubectl -n $NAMESPACE label mutatingwebhookconfiguration $PREFIX-webhook-config $LABELS
fi

FINGERPRINT=$(step certificate fingerprint $(step path)/certs/root_ca.crt)

echo
echo -e "\e[1mStep Certificates installed!\e[0m"
echo
echo "CA URL: ${CA_URL}"
echo "CA Fingerprint: ${FINGERPRINT}"
echo