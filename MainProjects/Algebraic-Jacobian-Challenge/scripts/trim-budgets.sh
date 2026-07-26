#!/usr/bin/env bash
# Remove the elaboration-budget `set_option` scopes a module no longer needs.
#
#   scripts/trim-budgets.sh AlgebraicJacobian/Picard/Foo.lean
#
# Mathlib v4.31.0 contains ZERO `set_option maxHeartbeats N in` under Mathlib/ and exactly one
# `synthInstance.maxHeartbeats`.  Every budget here is therefore a deviation that has to earn its
# place.  This script deletes ALL of a module's `maxHeartbeats` / `synthInstance.maxHeartbeats`
# / `maxRecDepth` scope lines at once and re-elaborates the file; if it still elaborates at Lean
# defaults the deletion stands, otherwise the file is restored untouched (then bisect by hand or
# measure the survivors with Mathlib's `count_heartbeats in`).
#
# `lake env lean` is used rather than `lake build`, so the build tree is never invalidated.
# Prints: OK <file> removed <n> | KEEP <file> still needed (<n> scopes) | SKIP <file> none
set -uo pipefail

SRC=${1:?usage: trim-budgets.sh <file.lean>}
OUT=${AJC_DEUMBRELLA_OUT:-/tmp/ajc-minimports}
mkdir -p "$OUT"
base=$(basename "$SRC" .lean)

n=$(grep -cE '^set_option (maxHeartbeats|synthInstance\.maxHeartbeats|maxRecDepth) [0-9]+ in$' "$SRC")
[ "$n" -eq 0 ] && { echo "SKIP  $SRC  no scoped budgets"; exit 0; }

bak="$SRC.budgets.bak"
cp "$SRC" "$bak"
grep -vE '^set_option (maxHeartbeats|synthInstance\.maxHeartbeats|maxRecDepth) [0-9]+ in$' "$bak" > "$SRC"

if lake env lean \
     -Dpp.unicode.fun=true \
     -DrelaxedAutoImplicit=false \
     -DmaxSynthPendingDepth=3 \
     -Dweak.linter.mathlibStandardSet=true \
     "$SRC" > "$OUT/$base.budgets.txt" 2>&1; then
  rm -f "$bak"
  echo "OK    $SRC  removed $n budget scopes"
else
  mv "$bak" "$SRC"
  echo "KEEP  $SRC  $n scopes still needed (see $OUT/$base.budgets.txt)"
fi
