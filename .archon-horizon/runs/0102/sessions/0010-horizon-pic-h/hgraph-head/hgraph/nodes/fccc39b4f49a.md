---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.picFromBase
docstring: 'The subgroup of Picard classes on `C ⊗ T` pulled back from the test object
  `T`

  along the second projection. The relative Picard group is the quotient by it.'
file: AlgebraicJacobian/Picard/RelPic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.picFromBase
type: lean
updated: '2026-08-01T09:44:17'
---
def picFromBase (T : Over (Spec (.of k))) : Subgroup ((C ⊗ T).left.CechPic) :=
  (CechPic.map (snd C T).left).range