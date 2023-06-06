---
order: 1
---

# Provisioning the cluster

`hetzner-k3s` makes it trivial to spin up a new K8S cluster inside Hetzner cloud. K3S is similar to vanilla Kubernetes, but is more lightweight and therefore suitable to run on smaller sized clusters.

All it requires is your YAML config and the Hetzner Cloud API token that you should have saved earlier (see [**:icon-tools: Getting Started**](/getting-started/#creating-an-api-token) if you missed that step).

That being said, it's time to put the pedal to the metal!

## Setting up the environment

You won't be able to create the cluster without exposing your API token. `hetzner-k3s` can read it from an env var, so go ahead and do that:

```shell
HCLOUD_TOKEN=<your-api-token>
```

## Applying the config

Double check the config file to make sure you're happy with it and then run one simple command, making sure that you are pointing to the correct config file.

```shell
hetzner-k3s create --config path/to/your/config/file.yml
```

As the CLI tool is doing its work, you'll start to see output similar to this:

```text
Validating configuration......configuration seems valid.

=== Creating infrastructure resources ===
Network already exists, skipping.
Updating firewall...done.
SSH key already exists, skipping.
Placement group cluster-masters already exists, skipping.
Server cluster-cax11-master1 already exists, skipping.
Waiting for server cluster-cax11-master1...
...server cluster-cax11-master1 is now up.

# ...

Deploying Cluster Autoscaler...
serviceaccount/cluster-autoscaler unchanged
clusterrole.rbac.authorization.k8s.io/cluster-autoscaler unchanged
role.rbac.authorization.k8s.io/cluster-autoscaler unchanged
clusterrolebinding.rbac.authorization.k8s.io/cluster-autoscaler unchanged
rolebinding.rbac.authorization.k8s.io/cluster-autoscaler unchanged
deployment.apps/cluster-autoscaler unchanged
...Cluster Autoscaler deployed.
```

## Verifying the setup

If you peek into your Hetzner Cloud console, or if you had it open while running this command, you should immediately see your 'master' server (the control plane). This is expected and everything is ok - it will take a minute or two for your worker node to appear, because the autoscaler is responsible for creating that.

Access to the cluster is configured automatically, and you can confirm by using `kubectl` to watch your worker node appear:

```shell
kubectl get nodes --watch
```

After some time you'll see a second server pop up along side your control plane. This is what it looks like on my setup:

```shell
kubectl get nodes --watch
NAME                               STATUS   ROLES                       AGE   VERSION
epona-cax11-master1                Ready    control-plane,etcd,master   2d    v1.27.2+k3s1
worker-pool-auto-45866f5527727bf   Ready    <none>                      9h    v1.27.2+k3s1
```

Getting output from this command means the cluster setup was successful, congratulations! The problem is that it's not really doing anything yet, so it's time to move on to the fun stuff.
