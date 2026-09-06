/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4DivisorFiberBridge
import HartshorneLib.Chapter4JumpDimension

/-!
# Surjectivity of the divisor-module stalk and its ordinary fiber jump

Every element of the intrinsic point lattice is represented by a bounded
divisor section on a neighborhood of the point.  Consequently the divisor
module stalk maps onto the local jump quotient, and the additive jump map
descends onto the ordinary fiber.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry

namespace Hartshorne

noncomputable section

attribute [local instance] functionFieldOverModule Scheme.overModule
attribute [local instance] Scheme.Modules.stalkModule

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]

/-! ## Stalk image -/

lemma stalkValPointLattice_surjective {x : X.left} (hx : x ≠ genericPoint X.left)
    (D : CurveDivisor k X) :
    Function.Surjective (stalkValPointLattice (X := X) hx D) := by
  intro g
  by_cases hg0 : (g : X.left.functionField) = 0
  · refine ⟨0, ?_⟩
    apply Subtype.ext
    change stalkVal D x (0 : Scheme.Modules.Stalk (divisorModule D) x) =
      (g : X.left.functionField)
    rw [map_zero, hg0]
  · let r : X.left.functionField := (g : X.left.functionField)
    let gu : X.left.functionFieldˣ := Units.mk0 r hg0
    have hgu : (gu : X.left.functionField) = r := rfl
    let Bad : Set X.left := {z | ∃ (hz : z ≠ genericPoint X.left),
      ¬ (orderAt X.hom hz r ≤ divisorBound D hz)}
    have hBadFinite : Bad.Finite := by
      apply Set.Finite.subset
        ((orderZAt_support_finite X.hom gu).image Subtype.val |>.union
          ((show PointDivisor X.left from D).support.finite_toSet.image Subtype.val))
      intro z hz
      obtain ⟨hzne, hzbad⟩ := hz
      by_contra houtside
      simp only [Set.mem_union, not_or] at houtside
      obtain ⟨horderSupport, hdivisorSupport⟩ := houtside
      have horderZ : orderZAt X.hom hzne gu = 1 := by
        by_contra hne
        exact horderSupport ⟨⟨z, hzne⟩, hne, rfl⟩
      have hcoeff : (show PointDivisor X.left from D).toFun ⟨z, hzne⟩ = 0 := by
        by_contra hne
        exact hdivisorSupport
          ⟨⟨z, hzne⟩, Finsupp.mem_support_iff.mpr hne, rfl⟩
      have hcoeffAt : CurveDivisor.coeffAt hzne D = 0 := by
        change (show PointDivisor X.left from D).toFun ⟨z, hzne⟩ = 0
        exact hcoeff
      apply hzbad
      have horder : orderAt X.hom hzne r = 1 := by
        rw [← hgu, ← orderZAt_eq_one_iff]
        exact horderZ
      rw [divisorBound_eq_coeffAt, horder, hcoeffAt]
      simp
    have hBadClosed : IsClosed Bad := by
      rw [← Set.biUnion_of_singleton Bad]
      exact hBadFinite.isClosed_biUnion
        (fun z hz => smoothCurve_isClosed_singleton_of_ne_genericPoint X.hom hz.choose)
    let W : X.left.Opens := ⟨Badᶜ, hBadClosed.isOpen_compl⟩
    have hgBound : orderAt X.hom hx r ≤ divisorBound D hx := by
      rw [divisorBound_eq_coeffAt]
      exact (mem_pointLattice (X := X) hx).mp g.property
    have hxBad : x ∉ Bad := by
      rintro ⟨_, hbad⟩
      exact hbad hgBound
    have hxW : x ∈ W := hxBad
    have hWne : (W : Set X.left).Nonempty := ⟨x, hxW⟩
    have hrmem : r ∈ divisorSections D W := by
      rw [mem_divisorSections_of_nonempty hWne]
      intro z hz hzW
      by_contra h
      exact hzW ⟨hz, h⟩
    let s : (divisorModule D).val.presheaf.obj (op W) := ⟨r, hrmem⟩
    refine ⟨ConcreteCategory.hom
      (TopCat.Presheaf.germ (divisorModule D).val.presheaf W x hxW) s, ?_⟩
    apply Subtype.ext
    change stalkVal D x
      (ConcreteCategory.hom
        (TopCat.Presheaf.germ (divisorModule D).val.presheaf W x hxW) s) = r
    rw [stalkVal_germ D x W hxW s]

