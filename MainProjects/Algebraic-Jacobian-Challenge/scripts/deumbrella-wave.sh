#!/usr/bin/env bash
# Drive the de-umbrella campaign wave by wave over the project import DAG.
#
#   scripts/deumbrella-wave.sh [max_waves] [parallel_jobs]
#
# A module's minimal-import probe is only CORRECT once every module in its
# transitive project-import closure is already umbrella-free: while a dependency
# still says `import Mathlib`, it hands the whole of Mathlib to the importer and
# the linter reports every Mathlib module as redundant.  So each wave converts
# exactly the bare modules whose project dependencies are already clean, rebuilds
# them so the next wave's probes see the narrowed oleans, and repeats.
#
# Wave 1 is the DAG sources (no project imports at all).  Failures are restored
# by scripts/deumbrella.sh and simply stay bare, blocking their dependents until
# a human or a later run handles them.
set -uo pipefail

MAX_WAVES=${1:-99}
JOBS=${2:-6}
HERE=$(cd "$(dirname "$0")" && pwd)
cd "$HERE/.."

ready_modules () {
python3 - <<'PY'
import os, re
mods = {}
for dp, _, fns in os.walk('AlgebraicJacobian'):
    for fn in fns:
        if fn.endswith('.lean'):
            p = os.path.join(dp, fn)
            mods[p[:-5].replace('/', '.')] = p
imports, umbrella = {}, set()
for n, p in mods.items():
    ds = []
    for line in open(p, errors='replace'):
        m = re.match(r'^import\s+([A-Za-z0-9_.]+)', line)
        if m:
            d = m.group(1)
            if d == 'Mathlib':
                umbrella.add(n)
            elif d.startswith('AlgebraicJacobian'):
                ds.append(d)
    imports[n] = ds
memo = {}
def contaminated(m):
    if m in memo:
        return memo[m]
    memo[m] = True
    r = m in umbrella or any(contaminated(d) for d in imports.get(m, []))
    memo[m] = r
    return r
ready = [m for m in umbrella if not any(contaminated(d) for d in imports[m])]
# cheapest first: a failure then costs the least, and the early wins land sooner
ready.sort(key=lambda m: os.path.getsize(mods[m]))
for m in ready:
    print(mods[m])
PY
}

wave=0
while [ "$wave" -lt "$MAX_WAVES" ]; do
  wave=$((wave + 1))
  mapfile -t READY < <(ready_modules)
  [ "${#READY[@]}" -eq 0 ] && { echo "== no module is ready; stopping after $((wave - 1)) wave(s)"; break; }

  echo "== wave $wave: ${#READY[@]} module(s) ready"
  printf '%s\n' "${READY[@]}" | xargs -P "$JOBS" -I{} bash "$HERE/deumbrella.sh" {}

  # Rebuild the converted modules so the next wave probes against narrowed oleans.
  targets=()
  for f in "${READY[@]}"; do
    grep -qx 'import Mathlib' "$f" || targets+=("${f%.lean}")
  done
  [ "${#targets[@]}" -eq 0 ] && { echo "== wave $wave converted nothing; stopping"; break; }
  echo "== wave $wave: rebuilding ${#targets[@]} module(s)"
  lake build "${targets[@]//\//.}" || echo "!! rebuild reported failures in wave $wave"
done

echo "== bare \`import Mathlib\` modules remaining: $(grep -rlx 'import Mathlib' AlgebraicJacobian --include=*.lean | wc -l)"
