variable "vpc_id" {
  type        = string
  description = "The ID of the VPC."
}

variable "istio_release_version" {
  type        = string
  default     = "1.18.3"
  description = "The version of Istio to be installed."
}

variable "istio_release_namespace" {
  type        = string
  default     = "istio-system"
  description = "The Kubernetes namespace where Istio will be installed."
}

variable "istio_enable_external_gateway" {
  type        = bool
  default     = true
  description = "Determines whether to enable an external gateway for Istio, allowing external traffic to reach Istio services."
}

variable "istio_enable_internal_gateway" {
  type        = bool
  default     = false
  description = "Controls the enabling of an internal gateway for Istio, which manages traffic within the Kubernetes cluster."
}

## External Gateway configs
variable "istio_external_gateway_lb_certs" {
  type        = list(string)
  description = "The certificates for the Istio external gateway load balancer."
}

variable "istio_external_gateway_service_kind" {
  type        = string
  default     = "NodePort"
  description = "The type of service for the Istio external gateway."
  validation {
    condition = contains(["NodePort", "LoadBalancer", "ClusterIP"], var.istio_external_gateway_service_kind)
    error_message = "istio_external_gateway_service_kind must be one of 'NodePort', 'LoadBalancer', or 'ClusterIP'."
  }
}

variable "istio_external_gateway_scaling_max_replicas" {
  type        = number
  description = "The maximum number of replicas for scaling the Istio external gateway."
  default     = 5
}

variable "istio_external_gateway_scaling_target_cpu_utilization" {
  type        = number
  description = "The target CPU utilization percentage for scaling the external gateway."
  default     = 80
}

## Internal Gateway configs
variable "istio_internal_gateway_lb_certs" {
  type        = list(string)
  description = "The certificates for the Istio internal gateway load balancer."
}

variable "istio_internal_gateway_service_kind" {
  type        = string
  default     = "NodePort"
  description = "The type of service for the Istio internal gateway."
  validation {
    condition = contains(["NodePort", "LoadBalancer", "ClusterIP"], var.istio_internal_gateway_service_kind)
    error_message = "istio_internal_gateway_service_kind must be one of 'NodePort', 'LoadBalancer', or 'ClusterIP'."
  }
}

variable "istio_internal_gateway_scaling_max_replicas" {
  type        = number
  description = "The maximum number of replicas for scaling the Istio internal gateway."
  default     = 5
}

variable "istio_internal_gateway_scaling_target_cpu_utilization" {
  type        = number
  description = "The target CPU utilization percentage for scaling the internal gateway."
  default     = 80
}