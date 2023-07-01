---
order: -6
---

# Networking

Workloads in a Kubernetes cluster, by default, will not be accessible from the public internet. In fact, the only thing that _is_ accessible by default is the control plane, as that is required to authenticate with and configure your cluster.

While any resource in K8S can connect to the internet (e.g. to call an external API), extra steps have to be taken to allow strangers on the internet to access the things you deploy on the cluster. In more technical terms, the former is known as network _egress_, and the latter is known as _ingress_.

There is a little more nuance to it than that though, and it's easier to break it down into two parts: internal networking and public networking.

## Internal networking

It's typically the _done thing_ to provision servers (K8S cluster nodes included) on private networks, limiting their exposure to the internet as a whole. There are a lot of reasons to do this, but the most intuitively benefician one is for security: if your cluster doesn't have a public IP address then nobody in the public can connect to it.

The process of setting up this kind of network depends on the provider you use and how they've chosen to abstract it. In the world of **:icon-cloud: Big Cloud** you'll be messing around with VPCs and Security Groups and who knows what else; in our Hetzner-based setup the YAML configuration included the provisioning of a private network automatically, along with a firewall that heavily restricts access to the control plane. It's not important to know the intimate details all at once, anything relevant will be explained when it presents itself.

Internal networking, particularly within a K8S cluster, can be as complicated as you want it to be. The default setup is good enough for us though.

### Service discovery

You could be hosting dozens of workloads on your cluster, as you would with a microservice architecture. Naturally, some of those workloads may need to communicate with each other over the network.

How do they do that? Via _service discovery_.

When you create a new service (as in, a `Service` resource in K8S terms), you expose a workload to the internal network by wiring it up to a port. This assigns the workload a virtual IP address, available at the configured port.

!!!info :whale: Docker familiarity
If you're familiar with Docker and Docker Compose, this is the same as mapping the port you `EXPOSE` inside a container to a port on your machine so you can connect to it in your browser.
!!!

Kubernetes knows that, when you create a service, you have a workload that is available to the rest of the network and it will assign an internal domain name, typically of the format: `service-name.namespace.cluster.svc.local`. The cluster operates its own DNS server in order to make that happen.

### Load balancing

Chances are that if you're using Kubernetes, you're running multiple replicas of workloads in order to horizontally scale. Services attached to those workloads are automatically load-balanced even when they're not public.

### Use cases

It's wise to limit the accessibility of any workload as much as is reasonable. If it's not meant to be public, best to leave it all private.

#### Databases and sensitive data

There is rarely a reason to give a database server pure, unfettered public access. This opens the door to malicious actors manipulating or stealing your data.

Keeping your databases--or anything that is sensitive for that matter--private, is low-hanging security fruit.

#### Internal APIs

You might have a primary web-app that most of your users access, and there's really no need for them to have visibility on anything that application accesses behind the scenes.

#### Egress-only workloads

There are also things you may operate in your cluster that simply work in the background. Jobs, cron jobs, message queues, workers, and so on.

## Public networking

There are a number of simple ways to provide public access to a workload in your cluster, but this guide will focus only on one: ingress.

!!!ghost :bulb: What are the alternatives
One is likely to cost you a lot of money: a service with the `LoadBalancer` type.
Another will simply expose the same port on every node in your cluster: a service with the `NodePort` type.
!!!

### Ingresses

If a `Service` puts your workload on the network, then an `Ingress` makes it visible to everyone and will route external connections to the specified service. 

To put it another way, they're Kubernetes' version of a virtual host in Apache HTTPD, or a reverse proxy server in Nginx, and you can achieve more-or-less the same as those through YAML. You can point your own domain names to them.

As it happens, they'll also handle the provisioning of SSL certificates (via LetsEncrypt/certbot) and TLS termination, so you can easily use `https` with them and also enforce it.

In a cluster with multiple nodes like yours, ingress resources typically depend on a load balancer (LB)...

#### Load balancers

By default, creating an ingress may provision an entirely new load balancer in your hosting account, which is _far_ from ideal. They're not cheap, especially if everything you host has its own LB.

However, it's helpful--if not necessary--to have at least one of them as they will distribute incoming traffic to your service based on your configuration.

It's therefore expedient to tell Kubernetes what to do whenever you create a new ingress.

#### Nginx Ingress

Thankfully, Kubernetes provides a first-party Nginx integration. This sets up an `IngressController` (as in, something that controls the creation of `Ingress` resources) and, in the simplest terms, means you get to use just one load balancer to route traffic in your cluster. You'll be setting this up later on.

While Nginx is not the only offering in this space, it's arguably the easiest thing to start with compared to altneratives like [Traefik](https://traefik.io) or [Istio](hjttps://istio.io).

## Use cases

### Giving a service a domain

Even if a service is public, it's likely to be authenticated in other ways, maybe even by a VPN. It's useful for internal tooling.

### Hosting your websites and public APIs

This guide is hosted as a static website on Kubernetes. You can check the Dockerfile and CI workflow on [**:icon-mark-github: Github**](https://github.com/leemeichin/k8s-guide).
