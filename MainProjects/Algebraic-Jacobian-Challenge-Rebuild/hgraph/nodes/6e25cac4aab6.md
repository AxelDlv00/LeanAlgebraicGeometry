---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.ordZ_germGenericUnits
docstring: '**Unit sections have trivial order.** The germ at `η` of a unit section
  over an open

  `U` has order zero at every closed point of `U`: locally the rational function is
  a unit

  of the structure sheaf. This is the local vanishing statement behind the

  piece-independence of `presentationDivisor`.'
file: AlgebraicJacobian/Picard/PresentationDivisor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.ordZ_germGenericUnits
type: lean
updated: '2026-08-01T09:44:17'
---
theorem ordZ_germGenericUnits {U : X.Opens} (hηU : genericPoint X ∈ U) (u : Γ(X, U)ˣ)
    {x : X} (hx : x ≠ genericPoint X) (hxU : x ∈ U) :
    Scheme.ordZ (X ↘ Spec (CommRingCat.of K)) hx (germGenericUnits hηU u) = 1 := by
  rw [Scheme.ordZ_eq_one_iff]
  have hmem : x ∈ X.basicOpen (u : Γ(X, U)) :=
    (X.mem_basicOpen (u : Γ(X, U)) x hxU).mpr
      (u.isUnit.map (X.presheaf.germ U x hxU).hom)
  exact Scheme.ord_eq_one_of_mem_basicOpen (X ↘ Spec (CommRingCat.of K)) hx
    (u : Γ(X, U)) hηU hmem