---
author: sync
content_type: definition
created: '2026-07-28T19:44:57'
decl: AlgebraicGeometry.IsChartDatumPlusFibre
docstring: '**The datum presents `μ` at every residue field, as plus classes** — the
  witness-free

  content of `IsChartDatumPresentation`.


  No witness divisor, no `H¹`, no degree: this says only that the plus class obtained
  by

  restricting `μ` to the residue field at `t` is the plus-unit of the datum''s fibre
  class there.


  Isolated as a definition because it is what the forward direction of

  `IsChartDatumPresentation` actually consumes, and because it is a statement about
  the *naturality

  of `cechPicClass` under base change to residue fields* — checkable independently
  of anything

  about witnesses.'
file: AlgebraicJacobian/Picard/Pic0ChartPresentationHalf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.IsChartDatumPlusFibre
type: lean
updated: '2026-07-29T15:31:47'
---
def IsChartDatumPlusFibre {A : Type u} [CommRing A] [Algebra k A]
    (μ : picEt C (overSpec k A)) (D : BasicOpenCocycleDatum C A π) : Prop :=
  ∀ t : (overSpec k A).left,
    PicEtAff.map C (Over.testPointField (T := overSpec k A) t)
        (picEtAffineEquiv C (Over.testPointField (T := overSpec k A) t)
          (picEtMap C (Over.testPoint t) μ))
      = PicEtAff.unit C (Over.testPointField (T := overSpec k A) t)
          (relPicMk C (overSpec k (Over.testPointField (T := overSpec k A) t))
            (Scheme.CechPic.map
              (relCurveMap C A (Over.testPointField (T := overSpec k A) t))
              D.cechPicClass))

/-! ## The forward half -/

variable (C π) in