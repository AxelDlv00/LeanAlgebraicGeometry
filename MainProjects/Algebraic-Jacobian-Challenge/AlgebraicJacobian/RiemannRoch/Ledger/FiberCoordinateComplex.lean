/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.RiemannRoch.Ledger.FiberCoordinateLattice
import AlgebraicJacobian.RiemannRoch.Ledger.DivisorSheafQcoh
import AlgebraicJacobian.RiemannRoch.Ledger.TwoCover
import AlgebraicJacobian.RiemannRoch.Ledger.SectionsFieldBaseChange
import AlgebraicJacobian.Picard.TwoTermFiniteFree

/-!
# The two-chart complex of a source-side fiber divisor

For source coordinate data `Q` and `E = n • Q.coordinateWeilDivisor`, the divisor-sheaf
Mayer--Vietoris complex on `Q.V₀, Q.V₁` is conjugate to the complex of structure sections

`coordinateDiff Q n (a, b) = yⁿ a|₀₁ - b|₀₁`.

This normalization is intrinsic to the source.  In particular it commutes with arbitrary field
extension because restriction and the pulled-back coordinate `y` do.  The comparison below is
the cohomological bridge needed to transport the genus twist without identifying projective-line
models after base change.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory Limits Opposite TopologicalSpace TensorProduct

namespace AlgebraicGeometry

open Scheme

attribute [local instance] Scheme.functionFieldOverModule Scheme.overModule

namespace FiberCoordinateData

