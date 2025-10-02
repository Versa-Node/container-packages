#!/usr/bin/env bash
set -euo pipefail

PKG="${1:-}"
if [[ -z "$PKG" ]]; then
  echo "Usage: $0 <package-name>"
  exit 1
fi

cd "$(dirname "$0")/.."
docker compose -f "packages/$PKG/docker-compose.example.yml" config >/dev/null
echo "Compose validated for $PKG"
