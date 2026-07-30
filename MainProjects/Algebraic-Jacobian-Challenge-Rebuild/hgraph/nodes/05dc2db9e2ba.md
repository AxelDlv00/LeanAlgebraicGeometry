---
author: sync
content_type: theorem
created: '2026-07-30T00:56:03'
decl: AlgebraicGeometry.abelDivAffPlus_toAff
docstring: '**The widened hook extends the chart-typed one along `DivFamZar.toAff`**:
  the widened Abel

  value of the image of a chart-typed class is the chart-typed Abel value.


  This is what makes the file an *extension* of `Picard/DivSchemeAbel.lean` rather
  than a second,

  incompatible Abel layer: `DivFamZarAff.picClass_toAff` says the widening does not
  move the

  Picard class, and both hooks are `unit ∘ relPicMk` of that class.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffAbel.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.abelDivAffPlus_toAff
type: lean
updated: '2026-07-30T15:27:56'
---
theorem abelDivAffPlus_toAff {A : Type u} [CommRing A] [Algebra k A]
    {π : C.left ⟶ P1 k} [IsAffineHom π] (F₀ : DivFamZar C A π n) :
    abelDivAffPlus C A F₀.toAff = abelDivPlus C π A F₀ := by
  rw [abelDivAffPlus, abelDivPlus, DivFamZarAff.picClass_toAff]

end AbelAff

/-! ## The widened Abel transformation at an arbitrary test -/

section AbelVehicle

/- `picEtMap` (`Picard/PicEtMap.lean:206-207`) carries these two beyond `[IsProper C.hom]`; they
are hypotheses of the whole DD-R lane, so this costs no generality, but they are stated rather
than inherited silently. -/
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

variable (C n) in