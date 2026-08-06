---
author: sync
content_type: theorem
created: '2026-08-04T10:53:20'
decl: AlgebraicGeometry.relCurveAffineOpenIso_inv_trans
docstring: 'Inverse form of `relCurveAffineOpenIso_hom_trans`, convenient for transporting

  data from a cover component to its affine relative-curve model.'
file: AlgebraicJacobian/Picard/RelativeCurveAffineCover.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relCurveAffineOpenIso_inv_trans
type: lean
updated: '2026-08-07T05:01:58'
---
theorem relCurveAffineOpenIso_inv_trans
    {U V : T.left.directedAffineCover.I₀} (hUV : U ⟶ V) :
    Scheme.Cover.trans (relCurveAffineCover C T) hUV ≫
        (relCurveAffineOpenIso C T V).inv =
      (relCurveAffineOpenIso C T U).inv ≫
        (C ◁ Over.overSpecMap (Over.resAlgHom T (leOfHom hUV))).left := by
  rw [← cancel_epi (relCurveAffineOpenIso C T U).hom]
  calc
    (relCurveAffineOpenIso C T U).hom ≫
          (Scheme.Cover.trans (relCurveAffineCover C T) hUV ≫
            (relCurveAffineOpenIso C T V).inv) =
        ((relCurveAffineOpenIso C T U).hom ≫
          Scheme.Cover.trans (relCurveAffineCover C T) hUV) ≫
            (relCurveAffineOpenIso C T V).inv := (Category.assoc _ _ _).symm
    _ = ((C ◁ Over.overSpecMap (Over.resAlgHom T (leOfHom hUV))).left ≫
          (relCurveAffineOpenIso C T V).hom) ≫
            (relCurveAffineOpenIso C T V).inv := by
      rw [relCurveAffineOpenIso_hom_trans C T hUV]
    _ = (C ◁ Over.overSpecMap (Over.resAlgHom T (leOfHom hUV))).left := by simp
    _ = ((relCurveAffineOpenIso C T U).hom ≫
          (relCurveAffineOpenIso C T U).inv) ≫
            (C ◁ Over.overSpecMap (Over.resAlgHom T (leOfHom hUV))).left := by simp
    _ = (relCurveAffineOpenIso C T U).hom ≫
          ((relCurveAffineOpenIso C T U).inv ≫
            (C ◁ Over.overSpecMap (Over.resAlgHom T (leOfHom hUV))).left) :=
      Category.assoc _ _ _