# Lean ↔ Blueprint Checker Directive

## Slug

g0bo-iter166

## File pair to audit

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus0BaseObjects.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelianVarietyRigidity.tex`
  (consolidated chapter that also covers `Genus0BaseObjects.lean` via `% archon:covers`).

## Scope

iter-166 Lane 2 landed three `k̄`-points of `ℙ¹` (`ProjectiveLineBar.{zeroPt, onePt, inftyPt}`,
L268–L280) and a private helper `ProjectiveLineBar.pointOfVec` (L234) with the supporting
`evalIntoGlobal` + `irrelevant_map_eq_top`. The other 6 sorries on the file remain:
- L177 `projectiveLineBar_geomIrred` (OPT-IN scaffold)
- L184 `projectiveLineBar_smoothOfRelDim` (OPT-IN scaffold)
- L335 `ga_grpObj` (OPT-IN scaffold, off-path)
- L400 `gm_grpObj` (CRITICAL, deferred — requires `IsLocalization.Away`-Spec representable-by)
- L437/L439 `gmScalingP1` body (CRITICAL, deferred — chartwise glue)
- L452/L456 `gmScalingP1_collapse_at_zero` body (CRITICAL, downstream of `gmScalingP1`)

Verify bidirectionally:

(A) **Lean → Blueprint.** Does the new `pointOfVec` helper + the three points match the
chapter's description of `def:genus0_base_objects` (the "three distinguished `k̄`-points of
`ℙ¹`")? In particular, the unit-coordinate choice (`zeroPt = [0:1]`, `onePt = [1:1]`,
`inftyPt = [1:0]`) should be consistent.

(B) **Blueprint → Lean.** Is the chapter sufficient for the live-consumer sorries that remain?
Specifically, does the chapter pin
- `gm_grpObj` (the `GrpObj` instance on `Gm`),
- `gmScalingP1` (the σ_× action ℙ¹ × Gm → ℙ¹),
- `gmScalingP1_collapse_at_zero` (the fixed-point identity at zero)
to `\lean{...}` hooks the prover can find, AND give enough mathematical detail for iter-167+
to attempt them?

(C) Per-decl `\lean{...}` coverage gap previously flagged in iter-165 `g0bo-iter165`:
the three points + `gmScalingP1_collapse_at_zero` did not have per-decl hooks. Confirm whether
the chapter has been updated since.

(D) Confirm `pointOfVec` is correctly `private` (helper, not a top-level decl) — the chapter
should not expose it.

## Out of scope

- Do not read STRATEGY.md, PROGRESS.md, iter sidecars, or `AbelianVarietyRigidity.lean`.
- Restrict to the one file pair named above.
