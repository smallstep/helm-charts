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

1. Update `version` in _packageName/Chart.yaml_.

2. Update `appVersion` to the image tag in _packageName/Chart.yaml_.

3. Commit these changes to a branch and push the branch to the origin. 
Open a PR for merging to master.

4. Create helm package (using `step-certificates` as an example):

   ```sh
   helm package ./step-certificates
   ```

5. Update repository (using `step-certificates` as an example):

   ```sh
   ./deploy.sh ./step-certificates
   ```
