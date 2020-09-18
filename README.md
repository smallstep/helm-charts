# Smallstep Helm Charts

[Helm](https://helm.sh) packages for Kubernetes. The master branch of this
repository contains work in progress packages.

Visit https://smallstep.github.io/helm-charts/ for stable releases.

## Packages

* [Step Certificates](./step-certificates/README.md): An online certificate authority and
  related tools for secure automated certificate management, so you can use TLS
  everywhere.

* [Autocert](./autocert/README.md): A kubernetes add-on that automatically
  injects TLS/HTTPS certificates into your containers.

* [Step Issuer](./step-issuer/README.md): A certificate issuer for cert-manager
  using Step Certificates.

## Distribution

1. Update `version` and `appVersion` in _packageName/Chart.yaml_.

2. Update image tag in _packageName/values.yaml_.

3. Create helm package. For example for step-certificates:

   ```sh
   helm package ./step-certificates
   ```

4. Update repository:

   ```sh
   git checkout gh-pages
   git pull origin gh-pages
   git add "step-certificates-<version>.tgz"
   helm repo index --merge index.yaml --url https://smallstep.github.io/helm-charts/ .
   git commit -a -m "Add package for step-certificates vX.Y.Z"
   git push origin gh-pages
   ```
