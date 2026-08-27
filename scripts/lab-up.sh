#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PATH="$ROOT_DIR/.tools/bin:$PATH"

cd "$ROOT_DIR"

./scripts/check-prereqs.sh

available_kb="$(df --output=avail / | tail -n 1 | tr -d ' ')"
if [ "$available_kb" -lt 8388608 ]; then
  echo "Root filesystem has less than 8 GiB available. Free space before pulling Kubernetes images."
  exit 1
fi

if ! kind get clusters | grep -qx "hopeful-gitops"; then
  kind create cluster --config platform/kind/kind-config.yaml
fi

kubectl config use-context kind-hopeful-gitops

terraform -chdir=infra/terraform init
terraform -chdir=infra/terraform apply -auto-approve

kubectl -n argocd rollout status deploy/argocd-server --timeout=180s

if [ "${GIT_REPO_URL:-}" != "" ]; then
  tmp_app="$(mktemp)"
  sed "s#https://github.com/CHANGE-ME/gitops-demo.git#${GIT_REPO_URL}#g" \
    platform/argocd/application.yaml > "$tmp_app"
  kubectl apply -f "$tmp_app"
  rm -f "$tmp_app"
else
  cat <<'MSG'

Argo CD is installed. Set GIT_REPO_URL when you are ready to register this repo:

  GIT_REPO_URL=https://github.com/YOUR_USER/gitops-demo.git ./scripts/lab-up.sh
MSG
fi

cat <<'MSG'

Lab platform is ready.

Use these next:

  ./scripts/deploy-local-dev.sh
  ./scripts/port-forward-argocd.sh

The demo API is configured for:

  http://famtangen.no:18080
  http://100.81.95.1:18080
MSG
