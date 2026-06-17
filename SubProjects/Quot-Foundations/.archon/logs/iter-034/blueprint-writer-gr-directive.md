# blueprint-writer directive — Picard_GrassmannianCells.tex (iter-034)

Chapter: `blueprint/src/chapters/Picard_GrassmannianCells.tex`. You edit ONLY this chapter. Two parts.
Do NOT add `\leanok` (deterministic sync owns it). `\mathlibok` only on genuine Mathlib anchors.

## Strategy context
`lem:gr_separated` (label @~1716): separatedness of `Grassmannian.scheme = (theGlueData d r).glued`
over ℤ, checked on the affine chart cover `U^I ×_ℤ U^J`. Source: Nitsure §1 "Separatedness"
(already source-quoted in the existing block — preserve the `% SOURCE QUOTE`). The ring-theoretic heart
(surjectivity of the restricted-diagonal comorphism) is now formalized; the geometric assembly route
has been scouted (route (b)).

## PART A — Coverage blocks for 7 unmatched Lean helpers (clear coverage debt)

These public Lean decls (GrassmannianCells.lean ~1179–1272) have NO blueprint block. Add one block each
(statement + `\label` + `\lean{full.Lean.Name}` + accurate `\uses{}` + ≥1-line informal proof), placed
in a new subsection `sec:gr_separated` BEFORE `lem:gr_separated`. Suggested labels in brackets.

1. `AlgebraicGeometry.Grassmannian.transitionPreMap_minorDet_swap_mul`
   [`lem:gr_transitionPreMap_minorDet_swap_mul`] — `θ̃_{I,J}(P^J_I) · P^I_J = 1` in `R^I_J`
   (explicit two-sided inverse refining `lem:gr_transitionPreMap_minorDet` @~654).
   `\uses{lem:gr_transition_pre, lem:gr_transitionPreMap_minorDet}`.
2. `AlgebraicGeometry.Grassmannian.diagonalRingMap` (def) [`def:gr_diagonalRingMap`] — the
   restricted-diagonal comorphism `δ_{I,J} : ℤ[X^I] ⊗_ℤ ℤ[X^J] → R^I_J`,
   `X^I⊗1 ↦ X^I`, `1⊗X^J ↦ θ̃_{I,J}(X^J) = (X^I_J)⁻¹X^I`, built as
   `Algebra.TensorProduct.lift (R^I→R^I_J) θ̃_{I,J}`. `\uses{def:gr_transition_pre}`.
3. `AlgebraicGeometry.Grassmannian.diagonalRingMap_left` and `…_right` — fold into ONE block
   [`lem:gr_diagonalRingMap_apply`]: `δ(a⊗1) = algebraMap a`, `δ(1⊗b) = θ̃_{I,J}(b)` (via
   `Algebra.TensorProduct.lift_tmul`). `\uses{def:gr_diagonalRingMap}`.
4. `AlgebraicGeometry.Grassmannian.diagonalRingMap_surjective` [`lem:gr_diagonalRingMap_surjective`] —
   `δ_{I,J}` is surjective. Proof: `IsLocalization.surj` gives `z·(P^I_J)^n = algebraMap a`; the
   witness `a ⊗ (P^J_I)^n` maps to `z` using `transitionPreMap_minorDet_swap_mul`.
   `\uses{lem:gr_transitionPreMap_minorDet_swap_mul, def:gr_diagonalRingMap, lem:gr_diagonalRingMap_apply}`.
5. `AlgebraicGeometry.Grassmannian.pullbackιIso` (def) [`def:gr_pullbackIotaIso`] —
   `pullback (ι i) (ι j) ≅ chartOverlap d r i.1 j.1` (the source iso `e₂`), built from
   `theGlueData.vPullbackConeIsLimit` + `limit.isLimit`. `\uses{}` the glue-data + chart-overlap labels.

(The 3 GR `private` helpers `rotMid`, `transitionInvImageMatrix`, `transitionInvPair` are
implementation details of the cocycle; they may appear in the leandag unmatched scan but need NO
blueprint block — they are private. Add a one-line `% NOTE:` in the cocycle proof block recording that
these three are private helpers, so a future planner does not chase them.)

## PART B — Update `lem:gr_separated` proof to route (b)

The current `lem:gr_separated` proof body should be updated to the scouted route (b):
- Build the structure morphism `π : scheme d r → Spec ℤ` by gluing the per-chart
  `Spec.map (algebraMap ℤ R^I)` via `GlueData.glueMorphisms` (compatible because every `transitionMap`
  is a ℤ-algebra map).
- Prove `IsSeparated π` over the GENUINE base `Spec ℤ` by the `AlgebraicGeometry.Proj.isSeparated`
  template (`Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Proper.lean:80–129`): on each patch
  `U^I ×_{Spec ℤ} U^J` the restricted diagonal is the closed immersion
  `Spec.map δ_{I,J}` (`IsClosedImmersion.spec_of_surjective` + `diagonalRingMap_surjective`),
  using the source iso `pullbackιIso` (e₂) and target iso `pullbackSpecIso ℤ R^I R^J` (e₁) —
  route (b) works over the real `Spec ℤ`, so the Proj template applies verbatim (no terminal wrinkle).
- Conclude `(scheme d r).IsSeparated` (over the terminal) from `IsSeparated π` via
  `Scheme.isSeparated_iff` + `IsSeparated.comp_iff` (`Spec ℤ` affine ⟹ separated).
Add Mathlib anchor blocks (`\lean{}`+`\mathlibok`) for `AlgebraicGeometry.IsClosedImmersion.spec_of_surjective`,
`AlgebraicGeometry.pullbackSpecIso`, and `AlgebraicGeometry.Proj.isSeparated` (template reference).
Update `lem:gr_separated`'s `\uses{}` to include `lem:gr_diagonalRingMap_surjective`, `def:gr_pullbackIotaIso`.
Keep the existing Nitsure `% SOURCE QUOTE`.

## Out of scope
`lem:gr_proper` (follows separated — leave as is). Do not touch other chapters or add `\leanok`.
Authorize a child reference-retriever only if you need Nitsure §1 text not already in the chapter.
