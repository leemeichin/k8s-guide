---
order: -1
---

# Package management

You're probably accustomed to the concept of packages, libraries or modules in your programming language of choice and you might wonder if Kubernetes has something similar.

The answer to that is yes... and no. Being declarative and configured entirely through YAML, you can't necessarily 'script' your cluster to implement custom behaviour. If you want to do that, then you need to deploy something into the cluster in the form of a workload (a deployment, pod, daemon, and so on - we'll get to that later).

That said, you can still abstract the YAML itself and create reusable, shareable configurations, and there are a few options for that:

## [Kustomize](https://kustomize.io)

Now built into `kubectl`, kustomize allows you to compose and parameterise your manifests. The common use-case will be to swap out certain values based on the environment you're applying the configuration to (e.g. development, staging, production), but it can also come in handy when sharing a manifest and describing what should be customised before use.

## [Helm](https://helm.sh)

Helm looks and feels like a more traditional package manager and it makes it easy to deploy more complex applications that might otherwise take several steps to do manually. It uses `charts` to abstract over the various resources an application might require, where each chart exposes its own YAML interface for configuration. In that sense, charts are simply collections of templated YAML files and Helm itself tracks their state in the cluster, allowing for version upgrades and rollbacks.

Consequently, it also means you can package your own applications into reusable charts which you can then share publicly or just use for yourself to avoid copy/paste work across projects.

We'll be using Helm to install ready-made charts later on.

!!!light :raised_hands: I want custom charts!
If you're interested in creating a custom chart and want to know how to do it, drop an issue on the [**:icon-mark-github: Github repo**](https://github.com/leemeichin/k8s-guide) to propose it as a chapter.
!!!

## [Operators](https://operatorhub.io/)

Operators follow a pattern proposed by Kubernetes and add extra automation capabilities to a cluster. An operator will typically come with a collection of Custom Resources that you will use to describe what you want to do, and it is then the job of the operator to make that happen. One example of this is an operator that that reads the labels and annotations of `Ingress` objects to set up SSL or configure Nginx parameters, but you can also have operators that automatically restart your depoloyments if an environment variable or secret is updated.

In the simplest scenarios an operator may feel a bit like a package, not unlike a Helm chart, as they too can automate the process of painstakingly writing dozens of YAML configurations. They're not mutually exclusive though and depending on the complexity and scope of an operator, you might still find a Helm chart that provides an out-of-the-box setup for you.

We will be working with at least one operator throughout this guide, although not explicitly so.
