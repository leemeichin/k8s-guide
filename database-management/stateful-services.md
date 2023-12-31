
Hosting a collection of static websites is all well and good, but at some point you might require something a little bit more dynamic. Perhaps an API or a web app that requires the storage and querying of data across many sessions.

There are plenty of services out in the wild that will offer to manage a database for you, all with their own different use-cases. Aurora, for example, is a modified version of PostgreSQL (Postgres) that AWS will manage for you. Supabase is another pretty modern adaptation of Postgres that layers its own functionality on top.

This is all well and good, but what about hosting your own database like it's 1999?

!!!info Persistent databases in K8S
For a long time it was recommended *not* to host your own databases inside a Kubernetes cluster. There was good reason for it too, as it was more difficult to manage and not as reliable as hosting outside of Docker.

This is no longer the case and self-hosting is now a viable option. It's also much simpler to set up now than it used to be.
!!!

In this chapter, you will ultimately end up with a functioning Postgres cluster in your, er, cluster. It will be big enough for toy projects and experiments, but not so big that it will force you to scale up your cluster even more.
