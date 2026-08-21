/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageDatum
import AlgebraicJacobian.Picard.RelPicPi
import AlgebraicJacobian.Cohomology.GluedSheafExtraction

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory MonoidalCategory
open scoped TensorProduct

namespace AlgebraicGeometry

theorem exists_finSubext_relPic_tensorStage
    {F K B : Type u} [Field F] [Field K] [Algebra F K] [Algebra.IsAlgebraic F K]
    [CommRing B] [Algebra F B]
    {C : Over (Spec (.of F))} {pi : C.left ⟶ P1 F} [IsAffineHom pi]
    (q : relPic C (overSpec F (K ⊗[F] B))) :
    ∃ M : DatG0.FinSubext F K,
      letI : Algebra F (M.1 ⊗[F] B) := Algebra.TensorProduct.instAlgebra
      let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
        Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
      letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) := iota.toAlgebra
      letI : IsScalarTower F (M.1 ⊗[F] B) (K ⊗[F] B) :=
        @IsScalarTower.of_algebraMap_eq F _ _ inferInstance inferInstance inferInstance
          inferInstance inferInstance inferInstance (fun x => (iota.commutes x).symm)
      ∃ qM : relPic C (overSpec F (M.1 ⊗[F] B)),
        relPicAlgMap C iota qM = q := by
  obtain ⟨c, hc⟩ := relPicMk_surjective C (overSpec F (K ⊗[F] B)) q
  obtain ⟨D, hD⟩ := BasicOpenCocycleDatum.exists_cechPicClass_eq (π := pi) c
  obtain ⟨M, DM, hDM⟩ := D.exists_finSubext_tensorStage
  refine ⟨M, ?_⟩
  dsimp only
  let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) := iota.toAlgebra
  letI : IsScalarTower F (M.1 ⊗[F] B) (K ⊗[F] B) :=
    @IsScalarTower.of_algebraMap_eq F (M.1 ⊗[F] B) (K ⊗[F] B)
      inferInstance inferInstance inferInstance inferInstance inferInstance inferInstance
      (fun x => (iota.commutes x).symm)
  refine ⟨relPicMk C (overSpec F (M.1 ⊗[F] B)) DM.cechPicClass, ?_⟩
  rw [relPicAlgMap_mk]
  have hcurve : (C ◁ Over.overSpecMap iota).left =
      relCurveMap C (M.1 ⊗[F] B) (K ⊗[F] B) := by
    refine congrArg (fun g : overSpec F (K ⊗[F] B) ⟶
      overSpec F (M.1 ⊗[F] B) => (C ◁ g).left) ?_
    exact Over.OverMorphism.ext rfl
  rw [hcurve]
  have hclass := (DM.cechPicClass_baseChange (B' := K ⊗[F] B)).symm
  rw [hDM, hD] at hclass
  exact (congrArg (relPicMk C (overSpec F (K ⊗[F] B))) hclass).trans hc

theorem exists_finSubext_relPic_tensorStage_finite
    {F K : Type u} [Field F] [Field K] [Algebra F K] [Algebra.IsAlgebraic F K]
    {ι : Type*} [Finite ι]
    {B : ι → Type u} [∀ i, CommRing (B i)] [∀ i, Algebra F (B i)]
    {C : Over (Spec (.of F))} {pi : C.left ⟶ P1 F} [IsAffineHom pi]
    (q : ∀ i, relPic C (overSpec F (K ⊗[F] B i))) :
    ∃ M : DatG0.FinSubext F K,
      ∀ i,
        letI : Algebra F (M.1 ⊗[F] B i) := Algebra.TensorProduct.instAlgebra
        let iota : M.1 ⊗[F] B i →ₐ[F] K ⊗[F] B i :=
          Algebra.TensorProduct.map M.1.val (AlgHom.id F (B i))
        letI : Algebra (M.1 ⊗[F] B i) (K ⊗[F] B i) := iota.toAlgebra
        letI : IsScalarTower F (M.1 ⊗[F] B i) (K ⊗[F] B i) :=
          @IsScalarTower.of_algebraMap_eq F _ _ inferInstance inferInstance inferInstance
            inferInstance inferInstance inferInstance (fun x => (iota.commutes x).symm)
        ∃ qM : relPic C (overSpec F (M.1 ⊗[F] B i)),
          relPicAlgMap C iota qM = q i := by
  classical
  letI := Fintype.ofFinite ι
  choose M hM using fun i => exists_finSubext_relPic_tensorStage (q i)
  have hupper_aux : ∀ s : Finset ι,
      ∃ N : DatG0.FinSubext F K, ∀ i ∈ s, M i ≤ N := by
    intro s
    induction s using Finset.induction_on with
    | empty =>
        exact ⟨Classical.choice (inferInstance : Nonempty (DatG0.FinSubext F K)), by
          simp⟩
    | @insert i s hi hs ih =>
        obtain ⟨N, hN⟩ := ih
        obtain ⟨N', hNN', hiN'⟩ := DatG0.directed_finSubext N (M i)
        refine ⟨N', ?_⟩
        intro j hj
        by_cases hj' : j = i
        · simpa [hj'] using hiN'
        · exact (hN j (by simp [hj, hj'])).trans hNN'
  obtain ⟨N, hMN⟩ := hupper_aux Finset.univ
  refine ⟨N, ?_⟩
  intro i
  dsimp only at hM
  obtain ⟨qMi, hqi⟩ := hM i
  letI : Algebra F (M i).1 := (M i).1.toAlgebra
  letI : Algebra F (N.1) := N.1.toAlgebra
  letI : Algebra F ((M i).1 ⊗[F] B i) := Algebra.TensorProduct.instAlgebra
  letI : Algebra F (N.1 ⊗[F] B i) := Algebra.TensorProduct.instAlgebra
  have hMiN : (M i).1 ≤ N.1 := hMN i (Finset.mem_univ i)
  let j : (M i).1 ⊗[F] B i →ₐ[F] N.1 ⊗[F] B i :=
    Algebra.TensorProduct.map (IntermediateField.inclusion hMiN) (AlgHom.id F (B i))
  let iotaN : N.1 ⊗[F] B i →ₐ[F] K ⊗[F] B i :=
    Algebra.TensorProduct.map N.1.val (AlgHom.id F (B i))
  let iotaM : (M i).1 ⊗[F] B i →ₐ[F] K ⊗[F] B i :=
    Algebra.TensorProduct.map (M i).1.val (AlgHom.id F (B i))
  letI : Algebra ((M i).1 ⊗[F] B i) (N.1 ⊗[F] B i) := j.toAlgebra
  letI : Algebra (N.1 ⊗[F] B i) (K ⊗[F] B i) := iotaN.toAlgebra
  letI : IsScalarTower F ((M i).1 ⊗[F] B i) (N.1 ⊗[F] B i) :=
    @IsScalarTower.of_algebraMap_eq F _ _ inferInstance inferInstance inferInstance
      inferInstance inferInstance inferInstance (fun x => (j.commutes x).symm)
  letI : IsScalarTower F (N.1 ⊗[F] B i) (K ⊗[F] B i) :=
    @IsScalarTower.of_algebraMap_eq F _ _ inferInstance inferInstance inferInstance
      inferInstance inferInstance inferInstance (fun x => (iotaN.commutes x).symm)
  have hcomp : iotaN.comp j = iotaM := by
    ext x <;> rfl
  refine ⟨relPicAlgMap C j qMi, ?_⟩
  change relPicAlgMap C iotaN (relPicAlgMap C j qMi) = q i
  rw [← relPicAlgMap_comp, hcomp, hqi]

end AlgebraicGeometry
