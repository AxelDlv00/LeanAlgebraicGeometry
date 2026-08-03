/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0AtlasFromDivRepAff
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
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

noncomputable section

omit [GeometricallyReduced C.hom] in
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
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (T : Over (Spec (.of k))) (s₁ s₂ : divFamZarAff C n T) :
    chartValueAff C n m Z T s₁ = chartValueAff C n m Z T s₂
      ↔ ∀ U : T.left.affineOpens,
          (s₁.1 U).picClass / (s₂.1 U).picClass
            ∈ picFromBase C (overSpec k Γ(T.left, U.1)) := by
  rw [chartValueAff_eq_iff_forall_relPicMk_picClass_eq C n m Z T s₁ s₂]
  exact forall_congr' fun _ => relPicMk_eq_relPicMk_iff C

end

end AlgebraicGeometry
