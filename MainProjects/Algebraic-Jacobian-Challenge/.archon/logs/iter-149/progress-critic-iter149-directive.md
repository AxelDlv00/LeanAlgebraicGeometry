# Progress Critic Directive

## Slug
iter149

## Iter
149

## Active routes / files under review

### Route 1 (M2 critical path) — chart-algebra piece (ii) in `Cotangent/ChartAlgebra.lean`

- **Started at iter**: 145 (file-scaffold landing iter; pivot to
  chart-algebra committed iter-144).
- **Iters audited**: 145, 146, 147, 148 (4 iters of data).

#### Sorry counts per iter (declarations using sorry / inline)
- iter-144: 6 / 6 (pre-pivot — bundled-route bundle; not in
  this file yet)
- iter-145: 8 / 8 (chart-algebra decomposition cost: +2 from
  the 5-block scaffold landing)
- iter-146: 6 / 6 (α + lift closed sorry-free; constants substep
  3 → partial with sub-step (e) framing; β-core + KDM stayed
  `: True := sorry` placeholders)
- iter-147: 5 / 5 (β-core closed sorry-free via delegation to
  KDM; KDM reverse inclusion closed; constants substep 3 reduced
  to surjectivity + 7-step closure chain documented in-source)
- iter-148: 5 / 5 (KDM forward inclusion: docstring refresh, no
  code change; constants substep 3: smart-proof path (b)
  framework lands sorry-free, residual concentrated at
  `IsPurelyInseparable k Γ ∧ Algebra.IsSeparable k Γ` —
  4 named sub-claims (S3.pi.1) / (S3.pi.2) / (S3.sep.1) /
  (S3.sep.2))

#### Helpers added per iter
- iter-145: 5 placeholders (`: True := sorry`) scaffolded in
  the new `Cotangent/ChartAlgebra.lean` file.
- iter-146: 0 net helpers; 3 placeholders refined to real
  signatures (α, β-aux constants, lift).
- iter-147: 0 net helpers; 2 placeholders refined to real
  signatures (KDM, β-core); reverse-inclusion `_hRev` is an
  inline `have` binding inside KDM's body, not a top-level
  helper.
- iter-148: 0 net helpers; 0 signatures changed; 1 declaration
  body refactored (substep 3 → smart-proof path (b)), 1
  docstring expanded (KDM (BR.1)–(BR.5) inventory).

#### Prover statuses per iter
- iter-145: COMPLETE (scaffolding only, no proof work — the
  iter-145 plan agent's substantive directive)
- iter-146: PARTIAL — 2 closures (α, lift) + 1 partial
  (constants substep 3) + 2 unchanged placeholders (β-core,
  KDM).
- iter-147: PARTIAL — 1 closure (β-core) + 2 partials (KDM
  reverse inclusion, constants substep 3 chain).
- iter-148: PARTIAL — 0 closures + 2 partials (KDM docstring
  refresh, constants substep 3 smart-proof reduction).

#### Recurring blocker phrases
- "flat base change of Γ for proper schemes" appears in iter-147
  (constants substep 3 step (e) gap); iter-148 names it as
  (S3.pi.1) and confirms it's a genuine Mathlib gap (no
  `AlgebraicGeometry.IsBaseChange` for proper π).
- "Mathlib has no off-the-shelf lemma" / "no Mathlib base" /
  "fresh Mathlib gap" — iter-146, iter-147, iter-148 all
  surface Mathlib-gap dead ends. Iter-148 invested ~60 grep
  events confirming 3 distinct gaps.
- "`: True := sorry` placeholder" — present iter-145, iter-146
  (carry-over), absent iter-147 onward.
- "Differential.ContainConstants instance" — iter-147 ("primary
  attack route"), iter-148 ("Mathlib has the class but no
  instance for standard-smooth + CharZero").

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (verbatim from the
  `Chart-algebra envelope (5 sub-pieces)` row): "4–7".
- **Elapsed iters in current phase**: 4 (iter-145 through
  iter-148; current phase began iter-145 with the chart-algebra
  pivot).
- **Phase started at iter**: 145.

#### Planner's current proposal for this iter
The planner intends to dispatch a single multi-objective prover
lane on `Cotangent/ChartAlgebra.lean` materially larger than
prior iters (per the standing user hint that lane scope must
be "several hundred LOC of proof script", not 20 LOC). The
lane targets the 2 in-scope sorries (KDM L168 + constants L367)
via three parallel sub-attacks: (KDM-p2) `[CharZero k]` +
`[Algebra.IsStandardSmoothOfRelativeDimension k B]` signature
inflation + (BR.1)–(BR.5) bridge body; (S3.sep.1) build the
`Smooth ⇒ Γ separable` bridge; (S3.pi) build the
`GeometricallyIrreducible ⇒ Γ purely inseparable` bridge
(which subsumes the (S3.pi.1) flat-base-change gap). Aggregate
~370–610 LOC.

### Route 2 (M2 / M3 off-critical-path scaffolds)

- **Files**: `Jacobian.lean` (L197 `genusZeroWitness`,
  L223 `positiveGenusWitness`), `RigidityKbar.lean` (L87
  `rigidity_over_kbar`).
- **Status**: deliberately frozen, awaiting chart-algebra piece
  (ii) closure (Route 1). 3 sorries unchanged iter-145 → iter-148.
- **Iters audited**: 145, 146, 147, 148 — all 4 iters explicitly
  OFF-LIMITS per planner.

#### Sorry counts per iter
- iter-145: 3 (unchanged across the route)
- iter-146: 3
- iter-147: 3
- iter-148: 3

#### Strategy estimate vs reality
- **`Iters left`** for `rigidity_over_kbar` body closure phase:
  "2"; phase entered "gated on chart-algebra" iter-145; elapsed
  4 iters; status remains "gated" (legitimate hold pattern, not
  drift).

#### Planner's current proposal for this iter
OFF-LIMITS preserved. Route 2 stays frozen iter-149. Iter-149
escalation hook fires only if Route 1 stalls (see below).

## PROGRESS.md proposal (this iter)

- **File count**: 1.
- **Files**: `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`.
- **Dispatch cap**: 10.

## Out of scope

- M3 Route A (Picard via FGA) — off-critical-path; no work
  scheduled this iter.
- The 5 orphan helpers in `Cotangent/GrpObj.lean` flagged
  iter-147+ for cleanup — deferred until Route 1 closure.

## Special iter-149 escalation hook (carry-over from iter-148
planner's commitment)

The iter-148 planner committed in `PROGRESS.md` § "Watch
criteria committed for iter-149": *"If iter-148 closes neither
sorry AND the substep 3 residual gap is STILL framed as 'flat
base change of Γ for proper schemes' with no further narrowing
(e.g. to a specific Mathlib decl name, a specific Stacks tag
with a known Mathlib counterpart, or a reduction to a different
lemma family — including the path (b) smart-proof gap 'Γ of
smooth ⇒ Γ separable'), iter-149 must NOT dispatch a third
prover lane against the same wall; escalate via structural
refactor / route pivot."*

Iter-148 result: closed neither sorry. BUT: substep 3 residual
WAS narrowed to 4 named sub-claims, one of which is exactly the
"Γ of smooth ⇒ separable"-family bridge claim explicitly
called out as acceptable narrowing in the hook's carve-out.
Please render a verdict on whether the hook fires or is
satisfied by the carve-out. Plan agent's read: the carve-out
applies, so the hook is satisfied and a substantively larger
prover lane (~370–610 LOC) on Route 1 is the right
iter-149 move. Critic's read may differ — please apply your
verdict rules verbatim and call CHURNING or STUCK if the
signals say so.
