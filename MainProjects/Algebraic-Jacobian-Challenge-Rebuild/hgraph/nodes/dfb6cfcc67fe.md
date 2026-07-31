---
author: sync
content_type: theorem
created: '2026-07-19T20:31:14'
decl: AlgebraicGeometry.PicRepDatum.homEquiv_comp
docstring: 'Naturality of `homEquiv` against the degree-zero restriction maps `pic0Map`

  (element form of the `RepresentableBy` naturality, with the functor value unfolded

  through `forget₂ ⋙ forget`).'
file: AlgebraicJacobian/Picard/PicRepDatum.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicRepDatum.homEquiv_comp
type: lean
updated: '2026-07-31T20:15:28'
---
theorem homEquiv_comp (d : PicRepDatum k k' C') {T T' : Over (Spec (.of k'))}
    (f : T' ⟶ T) (g : T ⟶ d.J) :
    d.homEquiv (f ≫ g) = pic0Map C' f (d.homEquiv g) :=
  d.rep.homEquiv_comp f g