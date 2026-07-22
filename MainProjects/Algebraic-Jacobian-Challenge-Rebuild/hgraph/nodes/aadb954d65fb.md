---
author: sync
content_type: theorem
created: '2026-07-19T21:01:15'
decl: AlgebraicGeometry.subsingleton_tensorProduct_field_ext_iff
docstring: '**Base change of a module along a field extension preserves triviality**:
  for an

  `S`-module `H` and a field extension `L → L''` inside the `S`-tower, `H ⊗[S] L`
  is

  subsingleton iff `H ⊗[S] L''` is.


  Going up is `0 ⊗ = 0`; coming down is the faithful flatness of the (nonzero) field

  extension `L → L''` (`Module.FaithfullyFlat.lTensor_reflects_triviality`), read
  across the

  base-change-in-stages equivalence `(TensorProduct.AlgebraTensorModule.cancelBaseChange)`.

  **Separability is not used** — every field extension is faithfully flat.'
file: AlgebraicJacobian/Picard/Pic0ChartLocusFibreField.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.subsingleton_tensorProduct_field_ext_iff
type: lean
updated: '2026-07-19T21:31:15'
---
theorem subsingleton_tensorProduct_field_ext_iff
    {S L L' H : Type u} [CommRing S] [Field L] [Field L'] [Algebra S L] [Algebra S L']
    [Algebra L L'] [IsScalarTower S L L'] [AddCommGroup H] [Module S H] :
    Subsingleton (H ⊗[S] L) ↔ Subsingleton (H ⊗[S] L') := by
  have e := TensorProduct.AlgebraTensorModule.cancelBaseChange S L L' L' H
  rw [(TensorProduct.comm S H L).toEquiv.subsingleton_congr,
      (TensorProduct.comm S H L').toEquiv.subsingleton_congr,
      ← e.toEquiv.subsingleton_congr]
  exact ⟨fun _ => inferInstance,
    fun _ => Module.FaithfullyFlat.lTensor_reflects_triviality L L' (L ⊗[S] H)⟩

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {B : Type u} [CommRing B] [Algebra k B]
variable {π : C.left ⟶ P1 k} [IsFinite π]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

/-! ## The witness predicate as a function of the fibre field -/