---
author: sync
content_type: lemma
created: '2026-08-14T04:55:15'
decl: AlgebraicGeometry.PicRepDatum.toJacobianData_grpObj
file: AlgebraicJacobian/Picard/JacobianDataHandoff.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicRepDatum.toJacobianData_grpObj
type: lean
updated: '2026-08-18T23:39:51'
---
lemma toJacobianData_grpObj (d : PicRepDatum k k C) (hqc : QuasiCompact d.J.hom) :
    (d.toJacobianData hqc).grpObj = d.grpObj :=
  rfl

/-- The universal properties of the packaged datum and the original datum agree. -/
@[simp]