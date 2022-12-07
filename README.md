# I'm learning K8S !

On my way to my CKA.  Working through [Linux Foundation Kubernetes Fundamentals LFS258](https://trainingportal.linuxfoundation.org/learn/course/kubernetes-fundamentals-lfs258).

Because I like to optimize my learning and enjoy the feeling of my head esplode (sic), I'm using GCP instead my comfortable AWS.  And I'm learning/using Terraform instead of the GCP console and CLI for provisioning resources.

For extra fun, I'm taking the recommended detour of setting up [Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way).

I've created this repo so you can both follow me on my journey (yay me!) and more importantly glean something extra if you take the same journey (yay you!).  You can follow me on [LinkedIn](https://www.linkedin.com/in/mikejansen/) as I intend to post my progress.

This is mostly a raw tree of my work but I'll seek to add notes and such to help follow it.

`README.md` files are in each folder instead of all in this one.

I'm using Ubuntu Linux 20.04 in WSL 2 on Windows 11, VSCode with remote extension.  Everything I'm doing is specific to Linux.

## Prerequisites

If you're following along with what I'm doing, here's what you need:

1. Linux
1. Create a [Google Cloud](https://console.cloud.google.com) account 
1. Install and configure [gcloud](https://cloud.google.com/sdk/docs/install)
1. Install [Terraform](https://developer.hashicorp.com/terraform/downloads)
1. Install [jq](https://stedolan.github.io/jq/download/).

## Where to start?

I started with [Linux Foundation Kubernetes Fundamentals LFS258](https://trainingportal.linuxfoundation.org/learn/course/kubernetes-fundamentals-lfs258).  This is a paid class.  (I won't share stuff from the class, just what I'm doing on side exercises.)  [Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way) was referenced as a good place to learn how to manually install Kubernetes, so I'm detouring to work through it.

## Configurability Scratch Pad

* Control Plane CIDR/IPs
* Node CIDR/IPs
* Service Cluster CIDR
* Pod Cluster CIDR
* Number of Controllers
* Number of Nodes

