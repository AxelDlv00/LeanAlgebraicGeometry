# Mathlib Analogist Report

## Mode
api-alignment

## Slug
chart-bridge173

## Iteration
173

## Question
Right Mathlib idiom for `(gmScalingP1_cover kbar).X i ≅ Spec ((Away 𝒜 (X i)) ⊗[kbar] GmRing kbar)`, where
`(gmScalingP1_cover kbar).X i = pullback (pullback.fst PLB.hom Gm.hom) (Proj.awayι 𝒜 (X i) _ _)`. Iter-172 prover's PRIMARY 3 blocked on the source-side identification.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| (1) `pullbackSpecIso` IS the canonical tensor-pullback iso (orientation: `pullback (Spec.map (algebraMap R S)) (Spec.map (algebraMap R T)) ≅ Spec (.of (S ⊗[R] T))`) | PROCEED | informational |
| (2) Bridge from `pullback (pullback.fst PLB.hom Gm.hom) (Proj.awayι …)` to two-`Spec.map`s pullback requires `pullbackSymmetry ≫ pullbackRightPullbackFstIso ≫ congr ≫ pullbackSpecIso` — NO single Mathlib lemma | NEEDS_MATHLIB_GAP_FILL (weak) | informational |
| (3) `Proj.awayι ≫ PLB.hom = Spec.map (algebraMap kbar (Away 𝒜 X_i))` via `Proj.awayι_toSpecZero` + `algebraKbarAway` defeq | PROCEED | informational |
| (4) `OpenCover.pullback₁` encoding is the right Mathlib path | PROCEED | informational |

## Informational

- **Iter-172 prover was correct** that the bridge from the abstract pullback to a tensor-product `Spec` requires more than `pullbackSpecIso` alone. The full chain assembles four Mathlib lemmas. Cite chain:
  - `pullbackSymmetry` — `Mathlib.CategoryTheory.Limits.Shapes.Pullback.HasPullback.lean:494-496`.
  - `pullbackRightPullbackFstIso : pullback f' (pullback.fst f g) ≅ pullback (f' ≫ f) g` — `Mathlib.CategoryTheory.Limits.Shapes.Pullback.Pasting.lean:451-456`.
  - `Proj.awayι_toSpecZero : awayι 𝒜 f f_deg hm ≫ toSpecZero 𝒜 = Spec.map (CommRingCat.ofHom (fromZeroRingHom 𝒜 _))` — `Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Basic.lean:209`.
  - `pullbackSpecIso (R S T : Type u) [CommRing _]³ [Algebra R S] [Algebra R T] : pullback (Spec.map (algebraMap R S)) (Spec.map (algebraMap R T)) ≅ Spec (.of (S ⊗[R] T))` — `Mathlib.AlgebraicGeometry.Pullbacks.lean:702-708`.

- **The exact same pattern (pullbackSymmetry + pullbackRightPullbackFstIso) is used in Mathlib** at `Mathlib.AlgebraicGeometry.Cover.Open.lean:160-166` for `OpenCover.pullbackCoverAffineRefinementObjIso`. This is the proper-Mathlib-style template the prover should mirror.

- **Defeq sanity check** for step `Gm.hom = Spec.map (CommRingCat.ofHom (algebraMap kbar (GmRing kbar)))`: instance `gmScheme_canOver` (project L707-709) sets `hom := Spec.map (CommRingCat.ofHom (algebraMap kbar (GmRing kbar)))` directly, so this is `rfl`. No bridge needed there.

- **Bridge size: ~30 LOC total** across two declarations (`awayι_comp_PLB_hom` ~8 LOC, `gmScalingP1_cover_X_iso` ~12 LOC), well within the ≤30 LOC threshold. No further sub-splitting is needed.

- **`gmScalingP1_chart` body** then becomes ~10 LOC: `(gmScalingP1_cover_X_iso kbar i).hom ≫ Spec.map (chart_i_ringMap) ≫ Spec.map (homogeneousLocalizationAwayIso.symm) ≫ Proj.awayι`. Caveat the prover should respect: `gmScalingP1_chart{0,1}_ringMap` codomain is `Tensor kbar (MvPoly Unit kbar) (GmRing kbar)` while the bridge lands at `Spec (… (Away 𝒜 X_i) ⊗[kbar] GmRing)`, so the iso must apply *before* (i.e. its inverse threads into the source). The order in the recipe is detailed in `analogies/chart-bridge.md`.

## Persistent file
- `analogies/chart-bridge.md` — design-rationale captured; full bridge recipe + 2-declaration scaffold + Mathlib citations + Sub-lemma proof sketches.

Overall verdict: project's pullback₁-encoding is correctly Mathlib-aligned; the iter-172 blocker is resolved by a 30-LOC bridge assembling `pullbackSymmetry`, `pullbackRightPullbackFstIso`, `Proj.awayι_toSpecZero`, and `pullbackSpecIso` — no refactor, no Mathlib parallel-API problem.