variable {K : Type u} [Field K] {Y : Scheme.{u}} [IsIntegral Y]
  [Y.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (Y ↘ Spec (CommRingCat.of K))]
  [LocallyOfFiniteType (Y ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (Y ↘ Spec (CommRingCat.of K))]
  (Q : FiberCoordinateData Y)

/-! ## Term comparisons -/

/-- Regular sections are linearly equivalent to sections of the zero divisor sheaf. -/
noncomputable def divisorZeroSectionsEquiv (U : Y.Opens) :
    Γ(Y, U) ≃ₗ[K] divisorSections K 0 U :=
  LinearEquiv.ofBijective (moduleToDivisorZeroPresheafApp K U)
    (moduleToDivisorZeroPresheafApp_bijective K U)

/-- The normalized chart-zero comparison.  A regular section is first viewed in `𝒪(0)` and
then multiplied by the inverse `n`th power of the coordinate unit. -/
noncomputable def coordinateSectionsEquivV0 (n : ℕ) :
    Γ(Y, Q.V₀) ≃ₗ[K]
      divisorSections K (n • Q.coordinateWeilDivisor (K := K)) Q.V₀ :=
  (divisorZeroSectionsEquiv (K := K) Q.V₀).trans
    ((LinearEquiv.submoduleMap (mulByUnit K (Q.coordinateUnit⁻¹ ^ n))
      (divisorSections K 0 Q.V₀)).trans
        (LinearEquiv.ofEq _ _ (by
          simpa only [zero_add] using
            (Q.divisorSections_add_nsmul_coordinateWeilDivisor_V0
              (K := K) (0 : Y.CurveDivisor) n).symm)))

/-- The normalized chart-one comparison; the coordinate divisor vanishes on this chart. -/
noncomputable def coordinateSectionsEquivV1 (n : ℕ) :
    Γ(Y, Q.V₁) ≃ₗ[K]
      divisorSections K (n • Q.coordinateWeilDivisor (K := K)) Q.V₁ :=
  (divisorZeroSectionsEquiv (K := K) Q.V₁).trans
    (LinearEquiv.ofEq _ _ (by
      simpa only [zero_add] using
        (Q.divisorSections_add_nsmul_coordinateWeilDivisor_V1
          (K := K) (0 : Y.CurveDivisor) n).symm))

/-- The normalized overlap comparison; the coordinate divisor also vanishes on the overlap. -/
noncomputable def coordinateSectionsEquivOverlap (n : ℕ) :
    Γ(Y, Q.V₀ ⊓ Q.V₁) ≃ₗ[K]
      divisorSections K (n • Q.coordinateWeilDivisor (K := K)) (Q.V₀ ⊓ Q.V₁) :=
  (divisorZeroSectionsEquiv (K := K) (Q.V₀ ⊓ Q.V₁)).trans
    (LinearEquiv.ofEq _ _ (by
      simpa only [zero_add] using
        (Q.divisorSections_add_nsmul_coordinateWeilDivisor_overlap
          (K := K) (0 : Y.CurveDivisor) n).symm))

/-- The product of the two normalized chart comparisons. -/
noncomputable def coordinateSectionsEquivDom (n : ℕ) :
    (Γ(Y, Q.V₀) × Γ(Y, Q.V₁)) ≃ₗ[K]
      (divisorSections K (n • Q.coordinateWeilDivisor (K := K)) Q.V₀ ×
        divisorSections K (n • Q.coordinateWeilDivisor (K := K)) Q.V₁) :=
  (Q.coordinateSectionsEquivV0 (K := K) n).prodCongr
    (Q.coordinateSectionsEquivV1 (K := K) n)

/-! ## The normalized differential -/

/-- The overlap restriction of the inverse coordinate. -/
noncomputable def overlapInverseCoordinate : Γ(Y, Q.V₀ ⊓ Q.V₁) :=
  (Y.presheaf.map (homOfLE (inf_le_right : Q.V₀ ⊓ Q.V₁ ≤ Q.V₁)).op).hom Q.y

/-- The overlap restriction of the inverse coordinate, raised to the twist exponent. -/
noncomputable def overlapInversePower (n : ℕ) : Γ(Y, Q.V₀ ⊓ Q.V₁) :=
  Q.overlapInverseCoordinate ^ n

/-- The normalized two-chart differential `(a,b) ↦ yⁿ a|₀₁ - b|₀₁`. -/
noncomputable def coordinateDiff (n : ℕ) :
    (Γ(Y, Q.V₀) × Γ(Y, Q.V₁)) →ₗ[K] Γ(Y, Q.V₀ ⊓ Q.V₁) :=
  (LinearMap.mulLeft K (Q.overlapInversePower n)).comp
      (((Y.moduleKSheaf K).obj.map
        (homOfLE (inf_le_left : Q.V₀ ⊓ Q.V₁ ≤ Q.V₀)).op).hom.comp
          (LinearMap.fst K _ _)) -
    ((Y.moduleKSheaf K).obj.map
      (homOfLE (inf_le_right : Q.V₀ ⊓ Q.V₁ ≤ Q.V₁)).op).hom.comp
        (LinearMap.snd K _ _)

lemma coordinateDiff_apply (n : ℕ) (a : Γ(Y, Q.V₀)) (b : Γ(Y, Q.V₁)) :
    Q.coordinateDiff (K := K) n (a, b) =
      Q.overlapInversePower n *
          (Y.presheaf.map
            (homOfLE (inf_le_left : Q.V₀ ⊓ Q.V₁ ≤ Q.V₀)).op).hom a -
        (Y.presheaf.map
          (homOfLE (inf_le_right : Q.V₀ ⊓ Q.V₁ ≤ Q.V₁)).op).hom b := rfl

/-! ## Comparison with the divisor-sheaf differential -/

lemma divisorZeroSectionsEquiv_coe_of_nonempty {U : Y.Opens}
    (hU : (U : Set Y).Nonempty) (s : Γ(Y, U)) :
    (((divisorZeroSectionsEquiv (K := K) U) s : divisorSections K 0 U) :
        Y.functionField) =
      (Y.presheaf.germ U (genericPoint Y) (genericPoint_mem_of_nonempty hU)).hom s := by
  exact moduleToDivisorZeroPresheafApp_coe_of_nonempty K hU s

lemma coordinateSectionsEquivV0_coe (n : ℕ) (s : Γ(Y, Q.V₀)) :
    (((Q.coordinateSectionsEquivV0 (K := K) n) s :
        divisorSections K (n • Q.coordinateWeilDivisor (K := K)) Q.V₀) :
        Y.functionField) =
      ((Q.coordinateUnit⁻¹ ^ n : Y.functionFieldˣ) : Y.functionField) *
        (Y.presheaf.germ Q.V₀ (genericPoint Y) (Q.genericPoint_mem_inf).1).hom s := by
  rw [coordinateSectionsEquivV0, LinearEquiv.trans_apply, LinearEquiv.trans_apply]
  rfl

lemma coordinateSectionsEquivV1_coe (n : ℕ) (s : Γ(Y, Q.V₁)) :
    (((Q.coordinateSectionsEquivV1 (K := K) n) s :
        divisorSections K (n • Q.coordinateWeilDivisor (K := K)) Q.V₁) :
        Y.functionField) =
      (Y.presheaf.germ Q.V₁ (genericPoint Y) (Q.genericPoint_mem_inf).2).hom s := by
  rw [coordinateSectionsEquivV1, LinearEquiv.trans_apply]
  exact divisorZeroSectionsEquiv_coe_of_nonempty
    (K := K) ⟨genericPoint Y, (Q.genericPoint_mem_inf).2⟩ s

lemma coordinateSectionsEquivOverlap_coe (n : ℕ) (s : Γ(Y, Q.V₀ ⊓ Q.V₁)) :
    (((Q.coordinateSectionsEquivOverlap (K := K) n) s :
        divisorSections K (n • Q.coordinateWeilDivisor (K := K)) (Q.V₀ ⊓ Q.V₁)) :
        Y.functionField) =
      (Y.presheaf.germ (Q.V₀ ⊓ Q.V₁) (genericPoint Y) Q.genericPoint_mem_inf).hom s := by
  rw [coordinateSectionsEquivOverlap, LinearEquiv.trans_apply]
  exact divisorZeroSectionsEquiv_coe_of_nonempty (K := K) Q.inf_nonempty s

lemma coordinateUnit_inv_pow_eq_germ_overlap (n : ℕ) :
    ((Q.coordinateUnit⁻¹ ^ n : Y.functionFieldˣ) : Y.functionField) =
      (Y.presheaf.germ (Q.V₀ ⊓ Q.V₁) (genericPoint Y) Q.genericPoint_mem_inf).hom
        (Q.overlapInversePower n) := by
  rw [map_pow, overlapInversePower, map_pow, ← Q.coordinateUnit_inv_val]
  exact congrArg (fun z : Y.functionField => z ^ n)
    (Y.presheaf.germ_res_apply
      (homOfLE (inf_le_right : Q.V₀ ⊓ Q.V₁ ≤ Q.V₁))
      (genericPoint Y) Q.genericPoint_mem_inf Q.y).symm

private lemma divisorVal_sub {E : Y.CurveDivisor} {W : Y.Opens}
    (a b : (Y.divisorSheaf K E).obj.obj (op W)) :
    divisorVal K (a - b) = divisorVal K a - divisorVal K b := rfl

private lemma divisorVal_coordinateModuleDiff (E : Y.CurveDivisor)
    (t : (divisorSections K E Q.V₀ × divisorSections K E Q.V₁)) :
    divisorVal K ((Y.twoCoverSquare Q.V₀ Q.V₁ Q.cover).moduleDiff
      (Y.divisorSheaf K E) t) = divisorVal K t.1 - divisorVal K t.2 := by
  have h0 : divisorVal K
      (((Y.divisorSheaf K E).obj.map
        (Y.twoCoverSquare Q.V₀ Q.V₁ Q.cover).f₁₂.op).hom t.1) =
      divisorVal K t.1 :=
    divisorPresheaf_map_val K _ Q.inf_nonempty t.1
  have h1 : divisorVal K
      (((Y.divisorSheaf K E).obj.map
        (Y.twoCoverSquare Q.V₀ Q.V₁ Q.cover).f₁₃.op).hom t.2) =
      divisorVal K t.2 :=
    divisorPresheaf_map_val K _ Q.inf_nonempty t.2
  rw [GrothendieckTopology.MayerVietorisSquare.moduleDiff_apply, divisorVal_sub, h0, h1]

/-- The normalized differential is conjugate to the divisor-sheaf Mayer--Vietoris
differential. -/
theorem coordinateDiff_intertwine (n : ℕ) :
    ((Y.twoCoverSquare Q.V₀ Q.V₁ Q.cover).moduleDiff
      (Y.divisorSheaf K (n • Q.coordinateWeilDivisor (K := K)))).comp
        (Q.coordinateSectionsEquivDom (K := K) n).toLinearMap =
      (Q.coordinateSectionsEquivOverlap (K := K) n).toLinearMap.comp
        (Q.coordinateDiff (K := K) n) := by
  ext p
  apply divisorSection_ext K
  rw [divisorVal_coordinateModuleDiff Q]
  simp only [coordinateSectionsEquivDom, LinearEquiv.prodCongr_apply,
    LinearMap.comp_apply, LinearEquiv.coe_coe]
  rw [coordinateSectionsEquivV0_coe, coordinateSectionsEquivV1_coe,
    coordinateSectionsEquivOverlap_coe, coordinateDiff_apply, map_sub, map_mul, map_pow]
  have hy := Y.presheaf.germ_res_apply
    (homOfLE (inf_le_right : Q.V₀ ⊓ Q.V₁ ≤ Q.V₁)) (genericPoint Y)
      Q.genericPoint_mem_inf Q.y
  have ha := Y.presheaf.germ_res_apply
    (homOfLE (inf_le_left : Q.V₀ ⊓ Q.V₁ ≤ Q.V₀)) (genericPoint Y)
      Q.genericPoint_mem_inf p.1
  have hb := Y.presheaf.germ_res_apply
    (homOfLE (inf_le_right : Q.V₀ ⊓ Q.V₁ ≤ Q.V₁)) (genericPoint Y)
      Q.genericPoint_mem_inf p.2
  rw [hy, ha, hb]
  rw [show (((Q.coordinateUnit⁻¹ ^ n : Y.functionFieldˣ) : Y.functionField)) =
      ((Y.presheaf.germ Q.V₁ (genericPoint Y) Q.genericPoint_mem_inf.2).hom Q.y) ^ n by
        rw [Units.val_pow, Q.coordinateUnit_inv_val]]

/-! ## Arbitrary field extension -/

section BaseChange

variable {k : Type u} [Field k] {C : Over (Spec (CommRingCat.of k))}
variable (κ : Type u) [Field κ] [Algebra k κ]
variable (D : FiberCoordinateData C.left)

/-- The product comparison on the degree-zero term of the normalized complex. -/
noncomputable def coordinateDiffDomBaseChangeField :
    κ ⊗[k] (Γ(C.left, D.V₀) × Γ(C.left, D.V₁)) ≃ₗ[κ]
      Γ((baseChangeField C κ).left, (D.baseChangeField κ).V₀) ×
        Γ((baseChangeField C κ).left, (D.baseChangeField κ).V₁) :=
  (TensorProduct.prodRight k κ κ _ _).trans
    ((sectionsBaseChangeFieldₗ κ D.isAffineOpen_V₀.isCompact
        D.isAffineOpen_V₀.isQuasiSeparated).prodCongr
      (sectionsBaseChangeFieldₗ κ D.isAffineOpen_V₁.isCompact
        D.isAffineOpen_V₁.isQuasiSeparated))

/-- The overlap comparison on the degree-one term of the normalized complex. -/
noncomputable def coordinateDiffCodBaseChangeField :
    κ ⊗[k] Γ(C.left, D.V₀ ⊓ D.V₁) ≃ₗ[κ]
      Γ((baseChangeField C κ).left,
        (D.baseChangeField κ).V₀ ⊓ (D.baseChangeField κ).V₁) :=
  sectionsBaseChangeFieldₗ κ
    D.toAffineCoverMVSquare.isAffineOpen_inf.isCompact
    D.toAffineCoverMVSquare.isAffineOpen_inf.isQuasiSeparated

/-- The overlap inverse coordinate pulls back to the overlap inverse coordinate after field
extension. -/
lemma overlapInverseCoordinate_baseChangeField :
    (D.baseChangeField κ).overlapInverseCoordinate =
      sectionsBaseChangeFieldₗ κ
        D.toAffineCoverMVSquare.isAffineOpen_inf.isCompact
        D.toAffineCoverMVSquare.isAffineOpen_inf.isQuasiSeparated
        (1 ⊗ₜ D.overlapInverseCoordinate) := by
  rw [sectionsBaseChangeFieldₗ_one_tmul]
  let f := baseChangeFieldFst C κ
  have h := congrArg
    (fun g : Γ(C.left, D.V₁) ⟶
        Γ((baseChangeField C κ).left, f ⁻¹ᵁ (D.V₀ ⊓ D.V₁)) => g.hom D.y)
    (f.naturality (homOfLE (inf_le_right : D.V₀ ⊓ D.V₁ ≤ D.V₁)).op)
  exact h.symm

/-- The normalized differential after extension is the scalar extension of the base
differential, through the two term comparisons. -/
theorem coordinateDiff_baseChangeField (n : ℕ) :
    ((D.baseChangeField κ).coordinateDiff n).comp
        (coordinateDiffDomBaseChangeField κ D).toLinearMap =
      (coordinateDiffCodBaseChangeField κ D).toLinearMap.comp
        ((D.coordinateDiff n).baseChange κ) := by
  ext x
  simp only [LinearMap.comp_apply, LinearEquiv.coe_coe]
  induction x with
  | zero => simp only [map_zero]
  | add u v hu hv => rw [map_add, map_add, map_add, map_add, hu, hv]
  | tmul a p =>
    obtain ⟨s₀, s₁⟩ := p
    rw [LinearMap.baseChange_tmul]
    have hdom : coordinateDiffDomBaseChangeField κ D (a ⊗ₜ (s₀, s₁)) =
        (sectionsBaseChangeFieldₗ κ D.isAffineOpen_V₀.isCompact
            D.isAffineOpen_V₀.isQuasiSeparated (a ⊗ₜ s₀),
          sectionsBaseChangeFieldₗ κ D.isAffineOpen_V₁.isCompact
            D.isAffineOpen_V₁.isQuasiSeparated (a ⊗ₜ s₁)) := rfl
    rw [hdom, coordinateDiff_apply, overlapInversePower,
      overlapInverseCoordinate_baseChangeField]
    change _ = sectionsBaseChangeField κ
      D.toAffineCoverMVSquare.isAffineOpen_inf.isCompact
      D.toAffineCoverMVSquare.isAffineOpen_inf.isQuasiSeparated
      ((D.coordinateDiff n (s₀, s₁)) ⊗ₜ a)
    rw [coordinateDiff_apply, sub_tmul, map_sub]
    have h₀ := sectionsBaseChangeField_res κ D.isAffineOpen_V₀.isCompact
      D.isAffineOpen_V₀.isQuasiSeparated
      D.toAffineCoverMVSquare.isAffineOpen_inf.isCompact
      D.toAffineCoverMVSquare.isAffineOpen_inf.isQuasiSeparated inf_le_left s₀ a
    have h₁ := sectionsBaseChangeField_res κ D.isAffineOpen_V₁.isCompact
      D.isAffineOpen_V₁.isQuasiSeparated
      D.toAffineCoverMVSquare.isAffineOpen_inf.isCompact
      D.toAffineCoverMVSquare.isAffineOpen_inf.isQuasiSeparated inf_le_right s₁ a
    rw [h₀, h₁, mul_tmul, map_mul, map_pow]
    rfl

/-- Surjectivity of the normalized differential is preserved by every field extension. -/
theorem coordinateDiff_baseChangeField_surjective (n : ℕ)
    (hd : Function.Surjective (D.coordinateDiff n)) :
    Function.Surjective ((D.baseChangeField κ).coordinateDiff n) := by
  intro y
  obtain ⟨z, hz⟩ := LinearMap.baseChange_surjective κ hd
    ((coordinateDiffCodBaseChangeField κ D).symm y)
  refine ⟨coordinateDiffDomBaseChangeField κ D z, ?_⟩
  have h := LinearMap.congr_fun (coordinateDiff_baseChangeField κ D n) z
  simp only [LinearMap.comp_apply, LinearEquiv.coe_coe, hz,
    LinearEquiv.apply_symm_apply] at h
  exact h

/-- Kernels of commuting differentials are equivalent through term equivalences. -/
noncomputable def kerEquivOfComm
    {M N M' N' : Type u} [AddCommGroup M] [Module κ M]
    [AddCommGroup N] [Module κ N] [AddCommGroup M'] [Module κ M']
    [AddCommGroup N'] [Module κ N']
    {f : M →ₗ[κ] N} {g : M' →ₗ[κ] N'}
    (e₀ : M ≃ₗ[κ] M') (e₁ : N ≃ₗ[κ] N')
    (h : g.comp e₀.toLinearMap = e₁.toLinearMap.comp f) :
    LinearMap.ker f ≃ₗ[κ] LinearMap.ker g :=
  LinearEquiv.ofBijective
    (LinearMap.codRestrict (LinearMap.ker g)
      (e₀.toLinearMap.comp (LinearMap.ker f).subtype) (fun x => by
        rw [LinearMap.mem_ker]
        have hx := LinearMap.congr_fun h x
        simpa only [LinearMap.comp_apply, LinearEquiv.coe_coe, x.2, map_zero] using hx))
    (by
      constructor
      · intro x y hxy
        apply Subtype.ext
        apply e₀.injective
        exact congrArg Subtype.val hxy
      · intro y
        have hy : f (e₀.symm y) = 0 := by
          apply e₁.injective
          have he := LinearMap.congr_fun h (e₀.symm y)
          simpa only [LinearMap.comp_apply, LinearEquiv.coe_coe,
            LinearEquiv.apply_symm_apply, y.2, map_zero] using he.symm
        refine ⟨⟨e₀.symm y, hy⟩, ?_⟩
        apply Subtype.ext
        exact e₀.apply_symm_apply y)

/-- Once the base normalized differential is surjective, its kernel commutes with every field
extension. -/
noncomputable def coordinateDiffKerBaseChangeEquiv (n : ℕ)
    (hd : Function.Surjective (D.coordinateDiff n)) :
    κ ⊗[k] LinearMap.ker (D.coordinateDiff n) ≃ₗ[κ]
      LinearMap.ker ((D.baseChangeField κ).coordinateDiff n) :=
  (LinearEquiv.ofBijective
    (AlgebraicJacobian.TwoTerm.kerBaseChange (D.coordinateDiff n) κ)
    (AlgebraicJacobian.TwoTerm.bijective_kerBaseChange_of_surjective hd κ)).trans
  (kerEquivOfComm (coordinateDiffDomBaseChangeField κ D)
    (coordinateDiffCodBaseChangeField κ D)
    (coordinateDiff_baseChangeField κ D n))

end BaseChange

end FiberCoordinateData

end AlgebraicGeometry
