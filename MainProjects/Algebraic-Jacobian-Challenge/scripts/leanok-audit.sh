#!/usr/bin/env bash
# Is every blueprint `\leanok` honest?  Run from the project root:
#
#   scripts/leanok-audit.sh
#
# A `\leanok` is a LOCAL mark, but the defect it can hide is TRANSITIVE: a proof
# genuinely written in Lean is still not proved if it routes through a `sorry`, and
# nothing at the mark says so.  So the marks have to be joined against the axioms of
# the declarations they pin.  Reading cannot answer this question; that is the whole
# reason this script exists.
#
# Two positions, two different claims, measured SEPARATELY:
#
#   * a PROOF-level mark says the proof is formalised.  One on a `sorryAx` carrier is
#     a DEFECT.  Expected count: 0.
#   * a STATEMENT-level mark says the signature is formalised, which is TRUE of a
#     `sorry`-bodied declaration.  One on a `sorryAx` carrier is LEGITIMATE and must
#     NOT be "fixed".  Expected count: 34 and growing, as the open chapters take
#     landings.
#
# THE RECONCILIATION IDENTITY IS THE CHECK.  `public + private + unresolved == pins`
# is asserted per position, in code, and the script fails on a shortfall.  Six
# separate domain-shrinking bugs have been found in this audit, each of which printed
# a plausible `0 defects` line while examining a strict subset:
#
#   1. `#print axioms` on an absent name is an error and `lean` halts at 100 of them,
#      truncating the audit silently.  (Gone: `collectAxioms` returns a value.)
#   2. an output log matched by its own input glob and re-ingested as a batch.
#   3. a parser anchored on the closing quote of `'<name>'`, dropping every name
#      containing an apostrophe -- 49 pins do.
#   4. `#print axioms` printing `does not depend on any axioms`, a DIFFERENT sentence
#      that a `depends on axioms: [...]` regex never matches.
#   5. `split` numbering past `az` to `ba`, so a `lk_a*` glob skipped 33 pins.
#   6. `re.search` keeping only the FIRST `\lean{}` macro of a statement; two nodes in
#      `Picard_QuotScheme.tex` carry several, worth 8 pins.
#
# Only #5 and #6 were caught by the assertion after it was in place -- each had
# survived a careful reading of the code first.  #6 was found by chasing a DOMAIN
# disagreement (1552 vs 1560) against a second extractor that already AGREED on the
# answer (34): when two independent measurements agree on the finding and differ on
# how much they looked at, the gap is the thing to chase, because domain size is
# exactly what the false clean lines were wrong about.
#
# Two design points that are not incidental:
#
#   * environments are matched with an explicit STACK, not a non-greedy regex.  A
#     regex reaches past the true `\end{theorem}` whenever anything intervenes, and
#     that silently pairs one node's statement with a LATER node's proof.  It was the
#     entire source of three retracted "dishonest mark" findings.
#   * axioms come from `Lean.collectAxioms`, not `#print axioms`.  The latter resolves
#     through the EXPORTED environment, so a `private` constant is unaddressable from
#     outside its defining file; the former runs against `setExporting false` and
#     decides all of them.  188 statement-level pins are private.  "My probe cannot
#     see it" is a fact about the probe.
#
# The private lane carries a POSITIVE CONTROL, without which "zero private pins carry
# sorryAx" is indistinguishable from a lane measuring nothing: exactly one private pin
# DOES carry it.  The script checks the control fired and fails if it did not.
set -euo pipefail

cd "$(dirname "$0")/.."
WORK="${TMPDIR:-/tmp}/leanok-audit.$$"
mkdir -p "$WORK"
trap 'rm -rf "$WORK"' EXIT

# The one private pin that must show up as a sorryAx carrier, or the private lane is
# not actually measuring anything.
CONTROL='AlgebraicGeometry.Scheme.RationalMap.av_indeterminacyLocus_eq_empty'

echo '== step 1: extract the marks =='
WORK="$WORK" python3 - <<'PY'
import re, glob, json, os
WORK = os.environ['WORK']
ENVS = {'theorem','lemma','proposition','corollary','definition','remark',
        'example','notation','convention'}

def strip_comments(t):
    """A `%` comment can hold a \\begin{proof} or an \\end{theorem}.  Honour
    backslash escapes so `\\%` is not treated as a comment start."""
    out = []
    for line in t.split('\n'):
        i = 0
        while i < len(line):
            if line[i] == '\\':
                i += 2
                continue
            if line[i] == '%':
                line = line[:i]
                break
            i += 1
        out.append(line)
    return '\n'.join(out)

TOK = re.compile(r'\\(begin|end)\{([^}]*)\}')

def top_level_envs(t):
    """Every environment at nesting depth 0, as
    (name, inner_start, inner_end, outer_start, outer_end)."""
    stack, out = [], []
    for m in TOK.finditer(t):
        if m.group(1) == 'begin':
            stack.append((m.group(2), m.end(), m.start()))
        else:
            while stack:
                nm, s, os_ = stack.pop()
                if nm == m.group(2):
                    if not stack:
                        out.append((nm, s, m.start(), os_, m.end()))
                    break
    return out

