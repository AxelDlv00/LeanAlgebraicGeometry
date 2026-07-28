/-
Axiom-frontier probe.  Not part of the library: run it with

    lake env lean scripts/axiom-frontier.lean

from the project root.  Every `#print axioms` line below reports the axioms a
declaration actually depends on, `sorryAx` included, so a declaration that is
locally `sorry`-free but consumes a `sorry`-bodied *instance* through typeclass
synthesis is exposed here and nowhere else.

What this probe does NOT establish is at least as important as what it does, so read
§6b, §6c and §8 before quoting any "clean" line as a completeness claim.  A clean axiom
set means one thing only: no `sorry` is reachable from that proof term.  It says nothing
about unproved or even false hypotheses carried in the statement.

Companion measurement — reachability of the headline.  `#print axioms` says what
the headline depends on; the import graph says what it *could* depend on.  A
headline importing only `Genus.lean` cannot rest on the Picard, cohomology or
Riemann-Roch work no matter what its docstring claims, so the size of its
transitive project-import closure is the honest check that the infrastructure is
wired to the stated theorem:

    python3 - <<'PY'
    import os, re
    def imports(m):
        p = m.replace('.', '/') + '.lean'
        return re.findall(r'^import\s+(AlgebraicJacobian[\w.]*)', open(p).read(), re.M) \
               if os.path.exists(p) else []
    seen, stack = set(), ['AlgebraicJacobian.Jacobian']
    while stack:
        m = stack.pop()
        if m not in seen:
            seen.add(m); stack += imports(m)
    total = sum(1 for _, _, fs in os.walk('AlgebraicJacobian') for f in fs
                if f.endswith('.lean'))
    print(f'{len(seen)} of {total} project modules reachable from the headline')
    PY

Re-measured 2026-07-28: 98 reachable modules of 187 on disk, and zero unrooted, up from
8 before `picardJacobianWitness` was wired to `Scheme.Pic0Scheme`.  The two most recent
additions are `Curve/GeometricallyReduced.lean`, which discharges the curve's geometric
integrality, and `Albanese/AlbaneseUP.lean`, which the headline now reaches because leaf C
is stated against the landed universal property (`isAlbanese_pic0_of_isAlgClosed`).
The denominator moves as modules land, so read the reachable count, not the ratio — and
note that the reachable count does *not* move when a module lands beside the headline
cone rather than under it, which is the normal case for the rigid-pushforward and
Riemann–Roch lanes.

How to read the output.  Every line is one declaration; the only token that matters is
`sorryAx`.  The clean/leaking split is worth summarising rather than eyeballing:

    lake env lean scripts/axiom-frontier.lean > /tmp/ax.txt
    python3 - <<'PY'
    import re
    entries = [e for e in re.split(r"\n(?=')", open('/tmp/ax.txt').read().strip())
               if e.startswith("'")]
    bad = [e.split("'")[1] for e in entries if 'sorryAx' in e]
    print(f'{len(entries)} probed, {len(entries) - len(bad)} clean, {len(bad)} carry sorryAx')
    for n in bad: print('  ', n)
    PY

Note the `re.split` rather than a plain line filter: Lean wraps a long axiom list over
several lines, so a per-line scan misclassifies exactly the declarations whose axiom
list is longest.  Measured 2026-07-28 through the root path, with `lake build
AlgebraicJacobian` green at 8746 jobs: **126 probed, 84 clean, 42 carrying `sorryAx`**
(125/84/41 before §0c added the branch-(1) assembly; 113/72/41 before §6f added the twelve
unconditional-χ lines; 107/70/37 before the two leaf-A lines in §0, the §0b obligation-count
pair, and the two chapter-keystone synthesis probes in §8).
Run the command above rather than adjusting this sentence's arithmetic by hand, which is
how the two previous counts here went wrong.

The `sorryAx` count is the one to watch, and the last two additions moved it in opposite
directions for the right reasons.  §6f added twelve declarations and left it at 41: a lane
whose declarations are all clean adds nothing to the frontier, which is the correct outcome
and also the reason a clean line is not by itself progress on the headline (§6b, §6d).  §0c
added one and moved it to 42, because the branch-(1) assembly leaks on the five obligations
behind it — five, because its `[HasRationalPoint C]` binder makes the gate FIRE exactly as
§0b describes, so the gate is among them.  Writing "four" here is the same miscount §0b
exists to prevent, and it was written and corrected once in this very paragraph.  Neither movement is a change in the mathematics — the frontier is the same five
obligations it was — which is why the number is worth re-measuring rather than reciting.

The two lines added last are the ones to read as a PAIR rather than individually, because
the gap between them carries the information. `hasRationalPoint_of_curve_of_isAlgClosed` is
clean — leaf A is a theorem over an algebraically closed field, so it is a discharge and not
a relocation. `picardJacobianWitnessOfIsAlgClosed`, the same witness assembled on it, still
leaks, and must: the synthesised gate `instHasPicScheme`, `Pic0.smooth`, `Pic0.proper` and
leaves B and C are open. What the pair establishes is that the residue over `k̄` consists of
five *true* statements awaiting proofs — five, not four; see §0b, which measures the gate
rather than letting the natural arithmetic drop it — where the general `picardJacobianWitness`
also carries a *false* one. Both witnesses report
`sorryAx` identically, so nothing in this file's output distinguishes them — which is exactly
why the discharge had to be exhibited rather than measured (compare §2b, trap (g)).

Of the two declarations added earlier on 2026-07-28, §0's leaf-B dimension count leaks (as
its own comment predicts — the dimension chain rests on
`finrank_cotangentSpaceDual_eq_finrank_h1Cok`) and §6c's gate at the challenge's own
hypothesis bundle is clean, which is the informative one: the rigid-pushforward gate is
available at the hypotheses of `Jacobian C` itself and not merely at a restatement of them.

One failure mode of this probe that is not a defect in it: `import AlgebraicJacobian` means a
single red module anywhere in the tree makes the whole frontier unmeasurable, and in a
workspace with several teams landing in parallel that happens. Distinguish the two shapes
before concluding anything — `object file ... does not exist` is a transient race with a
sibling's rebuild and is fixed by re-running `lake build AlgebraicJacobian` first, whereas a
`timeout at 'whnf'` or an elaboration error is a real red build and the frontier simply
cannot be quoted until it is green.

Companion measurement 2 — is every module on disk rooted?  A module that nothing
imports compiles green, is invisible to the root build, and is therefore invisible to
this probe as well: `import AlgebraicJacobian` does not reach it, so `#print axioms` on
its declarations cannot even be written here.  Replace the `stack` seed above with
`['AlgebraicJacobian']` and compare against the on-disk module list; the difference is
the set of modules whose axioms nobody is measuring.  It should be empty.

Companion measurement 3 — is every blueprint `\leanok` honest?  This one exists because
reading cannot answer it.  A `\leanok` is a local mark, but the defect is transitive: a
proof genuinely written in Lean is still not proved if it routes through a `sorry`, and
nothing at the mark says so.  So the mark has to be joined against `#print axioms`.

**The join must be over every mark, not over this file's output.**  That is the whole
design of the check and the earlier version of it got this backwards: it intersected the
marks with §0–§8, which name 126 declarations, so it could only ever see the ~50 marked
nodes this probe happens to mention.  Generate the axiom lines *from the marks* instead.

**Both mark positions have to be measured, and by the same identity.**  The two are
different claims — a proof-level mark says the proof is formalised, a statement-level one
says the signature is — so they are counted separately and only the proof-level ones can be
defects (see the end of this section).  Measured 2026-07-28 over every mark:

    proof-level:     1078 marks pinning 1073 declarations = 930 public + 143 private,
                     0 unresolved, ZERO carrying `sorryAx`
    statement-level: 1567 marks pinning 1560 declarations = 1372 public + 188 private,
                     0 unresolved, 34 carrying `sorryAx`, across 34 nodes,
                     none of which also carries a proof-level mark

Both triples add up, which is the point, and the pairing is the load-bearing part: the 34
are legitimate and the 0 is the defect count.

Read the second line as a correction with a moral.  It stood here as "eleven" for two
revisions, and eleven is *precisely the intersection with this file's own 126 lines* — the
very artifact the paragraph above retracts, still live one paragraph below its own
retraction.  So fixing a domain bug is not done when the instance is fixed: every OTHER
figure derived by the same broken route has to go through the same identity.  A count that
was never wrong for its own reasons can still be wrong for the reason just fixed, and the
reconciliation assertion certifies exactly the quantities routed through it.  This one
mattered more than the arithmetic, because the sentence carrying it is the sentence telling
readers *not* to delete those marks: a reader reconciling 11 against a real 34 concludes 23
are unaccounted for and starts deleting correct ones.

Reconcile `public + private + unresolved == pins` every time, in code, and fail on a
shortfall.  That identity is the only thing that catches this check silently shrinking its
own domain, and it caught **six** independent instances of exactly that, each of which had
printed a plausible `0 dishonest` line:

  - the 100-error cap below;
  - an output log named `/tmp/lk_all.txt` that a `/tmp/lk_a*` input glob then re-ingested
    as a 1617-line "batch";
  - a parser anchored on the *closing* quote of `'<name>'`, which drops every declaration
    whose name contains an apostrophe — 49 of these pins do (`chartTransition'_cocycle`,
    `HModule'_sequence_exact`, …).  Anchor on the fixed `' depends on axioms:` suffix;
  - `#print axioms` printing `does not depend on any axioms` — a *different sentence* —
    for an axiom-free declaration, which a `depends on axioms: [...]` regex never matches;
  - `split` numbering past `z`: 1073 pins at 40 per batch gives `lk_aa`…`lk_az` **and
    `lk_ba`**, so a `lk_a*` glob silently skips the last 33 pins.  Glob `lk_*`;
  - `re.search(r'\\lean\{([^}]*)\}')` keeping only the FIRST `\lean{}` macro of a
    statement.  Two nodes in `Picard_QuotScheme.tex` (`def:graded_subquotientHilb`,
    `lem:graded_lastVarAlgHom`) carry several, worth 8 pins.  Use `findall`.

Only the last three were found *after* the reconciliation assertion was in place, and they
are the reason it is worth having: each had survived a careful reading of the code.  The
sixth was found by a different route worth naming, because it is cheaper than reading: two
extractors sharing no code agreed on the *answer* (34) and disagreed on the *domain* (1552
against 1560).  When two independent measurements agree on the finding and differ on how
much they looked at, the agreement is not the thing to report — chase the gap, because
domain size is exactly what the false clean lines above were wrong about.

**Run it, do not re-transcribe it:** `scripts/leanok-audit.sh`, from the project root.
One command, three live checks — the reconciliation identity per mark position, and the
private lane's positive control — exiting non-zero if any fails.  The whole history below
is a history of *transcribed* recipes drifting from the code that produced their numbers,
so the recipe now lives in a script that is executed rather than in a comment that is
copied.  What follows explains what the script does and why each part is shaped that way;
the script is the authority.

Step 1, extract the marks.  Match environments with an explicit STACK rather than a
non-greedy regex: the regex reaches past the true `\end{theorem}` whenever anything
intervenes, which is failure mode 2 below and was the entire source of the three retracted
findings.

    python3 - <<'PY'
    import re, glob, json
    ENVS = {'theorem','lemma','proposition','corollary','definition','remark',
            'example','notation','convention'}
    def strip_comments(t):                    # a `%` comment can hold \end{theorem}
        out = []
        for line in t.split('\n'):
            i = 0
            while i < len(line):
                if line[i] == '\\': i += 2; continue
                if line[i] == '%':  line = line[:i]; break
                i += 1
            out.append(line)
        return '\n'.join(out)
    TOK = re.compile(r'\\(begin|end)\{([^}]*)\}')
    def top_level_envs(t):
        stack, out = [], []
        for m in TOK.finditer(t):
            if m.group(1) == 'begin':
                stack.append((m.group(2), m.end(), m.start()))
            else:
                while stack:
                    nm, s, os_ = stack.pop()
                    if nm == m.group(2):
                        if not stack: out.append((nm, s, m.start(), os_, m.end()))
                        break
        return out
    stmt, proof = [], []
    for fn in sorted(glob.glob('blueprint/src/chapters/*.tex')):
        t = strip_comments(open(fn).read()); envs = top_level_envs(t); base = fn.split('/')[-1]
        for i, (name, s, e, os_, oe) in enumerate(envs):
            if name not in ENVS: continue
            body = t[s:e]
            lab = re.search(r'\\label\{([^}]*)\}', body)
            leans = re.findall(r'\\lean\{([^}]*)\}', body)   # findall: a node may carry several
            if not (lab and leans): continue
            pins = [x.strip() for g in leans for x in g.split(',') if x.strip()]
            if '\\leanok' in body:
                stmt += [(base, lab.group(1), d) for d in pins]
            if i + 1 < len(envs) and envs[i+1][0] == 'proof' and '\\leanok' in t[envs[i+1][1]:envs[i+1][2]]:
                proof += [(base, lab.group(1), d) for d in pins]
    json.dump({'stmt': stmt, 'proof': proof}, open('/tmp/marks.json','w'))
    open('/tmp/all_pins.txt','w').write(
        '\n'.join(sorted({d for _,_,d in stmt} | {d for _,_,d in proof})) + '\n')
    PY

