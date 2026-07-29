---
author: sync
content_type: theorem
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.DivFamZar.awayMulOfDvd_toAlgHom
docstring: '**The comparison map is a map over the base ring**: composing the structure
  map

  `S → Localization.Away a` with the comparison into `Localization.Away f` gives the

  structure map `S → Localization.Away f`.  This is the form consumed when a class
  pulled

  back from `S` is compared across two different away localizations.'
file: AlgebraicJacobian/Picard/DivRepAwaySpanGlue.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivFamZar.awayMulOfDvd_toAlgHom
type: lean
updated: '2026-07-29T15:26:30'
---
theorem awayMulOfDvd_toAlgHom (f a b : S) (h : a * b = f) (x : S) :
    awayMulOfDvd (k := k) f a b h (IsScalarTower.toAlgHom k S (Localization.Away a) x)
      = IsScalarTower.toAlgHom k S (Localization.Away f) x :=
  IsLocalization.Away.lift_eq a
    (IsLocalization.Away.isUnit_of_dvd (S := Localization.Away f) (x := f) ⟨b, h.symm⟩) x

section Pack

variable {m : ℕ} (f : Fin m → S)