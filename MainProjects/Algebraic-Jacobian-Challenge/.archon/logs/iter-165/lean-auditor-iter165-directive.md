# lean-auditor iter-165 directive

## Scope

Audit the `.lean` files of the project. Pay extra attention to the file
that received prover edits this iter (the only meaningfully changed code
file), but as always do a whole-tree pass.

## Files

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus0BaseObjects.lean` (NEW this iter — primary focus)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian.lean` (one-line import added)
- The rest of the tree per your normal whole-project sweep:
  `AlgebraicJacobian/AbelianVarietyRigidity.lean`,
  `AlgebraicJacobian/Jacobian.lean`,
  `AlgebraicJacobian/RigidityKbar.lean`,
  `AlgebraicJacobian/Genus.lean`,
  `AlgebraicJacobian/Rigidity.lean`,
  `AlgebraicJacobian/Differentials.lean`,
  `AlgebraicJacobian/AbelJacobi.lean`,
  `AlgebraicJacobian/Cotangent/*.lean` (if any),
  `AlgebraicJacobian/Cohomology/*.lean` (if any).

## What to check in `Genus0BaseObjects.lean` specifically

This file is a NEW scaffold lane. **9 `sorry`s remain by design** (per
the plan). Your job is to audit the SCAFFOLDING and the NON-sorry
proofs that DID land, not to mark "sorry remaining" as a finding. The
plan-allowed scaffold sorries are:

1. `projectiveLineBar_geomIrred` (L175): explicitly named "Mathlib has no `GeometricallyIrreducible Proj _`".
2. `projectiveLineBar_smoothOfRelDim` (L184): explicitly named.
3. `ProjectiveLineBar.{zeroPt,onePt,inftyPt}` (L201/206/211): scaffold k̄-points.
4. `ga_grpObj` (L264): `GrpObj.ofRepresentableBy` body deferred.
5. `gm_grpObj` (L329): same.
6. `gmScalingP1` (L368): bare ⊗-morphism via `Scheme.Cover.glueMorphisms`.
7. `gmScalingP1_collapse_at_zero` (L385): companion fixed-point lemma.

All are top-level named declarations, NOT buried `letI`/`have` sorries.

The main delivered proof to audit is `projectiveLineBar_isProper`
(L127–170): the chain change → IsScalarTower → FiniteType → bijective
algebraMap → IsIso → IsProper of composite. The task_result claims this
was promoted from "FREE-from-Mathlib" (the analogist's verdict) to a
proper proof because the algebra-map `k̄ → ↥(𝒜 0)` identification needed
a Subalgebra-of-constants check.

## What to flag

- Bad Lean practices in the scaffolding (e.g., `letI`/`have :=` hiding a
  real sorry inside an apparently-closed proof).
- The `projectiveLineBar_isProper` proof: any laundering, any
  hypothesis that's unused but load-bearing-looking, any
  `inferInstance` that should not actually find the desired instance.
- The `ga_smooth` / `gm_smooth` proofs (one-liner chains): are these
  sound given that `ga_grpObj` / `gm_grpObj` are `sorry`? They will
  necessarily carry `sorryAx`; the question is whether the chain is
  logically correct modulo that.
- Stale-narrative debt from prior iters (lean-auditor `iter164`
  flagged 5 such majors on `Cotangent/GrpObj.lean`,
  `Cotangent/ChartAlgebra.lean`, `RigidityKbar.lean`, `Jacobian.lean`).
  Confirm whether they were touched this iter; if not, re-surface as
  carry-over issues, not new.
- Any other suspect declarations or dead-end proofs.

## Out of scope

- Reviewing strategy / blueprint correspondence. That's the
  lean-vs-blueprint-checker's job.
- Marking "sorry remaining" as a finding for the 9 scaffold sorries
  named above. Treat them as plan-allowed.

## Format

Per-file checklist + flagged-issues block, severity-tagged. Write to
`task_results/lean-auditor-iter165.md`.
