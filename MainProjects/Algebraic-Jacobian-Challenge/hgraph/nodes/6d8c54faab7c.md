---
author: sync
content_type: lemma
created: '2026-07-16T21:14:25'
decl: AlgebraicGeometry.grpObjDiffLeft_comp_hom
docstring: 'The difference morphism sits over `Spec k̄`: `grpObjDiffLeft G ≫ G.hom
  =

  pr₁ ≫ G.hom`. This is the reduction that turns `Φ.compHom G.hom` into the structure

  morphism of `X ×_{k̄} X`; it is `Over.w` of `GrpObj.diff G`.'
file: AlgebraicJacobian/Albanese/DifferenceMap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.grpObjDiffLeft_comp_hom
type: lean
updated: '2026-07-24T03:02:09'
---
lemma grpObjDiffLeft_comp_hom (G : Over (Spec (.of kbar))) [GrpObj G] :
    grpObjDiffLeft G ≫ G.hom = pullback.fst G.hom G.hom ≫ G.hom :=
  Over.w (GrpObj.diff G)