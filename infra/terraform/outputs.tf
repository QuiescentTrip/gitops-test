output "cluster_name" {
  value = var.cluster_name
}

output "mock_gcp_project" {
  value = {
    project_id = var.mock_gcp_project_id
    region     = var.mock_gcp_region
  }
}

output "argocd_namespace" {
  value = kubernetes_namespace.argocd.metadata[0].name
}

output "workload_namespace" {
  value = kubernetes_namespace.workloads.metadata[0].name
}
