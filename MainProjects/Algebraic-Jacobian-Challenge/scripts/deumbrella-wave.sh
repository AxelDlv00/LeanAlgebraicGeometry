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
# THE CASCADE, AND WHY EACH WAVE SELF-REPAIRS.  35 of this project's modules
# declare no Mathlib import at all and inherit the library transitively.  Nothing
# in their own text says what they need, so they are invisible to the probe --
# and narrowing one of their parents silently strips the library from them.  The
# repair is deterministic and cannot fail: give the broken dependent a bare
# `import Mathlib`, restoring exactly the environment it used to inherit.  A wave
# therefore ends green or repairs itself; it never leaves the tree red.
#
# Failures of the conversion itself are restored by scripts/deumbrella.sh, so a
# module that resists narrowing (GrassmannianQuot times out at `isDefEq` with
# precise imports but builds fine with the umbrella) simply stays bare.
set -uo pipefail

MAX_WAVES=${1:-99}
JOBS=${2:-6}
HERE=$(cd "$(dirname "$0")" && pwd)
cd "$HERE/.." || exit 1

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
        m = re.match(r'^import\s+([A-Za-z0-9_.]+)\s*$', line)
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
ready.sort(key=lambda m: os.path.getsize(mods[m]))   # cheapest first
for m in ready:
    print(mods[m])
PY
}

add_umbrella () {
python3 - "$1" <<'PY'
import re, sys
p = sys.argv[1]
lines = open(p, encoding='utf-8').read().split('\n')
if any(l.rstrip() == 'import Mathlib' for l in lines):
    raise SystemExit
IMPORT = re.compile(r'^import\s+[A-Za-z_][A-Za-z0-9_.]*\s*$')
i, depth, first = 0, 0, -1
while i < len(lines):
    l = lines[i]
    if depth:
        depth += l.count('/-') - l.count('-/'); i += 1; continue
    s = l.strip()
    if s.startswith('/-'):
        depth = l.count('/-') - l.count('-/'); i += 1; continue
    if s == '' or s.startswith('--'):
        i += 1; continue
    if IMPORT.match(l):
        if first < 0: first = i
        i += 1; continue
    break
assert first >= 0, p
lines.insert(first, 'import Mathlib')
open(p, 'w', encoding='utf-8').write('\n'.join(lines))
print('    restored umbrella:', p)
PY
}

# Build, and repair any module the wave stripped the library from.  Returns 0 iff green.
build_and_repair () {
  local wave=$1
  for attempt in 1 2 3 4; do
    local log="/tmp/ajc-wave$wave-build$attempt.log"
    lake build > "$log" 2>&1 && return 0
    local broken
    broken=$(grep '^error: AlgebraicJacobian' "$log" | sed 's/^error: \([^:]*\):.*/\1/' | sort -u)
    if [ -z "$broken" ]; then
      echo "  !! wave $wave build failed with no per-module error; see $log"
      tail -20 "$log"
      return 1
    fi
    echo "  wave $wave attempt $attempt: repairing $(echo "$broken" | grep -c .) cascade victim(s)"
    while IFS= read -r f; do [ -n "$f" ] && add_umbrella "$f"; done <<< "$broken"
  done
  echo "  !! wave $wave still red after 4 repair attempts"
  return 1
}

wave=0
while [ "$wave" -lt "$MAX_WAVES" ]; do
  wave=$((wave + 1))
  mapfile -t READY < <(ready_modules)
  [ "${#READY[@]}" -eq 0 ] && { echo "== no module is ready; stopping after $((wave - 1)) wave(s)"; break; }

  echo "== wave $wave: ${#READY[@]} module(s) ready"
  printf '%s\n' "${READY[@]}" | xargs -P "$JOBS" -I{} bash "$HERE/deumbrella.sh" {}

  converted=0
  for f in "${READY[@]}"; do grep -qx 'import Mathlib' "$f" || converted=$((converted + 1)); done
  [ "$converted" -eq 0 ] && { echo "== wave $wave converted nothing; stopping"; break; }

  echo "== wave $wave: converted $converted, building"
  build_and_repair "$wave" || { echo "== stopping: wave $wave could not be brought green"; exit 1; }
  echo "== wave $wave green"
done

echo "== bare \`import Mathlib\` modules remaining: $(grep -rlx 'import Mathlib' AlgebraicJacobian --include=*.lean | wc -l)"
