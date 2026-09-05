/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4BasisJumpWitness
import HartshorneLib.Chapter4SmoothProperDevissage

/-!
# The one-point jump criterion for base-point-freeness

The numerical one-point condition is equivalent to the existence of a global
divisor section with nonzero local jump at every non-generic point.  This is
the geometric section-level interface needed by the local-ratio construction.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry

namespace Hartshorne

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]

attribute [local instance] functionFieldOverModule
  AlgebraicGeometry.Scheme.residueFieldOverModule

/-- Numerical base-point-freeness is equivalent to a nonzero local jump of
some global divisor section at every non-generic point. -/
theorem basePointFreeLinearSystem_iff_exists_jumpProj_ne_zero
    (D : CurveDivisor k X) :
    BasePointFreeLinearSystem D ↔
      ∀ (x : X.left) (hx : x ≠ genericPoint X.left),
        ∃ s : divisorSections D (⊤ : X.left.Opens),
          jumpProj hx D ⊤ trivial s ≠ 0 := by
  constructor
  · intro hD x hx
    exact exists_jumpProj_ne_zero_of_basePointFree hD x hx
  · intro hJ x hx
    obtain ⟨s, hs⟩ := hJ x hx
    have hnot : (s : X.left.functionField) ∉
        divisorSections (CurveDivisor.devissageDivisor hx D) ⊤ :=
      (jumpProj_ne_zero_iff_not_mem_divisorSections_devissage hx D s).mp hs
    have hle : divisorSections (CurveDivisor.devissageDivisor hx D) ⊤ ≤
        divisorSections D ⊤ :=
      divisorSections_mono (devissageDivisor_le hx D) ⊤
    have hne : divisorSections (CurveDivisor.devissageDivisor hx D) ⊤ ≠
        divisorSections D ⊤ := by
      intro heq
      apply hnot
      simpa only [heq] using s.2
    have hlt : divisorSections (CurveDivisor.devissageDivisor hx D) ⊤ <
        divisorSections D ⊤ := lt_of_le_of_ne hle hne
    letI : Module.Finite k (CurveDivisorSectionSpace D) :=
      (hasFiniteDivisorCohomology_of_smoothProperIntegralCurve (k := k) X D).1
    letI : Module.Finite k (divisorSections D (⊤ : X.left.Opens)) :=
      Module.Finite.equiv (divisorSectionSpaceEquiv (D := D))
    have hfinrank := Submodule.finrank_lt_finrank_of_lt hlt
    have hltObj :
        Module.finrank k
            ((divisorSheaf (CurveDivisor.devissageDivisor hx D)).obj.obj
              (Opposite.op (⊤ : X.left.Opens))) <
          Module.finrank k ((divisorSheaf D).obj.obj
            (Opposite.op (⊤ : X.left.Opens))) := by
      rw [divisorSheaf_obj, divisorSheaf_obj]
      exact hfinrank
    have hstrict :
        CategoryTheory.Sheaf.h0
            (divisorSheaf (CurveDivisor.devissageDivisor hx D)) <
          CategoryTheory.Sheaf.h0 (divisorSheaf D) := by
      let eSmall := CategoryTheory.Sheaf.HModule.linearEquiv₀
        (isTerminalTop : IsTerminal (⊤ : X.left.Opens))
        (divisorSheaf (CurveDivisor.devissageDivisor hx D))
      let eBig := CategoryTheory.Sheaf.HModule.linearEquiv₀
        (isTerminalTop : IsTerminal (⊤ : X.left.Opens)) (divisorSheaf D)
      rw [CategoryTheory.Sheaf.h0, CategoryTheory.Sheaf.h0]
      rw [eSmall.finrank_eq, eBig.finrank_eq]
      exact hltObj
    have hupper := h0_le_h0_sub_point_add_one_of_smoothProperIntegralCurve hx D
    omega

