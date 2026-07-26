#!/usr/bin/env bash
# Replace a module's bare `import Mathlib` by the precise Mathlib imports it needs.
#
#   scripts/deumbrella.sh AlgebraicJacobian/Picard/Foo.lean
#
# Procedure: probe with `scripts/min-imports.sh` (Mathlib's `#import_bumps`
# linter), rewrite the import block, then re-elaborate the file with
# `lake env lean`.  On any failure the original file is restored, so the tree is
# never left broken.  Prints one summary line:
#
#   OK    <file>  <n> precise imports (was: import Mathlib)
#   SKIP  <file>  <reason>
#   FAIL  <file>  <reason>   (original restored)
#
# A module only stops paying for the umbrella once NO module in its transitive
# project-import closure is bare, so convert DAG sources first.
set -uo pipefail

SRC=${1:?usage: deumbrella.sh <file.lean>}
HERE=$(cd "$(dirname "$0")" && pwd)
OUT=${AJC_DEUMBRELLA_OUT:-/tmp/ajc-minimports}
mkdir -p "$OUT"

grep -qx 'import Mathlib' "$SRC" || { echo "SKIP  $SRC  no bare import Mathlib"; exit 0; }

probe="$OUT/$(basename "$SRC" .lean).probe.txt"
bash "$HERE/min-imports.sh" "$SRC" "$OUT" > "$probe" 2>&1

grep -q '^STATUS ok' "$probe" || { echo "SKIP  $SRC  probe did not elaborate (see $probe)"; exit 0; }
grep -qx "UNNEEDED Mathlib" "$probe" || { echo "SKIP  $SRC  linter did not report Mathlib unneeded"; exit 0; }

bak="$SRC.deumbrella.bak"
cp "$SRC" "$bak"

python3 - "$SRC" "$probe" <<'PY'
import sys
src, probe = sys.argv[1], sys.argv[2]
missing = [l.split(None, 1)[1].strip()
           for l in open(probe, encoding="utf-8") if l.startswith("MISSING ")]
mathlib = sorted(m for m in missing if m == "Mathlib" or m.startswith("Mathlib."))
other = [m for m in missing if m not in mathlib]

lines = open(src, encoding="utf-8").read().split("\n")
out, done = [], False
for l in lines:
    if l == "import Mathlib" and not done:
        out.extend(f"import {m}" for m in mathlib)
        out.extend(f"import {m}" for m in other)
        done = True
        continue
    out.append(l)
open(src, "w", encoding="utf-8").write("\n".join(out))
print(len(mathlib) + len(other))
PY

n=$(grep -c '^import Mathlib\.' "$SRC")

if lake env lean \
     -Dpp.unicode.fun=true \
     -DrelaxedAutoImplicit=false \
     -DmaxSynthPendingDepth=3 \
     -Dweak.linter.mathlibStandardSet=true \
     "$SRC" > "$OUT/$(basename "$SRC" .lean).verify.txt" 2>&1; then
  rm -f "$bak"
  echo "OK    $SRC  $n precise imports"
else
  mv "$bak" "$SRC"
  echo "FAIL  $SRC  verification failed, restored (see $OUT/$(basename "$SRC" .lean).verify.txt)"
fi