Step 2, decide the axioms of every pin — **including the `private` ones**.  Use
`Lean.collectAxioms`, not `#print axioms`: the latter resolves through the *exported*
environment, so a private constant is unaddressable from outside its defining file, whereas
`collectAxioms` runs against `env.setExporting false` and answers for all of them once the
private mangling is reversed.  Build the reverse map with ONE fold over the environment; one
fold per unresolved name does not finish.

    cat > /tmp/axprobe.lean <<'LEAN'
    import AlgebraicJacobian
    open Lean Elab Command
    run_cmd do
      let names := ((← IO.FS.readFile "/tmp/all_pins.txt").splitOn "\n").filterMap fun s =>
        let s := s.trimAscii.toString; if s.isEmpty then none else some s.toName
      let env ← getEnv
      let exported := env.setExporting true
      let wanted : Std.HashSet Name := names.foldl (fun s n => s.insert n) {}
      let privMap : Std.HashMap Name (List Name) :=
        env.constants.fold (init := {}) fun acc c _ =>
          let u := privateToUserName c
          if u != c && wanted.contains u then acc.insert u (c :: (acc.getD u [])) else acc
      let mut out := #[]
      let mut nMissing := 0; let mut nPublic := 0; let mut nPrivate := 0; let mut nBad := 0
      for n in names do
        match (if (exported.find? n).isSome then [n] else privMap.getD n []) with
        | [] => nMissing := nMissing + 1; out := out.push s!"{n}\tMISSING\t"
        | cs => for c in cs do
                  if c != n then nPrivate := nPrivate + 1 else nPublic := nPublic + 1
                  let axs ← Lean.collectAxioms c
                  if axs.contains ``sorryAx then nBad := nBad + 1
                  out := out.push s!"{n}\t{if c != n then "private" else "public"}\t{String.intercalate "," (axs.toList.map toString)}"
      IO.FS.writeFile "/tmp/axout.txt" (String.intercalate "\n" out.toList ++ "\n")
      logInfo s!"pins={names.length} public={nPublic} private={nPrivate} missing={nMissing} sorryAxHits={nBad}"
    LEAN
    lake env lean /tmp/axprobe.lean

Step 3, join and RECONCILE each position separately.  The assertion is the check.

    python3 - <<'PY'
    import json
    marks = json.load(open('/tmp/marks.json'))
    ax, kind = {}, {}
    for line in open('/tmp/axout.txt'):
        if not line.strip(): continue
        n, k, a = line.rstrip('\n').split('\t', 2)
        kind[n] = k; ax[n] = ax.get(n, '') + ',' + a     # several private constants may share a name
    for tag, ms in (('proof-level', marks['proof']), ('statement-level', marks['stmt'])):
        pins = {d for _, _, d in ms}
        missing = pins - set(ax)
        assert not missing, f'{tag}: {len(missing)} pins produced NO output: {sorted(missing)[:5]}'
        pub = sum(1 for d in pins if kind[d] == 'public')
        priv = sum(1 for d in pins if kind[d] == 'private')
        assert pub + priv == len(pins), f'{tag}: split does not reconcile'
        bad = sorted({(l, d, f) for f, l, d in ms if 'sorryAx' in ax[d]})
        print(f'{tag}: {len(ms)} marks pinning {len(pins)} = {pub} public + {priv} private, '
              f'missing 0; {len(bad)} on sorryAx carriers across {len({l for l,_,_ in bad})} nodes')
        for l, d, f in bad: print(f'   {"DISHONEST" if tag == "proof-level" else "stmt"} {f} {l} {d}')
    PY

The private lane needs a POSITIVE CONTROL, or "zero private pins carry `sorryAx`" is
indistinguishable from a lane that silently measures nothing.  It has one, which is why the
result is a measurement: exactly one private pin does carry `sorryAx`
(`Scheme.RationalMap.av_indeterminacyLocus_eq_empty`, statement-level only, correctly, and
among the 34).  Check that it still appears before believing the other 187.

Three failure modes of the naive version, each of which it exhibited, and all three
matter more than the arithmetic:

  1. **It required the proof to be textually adjacent** (`\end{theorem}\s*\n\s*
     \begin{proof}`).  Nodes in this tree routinely carry a `% SOURCE` comment block
     between statement and proof, so 452 of the 1311 pinned statement-with-proof pairs
     were never examined at all.
  2. **Non-greedy `(.*?)` then makes the regex reach PAST the true `\end{theorem}` to
     find an adjacent pair**, silently pairing one node's statement with a *later*
     node's proof.  It reported `thm:pic0_smooth` as claiming `\leanok` on a proof
     whose Lean is `sorry`; that "statement" in fact spanned nine `\label`s and the
     proof it picked up belongs to `thm:pic0_geom_irred`, which is proved and clean.
     Same shape for `thm:pic0_tangent_space_iso`, paired with
     `thm:dual_number_units_split`'s proof.  48 nodes were mis-attributed this way.
     **Both reported defects were artifacts: neither node carries a proof-level
     `\leanok` at all, and `git log` records that this is deliberate.**
  3. **`#print axioms` on an absent name is an error and `lean` halts at 100**, so a
     naive one-file audit reports on whatever it reached before the cap and looks
     complete.  This is the first of the six domain-shrinking bugs listed above; all
     six printed a clean line while examining a strict subset, which is why the
     reconciliation assertion is part of the recipe rather than hygiene.  Step 2 above
     drops this failure mode entirely rather than batching around it: `collectAxioms`
     returns a value per name instead of raising an error, so there is no cap to hit.

The `private` pins are DECIDED, and the way that claim changed is worth more than the
number.  143 of the 1073 proof-level pins (188 of 1560 at statement level) name `private`
declarations, concentrated in `Picard/TensorObjInverse.lean` (36),
`TensorObjSubstrate.lean` (21) and `Albanese/AuslanderBuchsbaum.lean` (21).  This file
published them twice as marks "whose honesty this method cannot decide either way", on the
grounds that auditing them would need a probe *inside* each defining file.  That is a true
statement about `#print axioms` and a false one about the method: `Lean.collectAxioms`
reaches every one of them from outside (step 2 above), and the answer is zero `sorryAx`.

So the general lesson, and it is the one that generalises past this check: **"my probe
cannot see it" is a fact about the probe.**  Before publishing a bound on a method, look for
a different tool in the same ecosystem that decides the question — a limit of the chosen
instrument reads exactly like a limit of the approach, and only one of those is worth
telling a reader about.

Only *proof*-level marks are defects here.  A **statement**-level `\leanok` on a `sorry`
carrier is legitimate: it claims the signature is formalised, which is true of a
`sorry`-bodied declaration.  There are **34**, none of which also carries a proof-level
mark, and they concentrate where the open cones are — 12 in `Picard_QuotScheme.tex`, 8 in
`Cohomology_CechHigherDirectImage.tex`, 4 in `Picard_IdentityComponent.tex`.  Expect the
count to grow as those chapters take landings; re-measure it rather than quoting this
sentence.  Do not "fix" them — the distinction is the convention, and deleting a correct
mark to make a report cleaner is the same error as leaving a false one.  `thm:pic0_smooth`
and `thm:pic0_proper` carry no `\leanok` in *either* position, which is right: their
statements *are* the `sorry`-bodied declarations.
-/
import AlgebraicJacobian

open AlgebraicGeometry AlgebraicGeometry.Scheme

-- §0 THE FIVE OBLIGATIONS OF THE HEADLINE, after the étale rewire of 2026-07-28.
-- The headline witness `picardJacobianWitness` is now assembled from `Pic0SchemeEt`
-- (`Picard/Pic0Et.lean`) with NO rational-point binder, so its obligations are:
--   1. `Scheme.fgaPicardRepresentability`  -- representability of the ÉTALE-sheafified
--      relative Picard functor over an arbitrary field (the project's central open
--      obligation, expected to stay open);
--   2. `Scheme.Pic0Et.smooth`, 3. `Scheme.Pic0Et.proper`  -- the two Kleiman §5
--      statements about the identity component.  Both are ASSEMBLIES, not bare
--      `sorry`s: their actual residues are `Pic0Et.geometricallyReduced` (Cartier in
--      char 0) and `Pic0Et.universallyClosed` (Kleiman §5 `th:qpp&p`), probed below.
--      Cite THOSE, not smoothness and properness, when sizing what is left;
--   4. `smoothOfRelativeDimension_genus_pic0Et`, 5. `isAlbanese_pic0Et`  -- the two
--      étale leaves stated at exactly the strength the assembly consumes.
-- COUNT UNCHANGED AT FIVE; what changed is that **none of the five is a false
-- statement** any more.  The deleted leaf `hasRationalPoint_of_curve` asserted a
-- rational point from the challenge hypotheses alone and was FALSE, so the witness
-- rested on an inconsistent hypothesis and its consequences were vacuously true --- a
-- state no axiom check can distinguish from an honest one.  That is the deliverable of
-- the rewire, and it is not visible in these axiom sets: every line below still reports
-- `sorryAx`.  What IS visible is that `hasRationalPoint_of_curve` no longer exists to
-- probe, and that the witness now elaborates without a `[HasRationalPoint C]` binder.
#print axioms AlgebraicGeometry.Scheme.fgaPicardRepresentability
#print axioms AlgebraicGeometry.Scheme.Pic0Et.smooth
#print axioms AlgebraicGeometry.Scheme.Pic0Et.proper
-- the actual residues of those two, one statement each:
#print axioms AlgebraicGeometry.Scheme.Pic0Et.geometricallyReduced
#print axioms AlgebraicGeometry.Scheme.Pic0Et.universallyClosed
#print axioms AlgebraicGeometry.smoothOfRelativeDimension_genus_pic0Et
#print axioms AlgebraicGeometry.isAlbanese_pic0Et

-- The étale functor itself, and the sheaf property that makes the obligation above a
-- CONSISTENT statement rather than a false one.  These are the parts that are PROVED:
-- clean lines here are the substance of the rewire.
#print axioms AlgebraicGeometry.Scheme.PicSharp.etaleSheaf
#print axioms AlgebraicGeometry.Scheme.PicSharp.etaleSheaf_isSheaf
#print axioms AlgebraicGeometry.Scheme.PicScheme.picEt_isSheaf_forget
#print axioms AlgebraicGeometry.Scheme.zariskiTopologyOver_le_etaleTopologyOver
#print axioms AlgebraicGeometry.Scheme.Pic0Et.grpObj
#print axioms AlgebraicGeometry.Scheme.Pic0Et.geometricallyIrreducible
#print axioms AlgebraicGeometry.Scheme.Pic0Et.locallyOfFiniteType
#print axioms AlgebraicGeometry.Scheme.Pic0Et.isSeparated

-- The legacy `picSharp`-shaped leaves, retained: they are the obligations of the
-- CONDITIONAL milestone `picardJacobianWitnessOfHasRationalPoint`, not of the headline.
#print axioms AlgebraicGeometry.smoothOfRelativeDimension_genus_pic0
#print axioms AlgebraicGeometry.isAlbanese_pic0
#print axioms AlgebraicGeometry.Scheme.picSchemeOfHasRationalPoint

-- The half of the former combined leaf `hasRationalPoint_and_geometricallyIntegral`
-- that turned out to be a theorem rather than a decision: geometric integrality of the
-- curve follows from the challenge hypotheses via `Smooth.geometricallyReduced`
-- (`Curve/GeometricallyReduced.lean`).  Clean here means it really is discharged, not
-- that a hypothesis was moved.
#print axioms AlgebraicGeometry.geometricallyIntegral_of_curve

-- Leaf A over an algebraically closed field, and the witness assembled without it.  The
-- FIRST of these is a genuine discharge and reads clean, which distinguishes it from leaf B's
-- and leaf C's `_of_isAlgClosed` companions: those record a distance and leak.  The SECOND
-- still leaks, and what it leaks on is measured in §0b below rather than asserted --- an
-- earlier revision of this comment claimed the residue over `k̄` was "the four ordinary
-- obligations" and was WRONG, because discharging leaf A does not remove the gate it
-- discharges: it makes `instHasPicScheme` fire instead of being assumed.
--
-- What the pair does establish, and it is the point: over `k̄` every remaining obligation is a
-- TRUE statement awaiting a proof, where the general witness also carries a FALSE one.  That
-- distinction is invisible here --- trap (c) means a witness resting on an inconsistent leaf
-- reports the same `sorryAx` as an honest one --- so it has to be established by exhibiting
-- the discharge, which is what the clean line does.
#print axioms AlgebraicGeometry.hasRationalPoint_of_curve_of_isAlgClosed
#print axioms AlgebraicGeometry.picardJacobianWitnessOfIsAlgClosed

-- Leaf B at the strength the landed development reaches: the dimension count
-- `dim T_e Pic⁰_{C/k} = genus C` holds at the headline with no transport, so what leaf B
-- still owes is `Pic0.smooth` plus the passage from a tangent-space dimension to Mathlib's
-- presentation-based `SmoothOfRelativeDimension` — which has no bridge in either direction.
-- Like leaf C's `_of_isAlgClosed` companion this reports `sorryAx`, and for the same reason:
-- it is a faithful record of a distance, not a discharge.
#print axioms AlgebraicGeometry.finrank_tangentSpace_pic0_eq_genus

