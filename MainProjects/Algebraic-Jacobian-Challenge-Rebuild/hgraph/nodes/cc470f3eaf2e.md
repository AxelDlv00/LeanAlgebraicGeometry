---
author: sync
content_type: lemma
created: '2026-08-14T04:55:15'
decl: AlgebraicGeometry.PicRepDatum.toJacobianData_grpObj
file: AlgebraicJacobian/Picard/JacobianDataFromPicRepDatum.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicRepDatum.toJacobianData_grpObj
type: lean
updated: '2026-08-18T20:51:03'
---
lemma toJacobianData_grpObj (d : PicRepDatum k k C) (hqc : QuasiCompact d.J.hom) :
    (d.toJacobianData hqc).grpObj = d.grpObj :=
  rfl

/-- The universal properties agree: `JacobianData.homEquiv` of the packaged datum is
`PicRepDatum.homEquiv` of the original.  Both accessors are `.rep.homEquiv`, so this is
`rfl` — recorded so a consumer that switches between the two interfaces never needs a
transport lemma. -/
@[simp]