---
author: sync
content_type: theorem
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.isOpenImmersion_relCurveMap_away
docstring: '**The relative-curve comparison of a localization is an open immersion**:
  for

  `IsLocalization.Away f S`, the comparison `relCurveMap C R S : C_S ⟶ C_R` is the

  whiskering of the basic open immersion `Spec S ⟶ Spec R`, hence its base change
  along

  the projection (`Over.isOpenImmersion_whiskerLeft`).'
file: AlgebraicJacobian/Picard/DivisorFamilyZariskiSep.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isOpenImmersion_relCurveMap_away
type: lean
updated: '2026-07-24T17:02:47'
---
theorem isOpenImmersion_relCurveMap_away (f : R) [IsLocalization.Away f S] :
    IsOpenImmersion (relCurveMap C R S) := by
  haveI : IsOpenImmersion (overSpecMap (k := k) R S).left := by
    rw [overSpecMap_left]
    exact IsOpenImmersion.of_isLocalization f
  exact Over.isOpenImmersion_whiskerLeft C (overSpecMap (k := k) R S)

end OneLocalization

section Family

variable {ι : Type u} (g : ι → R) (S : ι → Type u) [∀ i, CommRing (S i)]
  [∀ i, Algebra k (S i)] [∀ i, Algebra R (S i)] [∀ i, IsScalarTower k R (S i)]
  [∀ i, IsLocalization.Away (g i) (S i)]

/-- **The point lift for a span-⊤ family of localizations**: every point of the
relative curve `C_R` lifts to the relative curve of some localization `S i`. The