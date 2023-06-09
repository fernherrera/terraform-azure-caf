# Azure Application Gateway Terraform Module

Azure Application Gateway provides HTTP based load balancing that enables in creating routing rules for traffic based on HTTP. Traditional load balancers operate at the transport level and then route the traffic using source IP address and port to deliver data to a destination IP and port. Application Gateway using additional attributes such as URI (Uniform Resource Identifier) path and host headers to route the traffic.

Classic load balances operate at OSI layer 4 - TCP and UDP, while Application Gateway operates at application layer OSI layer 7 for load balancing.

This terraform module quickly creates a desired application gateway with additional options like WAF, Custom Error Configuration, SSL offloading with SSL policies, URL path mapping and many other options.

## sku - Which one is the correct sku v1 or V2?

Application Gateway is available under a Standard_v2 SKU. Web Application Firewall (WAF) is available under a WAF_v2 SKU. The v2 SKU offers performance enhancements and adds support for critical new features like autoscaling, zone redundancy, and support for static VIPs.

Application Gateway Standard_v2 supports autoscaling and can scale up or down based on changing traffic load patterns. Autoscaling also removes the requirement to choose a deployment size or instance count during provisioning.

`sku` object supports the following:

| Name | Description
|--|--
`name`|The Name of the `SKU` to use for this Application Gateway. Possible values are `Standard_Small`, `Standard_Medium`, `Standard_Large`, `Standard_v2`, `WAF_Medium`, `WAF_Large`, and `WAF_v2`.
tier|The `Tier` of the `SKU` to use for this Application Gateway. Possible values are `Standard`, `Standard_v2`, WAF and `WAF_v2`.
`capacity`|The Capacity of the `SKU` to use for this Application Gateway. When using a `V1` SKU this value must be between `1` and `32`, and `1` to `125` for a `V2` SKU. This property is optional if `autoscale_configuration` is set.

A `autoscale_configuration` block supports the following:

| Name | Description
|--|--
`min_capacity`|Minimum capacity for autoscaling. Accepted values are in the range `0` to `100`.
`max_capacity`|Maximum capacity for autoscaling. Accepted values are in the range `2` to `125`.

### FEATURE COMPARISON BETWEEN V1 SKU AND V2 SKU

Feature|v1 SKU|v2 SKU
-------|------|------
Autoscaling| |✓|
Zone redundancy| |✓
Static VIP| |✓
Azure Kubernetes Service (AKS) Ingress controller| |✓
Azure Key Vault integration| |✓
Rewrite HTTP(S) headers| |✓
URL-based routing|✓|✓
Multiple-site hosting|✓|✓
Traffic redirection|✓|✓
Web Application Firewall (WAF)|✓|✓
WAF custom rules| |✓
Transport Layer Security (TLS)/Secure Sockets Layer (SSL) termination|✓|✓
End-to-end TLS encryption|✓|✓
Session affinity|✓|✓
Custom error pages|✓|✓
WebSocket support|✓|✓
HTTP/2 support|✓|✓
Connection draining|✓|✓
