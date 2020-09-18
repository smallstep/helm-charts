# Step Issuer

⚙️  A certificate issuer for cert-manager using step certificates CA.

To learn more, visit <https://github.com/smallstep/step-issuer>.

## TL;DR

```console
helm install step-issuer step-issuer
```

## Prerequisites

-   Kubernetes 1.10+

## Installing the Chart

To install the chart with the release name `step-issuer`:

```console
helm install step-issuer step-issuer
```

The command deploys step-issuer on the Kubernetes cluster with the default configuration.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `step-issuer` deployment:

```console
helm uninstall step-issuer
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Configuration

The following table lists the configurable parameters of the Step Issuer chart
and their default values.

| Parameter                                 | Description                                                              | Default                 |
| ----------------------------------------- | ------------------------------------------------------------------------ | ----------------------- |
| `replicaCount`                            | Number of Step Issuer replicas.                                          | `1`                     |
| `deployment.image.repository`             | Repository of the Step Issuer image.                                     | `smallstep/step-issuer` |
| `deployment.image.tag`                    | Tag of the Step Step Issuer image .                                      | `0.2.0`                 |
| `deployment.image.pullPolicy`             | Step Issuer image pull policy                                            | `IfNotPresent`          |
| `stepIssuer.created`                      | If we should automatically create an step-issuer.                        | `false`                 |
| `stepIssuer.caBundler`                    | Step Certificates root certificate in base64.                            | `""`                    |
| `stepIssuer.provisioner.name`             | Name of the provisioner used for authorizing the sign of certificates.   | `""`                    |
| `stepIssuer.provisioner.kid`              | Key id of the provisioner used for authorizing the sign of certificates. | `""`                    |
| `stepIssuer.provisioner.passwordRef.name` | Name of the secret with the provisioner password.                        | `""`                    |
| `stepIssuer.provisioner.passwordRef.key`  | Key name in the the secret with the provisioner password.                | `""`                    |
