---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.GradedModule.lastVarAlgHom_X_castSucc
file: AlgebraicJacobian/Picard/GradedHilbertSerre.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.GradedModule.lastVarAlgHom_X_castSucc
type: lean
updated: '2026-07-24T03:02:10'
---
@[simp] lemma lastVarAlgHom_X_castSucc (r : ℕ) (i : Fin r) :
    lastVarAlgHom r κ (MvPolynomial.X (Fin.castSucc i)) = MvPolynomial.X i := by
  simp [lastVarAlgHom]