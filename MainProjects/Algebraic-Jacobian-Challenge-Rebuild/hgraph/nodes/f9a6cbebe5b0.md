---
author: sync
content_type: theorem
created: '2026-07-22T11:03:23'
decl: AlgebraicGeometry.liftQ_baseChange_injective_of_boundary
docstring: 'An independent boundary presentation of every base-changed kernel makes

  the injectivized map remain injective after that base change.  This is the

  non-circular bridge from a fibrewise Koszul theorem to the relative flatness

  criterion: no flatness of the cokernel is assumed.


  The proof lifts through the right-exact base change of `ker(f).mkQ`.  A lift

  in the fibre kernel is a base-changed boundary by `hspan`, and the global

  identity `f ∘ d = 0` makes its quotient class vanish.'
file: AlgebraicJacobian/Picard/DivSchemeHighWindowSyzygy.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.liftQ_baseChange_injective_of_boundary
type: lean
updated: '2026-07-22T11:03:23'
---
theorem liftQ_baseChange_injective_of_boundary
    (f : M →ₗ[R] N) (d : P →ₗ[R] M) (hfd : f.comp d = 0)
    (S : Type u) [CommRing S] [Algebra R S]
    (hspan : LinearMap.ker (LinearMap.baseChange S f) ≤
      LinearMap.range (LinearMap.baseChange S d)) :
    Function.Injective
      (LinearMap.baseChange S ((LinearMap.ker f).liftQ f le_rfl)) := by
  let L := LinearMap.ker f
  let fbar := L.liftQ f le_rfl
  have hfcomp : LinearMap.baseChange S f =
      (LinearMap.baseChange S fbar).comp (LinearMap.baseChange S L.mkQ) := by
    rw [← LinearMap.baseChange_comp, Submodule.liftQ_mkQ]
  have hdL : ∀ y : P, d y ∈ L := by
    intro y
    apply LinearMap.mem_ker.mpr
    have hy := LinearMap.congr_fun hfd y
    simpa only [LinearMap.comp_apply, LinearMap.zero_apply] using hy
  have hqd : L.mkQ.comp d = 0 := by
    apply LinearMap.ext
    intro y
    rw [LinearMap.comp_apply, LinearMap.zero_apply, Submodule.mkQ_apply,
      Submodule.Quotient.mk_eq_zero]
    exact hdL y
  rw [injective_iff_map_eq_zero]
  intro w hw
  obtain ⟨x, rfl⟩ := LinearMap.baseChange_surjective S
    (Submodule.mkQ_surjective L) w
  have hfx : LinearMap.baseChange S f x = 0 := by
    rw [hfcomp, LinearMap.comp_apply]
    exact hw
  obtain ⟨y, hy⟩ := hspan (LinearMap.mem_ker.mpr hfx)
  rw [← hy, ← LinearMap.comp_apply, ← LinearMap.baseChange_comp, hqd,
    LinearMap.baseChange_zero, LinearMap.zero_apply]

set_option maxHeartbeats 800000 in
-- Elaborating the quotient injectivization through tensor purity exceeds the default budget.