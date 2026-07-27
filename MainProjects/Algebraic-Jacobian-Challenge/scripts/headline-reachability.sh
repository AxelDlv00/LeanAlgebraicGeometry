#!/usr/bin/env bash
# Reachability of the headline: how many project modules lie in the transitive
# import closure of AlgebraicJacobian/Jacobian.lean.  A headline that imports
# only Genus.lean cannot depend on the Picard/cohomology/Riemann-Roch work no
# matter what its docstring claims, so this number is the honest measure of
# whether the project's infrastructure is wired to its stated theorem.
#
# Run from the project root:  scripts/headline-reachability.sh
set -euo pipefail
cd "$(dirname "$0")/.."

python3 - "$@" <<'PY'
import os, re, sys

def imports(mod: str) -> list[str]:
    path = mod.replace('.', '/') + '.lean'
    if not os.path.exists(path):
        return []
    with open(path) as fh:
        return re.findall(r'^import\s+(AlgebraicJacobian[\w.]*)', fh.read(), re.M)

def closure(root: str) -> set[str]:
    seen: set[str] = set()
    stack = [root]
    while stack:
        mod = stack.pop()
        if mod in seen:
            continue
        seen.add(mod)
        stack.extend(imports(mod))
    return seen

total = sum(1 for d, _, fs in os.walk('AlgebraicJacobian') for f in fs
            if f.endswith('.lean'))
for root in sys.argv[1:] or ['AlgebraicJacobian.Jacobian',
                             'AlgebraicJacobian.AbelJacobi']:
    reach = closure(root)
    print(f'{root}: {len(reach)} of {total} project modules reachable')
PY
