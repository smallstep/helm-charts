# Autocert

A kubernetes add-on that automatically injects TLS/HTTPS certificates into your
containers.

To learn more, visit https://github.com/smallstep/certificates/tree/master/autocert.

## TL;DR

```console
helm install autocert
kubectl label namespace default autocert.step.sm=enabled
```

## Prerequisites

- Kubernetes 1.10+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install --name my-release autocert
```

The command deploys Autocert on the Kubernetes cluster in the default
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

## Enable Autocert (per namespace)

To enable Autocert for a namespace it must be labelled
`autocert.step.sm=enabled`.

To label the default namespace run:

```console
kubectl label namespace default autocert.step.sm=enabled
```

To check which namespaces have Autocert enabled run:

```console
$ kubectl get namespace -L autocert.step.sm
NAME          STATUS   AGE   AUTOCERT.STEP.SM
default       Active   59m   enabled
...
```

## Configuration

The following table lists the configurable parameters of the Autocert chart and
their default values.

| Parameter                                  | Description                                                                       | Default                                 |
|--------------------------------------------|-----------------------------------------------------------------------------------|-----------------------------------------|
| `replicaCount`                             | Number of Autocert replicas                                                       | `1`                                     |
| `nameOverride`                             | Overrides the name of the chart                                                   | `""`                                    |
| `fullnameOverride`                         | Overrides the full name of the chart                                              | `""`                                    |
| `service.type`                             | Service type                                                                      | `ClusterIP`                             |
| `service.port`                             | Incoming port to access Autocert                                                  | `443`                                   |
| `service.targetPort`                       | Internal port where Autocert runs                                                 | `4443`                                  |
| `autocert.image.repository`                | Repository of the Autocert image                                                  | `smallstep/autocert-controller`         |
| `autocert.image.tag`                       | Tag of the Autocert image                                                         | `0.8.3`                                 |
| `autocert.image.pullPolicy`                | Autocert image pull policy                                                        | `IfNotPresent`                          |
| `autocert.logFormat`                       | Log format, `json` or `text`                                                      | `json`                                  |
| `autocert.restrictCertificatesToNamespace` | If certificate names are restricted to the namespace                              | `false`                                 |
| `autocert.closterDomain`                   | Cluster domain name                                                               | `cluster.local`                         |
| `autocert.certLifetime`                    | Certificate lifetime                                                              | `24h`                                   |
| `autocert.resources`                       | CPU/memory resource requests/limits (YAML)                                        | `{requests: {cpu: 100m, memory: 20Mi}}` |
| `autocert.nodeSelector`                    | Node labels for pod assignment (YAML)                                             | `{}`                                    |
| `autocert.tolerations`                     | Toleration labels for pod assignment (YAML)                                       | `[]`                                    |
| `autocert.affinity`                        | Affinity settings for pod assignment (YAML)                                       | `{}`                                    |
| `bootstrapper.image.repository`            | Repository of the Autocert bootstrapper image                                     | `smallstep/autocert-bootstrapper`       |
| `bootstrapper.image.tag`                   | Tag of the Autocert bootstrapper image                                            | `0.8.3`                                 |
| `bootstrapper.image.pullPolicy`            | Autocert bootstrapper image pull policy                                           | `IfNotPresent`                          |
| `bootstrapper.resources`                   | CPU/memory resource requests/limits (YAML)                                        | `{}`                                    |
| `renewer.image.repository`                 | Repository of the Autocert renewer image                                          | `smallstep/autocert-renewer`            |
| `renewer.image.tag`                        | Tag of the Autocert renewer image                                                 | `0.8.3`                                 |
| `renewer.image.pullPolicy`                 | Autocert renewer image pull policy                                                | `IfNotPresent`                          |
| `renewer.resources`                        | CPU/memory resource requests/limits (YAML)                                        | `{}`                                    |
| `ingress.enabled`                          | If true Autocert ingress will be created                                          | `false`                                 |
| `ingress.annotations`                      | Autocert ingress annotations (YAML)                                               | `{}`                                    |
| `ingress.hosts`                            | Autocert ingress hostNAMES (YAML)                                                 | `[]`                                    |
| `ingress.tls`                              | Autocert ingress TLS configuration (YAML)                                         | `[]`                                    |
| `step-ca.ca.name`                          | Name for you CA                                                                   | `Step Certificates`                     |
| `step-ca.ca.address`                       | TCP address where Step CA runs                                                    | `:9000`                                 |
| `step-ca.ca.url`                           | URL of Step CA, if empty it will be inferred                                      | `""`                                    |
| `step-ca.ca.password`                      | Password for the CA keys, if empty it will be automatically generated             | `""`                                    |
| `step-ca.ca.provisioner.name`              | Name for the default provisioner                                                  | `admin`                                 |
| `step-ca.ca.provisioner.password`          | Password for the default provisioner, if empty it will be automatically generated | `""`                                    |
| `step-ca.service.type`                     | Service type                                                                      | `ClusterIP`                             |
| `step-ca.service.port`                     | Incoming port to access Step CA                                                   | `443`                                   |
| `step-ca.service.targetPort`               | Internal port where Step CA runs                                                  | `9000`                                  |
| `step-ca.replicaCount`                     | Number of Step CA replicas                                                        | `1`                                     |
| `step-ca.image.repository`                 | Repository of the Step CA image                                                   | `smallstep/step-ca`                     |
| `step-ca.image.tag`                        | Tag of the Step CA image                                                          | `latest`                                |
| `step-ca.image.pullPolicy`                 | Step CA image pull policy                                                         | `IfNotPresent`                          |
| `step-ca.bootstrapImage.repository`        | Repository of the Step CA bootstrap image                                         | `smallstep/step-ca-bootstrap`           |
| `step-ca.bootstrapImage.tag`               | Tag of the Step CA bootstrap image                                                | `latest`                                |
| `step-ca.bootstrapImage.pullPolicy`        | Step CA bootstrap image pull policy                                               | `IfNotPresent`                          |
| `step-ca.nameOverride`                     | Overrides the name of the chart                                                   | `""`                                    |
| `step-ca.fullnameOverride`                 | Overrides the full name of the chart                                              | `""`                                    |
| `step-ca.ingress.enabled`                  | If true Step CA ingress will be created                                           | `false`                                 |
| `step-ca.ingress.annotations`              | Step CA ingress annotations (YAML)                                                | `{}`                                    |
| `step-ca.ingress.hosts`                    | Step CA ingress hostNAMES (YAML)                                                  | `[]`                                    |
| `step-ca.ingress.tls`                      | Step CA ingress TLS configuration (YAML)                                          | `[]`                                    |
| `step-ca.resources`                        | CPU/memory resource requests/limits (YAML)                                        | `{}`                                    |
| `step-ca.nodeSelector`                     | Node labels for pod assignment (YAML)                                             | `{}`                                    |
| `step-ca.tolerations`                      | Toleration labels for pod assignment (YAML)                                       | `[]`                                    |
| `step-ca.affinity`                         | Affinity settings for pod assignment (YAML)                                       | `{}`                                    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm
install`. For example,

```console
helm install --name my-release \
  --set step-ca.provisioner.password=secretpassword,step-ca.provisioner.name=Foo \
  autocert
```

The above command sets the Autocert provisioner `Foo` with the key password
`secretpassword`.

Alternatively, a YAML file that specifies the values for the parameters can be
provided while installing the chart. For example,

```console
helm install --name my-release -f values.yaml autocert
```

> **Tip**: You can use the default [values.yaml](values.yaml)
