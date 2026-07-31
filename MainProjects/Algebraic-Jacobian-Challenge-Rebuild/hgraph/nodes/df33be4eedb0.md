---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.picEtAffineEquiv_relPicToPicEt
docstring: '**Affine consistency of the unit**: on an affine test `overSpec k A` the
  component

  `relPicToPicEt` collapses, through the affine comparison `picEtAffineEquiv`, to
  the

  unit `PicEtAff.unit` of the plus construction.'
file: AlgebraicJacobian/Picard/PicEtUnit.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.picEtAffineEquiv_relPicToPicEt
type: lean
updated: '2026-07-31T20:15:28'
---
theorem picEtAffineEquiv_relPicToPicEt (A : Type u) [CommRing A] [Algebra k A]
    (z : relPic C (overSpec k A)) :
    picEtAffineEquiv C A (relPicToPicEt C (overSpec k A) z) = PicEtAff.unit C A z :=
  calc picEtAffineEquiv C A (relPicToPicEt C (overSpec k A) z)
      = PicEtAff.mapAlg C (Over.overSpecΓTopAlgEquiv k A).toAlgHom
          (PicEtAff.unit C Γ((overSpec k A).left, (overSpecTopAffine A).1)
            (relPicMap C (Over.fromSpecAffine (overSpec k A) (overSpecTopAffine A))
              z)) := rfl
    _ = PicEtAff.unit C A (relPicAlgMap C (Over.overSpecΓTopAlgEquiv k A).toAlgHom
          (relPicMap C (Over.fromSpecAffine (overSpec k A) (overSpecTopAffine A)) z)) :=
        PicEtAff.mapAlg_unit C _ _
    _ = PicEtAff.unit C A
          (relPicMap C (Over.overSpecMap (k := k) (Over.overSpecΓTopAlgEquiv k A).toAlgHom
            ≫ Over.fromSpecAffine (overSpec k A) (overSpecTopAffine A)) z) :=
        congrArg (PicEtAff.unit C A)
          (relPicMap_comp C (Over.fromSpecAffine (overSpec k A) (overSpecTopAffine A))
            (Over.overSpecMap (k := k) (Over.overSpecΓTopAlgEquiv k A).toAlgHom) z).symm
    _ = PicEtAff.unit C A (relPicMap C (𝟙 (overSpec k A)) z) :=
        congrArg (fun g : overSpec k A ⟶ overSpec k A =>
            PicEtAff.unit C A (relPicMap C g z))
          (Over.overSpecMap_ΓTop_fromSpecAffine_top A)
    _ = PicEtAff.unit C A z := congrArg (PicEtAff.unit C A) (relPicMap_id C z)

/-! ## The natural transformation -/

section unit

variable [IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]