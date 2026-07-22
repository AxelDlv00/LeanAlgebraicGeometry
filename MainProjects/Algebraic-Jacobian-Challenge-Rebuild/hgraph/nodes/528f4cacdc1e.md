---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.representableByOfShift
docstring: '**The ε⁺ transport of a `RepresentableBy` datum (DAT-J consumer)**: a
  representing

  object for the shifted degree-`m·d₁` layer is a representing object for the degree-zero

  Picard functor.  Precomposition with `mulThetaPowNatIso` via `RepresentableBy.ofIso`.'
file: AlgebraicJacobian/Picard/ThetaShift.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.representableByOfShift
type: lean
updated: '2026-07-16T21:33:28'
---
def representableByOfShift {J : Over (Spec (.of k))}
    (L₀ : (C ⊗ overSpec k k).left.CechPic) (m : ℕ)
    (rep : (picDegLayerFunctor C ((m : ℤ) * classDeg k L₀)).RepresentableBy J) :
    ((pic0Functor C ⋙ forget₂ CommGrpCat GrpCat) ⋙ forget GrpCat).RepresentableBy J :=
  rep.ofIso (mulThetaPowNatIso C L₀ m).symm

/-! ## The pinned Θ-class and its positivity (DAT-0b) -/

variable (C) in