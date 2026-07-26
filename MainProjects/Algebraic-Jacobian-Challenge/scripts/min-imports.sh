#!/usr/bin/env bash
# Compute the minimal Mathlib import set for one module of this package.
#
#   scripts/min-imports.sh AlgebraicJacobian/Picard/Foo.lean [outdir]
#
# Uses Mathlib's `#import_bumps` (the `linter.minImports` linter).  The linter
# reports, at end of file, both the imports that are missing and the declared
# imports that are unneeded.  We run it on a copy in $outdir so the real source
# is never touched and Lake's build products stay valid.
#
# Output on stdout, machine readable:
#   MISSING <module>       (one per line, an import to add)
#   UNNEEDED <module>      (one per line, a declared import that is not needed)
#   STATUS ok|error
#
# The raw Lean output is left in $outdir/<basename>.out for inspection.
set -uo pipefail

SRC=${1:?usage: min-imports.sh <file.lean> [outdir]}
OUT=${2:-/tmp/ajc-minimports}
mkdir -p "$OUT"

base=$(basename "$SRC" .lean)
tmp="$OUT/$base.probe.lean"
raw="$OUT/$base.out"

# Insert `#import_bumps` immediately after the import header.
#
# The header must be delimited structurally, not by "the last line starting with
# `import `": prose inside a module docstring can begin with that word (it does in
# Cohomology/RegroupHelper.lean), and inserting the macro into a comment makes the
# linter silently never fire.  Lean requires every import before the first command,
# so walk from the top through comment blocks, blank lines and real import lines and
# stop at the first command.
python3 - "$SRC" "$tmp" <<'PY'
import re
import sys

src, dst = sys.argv[1], sys.argv[2]
lines = open(src, encoding="utf-8").read().split("\n")

IMPORT = re.compile(r"^import\s+[A-Za-z_][A-Za-z0-9_.]*\s*$")
i, depth, last = 0, 0, -1
while i < len(lines):
    l = lines[i]
    if depth:
        depth += l.count("/-") - l.count("-/")
        i += 1
        continue
    s = l.strip()
    if s.startswith("/-"):
        depth = 1 + l.count("/-") - l.count("-/") - 1
        i += 1
        continue
    if s == "" or s.startswith("--"):
        i += 1
        continue
    if IMPORT.match(l):
        last = i
        i += 1
        continue
    break                                    # first real command
assert last >= 0, f"no import line in {src}"
lines.insert(last + 1, "#import_bumps")
open(dst, "w", encoding="utf-8").write("\n".join(lines))
PY

# `lake env lean` does not apply the lakefile's [leanOptions]; pass them explicitly
# so the probe elaborates under the same configuration as the real build.
lake env lean \
  -Dpp.unicode.fun=true \
  -DrelaxedAutoImplicit=false \
  -DmaxSynthPendingDepth=3 \
  -Dweak.linter.mathlibStandardSet=true \
  "$tmp" > "$raw" 2>&1
rc=$?

python3 - "$raw" <<'PY'
import re, sys
txt = open(sys.argv[1], encoding="utf-8", errors="replace").read()
for m in re.finditer(r"unneeded import '([^']+)'", txt):
    print("UNNEEDED", m.group(1))
m = re.search(r"-- missing imports\n((?:import [^\n]+\n?)+)", txt)
if m:
    for line in m.group(1).strip().split("\n"):
        print("MISSING", line.split(None, 1)[1].strip())
PY

if [ $rc -eq 0 ]; then echo "STATUS ok"; else echo "STATUS error"; fi
exit 0
