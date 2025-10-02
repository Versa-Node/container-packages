import sys, yaml, pathlib

errors = 0
for path in pathlib.Path('packages').glob('*/package.yaml'):
    data = yaml.safe_load(path.read_text())
    required = ['name', 'description', 'arch', 'maintainers']
    miss = [k for k in required if k not in data]
    if miss:
        print(f"[{path}] missing: {', '.join(miss)}")
        errors += 1

if errors:
    sys.exit(1)
print("All package.yaml files look good.")
