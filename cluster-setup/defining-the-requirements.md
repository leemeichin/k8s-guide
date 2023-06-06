---
order: 3
---

# Defining the requirements


Before continuing though, let's run through the specification of the cluster to be created, both in terms of the hardware and what it should support:

- [x] Servers should be the smallest ARM64 instances available (CAX11)
- [x] The region must be one that offers ARM64 instances (Falkenstein)
- [x] There should only be one control plane instance
- [x] Autoscaling should be enabled
- [x] The worker pool should contain a minimum of one instance
- [x] The worker pool should scale up to a maximum of two instances
- [x] Unattended upgrades should be enabled

Once we create the configuration for this, we should expect to see two servers in the Hetzner Cloud console: one will be for the control plane, and another will be a worker node.


!!!info :bulb: What's a control plane?
The control plane manages the worker nodes and pods in the cluster, ensuring that worker nodes are scaled and that pods are efficiently assigned across those nodes. This is what makes it possible to run multiple copies of the same application and to distribute the load between them in large clusters, meaning that scaling can be achieved by adding more servers (horizontal scaling) rather than increasing the CPU and RAM of an existing one (vertical scaling).

Historically this was called the master node, although that terminology is now dated.
!!!
