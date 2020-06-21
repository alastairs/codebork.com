---
title: Options for running Docker Containers on Azure
author: Alastair Smith
category: ops
created: 1592600136
tags:
        - ops
        - donabase
        - azure
        - docker
        - containers
        - serverless
        - orchestration
---

Earlier this year I had some time off between jobs, and I used the opportunity
to put some life into an idea I've been wanting to work on for nearly a decade
now. I need to run the project on only a small budget, and therefore need to
keep hosting costs down. On the other side of the coin, I really like the
workflows I built around Docker, and want to continue building on those. As
such, I've been researching options for running Docker Containers on Azure,
beyond the obvious orchestration example of Kubernetes. This blog post is a
summary of what I've found so far. All quotations are for North Europe (Dublin):
whilst all are available in UK South (London), the region is at least
second-tier when it comes to updates, previews, etc., and is not as cheap as the
North Europe region on some services. The prices are in GBP as I am based in the
UK and billed in GBP. All prices converted to monthly equivalent costs are based
on a 730-hour month.

I've divided the options into Infrastructure-as-a-Service (IaaS) and
Platform-as-a-Service (PaaS) options. While all of the PaaS options can be
considered "serverless", only one offers consumption-based pricing: Azure
Container Instances (ACI).

# Infrastructure-as-a-Service (IaaS)

As with everything in life there are pros and cons to both IaaS and PaaS. The
pros of IaaS are greater control over your resources and infrastructure, and the
ability to more finely-tune your set-up for your application. The downside is a
greate administrative burden, in the form of patching and updating your virtual
machines' operating systems, installed software, etc., as well as your own
application.

## Azure Virtual Machines

It's fair to say that, with a virtual machine in the cloud, you can do basically
anything you want. It's certainly the case that one _could_ run Docker
Containers on Azure Virtual Machines, and if one is working solely with
Docker Compose, this might not be a bad solution. As we'll see, however, there
are better options for deploying Docker Compose configurations on Azure.

The cheapest pay-as-you-go VM available on Azure is the B1S "burstable" VM.
These allow you to accrue CPU "credits" during periods of VM inactivity that can
be redeemed during periods of high activity. When the available credits have been
exhausted, the VM CPU resource is severely limited. The B1S VM is £0.0084/hour or
£6.19/month.

### A word on spot instances

The newer "spot instances" are a lot cheaper than this, with Azure's pricing
pages boasting discounts as high as "~90%", and this is the absolute cheapest
option for doing basically anything on Azure, **provided you're willing to put
the work in:** in the case of running a Docker Compose application, this means
spinning up a new spot VM and deploying the application to that each time a VM
was terminated. This can be achieved via in-VM notifications, but as far as I'm
aware there's no turn-key solution for this: even VM Scale Sets will only handle
so much of the process. That said, a D2a v4 spot instance will set you back
roughly the same amount per month as a B1S and is a much beefier VM with 2 vCPUs
and 8GB RAM, but the cheapest spot instance I could find was an F1 at
~£5.3450/month, with 1 vCPU and 2GB RAM. This might be appropriate for a very
small workload, but for the money I'd vouch that a D2a v4 represents better
value given the additional work required.

**Conclusion:** cheap, but a lot of extra effort required to handle deployments.

## Azure Kubernetes Service (AKS)

AKS is the shire horse of container workloads on Azure: it will handle any
workload you care to throw at it, and as a result is big, powerful, and
expensive. There's plenty to take care of yourself too: as mentioned at the
beginnig of this section, you will need to patch your VMs' operating systems and
other software, including staying on top of Kubernetes (k8s) updates. At the
time of writing, AKS defaults to k8s 1.15.11, and offers 1.16.8 and .9 as
fully-supported releases. If you want the newer 1.17 and 1.18 release streams,
you're relegated to "preview"-level support, and herein lies the rub with hosted
k8s solutions: they all track a version or two behind upstream Kubernetes. Given
k8s releases a minor version each quarter, the default release stream AKS offers
is a whole year behind upstream.

Only some VM types are supported in AKS, and as a result the absolute smallest
cluster you can build is 1xB2S node, which is £0.034/hour, or £24.48/month. I
have left as an open question whether or not Kubernetes processes such as
kubelet will consume CPU credits and make this impractical, but given the
smaller B-series VMs are not supported, I would hazard a guess that it won't
consume all the VM's credits...

AKS now supports spot instances in a secondary node pool, but not in the primary
node pool. This makes sense from a technical perspective, but means that the
spot instances are an incremental cost over the ~£25/month base price. The
cheapest spot instance VM available in AKS is the DS1v2 offering 1 vCPU and
3.5GB RAM for ~£36/month. I haven't worked out why there is a >2x discrepancy
between the spot pricing for this level in AKS vs. as a standalone VM, where the
cost is advertised as ~£15/month.

