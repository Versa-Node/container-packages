import sys, yaml, pathlib
errors = 0
for path in pathlib.Path('packages').glob('*/package.yaml'):
    data = yaml.safe_load(path.read_text())
    for k in ['name','description','arch','maintainers']:
        if k not in data:
            print(f"[{path}] missing: {k}")
            errors += 1
if errors:
    sys.exit(1)
print("All package.yaml files look good.")
