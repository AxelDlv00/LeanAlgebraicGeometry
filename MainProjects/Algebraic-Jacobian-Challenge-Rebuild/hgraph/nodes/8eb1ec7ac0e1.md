---
author: sync
content_type: theorem
created: '2026-07-29T03:25:40'
decl: AlgebraicGeometry.Over.testPoint_comp
docstring: '**The naturality square of the bridge, in the slice.**  `Pic0ChartTestPoint.testPoint_comp_left`

  states it for the underlying scheme morphisms; every class-level transport needs
  it for the

  `Over`-morphisms themselves, since `picEtMap` is indexed by those.  Faithfulness
  of

  `Over.forget` (`Over.OverMorphism.ext`) is the whole content.'
file: AlgebraicJacobian/Picard/Pic0ChartLocusIsoInvariance.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.testPoint_comp
type: lean
updated: '2026-08-01T09:44:16'
---
theorem testPoint_comp {T T' : Over (Spec (.of k))} (f : T' ⟶ T) (t : T'.left) :
    testPoint t ≫ f
      = overSpecMap (testPointFieldAlgHom f t) ≫ testPoint (T := T) (f.left.base t) :=
  Over.OverMorphism.ext (by
    rw [Over.comp_left, Over.comp_left, Over.overSpecMap_left]
    exact testPoint_comp_left f t)

end Over

namespace PicEtAff

omit [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] in