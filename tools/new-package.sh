#!/usr/bin/env bash
set -euo pipefail

NAME="${1:-}"
if [[ -z "$NAME" ]]; then
  echo "Usage: $0 <new-package-name>"
  exit 1
fi

cd "$(dirname "$0")/.."

SRC="packages/template"
DST="packages/$NAME"
if [[ -d "$DST" ]]; then
  echo "Package '$NAME' already exists"
  exit 1
fi

cp -r "$SRC" "$DST"
sed -i 's/name: template/name: '"$NAME"'/g' "$DST/package.yaml"
echo "Scaffolded $DST"
