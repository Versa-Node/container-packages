# vncp-template

Starter template for a new VersaNode Controller Package.

## Steps to create a new package

1. Copy this folder:
   ```bash
   cp -r packages/vncp-template packages/vncp-<your-app>
   ```

2. Edit `package.yaml`:
   - `name`: `vncp-<your-app>`
   - `description`: short one-liner
   - `upstream.image`: upstream base image
   - `maintainers`: yourself

3. Write a minimal `Dockerfile`:
   - Prefer `FROM <upstream>` + OCI labels.
   - Add `org.opencontainers.image.documentation` pointing to this package README.

4. Define a `docker-compose.yml`:
   - Include `env_file: ./.env`
   - Attach to the shared network:
     ```yaml
     networks: [versanode]
     ```
   - Expose ports/volumes as needed.
   - Add a healthcheck.

5. Create `vncp.config.yaml`:
   - Define **typed** parameters with **descriptions**, defaults, and validation hints.
   - Add `mappings.env` and optional `mappings.files` + `templates/`.

6. Test locally:
   ```bash
   bash ../../tools/ensure-network.sh
   docker compose -f packages/vncp-<your-app>/docker-compose.yml config >/dev/null
   ```

7. Open a PR with the new package.
