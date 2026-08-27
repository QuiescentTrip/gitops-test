variable "cluster_name" {
  type        = string
  description = "Local kind cluster name."
  default     = "hopeful-gitops"
}

variable "kubeconfig_path" {
  type        = string
  description = "Path to the kubeconfig used by kind."
  default     = "~/.kube/config"
}

variable "kube_context" {
  type        = string
  description = "Kubernetes context for the kind cluster."
  default     = "kind-hopeful-gitops"
}

variable "mock_gcp_project_id" {
  type        = string
  description = "Fake GCP project ID used for practice outputs and config maps."
  default     = "hopeful-gitops-dev"
}

variable "mock_gcp_region" {
  type        = string
  description = "Fake GCP region represented by the local kind cluster."
  default     = "europe-north1"
}

variable "argocd_chart_version" {
  type        = string
  description = "Argo CD Helm chart version."
  default     = null
  nullable    = true
}
