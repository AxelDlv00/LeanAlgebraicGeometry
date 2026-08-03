/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0AtlasFromDivRepAffChallenge
import AlgebraicJacobian.Picard.CechKernelLemma

/-!
# The kernel of the widened Abel transformation

This module identifies equality under `chartValueAff` with relative linear equivalence.  The
two fixed twist factors cancel, equality in `picEt` is detected on every affine open because
the etale-plus unit is injective, and `relPicMk_eq_relPicMk_iff` identifies the remaining
relation with the quotient by `picFromBase`.

The last theorem is the concrete relation that an Altman--Kleiman quotient of the admissible
divisor representer must represent.  No quotient scheme or representability conclusion is
asserted here.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory Opposite

namespace AlgebraicGeometry

attribute [local instance] Over.sectionsAlgebra Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))} {n : ℕ}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

noncomputable section

variable (C n) in
/-- The fixed sigma and theta twists do not change the kernel of the widened Abel map. -/
theorem chartValueAff_eq_iff_abelDivAff'_eq
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (T : Over (Spec (.of k))) (s₁ s₂ : divFamZarAff C n T) :
    chartValueAff C n m Z T s₁ = chartValueAff C n m Z T s₂
      ↔ abelDivAff' C n T s₁ = abelDivAff' C n T s₂ := by
  rw [chartValueAff, chartValueAff, mul_left_inj, mul_left_inj]

omit [SmoothOfRelativeDimension 1 C.hom] in
variable (C n) in
/-- Equality of widened Abel values is equality of their relative Picard classes on every
affine open of the test scheme. -/
theorem abelDivAff'_eq_iff_forall_relPicMk_picClass_eq
    [GeometricallyReduced C.hom]
    (T : Over (Spec (.of k))) (s₁ s₂ : divFamZarAff C n T) :
    abelDivAff' C n T s₁ = abelDivAff' C n T s₂
      ↔ ∀ U : T.left.affineOpens,
          relPicMk C (overSpec k Γ(T.left, U.1)) (s₁.1 U).picClass
            = relPicMk C (overSpec k Γ(T.left, U.1)) (s₂.1 U).picClass :=
  ⟨fun h U => PicEtAff.unit_injective C _ (congrFun (congrArg Subtype.val h) U),
    fun h => picEt.ext fun U => congrArg (PicEtAff.unit C _) (h U)⟩

variable (C n) in
/-- Equality of widened chart values is equality of the relative Picard classes of the
underlying divisor families, affine-locally on the test scheme. -/
theorem chartValueAff_eq_iff_forall_relPicMk_picClass_eq
    [GeometricallyReduced C.hom]
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (T : Over (Spec (.of k))) (s₁ s₂ : divFamZarAff C n T) :
    chartValueAff C n m Z T s₁ = chartValueAff C n m Z T s₂
      ↔ ∀ U : T.left.affineOpens,
          relPicMk C (overSpec k Γ(T.left, U.1)) (s₁.1 U).picClass
            = relPicMk C (overSpec k Γ(T.left, U.1)) (s₂.1 U).picClass :=
  (chartValueAff_eq_iff_abelDivAff'_eq C n m Z T s₁ s₂).trans
    (abelDivAff'_eq_iff_forall_relPicMk_picClass_eq C n T s₁ s₂)

variable (C n) in
/-- The concrete kernel relation of the widened chart: on every affine open, the ratio of the
two divisor Picard classes is pulled back from the base. -/
theorem chartValueAff_eq_iff_forall_picClass_div_mem_picFromBase
    [GeometricallyReduced C.hom]
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (T : Over (Spec (.of k))) (s₁ s₂ : divFamZarAff C n T) :
    chartValueAff C n m Z T s₁ = chartValueAff C n m Z T s₂
      ↔ ∀ U : T.left.affineOpens,
          (s₁.1 U).picClass / (s₂.1 U).picClass
            ∈ picFromBase C (overSpec k Γ(T.left, U.1)) := by
  rw [chartValueAff_eq_iff_forall_relPicMk_picClass_eq C n m Z T s₁ s₂]
  exact forall_congr' fun _ => relPicMk_eq_relPicMk_iff C

/-! ## The concrete map from the admissible divisor representer -/

attribute [local instance 10000] relCurve.instOver in
variable (C) in
/-- The internally chosen multiplicity of the uniform admissible Abel datum. -/
def admissibleAbelChartIndex : ℕ := by
  classical
  letI : C.left.Over (Spec (.of k)) := .ofHom C.hom
  haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (.of k)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
  haveI : IsIntegral C.left := isIntegral_left_of_geometricallyReduced C
  haveI : LocallyOfFiniteType (C.left ↘ Spec (.of k)) :=
    inferInstanceAs (LocallyOfFiniteType C.hom)
  haveI : QuasiCompact (C.left ↘ Spec (.of k)) :=
    inferInstanceAs (QuasiCompact C.hom)
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0) :=
    moduleFinite_hModule_zero C
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1) :=
    moduleFinite_hModule_one C
  exact (exists_uniform_admissibleCoverageChart_eq_univ
    (C := C) (divRepAffP1Map_comp C) (genus C) (chi_moduleKSheaf C)).choose

