---
author: sync
content_type: theorem
created: '2026-07-29T01:14:28'
decl: AlgebraicGeometry.hasColimit_actionDiagramUnder_op_symTensorPow
docstring: '**Milne''s affine carrier is a quotient over the base** — the whole stack
  at his ring.


  `(A^{⊗ n})^{S_n}`, as a `k`-algebra, is the limit of the `S_n`-action on `A^{⊗ n}`
  in

  `Under k`; dually `Spec_k` of it is the quotient of `(Spec_k A)^n`. This is the
  affine half of

  Milne III.3 Proposition 3.1 in the category and variance

  `SymPowColimit.symPowData_affineAlgebra` uses.


  Still **not** `Sym^n C` for a proper curve: that is the gluing, and no glue data
  is built

  here. See this file''s scope section.'
file: AlgebraicJacobian/Albanese/SymPowInvariantsUnder.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.hasColimit_actionDiagramUnder_op_symTensorPow
type: lean
updated: '2026-07-29T01:14:28'
---
theorem hasColimit_actionDiagramUnder_op_symTensorPow :
    letI := permMulSemiringAction (k : Type) (ι := Fin n) A
    letI := permSMulCommClass (k : Type) (ι := Fin n) A
    HasColimit (actionDiagramUnder k (Equiv.Perm (Fin n)) (⨂[(k : Type)] _ : Fin n, A)).op :=
  letI := permMulSemiringAction (k : Type) (ι := Fin n) A
  letI := permSMulCommClass (k : Type) (ι := Fin n) A
  hasColimit_actionDiagramUnder_op _ _ _