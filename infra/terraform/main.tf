resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"

    labels = {
      "app.kubernetes.io/part-of" = "hopeful-gitops-lab"
    }
  }
}

resource "kubernetes_namespace" "workloads" {
  metadata {
    name = "gitops-demo"

    labels = {
      "app.kubernetes.io/part-of" = "hopeful-gitops-lab"
    }
  }
}

resource "kubernetes_namespace" "mock_cloud" {
  metadata {
    name = "mock-cloud"

    labels = {
      "app.kubernetes.io/part-of" = "hopeful-gitops-lab"
    }
  }
}

resource "kubernetes_config_map" "mock_gcp_project" {
  metadata {
    name      = "mock-gcp-project"
    namespace = kubernetes_namespace.mock_cloud.metadata[0].name
  }

  data = {
    project_id        = var.mock_gcp_project_id
    region            = var.mock_gcp_region
    gke_equivalent    = var.cluster_name
    artifact_registry = "GitHub Container Registry or a local registry"
    cloud_sql         = "Use a local Postgres container when needed"
    cloud_storage     = "Use MinIO when needed"
    secret_manager    = "Use Kubernetes Secrets, SOPS, or Sealed Secrets"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_chart_version

  values = [
    yamlencode({
      configs = {
        params = {
          "server.insecure" = true
        }
      }

      server = {
        service = {
          type = "ClusterIP"
        }
      }
    })
  ]
}
