---
author: sync
content_type: theorem
created: '2026-07-30T16:21:06'
decl: AlgebraicGeometry.Scheme.PicSharp.kernelClass_divFamilyZero
docstring: '**The ideal sheaf of the empty divisor is the structure sheaf**, as a
  class in the

  relative Picard group: `[I_∅] = [O] = 0`.


  `ker (0 : O_{X_T} ⟶ 0) ≅ O_{X_T}` by `kernelZeroIsoSource`, then

  `Modules.pullbackUnitIso` identifies `DivFamily.q`''s pulled-back-unit source with
  the

  structure sheaf, and the zero of `relPresheaf` *is* the unit class.'
file: AlgebraicJacobian/Picard/DivFamilyZeroAbel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicSharp.kernelClass_divFamilyZero
type: lean
updated: '2026-07-30T16:21:06'
---
theorem PicSharp.kernelClass_divFamilyZero (T : (Over (Spec (CommRingCat.of k)))ᵒᵖ) :
    (Quotient.mk (PicSharp.relPicSetoid C.hom T.unop.hom)
      (⟨kernel (DivFamily.zero C.hom T.unop).q,
        (DivFamily.zero C.hom T.unop).kerLocallyTrivial⟩ :
        LineBundle.OnProduct C.hom T.unop.hom))
      = (0 : (PicSharp.relPresheaf C).obj T) :=
  Quotient.sound (PicSharp.relPicRel_of_iso
    ⟨Limits.kernelZeroIsoSource ≪≫ Scheme.Modules.pullbackUnitIso _⟩)

variable [GeometricallyIntegral C.hom]