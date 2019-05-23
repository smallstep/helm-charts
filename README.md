# helm-charts
Helm packages for Kubernetes.

```text
⚠️ This repository contains work in progress packages
```

## Helm, Tiller, & RBAC
If you're using a cluster with RBAC enabled please be sure to follow helm's [setup intructions available here](https://github.com/helm/helm/blob/master/docs/rbac.md).

## Packages

* [Step CA](./step-ca/README.md): An online certificate authority and related
  tools for secure automated certificate management, so you can use TLS
  everywhere.

* [Autocert](./autocert/REAMDE.md): A kubernetes add-on that automatically
  injects TLS/HTTPS certificates into your containers.
