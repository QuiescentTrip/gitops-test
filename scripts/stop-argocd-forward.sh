#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PID_FILE="$ROOT_DIR/logs/argocd-port-forward.pid"

if [ ! -s "$PID_FILE" ]; then
  echo "No Argo CD forward PID file found."
  exit 0
fi

pid="$(cat "$PID_FILE")"

if kill -0 "$pid" >/dev/null 2>&1; then
  kill "$pid"
  echo "Stopped Argo CD forward with PID $pid."
else
  echo "Argo CD forward PID $pid was not running."
fi

rm -f "$PID_FILE"
