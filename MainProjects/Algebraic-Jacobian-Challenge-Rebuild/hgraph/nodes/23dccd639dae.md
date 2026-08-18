---
author: sync
content_type: theorem
created: '2026-08-16T20:15:44'
decl: AlgebraicGeometry.DatG0.exists_finSubext_tensorProduct_algHom_finite
docstring: 'A finite family of algebra maps between base changes of `F`-algebras descends
  to one

  common finite subextension of `K/F` when every source algebra is of finite type.'
file: AlgebraicJacobian/Picard/FinitePresentationAlgebraMapFiniteStage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DatG0.exists_finSubext_tensorProduct_algHom_finite
type: lean
updated: '2026-08-18T20:51:03'
---
theorem exists_finSubext_tensorProduct_algHom_finite
    {F K : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] {ι : Type*} [Finite ι]
    (A B : ι → Type u) [∀ i, CommRing (A i)] [∀ i, Algebra F (A i)]
    [∀ i, Algebra.FiniteType F (A i)]
    [∀ i, CommRing (B i)] [∀ i, Algebra F (B i)]
    (phi : ∀ i, K ⊗[F] A i →ₐ[K] K ⊗[F] B i) :
    ∃ L : FinSubext F K, ∀ i,
      ∃ phiL : L.1 ⊗[F] A i →ₐ[L.1] L.1 ⊗[F] B i,
        (Algebra.TensorProduct.map L.1.val (AlgHom.id F (B i))).comp
            (phiL.restrictScalars F) =
          ((phi i).restrictScalars F).comp
            (Algebra.TensorProduct.map L.1.val (AlgHom.id F (A i))) := by
  classical
  letI := Fintype.ofFinite ι
  choose Li phiLi hphiLi using fun i =>
    exists_finSubext_tensorProduct_algHom (phi i)
  let A0i (i : ι) : Subalgebra F K := (Li i).1.toSubalgebra
  have hA0i (i : ι) : (A0i i).FG := by
    rw [Subalgebra.fg_iff_finiteType]
    change Algebra.FiniteType F (Li i).1
    infer_instance
  let A0 : Subalgebra F K := Finset.univ.sup A0i
  have hA0 : A0.FG := by
    dsimp only [A0]
    induction (Finset.univ : Finset ι) using Finset.induction_on with
    | empty => simpa using (Subalgebra.fg_bot : (⊥ : Subalgebra F K).FG)
    | @insert i s hi hs =>
        simpa [Finset.sup_insert] using (hA0i i).sup hs
  have hA0iA0 : ∀ i, A0i i ≤ A0 := fun i =>
    Finset.le_sup (s := Finset.univ) (f := A0i) (Finset.mem_univ i)
  letI : Algebra.IsAlgebraic F A0 :=
    Algebra.IsAlgebraic.of_injective A0.val Subtype.val_injective
  let L0 : IntermediateField F K := Algebra.IsAlgebraic.toIntermediateField A0
  letI : Algebra.FiniteType F L0 := by
    change Algebra.FiniteType F A0
    exact (Subalgebra.fg_iff_finiteType A0).mp hA0
  letI : Module.Finite F L0 := Algebra.finite_of_essFiniteType_of_isAlgebraic
  let L : FinSubext F K := ⟨L0, inferInstance⟩
  refine ⟨L, ?_⟩
  intro i
  have hLiL : (Li i).1 ≤ L.1 := hA0iA0 i
  let inc : (Li i).1 →ₐ[F] L.1 := IntermediateField.inclusion hLiL
  let fL : A i →ₐ[F] L.1 ⊗[F] B i :=
    (Algebra.TensorProduct.map inc (AlgHom.id F (B i))).comp
      ((phiLi i).restrictScalars F |>.comp
        (Algebra.TensorProduct.includeRight (R := F) (A := (Li i).1) (B := A i)))
  let phiL : L.1 ⊗[F] A i →ₐ[L.1] L.1 ⊗[F] B i :=
    AlgHom.liftEquiv F L.1 (A i) (L.1 ⊗[F] B i) fL
  have hmap :
      (Algebra.TensorProduct.map L.1.val (AlgHom.id F (B i))).comp
          (Algebra.TensorProduct.map inc (AlgHom.id F (B i))) =
        Algebra.TensorProduct.map (Li i).1.val (AlgHom.id F (B i)) := by
    ext x <;> rfl
  refine ⟨phiL, ?_⟩
  ext x
  · change (Algebra.TensorProduct.map L.1.val (AlgHom.id F (B i)))
        (phiL (Algebra.TensorProduct.includeLeft (R := F) (S := L.1)
          (A := L.1) (B := A i) x)) =
      phi i ((Algebra.TensorProduct.map L.1.val (AlgHom.id F (A i)))
        (Algebra.TensorProduct.includeLeft (R := F) (S := L.1)
          (A := L.1) (B := A i) x))
    simp only [Algebra.TensorProduct.includeLeft_apply, phiL, AlgHom.liftEquiv_tmul,
      Algebra.TensorProduct.map_tmul, map_one]
    simpa [Algebra.smul_def] using ((phi i).commutes (x : K)).symm
  · change (Algebra.TensorProduct.map L.1.val (AlgHom.id F (B i)))
        (phiL (Algebra.TensorProduct.includeRight (R := F) (A := L.1) (B := A i) x)) =
      phi i ((Algebra.TensorProduct.map L.1.val (AlgHom.id F (A i)))
        (Algebra.TensorProduct.includeRight (R := F) (A := L.1) (B := A i) x))
    simp only [Algebra.TensorProduct.includeRight_apply, phiL, AlgHom.liftEquiv_tmul,
      Algebra.TensorProduct.map_tmul, AlgHom.id_apply, map_one, one_smul, fL,
      AlgHom.comp_apply]
    rw [← AlgHom.comp_apply, hmap]
    exact DFunLike.congr_fun (hphiLi i)
      (Algebra.TensorProduct.includeRight (R := F) (A := (Li i).1) (B := A i) x)