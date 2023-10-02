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
