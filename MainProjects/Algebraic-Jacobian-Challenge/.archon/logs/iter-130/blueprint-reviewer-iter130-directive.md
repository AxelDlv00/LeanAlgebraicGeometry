# Blueprint Reviewer Directive

## Slug
iter130

## Iter
130

## Strategy snapshot (one paragraph)

Iter-130 enters the prover phase under the iter-127 over-k commitment. The
critical-path is **M2 (genus-0 witness) shared cotangent-vanishing pile**,
specifically iter-130's prover lane: swap the iter-128 body of
`AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` (which is kernel-clean
but computes the zero `k`-module per the iter-129 mathlib-analogist
discovery in `analogies/lieAlgebra-rank-bridge.md`) to **Replacement (B)**:
affine-chart base change via the already-shipped `smooth_locally_free_omega`
+ `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`.
Expected closure 200–400 LOC. After body swap, optional Wave 2 may scaffold
+ close the rank lemma `cotangentSpaceAtIdentity_finrank_eq` (50–100 LOC).

## Lean files in scope this iter (prover-touch candidates)

- `AlgebraicJacobian/Cotangent/GrpObj.lean` — primary iter-130 prover target. Single declaration `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` (currently kernel-clean but mathematically degenerate body — iter-130 swaps to Replacement (B)). Corresponding blueprint chapter: `blueprint/src/chapters/RigidityKbar.tex`.

## Sorry inventory entering iter-130

- `AlgebraicJacobian/Jacobian.lean:192` — `genusZeroWitness` (iter-127 scaffold; body closure iter-138+; OFF-LIMITS this iter).
- `AlgebraicJacobian/Jacobian.lean:211` — `nonempty_jacobianWitness` (Phase-C OFF-LIMITS; iter-148+).
- `AlgebraicJacobian/RigidityKbar.lean:87` — `rigidity_over_kbar` (iter-126 scaffold; iter-144+; OFF-LIMITS this iter).

## Specific reviewer asks (iter-130)

1. **HARD GATE on `RigidityKbar.tex` for `Cotangent/GrpObj.lean` prover lane**: per the iter-129 lean-vs-blueprint-checker `cotangent-grpobj-review129`, the iter-129 writer pass frames the iter-128 body as the canonical realisation of `η_G^* Ω_{G/k}` (proof of `lem:GrpObj_cotangentSpace` line 115 uses "*realises*"; `lem:GrpObj_cotangent_bridge` proof line 160 calls the bridge "tautological"; statement line 141 names the LHS as "the iter-128 evaluate-then-extend-scalars Lean body" with no hedge). Under the iter-129 mathlib-analogist finding that the iter-128 body is provably degenerate (zero for the consumer class), this framing is wrong. Does this drift block the iter-130 prover lane on body swap, or is the chapter-prose-vs-Lean-body discrepancy tolerable (since the prover lane will land Replacement (B) which the chapter prose can be re-aligned to in iter-131+)?
2. **Bridge lemma `lem:GrpObj_cotangent_bridge` vs Replacement (B)**: the iter-129 writer authored the bridge as a stalk-side cotangent (closer to Replacement (A)), while the iter-130 prover lane will implement Replacement (B) (affine-chart base change). After iter-130 body swap, the bridge lemma's LHS will no longer be the "evaluate-then-extend-scalars" form — it'll be a "chart-base-changed Kähler module" form. Does the chapter need a writer pass THIS iter to re-state the bridge against Replacement (B), or is it OK to leave the bridge as a "(A)-flavored, iter-131+ alignment" placeholder?
3. **Forward-reference completeness**: do all `\lean{...}` hints in `RigidityKbar.tex` (`cotangentSpaceAtIdentity_iso_localRingCotangent`, `cotangentSpaceAtIdentity_finrank_eq`, `mulRight_globalises_cotangent`, `omega_free`, `omega_rank_eq_dim`) point at declarations that the iter-130+ prover lane will eventually instantiate, or are any of them phantom names that need correcting?
4. **`Jacobian.tex` adequacy for iter-138+ genusZeroWitness body closure**: the iter-129 lean-vs-blueprint-checker reported 2 minor stale line refs (`Jacobian.tex:398/410`) — are these blocking or editorial?
5. **Other chapters**: any cross-chapter `\uses{...}` dangling, any chapter that says "this is in Mathlib" when it isn't, any prose that contradicts the iter-127 over-k commitment?

## Apply the HARD GATE verbatim

Per your dispatcher-notes HARD GATE rule, for each Lean file F in scope this iter (listed above), look up the corresponding blueprint chapter C and decide:

- C `complete: true` AND `correct: true` AND no must-fix-this-iter? → green light for F's prover dispatch.
- Otherwise → flag F to be dropped this iter, name the writer dispatch that would unblock it next iter (or this iter if the writer is dispatched in parallel).

If the iter-130 prover lane on `Cotangent/GrpObj.lean` should be deferred per HARD GATE, name the specific writer directive that would unblock it.
