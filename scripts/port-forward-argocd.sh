#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PATH="$ROOT_DIR/.tools/bin:$PATH"

kubectl config use-context kind-hopeful-gitops
kubectl -n argocd port-forward --address 100.81.95.1 svc/argocd-server 8081:80
