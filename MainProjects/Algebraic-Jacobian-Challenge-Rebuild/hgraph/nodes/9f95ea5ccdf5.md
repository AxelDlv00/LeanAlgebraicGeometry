---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.presentationDivisor
docstring: '**The divisor of a meromorphic presentation** (the W2 deliverable): the
  Weil divisor

  whose multiplicity at a closed point `x` is the order of vanishing at `x` of the

  trivializing element `P.elem x` of the piece indexed by `x`. By piece-independence

  (`MeromorphicPresentation.ordZ_elem_eq`) this is the order of the local trivialization

  of the presented class near `x`, whichever piece is used to read it off.'
file: AlgebraicJacobian/Picard/PresentationDivisor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.presentationDivisor
type: lean
updated: '2026-07-16T21:33:28'
---
noncomputable def presentationDivisor [QuasiCompact (X ↘ Spec (CommRingCat.of K))]
    (P : X.MeromorphicPresentation) : X.CurveDivisor :=
  Finsupp.onFinset (P.ordZ_elem_support_finite K).toFinset
    (fun p => Multiplicative.toAdd
      (Scheme.ordZ (X ↘ Spec (CommRingCat.of K)) p.2 (P.elem p.1)))
    (fun p hp => by
      rw [Set.Finite.mem_toFinset]
      exact fun he => hp (by rw [he, toAdd_one]))

/-- The multiplicity of the divisor of a presentation at a closed point `x` is the order
of vanishing of the trivializing element `P.elem x`. -/
@[simp]