---
author: sync
content_type: theorem
created: '2026-07-31T16:07:32'
decl: AlgebraicGeometry.relPicToPicEt_injective
docstring: '**(C1) étale separatedness, functor level**: the unit component `relPicToPicEt`
  is

  injective on **every** affine test — unconditional, exactly as `PicEtAff.unit_injective`

  is.  It is the affine comparison composed with the injective plus-construction unit.'
file: AlgebraicJacobian/Picard/PicEtUnitFieldComparison.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relPicToPicEt_injective
type: lean
updated: '2026-08-01T09:44:16'
---
theorem relPicToPicEt_injective (A : Type u) [CommRing A] [Algebra k A] :
    Function.Injective (relPicToPicEt C (overSpec k A)) := fun x y h => by
  apply PicEtAff.unit_injective C A
  rw [← picEtAffineEquiv_relPicToPicEt C A x, ← picEtAffineEquiv_relPicToPicEt C A y, h]

end injective

/-! ## (C1)+(C2) at the functor level: the field-point isomorphism -/

section field

variable (K : Type u) [Field K] [Algebra k K]
variable [IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]