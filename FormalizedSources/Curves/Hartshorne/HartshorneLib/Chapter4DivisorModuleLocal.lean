/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4BasePointFreeDenominatorOpen
import HartshorneLib.Chapter4CurvePointWitness
import HartshorneLib.Chapter4DivisorModuleMul

/-!
# Local triviality of divisor modules

Divisor sections depend only on the divisor coefficients in the open on which
they are evaluated. This gives an isomorphism between restrictions of divisor
modules whose coefficients agree locally. Combining that comparison with local
principalization and multiplication by a rational function proves that every
divisor module on a smooth proper curve is a line bundle.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry

namespace Hartshorne

noncomputable section

attribute [local instance] functionFieldOverModule Scheme.overModule

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]

/-- Divisors with equal coefficients throughout an open have the same bounded
rational sections on that open. -/
lemma divisorSections_eq_of_coeffAt_eq_on
    (D E : CurveDivisor k X) (U : X.left.Opens)
    (hDE : ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ U →
      CurveDivisor.coeffAt hz D = CurveDivisor.coeffAt hz E) :
    divisorSections D U = divisorSections E U := by
  by_cases hU : (U : Set X.left).Nonempty
  · rw [divisorSections_of_nonempty hU, divisorSections_of_nonempty hU]
    ext g
    simp only [mem_boundedSections]
    constructor
    · intro hg z hz hzU
      have hb : divisorBound D hz = divisorBound E hz := by
        rw [divisorBound_eq_coeffAt hz D, divisorBound_eq_coeffAt hz E,
          hDE z hz hzU]
      rw [← hb]
      exact hg z hz hzU
    · intro hg z hz hzU
      have hb : divisorBound D hz = divisorBound E hz := by
        rw [divisorBound_eq_coeffAt hz D, divisorBound_eq_coeffAt hz E,
          hDE z hz hzU]
      rw [hb]
      exact hg z hz hzU
  · rw [divisorSections_of_empty hU, divisorSections_of_empty hU]

/-- The identity on rational-function representatives gives a linear map
between restricted divisor sections when the coefficients agree on the
ambient open. -/
noncomputable def restrictDivisorModuleAppOfCoeffAtEqOn
    (D E : CurveDivisor k X) (W : X.left.Opens)
    (hDE : ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ W →
      CurveDivisor.coeffAt hz D = CurveDivisor.coeffAt hz E)
    (V : W.toScheme.Opens) :
    Γ((Scheme.Modules.restrictFunctor W.ι).obj (divisorModule D), V) →ₗ[Γ(W.toScheme, V)]
      Γ((Scheme.Modules.restrictFunctor W.ι).obj (divisorModule E), V) := by
  have hsections : divisorSections D (W.ι ''ᵁ V) =
      divisorSections E (W.ι ''ᵁ V) :=
    divisorSections_eq_of_coeffAt_eq_on D E (W.ι ''ᵁ V)
      (fun z hz hzV ↦ hDE z hz (W.ι_image_le V hzV))
  let e := LinearEquiv.ofEq
    (divisorSections D (W.ι ''ᵁ V))
    (divisorSections E (W.ι ''ᵁ V)) hsections
  exact
    { toFun := e
      map_add' := e.map_add
      map_smul' := by
        intro r s
        by_cases hV : ((W.ι ''ᵁ V : X.left.Opens) : Set X.left).Nonempty
        · apply Subtype.ext
          change ((e (divisorSectionAction D (W.ι ''ᵁ V)
              ((W.ι.appIso V).inv r) s) : divisorSections E (W.ι ''ᵁ V)) :
                X.left.functionField) =
            ((divisorSectionAction E (W.ι ''ᵁ V)
              ((W.ι.appIso V).inv r) (e s) :
                divisorSections E (W.ι ''ᵁ V)) : X.left.functionField)
          have hecoe (t : divisorSections D (W.ι ''ᵁ V)) :
              ((e t : divisorSections E (W.ι ''ᵁ V)) :
                X.left.functionField) = (t : X.left.functionField) := by
            rfl
          rw [hecoe, divisorSectionAction_coe_of_nonempty D (W.ι ''ᵁ V) hV,
            divisorSectionAction_coe_of_nonempty E (W.ι ''ᵁ V) hV]
          rw [hecoe]
        · letI := divisorSections_subsingleton_of_empty (D := E) hV
          change e (divisorSectionAction D (W.ι ''ᵁ V)
              ((W.ι.appIso V).inv r) s) =
            divisorSectionAction E (W.ι ''ᵁ V)
              ((W.ι.appIso V).inv r) (e s)
          exact Subsingleton.elim _ _ }

