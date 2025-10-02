# Contributing

1. Fork the repository and create a branch.
2. Add a new package under `packages/<name>` using the [template](packages/template).
3. Ensure `docker-compose.example.yml` runs on `linux/arm64` (CM5).
4. Run `make check` to lint and validate metadata.
5. Open a pull request. Fill in the PR template and link any issues.

## Adding a package

- Copy `packages/template` to `packages/<your-package>`
- Update `package.yaml`, `README.md`, and compose file
- Prefer official upstream images; only build a custom Dockerfile if truly necessary
- Keep defaults secure. Expose minimal ports, and mark volumes explicitly

## Versioning

- This repo uses a simple `VERSION` file and a `CHANGELOG.md`
- Tag releases as `vX.Y.Z`. CI builds and publishes multi-arch images to GHCR under `ghcr.io/versanode/<package>`.
