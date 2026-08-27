# Practice Runbook

## Daily Workflow

1. Create a branch.
2. Change `app/src/server.js`.
3. Run `cd app && npm test`.
4. Open a pull request.
5. Merge to `main`.
6. Watch GitHub Actions update `environments/dev/kustomization.yaml`.
7. Watch Argo CD sync the change into kind.

## Useful Commands

```bash
kubectl get pods -n argocd
kubectl get pods -n gitops-demo
kubectl get app -n argocd
kubectl describe app hopeful-api-dev -n argocd
kubectl logs -n gitops-demo deploy/hopeful-api
terraform -chdir=infra/terraform plan
```

## Interview Talking Points

- Terraform creates the platform baseline: namespaces, Argo CD, and mock cloud
  metadata.
- Argo CD owns workload reconciliation from Git.
- GitHub Actions does CI and image promotion, but it does not directly mutate
  the cluster.
- The Kubernetes manifests are the deployment contract.
- The image tag in Git is the release record.

## Safe Experiments

- Add a second environment under `environments/stage`.
- Add resource requests and limits, then inspect scheduling.
- Break the health check and watch rollout behavior.
- Disable Argo CD auto-sync and practice manual sync.
- Add a Postgres dependency to simulate Cloud SQL.
