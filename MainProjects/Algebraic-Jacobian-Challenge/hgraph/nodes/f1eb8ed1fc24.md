---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial
docstring: '**Tensor product of locally-trivial modules is locally trivial.**


  If `M, N : X.Modules` are locally trivial of rank one (line bundles), so is

  their tensor product `tensorObj M N`. Per blueprint

  `lem:tensorobj_preserves_locally_trivial`. The proof picks, for each point `x`,

  a common affine open `W ∋ x` contained in trivialising opens `U` (for `M`) and

  `U''` (for `N`), refines both trivialisations to `W` via `restrictIsoUnitOfLE`,

  then transports through `tensorObj_restrict_iso`, the bifunctoriality

  `tensorObjIsoOfIso`, and the unit isomorphism `tensorObj_unit_iso`:

  `(M ⊗ N)|_W ≅ M|_W ⊗ N|_W ≅ 𝒪_W ⊗ 𝒪_W ≅ 𝒪_W`. The only residual gap is the

  substrate-restriction compatibility `tensorObj_restrict_iso`.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial
type: lean
updated: '2026-07-16T21:14:28'
---
lemma tensorObj_isLocallyTrivial {X : Scheme.{u}} {M N : X.Modules}
    (hM : LineBundle.IsLocallyTrivial M) (hN : LineBundle.IsLocallyTrivial N) :
    LineBundle.IsLocallyTrivial (tensorObj M N) := by
  intro x
  obtain ⟨U, hxU, hU_aff, ⟨eM⟩⟩ := hM x
  obtain ⟨U', hxU', hU'_aff, ⟨eN⟩⟩ := hN x
  obtain ⟨W, hW_aff, hxW, hWsub⟩ :=
    exists_isAffineOpen_mem_and_subset (X := X) (x := x) (U := U ⊓ U') ⟨hxU, hxU'⟩
  have hWU : W ≤ U := le_trans hWsub inf_le_left
  have hWU' : W ≤ U' := le_trans hWsub inf_le_right
  refine ⟨W, hxW, hW_aff, ⟨?_⟩⟩
  exact tensorObj_restrict_iso W.ι M N ≪≫
    tensorObjIsoOfIso (restrictIsoUnitOfLE hWU eM) (restrictIsoUnitOfLE hWU' eN) ≪≫
    tensorObj_unit_iso

/-! ## Project-local Mathlib supplement — the d.2-free descent re-route (B-connector)

The "locally-iso ⇒ iso" half of the descent assembly of `exists_tensorObj_inverse`:
a morphism of `𝒪_X`-modules that restricts to an isomorphism on an open
neighbourhood of every point is a global isomorphism. The route is the stalkwise
iso criterion `TopCat.Presheaf.isIso_of_stalkFunctor_map_iso` (for sheaves valued
in `Ab`, whose forgetful functor reflects isos and preserves limits / filtered
colimits) together with `Scheme.Modules.restrictStalkNatIso` (restriction along an
open immersion commutes with stalks). **No stalk-⊗ ("d.2") is invoked**: this is a
statement about a single module morphism, never about the tensor stalk. -/