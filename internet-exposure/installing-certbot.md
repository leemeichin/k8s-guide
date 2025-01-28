---
order: -7
---

# Installing cert-manager

!!!danger :no_entry: Dependencies required
You'll need to install Helm to continue. If you don't have it yet, refer back to [**:icon-tools: Getting Started**](/getting-started/#helm).
!!!

Certbot makes it effortless to provision TLS certificates for services in your cluster simply by adding a few lines of config to anything you need it for. This is handled by a Helm chart called `cert-manager`.

## Requirements

As with other things that rely on Helm, the process is pretty consistent.

- [x] Add the cert-manager helm repo
- [x] Configure the values for the chart
- [x] Create the `ClusterIssuer` resource
- [x] Install the chart
- [x] Apply the K8S config

## Add the Helm chart repository

First things first, add the repo to Helm.

```shell
helm repo add certbot jetstack/cert-manager
```

## Configure the chart

The configuration required here is so minimal that it feels heavy-handed to store it in a file of its own, but it's better to stay consistent and not everyone will know the magical CLI-based incantation off the top of their heads.

So, create a little file with this one small line in it:

```yaml helm/cert-manager.yml
installCRDs: true
```

All it will do is ensure you have the Custom Resource Definitions (CRDs) required for cert-manager to work, which is exactly what will be done shortly.

### Install the chart

The next step is to install this into the cluster under the `cert-manager` namespace, creating it at the same time.

```shell
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager --create-namespace \
  --file helm/cert-manager.yml
```

Once that succeeds, time to wire this up.

### Create the `ClusterIssuer` resource

The `ClusterIssuer` is a CRD that gives cert-manager the info it needs to provision and authenticate a TLS certificate, as well as where to store the credentials for renewing these certificates in future.

Most of the content of this configuration is just sensible defaults, but you are expected to provide an email address that you own as this will be used to inform you about your certificates.

```yaml #8 cert-manager/cluster-issuer.yml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  namespace: cert-manager
spec:
  acme:
    email: YOUR_EMAIL@EXAMPLE.COM
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-prod-account-key
    solvers:
      - http01:
          ingress:
            class: nginx
```

The rest of the configuration simply informs cert-manager that you're using nginx for ingress and to configure authentication through that.

### Apply the config

Once you're happy, apply away.

```shell
kubectl apply -f cert-manager/cluster-issuer.yml
```

You won't see anything tangible from this just yet, so the best way to test it out is to create a dummy service and enable TLS for it, which will be covered in the next part of this chapter.