private theorem jump_surjective_iff_exists_ne_zero
    {x : X.left} (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X) :
    Function.Surjective (jumpProj hx D ⊤ trivial) ↔
      ∃ s : divisorSections D (⊤ : X.left.Opens),
        jumpProj hx D ⊤ trivial s ≠ 0 := by
  letI : Module.Finite k (jumpModule hx D) := moduleFinite_jumpModule hx D
  have hW : Module.finrank k (jumpModule hx D) = 1 := by
    rw [finrank_jumpModule]
    letI : X.left.Over (Spec (CommRingCat.of k)) := .ofHom X.hom
    letI : SmoothOfRelativeDimension 1 (X.left ↘ Spec (CommRingCat.of k)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 X.hom)
    letI : LocallyOfFiniteType (X.left ↘ Spec (CommRingCat.of k)) :=
      inferInstanceAs (LocallyOfFiniteType X.hom)
    exact AlgebraicGeometry.Scheme.residueDeg_eq_one_of_isAlgClosed hx
  constructor
  · intro hsurj
    have hWpos : 0 < Module.finrank k (jumpModule hx D) := by
      rw [hW]
      exact Nat.zero_lt_succ _
    letI : Nontrivial (jumpModule hx D) := Module.nontrivial_of_finrank_pos hWpos
    obtain ⟨w, hw⟩ := exists_ne (0 : jumpModule hx D)
    obtain ⟨s, hs⟩ := hsurj w
    refine ⟨s, ?_⟩
    intro hz
    apply hw
    rw [← hs, hz]
  · intro hne
    obtain ⟨s, hs⟩ := hne
    have hrange_ne : LinearMap.range (jumpProj hx D ⊤ trivial) ≠
        (⊥ : Submodule k (jumpModule hx D)) := by
      intro hz
      have hm : jumpProj hx D ⊤ trivial s ∈
          (⊥ : Submodule k (jumpModule hx D)) := by
        rw [← hz]
        exact ⟨s, rfl⟩
      change jumpProj hx D ⊤ trivial s = 0 at hm
      exact hs hm
    letI : Module.Finite k (LinearMap.range (jumpProj hx D ⊤ trivial)) :=
      Submodule.finiteDimensional_of_le
        (show LinearMap.range (jumpProj hx D ⊤ trivial) ≤
          (⊤ : Submodule k (jumpModule hx D)) from le_top)
    have hone : 1 ≤ Module.finrank k
        (LinearMap.range (jumpProj hx D ⊤ trivial)) :=
      Submodule.one_le_finrank_iff.mpr hrange_ne
    have hle : Module.finrank k
        (LinearMap.range (jumpProj hx D ⊤ trivial)) ≤
        Module.finrank k (jumpModule hx D) := Submodule.finrank_le _
    have heq : Module.finrank k
        (LinearMap.range (jumpProj hx D ⊤ trivial)) =
        Module.finrank k (jumpModule hx D) := by
      omega
    exact LinearMap.range_eq_top.mp (Submodule.eq_top_of_finrank_eq heq)

/-- Base-point-freeness is equivalently surjectivity onto each one-point jump
space.  The target has rank one over the algebraically closed ground field. -/
theorem basePointFreeLinearSystem_iff_jumpProj_surjective
    (D : CurveDivisor k X) :
    BasePointFreeLinearSystem D ↔
      ∀ (x : X.left) (hx : x ≠ genericPoint X.left),
        Function.Surjective (jumpProj hx D ⊤ trivial) := by
  rw [basePointFreeLinearSystem_iff_exists_jumpProj_ne_zero]
  constructor
  · intro h x hx
    exact (jump_surjective_iff_exists_ne_zero hx D).mpr (h x hx)
  · intro h x hx
    exact (jump_surjective_iff_exists_ne_zero hx D).mp (h x hx)

/-! ## Residue realization of the local jump -/

