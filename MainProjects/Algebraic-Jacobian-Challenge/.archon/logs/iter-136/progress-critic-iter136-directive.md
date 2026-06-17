# Progress Critic Directive — iter-136

You audit progress signals for the active routes the plan agent is
considering for this iter's prover assignment. You do NOT read
STRATEGY.md, the blueprint, or PROGRESS.md — only the signals below.

## Active routes (4)

### Route 1 — `AlgebraicJacobian/Cotangent/GrpObj.lean` piece (i.a)

Piece (i.a) closed iter-132. No further work this iter. Last 5 iters:

| iter | sorries (file) | helpers added | prover status | notes |
|---|---|---|---|---|
| 131 | 1 | 1 strong-acceptance lemma `cotangentSpaceAtIdentity_eq_extendScalars` | PARTIAL | iter-131 body-shape refactor |
| 132 | 0 | 0 | COMPLETE | rank lemma `cotangentSpaceAtIdentity_finrank_eq` closed kernel-only |
| 133 | 0 | 0 | n/a (no prover) | iter-133 plan-only (refactor + 3 writers) |
| 134 | 0 | n/a (file's piece-(i.b) work landed iter-134; see Route 4) | n/a for (i.a) | piece-(i.a) declarations untouched |
| 135 | 0 | n/a (file's piece-(i.b) work iter-135 honest-scaffold refactor; see Route 4) | n/a for (i.a) | piece-(i.a) declarations untouched |

### Route 2 — `AlgebraicJacobian/Jacobian.lean` (deferred by design)

`genusZeroWitness` body gated on M2.a body iter-151+;
`positiveGenusWitness` body gated on M3 user-escalation-pending
(OFF-CRITICAL-PATH). Last 5 iters:

| iter | sorries (file) | helpers added | prover status | notes |
|---|---|---|---|---|
| 131 | 2 | 0 | n/a (deferred) | no prover work |
| 132 | 2 | 0 | n/a (deferred) | no prover work |
| 133 | 2 | 0 | n/a (deferred) | no prover work |
| 134 | 3 | 1 scaffold `positiveGenusWitness` (refactor lane, +1 sorry) | n/a (refactor only) | iter-134 plan-phase scaffold landing |
| 135 | 2 | 0 substantive (body restructure: 1 inline `sorry` → `by_cases` delegation) | n/a (refactor only) | iter-135 refactor net −1 sorry via delegation |

### Route 3 — `AlgebraicJacobian/RigidityKbar.lean` (deferred by design)

`rigidity_over_kbar` body gated on M2.body-pile pieces (i)+(ii)+(iii).
Last 5 iters:

| iter | sorries (file) | helpers added | prover status | notes |
|---|---|---|---|---|
| 131 | 1 | 0 | n/a (deferred) | no prover work |
| 132 | 1 | 0 | n/a (deferred) | no prover work |
| 133 | 1 | 0 | n/a (deferred) | no prover work |
| 134 | 1 | 0 | n/a (deferred) | no prover work |
| 135 | 1 | 0 | n/a (deferred) | no prover work |

### Route 4 — `AlgebraicJacobian/Cotangent/GrpObj.lean` piece (i.b)

Iter-134 first prover lane landed Step 1 substantively (4 closed
declarations) + 3 hollow placeholders (`Nonempty (X ≅ X) := ⟨Iso.refl _⟩`
shape) at L468/L496/L560. Both iter-134 review audits flagged the
3 placeholders as must-fix-this-iter under the strict rubric.
Iter-135 plan-phase refactor REPLACED the 3 placeholders with 3
honest sorry-bodied scaffolds typed against the intended sheaf-level
RHS using Mathlib's `Scheme.Hom.toRingCatSheafHom` idiom. Both
iter-135 review audits classified the refactor as a "legitimate
honesty improvement". Last 5 iters:

| iter | sorries (Route 4 only) | helpers added | prover status | notes |
|---|---|---|---|---|
| 131 | 0 (Route 4 fresh, not yet started) | 0 | n/a | piece (i.b) blueprint hardening + analogist scheduled iter-133 |
| 132 | 0 (still pre-Route-4) | 0 | n/a | piece (i.a) close iter-132 |
| 133 | 0 (still pre-Route-4) | 0 | n/a (plan-only) | piece (i.b) blueprint hardening (RigidityKbar.tex 324 → 511 LOC) + iter-133 mathlib-analogist returned PROCEED |
| 134 | 0 substantive (4 closed: `shearMulRight` + 2 `@[simps]` companions + `schemeHomRingCompatibility`) + **3 hollow placeholders** (`Nonempty (X ≅ X) := ⟨Iso.refl _⟩` at L468/L496/L560; tautology bodies, `sorry_analyzer` blind) | 4 substantive + 3 placeholders | PARTIAL (must-fix-this-iter under strict rubric) | iter-134 prover lane; +278 LOC |
| 135 | 3 honest sorries (L468/L496/L560 NEW iter-135 honest scaffolds replacing 3 hollow placeholders); 1 inline-`sorry` on `nonempty_jacobianWitness` REPLACED by `by_cases` delegation (Route 2 side) | 0 (refactor was signature swap; net Route 4 helpers iter-135: 0 substantive) | n/a (plan-only refactor + 3 writers) | iter-135 refactor classified honesty-improvement by both review audits |

Iter-136 plan agent is considering: prover lane on
`Cotangent/GrpObj.lean` targeting Step 3
(`relativeDifferentialsPresheaf_restrict_along_identity_section`,
L496, ~30–80 LOC) as cheapest substantive piece; if Step 3 closes,
attempt Step 2 (L468, ~150–300 LOC) in iter-137.

**Recurring blocker phrases** (none currently active on Route 4 entering
iter-136; the iter-134 placeholder pattern was addressed by iter-135
refactor + the project convention is codified in
`Cotangent/GrpObj.lean` L421 docstring + `RigidityKbar.tex` iter-135
NOTEs as "honest scaffolds, never tautological-iso placeholders").

## Iter-135 carry-forward verdict criteria

- **PASS criterion (iter-135 progress-critic)**: ≥ 2 of 3 placeholders
  refactored to non-`Nonempty (X ≅ X)` types — **already satisfied
  iter-135** (3 of 3 typed against intended sheaf-level RHS).
- **Iter-136 next-tier PASS**: prover round substantively closes ≥ 1
  of the 3 honest-scaffold bodies (Step 3 ~30–80 LOC is cheapest).
- **FAIL (flips Route 4 to CHURNING)**: any iter-136 prover round
  that adds declarations whose declared types do not match docstring
  intent only at the prose level (the same placeholder pattern).

## What I ask of you

Render a per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR)
and, where CHURNING or STUCK, name the corrective. Specifically:

1. Is Route 4 CONVERGING entering iter-136 given the iter-135
   honest-scaffold refactor that the review audits endorsed?
2. Are Routes 2 + 3 properly classified as deferred-by-design (UNCLEAR)?
3. Is Route 1 properly classified as CONVERGING (closed iter-132,
   META-PATTERN TRIPWIRE non-promise holds)?

If Route 4 is UNCLEAR or CHURNING, recommend the corrective: a
narrower iter-136 prover scope (e.g. Step 3 only, not Step 2 + Step
3 bundled), or a blueprint-writer expansion on
`RigidityKbar.tex § Step 3 proof`, or a mathlib-analogist consult on
`PresheafOfModules.pullbackId` / `pullbackComp` usage.

Output to `.archon/task_results/progress-critic-iter136.md`.
