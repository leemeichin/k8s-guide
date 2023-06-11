# Resources

Now we are firmly in the territory of Kubernetes, it's time to take a brief interlude to understand what a resource config is. If you already understand all of this, skip ahead clever clogs. :wink:


## Resource Configs

A resource config is an `object` that can be written in YAML or JSON but most people use YAML. It represents a `resource` and provides configuration for it.

==- Example deployment resource config

Here's a typical description of a `Deployment` resource:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: blog
  labels:
    app: blog
spec:
  replicas: 1
  selector:
    matchLabels:
      app: blog
  template:
    metadata:
      labels:
        app: blog
    spec:
      containers:
        - name: blog
          image: myregistry/blog:latest
          imagePullPolicy: Always
          ports:
            - containerPort: 3000
```

This resource config describes a deployment of a hypothetical blog that exposes itself on port `3000`. On its own it's not very useful because nobody on the internet will be able to access it, but Kubernetes will be running it nonetheless. A fully working deploy will be covered in a later chapter.
===

Every config for every resource will conform to the same structure. They all have an `apiVersion`, `kind`, and `metadata` that can be used to define labels and annotations. 

### Labels and annotations

Those labels and annotations can merely be descriptive, or they can inform _other_ services how to behave. In a sense, these are how resources can communicate between each other without having to know anything more specific.

This will be covered later, where such annotations and labels are used to configure TLS for an application, enabling `https` support.

## Resources

To do anything useful in a K8S cluster, you have to create _resources_. Resources cover the whole spectrum of what a server can be traditionally expected to do, from supervising services to handling permissions. You'll be creating a number of resources by hand in the following chapters, and you'll get to know some of them more intimately than others.

### Example resources

There are far too many resources to describe all at once, but there a handful that you will see often.

| Resource type  | Description                                                    |
|----------------|----------------------------------------------------------------|
| Pod            | Represents a single instance of an application                 |
| Deployment     | Higher level than pods, handles replication and pod updates    |
| Service        | Makes a pod or deployment available on the internal network    |
| Ingress        | Exposes a service to the internet for public access            |
| ConfigMap      | Stores configuration values that resources can share           |
| Secret         | Creates a secure token that can be provided to other resources |
| ServiceAccount | Extra accounts used for authentication and access control      |

### Custom resources

The K8S API can be extended by defining custom resources, known as Custom Resource Definitions (CRDs). These tell Kubernetes how to deal with things that aren't baked into the standard package, so you can manage other parts of your stack using the same YAML spec as everything else. Or to put it another way, it allows a software author to provide a K8S compatible interface so you don't have to manually wire everything up yourself.

We won't be diving into these in this guide, but there are one or two instances where they will be used.
