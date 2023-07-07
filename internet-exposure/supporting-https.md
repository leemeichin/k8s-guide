---
order: -6
---

# Supporting HTTPS

Once upon of time it cost a webmaster a lot of money to enable support for HTTPS, as the SSL certificates required to do so didn't come cheap and encryption was a little more taxing on the CPUs of the time. The concept of getting a certificate for free, let alone HTTPS being ubiquitous, didn't even exist until around ten years ago!

Nowadays it is more strange to *not* support HTTPS and browsers will complain about your old-fashioned HTTP pages being insecure.

==- :sweat_smile: HTTP, HTTPS, SSL, TLS...WTF?
Not even two paragraphs into this page and there are acronyms flying all over the shop. While each one has specific technical nuance, you can pretty much assume that HTTPS, SSL and TLS in the context of serving a website are referring to the same thing: applying end-to-end encryption to a connection to prevent bad actors from snooping on the data.

In such a case, HTTPS is the protocol which informs both the browser and server that the request is encrypted and, while SSL used to be responsible for encryption and decryption, TLS has since taken its place as an upgraded version.

For what it's worth, this applies just the same to WebSockets with `ws://` and `wss://`. The extra `s` means `secure`.
===

## Overview

There is no single correct way to deal with TLS or encrypted traffic in Kubernetes, it will always differ depending on your situation, but you'll take a fairly simple and effective approach in this guide.

!!!warning :thinking_face: Networking recap
In case you missed it, check out [**:icon-globe: Networking**](/kubernetes-fundamentals/networking) for a quick refresher on public and private networking.
!!!

It's useful to know a couple of concepts before diving in head first.

## TLS termination

Our use-case is basic: there is a Kubernetes cluster that exposes some web services to the internet and those services are accessible through a domain and HTTPS. All of the traffic coming into the cluster from the outside should be TLS encrypted, and when it hits the cluster's load balancer it will be decrypted. This is referred to as **termination**, as in: *"where is the encrypted connection terminated (decrypted) and thus becomes cleartext?"*

When the load balancer handles the termination, the entire cluster can read the data in the connection and workloads don't need to worry about handling that themselves. It makes life easy and, similarly, it means that services that communicate entirely on the internal network will not bother with TLS either because it is presumed that it's secure *enough*.

### HTTPS... everywhere!?

You might think: *"can't I make it even more secure by encrypting everything and using HTTPS **everywhere**"*?

eThe answer is, **probably not**. But if you think it probably is then it's out of scope for this guide.

## LetsEncrypt and Certbot

[LetsEncrypt](https://letsencrypt.org) is a *certificate authority*, meaning that it is a trusted source that can provide TLS certificates to anyone who wants one. It does this for free, so you can use HTTPS for any domain you own at no cost.

[Certbot](https://certbot.eff.org/) automates the provisioning of said certificates and integrates neatly into a lot of modern tooling.

The integration of LetsEncrypt and Certbot, along with the standards that came with them, has become so ubiquitous that you are unlikely to need to interact with these manually. In the case of Kubernetes there is an integration that can watch for new ingresses and then create and store new certificates for them.