Finally, AKS offers an interesting scalability feature that allows a cluster to
"break out" into Azure Container Instances for scheduling in times of high load.
There are some [known
limitations](https://docs.microsoft.com/en-gb/azure/aks/virtual-nodes-portal#known-limitations)
that may not make this a slam-dunk option (e.g. the fact that these virtual
nodes won't run DaemonSet resources), but it can certainly be a cost-effective
way to scale.

**Conclusion: £25/month base price is affordable, but the available resources
are small and the incremental cost of scaling out is at least £25/month.**

# Platform-as-a-Service (PaaS)

PaaS offerings are becoming much more popular as people realise the benefits of
not administering their own servers. To my mind this is equivalent to the notion
of "serverless", although some prefer to keep to a stricter definition involving
code-to-platform deployment and consumption-based pricing (e.g. Azure Functions,
AWS Lambda, etc.). Some of these offerings, such as Azure App Service and Azure
Functions are "all-inclusive", meaning that custom domain names, public IP
addresses, etc., are included in the plan price.

## Azure App Service

Azure App Service is a well-established product on the platform at this point.
Introduced as Azure Websites in the early 2010s, it was Microsoft's response to
services such as Heroku offering repository-to-platform deployment. Since then
it has grown to encompass a number of products across web, mobile, API, and
process automation.

Under the covers, Azure App Service is backed by a VM running Microsoft's [Kudu
project](https://github.com/projectkudu/kudu/), and the pricing levels reflect
this. Lower-priced tiers co-locate your app(s) with others', and offer fewer
platform features; higher-priced (production-ready) tiers offer "dedicated
compute" (i.e., your own VM) and features such as deployment slots and SSL
connections.

From a Docker perspective, containers are only supported on App Service for
Linux plans, which excludes the lower-priced co-located resources. The Basic
tier App Service for Linux plan is £0.013/hour, or £9.79/month, but beware of
the up-sells to services such as Azure Front Door which can be very pricey.

## Azure Container Instances (ACI)

Azure Container Instances is an interesting and novel service, and, if memory
serves, one of the areas Microsoft led the market with compute offerings. At its
heart, ACI is a fully-hosted Kubernetes, where the nodes are abstracted away
from you as well as the control plane. Unfortunately, however, it is not
possible to deploy ACI containers with standard k8s tooling beyond the one-off
`kubectl exec` unless you use ACI as a virtual node with AKS. As a result, the
orchestration concerns of container deployment need to be implemented with Azure
Resource Manager templates, which is ... not ideal. (There is support for YAML
manifests, which is easier than ARM templates, but it's only "Kubernetes-like").

That said, fully serverless k8s is rather exciting, and the consumption-based
pricing can be cost-effective for deploying self-contained apps such as Grafana,
Kibana, etc. A 1 vCPU, 1GB RAM container (sufficient for Kibana workloads at
least) will set you back ~£25/month. A 1 vCPU, 1.5GB RAM container (for, e.g.
nginx) is only another ~£2/month. These resources are assigned per "container
group" rather than per container, which translates to a pod in k8s terminology,
so a side-car container will run very cost-effectively.

Given the elastic nature of ACI, it's probable this is best suited to elastic
workloads, such as data-processing and service workers. Unlike Azure App
Service, ACI is not "all-inclusive" and only provides the compute resources.
Public IP addresses for ACI container groups are an add-on component and billed
at the standard ~£2/month.

## Azure Functions

Finally, it's possible to run containers from Azure Functions. At the time of
writing, I'm not convinced of the benefits of doing this, not least because
containers are not supported on the consumption plan for Functions; if this is
something you're after, then ACI represents the best option here.

The two options for running containers on Azure Functions are on the Premium
plan, and the Dedicated plan. The Dedicated plan backs your Functions app with
an App Service plan, and pricing is then the same as for Azure App Service
above. If you're writing a plain HTTP app, then I'd suggest that Azure App
Service is the better product to pick; if, however, you're looking to take
advantage of triggers from other platform products such as CosmosDB without
writing your own integration code, this can be a good option for your app.

The Premium plan provides pre-warmed instances, so if you have other Functions
app requiring this level of service, piggy-backing your containers onto the same
plan could be sensible. For just running containers, however, the £0.16/hr,
£113.52/month is prohibitive compared with the other options previously
discussed.

# Comparison and Conclusion

| Service                       | Unit price/month | No. of units | Ease of deployment | CPU Cores | RAM (GB) | Value for Money |
| ----------------------------- | ---------------- | ------------ | ------------------ | --------- | -------- | --------------- |
| **Virtual Machines**          |                  |              |                    |           |          |                 |
| B1S                           | £6.19            | 1            | 0.01               | 1.00      | 4.00     | 0.0065          |
| D2av4 Spot                    | £6.04            | 1            | 0.01               | 2.00      | 8.00     | 0.0265          |
| **Azure Kubernetes Service**  |                  |              |                    |           |          |                 |
| B2S                           | £24.48           | 1            | 10.00              | 2.00      | 4.00     | 3.2680          |
| D2v4                          | £58.22           | 1            | 10.00              | 2.00      | 8.00     | 2.7482          |
| **Azure App Service**         |                  |              |                    |           |          |
| Linux Basic                   | £9.79            | 1            | 10.00              | 1.00      | 1.75     | 1.7875          |
| **Azure Container Instances** | £27.00           | 4            | 5.00               | 1.00      | 1.00     | 0.0463          |
| **Azure Functions**           |                  |              |                    |           |          |
| Dedicated                     | £9.79            | 1            | 10.00              | 1.00      | 1.75     | 1.7875          |
| Premium                       | £113.52          | 1            | 1.00               | 1.00      | 1.00     | 0.0088          |
