---
author: sync
content_type: lemma
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Grassmannian.matrixPoint_toSubmodule
file: AlgebraicJacobian/Picard/GrassmannianMatrixPoint.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Grassmannian.matrixPoint_toSubmodule
type: lean
updated: '2026-07-31T20:14:50'
---
lemma matrixPoint_toSubmodule (X : Matrix (Fin d) (Fin r) S)
    (hX : Function.Surjective (matrixProj k d r S X)) :
    (matrixPoint k d r S X hX).toSubmodule = LinearMap.ker (matrixProj k d r S X) :=
  rfl