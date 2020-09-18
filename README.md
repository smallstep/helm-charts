# Smallstep Helm Charts

This is a [Helm](https://helm.sh) repository with packages for Kubernetes.

To install the [Smallstep](https://smallstep.com) repo just run:

```console
helm repo add smallstep  https://smallstep.github.io/helm-charts
helm repo update
```

## Packages

* [Step Certificates](https://github.com/smallstep/helm-charts/tree/master/step-certificates):
  An online certificate authority and related tools for secure automated
  certificate management, so you can use TLS everywhere. Install
  step-certificates using:

  ```console
  helm install step-certificates smallstep/step-certificates
  ```

* [Autocert](https://github.com/smallstep/helm-charts/tree/master/autocert): A
  kubernetes add-on that automatically injects TLS/HTTPS certificates into your
  containers. Install autocert using:

  ```console
  helm install autocert smallstep/autocert
  ```

* [Step Issuer](https://github.com/smallstep/helm-charts/tree/master/step-issuer): A
  certificate issuer for cert-manager using Step Certificates.

  ```console
  helm install step-issuer smallstep/step-issuer
  ```
