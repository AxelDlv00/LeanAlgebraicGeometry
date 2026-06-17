# lean-vs-blueprint-checker — Genus0BaseObjects.lean vs AbelianVarietyRigidity.tex (iter-168)

## Mode

Bidirectional file-vs-chapter check.

## Lean file

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus0BaseObjects.lean`

## Blueprint chapter

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelianVarietyRigidity.tex`

The Genus0BaseObjects.lean file is covered by AbelianVarietyRigidity.tex via the
top-of-chapter directive `% archon:covers AlgebraicJacobian/AbelianVarietyRigidity.lean
AlgebraicJacobian/Genus0BaseObjects.lean`.

## Scope of this iter

This iter (168) the prover added:
- `projectiveLineBarAffineCover` (L196) — axiom-clean 2-chart cover via
  `Proj.affineOpenCoverOfIrrelevantLESpan`.
- `homogeneousLocalizationAwayIso` (L378) and helper ring maps L259–L312 — chart
  ring iso `Away 𝒜 (X i) ≃+* k̄[u]`, with `aux_left` round-trip (L368) still a
  `sorry`.
- `projectiveLineBar_isReduced` (L719) — axiom-clean (NEW substantive closure;
  previously a scaffold sorry).

Check:

1. Does the chapter need new `\lean{...}` hooks pinning the new declarations
   (`projectiveLineBarAffineCover`, `homogeneousLocalizationAwayIso`,
   `homogeneousLocalizationAwayToMvPoly`,
   `mvPolyToHomogeneousLocalizationAway`,
   `projectiveLineBar_isReduced`)? If so, suggest precise locations.
2. Is the prose around `def:genus0_base_objects` and `def:gaTranslationP1` still
   accurate now that the chart-ring iso has been built (still partially
   `sorry`-bodied at `aux_left`)?
3. Does the L708 docstring on `projectiveLineBar_isReduced` correctly identify
   the Mathlib bridge it consumed (`Function.Injective.isDomain` +
   `IsLocalization.isDomain_localization`)? Has the blueprint side caught up?
4. Any remaining sorries in `Genus0BaseObjects.lean`
   (L175 `geomIrred`, L182 `smoothOfRelDim`, L368 `aux_left`, L537 `ga_grpObj`,
   L622 `gm_grpObj`, L659 `gmScalingP1` body, L674
   `gmScalingP1_collapse_at_zero` body, L761 `gm_geomIrred`,
   L791 `projGm_isReduced`) — does each have a corresponding blueprint anchor or
   is the chapter silent on them?

## Output

Bidirectional report:
- Lean → blueprint: declarations without blueprint coverage / `\lean{...}` pins.
- Blueprint → Lean: claims in prose not backed by Lean / Lean names that the
  chapter references but no Lean decl exists.
- Severity: must-fix-this-iter / major / minor.
- Concrete `\lean{...}` insertions or chapter-prose patches (when applicable).
