---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.coprodToProdMap_comp_
docstring: 'Projecting the canonical comparison `coprodToProdMap` onto a factor recovers
  the push–pull map

  of the corresponding coproduct inclusion (the defining property of `coprodToProdMap`).'
file: AlgebraicJacobian/Cohomology/CechSectionIdentificationBase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.coprodToProdMap_comp_
type: lean
updated: '2026-07-24T03:02:09'
---
private lemma coprodToProdMap_comp_π {ι : Type*} (F : X.Modules) (legs : ι → Over X)
    [HasCoproduct (fun i => (legs i).left)] [HasProduct (fun i => pushPullObj F (legs i))]
    (i : ι) :
    coprodToProdMap F legs ≫ Limits.Pi.π (fun i => pushPullObj F (legs i)) i
      = pushPullMap F (coprodOverIncl legs i) := by
  simp only [coprodToProdMap, Limits.Pi.lift_π]