---
order: -5
---

# Setting up ingress-nginx

!!!danger :no_entry: Dependencies required
You'll need to install Helm to continue. If you don't have it yet, refer back to [**:icon-tools: Getting Started**](/getting-started/#helm).
!!!

The easiest way to set up ingress-nginx is to use Helm, which will take much of the manual labour out of the process. Some charts require more configuration than others, but in this case the goal is to install the chart with configuration that is specific to Hetzner Cloud.

In practical terms, you'll get a new load balancer on the cloud side, and everything you expose to the internet on Kubernetes will go through Nginx.

!!!info :loudspeaker: Get a domain name!
It will be difficult--if not impossible--to continue with this chapter if you don't have a domain name. If you're already working with Hetzner Cloud then you can register a domain [directly through them](https://www.hetzner.com/domainregistration) but it may not be the cheapest option. [CloudFlare](https://www.cloudflare.com) are a great alternative if you are more conscious of price.
!!!

## Requirements

A successful installation will require the following things:

- [x] Configuring and installing the ingress-nginx helm chart
- [x] Applying extra Hetzner-specific config
- [x] Setting up HTTPS (SSL) support with LetsEncrypt

There isn't much more to it than that, so let's get started!

## ingress-nginx configuration

First things first, you'll want to add the Helm repository for ingress-nginx.

```shell
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
```

### Defining the values

The easiest way to configure a Helm chart is to create a new YAML file with the values you want. In this case, you want something like this:

```yaml #6,9 helm/ingress-nginx.yml
controller:
  kind: DaemonSet
  service:
    annotations:
      load-balancer.hetzner.cloud/location: fsn1
      load-balancer.hetzner.cloud/name: your-load-balancer-name
      load-balancer.hetzner.cloud/use-private-ip: "true"
      load-balancer.hetzner.cloud/uses-proxyprotocol: "true"
      load-balancer.hetzner.cloud/hostname: internal.your.domain.name
      load-balancer.hetzner.cloud/http-redirect-https: "true"
```

Note the two highlighted pieces:

| Attribute                              | Description                                                 |
|----------------------------------------|-------------------------------------------------------------|
| `load-balancer.hetzner.cloud/name`     | Name of the load balancer created in Hetzner Cloud          |
| `load-balancer.hetzner.cloud/hostname` | A domain (or subdomain) that points to the load balancer IP |


You'll need to pick a domain name to point to the load balancer this will create, as this is required for adding LetsEncrypt certificate generation into the cluster. I use `internal` as a subdomain like `internal.example.com`, as it's not really something you will share with anyone.

## Installing the chart

Once you've settled on some names for the ingress controller and load balancer, it's time to apply the configuration.

```shell
helm install ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace --file helm/ingress-nginx.yml
```

### Breaking it down

Holy :poop: that's a lot of duplication! Let's break the command down a bit.

```shell
helm install ingress-nginx/ingress-nginx
```

You previously added a helm repo using `helm repo add` and gave it the name `ingress-nginx`, however that is just the name of the repository. The actual chart is called `ingress-nginx` too, so when you combine the two together you get `ingress-nginx/ingress-nginx`. You could give the repository a different name when adding it but then you have to keep track of your custom naming convention.

```shell
helm install ... -- namespace ingress-nginx --create-namespace
```

Kubernetes gives you a `default` namespace by, er, default, but you don't want to dump everything in there because it'll become much harder to manage as you add more and more resources. This tells Helm to install the chart into the `ingress-nginx` namespace and to create the namespace if it doesn't exist already. Similar to before, it's better to keep your naming simple so it's easier to remember what things are when you return to the setup a few months later.

```shell
helm install ... ... --file helm/ingress-nginx.yml
```

The final piece of the command simply tells Helm to read config values from a specific file. While you can do this from the command line directly, it doesn't allow for reproducible installs or seamlessly reconfiguring charts.

## Update the config

The final step is to create a new `ConfigMap` to reflect the configuration on Hetzner Cloud's side:

```yaml ingress-nginx/config-map.yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: ingress-nginx-controller
  namespace: ingress-nginx
data:
  use-proxy-protocol: "true"
```

You can apply it with `kubectl` directly:

```shell
kubectl apply -f ingress-nginx/config-map.yml
```

The ingress controller will update with this config once it's applied.

# Update your DNS

The final step is to point the hostname you chose to the load balancer's IP address, which you can get from the Hetzner Cloud console in the Load Balancers section. You'll need to create an A record, but you can also add an AAAA record for the IPv6 address you will have been provided.

Unfortunately that setup is totally dependent on your domain provider, but the values you need from the load balancer will look like this:

![A screenshot of the load balancer page in Hetzner Cloud](/assets/lb.png)

Once you've confirmed the changes to your DNS you may have to wait a little while for it to propagate, at which point it's time to move on to dealing with SSL encryption.
