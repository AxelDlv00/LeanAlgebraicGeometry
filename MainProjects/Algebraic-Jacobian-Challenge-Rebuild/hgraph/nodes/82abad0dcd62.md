---
author: sync
content_type: theorem
created: '2026-07-29T12:10:36'
decl: AlgebraicGeometry.isChartDatumPlusFibre_of_relPicToPicEt
docstring: '**THE PRODUCER, with the datum supplied**: if `μ` is the unit image of
  a relative Picard

  class presented by the Čech class `L₀`, then any datum whose class is `L₀` satisfies

  `IsChartDatumPlusFibre`.


  The proof is four rewrites and no geometry.  `picEtMap_relPicToPicEt` moves the
  restriction to

  `κ(t)` inside the unit; `picEtAffineEquiv_relPicToPicEt` collapses the affine comparison
  to

  `PicEtAff.unit`; `PicEtAff.map_id` deletes the identity restriction `κ(t) → κ(t)`
  that

  `IsChartDatumPlusFibre`''s left-hand side carries; and `relCurveMap_testPoint` identifies

  the two spellings of the base change.


  Note which hypotheses are absent: no witness, no `H¹`, no divisor, no degree, no
  separability,

  and no certificate.  The plus-class identity was never geometry — it is the statement
  that the

  two ways of restricting a *unit* to a residue field agree.


  **A measurement, not a claim, and it is independent evidence for that reading**:
  this theorem does

  not use `GeometricallyReduced C.hom` either — the linter says so, hence the `omit`.  A
  statement

  about a fibre class would need the curve''s geometry; this one needs the curve only
  to have the

  functor defined.'
file: AlgebraicJacobian/Picard/Pic0ChartPlusFibreProducer.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isChartDatumPlusFibre_of_relPicToPicEt
type: lean
updated: '2026-07-30T15:46:05'
---
theorem isChartDatumPlusFibre_of_relPicToPicEt {A : Type u} [CommRing A] [Algebra k A]
    (L₀ : (C ⊗ overSpec k A).left.CechPic) (D : BasicOpenCocycleDatum C A π)
    (hD : D.cechPicClass = L₀) :
    IsChartDatumPlusFibre C π
      (relPicToPicEt C (overSpec k A) (relPicMk C (overSpec k A) L₀)) D := by
  intro t
  rw [picEtMap_relPicToPicEt, picEtAffineEquiv_relPicToPicEt, PicEtAff.map_id, hD,
    relPicMap_mk, relCurveMap_testPoint]
  rfl

omit [GeometricallyReduced C.hom] in
variable (C π) in