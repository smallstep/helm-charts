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
| `autocert.image.tag`                       | Tag of the Autocert image                                                         | `0.11.0-rc.2`                           |
| `autocert.image.pullPolicy`                | Autocert image pull policy                                                        | `IfNotPresent`                          |
| `autocert.label`                           | Label uses to enable Autocert in a namespaces (should not be changed)             | `autocert.step.sm`                      |
| `autocert.logFormat`                       | Log format, `json` or `text`                                                      | `json`                                  |
| `autocert.restrictCertificatesToNamespace` | If certificate names are restricted to the namespace                              | `false`                                 |
| `autocert.closterDomain`                   | Cluster domain name                                                               | `cluster.local`                         |
| `autocert.certLifetime`                    | Certificate lifetime                                                              | `24h`                                   |
| `autocert.resources`                       | CPU/memory resource requests/limits (YAML)                                        | `{requests: {cpu: 100m, memory: 20Mi}}` |
| `autocert.nodeSelector`                    | Node labels for pod assignment (YAML)                                             | `{}`                                    |
| `autocert.tolerations`                     | Toleration labels for pod assignment (YAML)                                       | `[]`                                    |
| `autocert.affinity`                        | Affinity settings for pod assignment (YAML)                                       | `{}`                                    |
| `bootstrapper.image.repository`            | Repository of the Autocert bootstrapper image                                     | `smallstep/autocert-bootstrapper`       |
| `bootstrapper.image.tag`                   | Tag of the Autocert bootstrapper image                                            | `0.11.0-rc.2`                           |
| `bootstrapper.image.pullPolicy`            | Autocert bootstrapper image pull policy                                           | `IfNotPresent`                          |
| `bootstrapper.resources`                   | CPU/memory resource requests/limits (YAML)                                        | `{}`                                    |
| `renewer.image.repository`                 | Repository of the Autocert renewer image                                          | `smallstep/autocert-renewer`            |
| `renewer.image.tag`                        | Tag of the Autocert renewer image                                                 | `0.11.0-rc.2`                           |
| `renewer.image.pullPolicy`                 | Autocert renewer image pull policy                                                | `IfNotPresent`                          |
| `renewer.resources`                        | CPU/memory resource requests/limits (YAML)                                        | `{}`                                    |
| `ingress.enabled`                          | If true Autocert ingress will be created                                          | `false`                                 |
| `ingress.annotations`                      | Autocert ingress annotations (YAML)                                               | `{}`                                    |
| `ingress.hosts`                            | Autocert ingress hostNAMES (YAML)                                                 | `[]`                                    |
| `ingress.tls`                              | Autocert ingress TLS configuration (YAML)                                         | `[]`                                    |
| `step-certificates.autocert.enabled`       | Enables autocert in step-certificates sub-chart (should not be changed)           | `true`                                  |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm
install`. For example,

```console
helm install --name my-release \
  --set autocert.logFormat=text,step-certificates.ca.name=Foo \
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