-- Leaf C at the strength the landed Albanese development actually reaches.  This is a
-- theorem, so what it measures is the DISTANCE from the leaf: over an algebraically closed
-- field, in positive genus, and given the basepoint condition, the universal property is
-- `Albanese.Pic0.albanese_universal_property` on the nose.  It reports `sorryAx` all the
-- same, because `Pic0.abelJacobi` is unconstructed -- which is the honest reading: a faithful
-- record of where the mathematics stops is not a discharge.
#print axioms AlgebraicGeometry.isAlbanese_pic0_of_isAlgClosed

/-! §0b How many obligations does the witness over `k̄` actually rest on?  FIVE, not four,
and the pair below is why the answer had to be measured.

The tempting arithmetic is: five obligations, leaf A discharged over `k̄`, therefore four.
It is wrong, and the reason is trap (a) landing on the very declaration whose docstring warns
about trap (c).  `Scheme.Pic0Scheme` carries `[HasPicScheme C]` among its binders, whose sole
producer is the `sorry`-bodied `instHasPicScheme` (§2).  Over a general field that gate hides
*behind* leaf A --- the leaf is what supplies `HasRationalPoint`, from which the gate is
synthesised --- so counting it separately looks like double-counting.  Discharging leaf A does
not remove the gate; it makes the gate FIRE.  So the gate is a free-standing fifth obligation
over `k̄`, and it is the one nobody was counting.

`probe_pic0Scheme_named_of_isAlgClosed` isolates this: it discharges leaf A and then merely
*names* `Pic0Scheme C`, with no `Pic0.smooth`, no `Pic0.proper`, and neither leaf B nor leaf C
anywhere in the term.  It still reports `sorryAx`.  The control assumes the gate instead of
synthesising it and is clean, which pins the leak to synthesis and to nothing else.

The claim that survives, and it is the one worth publishing: over `k̄` all five remaining
obligations are TRUE statements awaiting proofs, where the general-field witness carries a
FALSE one among them.  "Four" was a count; the kind of obligation is the content. -/
section Section0b

open AlgebraicGeometry

universe u₀

variable {k : Type u₀} [Field k] (C : CategoryTheory.Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]

/-- Leaf A discharged, then `Pic⁰_{C/k̄}` merely named.  Leaks: the gate is synthesised. -/
noncomputable def probe_pic0Scheme_named_of_isAlgClosed [IsAlgClosed k] :
    CategoryTheory.Over (Spec (.of k)) := by
  haveI := hasRationalPoint_of_curve_of_isAlgClosed C
  haveI : GeometricallyIntegral C.hom := geometricallyIntegral_of_curve C
  haveI := Scheme.picSchemeOfHasRationalPoint C
  exact Scheme.Pic0Scheme C

/-- The control: the same object with `HasPicScheme` assumed rather than synthesised.  Clean,
which is what isolates the leak above to the gate. -/
noncomputable def probe_pic0Scheme_named_gateAssumed [GeometricallyIntegral C.hom]
    [Scheme.HasPicScheme C] : CategoryTheory.Over (Spec (.of k)) :=
  Scheme.Pic0Scheme C

#print axioms probe_pic0Scheme_named_of_isAlgClosed
#print axioms probe_pic0Scheme_named_gateAssumed

end Section0b

/-! §0c Branch (1) of the open decision I-0372, as a compiled definition rather than a
description.

`picardJacobianWitnessOfHasRationalPoint` is the FGA assembly with `[HasRationalPoint C]` as
a binder instead of a source, and `picardJacobianWitness` /
`picardJacobianWitnessOfIsAlgClosed` are both `haveI` specialisations of it. Two things follow
that are worth having measured.

First, it *leaks* — the synthesised gate `instHasPicScheme`, `Pic0.smooth`, `Pic0.proper`, and
leaves B and C are open — and that is the honest reading of "branch (1) is cheap": cheap means
no NEW mathematics beyond those FIVE, not that a headline carrying `C(k) ≠ ∅` is available
today. The clean/leak split here says precisely which of the two.

Second, note what it does *not* measure, and that the count above is five for the reason §0b
gives. Under this binder the representability gate is *synthesised*, not assumed, so it is one
of the obligations rather than a hypothesis of the statement — the same step at which "five
becomes four" was wrongly asserted twice before. §0b's pair, not this line, is where the gate
is visible. Comparing this line against `picardJacobianWitness`
tells you nothing at all, because both leak and for overlapping reasons; the informative
comparison is §0b's. -/
#print axioms AlgebraicGeometry.picardJacobianWitnessOfHasRationalPoint

-- §1 The headline (AlgebraicJacobian/Jacobian.lean, AbelJacobi.lean)
#print axioms AlgebraicGeometry.picardJacobianWitness
#print axioms AlgebraicGeometry.nonempty_jacobianWitness
#print axioms AlgebraicGeometry.jacobianWitness
#print axioms AlgebraicGeometry.Jacobian
#print axioms AlgebraicGeometry.Jacobian.instGrpObj
#print axioms AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus
#print axioms AlgebraicGeometry.Jacobian.instIsProper
#print axioms AlgebraicGeometry.Jacobian.instGeometricallyIrreducible
#print axioms AlgebraicGeometry.IsAlbanese
#print axioms AlgebraicGeometry.IsAlbanese.unique
#print axioms AlgebraicGeometry.Jacobian.ofCurve
#print axioms AlgebraicGeometry.Jacobian.comp_ofCurve
#print axioms AlgebraicGeometry.Jacobian.exists_unique_ofCurve_comp
#print axioms AlgebraicGeometry.genus

/-! §2 Trap (a) is now EMPTY: there are no `sorry`-bodied instances left.

An instance is the only kind of `sorry` carrier a consumer can pick up *without naming it*:
every other carrier has to be written down by whoever depends on it, whereas an instance
arrives through synthesis, so a declaration merely *quantifying* over it reports clean axioms
while every *synthesis site* silently acquires `sorryAx`. That is trap (a), and §8 used to
measure its consequence.

**As of 2026-07-28 the surface is empty.** Both offenders were demoted to plain theorems in the
same window, by the two lanes that owned them:

* `instHasPicScheme` → the theorem `Scheme.picSchemeOfHasRationalPoint` (ajc-etale-pic);
* `pullback_preservesFiniteLimits` and `pullback_preservesHomology` → plain theorems (ajc-fbc),
  with their in-file consumers citing them explicitly via `haveI`.

Measured at HEAD over the rooted tree: **28 `sorry`-bodied declarations** over 11 modules, of
which **21 theorem + 7 def + 0 instance**. Re-derive that split with the command below rather
than trusting this paragraph — the whole point of the section is that the claim rots.

Consequences for how to read this file. A `sorryAx` line can no longer appear at a site that
does not name its carrier, so a *clean* line is now somewhat stronger evidence than it was, and
the §8 synthesis-site probes measure explicit dependencies rather than invisible ones. What has
NOT changed: a clean axiom set still says nothing about unproved or false hypotheses in the
statement (§6b, §6c, §8), and the underlying mathematics is exactly as unfinished as before —
demoting an instance closes a leak *mechanism*, it does not prove anything.

One trap the demotion introduced, worth knowing before reading any probe here: a probe written
over a DEGENERATE argument (the identity morphism, a terminal object, a trivial ring) measures
its intended declaration only while no cheaper instance path exists. Change the instance graph
and it silently starts measuring something else, and the symptom is a leaking line turning clean
for no mathematical reason. That happened to this file's own flat-pullback probe — see §6's
`leakProbe_pullback_finiteLimits`, restated for exactly this reason. Probe over a general
argument, name the carrier, and ship a control that must come out the other way.

The historical enumeration, retained because the per-module shape is still useful: the 24
non-instance carriers as of the measurement above were

  Jacobian.lean          `hasRationalPoint_of_curve`, `smoothOfRelativeDimension_genus_pic0`,
                         `isAlbanese_pic0`                                    (the three leaves)
  IdentityComponent      `degree`, `finrank_eq_genus`, `kPoints_iff_kerDegree`
  Pic0AbelianVariety     `finrank_cotangentSpaceDual_eq_finrank_h1Cok`, `smooth`, `proper`
  AlbaneseUP             `abelJacobi`, `SymmetricPower`, `symmetricPowerAVMap`,
                         `symmetricPowerToJacobian`, `descentThroughBirationalSigma`,
                         `albanese_eq_iff_symmetricPower_eq`
  QuotFunctorDef         `Modules.pullbackTensorMap_isIso`, `gammaFiber_finrank_baseChange_field`
  SerreFiniteness        `sectionGradedModule_fg`, `gradedHilbert_fiber`
  QuotRepresentability   `QuotScheme`
  CodimOneExtension      `indeterminacy_pure_codim_one_into_grpScheme`
  WeilDivisor            `principal_degree_zero`
  CechHigherDirectImageUnconditional
                         `cech_pushforward_baseChange_natIso`, `twisted_cech_nerve_iso`
                         (two `fun _ => sorry` fields, so they are carriers even though the
                         declarations are not themselves bare `sorry` bodies)

To re-derive rather than trust that list, and to see immediately if it has drifted:

    lake build AlgebraicJacobian 2>&1 | grep 'declaration uses' | sort -u

Each line is one carrier, `file:line:col`. Which of them are instances is a source question at
those lines, not something the build reports. Do not derive the count by grepping the sources
for `:= sorry`: that misses the last two entries above, whose `sorry` sits in a structure field,
and it counts prose mentions of the word. Two earlier revisions of this file got the arithmetic
wrong in exactly one of those ways, which is the reason the command is written out here rather
than the number alone.

