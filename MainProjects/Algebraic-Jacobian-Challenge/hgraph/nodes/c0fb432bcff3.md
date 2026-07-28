---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.isAffineOpen_preimage_inf_preimage_of_isPullback
docstring: '**Cover pieces of the 02KE ladder are affine**: for a cartesian square
  and

  affine opens `V ⊆ S`, `U ⊆ S''`, `V'' ⊆ X` with `U ≤ g ⁻¹ᵁ V` and

  `V'' ≤ f ⁻¹ᵁ V`, the open `g'' ⁻¹ᵁ V'' ⊓ f'' ⁻¹ᵁ U ⊆ X''` is affine (it is the

  fibre product `V'' ×_V U` of affines over an affine, via the restricted

  cartesian square `Scheme.Hom.isPullback_resLE`). Brick for

  `pullback_baseMap_sectionLinearEquiv_of_quasiCompact` (Stacks 02KE).'
file: AlgebraicJacobian/Picard/QuotScheme.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.isAffineOpen_preimage_inf_preimage_of_isPullback
type: lean
updated: '2026-07-28T13:22:16'
---
private lemma isAffineOpen_preimage_inf_preimage_of_isPullback
    {X X' S S' : Scheme.{u}}
    {f : X ⟶ S} {g : S' ⟶ S} {g' : X' ⟶ X} {f' : X' ⟶ S'}
    (sq : IsPullback g' f' f g)
    {V : S.Opens} {U : S'.Opens} {V' : X.Opens}
    (hV : IsAffineOpen V) (hU : IsAffineOpen U) (hV' : IsAffineOpen V')
    (e : U ≤ g ⁻¹ᵁ V) (hle : V' ≤ f ⁻¹ᵁ V) :
    IsAffineOpen (g' ⁻¹ᵁ V' ⊓ f' ⁻¹ᵁ U) := by
  have : IsAffine _ := hV
  have : IsAffine _ := hU
  have : IsAffine _ := hV'
  exact .of_isIso (Scheme.Hom.isPullback_resLE sq e hle rfl).isoPullback.hom