#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_DIR="$ROOT_DIR/.tools/bin"
TMP_DIR="$(mktemp -d)"

mkdir -p "$BIN_DIR"
trap 'rm -rf "$TMP_DIR"' EXIT

arch="$(uname -m)"
case "$arch" in
  x86_64 | amd64) machine="amd64" ;;
  aarch64 | arm64) machine="arm64" ;;
  *)
    echo "Unsupported architecture: $arch"
    exit 1
    ;;
esac

need() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required downloader: $1"
    exit 1
  }
}

download() {
  local url="$1"
  local output="$2"
  echo "Downloading $url"
  curl -fsSL "$url" -o "$output"
}

install_kind() {
  local version="${KIND_VERSION:-v0.23.0}"
  download "https://kind.sigs.k8s.io/dl/${version}/kind-linux-${machine}" "$BIN_DIR/kind"
  chmod +x "$BIN_DIR/kind"
}

install_kubectl() {
  local version
  version="${KUBECTL_VERSION:-v1.30.0}"
  download "https://dl.k8s.io/release/${version}/bin/linux/${machine}/kubectl" "$BIN_DIR/kubectl"
  chmod +x "$BIN_DIR/kubectl"
}

install_helm() {
  local version="${HELM_VERSION:-v3.15.2}"
  local archive="$TMP_DIR/helm.tar.gz"
  download "https://get.helm.sh/helm-${version}-linux-${machine}.tar.gz" "$archive"
  tar -xzf "$archive" -C "$TMP_DIR"
  mv "$TMP_DIR/linux-${machine}/helm" "$BIN_DIR/helm"
  chmod +x "$BIN_DIR/helm"
}

install_terraform() {
  local version="${TERRAFORM_VERSION:-1.8.5}"
  local archive="$TMP_DIR/terraform.zip"
  download "https://releases.hashicorp.com/terraform/${version}/terraform_${version}_linux_${machine}.zip" "$archive"
  unzip -o "$archive" -d "$BIN_DIR"
  chmod +x "$BIN_DIR/terraform"
}

need curl
need tar
need unzip

install_kind
install_kubectl
install_helm
install_terraform

cat <<MSG

Installed local tools into:

  $BIN_DIR

Use them with:

  export PATH=$BIN_DIR:\$PATH
  ./scripts/check-prereqs.sh
MSG
