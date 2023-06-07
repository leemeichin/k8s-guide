---
order: 5
---

# Why monitoring?

What good is a server if you can't keep an eye on its performance? And what better way to monitor performance than to look at some pretty dashboards?

The study of observability in software is vast and can admittedly be quite intimidating at first -- there are entire books dedicated to this specialism after all ([Practical Monitoring](https://www.oreilly.com/library/view/practical-monitoring/9781491957349) is one I can recommend). What you achieve in setting up monitoring through this guide will only scratch the surface of what is possible.

I haven't answered the question yet though, have I? In a production grade system like one you might work with at your job, the purpose of observability (often shortened to `o11y` out of sheer laziness) is to gain enough inside into your infrastructure in order to proactively resolve problems before they escalate into something much worse. To put it another way, a strong o11y story gives a team the power to work _proactively_ rather than _reactively_, and this is vital when it comes to dealing with critical incidents. Everything can be monitored, from resource usage to error frequency to network bandwidth and traffic, and from there it can be analysed to provide deeper insights into your infrastructure.

You're not running a production grade cluster here though, right? Monitoring is still useful, if not critical. The motivation for setting it up in this guide is partly for fun and for learning, with the added bonus of providing something to work with if you choose to experiment later on.

The default dashboards made available will be fairly simplistic, but will show you how much of your cluster is being utilised as you build it out. If you chose to install Lens to view your cluster, it will also provide simple metrics based on data collected by the cluster.

There are a wealth of tools and services out there that provide monitoring for Kubernetes. [NewRelic](https://www.newrelic.com) and [Datadog](https://datadog.com) are two notable, albeit expensive, examples. You might also have heard of [OpenTelemetry](https://opentelemetry.io) which provides an open source specification for collecting metrics.

## Prometheus and Grafana

For the sake of simplicity (and cost), this guide will use [Prometheus](https://prometheus.io) and its friend [Grafana](https://grafana.com). Prometheus will collect the metrics in your cluster, Grafana will visualise them, and what's more...both are open source and incredibly well supported. You can monitor a lot more than just Kubernetes if that floats your boat.

It can take a bit of effort to tailor your dashboards to be juuuuust how you like them, so for the sake of the guide it will only walk through the process of setting everything up and creating a simple dashboard.

!!!light :raised_hands: I want to know more!
If you're interested in more coverage around monitoring and observability, drop an issue on the [**:icon-mark-github: Github repo**](https://github.com/leemeichin/k8s-guide) to propose it as a chapter.
!!!
