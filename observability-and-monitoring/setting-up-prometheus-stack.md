# Setting up Prometheus Stack

!!!danger :no_entry: Dependencies required
You'll need to install Helm to continue. If you don't have it yet, refer back to [**:icon-tools: Getting Started**](/getting-started/#helm).
!!!

The default Prometheus/Grafana setup will give you everything including the kitchen sink. At this point in time it's worth keeping all of that around for the sake of learning, but some small modifications are required to make it a bit more secure.

## Requirements

A successful deployment depends on just a few tasks.

- [x] Adding the Prometheus Stack repo
- [x] Defining the values for the Helm chart
- [x] Installing the Helm chart with the configuration
- [x] Exposing Grafana to the internet

Let's take this step by step.


## Add the Helm chart repository

This command won't appear to do much on its own, but it keeps track of charts you want to use. Like adding a dependency, say.

```shell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

This will make a few prometheus-related charts available but when it comes to installing Prometheus, only a specific chart will be used.

## Configure the helm chart

!!!ghost :open_file_folder: Config organisation
How you choose to organise your setup is up to you, but if you're looking for inspiration you can take a look at [**:icon-light-bulb: Organising your config**](/kubernetes-fundamentals/organising-your-config) for inspiration.
!!!

A helm chart is configured using a single _values_ file, and whatever you define there is passed into the chart before installing it. There is no consistent structure for these files, it really depends on the author of the chart.

The structure for Prometheus Stack is... well... [see for yourself :sweat_smile:](https://github.com/prometheus-community/helm-charts/blob/kube-prometheus-stack-16.0.1/charts/kube-prometheus-stack/values.yaml). We're not going to go through roughly 2.5k lines worth of config (no matter how well-documented it is), most of which consists of sensible defaults.

Instead, there is just one thing that is worth tweaking. Save this config into a file:

```yaml helm/prometheus-stack.yml
grafana:
  admin:
    existingSecret: grafana-admin
    userKey: admin-user
    passwordKey: admin-password
```

What is it doing? The default Grafana setup hard-codes a generic admin account and password that is common to all default installations. That is _no bueno_, especially if you decide to expose Grafana to the internet, so this merely replaces the default admin account with one of your own.

### Create your login credentials

Now you need to create a secret and that leaves us at an impasse. It's also not secure to store passwords in plaintext inside your config (which might be a git repo too).

It's better to use the `kubectl` CLI for this, which is not perfect but will do the job for now.

```shell
kubectl create secret generic grafana-admin \
  --from-literal=admin-user=$YOUR_USERNAME \
  --from-literal=admin-password=$YOUR_PASSWORD \
  --namespace prometheus-stack
```

Make sure to swap `$YOUR_USERNAME` and `$YOUR_PASSWORD` with values of your own, of course. Once you run it, it will have stored your new login credentials as a secret in the same namespace that Grafana runs in.

## Install the chart

You now have enough to set up a full-blown monitoring solution! Time to make it happen by running this one simple command:

```shell
helm install prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace prometheus-stack --create-namespace \
  --file helm/prometheus-stack.yml
```

This is likely to take a moment to run, which creates a nice opportunity to explain what you just did.

### Breaking it down

That's a lot of repetition in the command! Let's break it down:

```shell
helm install prometheus-stack prometheus-community/kube-prometheus-stack
```

This installs the chart `kube-prometheus-stack` from the `prometheus-community` repo and names the corresponding release `prometheus-stack`. A release, in Helm terms, is a successful deployment of a chart. Each update creates a new release so you can roll back to previous ones if necessary.

```shell
helm install ... --namespace prometheus-stack --create-namespace
```

It's useful to isolate your deployments to their own namespace rather than dumping them all in the `default` one,and you might as well give it the same name as the release.

!!!ghost :broom: Organising your cluster
In case you missed it, you can find some tips on namespacing and why it's so useful in [**:icon-light-bulb: Namespacing**](/kubernetes-fundamentals/namespacing).
!!!

```shell
helm install ... ... --file helm/prometheus-stack.yml
```

While it's not necessary to provide your configuration in YAML format (you can do it all via the CLI if you're desperate), this is used to configure the values the given chart provides.

You can put this file anywhere; personally I keep them in one folder to make it easier to see what I'm using Helm for.

## Reveal Grafana to the internet

Nothing you've deployed is publicly accessible so far, so assuming you've successfully worked through [**:icon-globe: Internet Exposure**](/internet-exposure), you should have enough in place to change that.

!!!info :shushing_face: Keeping it secret
This step is optional and if you prefer to keep your Grafana deploy private, you can access it through kubectl's port-forwarding mechanism instead. This will expose Grafana at `http://localhost:3000`.

```shell
kubectl port-forward service/prometheus-stack-grafana 3000:80 --namespace prometheus-stack
```
!!!

By default, a service isn't available to the internet at large unless it has an ingress to make it visible. If you're familiar with Apache HTTPD or Nginx then an ingress is something like a virtual host with a reverse proxy.

### Create the ingress config

The Helm chart already did all of the heavy lifting, so all that is required to make the service available is to create an `Ingress` manifest.

```yaml prometheus-stack/grafana-ingress.yml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: grafana
  namespace: prometheus-stack
  annotations:
    kubernetes.io/tls-acme: "true"
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  ingressClassName: nginx
  rules:
    - host: grafana.your-domain.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: prometheus-stack-grafana
                port:
                  number: 80
  tls:
    - hosts:
        - grafana.your-domain.com
      secretName: grafana.your-domain.com-tls
```

### Apply the ingress config

It's helpful to save this in a different directory to the Helm chart configuration, because `kubectl` will complain if you try to apply all of the config in a directory and one of the files is invalid.

Speaking of applying configuration, do that, changing the path to the file if you need to:

```shell
kubectl apply -f prometheus-stack/grafana-ingress.yml
```

### Update your DNS

Depending on your choice of name, this is as simple as adding either a CNAME or A record to your DNS zonefile. For example, `grafana.yourdomain.com` or `grafana.internal.yourname.com` could work.

Once you're done, go ahead and visit the domain. You should be able to log in with the secret you created earlier.
