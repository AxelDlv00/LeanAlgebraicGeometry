---
author: sync
content_type: theorem
created: '2026-08-14T14:17:16'
decl: AlgebraicGeometry.locallyOfFiniteType_pic0_sepClosed_representableBy
docstring: 'The exact separably closed representing scheme constructed above is locally
  of finite type

  over the base field.'
file: AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.locallyOfFiniteType_pic0_sepClosed_representableBy
type: lean
updated: '2026-08-18T20:51:06'
---
theorem locallyOfFiniteType_pic0_sepClosed_representableBy :
    LocallyOfFiniteType (pic0_sepClosed_representableBy (C := C)).1.hom := by
  let hopen := picRankOneOpen_isOpen (C := C)
    (divRepAffP1Map C) (divRepAffP1Map_comp C)
  let h := divRankOneOpenDataOfPicRankOneOpen (divRepAffP1Map C) hopen
  let f := fun a : PicRankOneTranslatorIndex (C := C) =>
    picRankOneTranslatedChart (C := C) h a
  let hf := fun a : PicRankOneTranslatorIndex (C := C) =>
    picRankOneTranslatedChart_isOpenImmersion (C := C) hopen a
  letI : Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f) :=
    isLocallySurjective_sigmaDesc_of_pointwise C f
      (picRankOneTranslatedChart_pointwiseCoverage (C := C) hopen)
  change LocallyOfFiniteType (gluedHom C f hf)
  apply locallyOfFiniteType_gluedHom C f hf
  intro a
  rw [chartHom_picRankOneTranslatedChart]
  exact locallyOfFiniteType_divRankOneOpenOver h