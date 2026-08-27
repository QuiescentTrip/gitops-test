#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PATH="$ROOT_DIR/.tools/bin:$PATH"

cd "$ROOT_DIR"

command -v docker >/dev/null
command -v kind >/dev/null
command -v kubectl >/dev/null

docker build -t hopeful-api:dev app
kind load docker-image hopeful-api:dev --name hopeful-gitops
kubectl config use-context kind-hopeful-gitops
kubectl apply -k environments/dev
kubectl -n gitops-demo rollout status deploy/hopeful-api --timeout=120s

cat <<'MSG'

Demo API is deployed.

Open:

  http://famtangen.no:18080

Or directly through Tailscale:

  http://100.81.95.1:18080
MSG
