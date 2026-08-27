# Mock GCP Map

This lab keeps the same mental model as a GCP-backed platform without creating
cloud resources.

| GCP concept | Local lab equivalent | Where |
| --- | --- | --- |
| GCP project | Terraform variable and `mock-cloud/mock-gcp-project` ConfigMap | `infra/terraform` |
| GKE cluster | `kind` cluster named `hopeful-gitops` | `platform/kind` |
| Artifact Registry | GitHub Container Registry, or local image loaded into kind | `.github/workflows/ci.yml`, `scripts/deploy-local-dev.sh` |
| Cloud Deploy / GitOps | Argo CD watches Git and syncs manifests | `platform/argocd` |
| Cloud SQL | Add a Postgres Helm chart or container when needed | Future exercise |
| Cloud Storage | Add MinIO when object storage practice is needed | Future exercise |
| Secret Manager | Kubernetes Secrets, SOPS, or Sealed Secrets | Future exercise |
| IAM service account | GitHub Actions token plus Kubernetes RBAC | Workflow and cluster config |

The useful practice is the shape of the work:

1. Application code changes.
2. CI tests and builds a container image.
3. CI promotes by changing Git manifests.
4. Argo CD reconciles the cluster from Git.
5. Terraform owns the platform baseline.

That is the core motion you will see in many GCP + Terraform + Argo CD teams,
even though the actual managed services differ.