"There are no instances among the carriers" is what the whole synthesis-leak argument now rests
on, so check it against the DECLARATION KEYWORD at each carrier line rather than against any
prose in this file — a prose list is the thing that rots, and reading this file is exactly how
you would miss an instance added back to it:

    lake build AlgebraicJacobian 2>&1 | grep 'declaration uses' | sort -u |
      while read -r l; do
        f=${l#warning: }; f=${f%%:*}
        n=$(printf '%s' "$l" | sed 's/.*\.lean:\([0-9]*\):.*/\1/')
        sed -n "${n}p" "$f" | grep -oE '(instance|theorem|def)' | head -1
      done | sort | uniq -c

Measured at HEAD 2026-07-28, after both demotions: **21 theorem + 7 def + 0 instance = 28**.
(An earlier revision of this paragraph read "17 theorem + 7 def + 2 instance = 26" and was
correct when written; both instances were demoted the same day.  If you find it disagreeing with
the command again, trust the command.)  Note the line numbers move as docstrings are edited, so
re-run the build rather than reusing a saved carrier list — a stale list silently misattributes a
keyword to whatever now sits at that line. -/
-- Both former leaking instances, now named theorems, probed as ordinary carriers.  Neither can
-- reach a consumer that does not name it; each still reports `sorryAx`, which is the honest
-- state of the mathematics behind them.
#print axioms AlgebraicGeometry.Scheme.picSchemeOfHasRationalPoint
#print axioms AlgebraicGeometry.pullback_preservesFiniteLimits

-- §3 Picard cone keystones
#print axioms AlgebraicGeometry.Scheme.PicScheme
#print axioms AlgebraicGeometry.Scheme.PicScheme.representable
#print axioms AlgebraicGeometry.Scheme.PicScheme.picSharp
#print axioms AlgebraicGeometry.Scheme.Pic0Scheme

-- §4 Pic⁰-is-an-abelian-variety cone
#print axioms AlgebraicGeometry.Scheme.Pic0.tangentSpaceIso
#print axioms AlgebraicGeometry.Scheme.Pic0.smooth
#print axioms AlgebraicGeometry.Scheme.Pic0.proper
#print axioms AlgebraicGeometry.Scheme.Pic0.geometricallyIrreducible
#print axioms AlgebraicGeometry.Scheme.Pic0.grpObj
#print axioms AlgebraicGeometry.Scheme.Pic0.isAbelianVariety
#print axioms AlgebraicGeometry.Scheme.Pic0Scheme.isAbelianVariety
#print axioms AlgebraicGeometry.Scheme.Pic0.finrank_cotangentSpace_eq_finrank_hModuleOne
#print axioms AlgebraicGeometry.Scheme.Pic0.pointedDualNumberPoints_equiv_relPicKernel
#print axioms AlgebraicGeometry.Scheme.Pic0.isSeparated
#print axioms AlgebraicGeometry.Scheme.Pic0.locallyOfFiniteType

-- §5 Cohomology cone: the Čech engine and the flat-base-change frontier
#print axioms AlgebraicGeometry.cech_computes_higherDirectImage
#print axioms AlgebraicGeometry.pullback_preservesFiniteColimits
#print axioms AlgebraicGeometry.pullback_preservesHomology
#print axioms AlgebraicGeometry.Scheme.subsingleton_hModule'_one_toModuleKSheaf_of_isAffineOpen

-- §6 Riemann–Roch / genus cone
#print axioms AlgebraicGeometry.Adelic.instModuleFiniteHModuleOne
#print axioms AlgebraicGeometry.Scheme.AffineCoverMVSquare.hModuleOneEquivH1Cok_curve
#print axioms AlgebraicGeometry.Scheme.AffineCoverMVSquare.chi_unit_eq_one_sub_genus
#print axioms AlgebraicGeometry.Scheme.AffineCoverMVSquare.h1_unit_eq_genus

/-! §2b The SEVENTH trap, and the one that is hardest to defend against: a hypothesis the
project can REFUTE.

Trap (c) below is a named hypothesis that is false as stated — someone has to notice that it
is false. This is the sharper version: a hypothesis whose negation is *derivable from
declarations already in the tree*, so the project simultaneously proves `H → C` and, at every
instance anyone would use, `¬H`. The theorem is true, axiom-clean, non-vacuous by every probe
in this file, and empty.

Measured instance (2026-07-28, `RiemannRoch/Adelic/LedgerClosure.lean`): `chi_eq_of_bump`
takes `hbump : ∀ P E, χ(1·P + E) = χ(E) + residueDeg P`. Iterating it down the anti-effective
cone forces `χ(-m·P) = χ(0) - m·[κ(P):k]`, and since `χ = ℓ - h¹` with `ℓ ≥ 0`, `h¹` must grow
linearly there. So `hbump` is FALSE on every cover whose `h¹` is bounded — and outright false
at the degenerate cover `U₀ = U₁ = ⊤`, where the Čech `H¹` vanishes identically, as soon as a
single prime divisor exists. That refutation needs no exactness data at all.

THE OFF-CHART REFUTATION, and the two-step history of this paragraph is the most instructive
part of the entry, because the trap caught the audit and then caught the retraction.

Round 1 (the audit, `I-0449`): a second refutation "at each prime outside the overlap", on the
grounds that `A(1·P + E) = A(E)` there makes the local step a subsingleton, so
`ChiLedger.chi_add` gives a χ-jump of `0` against `hbump`'s `residueDeg P ≥ 1`.

Round 2 (my retraction, and it was WRONG): I withdrew that on the grounds that the derivation
runs through `chi_add`, so it measures `chi_add`'s exactness hypotheses rather than `hbump` —
citing `Adelic.bump_iff_chartStep_of_notMem_left`, which makes `hbump` at such a `P` equivalent
to the surviving one-chart step being `[κ(P):k]`, and concluding `hbump` is merely weaker there
rather than false.

Round 3 (`I-0467`, machine-checked, and it reinstates round 1): the one-chart step cannot be
`[κ(P):k]` repeatedly, because the overlap term `A` is FROZEN along the tower `n·P`
(`sectionSub_add_pointDivisor_of_notMem`, iterated) and the coboundary term is trapped beneath
it (`S₁(D) ≤ A(D)`). So in `χ = dim S₀ + dim S₁ − dim A` all three terms are bounded along the
tower while `hbump` forces linear growth. Hence `¬hbump` off the chart, from this file's own
theorems and its own finiteness binders, with **no** `chi_add` and no exactness hypothesis
anywhere. The equivalence I cited is true and does not say what I used it for: its right-hand
side is itself false for large `n`. `Adelic.not_bump_of_notMem_left` and
`Adelic.ledger_refuted_of_notMem_left` are the landed forms (§6f), and `P.point ∉ U₀` is far
weaker than `P.point ∉ U₀ ⊓ U₁`, so the refutation reaches MORE primes than the audit claimed.

Honest status of `hbump`: consistent (`bump_of_isEmpty_primeDivisor`); refutable at
`U₀ = U₁ = ⊤` given one prime divisor; refutable on every bounded-`h¹` cover; refutable
whenever any prime divisor lies off one chart; satisfiable only where `h¹` is unbounded on the
anti-effective cone. The closed ledger itself is refuted on the same covers. None of that
contradicts the vanishing lane, whose results are high-degree only — which is why nobody
noticed.

The generalisable lesson, and note that it cuts BOTH ways, which is what round 2 missed. When a
hypothesis `H` and a lemma `L` are inconsistent together, that does not tell you which is at
fault: establishing that `H` is refutable requires deriving `¬H` from things THEMSELVES
satisfiable. That is why round 1's argument was not yet conclusive. But it equally does not
license concluding `H` is *fine* — round 2 inferred "not refutable" from "not refutable by this
route", which is the same error with the sign flipped, and an ungated derivation existed the
whole time. The correct response to "your refutation measured the wrong thing" is to look for an
ungated derivation, not to withdraw the conclusion. Recorded as I-0449/I-0454/I-0467, with the
durable lessons at I-0451 and I-0468.

What defeats each check, in order: `#print axioms` sees a clean line; a consistency witness
exists (`bump_of_isEmpty_primeDivisor`, on a scheme with no prime divisors); an elaboration
probe synthesises every binder; and non-vacuity in the trap-(c) sense holds, because the
hypothesis is not contradictory — it is merely refutable where it is wanted. The only check
that finds it is reading the PRODUCER's side conditions and asking whether the family the
hypothesis quantifies over contains members where the tree proves the negation.

So the discipline this adds to the other six: for a hypothesis quantified over a family, do
not stop at "is it satisfiable". Ask where the project can derive its negation. Recorded as
I-0449/I-0454 with the machine-checked steps, and as the durable lesson I-0451.

ROUND 4, and it closes this entry by invalidating rounds 1-3 AT A CURVE (task ajc-rr,
2026-07-28, `RiemannRoch/Adelic/ChartFinitenessRefuted.lean`, sorry-free and axiom-clean).
Every refutation above runs on the binder `[∀ D, Module.Finite k (sectionSub k U₀ D)]` at a
NON-TOTAL open. That binder is not merely restrictive: it is UNSATISFIABLE on a curve. One
instance at `D = 0` alone forces `K(X)/k` to be a finite extension
(`module_finite_functionField_of_chart_finite`), and the binder is *equivalent* to that
(`chart_finiteness_iff_module_finite_functionField`) — a statement with no cover, no chart and
no divisor in it. Mechanism: `Γ(U,𝒪(0))` is a ring containing `Γ(X,U)`; a `k`-finite domain is
a field; a field between `Γ(X,U)` and its own fraction field is all of `K(X)`. And `K(X)/k` is
never finite once a single prime divisor exists, because the DVR stalk `𝒪_P` would then be a
`k`-finite domain hence a field, while `exists_order_eq` gives an element of order `1` whose
inverse has order `-1` (`not_module_finite_functionField_of_primeDivisor`).

So `hbump` and `hledger` are OPEN at a curve, not refuted; rounds 1-3 argued about which route
refutes them when in fact none reaches a curve. Note the scope: `IsAffineOpen U` is
load-bearing (used once, for `chartRing_isFractionRing`), and on a proper curve `⊤` is not
affine — so the `Module.Finite k (sectionSub k ⊤ D)` binders used throughout
`GlobalGeneration.lean`, `LedgerClosure.lean` and `SectionBounds.lean` are UNAFFECTED. That
asymmetry is the whole content: finiteness at `⊤` is finiteness of `L(D)`, which Riemann-Roch
asserts; finiteness at an affine `U` is a disguised finiteness of `K(X)/k`, which is false.

THE NINTH TRAP, which is what this really is, and no earlier entry covers it:

  (i) a REFUTATION whose own hypotheses are unsatisfiable. It reports clean axioms exactly
      like a useful theorem, every binder synthesises in the abstract, `#print axioms` sees
      nothing, and it is *true*. It simply says nothing about the object you care about. This
      is trap (c) with the sign flipped, and it is more dangerous than trap (c) because a
      negative result is normally treated as closing a route: rounds 1-3 above, plus five
      docstrings and a roadmap comment, told the next session to go find a better cover. There
      is no better cover. The check is the same one trap (c) demands, applied to the
      refutation instead of the theorem: instantiate its hypotheses at the object you actually
      have.

§2c The EIGHTH, found in the same audit and cheaper to check than any of the others: a
hypothesis EQUIVALENT to the conclusion it is supposed to buy.

`chi_eq_of_bump` proves `hbump → closed χ-ledger`. The converse is three lines —
`rw [hledger (pointDivisor P + E), hledger E, degK_add, degK_pointDivisor]; ring` — because
`degK` is an `AddMonoidHom` and the bump adds exactly one point. A theorem `A → B` whose
converse is trivial transports no information: it is a restatement, and "is `A` satisfiable"
is literally the question "is `B` satisfiable". The theorem is true, axiom-clean,
instantiable, non-vacuous, and not a reduction.

This is the re-indexing failure mode one level out, and it is the one to check FIRST, because
it costs a single `rw` attempt: before believing that `H → C` reduces `C` to `H`, try to prove
`C → H`. If that succeeds, no amount of axiom-probing will tell you the result is empty.
Lesson recorded as I-0456.

§6b Cluster-P extensions (task ajc-rr).  Independent re-verification, in the
rooted environment, of the axiom claims made in I-0383 and I-0403.

CAUTION, and this is the section to read before quoting any line below as a
completeness claim: several of these are axiom-clean and still NOT unconditional
mathematics, because they take the closed χ-ledger and/or a peel-surjectivity
datum as *named hypotheses* — invisible to `#print axioms`.  What each one is
open in, as of 2026-07-27:

| declaration                          | open named hypotheses                    |
|--------------------------------------|------------------------------------------|
| `chi_eq_of_linearEquivalence`        | none (unconditional)                     |
| `degK`                               | none (a definition)                      |
| `degK_principal_eq_zero`             | **closed χ-ledger** — see correction below |
| `ell_eq_zero_of_degK_neg`            | closed χ-ledger                          |
| `chi_divisorOfList_eq_degK`          | closed χ-ledger                          |
| `coneVanishing_iff_base_and_peel`    | none (unconditional; an equivalence)     |
| `exists_bound_subsingleton_h1Mod`    | base vanishing at one divisor + peel     |
| `exists_bound_subsingleton_h1Mod_of_pointPeel` | base vanishing + point-peel    |
| `exists_bound_h1dim_eq_zero`         | the above, plus the closed χ-ledger      |

CORRECTION, 2026-07-28 (task `ajc-rr`, run 0074).  The `degK_principal_eq_zero` row read
"none (unconditional)".  That is **wrong**, and it was wrong in exactly the way this section
exists to catch.  `SectionBounds.degK_principal_eq_zero` (`:441`) takes

```
(hledger : ∀ D : X.WeilDivisor, chi k U₀ U₁ D = chi k U₀ U₁ 0 + degK k D)
```

— the closed χ-ledger — as an explicit hypothesis, and `lean_minimal_hypotheses` reports that
binder **load-bearing** (dropping it leaves the goal unproved).  So the row belonged with
`ell_eq_zero_of_degK_neg` and `chi_divisorOfList_eq_degK` all along.  The clean `#print axioms`
line below is real and says nothing about the ledger being available: this is failure mode (b)
of §8, a named unproved hypothesis in the statement, which is the very mode the paragraph above
the table warns about.  A reader who took the table at face value would have concluded that AJC
already had principal-degree-zero unconditionally.

WHAT IS ACTUALLY UNCONDITIONAL, as of this run and on a *different* carrier: the ported
χ-ledger's `Ledger/PrincipalTransport.degree_principal_eq_zero_curve` — no ledger hypothesis,
both `Module.Finite` cohomology binders discharged by synthesis, but carrying `[IsAlgClosed k]`
and stated for `WeilDivisor.degree` rather than the adelic `degK`.  The two are not
interchangeable: `degK` is residue-weighted and lives on a chosen 2-affine cover.

The honest one-line summary of the vanishing lane, in ajc-rr's own sharpened
words: single-field bounded `H¹` vanishing is assembled and kernel-checked, and
its hypothesis pair (base vanishing at one divisor plus peel-surjectivity) is
*equivalent* to vanishing on the whole cone `{D' ≥ D₀}` — that equivalence is
proved (`coneVanishing_iff_base_and_peel`).  So the content is "pointwise cone
vanishing plus closed ledger ⟹ numerical-degree vanishing", a real reduction,
since a divisor of large weighted degree need not dominate `D₀`.  It is NOT "one
vanishing implies all vanishing".

**TWO CLAUSES OF THIS PARAGRAPH WERE STALE AND ARE RETRACTED (ajc-rr, run 0074
r3).**  It used to end: "Extension-uniformity and global generation are proved
nowhere in AJC, and extension-uniformity is not currently even statable."  Both
halves were false at HEAD, and a janitor sweep caught them (`I-0649`).

* **Global generation IS proved in AJC, in two places.**  On the adelic carrier:
  `Adelic/GlobalGeneration.generatedAt_of_vanishing` (:374),
  `exists_bound_generatedAt` (:424), `exists_bound_forall_generatedAt` (:452) —
  which **§6d of this very file already tabulates, twenty lines below**, so the
  sentence contradicted its own document.  On the ledger carrier, above a degree
  bound: `Ledger/DegreeVanishing.surjective_eval_of_deg_ge` and
  `generated_of_deg_ge`, off the third slot of the dévissage slice, with no
  finiteness.
* **Extension-uniformity IS statable.**  `Adelic/ResidueField.lean:689` defines
  `UniformlyBoundedVanishing`, and `CurveBaseChange.lean` does transport the cover
  (`AffineCoverMVSquare.baseChangeField`).  `Adelic/BoundedVanishing.lean:107-115`
  and `GlobalGeneration.lean:80-84` each already carried an explicit "that was
  wrong" for this exact sentence; this probe kept the retracted version.

**What remains genuinely open is uniformity itself**, not its statability: flat
base change for the section spaces, and a `WeilDivisor` pullback along
`C_κ ⟶ C` (hard — points split).  That is the honest residue, and it is the only
cluster-P item with nothing landed against it.

One further caveat that no axiom line shows.  "`Subsingleton` rather than
`h¹ = 0`, so no finiteness instance is needed" holds only for the
vanishing-criterion and peel machinery.  Any theorem taking the closed χ-ledger
carries finiteness content with no `Module.Finite` binder visible, because
`Module.finrank` of an infinite-dimensional space is `0`. -/
#print axioms AlgebraicGeometry.Adelic.chi_eq_of_linearEquivalence
#print axioms AlgebraicGeometry.Adelic.degK
#print axioms AlgebraicGeometry.Adelic.degK_principal_eq_zero
#print axioms AlgebraicGeometry.Adelic.ell_eq_zero_of_degK_neg
#print axioms AlgebraicGeometry.Adelic.exists_bound_h1dim_eq_zero
#print axioms AlgebraicGeometry.Adelic.exists_bound_subsingleton_h1Mod
#print axioms AlgebraicGeometry.Adelic.coneVanishing_iff_base_and_peel
#print axioms AlgebraicGeometry.Adelic.exists_bound_subsingleton_h1Mod_of_pointPeel
#print axioms AlgebraicGeometry.Adelic.chi_divisorOfList_eq_degK

/-! §6d The global-generation and ledger-closure lane (task ajc-rr, requested in I-0410).

Same caution as §6b, and ajc-rr asked for it to be kept: everything in the generation
lane takes the closed χ-ledger `hledger` as an explicit hypothesis, so a clean axiom line
on `exists_bound_generatedAt` says nothing about the ledger being available.  Measured
open named hypotheses, read off the signatures rather than asserted:

| declaration                                    | open named hypotheses                   |
|------------------------------------------------|-----------------------------------------|
| `evalMap_injective`                            | none (unconditional)                    |
| `mem_orderGe_one_iff_mem_maximalIdeal`         | none (unconditional)                    |
| `residueDeg_eq_one_iff_hasRationalResidues`    | none (unconditional; an equivalence)    |
| `hasRationalResidues_of_isAlgClosed`           | no *named* hypothesis, but three
                                                   un-instantiable instance binders —
                                                   see §6e, this is trap (d)              |
| `residueDeg_eq_one_of_hasRationalResidues`     | rational residues at every point        |
| `degK_eq_degree_of_hasRationalResidues`        | rational residues at every point        |
| `ell_sub_ell_sub_pointDivisor_eq`              | ledger + vanishing at `D` and `D − P`   |
| `evalMap_surjective`                           | ledger + the same two vanishings        |
| `generatedAt_of_evalMap_surjective`            | surjectivity of `evalMap` itself        |
| `generatedAt_of_vanishing`                     | ledger + the same two vanishings        |
| `exists_bound_generatedAt`                     | ledger + base vanishing + peel          |
| `exists_bound_forall_generatedAt`              | the above, plus a uniform residue bound |
| `exists_bound_forall_generatedAt_of_hasRationalResidues` | ledger + base vanishing + peel |
| `degree_principal_eq_zero_of_hasRationalResidues` | ledger + rational residues          |
| `chi_eq_of_bump_of_nonneg`                     | the one-point bump                      |
| `chi_eq_iff_step_of_bump`                      | the one-point bump (an equivalence)     |

§6e The fourth trap, and why the apparent exception in the table above is not one.

`hasRationalResidues_of_isAlgClosed` looks like the one unconditional statement of the
lane: no ledger, no vanishing, no bump, and it measures clean.  It is not, and the reason
is a way of overstating a result that the other three traps do not cover.

Its obligations are in *instance* position, not in named-hypothesis position:
`[Algebra k (X.presheaf.stalk P.point)]`,
`[IsScalarTower k (X.presheaf.stalk P.point) X.functionField]` and
`[Module.Finite k (IsLocalRing.ResidueField (X.presheaf.stalk P.point))]`.  Nothing in
this project constructs any of the last two for the ambient object the Adelic lane runs
on — a bare `Scheme X` — and the first exists only for `Over (Spec k)` objects.  The
`Module.Finite` binder is on the stalk residue field, which the lane has no identification
with its own `localStepTgt` keystone, so it is a new obligation rather than a reused one.

So the fourth trap, in the same form as the other three:

  (d) a theorem whose INSTANCE BINDERS are never instantiable for the object actually
      used reports `[propext, Classical.choice, Quot.sound]` and always will, because the
      binders are hypotheses.  The axiom output cannot see this at all; the check is
      whether each binder has a constructing instance for the ambient object.

The statement is still a real reduction — `[κ(P) : k] = 1` is traded for standard stalk
commutative algebra — but it is a relocation of the obligation, not a discharge, and the
two `_of_hasRationalResidues` results are therefore not unconditional over an
algebraically closed field either.

RESOLVED, and the resolution is what makes trap (d) worth stating rather than merely
embarrassing.  `RiemannRoch/Adelic/ResidueField.lean` supplies the `_curve` forms below,
which take no stalk binders at all: only the curve's own geometric instances, with the
stalk algebra and tower *built* (`algebraMap_stalk_functionField`,
`isScalarTower_stalk_functionField`) and the residue-field finiteness routed around
entirely through mathlib's `residueFieldIsoBase`, which gets integrality of `κ(x)` over `k`
from `LocallyOfFiniteType` by the Jacobson-space criterion.  So the same mathematics that
was a relocation in the `_of_hasRationalResidues` form is a discharge in the `_curve` form,
and the difference is invisible to `#print axioms`: both report clean.  That is trap (d)
stated positively — the axiom line was never the thing that distinguished them.

`degK_eq_degree_of_isAlgClosed_curve` is the one to look at: geometric degree equals the
residue-weighted degree on an AJC curve over an algebraically closed field, with no open
input at all.  `degree_principal_eq_zero_of_isAlgClosed_curve` then rests on the closed
ledger alone, where its `_of_hasRationalResidues` predecessor needed the ledger *and* the
approximation statement.

ONE QUALIFICATION, established by elaborating a consumer rather than by reading signatures,
because that is the discipline trap (d) demands.  These take an `Adelic.IsConstantField k
C.left` binder whose producer (`Scheme.instIsConstantField`, `Adelic/GateInstances.lean`) is
a `scoped` instance.  A consumer must therefore `open scoped AlgebraicGeometry.Scheme`; a
`degK_eq_degree_of_isAlgClosed_curve` applied without it fails to synthesize, and the
failure looks exactly like trap (d) even though the instance exists.  Instantiability is
`open`-sensitive, which is a fifth thing no axiom line shows and the reason to test the
consumer instead of the signature. -/
#print axioms AlgebraicGeometry.Adelic.evalMap_injective
#print axioms AlgebraicGeometry.Adelic.mem_orderGe_one_iff_mem_maximalIdeal
#print axioms AlgebraicGeometry.Adelic.residueDeg_eq_one_iff_hasRationalResidues
#print axioms AlgebraicGeometry.Adelic.hasRationalResidues_of_isAlgClosed
#print axioms AlgebraicGeometry.Adelic.residueDeg_eq_one_of_hasRationalResidues
#print axioms AlgebraicGeometry.Adelic.degK_eq_degree_of_hasRationalResidues
#print axioms AlgebraicGeometry.Adelic.ell_sub_ell_sub_pointDivisor_eq
#print axioms AlgebraicGeometry.Adelic.evalMap_surjective
#print axioms AlgebraicGeometry.Adelic.generatedAt_of_evalMap_surjective
#print axioms AlgebraicGeometry.Adelic.generatedAt_of_vanishing
#print axioms AlgebraicGeometry.Adelic.exists_bound_generatedAt
#print axioms AlgebraicGeometry.Adelic.exists_bound_forall_generatedAt
#print axioms AlgebraicGeometry.Adelic.exists_bound_forall_generatedAt_of_hasRationalResidues
#print axioms AlgebraicGeometry.Adelic.degree_principal_eq_zero_of_hasRationalResidues
#print axioms AlgebraicGeometry.Adelic.chi_eq_of_bump_of_nonneg
#print axioms AlgebraicGeometry.Adelic.chi_eq_iff_step_of_bump

-- The `_curve` forms of §6e: same clean axiom lines as their `_of_hasRationalResidues`
-- predecessors, and unlike them, instantiable at the curve's own hypotheses.
#print axioms AlgebraicGeometry.Adelic.algebraMap_stalk_functionField
#print axioms AlgebraicGeometry.Adelic.isScalarTower_stalk_functionField
#print axioms AlgebraicGeometry.Adelic.hasRationalResidues_of_isAlgClosed_curve
#print axioms AlgebraicGeometry.Adelic.residueDeg_eq_one_of_isAlgClosed_curve
#print axioms AlgebraicGeometry.Adelic.degK_eq_degree_of_isAlgClosed_curve
#print axioms AlgebraicGeometry.Adelic.degree_principal_eq_zero_of_isAlgClosed_curve
#print axioms AlgebraicGeometry.Adelic.exists_bound_forall_generatedAt_of_isAlgClosed_curve

/-! §6f The unconditional-χ lane, measured THROUGH THE ROOT PATH (requested by ajc-rr in
I-0463).

ajc-rr measured twelve declarations in their own session and reported zero `sorryAx`, but
flagged the measurement themselves: they probed through a scratch file that imported
`AlgebraicJacobian` *plus* the two new modules directly, because at that moment
`ChiUnconditional` and `UniformChartVanishing` were committed and **not** in the root
roll-up. The two imports have since landed (`AlgebraicJacobian.lean`), so the lines below
are measured on the root path — the measurement that may be quoted. All clean, agreeing with
theirs.

Ten of the twelve, not twelve: `degK_principal_eq_zero_of_chartCounts` and
`chartCountsDegree_iff_ledger` no longer exist. ajc-rr deleted them (audit `I-0467`) on their
own initiative, for two reasons worth recording because both are the reasons a probe line
would have been misleading. The predicate was `Iff.rfl` to the closed ledger and
`SectionBounds.degK_principal_eq_zero` already took that hypothesis verbatim, so the theorem
was the old one with a renamed binder; and it was *vacuous on the covers the module is about*,
since the ledger is outright FALSE whenever a prime divisor lies off one chart. Two clean
axiom lines would have sat on a duplicate of a vacuous statement — which is trap (c) and trap
(h) at once, and no axiom output distinguishes either. `ledger_refuted_of_notMem_left` below
is what replaced them, and it is a constraint on the route rather than a theorem about it.

This is also why a probe file must be re-elaborated and not merely re-read after a sibling
team lands: naming a deleted declaration is a hard error, so the file itself fails rather than
silently reporting a stale set. That is the desired failure mode, and it fired here.

Why the distinction is not pedantry. An unrooted module is invisible to `import
AlgebraicJacobian`, so its axioms cannot be probed here at all; and a scratch import can
differ from the root path in instance *scope*, which §6e's final qualification shows is
exactly the kind of difference an axiom line does not display. The honest procedure when a
sibling team lands a module is: root it, rebuild, then re-measure — not carry the scratch
number forward.

What the clean lines do and do not say. Same caution as §6b and §6d: the χ identity
`chi_eq_charts_sub_overlap` is genuinely unconditional (inclusion–exclusion for a two-set
cover, no exact sequence and no exactness binders), whereas the two vanishing statements carry
chart-count hypotheses proved at no curve. `uniformlyBoundedVanishing_of_uniformChartCount`
takes `UniformChartCount`, which is strictly stronger than the single-field count. And the two
refutations are the sharpest lines here precisely because they are *negative*: they say the
bump hypothesis and the closed ledger are FALSE on any cover having a prime divisor off one
chart, so a clean axiom line on anything downstream of either is clean about a vacuous
premise (trap (h)). -/
#print axioms AlgebraicGeometry.Adelic.chi_eq_charts_sub_overlap
#print axioms AlgebraicGeometry.Adelic.chi_sub_chi_eq_charts_sub_overlap
#print axioms AlgebraicGeometry.Adelic.sectionSub_top_eq_inf
#print axioms AlgebraicGeometry.Adelic.sectionSub_add_pointDivisor_of_notMem
#print axioms AlgebraicGeometry.Adelic.chi_add_pointDivisor_of_notMem_left
#print axioms AlgebraicGeometry.Adelic.bump_iff_chartStep_of_notMem_left
#print axioms AlgebraicGeometry.Adelic.charts_sub_overlap_le_ell
#print axioms AlgebraicGeometry.Adelic.h1dim_eq_zero_iff_charts
#print axioms AlgebraicGeometry.Adelic.exists_bound_h1dim_eq_zero_of_charts
#print axioms AlgebraicGeometry.Adelic.uniformlyBoundedVanishing_of_uniformChartCount

-- The two refutations that replaced the deleted `ChartCountsDegree` pair.  Both are negative
-- results on a cover with a prime divisor off one chart, under chart-finiteness binders.
-- THEY DO NOT REACH A CURVE — see §2b round 4 and §6g.  Measured here because a clean line on a
-- refutation is exactly as uninformative as a clean line on a vacuous theorem (trap (i)).
#print axioms AlgebraicGeometry.Adelic.not_bump_of_notMem_left
#print axioms AlgebraicGeometry.Adelic.ledger_refuted_of_notMem_left

/-! §6g The chart-finiteness collapse (task ajc-rr, 2026-07-28) — the measurement that says the
two lines above are about nothing, and the one place in this file where the interesting content
is which binder is UNSATISFIABLE rather than which axiom is present.

All of these are `[propext, Classical.choice, Quot.sound]`, and for once that is not the point:
the point is what they say about the binders of §6f.

  `module_finite_functionField_of_chart_finite`  — `Module.Finite k (sectionSub k U 0)` at ONE
      nonempty affine chart forces `Module.Finite k K(X)`.  Not the whole divisor family: one
      divisor, `D = 0`.
  `chart_finiteness_iff_module_finite_functionField` — and conversely, so the binder IS that
      statement.  No cover, no chart, no divisor appears on the right-hand side.
  `not_module_finite_functionField_of_primeDivisor` — `K(X)/k` is not finite as soon as one
      prime divisor exists.  A DVR is not a field, and finiteness over `k` would make `𝒪_P` one.
  `not_chart_finite_of_primeDivisor` — hence the binder holds at NO chart of such a curve.

Consequences for this file's own claims, stated because several were wrong:
 * §6f called the two refutations "unconditional negative results". They are unconditional in
   *exactness data* only. Corrected above.
 * "a clean axiom line on anything downstream of either is clean about a vacuous premise (trap
   (h))" — that inference is now void for curves, since the refutations have no instances there.
   The `hledger`-conditional results of `SectionBounds`/`BoundedVanishing`/`GlobalGeneration` are
   NOT shown vacuous.
 * The `⊤` binders those files use are NOT REACHED BY THIS ARGUMENT at a proper curve — which is
   weaker than "unaffected", and the difference is trap (i) again. Nothing proves those binders
   HOLD at a proper curve; that is finiteness of `L(D)`, i.e. Riemann-Roch's own content, open in
   AJC. What is proved is only that this collapse does not apply there. A fresh-context review
   caught an earlier version of this bullet asserting survival.
   `IsAffineOpen U` is load-bearing in the collapse, and `⊤` is not affine on a proper curve — but
   it IS affine when `X` is, and then the `⊤` binder dies too
   (`not_chart_finite_top_of_isAffine`). This matters because `GlobalGeneration.lean`,
   `LedgerClosure.lean` and `SectionBounds.lean` are stated over a bare `Scheme X` with NO
   `IsProper` binder, so at the affine members of the family they quantify over their hypotheses
   are unsatisfiable and their conclusions vacuous. An earlier version of this section said
   flatly that the `⊤` binders are unaffected; that was the same overstatement as the one this
   section exists to record, made one level down.

