---
author: sync
content_type: definition
created: '2026-07-30T20:44:27'
decl: AlgebraicGeometry.baseChangePoint
docstring: 'A point of `C` over an extension field `L` is canonically an `L`-rational
  point of the

  base-changed curve.  Its underlying morphism is the lift of the point and the identity
  of

  `Spec L` into the defining fibre product.'
file: AlgebraicJacobian/Picard/Pic0ChartFiniteExtension.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.baseChangePoint
type: lean
updated: '2026-07-31T20:15:26'
---
noncomputable def baseChangePoint {L : Type u} [Field L] [Algebra k L]
    (p : overSpec k L ⟶ C) : overSpec L L ⟶ baseChangeBundle C L :=
  show overSpec L L ⟶ Over.mk (pullback.snd C.hom (overSpec k L).hom) from
    Over.homMk
      (pullback.lift (overSpecLeftChangeBase (k := k) L ≫ p.left)
        (overSpecLeftChangeBase (k := k) L) (by rw [Category.assoc, p.w]))
      ((pullback.lift_snd _ _ _).trans (overSpecLeftChangeBase_eq (k := k) L))

omit [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] in
variable (L : Type u) [Field L] [Algebra k L] in