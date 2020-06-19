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

I've been researching options for running Docker Containers on Azure, and this
is what I've found. All quotations are for North Europe (Dublin).

# Azure Kubernetes Service

The big daddy. Expensive. Pay-per-VM in your cluster. Powerful. Not serverless,
so patching of VMs, k8s, etc., all required to maintain security. The absolute
smallest cluster you can build (1x B2S node at £0.034/hour) is £24.48/month.
Will kubelet eat up CPU credits? Who knows!

# Azure App Service

Backed by a VM, pricing reflects that, but the VM ("App Service Plan") can be
used to power a number of Azure service options, such as Web Apps, Static Web
Apps, and some Function Apps. Docker containers only supported on App Service
for Linux plans, which are currently at Basic and above only: £9.79/month.

# Azure Container Instances

Serverless k8s, but without the control over deployment, etc., that plain k8s
offers. Like doing your k8s orchestration with ARM :tada: Consumption-based
pricing means you pay for number of CPUs and amount of RAM over the amount of
time they're in active use. The "quick start" example running nginx is pretty
small: 1 vCPU, 1.5GB RAM, and is £26.16/month.

# Azure Functions

Not available in the Consumption plan because it is dependent on pre-warmed
instances, which are a feature of the Premium plan, and consumption-based
pricing is available via Azure Container Instances. Pricing is not cheap,
starts at £0.16/hr, or £113.52/month. Available much more cheaply as part of a
App Service for Linux plan, but then a question over "why Functions?" for a
plain HTTP app.
