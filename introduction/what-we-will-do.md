---
order: 3
---

# What will we do?

You've got a few options to experiment with K8S; let's just list some out for posterity:

||| :icon-codespaces: Local
- [Minikube](https://minikube.sigs.k8s.io)
- [KinD](https://kind.sigs.k8s.io)
- [Docker Desktop](https://www.docker.com/products/docker-desktop)
||| :icon-server: Hosted
- [K8S (kubeadm)](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm)
- [K3S](https://k3s.io)
- [MicroK8s](https://microk8s.io)
||| :icon-cloud: Managed
- [Elastic Kubernetes Service (EKS)](https://aws.amazon.com/eks)
- [Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine)
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/en-gb/products/kubernetes-service)
|||

While the local tools are great for experimentation, you won't get quite the same experience running K8S on your laptop. The `control plane` that manages your applications will be running on the same virtual machine (VM) as the applications themselves, and generally you won't run a K8S stack on a single machine.

Similarly, we can cross out the **:icon-cloud: Big Cloud** options because they are *prohibitively* expensive and, even taking their free tiers into account, it is trivially simple to make a mistake and get a nasty surprise in your bill at the end of the month. And, truth be told, it's overkill for a hobby project.

That leaves us with... :drum_with_drumsticks: a self-hosted cluster! :partying_face:

We'll be setting up a simple, autoscaling Kubernetes cluster on [**Hetzner Cloud**](https://cloud.hetzner.com) using [**K3S**](https://k3s.io), which is a lightweight version of Kubernetes compared to `kubeadm`, the traditional implementation.

## Then what?

It's not enough to have a cluster, you need to do something with it, and that's where this gets interesting.

After spinning up the servers, we'll cover the following topics and - in future - more:

- [x] Monitoring with Prometheus and Grafana
- [x] Hosting a private Docker registry
- [x] Setting up Nginx and LetsEncrypt for SSL
- [x] Configuring unattended cluster upgrades
- [x] Using Helm
- [x] Deploying an application
- [x] Adding CI with Github Actions
