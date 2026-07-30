/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.FiberH0CechKernel
import AlgebraicJacobian.Picard.RigidPushforwardInstance
import AlgebraicJacobian.Picard.RigidPushforwardP1Constants
import AlgebraicJacobian.Picard.RigidPushforwardTransfer
import AlgebraicJacobian.Picard.SemicontinuityH0
import AlgebraicJacobian.Picard.TwoTermFiniteFree
import AlgebraicJacobian.Picard.TwoTermKernelSemicontinuity

/-!
# Upper semicontinuity of fibrewise h0 for a curve

This module discharges the B5 gate for every smooth proper geometrically integral curve.
For a line bundle on the constant family over an affine base, push it forward along the
finite map to the projective line and replace the standard two-chart Cech complex by its
finite Mumford complex. Upper semicontinuity is then the kernel-rank theorem for that
finite complex; the comparison with the original Cech kernel and finite pushforward
identifies its value with the fibrewise h0 of the line bundle.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Module TensorProduct

namespace AlgebraicGeometry

noncomputable section

variable {k : Type u} [Field k]

/-- The dimension of the kernel of a base-changed linear map is unchanged when the
coefficient field algebra is replaced by an isomorphic one. -/
theorem finrank_ker_baseChange_of_algEquiv {R : Type u} [CommRing R]
    {M₀ M₁ : Type u} [AddCommGroup M₀] [Module R M₀]
    [AddCommGroup M₁] [Module R M₁]
    (d : M₀ →ₗ[R] M₁) {S T : Type u} [Field S] [Field T]
    [Algebra R S] [Algebra R T] (e : S ≃ₐ[R] T) :
    Module.finrank S (LinearMap.ker (d.baseChange S)) =
      Module.finrank T (LinearMap.ker (d.baseChange T)) := by
  let E₀ : (S ⊗[R] M₀) ≃ₗ[R] (T ⊗[R] M₀) :=
    TensorProduct.congr e.toLinearEquiv (LinearEquiv.refl R M₀)
  let E₁ : (S ⊗[R] M₁) ≃ₗ[R] (T ⊗[R] M₁) :=
    TensorProduct.congr e.toLinearEquiv (LinearEquiv.refl R M₁)
  have hsq : ∀ z : S ⊗[R] M₀,
      E₁ (d.baseChange S z) = d.baseChange T (E₀ z) := by
    intro z
    induction z using TensorProduct.induction_on with
    | zero => simp
    | add z₁ z₂ h₁ h₂ => simp only [map_add, h₁, h₂]
    | tmul s x => simp [E₀, E₁, LinearMap.baseChange_tmul]
  let j : LinearMap.ker (d.baseChange S) ≃+ LinearMap.ker (d.baseChange T) :=
    { toFun := fun x => ⟨E₀ x, by
        rw [LinearMap.mem_ker]
        rw [← hsq, x.property, map_zero]⟩
      invFun := fun y => ⟨E₀.symm y, by
        rw [LinearMap.mem_ker]
        apply E₁.injective
        rw [map_zero, hsq, E₀.apply_symm_apply]
        exact y.property⟩
      left_inv := fun x => Subtype.ext (E₀.symm_apply_apply x)
      right_inv := fun y => Subtype.ext (E₀.apply_symm_apply y)
      map_add' := fun x y => Subtype.ext
        (E₀.map_add (x : S ⊗[R] M₀) (y : S ⊗[R] M₀)) }
  refine finrank_eq_of_ringEquiv_addEquiv e.toRingEquiv j ?_
  intro s x
  apply Subtype.ext
  change E₀ (s • (x : S ⊗[R] M₀)) = e s • E₀ x
  induction (x : S ⊗[R] M₀) using TensorProduct.induction_on with
  | zero => simp
  | add z₁ z₂ h₁ h₂ => simp only [smul_add, map_add, h₁, h₂]
  | tmul s₀ m => simp [E₀, TensorProduct.smul_tmul', map_mul]

namespace Scheme

/-- Fibrewise h0 is upper semicontinuous for a smooth proper geometrically integral
curve, with no additional hypothesis on the curve or the line bundle. -/
instance instHasH0SemicontinuityOfCurve
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] : HasH0Semicontinuity C := by
  constructor
  intro A _ _ _ L hL n
  haveI : Adelic.HasFiniteMapToP1 C := inferInstance
  haveI : IsNoetherianRing A := Algebra.FiniteType.isNoetherianRing k A
  haveI : IsNoetherianRing Γ(Spec (CommRingCat.of A), ⊤) :=
    isNoetherianRing_of_ringEquiv A
      (Scheme.ΓSpecIso (CommRingCat.of A)).commRingCatIsoToRingEquiv.symm
  haveI := hL.isFinitePresentation
  let M := (Modules.pushforward (Adelic.finiteMapToP1BaseChange A C)).obj L
  haveI hMfp : M.IsFinitePresentation :=
    Adelic.pushforward_finiteMapToP1BaseChange_isFinitePresentation A C L hL
  haveI hMqc : M.IsQuasicoherent := by
    haveI : IsFinite (Adelic.finiteMapToP1BaseChange A C) :=
      Adelic.isFinite_finiteMapToP1BaseChange A C
    exact Modules.pushforward_isQuasicoherent (Adelic.finiteMapToP1BaseChange A C) L
  let p := pullback.snd (Adelic.p1Over k).hom
    (Spec.map (CommRingCat.ofHom (algebraMap k A)))
  let U := Adelic.p1BaseChangeCoverSquare (k := k) A
  letI := p.baseSectionsModule M U.U₁
  letI := p.baseSectionsModule M U.U₂
  letI := p.baseSectionsModule M (U.U₁ ⊓ U.U₂)
  have hflat : CoherentSheafFlat p M :=
    Adelic.pushforward_finiteMapToP1BaseChange_coherentSheafFlat A C L hL
  haveI hflat₁ : Module.Flat Γ(Spec (CommRingCat.of A), ⊤) Γ(M, U.U₁) :=
    flat_baseSections_of_coherentSheafFlat p M hflat U.isAffineOpen_U₁
  haveI hflat₂ : Module.Flat Γ(Spec (CommRingCat.of A), ⊤) Γ(M, U.U₂) :=
    flat_baseSections_of_coherentSheafFlat p M hflat U.isAffineOpen_U₂
  haveI hflat₀ : Module.Flat Γ(Spec (CommRingCat.of A), ⊤)
      (Γ(M, U.U₁) × Γ(M, U.U₂)) :=
    AlgebraicJacobian.TwoTerm.flat_prod
  haveI hflatΓ : Module.Flat Γ(Spec (CommRingCat.of A), ⊤) Γ(M, U.U₁ ⊓ U.U₂) :=
    flat_baseSections_of_coherentSheafFlat p M hflat U.isAffineOpen_inf
  haveI : IsIntegral (Adelic.p1Over k).left := inferInstance
  have hH₀ : (LinearMap.ker (U.moduleSectionDiffBase p M)).FG :=
    Adelic.p1Cech_h0_fg_of_isIntegral A M
  haveI hH₁ : Module.Finite Γ(Spec (CommRingCat.of A), ⊤)
      (Γ(M, U.U₁ ⊓ U.U₂) ⧸ LinearMap.range (U.moduleSectionDiffBase p M)) :=
    Adelic.module_finite_h1_p1BaseChange A M
  obtain ⟨R⟩ := AlgebraicJacobian.exists_twoTermFiniteReplacement
    (U.moduleSectionDiffBase p M) hH₀
  letI : Module.FinitePresentation Γ(Spec (CommRingCat.of A), ⊤) R.K0 :=
    Module.finitePresentation_of_projective _ _
  have hOpenR := AlgebraicJacobian.TwoTerm.isOpen_finrank_ker_baseChange_le R.n R.k n
  let B := Γ(Spec (CommRingCat.of A), ⊤)
  let ε : B ≃+* A :=
    (Scheme.ΓSpecIso (CommRingCat.of A)).commRingCatIsoToRingEquiv
  let H : PrimeSpectrum B ≃ₜ PrimeSpectrum A :=
    PrimeSpectrum.homeomorphOfRingEquiv ε
  have hdim (t : Spec (CommRingCat.of A)) :
      Module.finrank (H.symm t).asIdeal.ResidueField
          (LinearMap.ker (R.k.baseChange (H.symm t).asIdeal.ResidueField)) =
        (pullback.snd C.hom
          (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiberH0 L t := by
    let s := H.symm t
    let Kt := Γ(Spec ((Spec (CommRingCat.of A)).residueField t), ⊤)
    letI : Field Kt :=
      (MulEquiv.isField (Field.toIsField t.asIdeal.ResidueField)
        (specResidueFieldRingEquiv (CommRingCat.of A) t).symm.toMulEquiv).toField
    letI : Algebra B Kt :=
      (((Spec (CommRingCat.of A)).fromSpecResidueField t).appLE ⊤ ⊤ le_top).hom.toAlgebra
    let hs : s.asIdeal = Ideal.comap ε.toRingHom t.asIdeal := rfl
    let κme := Ideal.ResidueField.map s.asIdeal t.asIdeal ε.toRingHom hs
    have hκme : Function.Bijective κme :=
      (RingEquiv.surjectiveOnStalks ε).residueFieldMap_bijective
        s.asIdeal t.asIdeal hs
    let κe := RingEquiv.ofBijective κme hκme
    let τ := κe.trans (specResidueFieldRingEquiv (CommRingCat.of A) t)
    let τAlg : s.asIdeal.ResidueField ≃ₐ[B] Kt :=
      AlgEquiv.ofRingEquiv fun b => by
        change τ ((algebraMap B s.asIdeal.ResidueField) b) = _
        change specResidueFieldRingEquiv (CommRingCat.of A) t
          (κme ((algebraMap B s.asIdeal.ResidueField) b)) = _
        rw [Ideal.ResidueField.map_algebraMap]
        exact (appLE_fromSpecResidueField_apply (CommRingCat.of A) t b).symm
    have htransport := finrank_ker_baseChange_of_algEquiv R.k τAlg
    let d := U.moduleSectionDiffBase p M
    let h₀map := AlgebraicJacobian.TwoTerm.h0Map
      (R.k.baseChange Kt) (d.baseChange Kt) (R.a0.baseChange Kt)
      (R.a1.baseChange Kt)
      (AlgebraicJacobian.TwoTerm.baseChange_square
        R.k d R.a0 R.a1 Kt R.comm)
    have hreplacement :
        Module.finrank Kt (LinearMap.ker (R.k.baseChange Kt)) =
          Module.finrank Kt (LinearMap.ker (d.baseChange Kt)) :=
      LinearEquiv.finrank_eq
        (LinearEquiv.ofBijective h₀map (R.h0_bijective Kt))
    have hcech := finrank_ker_moduleSectionDiffBase_baseChange_eq_fiberH0
      p U M t
    have hpush := Adelic.pushforward_finiteMapToP1BaseChange_fiberH0 A C L t hL
    exact htransport.trans (hreplacement.trans (hcech.trans hpush))
  rw [show {t : Spec (CommRingCat.of A) |
      (pullback.snd C.hom
        (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiberH0 L t ≤ n} =
      H.symm ⁻¹' {s : PrimeSpectrum B |
        Module.finrank s.asIdeal.ResidueField
          (LinearMap.ker (R.k.baseChange s.asIdeal.ResidueField)) ≤ n} by
    ext t
    change (pullback.snd C.hom
        (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiberH0 L t ≤ n ↔
      Module.finrank (H.symm t).asIdeal.ResidueField
        (LinearMap.ker (R.k.baseChange (H.symm t).asIdeal.ResidueField)) ≤ n
    rw [hdim t]]
  exact H.symm.continuous.isOpen_preimage _ hOpenR

end Scheme

end

end AlgebraicGeometry
