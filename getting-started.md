---
icon: tools
---

# :icon-tools: Getting Started

Time to get crack-a-lacking! But first...better make sure you've got all the tools you'll need.

## Hetzner Cloud

You'll require an account with [Hetzner Cloud](https://cloud.hetzner.com) to make any progress. You can sign up yourself or use my referral link to get an initial account credit; totally up to you. 

Once you're in, you'll need to procure an API token.

!!!success :money_with_wings: Referral discount
If you want to follow this guide step by step, you can sign up for a Hetzner account using this referral link: https://hetzner.cloud/?ref=B6gbvFr2BAxH.

You'll receive **€20** in credits which will cover the hosting of this cluster for a month or two. I'm not receiving payment to shill this, unless you continue to host the cluster after spending your credits.
!!!

### Creating an API token

Create a project in the Hetzner UI and give it a nice name, then go inside the project and navigate to the **:icon-key: Security** page from the left-hand nav-bar. Go to the **API tokens** tab and then you'll see the option to generate an API token.

Make sure your API token has **read and write** permissions. If you forgot to set that, you can edit the token to change it.

!!!warning :icon-lock: Safe storage
You will only get one chance to copy the API token, so make sure to put it somewhere safe, like in your password manager.
!!!

## A domain name

While you'll be able to work fine with pure IP addresses, this guide will work best if you have a domain handy, especially when it comes to setting up LetsEncrypt for SSL certificates. You don't need to use the top-level of your domain, a subdomain will do just fine too.

!!!ghost :pray: I don't have a domain
Domains cost money, which is not great if you're on a tight budget or sensitive to costs, especially if you don't intend to keep the domain in the long run.

A future version of this guide will provide ready-made subdomains to help out.
!!!

## Command line tools

Instructions will vary depending on your operating system, but you'll need the following:

!!!ghost Windows support
If you're doing this on Windows, your best bet is to use [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) with Ubuntu and follow instructions for Linux.
!!!

### [hetzner-k3s](https://github.com/vitobotta/hetzner-k3s) 
[!badge variant="danger" text="required"]

This is a little program that will do the heavy lifting for us when creating a cluster.

!!!ghost Why not Terraform?
You can achieve the same result by building a configuration in Terraform, providing some more control over the provisioning of your cluster. This is currently out of scope for the guide for the sake of simplicity, but may be considered as an extra chapter in future.
!!!

### [kubectl](https://kubernetes.io/docs/tasks/tools) 
[!badge variant="danger" text="required"]

While it's also a dependency for `hetzner-k3s`, you can't work with a K8S cluster without this.

### [helm](https://helm.sh/docs/intro/install)
[!badge variant="danger" text="required"]

Helm is a package manager for K8S and makes it easier to deploy pre-packaged software to the cluster. We'll be using this a lot to avoid having to set up certain services by hand, as they tend to come with sensible defaults.

## Bonus goodies

### [Lens](https://k8slens.dev/)
[!badge variant="ghost" text="optional"]

Lens is a desktop app that presents a comprehensive GUI for your K8S cluster. If you're not sure where to start with the `kubectl` CLI then you might find this useful for exploration.

### [k9s](https://k9scli.io/)
[!badge variant="ghost" text="optional"]

I can recommend k9s if you prefer to stay in the terminal but would still prefer a more discoverable, visual UI over `kubectl`.