What no axiom line shows here, and it is the fifth such thing this file has had to record: that
a hypothesis is unsatisfiable at the object of interest. Only instantiation shows it.

MEASUREMENT CAVEAT, recorded rather than glossed, because §6f exists precisely to punish this.
`ChartFinitenessRefuted` and `CurveCoheight` are NOT yet in the root roll-up
(`AlgebraicJacobian.lean`), which task `ajc-rr` does not own. So the eight lines above are
UNREACHABLE from `import AlgebraicJacobian` alone, and were measured by adding the two modules
as explicit imports alongside it — the same scratch-path measurement §6f warns can differ from
the root path in instance scope. All eight came out `[propext, Classical.choice, Quot.sound]`
with zero elaboration errors across the whole file (156 probes, 35 `sorryAx`). Whoever owns the
roll-up: root both modules, rebuild, and re-measure here before quoting these as root-path
numbers. Requested on the AJC thread I-0493. -/
#print axioms AlgebraicGeometry.Adelic.module_finite_functionField_of_chart_finite
#print axioms AlgebraicGeometry.Adelic.chart_finiteness_iff_module_finite_functionField
#print axioms AlgebraicGeometry.Adelic.not_module_finite_functionField_of_primeDivisor
#print axioms AlgebraicGeometry.Adelic.not_chart_finite_of_primeDivisor
#print axioms AlgebraicGeometry.Adelic.not_chart_finite_top_of_isAffine
#print axioms AlgebraicGeometry.Adelic.sectionSub_mul_mem_zero
#print axioms AlgebraicGeometry.Adelic.algebraMap_chart_mem_sectionSub_zero

