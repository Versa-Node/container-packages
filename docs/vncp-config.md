# VNCP Config (v1)

Each package includes a `vncp.config.yaml` with strongly-typed parameters and human-friendly descriptions.

## Parameter schema (summary)

```yaml
version: 1
metadata:
  id: vncp-<name>
  name: Human Name
  summary: Short description
  website: https://...
parameters:
  - key: KEY_NAME
    label: Friendly label
    type: string|password|int|bool|enum|path|port
    description: Human description of what this does
    required: true|false
    default: <value>
    enum: [a, b, c]   # when type=enum
    min: 0            # for int/port
    max: 65535
    pattern: '^[a-z]+'  # regex (string)
    secret: true|false  # hints to store securely
mappings:
  env: [ KEY_NAME, ... ]     # keys to write into .env consumed by compose
  files:
    - template: templates/<name>.j2  # simple ${KEY} substitution (your tool renders on host)
      output: config/<name>
notes:
  - Optional array of guidance strings
```

**Runtime contract:**  
- Your cockpit tool renders `.env` and any templated files **on the host**.  
- Compose files reference `env_file: .env` and mount `config/` or `data/` accordingly.  
- Containers do **not** render anything themselves.
