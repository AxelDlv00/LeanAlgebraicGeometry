---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: AlgebraicJacobian.Diagonal.sectionMap
docstring: "The section `ψ : B ⊗[Polynomial k] B → (B ⊗[k] B) ⧸ (u⊗1 − 1⊗u)` of `π`,\
  \ sending\n`x ⊗ y ↦ x ⊗ y`. Composed with `π` it is the quotient map, which forces\n\
  `ker π ⊆ (u⊗1 − 1⊗u)`. \n\n\n * Provenance: CUSTOM."
file: AlgebraicJacobian/Algebra/DiagonalIdeal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.Diagonal.sectionMap
type: lean
updated: '2026-08-14T19:11:10'
---
noncomputable def sectionMap :
    B ⊗[Polynomial k] B →ₐ[Polynomial k] (B ⊗[k] B) ⧸ Ideal.span {diagGen (k := k) (B := B)} :=
  Algebra.TensorProduct.lift
    ((Ideal.Quotient.mkₐ (Polynomial k) _).comp Algebra.TensorProduct.includeLeft)
    qRight (fun _ _ => Commute.all _ _)