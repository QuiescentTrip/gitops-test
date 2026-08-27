#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PATH="$ROOT_DIR/.tools/bin:$PATH"

if command -v kind >/dev/null 2>&1; then
  kind delete cluster --name hopeful-gitops
else
  echo "kind is not installed on PATH. Nothing deleted."
fi
