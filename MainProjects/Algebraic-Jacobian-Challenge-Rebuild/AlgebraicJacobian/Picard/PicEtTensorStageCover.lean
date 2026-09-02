/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Picard.PicEtFiniteStageCover
import AlgebraicJacobian.Picard.TensorFiniteSubextension
import AlgebraicJacobian.Descent.IsomorphismFieldTowerDescent
import Mathlib.RingTheory.Flat.FaithfullyFlat.Descent

set_option autoImplicit false

universe u

open scoped TensorProduct

namespace AlgebraicGeometry.DatG0

noncomputable section

set_option synthInstance.maxHeartbeats 100000 in
-- The dependent tensor signature needs a deeper search than the project default.
set_option maxSynthPendingDepth 16 in
/-- The canonical square from a finite tensor stage to the full tensor product is a
pushout square. -/
theorem tensorStageMap_isPushout
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : FinSubext F K) :
    let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
      Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
    letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
      iota.toRingHom.toAlgebra
    letI : IsScalarTower M.1 (M.1 ⊗[F] B) (K ⊗[F] B) :=
      @IsScalarTower.of_algebraMap_eq M.1 (M.1 ⊗[F] B) (K ⊗[F] B)
        inferInstance inferInstance inferInstance inferInstance inferInstance inferInstance
        (fun a => by
          change (a : K) ⊗ₜ[F] (1 : B) = iota (a ⊗ₜ[F] (1 : B))
          simp [iota])
    Algebra.IsPushout M.1 K (M.1 ⊗[F] B) (K ⊗[F] B) := by
  dsimp only
  let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
    iota.toRingHom.toAlgebra
  haveI : IsScalarTower M.1 (M.1 ⊗[F] B) (K ⊗[F] B) :=
    @IsScalarTower.of_algebraMap_eq M.1 (M.1 ⊗[F] B) (K ⊗[F] B)
      inferInstance inferInstance inferInstance inferInstance inferInstance inferInstance
      (fun a => by
        change (a : K) ⊗ₜ[F] (1 : B) = iota (a ⊗ₜ[F] (1 : B))
        simp [iota])
  let cancel := Algebra.TensorProduct.cancelBaseChange F M.1 K K B
  exact
    ⟨IsBaseChange.of_equiv cancel.toLinearEquiv fun x => by
      induction x using TensorProduct.induction_on with
      | zero => simp
      | tmul m b =>
          change cancel (1 ⊗ₜ[M.1] (m ⊗ₜ[F] b)) = iota (m ⊗ₜ[F] b)
          rw [show cancel = Algebra.TensorProduct.cancelBaseChange F M.1 K K B from rfl,
            Algebra.TensorProduct.cancelBaseChange_tmul]
          simp [iota, Algebra.smul_def]
      | add x y hx hy =>
          simpa only [TensorProduct.tmul_add, map_add] using
            congrArg₂ (fun a b => a + b) hx hy⟩

/-- The canonical map from a finite tensor stage is faithfully flat. -/
theorem tensorStageMap_faithfullyFlat
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : FinSubext F K) :
    let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
      Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
    letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
      iota.toRingHom.toAlgebra
    Module.FaithfullyFlat (M.1 ⊗[F] B) (K ⊗[F] B) := by
  dsimp only
  let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
    iota.toRingHom.toAlgebra
  haveI : IsScalarTower M.1 (M.1 ⊗[F] B) (K ⊗[F] B) :=
    @IsScalarTower.of_algebraMap_eq M.1 (M.1 ⊗[F] B) (K ⊗[F] B)
      inferInstance inferInstance inferInstance inferInstance inferInstance inferInstance
      (fun a => by
        change (a : K) ⊗ₜ[F] (1 : B) = iota (a ⊗ₜ[F] (1 : B))
        simp [iota])
  letI : Algebra.IsPushout M.1 K (M.1 ⊗[F] B) (K ⊗[F] B) :=
    tensorStageMap_isPushout (B := B) M
  rw [← RingHom.faithfullyFlat_algebraMap_iff]
  apply RingHom.FaithfullyFlat.isStableUnderBaseChange M.1 K
    (M.1 ⊗[F] B) (K ⊗[F] B)
  rw [RingHom.faithfullyFlat_algebraMap_iff]
  infer_instance

/-- Surjectivity on prime spectra descends across a commuting pair of algebra towers. -/
theorem comap_surjective_of_tower
    {R S T U : Type u} [CommRing R] [CommRing S] [CommRing T] [CommRing U]
    [Algebra R S] [Algebra R T] [Algebra R U] [Algebra S U] [Algebra T U]
    [IsScalarTower R S U] [IsScalarTower R T U]
    (hRS : Function.Surjective
      (PrimeSpectrum.comap (algebraMap R S)))
    (hSU : Function.Surjective
      (PrimeSpectrum.comap (algebraMap S U))) :
    Function.Surjective (PrimeSpectrum.comap (algebraMap R T)) := by
  intro p
  obtain ⟨q, hq⟩ := hRS p
  obtain ⟨r, hr⟩ := hSU q
  refine ⟨PrimeSpectrum.comap (algebraMap T U) r, ?_⟩
  rw [← PrimeSpectrum.comap_comp_apply,
    ← IsScalarTower.algebraMap_eq R T U,
    IsScalarTower.algebraMap_eq R S U,
    PrimeSpectrum.comap_comp_apply, hr, hq]