/-- The quotient class of a local divisor section is carried by the canonical
`jumpEquivResidueField` to the residue of its normalized function-field
representative.  This is an intrinsic local residue statement; it is not yet
the scheme-theoretic line-bundle evaluation map from the source proposition. -/
theorem jumpProj_ne_zero_iff_jumpToResidue_ne_zero
    {x : X.left} (hx : x ≠ genericPoint X.left)
    (D : CurveDivisor k X) {U : X.left.Opens} (hxU : x ∈ U)
    (s : divisorSections D U) :
    jumpProj hx D U hxU s ≠ 0 ↔
      jumpToResidue (X := X) hx D
        ⟨(s : X.left.functionField),
          divisorSections_le_pointLattice hx D U hxU s.2⟩ ≠ 0 := by
  have hEq :
      jumpEquivResidueField (X := X) hx D
          (jumpProj hx D U hxU s) =
        jumpToResidue (X := X) hx D
          ⟨(s : X.left.functionField),
            divisorSections_le_pointLattice hx D U hxU s.2⟩ := rfl
  constructor
  · intro h hz
    apply h
    apply (jumpEquivResidueField (X := X) hx D).injective
    rw [hEq, hz]
    simp
  · intro h hz
    apply h
    rw [← hEq, hz]
    simp

/-- The numerical one-point condition has a residue-level formulation: every
non-generic point admits a global divisor section whose normalized local
residue is nonzero.  The remaining geometric bridge is the identification of
this normalized residue with the usual line-bundle evaluation map. -/
theorem basePointFreeLinearSystem_iff_exists_jumpToResidue_ne_zero
    (D : CurveDivisor k X) :
    BasePointFreeLinearSystem D ↔
      ∀ (x : X.left) (hx : x ≠ genericPoint X.left),
        ∃ s : divisorSections D (⊤ : X.left.Opens),
          jumpToResidue (X := X) hx D
            ⟨(s : X.left.functionField),
              divisorSections_le_pointLattice hx D ⊤ (by simp) s.2⟩ ≠ 0 := by
  rw [basePointFreeLinearSystem_iff_exists_jumpProj_ne_zero]
  constructor
  · intro h x hx
    obtain ⟨s, hs⟩ := h x hx
    exact ⟨s, (jumpProj_ne_zero_iff_jumpToResidue_ne_zero
      (U := (⊤ : X.left.Opens)) hx D (by simp) s).mp hs⟩
  · intro h x hx
    obtain ⟨s, hs⟩ := h x hx
    exact ⟨s, (jumpProj_ne_zero_iff_jumpToResidue_ne_zero
      (U := (⊤ : X.left.Opens)) hx D (by simp) s).mpr hs⟩

/-! ## The sheaf-theoretic evaluation bridge -/

/-- The degree-zero divisor-sheaf class evaluated in the canonical one-point
skyscraper quotient.

This is the map induced by the sheaf morphism `devissageπ`: its target is the
intrinsic fiber quotient `jumpModule`, rather than a choice of local
trivialization of a line bundle. -/
noncomputable def divisorSectionJumpEvaluation
    {x : X.left} (hx : x ≠ genericPoint X.left)
    (D : CurveDivisor k X) :
    CurveDivisorSectionSpace D →ₗ[k] jumpModule hx D :=
  (skyModuleGammaEquiv (X := X) x (jumpModule hx D)).toLinearMap.comp
    (CategoryTheory.Sheaf.HModule.map (devissageπ hx D) 0)

