---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.coprodOverIncl
docstring: 'The coproduct inclusion of leg `i`, viewed as an over-morphism into the
  descent object

  `Over.mk (Sigma.desc (·.hom))`.'
file: AlgebraicJacobian/Cohomology/CechSectionIdentificationBase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.coprodOverIncl
type: lean
updated: '2026-07-24T03:02:09'
---
noncomputable def coprodOverIncl {ι : Type*} (legs : ι → Over X)
    [HasCoproduct (fun i => (legs i).left)] (i : ι) :
    legs i ⟶ Over.mk (Limits.Sigma.desc (fun i => (legs i).hom)) :=
  Over.homMk (Limits.Sigma.ι (fun i => (legs i).left) i)
    (Limits.Sigma.ι_desc (fun i => (legs i).hom) i)