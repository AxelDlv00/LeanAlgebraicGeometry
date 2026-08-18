---
author: sync
content_type: theorem
created: '2026-08-16T18:12:53'
decl: AlgebraicGeometry.DatG0.exists_finSubext_tensorProduct_eq
docstring: 'If two tensors over a finite subextension become equal over `K`, they
  are already equal

  after passage to some larger finite subextension.'
file: AlgebraicJacobian/Picard/TensorFiniteSubextension.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DatG0.exists_finSubext_tensorProduct_eq
type: lean
updated: '2026-08-18T20:51:07'
---
theorem exists_finSubext_tensorProduct_eq
    {F K B : Type u} [Field F] [Field K] [Algebra F K] [Algebra.IsAlgebraic F K]
    [CommRing B] [Algebra F B] (L : FinSubext F K) (x y : L.1 ⊗[F] B)
    (hxy : LinearMap.rTensor B L.1.val.toLinearMap x =
      LinearMap.rTensor B L.1.val.toLinearMap y) :
    ∃ M : FinSubext F K, ∃ hLM : L.1 ≤ M.1,
      LinearMap.rTensor B (IntermediateField.inclusion hLM).toLinearMap x =
        LinearMap.rTensor B (IntermediateField.inclusion hLM).toLinearMap y := by
  have hLfg : L.1.toSubalgebra.FG := by
    rw [Subalgebra.fg_iff_finiteType]
    change Algebra.FiniteType F L.1
    infer_instance
  obtain ⟨A, hLA, hA, hxyA⟩ :=
    TensorProduct.Algebra.eq_of_fg_of_subtype_eq hLfg hxy
  letI : Algebra.IsAlgebraic F A :=
    Algebra.IsAlgebraic.of_injective A.val Subtype.val_injective
  let M0 : IntermediateField F K := Algebra.IsAlgebraic.toIntermediateField A
  letI : Algebra.FiniteType F M0 := by
    change Algebra.FiniteType F A
    exact (Subalgebra.fg_iff_finiteType A).mp hA
  letI : Module.Finite F M0 := Algebra.finite_of_essFiniteType_of_isAlgebraic
  let M : FinSubext F K := ⟨M0, inferInstance⟩
  have hLM : L.1 ≤ M.1 := hLA
  exact ⟨M, hLM, hxyA⟩