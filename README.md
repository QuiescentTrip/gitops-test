# GitOps Demo Lab

This is a local lab for practicing a workplace-style delivery flow:

```text
GitHub Actions -> container image -> Git manifest change -> Argo CD -> kind Kubernetes
```

It deliberately does not use real GCP. The Terraform and docs model common GCP
concepts, but the backing services are local and disposable.

## What This Creates

- A `kind` Kubernetes cluster named `hopeful-gitops`
- Argo CD installed into the cluster by Terraform
- A small demo API deployed through Kubernetes manifests
- A GitHub Actions workflow that tests, builds, pushes, and promotes the app
- A mock "GCP map" showing how local pieces correspond to cloud services

## Layout

```text
app/                    Demo API
environments/dev/       Kubernetes manifests watched by Argo CD
infra/terraform/        Local platform Terraform
platform/kind/          kind cluster configuration
platform/argocd/        Argo CD Application manifest
scripts/                Local helper scripts
docs/                   Notes for interview/job practice
```

## Prerequisites

The lab expects these tools on your PATH:

- Docker
- kind
- kubectl
- Terraform
- Helm, optional but useful for inspecting chart values

Check your machine:

```bash
cd /home/quiescent/gitops-demo
./scripts/check-prereqs.sh
```

If you want the lab to install user-local tool binaries:

```bash
./scripts/install-local-tools.sh
export PATH=/home/quiescent/gitops-demo/.tools/bin:$PATH
./scripts/check-prereqs.sh
```

## Start The Lab

Create the local cluster and install the platform:

```bash
cd /home/quiescent/gitops-demo
./scripts/lab-up.sh
```

If this repository is pushed to GitHub, point Argo CD at it:

```bash
GIT_REPO_URL=https://github.com/YOUR_USER/gitops-demo.git ./scripts/lab-up.sh
```

Without `GIT_REPO_URL`, the cluster still starts and Terraform installs Argo CD,
but the Argo CD Application is not registered yet.

## Deploy The App Locally

This builds the demo API image, loads it into kind, and applies the dev
manifests directly. It is useful before wiring a GitHub repository.

```bash
./scripts/deploy-local-dev.sh
```

Then open:

```text
http://famtangen.no:18080
```

The equivalent Tailscale/VPN address on Q is currently:

```text
http://100.81.95.1:18080
```

## Open Argo CD

Start the Argo CD UI forward:

```bash
./scripts/start-argocd-forward.sh
```

Get the generated admin password:

```bash
./scripts/show-argocd-password.sh
```

Then visit:

```text
http://famtangen.no:8081
```

Username:

```text
admin
```

Stop the UI forward when you do not need it:

```bash
./scripts/stop-argocd-forward.sh
```

## GitHub Actions Flow

After the repo is on GitHub:

1. A pull request runs the API tests.
2. A push to `main` builds and pushes an image to GitHub Container Registry.
3. The workflow updates `environments/dev/kustomization.yaml` with the new image
   tag and commits that promotion.
4. Argo CD notices the Git change and syncs the local cluster.

For packages to push to GHCR, the repository needs Actions permissions for
packages and contents. The included workflow sets the job permissions it needs.

## Clean Up

```bash
./scripts/lab-down.sh
```

That deletes only the `hopeful-gitops` kind cluster.
