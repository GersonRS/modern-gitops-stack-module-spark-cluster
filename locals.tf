locals {
  domain      = format("spark.%s", trimprefix("${var.subdomain}.${var.base_domain}", "."))
  domain_full = format("spark.%s.%s", trimprefix("${var.subdomain}.${var.cluster_name}", "."), var.base_domain)

  helm_values = [{
    spark = {
      image = {
        registry   = "docker.io"
        repository = "bitnami/spark"
        tag        = "3.5.4-debian-12-r2"
        debug      = true
      }
      master = {
        resourcesPreset = "small"
        resources = {
          requests = { for k, v in var.resources.master.requests : k => v if v != null }
          limits   = { for k, v in var.resources.master.limits : k => v if v != null }
        }
        # configOptions = [
        #   "Dspark.ui.reverseProxy=true",
        #   "Dspark.ui.reverseProxyUrl=${local.domain_full}"
        # ]
      }
      worker = {
        replicaCount = var.replicas
        autoscaling = {
          enabled      = true
          minReplicas  = var.replicas
          maxReplicas  = var.replicas + 3
          targetCPU    = 70
          targetMemory = 70
        }
        resourcesPreset = "small"
        resources = {
          requests = { for k, v in var.resources.worker.requests : k => v if v != null }
          limits   = { for k, v in var.resources.worker.limits : k => v if v != null }
        }
        # configOptions = [
        #   "Dspark.ui.reverseProxy=true",
        #   "Dspark.ui.reverseProxyUrl=${local.domain_full}"
        # ]
      }
      ingress = {
        enabled          = true
        pathType         = "ImplementationSpecific"
        hostname         = local.domain_full
        ingressClassName = "traefik"
        path             = "/"
        annotations = {
          "cert-manager.io/cluster-issuer"                   = "${var.cluster_issuer}"
          "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure"
          "traefik.ingress.kubernetes.io/router.tls"         = "true"
        }
        tls        = true
        selfSigned = false
      }

      metrics = {
        enabled = var.enable_service_monitor
        podMonitor = {
          enabled = var.enable_service_monitor
        }
      }
    }
  }]
}
