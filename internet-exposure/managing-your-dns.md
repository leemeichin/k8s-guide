---
order: -8
title: Managing your DNS
---

After creating so many deployments, logging into your DNS provider to map each service to a domain gets old fast. It would be so much nicer if kubernetes could do that for you, right?

Say no more! Because with the help of `external-dns`[https://github.com/kubernetes-sigs/external-dns], it can.

!!!danger :no_entry: Dependencies required
You'll need to install Helm to continue. If you don't have it yet, refer back to [**:icon-tools: Getting Started**](/getting-started/#helm).

You'll also need to set up your domain name with Cloudflare to follow along, which you should have already if you bought a domain through them. But `external-dns` supports many other providers too.
!!!

You might wonder how this works. The long and short of it is that `external-dns` will keep an eye out for new deployments that have an ingress. For each one it finds, it'll create a DNS record that points back to your cluster.

This goes hand-in-hand with the previous work to set up `cert-manager`, as it will automatically use the domain that you generated a certificate for.

## Requirements

You know the drill. Here's what we need to do:

- [x] Create a Cloudflare account
- [x] Add your domain to Cloudflare
- [x] Change SSL mode to Strict
- [x] Create an API token
- [x] Add the Helm repo
- [x] Install the Helm chart

## Cloudflare setup

If you aren't already using Cloudflare, because your domain was bought elsewhere, all you need to do to catch up is sign up for a new account and then create a new website. Cloudflare will ask for your domain and then walk you through some setup, like changing your nameservers and such. Trust the process, as it were.

### SSL Strict Mode

The next bit is important, because if you don't do it, you'll have problems with endless redirects when trying to access your deployments. This happens because your cluster is already set up to use HTTPS and will automatically upgrade HTTP requests, and Cloudflare's default config conflicts with that.

In order to fix this, go to the _SSL/TLS_ page from the sidebar panel and smash that _Configure_ button<sup>*</sup>. In the section labeled _Custom SSL/TLS_, you want to tick the _Full (Strict)_ option and then save the changes.

### Creating an API token

All you need now is an API token so that your K8S cluster can talk to Cloudflare on your behalf.



<small>*(don't forget to like and subscribe)</small>