stmt, proof = [], []
nodes = 0
for fn in sorted(glob.glob('blueprint/src/chapters/*.tex')):
    t = strip_comments(open(fn).read())
    envs = top_level_envs(t)
    base = fn.split('/')[-1]
    for i, (name, s, e, os_, oe) in enumerate(envs):
        if name not in ENVS:
            continue
        body = t[s:e]
        lab = re.search(r'\\label\{([^}]*)\}', body)
        # findall, not search: a statement may carry SEVERAL \lean{} macros.
        leans = re.findall(r'\\lean\{([^}]*)\}', body)
        if not (lab and leans):
            continue
        nodes += 1
        pins = [x.strip() for g in leans for x in g.split(',') if x.strip()]
        if '\\leanok' in body:
            stmt += [(base, lab.group(1), d) for d in pins]
        nxt = envs[i + 1] if i + 1 < len(envs) else None
        if nxt and nxt[0] == 'proof' and '\\leanok' in t[nxt[1]:nxt[2]]:
            proof += [(base, lab.group(1), d) for d in pins]

json.dump({'stmt': stmt, 'proof': proof}, open(f'{WORK}/marks.json', 'w'))
allpins = sorted({d for _, _, d in stmt} | {d for _, _, d in proof})
open(f'{WORK}/all_pins.txt', 'w').write('\n'.join(allpins) + '\n')
print(f'{nodes} statement nodes with \\label+\\lean; '
      f'{len(stmt)} statement-level and {len(proof)} proof-level marks; '
      f'{len(allpins)} distinct declarations to probe')
PY

echo '== step 2: axioms of every pin, private ones included =='
cat > "$WORK/axprobe.lean" <<LEAN
import AlgebraicJacobian
open Lean Elab Command
run_cmd do
  let names := ((← IO.FS.readFile "$WORK/all_pins.txt").splitOn "\n").filterMap fun s =>
    let s := s.trimAscii.toString
    if s.isEmpty then none else some s.toName
  let env ← getEnv
  let exported := env.setExporting true
  -- ONE fold over the environment builds the private reverse map.  One fold per
  -- unresolved name does not finish.
  let wanted : Std.HashSet Name := names.foldl (fun s n => s.insert n) {}
  let privMap : Std.HashMap Name (List Name) :=
    env.constants.fold (init := {}) fun acc c _ =>
      let u := privateToUserName c
      if u != c && wanted.contains u then acc.insert u (c :: (acc.getD u [])) else acc
  let mut out := #[]
  let mut nMissing := 0
  let mut nPublic := 0
  let mut nPrivate := 0
  let mut nBad := 0
  for n in names do
    match (if (exported.find? n).isSome then [n] else privMap.getD n []) with
    | [] =>
      nMissing := nMissing + 1
      out := out.push s!"{n}\tMISSING\t"
    | cs =>
      for c in cs do
        if c != n then nPrivate := nPrivate + 1 else nPublic := nPublic + 1
        let axs ← Lean.collectAxioms c
        if axs.contains \`\`sorryAx then nBad := nBad + 1
        out := out.push
          s!"{n}\t{if c != n then "private" else "public"}\t{String.intercalate "," (axs.toList.map toString)}"
  IO.FS.writeFile "$WORK/axout.txt" (String.intercalate "\n" out.toList ++ "\n")
  logInfo s!"pins={names.length} public={nPublic} private={nPrivate} missing={nMissing} sorryAxHits={nBad}"
LEAN
lake env lean "$WORK/axprobe.lean"

echo '== step 3: join, reconcile per position, check the control =='
WORK="$WORK" CONTROL="$CONTROL" python3 - <<'PY'
import json, os, sys, collections
WORK, CONTROL = os.environ['WORK'], os.environ['CONTROL']
marks = json.load(open(f'{WORK}/marks.json'))
ax, kind = {}, {}
for line in open(f'{WORK}/axout.txt'):
    if not line.strip():
        continue
    n, k, a = line.rstrip('\n').split('\t', 2)
    kind[n] = k
    # a user-facing name may resolve to several private constants: sorryAx anywhere counts
    ax[n] = ax.get(n, '') + ',' + a

rc = 0
for tag, ms, expect_defects in (('proof-level    ', marks['proof'], True),
                                ('statement-level', marks['stmt'], False)):
    pins = {d for _, _, d in ms}
    missing = pins - set(ax)
    assert not missing, f'{tag}: {len(missing)} pins produced NO output: {sorted(missing)[:5]}'
    pub = sum(1 for d in pins if kind[d] == 'public')
    priv = sum(1 for d in pins if kind[d] == 'private')
    assert pub + priv == len(pins), f'{tag}: {pub}+{priv} != {len(pins)} -- split does not reconcile'
    bad = sorted({(l, d, f) for f, l, d in ms if 'sorryAx' in ax[d]})
    nodes = {l for l, _, _ in bad}
    print(f'{tag}: {len(ms)} marks pinning {len(pins)} declarations = {pub} public '
          f'+ {priv} private, missing 0; {len(bad)} on sorryAx carriers '
          f'across {len(nodes)} nodes')
    if expect_defects:
        for l, d, f in bad:
            print(f'    DISHONEST {f} {l} {d}')
        if bad:
            rc = 1
    else:
        for f, c in sorted(collections.Counter(f for _, _, f in bad).items(),
                           key=lambda kv: -kv[1]):
            print(f'    legitimate: {c:3d}  {f}')

# The private lane must be shown to bite, or its clean lines mean nothing.
if 'sorryAx' in ax.get(CONTROL, ''):
    print(f'positive control OK: {CONTROL.split(".")[-1]} carries sorryAx, '
          f'so the private lane is measuring')
else:
    print(f'POSITIVE CONTROL FAILED: {CONTROL} no longer reports sorryAx.')
    print('Either it was proved (update CONTROL) or the private lane has stopped '
          'measuring anything. Do not trust a clean private result until this is settled.')
    rc = 1
sys.exit(rc)
PY