-- The index-set half of the χ-ledger port (task ajc-rr): `X.PrimeDivisor ≃ {x // x ≠ η}` given
-- the coheight bound, stated at `WeilDivisor` import level so it inverts no imports.
#print axioms AlgebraicGeometry.Scheme.PrimeDivisor.ofNonGeneric
#print axioms AlgebraicGeometry.Scheme.PrimeDivisor.equivNonGeneric

-- §6c The rigid-pushforward gate (task ajc-gate).  THE GATE IS NOW INSTANTIATED AND THE
-- INSTANCE IS AXIOM-CLEAN — `instHasRigidPushforwardOfCurve`
-- (`Picard/RigidPushforwardGammaBaseChange.lean`), for every AJC curve, with no hypothesis
-- beyond the curve's own.  This is the one case in this file where a global instance is
-- *good* news, and it is exactly the case where the measurement matters most: the whole
-- point of §8 below is that a `sorry`-bodied instance poisons every synthesis site, so an
-- instance that measures clean has to be checked, not assumed.  The three extraction
-- theorems of `Picard/RigidPushforward.lean` now synthesize their gate rather than
-- assuming it, and §6c-headlines below measures them at that synthesis site.
--
-- `hasRigidPushforward_of_leaves` is a four-leaf FACTORIZATION, of historical interest
-- only now that the gate is a theorem; it was never the frontier once two of its leaves
-- were proved.
--
-- THIRD TRAP, worse than the first two, demonstrated in this very cone (I-0395): a
-- theorem whose named hypothesis is FALSE is vacuously true, and reports clean axioms
-- like any other.  `hrank`, one of the gate's extracted leaves, quantifies over every
-- finitely presented module with no flatness or fibrewise-vanishing hypothesis, and is
-- refuted by `𝒪_{ℙ¹_A}/x` (rank 0 against fibre `h⁰ = 1`).  So the assembly theorems
-- above it are clean, true, and empty.  `#print axioms` sees none of this.  It answers
-- exactly one question — "is a `sorry` reachable from this proof term" — and four
-- separate things it cannot see have now been measured here:
--   (a) a sorry-bodied INSTANCE reached only at a synthesis site (§8);
--   (b) a named hypothesis in the STATEMENT that is unproved (§6b);
--   (c) a named hypothesis in the statement that is FALSE (§6c);
--   (d) an INSTANCE BINDER that nothing can instantiate for the ambient object (§6e).
-- A fifth, outside this file: an unrooted module cannot be probed at all, because
-- `import AlgebraicJacobian` does not reach it (companion measurement 2 in the header).
#print axioms AlgebraicGeometry.Adelic.hasRigidPushforward_of_leaves

-- The gate's state after `Picard/RigidPushforwardInstance.lean`.  Two of the three
-- statements the frontier file listed are now theorems and this is where that is
-- measured rather than taken on report: `instIsIntegralP1OverLeft` (from the chart-ring
-- identification `Γ(ℙ¹_k, D₊(Xᵢ)) ≃ₐ[k] k[T]` plus the two-chart irreducibility
-- argument) and `p1RankIdentity_proved` carry no named hypotheses at all, so a clean
-- line on them is an unconditional discharge in the §6d sense.  The two consequences
-- are clean and conditional in the *other* direction: they quantify over the curve's
-- own instances only, which for an AJC curve are synthesized.
--
-- `hasRigidPushforward_of_gammaBaseChange` was the honest residue when the gate's cost was
-- one statement; `rigidPushforwardGammaBaseChange_proved` now supplies that statement, so
-- the reduction closed rather than merely narrowing.  Both are measured, along with the
-- resulting instance and the three extraction theorems AT THEIR SYNTHESIS SITE — which is
-- the only measurement that distinguishes a real discharge from trap (a).
#print axioms AlgebraicGeometry.Adelic.instIsIntegralP1OverLeft
#print axioms AlgebraicGeometry.Adelic.p1RankIdentity_proved
#print axioms AlgebraicGeometry.Adelic.p1RigidPushforwardStatement_proved
#print axioms AlgebraicGeometry.Adelic.rigidPushforwardLocallyFree_proved
#print axioms AlgebraicGeometry.Adelic.hasRigidPushforward_of_gammaBaseChange
#print axioms AlgebraicGeometry.Adelic.p1ChartSectionsAlgEquivX
#print axioms AlgebraicGeometry.Adelic.isIntegral_p1_of_isDomain_charts

-- The statement that closed the reduction, the instance it produces, and the three
-- extraction theorems restated without the gate binder — so they are measured where the
-- gate is SYNTHESIZED, not where it is assumed.  Compare §8: the same measurement on
-- `HasPicScheme` is what exposes `instHasPicScheme`, and these come out the other way.
#print axioms AlgebraicGeometry.Adelic.rigidPushforwardGammaBaseChange_proved
#print axioms AlgebraicGeometry.Adelic.instHasRigidPushforwardOfCurve
#print axioms AlgebraicGeometry.Adelic.rigidPushforward_locallyFree
#print axioms AlgebraicGeometry.Adelic.rigidPushforward_baseChange
#print axioms AlgebraicGeometry.Adelic.rigidPushforward_isLocallyTrivial

-- NON-VACUITY of that instance, which trap (c) says is a separate question from cleanliness:
-- a theorem quantified over three hypotheses is worth nothing if the tree contains nothing
-- satisfying them, and a vacuous theorem reports clean axioms like any other.  `ℙ¹` over an
-- arbitrary field satisfies all three and the gate fires at it, so the discharge above is
-- not empty.  This is the measurement that `hrank` (the false-hypothesis case) would fail.
#print axioms AlgebraicGeometry.Adelic.hasRigidPushforward_p1Over
#print axioms AlgebraicGeometry.Adelic.instSmoothOfRelativeDimensionOneP1Over
#print axioms AlgebraicGeometry.Adelic.rigidPushforward_baseChange_p1Over

-- The gate at the *challenge's own* hypothesis bundle, which is the form the headline would
-- consume: `GeometricallyIrreducible` where the gate's producer wants `GeometricallyIntegral`.
-- Measuring it here is not redundant with `instHasRigidPushforwardOfCurve` above, because the
-- two differ exactly by the `Smooth ⇒ GeometricallyIntegral` upgrade of
-- `Curve/GeometricallyReduced.lean` — the same upgrade the headline's
-- `geometricallyIntegral_of_curve` performs.  A clean line here says the gate is available at
-- the hypotheses of `Jacobian C` itself, not merely at a restatement of them.
#print axioms AlgebraicGeometry.Adelic.hasRigidPushforward_of_geometricallyIrreducible

-- §7 Albanese cone
#print axioms AlgebraicGeometry.Pic0.bundle
#print axioms AlgebraicGeometry.Pic0.jacobianScheme
#print axioms AlgebraicGeometry.Pic0.abelJacobi
#print axioms AlgebraicGeometry.Pic0.albanese_universal_property
#print axioms AlgebraicGeometry.Pic0.descentThroughBirationalSigma
#print axioms AlgebraicGeometry.Scheme.RationalMap.extend_to_av

/-! §8 The synthesis leak, measured rather than assumed.

A `#print axioms` on a declaration that *quantifies over* `[HasPicScheme C]`
reports the axioms of the declaration only, because the hypothesis is discharged
by the caller.  The leak the audit is about happens one step later: at a call
site where Lean must **synthesise** the instance, and the only producer is the
`sorry`-bodied `instHasPicScheme`.  The two `example`s below force exactly that
synthesis, so their axiom sets measure what a consumer of the theorem actually
gets.  `Flat` likewise has honest producers, so the flat-pullback probe is
stated at an identity morphism, whose flatness is proved. -/

namespace AlgebraicGeometry

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory Scheme

universe u

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom]

/-- Instantiated at a curve with a rational point, `Pic0.geometricallyIrreducible`
has to synthesise `HasPicScheme C`, whose sole producer is `sorry`-bodied. -/
theorem leakProbe_pic0_geometricallyIrreducible [HasRationalPoint C] :
    haveI := picSchemeOfHasRationalPoint C
    GeometricallyIrreducible (Pic0Scheme C).hom :=
  haveI := picSchemeOfHasRationalPoint C
  Pic0.geometricallyIrreducible C

/-- The same measurement for the separatedness carrier. -/
theorem leakProbe_pic0_isSeparated [HasRationalPoint C] :
    haveI := picSchemeOfHasRationalPoint C
    IsSeparated (Pic0Scheme C).hom :=
  haveI := picSchemeOfHasRationalPoint C
  Pic0.isSeparated C

/-- Same measurement for the local-finiteness carrier. -/
theorem leakProbe_pic0_locallyOfFiniteType [HasRationalPoint C] :
    haveI := picSchemeOfHasRationalPoint C
    LocallyOfFiniteType (Pic0Scheme C).hom :=
  haveI := picSchemeOfHasRationalPoint C
  Pic0.locallyOfFiniteType C

