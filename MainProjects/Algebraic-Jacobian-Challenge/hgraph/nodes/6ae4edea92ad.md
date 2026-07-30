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


  Named because `k^s` is the field campaign cluster `J` works over, so a lane can
  cite

  this instance without re-deriving the base change. **Not** because it is cluster
  `J`''s

  target: that target is a graded `picSharp` with no carrier in this project, and
  the

  section header above records why the identification is unproved. Do not cite this
  as

  "the campaign''s endpoint follows from the seam".'
file: AlgebraicJacobian/Picard/PicEtDescentNecessity.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.representableBy_picEt_separableClosure_of_representableBy
type: lean
updated: '2026-07-31T03:47:21'
---
noncomputable def representableBy_picEt_separableClosure_of_representableBy
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X : Over (Spec (CommRingCat.of k))}
    (rep : (picEt C).RepresentableBy X) :
    (picEt (Scheme.baseChangeField C (SeparableClosure k))).RepresentableBy
      ((Over.pullback (specMapAlgebra k (SeparableClosure k))).obj X) :=
  representableBy_picEt_baseChangeField_of_representableBy C rep