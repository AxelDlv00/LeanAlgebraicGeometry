---
author: sync
content_type: theorem
created: '2026-07-16T21:14:28'
decl: AlgebraicJacobian.TwoTerm.bijective_kerBaseChange_of_surjective
docstring: 'If `d : M0 → M1` is a surjection with `M1` flat, then `ker d` is a

  *pure* submodule of `M0`: the formation of `H⁰ = ker d` commutes with

  arbitrary base change.  This is the `H⁰`-half of cohomology-and-base-change

  once `H¹` vanishes.'
file: AlgebraicJacobian/Picard/TwoTermFiniteFree.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.TwoTerm.bijective_kerBaseChange_of_surjective
type: lean
updated: '2026-07-24T03:02:12'
---
theorem bijective_kerBaseChange_of_surjective [Module.Flat A M1]
    {d : M0 →ₗ[A] M1} (hd : Function.Surjective d)
    (B : Type v) [CommRing B] [Algebra A B] :
    Function.Bijective (kerBaseChange d B) := by
  have hexact : Function.Exact (ker d).subtype d := d.exact_subtype_ker_map
  have hinj : Function.Injective ((ker d).subtype.lTensor B) :=
    lTensor_injective_of_exact_of_flat (Submodule.injective_subtype _) hexact hd B
  constructor
  · intro z w hzw
    apply hinj
    exact congrArg Subtype.val hzw
  · intro x
    have hexactB : Function.Exact ((ker d).subtype.baseChange B) (d.baseChange B) :=
      lTensor_exact B hexact hd
    obtain ⟨z, hz⟩ := (hexactB x.1).mp (mem_ker.mp x.2)
    exact ⟨z, Subtype.ext hz⟩