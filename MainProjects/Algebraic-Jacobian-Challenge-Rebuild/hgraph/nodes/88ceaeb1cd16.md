---
author: sync
content_type: definition
created: '2026-08-01T14:45:39'
decl: AlgebraicGeometry.PicRepDatum.grpObj
file: AlgebraicJacobian/Picard/PicRepDatum.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicRepDatum.grpObj
type: lean
updated: '2026-08-18T20:51:06'
---
noncomputable def grpObj (d : PicRepDatum k k' C') : GrpObj d.J :=
  GrpObj.ofRepresentableBy d.J
    (pic0Functor C' ⋙ forget₂ CommGrpCat GrpCat) d.rep