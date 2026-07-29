---
author: sync
content_type: lemma
created: '2026-07-28T13:42:18'
decl: AlgebraicGeometry.isLocalHom_dualNumber_iff
docstring: 'A ring homomorphism from a local ring to the dual numbers `k[ε]` over
  a

  field is local iff its constant component kills the maximal ideal. The

  right-hand side is the side condition on dual-number points used in

  `TangentSpaceDualNumbers.lean`.'
file: AlgebraicJacobian/Tangent/TangentSchemePoints.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isLocalHom_dualNumber_iff
type: lean
updated: '2026-07-29T15:31:50'
---
lemma isLocalHom_dualNumber_iff (f : R →+* DualNumber k) :
    IsLocalHom f ↔ ∀ x ∈ maximalIdeal R, fst (f x) = 0 := by
  constructor
  · intro hf x hx
    by_contra h0
    have hu : IsUnit (f x) := isUnit_iff_isUnit_fst.mpr (isUnit_iff_ne_zero.mpr h0)
    exact mem_nonunits_iff.mp ((mem_maximalIdeal x).mp hx) (hf.map_nonunit x hu)
  · intro h
    refine ⟨fun a ha => ?_⟩
    by_contra hna
    have hm : a ∈ maximalIdeal R := (mem_maximalIdeal a).mpr (mem_nonunits_iff.mpr hna)
    have h0 : fst (f a) = 0 := h a hm
    have := isUnit_iff_isUnit_fst.mp ha
    rw [h0] at this
    exact not_isUnit_zero this

end DualNumberLocalHom

section SpecAtPoint

variable (X : Scheme.{u}) (R : CommRingCat.{u}) [IsLocalRing R]