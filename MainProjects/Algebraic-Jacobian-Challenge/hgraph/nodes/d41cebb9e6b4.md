---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.coverSectionModule
docstring: 'The constant coefficient module `O_X(V)` viewed as a module over itself.  This
  is the

  per-summand target of `freeYonedaEval_iso_of_le`, hence the coefficient of the engine
  complex.'
file: AlgebraicJacobian/Cohomology/FreePresheafComplex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.coverSectionModule
type: lean
updated: '2026-07-24T03:02:09'
---
abbrev coverSectionModule (V : TopologicalSpace.Opens ↥X) :
    ModuleCat (X.ringCatSheaf.obj.obj (Opposite.op V)) :=
  ModuleCat.of _ (X.ringCatSheaf.obj.obj (Opposite.op V))