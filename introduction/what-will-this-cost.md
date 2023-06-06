---
order: 1
---

# What will this cost?

Hetzner Cloud was chosen specifically because of its low-cost hosting in comparison to other providers such as Linode, Digital Ocean and Vultr.

!!!success :money_with_wings: Referral discount
If you want to follow this guide step by step, you can sign up for a Hetzner account using this referral link: https://hetzner.cloud/?ref=B6gbvFr2BAxH.

You'll receive **€20** in credits which will cover the hosting of this cluster for a month or two. I'm not receiving payment to shill this, unless you continue to host the cluster after spending your credits.
!!!

## Cost breakdown

Assuming you follow the configuration in the guide (prices correct at the time of writing):

| Resource                          | Quantity  | Per Unit | Total Per Month                    |
|-----------------------------------|----------:|---------:|-----------------------------------:|
| CAX11 ARM Server (4GB RAM/2 vCPU) | 2 (max 3) | €4.55    | €9.10 (max €13.65)                 |
| Load balancer                     | 1         | €6.47    | €6.47                              |
| Storage volume (10GB)             | 1         | €0.53    | €0.53                              |
|                                   |           |          | **<ins>€16.10 (max €20.65)</ins>** |

This is based on running a simple autoscaling cluster with one server for the control plane, and a worker pool with a minimum of one server and a maximum of two. The storage volume is for the private Docker registry, and the load balancer is to expose services in the worker pool to the internet.

Of course, you can expect the breakdown to change if you want a larger autoscaling capacity.
