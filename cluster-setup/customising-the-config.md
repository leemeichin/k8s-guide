---
order: 2
---

# Customising the config

We should be clear on what kind of cluster to provision now, so it's time to put the YAML together.

Here's what the config looks like in full, with the notable parts highlighted.

```yaml !#1,3-5,21,26-27 k3s-config.yml
cluster_name: your-cluster-name # name your cluster here
kubeconfig_path: "~/.kube/config"
k3s_version: v1.27.2+k3s1 # run `hetzner-k3s releases` to find available versions
public_ssh_key_path: your-ssh-public-key # recommended to use `ed25519` for the key, not default `RSA`
private_ssh_key_path: your-ssh-private-key
use_ssh_agent: false
ssh_allowed_networks:
  - 0.0.0.0/0
api_allowed_networks:
  - 0.0.0.0/0
private_network_subnet: 10.0.0.0/16
schedule_workloads_on_masters: false
image: 103908130
autoscaling_image: 103908130
masters_pool: # this is the control plane
  instance_type: cax11
  instance_count: 1
  location: fsn1
worker_node_pools:
  - name: worker-pool-auto
    instance_type: cax11 # this is the smallest available arm64 instance
    instance_count: 1
    location: fsn1
    autoscaling:
      enabled: true
      min_instances: 1
      max_instances: 2 # change this to increase scaling capacity
additional_packages:
  - unattended-upgrades
  - update-notifier-common
post_create_commands:
  - sudo systemctl enable unattended-upgrades
  - sudo systemctl start unattended-upgrades
```

This isn't a Kubernetes manifest, so it looks a little different to what will follow. You'll only need to touch this in future if you feel like adding more autoscaling nodes, worker pools, or maybe even creating a High Availability (HA) cluster instead.

!!!info :bulb: High availability?
A high availability cluster is one that has multiple control plane instances rather than just one. There will always be an odd number of them, and it means that the cluster will continue operating if one of the control plane instances goes down.

A production-grade cluster will place each instance in a different region, in case the data-centre the instance is hosted in is impacted (for example by fire or a natural disaster).
!!!

### SSH key generation

It's important to make sure you provide an SSH key using a more modern encryption algorithm than the default RSA one. If you don't already have these, you can create a fresh keypair with `ssh-keygen`:

```shell
ssh-keygen -t ed25519 -f ~/.ssh/k8s_ed25519 # or some other filename
```

Whether using an existing key or a fresh one, make sure to update the YAML config with the path to the private key and corresponding public key.
