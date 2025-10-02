#!/usr/bin/env bash
set -euo pipefail

# Optional extra pip installs (space-separated)
if [[ -n "${EXTRA_PIP_PACKAGES:-}" ]]; then
  echo "Installing extra pip packages: ${EXTRA_PIP_PACKAGES}"
  pip install --no-cache-dir ${EXTRA_PIP_PACKAGES} || true
fi

# Honor JUPYTER_TOKEN if provided
export JUPYTER_TOKEN="${JUPYTER_TOKEN:-changeme}"
exec start-notebook.sh --NotebookApp.token="${JUPYTER_TOKEN}" --ServerApp.token="${JUPYTER_TOKEN}"
