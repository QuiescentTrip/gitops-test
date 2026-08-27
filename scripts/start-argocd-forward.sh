#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PATH="$ROOT_DIR/.tools/bin:$PATH"

LOG_DIR="$ROOT_DIR/logs"
PID_FILE="$LOG_DIR/argocd-port-forward.pid"
LOG_FILE="$LOG_DIR/argocd-port-forward.log"
ADDRESS="${ARGOCD_ADDRESS:-100.81.95.1}"
PORT="${ARGOCD_PORT:-8081}"

mkdir -p "$LOG_DIR"

if [ -s "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" >/dev/null 2>&1; then
  echo "Argo CD forward is already running with PID $(cat "$PID_FILE")."
  exit 0
fi

kubectl config use-context kind-hopeful-gitops >/dev/null

: > "$LOG_FILE"
setsid bash -c "exec kubectl -n argocd port-forward --address '$ADDRESS' svc/argocd-server '$PORT':80 >> '$LOG_FILE' 2>&1" </dev/null >/dev/null 2>&1 &
echo "$!" > "$PID_FILE"

sleep 2

if ! kill -0 "$(cat "$PID_FILE")" >/dev/null 2>&1; then
  echo "Argo CD forward failed to stay running. Log:"
  cat "$LOG_FILE"
  exit 1
fi

echo "Argo CD UI is available at http://$ADDRESS:$PORT"
