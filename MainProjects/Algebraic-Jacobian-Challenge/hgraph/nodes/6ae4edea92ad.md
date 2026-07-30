---
author: sync
content_type: definition
created: '2026-07-31T02:29:40'
decl: AlgebraicGeometry.Scheme.PicScheme.representableBy_picEt_separableClosure_of_representableBy
docstring: '**The seam implies representability over the separable closure.**


  The `k^s` instance of §2. `SeparableClosure k` is a `Type u` field with a `k`-algebra

  structure, so no universe bridge and no extra hypothesis is involved: this is §2
  with

  `k'' := SeparableClosure k` and nothing else.


  Named because campaign cluster `J` targets exactly this object, and because a lane

  should be able to cite "the campaign''s endpoint is a consequence of the seam" without

  re-deriving the base change.'
file: AlgebraicJacobian/Picard/PicEtDescentNecessity.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.representableBy_picEt_separableClosure_of_representableBy
type: lean
updated: '2026-07-31T02:29:40'
---
noncomputable def representableBy_picEt_separableClosure_of_representableBy
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X : Over (Spec (CommRingCat.of k))}
    (rep : (picEt C).RepresentableBy X) :
    (picEt (Scheme.baseChangeField C (SeparableClosure k))).RepresentableBy
      ((Over.pullback (specMapAlgebra k (SeparableClosure k))).obj X) :=
  representableBy_picEt_baseChangeField_of_representableBy C rep