/-- On global divisor sections, the sheaf-theoretic evaluation is the local
jump projection. -/
@[simp] theorem divisorSectionJumpEvaluation_apply
    {x : X.left} (hx : x ≠ genericPoint X.left)
    (D : CurveDivisor k X) (v : CurveDivisorSectionSpace D) :
    divisorSectionJumpEvaluation hx D v =
      jumpProj hx D ⊤ trivial
        (divisorSectionSpaceEquiv (D := D) v) := by
  rw [divisorSectionJumpEvaluation, LinearMap.comp_apply]
  change
    (eqToHom (skyModule_obj_of_mem' (X := X) (jumpModule hx D) (by simp))).hom
        (CategoryTheory.Sheaf.HModule.linearEquiv₀
          (isTerminalTop : IsTerminal (⊤ : X.left.Opens))
          (skyModule (X := X) x (jumpModule hx D))
          (CategoryTheory.Sheaf.HModule.map (devissageπ hx D) 0 v)) = _
  rw [← CategoryTheory.Sheaf.HModule.linearEquiv₀_naturality]
  rw [devissageπ_app_hom_apply_of_mem hx D
    (Opposite.op (⊤ : X.left.Opens)) (by simp)]
  rw [← ConcreteCategory.comp_apply]
  rw [eqToHom_trans]
  simp only [divisorSectionSpaceEquiv]
  apply congrArg (jumpProj hx D ⊤ trivial)
  apply Subtype.ext
  rfl

/-- The intrinsic residue-valued evaluation of a global divisor section.

It is obtained from `divisorSectionJumpEvaluation` by the canonical
`jumpEquivResidueField`; no line-bundle frame is chosen. -/
noncomputable def divisorSectionResidueEvaluation
    {x : X.left} (hx : x ≠ genericPoint X.left)
    (D : CurveDivisor k X) :
    divisorSections D (⊤ : X.left.Opens) →ₗ[k] X.left.residueField x :=
  (jumpEquivResidueField (X := X) hx D).toLinearMap.comp
    ((divisorSectionJumpEvaluation (X := X) hx D).comp
      (divisorSectionSpaceEquiv (D := D)).symm.toLinearMap)

@[simp] theorem divisorSectionResidueEvaluation_apply
    {x : X.left} (hx : x ≠ genericPoint X.left)
    (D : CurveDivisor k X) (s : divisorSections D (⊤ : X.left.Opens)) :
    divisorSectionResidueEvaluation hx D s =
      jumpEquivResidueField (X := X) hx D
        (jumpProj hx D ⊤ trivial s) := by
  simp [divisorSectionResidueEvaluation]

/-- The kernel of intrinsic residue evaluation is exactly the global section
space after subtracting the chosen point. -/
theorem divisorSectionResidueEvaluation_eq_zero_iff_mem_devissage
    {x : X.left} (hx : x ≠ genericPoint X.left)
    (D : CurveDivisor k X) (s : divisorSections D (⊤ : X.left.Opens)) :
    divisorSectionResidueEvaluation hx D s = 0 ↔
      (s : X.left.functionField) ∈
        divisorSections (CurveDivisor.devissageDivisor hx D) ⊤ := by
  rw [divisorSectionResidueEvaluation_apply]
  rw [(jumpEquivResidueField (X := X) hx D).map_eq_zero_iff]
  rw [← not_iff_not]
  exact jumpProj_ne_zero_iff_not_mem_divisorSections_devissage hx D s

/-- Numerical base-point-freeness is equivalent to surjectivity of the
intrinsic residue evaluation at every non-generic point.  The evaluation here
is the canonical skyscraper quotient of `𝒪(D)`; identifying it with a chosen
line-bundle fiber is a separate geometric lift. -/
theorem basePointFreeLinearSystem_iff_divisorSectionResidueEvaluation_surjective
    (D : CurveDivisor k X) :
    BasePointFreeLinearSystem D ↔
      ∀ (x : X.left) (hx : x ≠ genericPoint X.left),
        Function.Surjective (divisorSectionResidueEvaluation hx D) := by
  rw [basePointFreeLinearSystem_iff_jumpProj_surjective]
  constructor
  · intro h x hx r
    obtain ⟨j, hj⟩ := (jumpEquivResidueField (X := X) hx D).surjective r
    obtain ⟨s, hs⟩ := h x hx j
    refine ⟨s, ?_⟩
    rw [divisorSectionResidueEvaluation_apply, hs]
    exact hj
  · intro h x hx j
    obtain ⟨s, hs⟩ := h x hx
      ((jumpEquivResidueField (X := X) hx D) j)
    refine ⟨s, ?_⟩
    apply (jumpEquivResidueField (X := X) hx D).injective
    rw [← hs]
    rw [divisorSectionResidueEvaluation_apply]

end
end Hartshorne
