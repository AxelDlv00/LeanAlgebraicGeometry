---
author: sync
content_type: instance
created: '2026-07-30T12:49:24'
decl: AlgebraicGeometry.instSubsingletonDivFamZarZero
docstring: '**And so does the functor carrier `DivFamZar C K π 0`.**  Over a field
  `toZar` is surjective

  (`DivFam.exists_toZar_eq`), so the subsingleton transports from the globally certified
  quotient

  to the locally certified one — which is the type `divFunctor C π 0` actually takes
  as its value

  at `Spec K`.'
file: AlgebraicJacobian/Picard/DivisorFamilyDegreeZeroUnique.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.instSubsingletonDivFamZarZero
type: lean
updated: '2026-07-30T15:28:04'
---
instance instSubsingletonDivFamZarZero : Subsingleton (DivFamZar C K pi 0) := by
  refine ⟨fun x y => ?_⟩
  obtain ⟨G, hG⟩ := DivFam.exists_toZar_eq (C := C) (K := K) (π := pi) (n := 0) x
  obtain ⟨H, hH⟩ := DivFam.exists_toZar_eq (C := C) (K := K) (π := pi) (n := 0) y
  rw [← hG, ← hH, Subsingleton.elim G H]