# Contributing

- Fork, branch, and open a PR.
- Use `packages/vncp-template` as a starting point.
- Keep defaults secure. Prefer upstream images; only build custom when needed.
- All packages should include `vncp.config.yaml` with typed, described parameters.

**Naming:** Prefix all packages with `vncp-`.

## CI
- CI validates package metadata.
- Publishing to GHCR uses multi-arch (arm64/amd64) with tags: `latest`, short SHA, and `versanode-controller-package`.