/-- The control that isolates the leak to synthesis and nothing else: identical
conclusion and proof term, but with `HasPicScheme` taken as a hypothesis rather
than synthesised.  This one is clean, which is exactly the point. -/
theorem leakControl_pic0_locallyOfFiniteType [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    LocallyOfFiniteType (Pic0Scheme C).hom :=
  Pic0.locallyOfFiniteType C

/-- The two *chapter keystones* at a synthesis site, which is what decides whether
a blueprint `\leanok` on them would be honest.  `PicScheme.representable` is
`Classical.choice` over the gate, and `Pic0.isAbelianVariety` bundles the
`sorry`-bodied `smooth` and `proper` conjuncts, so both pick up `sorryAx` here even
though each reports clean as stated. -/
noncomputable def leakProbe_picScheme_representable [HasRationalPoint C] :
    haveI := picSchemeOfHasRationalPoint C
    (PicScheme.picSharp C).RepresentableBy (PicScheme C) :=
  haveI := picSchemeOfHasRationalPoint C
  PicScheme.representable C

/-- Companion measurement for the abelian-variety assembly. -/
theorem leakProbe_pic0_isAbelianVariety [HasRationalPoint C] :
    haveI := picSchemeOfHasRationalPoint C
    IsProper (Pic0Scheme C).hom ∧ Smooth (Pic0Scheme C).hom ∧
      GeometricallyIrreducible (Pic0Scheme C).hom ∧
      Nonempty (GrpObj (Pic0Scheme C)) :=
  haveI := picSchemeOfHasRationalPoint C
  Pic0.isAbelianVariety C

/-- The two FGA *chapter* carriers that a blueprint `\leanok` is most likely to be read off:
the representability identification and the group-scheme structure.  Both are proved and
report clean **as stated**, and both pick up `sorryAx` here, where the gate is synthesised
rather than assumed.  This is the measurement that decides whether
`thm:fga_pic_representability`, `def:pic_scheme`, `def:inst_pic_sharp_representable` and
`thm:pic_is_group_scheme` may be read as "the Picard scheme exists in this development".
They may not: what is formalised is the extraction *from* the gate. -/
theorem leakProbe_instPicSharpRepresentable [HasRationalPoint C] :
    haveI := picSchemeOfHasRationalPoint C
    PicScheme.PicSharpRepresentable C :=
  haveI := picSchemeOfHasRationalPoint C
  inferInstance

/-- Companion measurement for the group-scheme structure.  `Nonempty` rather than the bare
class, so that this is a `theorem`: a `def` of class type draws a `@[reducible]` warning, and
a probe should not add a warning to the build it is measuring. -/
theorem leakProbe_groupSchemeStructure [HasRationalPoint C] :
    haveI := picSchemeOfHasRationalPoint C
    Nonempty (CommGrpObj (PicScheme C)) :=
  haveI := picSchemeOfHasRationalPoint C
  ⟨PicScheme.groupSchemeStructure C⟩

/-! §8b The ÉTALE gate at a synthesis site — the measurement that matters after the
rewire of 2026-07-28.

Unlike the `picSharp` gate above, `HasPicSchemeEt` DOES have an instance
(`instHasPicSchemeEt`), and it is unconditional: it fires for every smooth proper
geometrically integral curve with no hypothesis on `C(k)`.  So these probes measure the
étale interface exactly where a consumer picks it up.  Every one of them reports
`sorryAx`, from the single obligation `fgaPicardRepresentability` — which is the honest
state and is expected to persist.

What to read off them, and what NOT to.  A `sorryAx` here does NOT mean the same thing it
meant before the rewire.  Before, the headline's `sorryAx` came partly from a leaf that was
FALSE, so the surrounding theorems were vacuous.  Now every obligation is a true statement
awaiting a proof, and no declaration in the cone rests on an inconsistent hypothesis.  That
difference is invisible to `#print axioms` — it is a property of the STATEMENTS, not of the
proof terms — which is precisely why it has to be argued at the binders (below) rather than
measured here. -/

/-- The étale representability witness at a synthesis site, with NO rational point
anywhere in the binders.  This is the étale-formulation counterpart of
`leakProbe_picScheme_representable`, and the contrast is the deliverable: that one needs
`[HasRationalPoint C]`, this one does not. -/
noncomputable def etProbe_representableEt :
    (PicScheme.picEt C).RepresentableBy (PicSchemeEt C) :=
  representableEt C

/-- The group-scheme structure on `Pic_{C/k}` over an arbitrary field, at a synthesis
site.  `Nonempty` so this is a `theorem` and adds no `@[reducible]` warning. -/
theorem etProbe_groupSchemeStructureEt :
    Nonempty (CommGrpObj (PicSchemeEt C)) :=
  ⟨groupSchemeStructureEt C⟩

/-- Local finiteness and separatedness of `Pic_{C/k}` over an arbitrary field. -/
theorem etProbe_picSchemeEt_carriers :
    LocallyOfFiniteType (PicSchemeEt C).hom ∧ IsSeparated (PicSchemeEt C).hom :=
  ⟨inferInstance, inferInstance⟩

/-- The three PROVED abelian-variety properties of `Pic⁰_{C/k}` in the étale formulation,
at a synthesis site.  These still report `sorryAx` because they are extractions from the
gate, but they are the ones that need no NEW mathematics beyond it. -/
theorem etProbe_pic0Et_proved :
    Nonempty (GrpObj (Pic0SchemeEt C)) ∧
      GeometricallyIrreducible (Pic0SchemeEt C).hom ∧
      LocallyOfFiniteType (Pic0SchemeEt C).hom :=
  ⟨Pic0Et.grpObj C, Pic0Et.geometricallyIrreducible C, Pic0Et.locallyOfFiniteType C⟩

/-! ### The headline carries no rational-point binder — checked, not asserted.

`#print axioms` cannot see this, so it is checked at the binders instead.  Each `example`
below elaborates the headline declaration under EXACTLY the three challenge hypotheses
`[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]`
(the `variable` block above supplies `GeometricallyIntegral`, which is derived from them by
`geometricallyIntegral_of_curve`, not assumed).  If a `[HasRationalPoint _]` binder ever
returns to the headline cone, these stop elaborating.  That is the regression test for the
owner decision of 2026-07-28. -/

section HeadlineBinders

variable {K : Type u} [Field K] (D : Over (Spec (.of K)))
  [SmoothOfRelativeDimension 1 D.hom] [IsProper D.hom] [GeometricallyIrreducible D.hom]

noncomputable example : JacobianWitness D := picardJacobianWitness D
example : Nonempty (JacobianWitness D) := nonempty_jacobianWitness D
noncomputable example : Over (Spec (.of K)) := Jacobian D
noncomputable example : GrpObj (Jacobian D) := Jacobian.instGrpObj D
example : SmoothOfRelativeDimension (genus D) (Jacobian D).hom :=
  Jacobian.smoothOfRelativeDimension_genus D
example : IsProper (Jacobian D).hom := Jacobian.instIsProper D
example : GeometricallyIrreducible (Jacobian D).hom :=
  Jacobian.instGeometricallyIrreducible D

end HeadlineBinders

#print axioms etProbe_representableEt
#print axioms etProbe_groupSchemeStructureEt
#print axioms etProbe_picSchemeEt_carriers
#print axioms etProbe_pic0Et_proved

#print axioms leakProbe_pic0_geometricallyIrreducible
#print axioms leakProbe_pic0_isSeparated
#print axioms leakProbe_pic0_locallyOfFiniteType
#print axioms leakControl_pic0_locallyOfFiniteType
#print axioms leakProbe_picScheme_representable
#print axioms leakProbe_pic0_isAbelianVariety
#print axioms leakProbe_instPicSharpRepresentable
#print axioms leakProbe_groupSchemeStructure

/-! ### The flat-pullback probe, RESTATED (run 0068) — and why the old one is now vacuous

The old probe read
```
  theorem leakProbe_pullback_finiteLimits (S : Scheme.{u}) :
      PreservesFiniteLimits (Scheme.Modules.pullback (𝟙 S)) := inferInstance
```
and reported `sorryAx` because `pullback_preservesFiniteLimits` was an `instance` and
synthesis found it.  As of run 0068 that declaration is deliberately **not** an instance
(the `instance` attribute *was* the leak mechanism: it let synthesis inject `sorryAx` at
sites that never named the sorried declaration).  Two consequences:

1. For a general flat `g`, `PreservesFiniteLimits (Scheme.Modules.pullback g)` no longer
   synthesises **at all** — a consumer must name `pullback_preservesFiniteLimits`, so the
   dependency is visible in the proof term.  That is the point of the change.
2. The identity is the *worst possible* argument for this probe: for `𝟙 S` the pullback
   coincides with the identity functor (`Scheme.Modules.pullbackId`), so synthesis now finds
   a clean route and the probe reports clean **without measuring the obligation at all**.
   Reading that clean line as progress would be exactly the error §6b warns about.

So the probe below names the declaration instead of synthesising it, which is the only
honest way to measure a non-instance carrier, and a control records that synthesis for a
general flat `g` now fails rather than leaking. -/
theorem leakProbe_pullback_finiteLimits {S S' : Scheme.{u}} (g : S' ⟶ S) [Flat g] :
    PreservesFiniteLimits (Scheme.Modules.pullback g) :=
  pullback_preservesFiniteLimits g

/-- Companion: the residual carrier itself.  Everything the flat-base-change lane still owes
is this one statement (flat base change preserves injections), so this line and the one above
must agree — if they ever disagree, a second leak has appeared in the derivation. -/
theorem leakProbe_pullback_monos {S S' : Scheme.{u}} (g : S' ⟶ S) [Flat g] :
    (Scheme.Modules.pullback g).PreservesMonomorphisms :=
  pullback_preservesMonomorphisms g

/-- Control, and the one that should be read as the *reduction*: supplying mono-preservation
as an explicit hypothesis makes left exactness axiom-clean.  Together with the two probes
above this says the obligation is exactly one statement, with nothing hiding behind it. -/
theorem leakControl_pullback_finiteLimits_given_monos {S S' : Scheme.{u}} (g : S' ⟶ S)
    (hm : (Scheme.Modules.pullback g).PreservesMonomorphisms) :
    PreservesFiniteLimits (Scheme.Modules.pullback g) :=
  pullback_preservesFiniteLimits_of_preservesMonomorphisms g hm

/-- Control: the open-immersion case is genuinely proved, not merely reduced. -/
theorem leakControl_pullback_monos_openImmersion {X Y : Scheme.{u}} (f : X ⟶ Y)
    [IsOpenImmersion f] : (Scheme.Modules.pullback f).PreservesMonomorphisms :=
  Modules.pullback_preservesMonomorphisms_of_isOpenImmersion f

#print axioms leakProbe_pullback_finiteLimits
#print axioms leakProbe_pullback_monos
#print axioms leakControl_pullback_finiteLimits_given_monos
#print axioms leakControl_pullback_monos_openImmersion

/-! ### The QUASI-COHERENT route, and the first genuinely clean flat base change (run 0068 r1)

The four lines above measure the *arbitrary-module* obligation, which remains open.  The lines
below measure the route that BYPASSES it, and they are the ones that changed today.

The mathematics is in `Cohomology/CechHigherDirectImageUnconditional.lean`: flat left-exactness
was being demanded for all `𝒪_S`-modules (walled: mathlib gives `SheafOfModules.pullback` no
pointwise model), while every consumer instantiates it at *quasi-coherent* objects, where the tree
already had exactness on the tilde image.  Two steps closed the gap — cone-cancellation
(`preservesLimit_comp_cancel`) and the observation that `ShortComplex.mapHomologyIso` needs one
KERNEL rather than global exactness (`preservesLeftHomologyOf_of_preservesKernel`).

Read these four lines together with `leakControl_qcohRoute_oldRoute` below.  The control is the
point: it exercises the OLD route at the same statement and must keep reporting `sorryAx`.  If it
ever comes back clean, the probes above have stopped measuring anything — the §6b trap. -/

/-- PROBE: flat base change preserves kernels of quasi-coherent maps, general `g`, affine base. -/
theorem leakProbe_qcohRoute_kernel {S S' : Scheme.{u}} (g : S' ⟶ S) [Flat g]
    [IsAffine S] [IsAffine S'] {A B : S.Modules} (ψ : A ⟶ B)
    (hA : A.IsQuasicoherent) (hB : B.IsQuasicoherent) :
    Limits.PreservesLimit (Limits.parallelPair ψ 0) (Scheme.Modules.pullback g) :=
  pullback_preservesKernel_of_isQuasicoherent g ψ hA hB

/-- PROBE: the rewired homology comparison — the `sorry`-free replacement for
`pullback_mapHC_homologyIso`, which is the form the Čech proof consumes. -/
noncomputable def leakProbe_qcohRoute_homologyIso {S S' : Scheme.{u}} (g : S' ⟶ S) [Flat g]
    [IsAffine S] [IsAffine S'] (K : CochainComplex S.Modules ℕ) (i : ℕ)
    (h₂ : (K.sc i).X₂.IsQuasicoherent) (h₃ : (K.sc i).X₃.IsQuasicoherent) :
    (((Scheme.Modules.pullback g).mapHomologicalComplex (ComplexShape.up ℕ)).obj K).homology i
      ≅ (Scheme.Modules.pullback g).obj (K.homology i) :=
  pullback_mapHC_homologyIso_of_isQuasicoherent g K i h₂ h₃

/-- PROBE: the cone-cancellation brick, so a regression can be localised to it. -/
theorem leakProbe_qcohRoute_coneCancel {R R' : CommRingCat.{u}} (φ : R ⟶ R') (hφ : φ.hom.Flat)
    {M N : ModuleCat.{u} R} (f : M ⟶ N) :
    Limits.PreservesLimit (Limits.parallelPair ((tilde.functor R).map f) 0)
      (Scheme.Modules.pullback (Spec.map φ)) :=
  tildePullback_preservesKernel φ hφ f

/-- CONTROL, and the load-bearing line of this block: the OLD route at the *same* conclusion as
`leakProbe_qcohRoute_homologyIso`.  It goes through `pullback_preservesHomology`, hence through
the open `pullback_preservesMonomorphisms`, so it MUST report `sorryAx`.  A clean reading here
means the comparison has gone vacuous. -/
noncomputable def leakControl_qcohRoute_oldRoute {S S' : Scheme.{u}} (g : S' ⟶ S) [Flat g]
    (K : CochainComplex S.Modules ℕ) (i : ℕ) :
    (((Scheme.Modules.pullback g).mapHomologicalComplex (ComplexShape.up ℕ)).obj K).homology i
      ≅ (Scheme.Modules.pullback g).obj (K.homology i) :=
  pullback_mapHC_homologyIso g K i

/-- **NON-VACUITY WITNESS** for the two hypothesis-carrying probes above, per trap (c)/(d) of the
workspace catalogue: a clean axiom line proves nothing if the hypotheses cannot be satisfied.
`leakProbe_qcohRoute_kernel` carries `A.IsQuasicoherent`, `B.IsQuasicoherent` as *named*
hypotheses and `[Flat g]`, `[IsAffine S]`, `[IsAffine S']` as instance binders — all four kinds
that the catalogue records as invisible to `#print axioms`.

So here the theorem is FIRED, at objects that exist: `A = B = M^~` over `S = S' = Spec R` (the
tilde of any `R`-module is quasi-coherent, `AlgebraicGeometry.tilde` instance), with the map the
identity and `g` a `Spec` of a flat ring map.  If the hypotheses were unsatisfiable — or the
statement vacuous — this would not elaborate.

Note what this does and does not do: it witnesses *satisfiability*, not strength.  The strength
claim rests on `leakProbe_qcohRoute_*` versus `leakControl_qcohRoute_oldRoute`; `g` being an
identity-like `Spec` map here would be the wrong argument for *that* comparison (§6b). -/
theorem leakWitness_qcohRoute_nonvacuous {R R' : CommRingCat.{u}} (φ : R ⟶ R')
    (hφ : φ.hom.Flat) (M : ModuleCat.{u} R) :
    Limits.PreservesLimit (Limits.parallelPair (𝟙 (tilde M)) 0)
      (Scheme.Modules.pullback (Spec.map φ)) :=
  haveI : Flat (Spec.map φ) := Flat.SpecMap_iff.mpr hφ
  leakProbe_qcohRoute_kernel (Spec.map φ) (𝟙 (tilde M)) inferInstance inferInstance

#print axioms leakProbe_qcohRoute_kernel
#print axioms leakProbe_qcohRoute_homologyIso
#print axioms leakProbe_qcohRoute_coneCancel
#print axioms leakControl_qcohRoute_oldRoute
#print axioms leakWitness_qcohRoute_nonvacuous

/-! ### §6d. FLAT BASE CHANGE ITSELF — the declaration the task is about

Everything in §6c measures *ingredients*.  Until now **nothing in this file measured
`cech_flatBaseChange`**, which is the theorem the whole `AJC.fbc` lane exists to prove — so the
lane's axiom claims were being read off its inputs.  Fix that: the three declarations below are
the endpoint, its hypothesis-free form, and the two structural lemmas that removed the
cosimplicial naturality obligation.

Read the group as follows.

* `leakEndpoint_cech_flatBaseChange` and `leakEndpoint_cech_flatBaseChange_qcoh` are both
  expected to report `sorryAx`, and for a **single** reason: `cechComplex_baseChange_iso` carries
  the two cosimplicial naturality `sorry`s of `cech_pushforward_baseChange_natIso` and
  `twisted_cech_nerve_iso`.  That is now the *only* obstruction — the `_qcoh` form no longer
  routes through flat exactness and no longer carries the `h₂`/`h₃` quasi-coherence hypotheses.
* `leakProbe_cechTerm_isQuasicoherent` is the discharge of those hypotheses and must be **clean**.
  If it ever reports `sorryAx`, `cech_flatBaseChange_qcoh` has silently regressed to depending on
  something unproved *besides* naturality.
* `leakProbe_whiskeredBC_natIso` is the structural half: the cosimplicial natural isomorphism
  built by whiskering the outer mate.  It must be **clean**, and its cleanliness is the content
  of the claim "naturality is not an obligation" — it constructs, from a degreewise `IsIso` alone,
  the object that `NatIso.ofComponents` could only produce with a naturality proof.
* `leakProbe_isIso_app_pi` is the reduction of that degreewise `IsIso` to one per index tuple.
  Clean, and pure category theory.

So the honest summary of the lane is readable off four lines: the two endpoints dirty, the four
supporting reductions clean, and the delta between them is exactly the per-σ Beck–Chevalley
comparison. -/

theorem leakProbe_cechTerm_isQuasicoherent {S X : Scheme.{u}} (f : X ⟶ S) [IsSeparated f]
    [IsAffine S] (𝒰 : X.OpenCover) [Finite 𝒰.I₀] [∀ i, IsAffine (𝒰.X i)]
    (F : X.Modules) (hF : F.IsQuasicoherent) (p : ℕ) :
    ((CechComplex f 𝒰 F).X p).IsQuasicoherent :=
  isQuasicoherent_cechComplex_X f 𝒰 (fun σ => coverInterOpen_isAffine f 𝒰 σ) F hF p

noncomputable def leakProbe_whiskeredBC_natIso {S S' X X' : Scheme.{u}}
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) (𝒰 : X.OpenCover) (F : X.Modules)
    (hiso : ∀ n : SimplexCategory, IsIso ((cechOuterBC f g f' g' h).app
      ((CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)).obj n))) :
    ((CosimplicialObject.whiskering S.Modules S'.Modules).obj
        (Scheme.Modules.pullback g)).obj
      (((CosimplicialObject.whiskering X.Modules S.Modules).obj
          (Scheme.Modules.pushforward f)).obj
        (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)))
      ≅ ((CosimplicialObject.whiskering X'.Modules S'.Modules).obj
          (Scheme.Modules.pushforward f')).obj
        (((CosimplicialObject.whiskering X.Modules X'.Modules).obj
            (Scheme.Modules.pullback g')).obj
          (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F))) :=
  cech_pushforward_baseChange_natIso_of_isIso f g f' g' h 𝒰 F hiso

theorem leakProbe_isIso_app_pi {C D : Type*} [Category C] [Category D]
    {P Q : C ⥤ D} (α : P ⟶ Q) {J : Type*} [Finite J] (A : J → C)
    [Limits.HasProduct A] [Limits.HasProduct (fun j => P.obj (A j))]
    [Limits.HasProduct (fun j => Q.obj (A j))]
    [Limits.PreservesLimit (Discrete.functor A) P]
    [Limits.PreservesLimit (Discrete.functor A) Q]
    (h : ∀ j, IsIso (α.app (A j))) : IsIso (α.app (∏ᶜ A)) :=
  isIso_app_pi_of_isIso_app α A h

/-- **THE ENDPOINT, in its hypothesis-free form.**  Expected `sorryAx`, from the two cosimplicial
naturality leaves and nothing else.  Compare `leakProbe_cechTerm_isQuasicoherent` above, which is
the discharge of the hypotheses this form no longer carries, and is clean. -/
theorem leakEndpoint_cech_flatBaseChange_qcoh {S S' X X' : Scheme.{u}}
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) [Flat g] [QuasiCompact f] [IsSeparated f]
    [IsAffine S] [IsAffine S']
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀] [∀ i, IsAffine (𝒰.X i)]
    [Finite ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).I₀]
    [∀ i, IsAffine (((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).X i)]
    (F : X.Modules) (hF : F.IsQuasicoherent) (i : ℕ) :
    Nonempty ((Scheme.Modules.pullback g).obj (cechHigherDirectImage f 𝒰 F i) ≅
      cechHigherDirectImage f'
        ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom)
        ((Scheme.Modules.pullback g').obj F) i) :=
  cech_flatBaseChange_qcoh f g f' g' h 𝒰 F hF i

#print axioms leakProbe_cechTerm_isQuasicoherent
#print axioms leakProbe_whiskeredBC_natIso
#print axioms leakProbe_isIso_app_pi
#print axioms leakEndpoint_cech_flatBaseChange_qcoh
#print axioms cech_flatBaseChange
#print axioms cechComplex_baseChange_iso

/-! ### §6g. THE S-LEVEL COSIMPLICIAL LEAF IS CLOSED (run 0068 r3) — which of the §6d lines move

`cech_pushforward_baseChange_natIso` was one of the two `sorry`s behind every line of §6d.  It is
now fully replaced by `cech_pushforward_baseChange_natIso_flat`, because the per-σ mate obligation
turned out to be an existing theorem: `cechOuterBC f g f' g' h` is *definitionally*
`canonicalBaseChangeMap h` (`Picard/QuotScheme.lean`, `rfl`), and `canonicalBaseChangeMap_isIso`
proves that mate invertible at quasi-coherent modules with no `sorry`.

What to expect from the four lines below, and read them as a *pair of pairs*:

* `leakProbe_bcNatIso_flat` and `leakProbe_isIso_nerveObj` are the new closures: **clean**.  These
  are the whole of `AJC.fbc.cosimplicial.pushforward`.
* `leakEndpoint_cech_flatBaseChange_oneLeaf` still reports `sorryAx`, and that is CORRECT and is the
  point of the section: exactly one leaf is left, `twisted_cech_nerve_iso`'s naturality square.  Its
  value as a measurement is in comparison with `leakEndpoint_cech_flatBaseChange_qcoh` above — same
  statement, two leaves — so a future session that closes the twisted square can check its work by
  this line turning clean *without any other edit*.
* `leakProbe_twistedNerve_perSigma` is clean, which is the honest statement that the twisted leaf's
  *geometric* content is done and only the cosimplicial square remains.

Do not read a clean line here as "flat base change holds"; §6b's caution applies unchanged. -/

noncomputable def leakProbe_bcNatIso_flat {S S' X X' : Scheme.{u}}
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) [Flat g] [QuasiCompact f] [QuasiSeparated f]
    [IsSeparated f] [IsAffine S]
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀] [∀ i, IsAffine (𝒰.X i)]
    (F : X.Modules) (hF : F.IsQuasicoherent) :
    ((CosimplicialObject.whiskering S.Modules S'.Modules).obj
        (Scheme.Modules.pullback g)).obj
      (((CosimplicialObject.whiskering X.Modules S.Modules).obj
          (Scheme.Modules.pushforward f)).obj
        (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)))
      ≅ ((CosimplicialObject.whiskering X'.Modules S'.Modules).obj
          (Scheme.Modules.pushforward f')).obj
        (((CosimplicialObject.whiskering X.Modules X'.Modules).obj
            (Scheme.Modules.pullback g')).obj
          (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F))) :=
  cech_pushforward_baseChange_natIso_flat f g f' g' h 𝒰 F hF

theorem leakProbe_isIso_nerveObj {S S' X X' : Scheme.{u}}
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) [Flat g] [QuasiCompact f] [QuasiSeparated f]
    [IsSeparated f] [IsAffine S]
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀] [∀ i, IsAffine (𝒰.X i)]
    (F : X.Modules) (hF : F.IsQuasicoherent) (n : SimplexCategory) :
    IsIso ((cechOuterBC f g f' g' h).app
      ((CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)).obj n)) :=
  isIso_cechOuterBC_nerve_obj f g f' g' h 𝒰 F hF n

/-- The twisted leaf's per-σ geometric content, expected clean: what is left there is the
cosimplicial square, not the Beck–Chevalley identification. -/
noncomputable def leakProbe_twistedNerve_perSigma {S S' X X' : Scheme.{u}}
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) (𝒰 : X.OpenCover) [IsSeparated f] [IsAffine S]
    [∀ i, IsAffine (𝒰.X i)] (F : X.Modules) (hF : F.IsQuasicoherent)
    {κ : Type} [Finite κ] [Nonempty κ] (σ : κ → 𝒰.I₀) :
    (Scheme.Modules.pullback g').obj
        (pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))) ≅
      pushPullObj ((Scheme.Modules.pullback g').obj F)
        (Over.mk (Scheme.Opens.ι (coverInterOpen
          ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
            h.isoPullback.symm.hom) σ))) :=
  twisted_cech_nerve_per_sigma f g f' g' h 𝒰 F hF σ

/-- **The endpoint with ONE leaf.**  Expected `sorryAx` — from `twisted_cech_nerve_iso`'s
naturality square and nothing else.  Compare `leakEndpoint_cech_flatBaseChange_qcoh`: identical
statement, two leaves. -/
theorem leakEndpoint_cech_flatBaseChange_oneLeaf {S S' X X' : Scheme.{u}}
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) [Flat g] [QuasiCompact f] [IsSeparated f]
    [IsAffine S] [IsAffine S']
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀] [∀ i, IsAffine (𝒰.X i)]
    [Finite ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).I₀]
    [∀ i, IsAffine (((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).X i)]
    (F : X.Modules) (hF : F.IsQuasicoherent) (i : ℕ) :
    Nonempty ((Scheme.Modules.pullback g).obj (cechHigherDirectImage f 𝒰 F i) ≅
      cechHigherDirectImage f'
        ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom)
        ((Scheme.Modules.pullback g').obj F) i) :=
  cech_flatBaseChange_oneLeaf f g f' g' h 𝒰 F hF i

#print axioms leakProbe_bcNatIso_flat
#print axioms leakProbe_isIso_nerveObj
#print axioms leakProbe_twistedNerve_perSigma
#print axioms leakEndpoint_cech_flatBaseChange_oneLeaf
#print axioms cech_pushforward_baseChange_natIso_flat
#print axioms canonicalBaseChangeMap_isIso

end AlgebraicGeometry
