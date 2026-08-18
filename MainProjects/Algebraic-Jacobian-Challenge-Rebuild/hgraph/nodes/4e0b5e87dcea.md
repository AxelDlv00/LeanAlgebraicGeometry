---
author: sync
content_type: theorem
created: '2026-08-16T20:15:44'
decl: AlgebraicGeometry.pic0FiniteStageAtlas_inter_isAffine
docstring: 'Pairwise intersections of charts in the chosen finite atlas of the exact
  separably

  closed `Pic^0` representer are affine.  This uses the group structure transported
  from

  the represented Picard functor, rather than adding separatedness as a hypothesis.'
file: AlgebraicJacobian/Picard/Pic0FiniteStageAffineIntersections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0FiniteStageAtlas_inter_isAffine
type: lean
updated: '2026-08-18T20:51:05'
---
theorem pic0FiniteStageAtlas_inter_isAffine
    (U V : Pic0FiniteStageChartIndex C) :
    IsAffineOpen (U.1.1 ⊓ V.1.1) := by
  let J := (pic0_sepClosed_representableBy (C := C)).1
  letI : GrpObj J := (picRepDatumSepClosed C).grpObj
  haveI : IsSeparated J.hom := isSeparated_of_grpObj J
  haveI : Scheme.IsSeparated J.left := by
    constructor
    rw [← Limits.terminal.comp_from J.hom]
    infer_instance
  exact U.1.2.inf V.1.2