/-! ## The intrinsic jump -/

lemma stalkJump_surjective {x : X.left} (hx : x ≠ genericPoint X.left)
    (D : CurveDivisor k X) :
    Function.Surjective (stalkJump (X := X) hx D) := by
  intro q
  let P := (pointLattice (X := X) hx (CurveDivisor.coeffAt hx D - 1)).submoduleOf
    (pointLattice (X := X) hx (CurveDivisor.coeffAt hx D))
  obtain ⟨g, hg⟩ := Submodule.Quotient.mk_surjective P q
  obtain ⟨m, hm⟩ := stalkValPointLattice_surjective (X := X) hx D g
  refine ⟨m, ?_⟩
  change Submodule.Quotient.mk (stalkValPointLattice hx D m) = q
  rw [hm, hg]

/-! ## The ordinary fiber -/

noncomputable def stalkJumpFiberAddHom_of_divisorModule {x : X.left}
    (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X) :
    Scheme.Modules.stalkFiber (divisorModule D) x →+ jumpModule hx D :=
  stalkJumpFiberAddHom hx D (stalkJump_zero_of_mem_divisorStalkMaximalAction hx D)

@[simp]
lemma stalkJumpFiberAddHom_of_divisorModule_one_tmul {x : X.left}
    (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X)
    (m : Scheme.Modules.Stalk (divisorModule D) x) :
    stalkJumpFiberAddHom_of_divisorModule (X := X) hx D
        (1 ⊗ₜ[X.left.presheaf.stalk x] m) = stalkJump hx D m := by
  exact stalkJumpFiberAddHom_one_tmul hx D
    (stalkJump_zero_of_mem_divisorStalkMaximalAction hx D) m

lemma stalkJumpFiberAddHom_of_divisorModule_fiberEvaluation {x : X.left}
    (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X)
    (s : Γ(divisorModule D, (⊤ : X.left.Opens))) :
    stalkJumpFiberAddHom_of_divisorModule (X := X) hx D
        (Scheme.Modules.fiberEvaluation (divisorModule D) x s) =
      stalkJump hx D
        (ConcreteCategory.hom
          (TopCat.Presheaf.germ (divisorModule D).val.presheaf
            (⊤ : X.left.Opens) x trivial) s) := by
  exact stalkJumpFiberAddHom_fiberEvaluation hx D
    (stalkJump_zero_of_mem_divisorStalkMaximalAction hx D) s

lemma stalkJumpFiberAddHom_of_divisorModule_surjective {x : X.left}
    (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X) :
    Function.Surjective (stalkJumpFiberAddHom_of_divisorModule (X := X) hx D) := by
  intro q
  obtain ⟨m, hm⟩ := stalkJump_surjective (X := X) hx D q
  refine ⟨divisorStalkFiberClass (X := X) D m, ?_⟩
  change stalkJumpFiberAddHom hx D
      (stalkJump_zero_of_mem_divisorStalkMaximalAction hx D)
      (divisorStalkFiberClass (X := X) D m) = q
  calc
    stalkJumpFiberAddHom hx D
        (stalkJump_zero_of_mem_divisorStalkMaximalAction hx D)
        (divisorStalkFiberClass (X := X) D m) = stalkJump hx D m := by
      exact congrArg (fun f => f m)
        (stalkJumpFiberAddHom_comp_divisorStalkFiberClass (X := X) hx D
          (stalkJump_zero_of_mem_divisorStalkMaximalAction hx D))
    _ = q := hm

end
end Hartshorne
