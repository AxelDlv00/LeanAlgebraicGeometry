---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.relUnitCocycle
docstring: '**Pullback of a unit cocycle to the relative curve**: the image of a two-cover
  unit

  cocycle on the curve (e.g. the fiber-twist cocycle `t₀ⁿ` of

  `AlgebraicJacobian.RiemannRoch.FiberTwist`) under the first projection, a unit cocycle

  on the base-changed two-cover of `relCurve C R`.'
file: AlgebraicJacobian/Cohomology/TwistedSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relUnitCocycle
type: lean
updated: '2026-07-30T15:46:00'
---
noncomputable def relUnitCocycle (gk : Γ(C.left, D.V₀ ⊓ D.V₁)ˣ) :
    Γ(relCurve C R, (relCover C R D).V₀ ⊓ (relCover C R D).V₁)ˣ :=
  Units.map ((fst C (overSpec k R)).left.appLE (D.V₀ ⊓ D.V₁)
    ((relCover C R D).V₀ ⊓ (relCover C R D).V₁)
    (le_of_eq (relCover_inf C R D))).hom.toMonoidHom gk