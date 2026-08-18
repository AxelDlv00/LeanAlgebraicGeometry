---
author: sync
content_type: definition
created: '2026-08-14T14:17:16'
decl: AlgebraicGeometry.canonicalRankOneAbelSliceIso
docstring: 'The canonical Abel map and canonical evaluation divisor form an isomorphism
  already on the

  slice.  Its sigma extension is `canonicalRankOneAbelIso`.'
file: AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.canonicalRankOneAbelSliceIso
type: lean
updated: '2026-08-18T20:51:06'
---
noncomputable def canonicalRankOneAbelSliceIso :
    (divRankOnePresentationPreimageRepresenter (divRepAffP1Map C)).toFunctor ≅
      (PicRankOneOpen (divRepAffP1Map C)).toFunctor where
  hom := rankOneAbelRepresented (divRepAffP1Map C)
  inv := canonicalRankOneRepresenterTrans (C := C)
  hom_inv_id := by
    ext T x
    apply rankOneAbelRepresented_app_injective (divRepAffP1Map C) T.unop
    exact canonicalRankOneRepresenterTrans_abel
      ((rankOneAbelRepresented (divRepAffP1Map C)).app T x)
  inv_hom_id := by
    ext T x
    exact canonicalRankOneRepresenterTrans_abel x