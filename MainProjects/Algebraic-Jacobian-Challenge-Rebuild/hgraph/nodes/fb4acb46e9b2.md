---
author: sync
content_type: theorem
created: '2026-08-02T04:08:38'
decl: AlgebraicGeometry.Grassmannian.congrAmbient_symm_cancel
docstring: Transporting an ambient Grassmannian point through an equivalence and back
  is trivial.
file: AlgebraicJacobian/Picard/DivSchemeFrameKit.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.congrAmbient_symm_cancel
type: lean
updated: '2026-08-07T05:01:48'
---
theorem congrAmbient_symm_cancel (e : H ≃ₗ[k] H') (x : grFunctorAff k H' g T) :
    congrAmbient e (congrAmbient e.symm x) = x := by
  rw [congrAmbient_trans]
  exact Module.Grassmannian.ext (by simp)

end CongrAmbient

/-! ## K2: a matrix presentation from a free quotient -/

section MatrixFromFree

variable {k : Type u} [Field k]