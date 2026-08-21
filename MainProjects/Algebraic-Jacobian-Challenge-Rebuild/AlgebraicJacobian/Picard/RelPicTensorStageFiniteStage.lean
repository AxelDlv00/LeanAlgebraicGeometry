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

end AlgebraicGeometry
