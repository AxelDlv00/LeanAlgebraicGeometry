---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.matrixEndRect_one
docstring: '`matrixEndRect` of the identity matrix is the identity. Project-local.'
file: AlgebraicJacobian/Picard/GrassmannianQuot.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.matrixEndRect_one
type: lean
updated: '2026-07-16T21:14:27'
---
lemma matrixEndRect_one {S : Scheme.{0}} {d : ℕ} :
    matrixEndRect (1 : Matrix (Fin d) (Fin d) Γ(S, ⊤)) = 𝟙 _ :=
  (matrixEnd_eq_matrixEndRect _).symm.trans matrixEnd_one