---
author: sync
content_type: theorem
created: '2026-07-31T14:47:56'
decl: AlgebraicGeometry.Scheme.exists_affineOpen_of_subset_finiteInAffine_opens
docstring: '**`FiniteInAffine` of an open subscheme suffices for finite sets inside
  it.**


  If `U` is an open subscheme satisfying `FiniteInAffine` and the finite set `s` lies
  in `U`,

  then `s` lies in an affine open **of `X`** — push the affine open forward along
  the open

  immersion `U.ι`, which preserves affineness of opens

  (`IsAffineOpen.image_of_isOpenImmersion`).


  This is what lets projectivity be consumed piecewise: one quasi-projective piece
  containing

  the whole set is enough, and the ambient scheme need not be projective — which §5.5
  shows

  it is not.'
file: AlgebraicJacobian/Picard/QuasiProjectiveFiniteInAffine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.exists_affineOpen_of_subset_finiteInAffine_opens
type: lean
updated: '2026-07-31T14:47:56'
---
theorem exists_affineOpen_of_subset_finiteInAffine_opens {X : Scheme.{u}} (U : X.Opens)
    (hU : FiniteInAffine U.toScheme) {s : Set X} (hs : s.Finite) (hsub : s ⊆ U.1) :
    ∃ V : X.affineOpens, s ⊆ V.1 := by
  obtain ⟨W, hW⟩ := hU (U.ι.base ⁻¹' s) (hs.preimage U.ι.isOpenEmbedding.injective.injOn)
  refine ⟨⟨U.ι ''ᵁ W.1, W.2.image_of_isOpenImmersion U.ι⟩, ?_⟩
  intro x hx
  exact ⟨⟨x, hsub hx⟩, hW (by simpa using hx), rfl⟩