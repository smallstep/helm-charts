# Step Certificates

An online certificate authority and related tools for secure automated
certificate management, so you can use TLS everywhere.

To learn more, visit <https://github.com/smallstep/certificates>.

## TL;DR

```console
helm install step-certificates
```

## Prerequisites

-   Kubernetes 1.10+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install --name my-release step-certificates
```

The command deploys Step certificates on the Kubernetes cluster in the default
configuration. The [configuration](#configuration) section lists the parameters
that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Configuration

The following table lists the configurable parameters of the Step certificates
chart and their default values.

| Parameter                     | Description                                                                                                 | Default                                  |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| `ca.name`                     | Name for you CA                                                                                             | `Step Certificates`                      |
| `ca.address`                  | TCP address where Step CA runs                                                                              | `:9000`                                  |
| `ca.dns`                      | DNS of Step CA, if empty it will be inferred                                                                | `""`                                     |
| `ca.url`                      | URL of Step CA, if empty it will be inferred                                                                | `""`                                     |
| `ca.password`                 | Password for the CA keys, if empty it will be automatically generated                                       | `""`                                     |
| `ca.provisioner.name`         | Name for the default provisioner                                                                            | `admin`                                  |
| `ca.provisioner.password`     | Password for the default provisioner, if empty it will be automatically generated                           | `""`                                     |
| `ca.db.enabled`               | If true, step certificates will be configured with a database                                               | `true`                                   |
| `ca.db.persistent`            | If true a persistent volume will be used to store the db                                                    | `true`                                   |
| `ca.db.accessModes`           | Persistent volume access mode                                                                               | `["ReadWriteOnce"]`                      |
| `ca.db.size`                  | Persistent volume size                                                                                      | `10Gi`                                   |
| `ca.db.existingClaim`         | Persistent volume existing claim name. If defined, PVC must be created manually before volume will be bound | `""`                                     |
| `ca.runAsRoot`                | Run the CA as root.                                                                                         | `false`                                  |
| `ca.bootstrap.postInitHook`   | Extra script snippet to run after `step ca init` has completed.                                             | `""`                                     |
| `service.type`                | Service type                                                                                                | `ClusterIP`                              |
| `service.port`                | Incoming port to access Step CA                                                                             | `443`                                    |
| `service.nodePort`            | Incoming port to access Step CA                                                                             | `""`                                     |
| `service.targetPort`          | Internal port where Step CA runs                                                                            | `9000`                                   |
| `replicaCount`                | Number of Step CA replicas. Only one replica is currently supported.                                        | `1`                                      |
| `image.repository`            | Repository of the Step CA image                                                                             | `cr.step.sm/smallstep/step-ca`           |
| `image.tag`                   | Tag of the Step CA image                                                                                    | `latest`                                 |
| `image.pullPolicy`            | Step CA image pull policy                                                                                   | `IfNotPresent`                           |
| `bootstrap.image.repository`  | Repository of the Step CA bootstrap image                                                                   | `cr.step.sm/smallstep/step-ca-bootstrap` |
| `bootstrap.image.tag`         | Tag of the Step CA bootstrap image                                                                          | `latest`                                 |
| `bootstrap.image.pullPolicy`  | Step CA bootstrap image pull policy                                                                         | `IfNotPresent`                           |
| `bootstrap.enabled`           | If false, it does not create the bootstrap job.                                                             | `true`                                   |
| `bootstrap.configmaps`        | If false, it does not create the configmaps.                                                                | `true`                                   |
| `bootstrap.secrets`           | If false, it does not create the secrets.                                                                   | `true`                                   |
| `nameOverride`                | Overrides the name of the chart                                                                             | `""`                                     |
| `fullnameOverride`            | Overrides the full name of the chart                                                                        | `""`                                     |
| `ingress.enabled`             | If true Step CA ingress will be created                                                                     | `false`                                  |
| `ingress.annotations`         | Step CA ingress annotations (YAML)                                                                          | `{}`                                     |
| `ingress.hosts`               | Step CA ingress hostNAMES (YAML)                                                                            | `[]`                                     |
| `ingress.tls`                 | Step CA ingress TLS configuration (YAML)                                                                    | `[]`                                     |
| `resources`                   | CPU/memory resource requests/limits (YAML)                                                                  | `{}`                                     |
| `nodeSelector`                | Node labels for pod assignment (YAML)                                                                       | `{}`                                     |
| `tolerations`                 | Toleration labels for pod assignment (YAML)                                                                 | `[]`                                     |
| `affinity`                    | Affinity settings for pod assignment (YAML)                                                                 | `{}`                                     |
| `inject.config.enabled`       | When true, configuration files and templates are injected into a Kubernetes configmap.                      | `false`                                  |
| `inject.config.files.ca.json` | Yaml representation of the step-ca ca.json file.  This map object is converted to its equivalent json representation before being injected into a configMap.  See the step-ca [documentation](https://smallstep.com/docs/step-ca/configuration). | See [values.yaml](./values.yaml) |
| `inject.config.files.default.json` | Yaml representation of the step-cli defaults.json file.  This map object is converted to its equivalent json representation before being injected into a configMap.  See the step-cli [documentation](https://smallstep.com/docs/step-cli/reference). | See [values.yaml](./values.yaml) |
| `inject.config.templates.x509_leaf.tpl`   | Example X509 Leaf Certifixate Template to inject into the configMap.                            | See [values.yaml](./values.yaml)         |
| `inject.config.templates.ssh.tpl`         | Example SSH Certificate Template to inject into the configMap.                                  | See [values.yaml](./values.yaml)         |
| `inject.certificates.enabled`             | When true, certificates are injected into a configmap.                                          | `false`                                  |
| `inject.certificates.intermediate_ca`     | Plain text PEM representation of the intermediate CA certificate.                               | `""`                                     |
| `inject.certificates.root_ca`             | Plain text PEM representation of the root CA certificate.                                       | `""`                                     |
| `inject.certificates.ssh_host_ca`         | Plain text representation of the ssh host CA public key.                                        | `""`                                     |
| `inject.certificates.ssh_user_ca`         | Plain text representation of the ssh user CA public key.                                        | `""`                                     |
| `inject.secrets.enabled`                  | When true, secrets are injected into a Kubernetes Secret.                                       | `false`                                  |
| `inject.secrets.ca_password`              | Base64 encoded string.  Password used to encrypt intermediate and ssh keys.                     | `""`                                     |
| `inject.secrets.x509.intermediate_ca_key` | Plain text PEM representation of the intermediate CA private key.                               | `""`                                     |
| `inject.secrets.x509.root_ca_key`         | Plain text PEM representation of the root CA private key.                                       | `""`                                     |
| `inject.secrets.ssh.host_ca_key `         | Plain text representation of the ssh host CA private key.                                       | `""`                                     |
| `inject.secrets.ssh.user_ca_key `         | Plain text representation of the ssh user CA private key.                                       | `""`                                     |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm
install`. For example,

```console
helm install --set provisioner.password=secretpassword,provisioner.name=Foo \
  my-release step-certificates
```

The above command sets the Step Certificates main provisioner `Foo` with the key
password `secretpassword`.

If you provide a custom value for `ca.dns`, be sure to append
`,{{fullname}}.{{namespace}}.svc.cluster.local,127.0.0.1` to the end, otherwise
accessing the CA by those DNS/IPs will fail (services internal to the cluster):

```console
helm install --set ca.dns="ca.example.com\,my-release-step-certificates.default.svc.cluster.local\,127.0.0.1" \
  my-release step-certificates
```

Alternatively, a YAML file that specifies the values for the parameters can be
provided while installing the chart. For example,

```console
helm install -f values.yaml my-release step-certificates
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Notes

At this moment only one replica is supported, step certificates supports
multiple ones using MariaDB or MySQL.
