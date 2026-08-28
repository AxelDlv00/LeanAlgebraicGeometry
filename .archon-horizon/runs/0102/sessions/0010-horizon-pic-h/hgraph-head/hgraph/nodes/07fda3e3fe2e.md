---
author: sync
content_type: definition
created: '2026-08-01T00:55:15'
decl: AlgebraicGeometry.tensorTripleTheta12_face
docstring: "The direct `1,3` comparison, defined through the common k-side functor\
  \ rather than\nas the composite of the `1,2` and `2,3` comparisons. -/\nnoncomputable\
  \ def tensorTripleTheta13 :\n    (Over.map (tensorTripleCoord1 (k := k) (L := L))).op\
  \ ⋙\n        pic0TypeFunctor ((baseChange k L).obj C) ≅\n      (Over.map (tensorTripleCoord3\
  \ (k := k) (L := L))).op ⋙\n        pic0TypeFunctor ((baseChange k L).obj C) :=\n\
  \  tensorTripleTheta (k := k) (L := L) (C := C)\n    (tensorTripleCoord1 (k := k)\
  \ (L := L))\n    (tensorTripleCoord3 (k := k) (L := L))\n    (tensorTripleCoord1_comp_base\
  \ (k := k) (L := L))\n    (tensorTripleCoord3_comp_base (k := k) (L := L))\n\n/-!\
  \ The following three comparisons are the literal pullbacks of the double-overlap\n\
  theta.  The explicit equality arguments retain the proof-bearing scheme-map casts\
  \ for\nthe `2,3` and `1,3` faces."
file: AlgebraicJacobian/Picard/Pic0RepresentabilityOverlap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.tensorTripleTheta12_face
type: lean
updated: '2026-08-01T09:44:16'
---
noncomputable def tensorTripleTheta12_face :
    (Over.map (tensorTripleCoord1 (k := k) (L := L))).op ⋙
        pic0TypeFunctor ((baseChange k L).obj C) ≅
      (Over.map (tensorTripleCoord2 (k := k) (L := L))).op ⋙
        pic0TypeFunctor ((baseChange k L).obj C) :=
  Functor.RepresentableBy.Over.mapCompPresheafFace
    (tensorTripleCoord1 (k := k) (L := L))
    (tensorTripleCoord2 (k := k) (L := L))
    (tensorTripleFace12 (k := k) (L := L))
    (tensorOverlapInl (k := k) (L := L))
    (tensorOverlapInr (k := k) (L := L))
    rfl rfl (tensorOverlapTheta (C := C))