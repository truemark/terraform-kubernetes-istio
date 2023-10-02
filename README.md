# Terraform Kubernetes Istio Release


![Terraform](https://img.shields.io/badge/terraform-%5E0.15-green)
![Helm](https://img.shields.io/badge/helm-%5E3.0-blue)

This Terraform module simplifies the deployment of Istio as an ingress controller in a Kubernetes cluster. It utilizes Helm charts to install Istio with customizable configurations, allowing you to easily manage and configure Istio for your Kubernetes environment.

## Features

- **Easy Deployment**: Deploy Istio to your Kubernetes cluster with minimal configuration.

- **Custom Configuration**: Easily customize Istio's configuration.

- **Helm Compatibility**: Utilizes Helm charts for seamless deployment and upgrades.


## Example

Here's an example of how to use this module in your Terraform configuration:

Using with your custom module
```hcl
module "ingress_controller_istio" {
  count = var.enable_istio ? 1 : 0
  source = "truemark/istio"
}
```

Enabling with truemark EKS module
```hcl
module "eks" {
  source  = "truemark/eks/aws"
  # version = use version higher than 0.0.18

  cluster_name                    = "test-cluster"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id           = "vpc-xxxxxxx"
  subnets_ids      = ["subnet-xxxxxxx", "subnet-xxxxxxx", "subnet-xxxxxxx"]
  cluster_version = "1.28"
  enable_karpenter = true
  eks_managed_node_groups = {
    general = {
      disk_size      = 50
      min_size       = 1
      max_size       = 5
      desired_size   = 3
      ami_type       = "AL2_ARM_64"
      instance_types = ["m6g.large", "m6g.xlarge", "m7g.large", "m7g.xlarge", "m6g.2xlarge", "m7g.2xlarge"]
      labels = {
        "managed" : "eks"
        "purpose" : "general"
      }
      subnet_ids    = ["subnet-xxxxxxx", "subnet-xxxxxxx", "subnet-xxxxxxx"]
      capacity_type = "SPOT"
    }
  }
  enable_istio = true ## This toggles if we want to install istio or not
}
```



## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.26 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.9.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.11.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.istio-base](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio-discovery](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio-gateway-external](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio-gateway-internal](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_istio_enable_external_gateway"></a> [istio\_enable\_external\_gateway](#input\_istio\_enable\_external\_gateway) | Determines whether to enable an external gateway for Istio, allowing external traffic to reach Istio services. | `bool` | `true` | no |
| <a name="input_istio_enable_internal_gateway"></a> [istio\_enable\_internal\_gateway](#input\_istio\_enable\_internal\_gateway) | Controls the enabling of an internal gateway for Istio, which manages traffic within the Kubernetes cluster. | `bool` | `false` | no |
| <a name="input_istio_release_namespace"></a> [istio\_release\_namespace](#input\_istio\_release\_namespace) | The Kubernetes namespace where Istio will be installed. | `string` | `"istio-system"` | no |
| <a name="input_istio_release_version"></a> [istio\_release\_version](#input\_istio\_release\_version) | The version of Istio to be installed. | `string` | `"1.18.3"` | no |

## Outputs

No outputs.