lemma restrictDivisorModuleAppOfCoeffAtEqOn_coe
    (D E : CurveDivisor k X) (W : X.left.Opens)
    (hDE : ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ W →
      CurveDivisor.coeffAt hz D = CurveDivisor.coeffAt hz E)
    (V : W.toScheme.Opens)
    (s : Γ((Scheme.Modules.restrictFunctor W.ι).obj (divisorModule D), V)) :
    ((show divisorSections E (W.ι ''ᵁ V) from
        restrictDivisorModuleAppOfCoeffAtEqOn D E W hDE V s) :
      X.left.functionField) =
      ((show divisorSections D (W.ι ''ᵁ V) from s) :
        X.left.functionField) := by
  rfl

/-- The restricted-module morphism induced by local coefficient equality. -/
noncomputable def restrictDivisorModuleHomOfCoeffAtEqOn
    (D E : CurveDivisor k X) (W : X.left.Opens)
    (hDE : ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ W →
      CurveDivisor.coeffAt hz D = CurveDivisor.coeffAt hz E) :
    (Scheme.Modules.restrictFunctor W.ι).obj (divisorModule D) ⟶
      (Scheme.Modules.restrictFunctor W.ι).obj (divisorModule E) where
  val := PresheafOfModules.homMk
    { app := fun V ↦ AddCommGrpCat.ofHom
        (restrictDivisorModuleAppOfCoeffAtEqOn D E W hDE V.unop).toAddMonoidHom
      naturality := by
        intro U V i
        ext s
        change restrictDivisorModuleAppOfCoeffAtEqOn D E W hDE V.unop
            (divisorSectionsRes D (W.ι.image_mono (leOfHom i.unop)) s) =
          divisorSectionsRes E (W.ι.image_mono (leOfHom i.unop))
            (restrictDivisorModuleAppOfCoeffAtEqOn D E W hDE U.unop s)
        apply Subtype.ext
        by_cases hV : ((W.ι ''ᵁ V.unop : X.left.Opens) : Set X.left).Nonempty
        · rw [restrictDivisorModuleAppOfCoeffAtEqOn_coe,
            divisorSectionsRes_coe (W.ι.image_mono (leOfHom i.unop)) hV,
            divisorSectionsRes_coe (W.ι.image_mono (leOfHom i.unop)) hV]
          rw [restrictDivisorModuleAppOfCoeffAtEqOn_coe]
        · have hV' : ¬ ((Opposite.unop
              ((Scheme.Hom.opensFunctor W.ι).op.obj (op V.unop)) :
                X.left.Opens) : Set X.left).Nonempty := by
            exact hV
          letI := divisorSections_subsingleton_of_empty (D := E) hV'
          exact congrArg Subtype.val (Subsingleton.elim _ _) }
    (fun V r s ↦
      (restrictDivisorModuleAppOfCoeffAtEqOn D E W hDE V.unop).map_smul r s)

lemma restrictDivisorModuleHomOfCoeffAtEqOn_isIso
    (D E : CurveDivisor k X) (W : X.left.Opens)
    (hDE : ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ W →
      CurveDivisor.coeffAt hz D = CurveDivisor.coeffAt hz E) :
    IsIso (restrictDivisorModuleHomOfCoeffAtEqOn D E W hDE) := by
  rw [Scheme.Modules.Hom.isIso_iff_isIso_app]
  intro V
  rw [ConcreteCategory.isIso_iff_bijective]
  change Function.Bijective
    (restrictDivisorModuleAppOfCoeffAtEqOn D E W hDE V)
  let e := LinearEquiv.ofEq
    (divisorSections D (W.ι ''ᵁ V))
    (divisorSections E (W.ι ''ᵁ V))
    (divisorSections_eq_of_coeffAt_eq_on D E (W.ι ''ᵁ V)
      (fun z hz hzV ↦ hDE z hz (W.ι_image_le V hzV)))
  change Function.Bijective (fun s ↦ e s)
  exact e.bijective

