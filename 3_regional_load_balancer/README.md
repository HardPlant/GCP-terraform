## Overview

Load balancing on Google Cloud Platform (GCP) is different from other cloud providers. GCP uses forwarding rules instead of routing instances. These forwarding rules are combined with backend services, target pools, URL maps and target proxies to construct a functional load balancer across multiple regions and instance groups.

Terraform is an open source infrastructure management tool that can simplify the provisioning of load balancers on GCP by using modules.

## Terraform Modules Overview
The repository you'll use in this lab has some load balancer modules. First we'll explain what the modules are, then you'll clone the repository and use them.

### terraform-google-lb (regional forwarding rule)
This module creates a TCP Network Load Balancer for regional load balancing across a managed instance group. You provide a reference to a managed instance group and the module adds it to a target pool. A regional forwarding rule is created to forward traffic to healthy instances in the target pool.

### terraform-google-lb-http (global HTTP(S) forwarding rule)
This module creates a global HTTP load balancer for multi-regional content-based load balancing. You provide a reference to the managed instance group, optional certificates for SSL termination, and the module creates the http backend service, URL map, HTTP(S) target proxy, and the global http forwarding rule to route traffic based on HTTP paths to healthy instances.

### repo

git clone https://github.com/GoogleCloudPlatform/terraform-google-lb
cd ~/terraform-google-lb/examples/basic