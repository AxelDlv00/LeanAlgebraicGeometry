---
author: sync
content_type: lemma
created: '2026-07-28T22:23:02'
decl: AlgebraicGeometry.divFamZarAffOfAff_val
docstring: 'The value of `divFamZarAffOfAff` at every affine open is the restricted
  transported

  class.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffVehicle.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divFamZarAffOfAff_val
type: lean
updated: '2026-07-30T15:46:04'
---
lemma divFamZarAffOfAff_val (x : DivFamZarAff C R n)
    (U : (overSpec k R).left.affineOpens) :
    (divFamZarAffOfAff C n R x).1 U
      = DivFamZarAff.mapAlgHom
          ((Over.resAlgHom (overSpec k R) le_top).comp
            (Over.overSpecΓTopAlgEquiv k R).symm.toAlgHom) x :=
  rfl