set_option maxHeartbeats 800000 in
-- Reassociating the three tensor products is expensive for the elaborator.
set_option synthInstance.maxHeartbeats 100000 in
-- The nested tensor aliases require a deeper instance search than the project default.
set_option maxSynthPendingDepth 16 in
/-- A presented etale cover over `K ⊗[F] B` descends to a finite tensor stage.

The algebra structure used by `baseChange` is induced by the canonical tensor map
`M ⊗[F] B → K ⊗[F] B`. -/
theorem exists_finSubext_etaleCover_tensorStage
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (E : Algebra.EtaleCover (K ⊗[F] B)) :
    ∃ M : FinSubext F K,
      let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
        Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
      letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
        iota.toRingHom.toAlgebra
      ∃ E₀ : Algebra.EtaleCover (M.1 ⊗[F] B),
        Nonempty
          ((E₀.baseChange (K ⊗[F] B)).Carrier ≃ₐ[K ⊗[F] B] E.Carrier) := by
  obtain ⟨A₀, B₀, _, _, hA₀, hB₀, ⟨e⟩⟩ :=
    Algebra.Etale.exists_subalgebra_fg F (K ⊗[F] B) E.Carrier
  obtain ⟨M, f, hfactor⟩ :=
    exists_finSubext_fg_subalgebra_tensorProduct_factor A₀ hA₀
  letI : Algebra F (M.1 ⊗[F] B) := Algebra.TensorProduct.instAlgebra
  let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI algebraA₀R : Algebra A₀ (M.1 ⊗[F] B) :=
    f.toRingHom.toAlgebra' (by
      intro c x
      exact mul_comm (f.toRingHom c) x)
  letI moduleA₀R : Module A₀ (M.1 ⊗[F] B) :=
    @Algebra.toModule A₀ (M.1 ⊗[F] B) _ _ algebraA₀R
  letI : IsScalarTower F A₀ (M.1 ⊗[F] B) :=
    IsScalarTower.of_algebraMap_eq fun x => (f.commutes x).symm
  letI algebraRA : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
    iota.toRingHom.toAlgebra
  letI moduleRA : Module (M.1 ⊗[F] B) (K ⊗[F] B) :=
    @Algebra.toModule (M.1 ⊗[F] B) (K ⊗[F] B) _ _ algebraRA
  letI : IsScalarTower F (M.1 ⊗[F] B) (K ⊗[F] B) :=
    @IsScalarTower.of_algebraMap_eq F (M.1 ⊗[F] B) (K ⊗[F] B)
      inferInstance inferInstance inferInstance inferInstance inferInstance inferInstance
      (fun x => (iota.commutes x).symm)
  letI : IsScalarTower A₀ (M.1 ⊗[F] B) (K ⊗[F] B) :=
    @IsScalarTower.of_algebraMap_eq A₀ (M.1 ⊗[F] B) (K ⊗[F] B)
      inferInstance inferInstance inferInstance inferInstance inferInstance inferInstance
      (fun a => by
        change a.1 = iota (f a)
        exact congrArg (fun g : A₀ →ₐ[F] K ⊗[F] B => g a) hfactor.symm)
  refine ⟨M, ?_⟩
  dsimp only
  let R := M.1 ⊗[F] B
  let A := K ⊗[F] B
  let C₀ := R ⊗[A₀] B₀
  haveI hC₀ : Algebra.Etale R C₀ :=
    Algebra.Etale.baseChange A₀ B₀ R
  let U := A ⊗[R] C₀
  letI algebraC₀U : Algebra C₀ U := Algebra.TensorProduct.rightAlgebra
  let cancel : U ≃ₐ[A] A ⊗[A₀] B₀ :=
    Algebra.TensorProduct.cancelBaseChange A₀ R A A B₀
  let comparison : U ≃ₐ[A] E.Carrier := cancel.trans e.symm
  have hRA : Function.Surjective
      (PrimeSpectrum.comap (algebraMap R A)) := by
    haveI : Module.FaithfullyFlat R A :=
      tensorStageMap_faithfullyFlat (B := B) M
    exact PrimeSpectrum.comap_surjective_of_faithfullyFlat
  have hAU : Function.Surjective
      (PrimeSpectrum.comap (algebraMap A U)) := by
    intro p
    obtain ⟨q, hq⟩ := E.comap_surjective p
    refine ⟨PrimeSpectrum.comap comparison.toRingHom q, ?_⟩
    rw [← PrimeSpectrum.comap_comp_apply]
    have hcomp : comparison.toRingHom.comp (algebraMap A U) =
        algebraMap A E.Carrier := by
      apply DFunLike.ext _ _
      intro a
      exact comparison.commutes a
    rw [hcomp, hq]
  have hRC₀ : Function.Surjective
      (PrimeSpectrum.comap (algebraMap R C₀)) :=
    comap_surjective_of_tower
      (R := R) (S := A) (T := C₀) (U := U) hRA hAU
  let E₀ : Algebra.EtaleCover R := Algebra.EtaleCover.of C₀ hRC₀
  let e₀ : E₀.Carrier ≃ₐ[R] C₀ :=
    Algebra.EtaleCover.ofEquiv C₀ hRC₀
  let coverEquiv :
      (E₀.baseChange A).Carrier ≃ₐ[A] E.Carrier :=
    (E₀.baseChangeEquiv A).trans
      ((Algebra.TensorProduct.congr
        (AlgEquiv.refl : A ≃ₐ[A] A) e₀).trans comparison)
  exact ⟨E₀, ⟨coverEquiv⟩⟩

end

end AlgebraicGeometry.DatG0
