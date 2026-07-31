---
author: sync
content_type: instance
created: '2026-07-29T00:02:39'
decl: AlgebraicGeometry.Over.testPointField_fromSpecAffine_isIso
docstring: '**The residue-field comparison along an affine-open test object is an
  isomorphism** — the

  lemma `Picard/Pic0ChartTestPoint.lean`''s header advertises as `testPointField_affineOpen_iso`

  and which does not exist under that (or any) name.


  For `U` an affine open of `T.left` and `t` a point of `Spec Γ(T.left, U)`, the induced
  extension

  `κ(fromSpecAffine T U (t)) → κ(t)` is invertible.


  The reason is structural rather than computational: `IsAffineOpen.fromSpec` is an
  open immersion,

  and the residue-field map of an open immersion is an iso in mathlib already.'
file: AlgebraicJacobian/Picard/Pic0ChartLocusGeneralTest.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.testPointField_fromSpecAffine_isIso
type: lean
updated: '2026-07-31T20:15:27'
---
instance testPointField_fromSpecAffine_isIso (T : Over (Spec (.of k)))
    (U : T.left.affineOpens) (t : (overSpec k Γ(T.left, U.1)).left) :
    IsIso (testPointFieldMap (fromSpecAffine T U) t) := by
  haveI : IsOpenImmersion (fromSpecAffine T U).left := U.2.isOpenImmersion_fromSpec
  exact Scheme.instIsIsoCommRingCatResidueFieldMapOfIsOpenImmersion
    (fromSpecAffine T U).left t

end Over

/-! ## Transport (i) for the affine-piece maps, both directions -/

variable (C) in