/-- Divisor modules whose coefficients agree on `W` have isomorphic
restrictions to `W`. The forward map is identity on rational-function
representatives; no coordinate formula for the packaged inverse is asserted. -/
noncomputable def restrictDivisorModuleIsoOfCoeffAtEqOn
    (D E : CurveDivisor k X) (W : X.left.Opens)
    (hDE : ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ W →
      CurveDivisor.coeffAt hz D = CurveDivisor.coeffAt hz E) :
    (Scheme.Modules.restrictFunctor W.ι).obj (divisorModule D) ≅
      (Scheme.Modules.restrictFunctor W.ι).obj (divisorModule E) := by
  letI := restrictDivisorModuleHomOfCoeffAtEqOn_isIso D E W hDE
  exact asIso (restrictDivisorModuleHomOfCoeffAtEqOn D E W hDE)

/-- A local principalization identifies the restricted divisor module with the
restricted zero-divisor module. This trivialization depends on the specified
`q`; no independence from that choice is asserted. -/
noncomputable def restrictDivisorModuleIsoZeroOfPrincipalization
    (D : CurveDivisor k X) (q : X.left.functionFieldˣ) (W : X.left.Opens)
    (hqW : ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ W →
      CurveDivisor.coeffAt hz (principalDivisor q) =
        CurveDivisor.coeffAt hz D) :
    (Scheme.Modules.restrictFunctor W.ι).obj (divisorModule D) ≅
      (Scheme.Modules.restrictFunctor W.ι).obj
        (divisorModule (0 : CurveDivisor k X)) := by
  have hzero : ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ W →
      CurveDivisor.coeffAt hz (D - principalDivisor q) =
        CurveDivisor.coeffAt hz (0 : CurveDivisor k X) := by
    intro z hz hzW
    rw [CurveDivisor.coeffAt_sub, hqW z hz hzW,
      CurveDivisor.coeffAt_zero, sub_self]
  exact (Scheme.Modules.restrictFunctor W.ι).mapIso
      (mulEquivDivisorModule q D) ≪≫
    restrictDivisorModuleIsoOfCoeffAtEqOn
      (D - principalDivisor q) 0 W hzero

/-- The restricted zero-divisor module is the structure sheaf of the open
subscheme. -/
noncomputable def restrictDivisorModuleZeroIsoUnit (W : X.left.Opens) :
    (Scheme.Modules.restrictFunctor W.ι).obj
        (divisorModule (X := X) (0 : CurveDivisor k X)) ≅
      SheafOfModules.unit W.toScheme.ringCatSheaf :=
  (Scheme.Modules.restrictFunctor W.ι).mapIso
      (divisorModuleZeroIso (k := k) (X := X)).symm ≪≫
    restrictUnitIso W.ι

/-- Local principalization at an arbitrary point, including the generic point.
In the generic-point case a non-generic point supplies a nonempty open, which
also contains the generic point. -/
theorem exists_localRatioOpen_eq_principalDivisor_at
    (D : CurveDivisor k X) (x : X.left) :
    ∃ (q : X.left.functionFieldˣ) (W : LocalRatioOpen X),
      x ∈ W.U ∧
        ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ W.U →
          CurveDivisor.coeffAt hz (principalDivisor q) =
            CurveDivisor.coeffAt hz D := by
  by_cases hx : x = genericPoint X.left
  · obtain ⟨y, hy⟩ := exists_ne_genericPoint_of_smoothCurve X.hom
    obtain ⟨q, W, hyW, hW⟩ :=
      exists_localRatioOpen_eq_principalDivisor D hy
    subst x
    exact ⟨q, W, W.generic_mem, hW⟩
  · exact exists_localRatioOpen_eq_principalDivisor D hx

/-- The module `O_X(D)` of a curve divisor is a line bundle. -/
theorem isLineBundle_divisorModule (D : CurveDivisor k X) :
    IsLineBundle (divisorModule D) := by
  intro x
  obtain ⟨q, W, hxW, hqW⟩ :=
    exists_localRatioOpen_eq_principalDivisor_at D x
  refine ⟨W.U, hxW, ⟨?_⟩⟩
  exact restrictDivisorModuleIsoZeroOfPrincipalization D q W.U hqW ≪≫
    restrictDivisorModuleZeroIsoUnit W.U

end
end Hartshorne
