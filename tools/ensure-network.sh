#!/usr/bin/env bash
set -euo pipefail
docker network inspect versanode >/dev/null 2>&1 || docker network create versanode
echo "Network 'versanode' ready."
