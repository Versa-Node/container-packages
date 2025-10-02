#!/usr/bin/env bash
set -euo pipefail

PKG="${1:-}"
if [[ -z "$PKG" ]]; then
  echo "Usage: $0 <package-name>"
  exit 1
fi

cd "$(dirname "$0")/.."

if [[ ! -f "packages/$PKG/Dockerfile" ]]; then
  echo "No Dockerfile for $PKG (maybe it uses upstream image only)."
  exit 0
fi

IMAGE_NAME="ghcr.io/YOUR-ORG/$PKG:dev"
PLATFORM="${PLATFORM:-linux/arm64}"

docker buildx build --platform "$PLATFORM" -t "$IMAGE_NAME" "packages/$PKG" --load
echo "Built $IMAGE_NAME"
