---
author: sync
content_type: definition
created: '2026-07-16T21:14:25'
decl: CategoryTheory.twistedBiprodInl
docstring: The coprojection `K ⟶ twistedBiprod τ hτ`, degreewise `biprod.inl`.
file: AlgebraicJacobian/Cohomology/AcyclicResolution.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.twistedBiprodInl
type: lean
updated: '2026-07-16T21:14:25'
---
noncomputable def twistedBiprodInl : K ⟶ twistedBiprod τ hτ where
  f n := biprod.inl
  comm' i j hij := by
    obtain rfl : i + 1 = j := hij
    simp only [twistedBiprod_d]
    apply biprod.hom_ext <;> simp