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
  values           = [
    templatefile("${path.module}/values-istiod.yaml", {})
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
  values           = [
    templatefile("${path.module}/values-gateway.yaml", {})
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
  values           = [
    templatefile("${path.module}/values-gateway.yaml", {})
  ]
  depends_on = [helm_release.istio-base, helm_release.istio-discovery]
}
