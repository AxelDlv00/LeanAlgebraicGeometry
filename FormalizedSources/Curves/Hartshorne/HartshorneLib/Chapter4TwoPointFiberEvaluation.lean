/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4OrdinaryFiberVeryAmple
import HartshorneLib.Chapter4VeryAmpleSeparation

/-!
# Two-point evaluation for divisor modules

For two distinct points, the product of the intrinsic one-point jump maps has
kernel `H⁰(D - x - y)`. The two-dimensional drop in Hartshorne IV.3.1 therefore
makes this product surjective. The same conclusion is then transported to the
product of the ordinary scheme-module fibers without choosing residue-field
coordinates.
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

attribute [local instance] functionFieldOverModule Scheme.overModule
attribute [local instance] Scheme.Modules.stalkModule

/-- Simultaneous intrinsic jump evaluation at two points. -/
noncomputable def twoPointJumpEvaluation {x y : X.left}
    (hx : x ≠ genericPoint X.left) (hy : y ≠ genericPoint X.left)
    (D : CurveDivisor k X) :
    divisorSections D (⊤ : X.left.Opens) →ₗ[k]
      jumpModule hx D × jumpModule hy D :=
  (jumpProj hx D ⊤ trivial).prod (jumpProj hy D ⊤ trivial)

@[simp]
lemma twoPointJumpEvaluation_apply {x y : X.left}
    (hx : x ≠ genericPoint X.left) (hy : y ≠ genericPoint X.left)
    (D : CurveDivisor k X) (s : divisorSections D (⊤ : X.left.Opens)) :
    twoPointJumpEvaluation hx hy D s =
      (jumpProj hx D ⊤ trivial s, jumpProj hy D ⊤ trivial s) :=
  rfl

/-- A global section has zero jump at `x` exactly when it is a section of
`D - x`. -/
lemma jumpProj_eq_zero_iff_mem_divisorSections_devissage {x : X.left}
    (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X)
    (s : divisorSections D (⊤ : X.left.Opens)) :
    jumpProj hx D ⊤ trivial s = 0 ↔
      (s : X.left.functionField) ∈
        divisorSections (CurveDivisor.devissageDivisor hx D) ⊤ := by
  constructor
  · intro hzero
    by_contra hmem
    exact
      (jumpProj_ne_zero_iff_not_mem_divisorSections_devissage hx D s).mpr hmem
        hzero
  · intro hmem
    by_contra hne
    exact
      (jumpProj_ne_zero_iff_not_mem_divisorSections_devissage hx D s).mp hne
        hmem

/-- At distinct points, simultaneous jump evaluation vanishes exactly on the
sections of `D - x - y`. -/
theorem twoPointJumpEvaluation_eq_zero_iff_of_ne {x y : X.left}
    (hx : x ≠ genericPoint X.left) (hy : y ≠ genericPoint X.left)
    (hxy : x ≠ y) (D : CurveDivisor k X)
    (s : divisorSections D (⊤ : X.left.Opens)) :
    twoPointJumpEvaluation hx hy D s = 0 ↔
      (s : X.left.functionField) ∈
        divisorSections (CurveDivisor.devissageDivisor hy
          (CurveDivisor.devissageDivisor hx D)) ⊤ := by
  rw [twoPointJumpEvaluation_apply, Prod.mk_eq_zero,
    jumpProj_eq_zero_iff_mem_divisorSections_devissage,
    jumpProj_eq_zero_iff_mem_divisorSections_devissage]
  rw [divisorSections_twoDevissage_eq_inf_of_ne x y hx hy hxy,
    Submodule.mem_inf]

/-- The kernel of simultaneous jump evaluation is the twice-lowered section
space, regarded as a submodule of the original global sections. -/
theorem ker_twoPointJumpEvaluation_of_ne {x y : X.left}
    (hx : x ≠ genericPoint X.left) (hy : y ≠ genericPoint X.left)
    (hxy : x ≠ y) (D : CurveDivisor k X) :
    (twoPointJumpEvaluation hx hy D).ker =
      (divisorSections (CurveDivisor.devissageDivisor hy
        (CurveDivisor.devissageDivisor hx D)) (⊤ : X.left.Opens)).submoduleOf
        (divisorSections D ⊤) := by
  ext s
  rw [LinearMap.mem_ker, twoPointJumpEvaluation_eq_zero_iff_of_ne hx hy hxy]
  rfl

