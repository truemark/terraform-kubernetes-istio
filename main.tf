data "aws_subnets" "istio_private_subnet_ids" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  tags = {
    network = "private"
  }
}

data "aws_subnets" "istio_public_subnet_ids" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  tags = {
    network = "public"
  }
}

resource "helm_release" "istio-base" {
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  version          = var.istio_release_version
  namespace        = var.istio_release_namespace
  create_namespace = true
}

resource "helm_release" "istio-discovery" {
  name             = "istio-discovery"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  version          = var.istio_release_version
  namespace        = var.istio_release_namespace
  create_namespace = true
  values = [
    templatefile("${path.module}/values/istiod.yaml", {
      mesh_id       = var.istio_mesh_id
      network       = var.istio_network
      multi_cluster = var.istio_multi_cluster
      cluster_name  = var.istio_cluster_name
    })
  ]
  depends_on = [helm_release.istio-base]
}

resource "helm_release" "istio-gateway-external" {
  count            = var.istio_enable_external_gateway ? 1 : 0
  name             = "istio-gateway-external"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  version          = var.istio_release_version
  namespace        = "istio-system"
  create_namespace = true
  values = [
    templatefile("${path.module}/values/external-gateway.yaml", {
      external_gateway_service_kind                   = var.istio_external_gateway_service_kind
      external_gateway_lb_subnets                     = join(",", data.aws_subnets.istio_public_subnet_ids.ids)
      external_gateway_lb_certs                       = join(",", var.istio_external_gateway_lb_certs)
      external_gateway_scaling_max_replicas           = var.istio_external_gateway_scaling_max_replicas
      external_gateway_scaling_target_cpu_utilization = var.istio_external_gateway_scaling_target_cpu_utilization
    })
  ]
  depends_on = [helm_release.istio-base, helm_release.istio-discovery]
}

resource "helm_release" "istio-gateway-internal" {
  count            = var.istio_enable_internal_gateway ? 1 : 0
  name             = "istio-gateway-internal"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  version          = var.istio_release_version
  namespace        = "istio-system"
  create_namespace = true
  values = [
    templatefile("${path.module}/values/internal-gateway.yaml", {
      internal_gateway_service_kind                   = var.istio_internal_gateway_service_kind
      internal_gateway_lb_subnets                     = join(",", data.aws_subnets.istio_private_subnet_ids.ids)
      internal_gateway_lb_certs                       = join(",", var.istio_internal_gateway_lb_certs)
      internal_gateway_scaling_max_replicas           = var.istio_internal_gateway_scaling_max_replicas
      internal_gateway_scaling_target_cpu_utilization = var.istio_internal_gateway_scaling_target_cpu_utilization
    })
  ]
  depends_on = [helm_release.istio-base, helm_release.istio-discovery]
}
