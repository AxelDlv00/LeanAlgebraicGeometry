---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Grassmannian.grFunctor.eval
docstring: Evaluation of a section of `grFunctor` at an affine open.
file: AlgebraicJacobian/Picard/GrassmannianFunctor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.grFunctor.eval
type: lean
updated: '2026-07-30T15:46:05'
---
def eval (U : T.left.affineOpens) (s : grFunctor k H d T) :
    grFunctorAff k H d Γ(T.left, U.1) :=
  s.1 U

@[simp]