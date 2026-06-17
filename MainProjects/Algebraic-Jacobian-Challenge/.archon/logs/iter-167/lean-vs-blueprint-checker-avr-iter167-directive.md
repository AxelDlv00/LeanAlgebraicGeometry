# Lean ↔ Blueprint Checker Directive

## Slug

avr-iter167

## Lean file

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelianVarietyRigidity.lean`

## Blueprint chapter

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelianVarietyRigidity.tex`

(This chapter declares `% archon:covers AlgebraicJacobian/AbelianVarietyRigidity.lean
AlgebraicJacobian/Genus0BaseObjects.lean`; this dispatch checks AVR. The other file
(`Genus0BaseObjects.lean`) is the subject of a sister dispatch `g0bo-iter167`.)

## Iter-167 prover delta (for context only)

Lane B refactored the 5 inline `sorry`s out of the private helper
`morphism_P1_to_grpScheme_const_aux` (iter-166: L944/L949/L953/L1029/L1037):

- 4 of the 5 (the product/Proj instances) are now auto-resolved via Lane A's
  newly-exported `projGm_locallyOfFiniteType` / `projGm_geomIrred` /
  `projGm_isReduced` / `projectiveLineBar_isReduced` instances.
- The 5th (`IsDominant iotaGm.left`) is promoted to a single named
  top-level lemma `iotaGm_isDominant` (still `sorry`, gated on Lane A's
  `gmScalingP1` body).
- All 5 `-- TODO:` excuse comments dropped.

File now has 2 sorries on disk: L934 (`iotaGm_isDominant`, NEW) and L1141
(`genusZero_curve_iso_P1`, off-limits RR-bridge, unchanged).

## Checks to perform (bidirectional)

1. **Lean → blueprint** — does the chapter cover every load-bearing
   declaration in AVR.lean? In particular:
   - the private helper `morphism_P1_to_grpScheme_const_aux`;
   - the new file-local bridge `iotaGm_isDominant`;
   - the AVR-side outer body `morphism_P1_to_grpScheme_const`.
2. **Blueprint → Lean** — does the chapter's `\lean{...}` hooks point to
   declarations that actually exist with the cited name + signature?
   The iter-167 plan ran a `blueprint-writer avr-lean-hooks` pass that
   added per-decl `\lean{...}` blocks under `def:genus0_base_objects` and
   pinned `gmScalingP1_collapse_at_zero` to a new lemma block
   `lem:gmScaling_fixes_zero`.
3. **Marker hygiene** — flag any blueprint blocks whose `\leanok` /
   `\notready` semantics are out of step with the actual Lean state
   (informational; the `sync_leanok` phase owns `\leanok`).
4. **Excuse comments** — flag any `-- TODO:` / "will fix later" prose in
   the AVR Lean file (iter-166 audit found 5; the iter-167 prover claims
   they are all dropped).

## Output

Bidirectional report in the standard format. Must-fix-this-iter issues
block downstream work on AVR; minor recommendations go to recommendations.md.
