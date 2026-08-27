#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PATH="$ROOT_DIR/.tools/bin:$PATH"

missing_required=0

check() {
  local name="$1"
  if command -v "$name" >/dev/null 2>&1; then
    printf "ok: %s -> %s\n" "$name" "$(command -v "$name")"
  else
    printf "missing: %s\n" "$name"
    missing_required=1
  fi
}

check_optional() {
  local name="$1"
  if command -v "$name" >/dev/null 2>&1; then
    printf "ok: %s -> %s\n" "$name" "$(command -v "$name")"
  else
    printf "optional missing: %s\n" "$name"
  fi
}

check docker
check kind
check kubectl
check terraform
check git
check_optional helm

printf "\nDisk snapshot:\n"
df -hT / /DATA /mnt/4TB_HDD /mnt/1TB_HDD

if [ "$missing_required" -ne 0 ]; then
  cat <<'MSG'

Install the missing tools before running the full lab. To keep this host tidy,
prefer user-local binaries in:

  /home/quiescent/gitops-demo/.tools/bin

Then run:

  export PATH=/home/quiescent/gitops-demo/.tools/bin:$PATH
  ./scripts/check-prereqs.sh
MSG
  exit 1
fi