/-- At two distinct points, a two-dimensional section drop makes simultaneous
intrinsic jump evaluation surjective. -/
theorem twoPointJumpEvaluation_surjective_of_h0_drop
    {x y : X.left} (hx : x ≠ genericPoint X.left)
    (hy : y ≠ genericPoint X.left) (hxy : x ≠ y)
    (D : CurveDivisor k X)
    (hdrop : (CategoryTheory.Sheaf.h0 (divisorSheaf D) : ℤ) -
      CategoryTheory.Sheaf.h0
        (divisorSheaf (CurveDivisor.devissageDivisor hy
          (CurveDivisor.devissageDivisor hx D))) = 2) :
    Function.Surjective (twoPointJumpEvaluation hx hy D) := by
  let Dxy := CurveDivisor.devissageDivisor hy
    (CurveDivisor.devissageDivisor hx D)
  let P := divisorSections Dxy (⊤ : X.left.Opens)
  have hle : P ≤ divisorSections D ⊤ :=
    (divisorSections_mono
      (devissageDivisor_le hy (CurveDivisor.devissageDivisor hx D)) ⊤).trans
      (divisorSections_mono (devissageDivisor_le hx D) ⊤)
  letI : Module.Finite k (CurveDivisorSectionSpace D) :=
    (hasFiniteDivisorCohomology_of_smoothProperIntegralCurve (k := k) X D).1
  letI : Module.Finite k (divisorSections D (⊤ : X.left.Opens)) :=
    Module.Finite.equiv (divisorSectionSpaceEquiv (D := D))
  letI : Module.Finite k (jumpModule hx D) := moduleFinite_jumpModule hx D
  letI : Module.Finite k (jumpModule hy D) := moduleFinite_jumpModule hy D
  letI : X.left.Over (Spec (CommRingCat.of k)) := .ofHom X.hom
  letI : SmoothOfRelativeDimension 1
      (X.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 X.hom)
  letI : LocallyOfFiniteType (X.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (LocallyOfFiniteType X.hom)
  have hxdeg : X.left.residueDeg k x = 1 :=
    AlgebraicGeometry.Scheme.residueDeg_eq_one_of_isAlgClosed hx
  have hydeg : X.left.residueDeg k y = 1 :=
    AlgebraicGeometry.Scheme.residueDeg_eq_one_of_isAlgClosed hy
  have htarget :
      Module.finrank k (jumpModule hx D × jumpModule hy D) = 2 := by
    rw [Module.finrank_prod, finrank_jumpModule, finrank_jumpModule,
      hxdeg, hydeg]
  have hker :
      Module.finrank k (twoPointJumpEvaluation hx hy D).ker =
        Module.finrank k P := by
    rw [ker_twoPointJumpEvaluation_of_ne hx hy hxy D]
    exact (Submodule.submoduleOfEquivOfLe hle).finrank_eq
  let eSmall := CategoryTheory.Sheaf.HModule.linearEquiv₀ isTerminalTop
    (divisorSheaf Dxy)
  let eBig := CategoryTheory.Sheaf.HModule.linearEquiv₀ isTerminalTop
    (divisorSheaf D)
  change (CategoryTheory.Sheaf.h0 (divisorSheaf D) : ℤ) -
      CategoryTheory.Sheaf.h0 (divisorSheaf Dxy) = 2 at hdrop
  rw [CategoryTheory.Sheaf.h0, CategoryTheory.Sheaf.h0,
    eBig.finrank_eq, eSmall.finrank_eq, divisorSheaf_obj, divisorSheaf_obj]
    at hdrop
  change (Module.finrank k (divisorSections D (⊤ : X.left.Opens)) : ℤ) -
      Module.finrank k P = 2 at hdrop
  have hrank :=
    LinearMap.finrank_range_add_finrank_ker
      (twoPointJumpEvaluation hx hy D)
  rw [hker] at hrank
  have hrange :
      Module.finrank k (twoPointJumpEvaluation hx hy D).range =
        Module.finrank k (jumpModule hx D × jumpModule hy D) := by
    omega
  exact LinearMap.range_eq_top.mp (Submodule.eq_top_of_finrank_eq hrange)

/-- Numerical very ampleness makes simultaneous intrinsic jump evaluation
surjective at every pair of distinct points. -/
theorem twoPointJumpEvaluation_surjective_of_veryAmple
    {D : CurveDivisor k X} (hD : VeryAmpleLinearSystem D)
    {x y : X.left} (hx : x ≠ genericPoint X.left)
    (hy : y ≠ genericPoint X.left) (hxy : x ≠ y) :
    Function.Surjective (twoPointJumpEvaluation hx hy D) :=
  twoPointJumpEvaluation_surjective_of_h0_drop hx hy hxy D (hD x y hx hy)

/-- At two distinct points, surjectivity of simultaneous intrinsic jump
evaluation forces the two-dimensional section drop. -/
theorem h0_drop_eq_two_of_twoPointJumpEvaluation_surjective
    {x y : X.left} (hx : x ≠ genericPoint X.left)
    (hy : y ≠ genericPoint X.left) (hxy : x ≠ y)
    (D : CurveDivisor k X)
    (hsurj : Function.Surjective (twoPointJumpEvaluation hx hy D)) :
    (CategoryTheory.Sheaf.h0 (divisorSheaf D) : ℤ) -
      CategoryTheory.Sheaf.h0
        (divisorSheaf (CurveDivisor.devissageDivisor hy
          (CurveDivisor.devissageDivisor hx D))) = 2 := by
  let Dxy := CurveDivisor.devissageDivisor hy
    (CurveDivisor.devissageDivisor hx D)
  let P := divisorSections Dxy (⊤ : X.left.Opens)
  have hle : P ≤ divisorSections D ⊤ :=
    (divisorSections_mono
      (devissageDivisor_le hy (CurveDivisor.devissageDivisor hx D)) ⊤).trans
      (divisorSections_mono (devissageDivisor_le hx D) ⊤)
  letI : Module.Finite k (CurveDivisorSectionSpace D) :=
    (hasFiniteDivisorCohomology_of_smoothProperIntegralCurve (k := k) X D).1
  letI : Module.Finite k (divisorSections D (⊤ : X.left.Opens)) :=
    Module.Finite.equiv (divisorSectionSpaceEquiv (D := D))
  letI : Module.Finite k (jumpModule hx D) := moduleFinite_jumpModule hx D
  letI : Module.Finite k (jumpModule hy D) := moduleFinite_jumpModule hy D
  letI : X.left.Over (Spec (CommRingCat.of k)) := .ofHom X.hom
  letI : SmoothOfRelativeDimension 1
      (X.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 X.hom)
  letI : LocallyOfFiniteType (X.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (LocallyOfFiniteType X.hom)
  have hxdeg : X.left.residueDeg k x = 1 :=
    AlgebraicGeometry.Scheme.residueDeg_eq_one_of_isAlgClosed hx
  have hydeg : X.left.residueDeg k y = 1 :=
    AlgebraicGeometry.Scheme.residueDeg_eq_one_of_isAlgClosed hy
  have htarget :
      Module.finrank k (jumpModule hx D × jumpModule hy D) = 2 := by
    rw [Module.finrank_prod, finrank_jumpModule, finrank_jumpModule,
      hxdeg, hydeg]
  have hker :
      Module.finrank k (twoPointJumpEvaluation hx hy D).ker =
        Module.finrank k P := by
    rw [ker_twoPointJumpEvaluation_of_ne hx hy hxy D]
    exact (Submodule.submoduleOfEquivOfLe hle).finrank_eq
  have hrank :=
    LinearMap.finrank_range_add_finrank_ker
      (twoPointJumpEvaluation hx hy D)
  rw [hker] at hrank
  have hrange :
      Module.finrank k (twoPointJumpEvaluation hx hy D).range =
        Module.finrank k (jumpModule hx D × jumpModule hy D) := by
    rw [LinearMap.range_eq_top.mpr hsurj]
    exact finrank_top k (jumpModule hx D × jumpModule hy D)
  let eSmall := CategoryTheory.Sheaf.HModule.linearEquiv₀ isTerminalTop
    (divisorSheaf Dxy)
  let eBig := CategoryTheory.Sheaf.HModule.linearEquiv₀ isTerminalTop
    (divisorSheaf D)
  change (CategoryTheory.Sheaf.h0 (divisorSheaf D) : ℤ) -
      CategoryTheory.Sheaf.h0 (divisorSheaf Dxy) = 2
  rw [CategoryTheory.Sheaf.h0, CategoryTheory.Sheaf.h0,
    eBig.finrank_eq, eSmall.finrank_eq, divisorSheaf_obj, divisorSheaf_obj]
  change (Module.finrank k (divisorSections D (⊤ : X.left.Opens)) : ℤ) -
      Module.finrank k P = 2
  omega

/-- At two distinct points, the two-dimensional section drop is equivalent to
surjectivity of simultaneous intrinsic jump evaluation. -/
theorem h0_sub_h0_twoDevissage_eq_two_iff_twoPointJumpEvaluation_surjective
    {x y : X.left} (hx : x ≠ genericPoint X.left)
    (hy : y ≠ genericPoint X.left) (hxy : x ≠ y)
    (D : CurveDivisor k X) :
    (CategoryTheory.Sheaf.h0 (divisorSheaf D) : ℤ) -
        CategoryTheory.Sheaf.h0
          (divisorSheaf (CurveDivisor.devissageDivisor hy
            (CurveDivisor.devissageDivisor hx D))) = 2 ↔
      Function.Surjective (twoPointJumpEvaluation hx hy D) :=
  ⟨twoPointJumpEvaluation_surjective_of_h0_drop hx hy hxy D,
    h0_drop_eq_two_of_twoPointJumpEvaluation_surjective hx hy hxy D⟩

/-- Simultaneous evaluation in the two ordinary divisor-module fibers. -/
noncomputable def divisorModuleTwoPointFiberEvaluation (D : CurveDivisor k X)
    (x y : X.left) :
    Γ(divisorModule D, (⊤ : X.left.Opens)) →+
      Scheme.Modules.stalkFiber (divisorModule D) x ×
        Scheme.Modules.stalkFiber (divisorModule D) y :=
  (Scheme.Modules.fiberEvaluation (divisorModule D) x).toAddMonoidHom.prod
    (Scheme.Modules.fiberEvaluation (divisorModule D) y).toAddMonoidHom

@[simp]
lemma divisorModuleTwoPointFiberEvaluation_apply (D : CurveDivisor k X)
    (x y : X.left) (s : Γ(divisorModule D, (⊤ : X.left.Opens))) :
    divisorModuleTwoPointFiberEvaluation D x y s =
      (Scheme.Modules.fiberEvaluation (divisorModule D) x s,
        Scheme.Modules.fiberEvaluation (divisorModule D) y s) :=
  rfl

/-- Simultaneous ordinary-fiber evaluation is surjective exactly when the
corresponding pair of intrinsic jump evaluations is surjective. -/
theorem divisorModuleTwoPointFiberEvaluation_surjective_iff
    {x y : X.left} (hx : x ≠ genericPoint X.left)
    (hy : y ≠ genericPoint X.left) (D : CurveDivisor k X) :
    Function.Surjective (divisorModuleTwoPointFiberEvaluation D x y) ↔
      Function.Surjective (twoPointJumpEvaluation hx hy D) := by
  constructor
  · intro hFiber q
    obtain ⟨zx, hzx⟩ :=
      stalkJumpFiberAddHom_of_divisorModule_surjective (X := X) hx D q.1
    obtain ⟨zy, hzy⟩ :=
      stalkJumpFiberAddHom_of_divisorModule_surjective (X := X) hy D q.2
    obtain ⟨s, hs⟩ := hFiber (zx, zy)
    have hsx : Scheme.Modules.fiberEvaluation (divisorModule D) x s = zx := by
      simpa only [divisorModuleTwoPointFiberEvaluation_apply] using
        congrArg Prod.fst hs
    have hsy : Scheme.Modules.fiberEvaluation (divisorModule D) y s = zy := by
      simpa only [divisorModuleTwoPointFiberEvaluation_apply] using
        congrArg Prod.snd hs
    refine ⟨s, ?_⟩
    rw [twoPointJumpEvaluation_apply]
    apply Prod.ext
    · change jumpProj hx D ⊤ trivial s = q.1
      rw [← divisorModuleFiberJumpEvaluation_apply hx D]
      change stalkJumpFiberAddHom_of_divisorModule (X := X) hx D
          (Scheme.Modules.fiberEvaluation (divisorModule D) x s) = q.1
      rw [hsx, hzx]
    · change jumpProj hy D ⊤ trivial s = q.2
      rw [← divisorModuleFiberJumpEvaluation_apply hy D]
      change stalkJumpFiberAddHom_of_divisorModule (X := X) hy D
          (Scheme.Modules.fiberEvaluation (divisorModule D) y s) = q.2
      rw [hsy, hzy]
  · intro hJump z
    let fx := stalkJumpFiberAddHom_of_divisorModule (X := X) hx D
    let fy := stalkJumpFiberAddHom_of_divisorModule (X := X) hy D
    obtain ⟨s, hs⟩ := hJump (fx z.1, fy z.2)
    have hsx : jumpProj hx D ⊤ trivial s = fx z.1 := by
      simpa only [twoPointJumpEvaluation_apply] using congrArg Prod.fst hs
    have hsy : jumpProj hy D ⊤ trivial s = fy z.2 := by
      simpa only [twoPointJumpEvaluation_apply] using congrArg Prod.snd hs
    refine ⟨s, ?_⟩
    rw [divisorModuleTwoPointFiberEvaluation_apply]
    apply Prod.ext
    · apply stalkJumpFiberAddHom_of_divisorModule_injective hx D
      change divisorModuleFiberJumpEvaluation (X := X) hx D s = fx z.1
      rw [divisorModuleFiberJumpEvaluation_apply]
      exact hsx
    · apply stalkJumpFiberAddHom_of_divisorModule_injective hy D
      change divisorModuleFiberJumpEvaluation (X := X) hy D s = fy z.2
      rw [divisorModuleFiberJumpEvaluation_apply]
      exact hsy

/-- At two distinct points, the two-dimensional section drop is equivalent to
surjectivity of simultaneous evaluation in the ordinary divisor-module fibers. -/
theorem h0_sub_h0_twoDevissage_eq_two_iff_twoPointFiberEvaluation_surjective
    {x y : X.left} (hx : x ≠ genericPoint X.left)
    (hy : y ≠ genericPoint X.left) (hxy : x ≠ y)
    (D : CurveDivisor k X) :
    (CategoryTheory.Sheaf.h0 (divisorSheaf D) : ℤ) -
        CategoryTheory.Sheaf.h0
          (divisorSheaf (CurveDivisor.devissageDivisor hy
            (CurveDivisor.devissageDivisor hx D))) = 2 ↔
      Function.Surjective (divisorModuleTwoPointFiberEvaluation D x y) := by
  rw [divisorModuleTwoPointFiberEvaluation_surjective_iff hx hy D]
  exact
    h0_sub_h0_twoDevissage_eq_two_iff_twoPointJumpEvaluation_surjective
      hx hy hxy D

/-- A numerically very ample divisor module separates every pair of distinct
points by simultaneous ordinary-fiber evaluation. -/
theorem divisorModuleTwoPointFiberEvaluation_surjective_of_veryAmple
    {D : CurveDivisor k X} (hD : VeryAmpleLinearSystem D)
    {x y : X.left} (hx : x ≠ genericPoint X.left)
    (hy : y ≠ genericPoint X.left) (hxy : x ≠ y) :
    Function.Surjective (divisorModuleTwoPointFiberEvaluation D x y) :=
  (divisorModuleTwoPointFiberEvaluation_surjective_iff hx hy D).mpr
    (twoPointJumpEvaluation_surjective_of_veryAmple hD hx hy hxy)

end
end Hartshorne