attribute [local instance 10000] relCurve.instOver in
variable (C) in
/-- The internally chosen divisor of the uniform admissible Abel datum. -/
def admissibleAbelChartDivisor : (C ⊗ overSpec k k).left.CurveDivisor := by
  classical
  letI : C.left.Over (Spec (.of k)) := .ofHom C.hom
  haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (.of k)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
  haveI : IsIntegral C.left := isIntegral_left_of_geometricallyReduced C
  haveI : LocallyOfFiniteType (C.left ↘ Spec (.of k)) :=
    inferInstanceAs (LocallyOfFiniteType C.hom)
  haveI : QuasiCompact (C.left ↘ Spec (.of k)) :=
    inferInstanceAs (QuasiCompact C.hom)
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0) :=
    moduleFinite_hModule_zero C
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1) :=
    moduleFinite_hModule_one C
  exact (exists_uniform_admissibleCoverageChart_eq_univ
    (C := C) (divRepAffP1Map_comp C) (genus C)
      (chi_moduleKSheaf C)).choose_spec.choose

attribute [local instance 10000] relCurve.instOver in
variable (C) in
/-- The chosen admissible Abel datum has the degree required by `chartValueAffTrans`. -/
theorem admissibleAbelChartDivisor_degree :
    Scheme.CurveDivisor.deg k (admissibleAbelChartDivisor C)
      = (admissibleAbelChartIndex C : ℤ) * classDeg k (thetaCechClass C)
        - (divRepAffAdmissibleParameter C : ℤ) := by
  classical
  letI : C.left.Over (Spec (.of k)) := .ofHom C.hom
  haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (.of k)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
  haveI : IsIntegral C.left := isIntegral_left_of_geometricallyReduced C
  haveI : LocallyOfFiniteType (C.left ↘ Spec (.of k)) :=
    inferInstanceAs (LocallyOfFiniteType C.hom)
  haveI : QuasiCompact (C.left ↘ Spec (.of k)) :=
    inferInstanceAs (QuasiCompact C.hom)
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0) :=
    moduleFinite_hModule_zero C
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1) :=
    moduleFinite_hModule_one C
  exact (exists_uniform_admissibleCoverageChart_eq_univ
    (C := C) (divRepAffP1Map_comp C) (genus C)
      (chi_moduleKSheaf C)).choose_spec.choose_spec.1

variable (C) in
/-- The concrete admissible `chartValueAffTrans`, with its legal Abel datum chosen internally. -/
def admissibleChartValueAffTrans :
    divFunctorAff C (divRepAffAdmissibleParameter C) ⟶ pic0TypeFunctor C :=
  chartValueAffTrans C (divRepAffAdmissibleParameter C)
    (admissibleAbelChartIndex C) (admissibleAbelChartDivisor C)
      (admissibleAbelChartDivisor_degree C)

variable (C) in
/-- The concrete admissible Abel transformation in the slice over `Spec k`.  Its body directly
consumes the unconditional admissible divisor representation. -/
def admissibleAbelTrans :
    yoneda.obj (divRepAffAdmissibleScheme C) ⟶ pic0TypeFunctor C :=
  (divFunctorAff_admissible_representableBy C).toIso.hom ≫
    admissibleChartValueAffTrans C

variable (C) in
/-- Evaluation of the represented admissible Abel map classifies the corresponding widened
divisor family and applies the concrete chart transformation. -/
@[simp]
theorem admissibleAbelTrans_app {T : Over (Spec (.of k))}
    (q : T ⟶ divRepAffAdmissibleScheme C) :
    (admissibleAbelTrans C).app (op T) q =
      (admissibleChartValueAffTrans C).app (op T)
        ((divFunctorAff_admissible_representableBy C).homEquiv q) :=
  rfl

variable (C) in
/-- The kernel of the concrete admissible Abel transformation is precisely relative linear
equivalence, including the quotient by classes pulled back from the base. -/
theorem admissibleAbelTrans_app_eq_iff_forall_picClass_div_mem_picFromBase
    {T : Over (Spec (.of k))} (q₁ q₂ : T ⟶ divRepAffAdmissibleScheme C) :
    (admissibleAbelTrans C).app (op T) q₁ = (admissibleAbelTrans C).app (op T) q₂
      ↔ ∀ U : T.left.affineOpens,
          (((divFunctorAff_admissible_representableBy C).homEquiv q₁).1 U).picClass /
              (((divFunctorAff_admissible_representableBy C).homEquiv q₂).1 U).picClass
            ∈ picFromBase C (overSpec k Γ(T.left, U.1)) := by
  unfold admissibleAbelTrans admissibleChartValueAffTrans
  constructor
  · intro h
    apply (chartValueAff_eq_iff_forall_picClass_div_mem_picFromBase C
      (divRepAffAdmissibleParameter C) (admissibleAbelChartIndex C)
        (admissibleAbelChartDivisor C) T
          ((divFunctorAff_admissible_representableBy C).homEquiv q₁)
          ((divFunctorAff_admissible_representableBy C).homEquiv q₂)).mp
    exact congrArg Subtype.val h
  · intro h
    apply Subtype.ext
    exact (chartValueAff_eq_iff_forall_picClass_div_mem_picFromBase C
      (divRepAffAdmissibleParameter C) (admissibleAbelChartIndex C)
        (admissibleAbelChartDivisor C) T
          ((divFunctorAff_admissible_representableBy C).homEquiv q₁)
          ((divFunctorAff_admissible_representableBy C).homEquiv q₂)).mpr h

end

end AlgebraicGeometry
