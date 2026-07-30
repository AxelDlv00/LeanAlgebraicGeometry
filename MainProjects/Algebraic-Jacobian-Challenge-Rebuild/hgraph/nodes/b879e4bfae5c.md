---
author: sync
content_type: theorem
created: '2026-07-17T21:17:13'
decl: AlgebraicGeometry.JacobianData.yonedaGrp_map_pullbackHom
docstring: '**The defining equation of `pullbackHom`** (`map_preimage`): its `yonedaGrp`
  image

  is the conjugated degree-zero pullback transformation.  Everything about `pullbackHom`

  is proved through this equation and `yonedaGrp` faithfulness.'
file: AlgebraicJacobian/Picard/Pic0PullbackGrp.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.JacobianData.yonedaGrp_map_pullbackHom
type: lean
updated: '2026-07-30T15:28:03'
---
theorem yonedaGrp_map_pullbackHom (dX : JacobianData X) (dY : JacobianData Y)
    (g : X ⟶ Y) :
    letI := dX.grpObj
    letI := dY.grpObj
    yonedaGrp.map (pullbackHom dX dY g)
      = (yonedaGrpObjIsoOfRepresentableBy dY.J _ dY.rep).hom
        ≫ Functor.whiskerRight (pic0PullbackNat g) (forget₂ CommGrpCat GrpCat)
        ≫ (yonedaGrpObjIsoOfRepresentableBy dX.J _ dX.rep).inv :=
  yonedaGrpFullyFaithful.map_preimage _