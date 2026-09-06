/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorModules
import AlgebraicJacobian.Picard.LineBundlePullback

/-!
# Local triviality of divisor modules

Uniformizer powers give local principal equations for curve divisors.
Multiplication by these equations trivializes the corresponding modules
over affine neighborhoods.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace

namespace AlgebraicGeometry.Scheme

attribute [local instance] functionFieldOverModule overModule divisorSectionsModule

variable (K : Type u) [Field K] {X : Scheme.{u}}
  [X.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]
  [LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (X ↘ Spec (CommRingCat.of K))]

omit [LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (X ↘ Spec (CommRingCat.of K))] in
/-- Divisors with equal coefficients on an open have the same rational sections there. -/
lemma divisorSections_eq_of_coeffAt_eq_on (D E : X.CurveDivisor) (U : X.Opens)
    (hDE : ∀ (z : X) (hz : z ≠ genericPoint X), z ∈ U → coeffAt hz D = coeffAt hz E) :
    divisorSections K D U = divisorSections K E U := by
  by_cases hU : (U : Set X).Nonempty
  · rw [divisorSections_of_nonempty K hU, divisorSections_of_nonempty K hU]
    ext g
    simp only [mem_boundedSections]
    have hb (z : X) (hz : z ≠ genericPoint X) (hzU : z ∈ U) :
        divisorBound D hz = divisorBound E hz := by
      rw [divisorBound_eq_coeffAt, divisorBound_eq_coeffAt, hDE z hz hzU]
    exact ⟨fun hg z hz hzU => (hb z hz hzU) ▸ hg z hz hzU,
      fun hg z hz hzU => (hb z hz hzU).symm ▸ hg z hz hzU⟩
  · rw [divisorSections_of_empty K hU, divisorSections_of_empty K hU]

/-- Local coefficient equality acts by the identity on rational section representatives. -/
noncomputable def restrictDivisorModulesAppOfCoeffAtEqOn
    (D E : X.CurveDivisor) (W : X.Opens)
    (hDE : ∀ (z : X) (hz : z ≠ genericPoint X), z ∈ W → coeffAt hz D = coeffAt hz E)
    (V : W.toScheme.Opens) :
    Γ((Modules.restrictFunctor W.ι).obj (divisorModules K D), V) →ₗ[Γ(W.toScheme, V)]
      Γ((Modules.restrictFunctor W.ι).obj (divisorModules K E), V) := by
  let e := LinearEquiv.ofEq (divisorSections K D (W.ι ''ᵁ V))
    (divisorSections K E (W.ι ''ᵁ V))
    (divisorSections_eq_of_coeffAt_eq_on K D E (W.ι ''ᵁ V)
      (fun z hz hzV => hDE z hz (W.ι_image_le V hzV)))
  refine { toFun := e, map_add' := e.map_add, map_smul' := ?_ }
  intro r s
  change e (QcohOn.qsmul (F := X.divisorSheaf K D) le_rfl
      ((W.ι.appIso V).inv r) s) =
    QcohOn.qsmul (F := X.divisorSheaf K E) le_rfl ((W.ι.appIso V).inv r) (e s)
  by_cases hV : ((W.ι ''ᵁ V : X.Opens) : Set X).Nonempty
  · apply divisorSection_ext K
    have he (t : divisorSections K D (W.ι ''ᵁ V)) :
        divisorVal K (e t) = divisorVal K t := rfl
    rw [he, divisorVal_qsmul K (genericPoint_mem_of_nonempty hV),
      divisorVal_qsmul K (genericPoint_mem_of_nonempty hV), he]
  · haveI := divisorSections_subsingleton_of_empty K (D := E) hV
    exact Subsingleton.elim _ _

lemma restrictDivisorModulesAppOfCoeffAtEqOn_coe
    (D E : X.CurveDivisor) (W : X.Opens)
    (hDE : ∀ (z : X) (hz : z ≠ genericPoint X), z ∈ W → coeffAt hz D = coeffAt hz E)
    (V : W.toScheme.Opens)
    (s : Γ((Modules.restrictFunctor W.ι).obj (divisorModules K D), V)) :
    ((show divisorSections K E (W.ι ''ᵁ V) from
        restrictDivisorModulesAppOfCoeffAtEqOn K D E W hDE V s) : X.functionField) =
      ((show divisorSections K D (W.ι ''ᵁ V) from s) : X.functionField) := rfl

/-- Local coefficient equality gives a morphism between the restricted divisor modules. -/
noncomputable def restrictDivisorModulesHomOfCoeffAtEqOn
    (D E : X.CurveDivisor) (W : X.Opens)
    (hDE : ∀ (z : X) (hz : z ≠ genericPoint X), z ∈ W → coeffAt hz D = coeffAt hz E) :
    (Modules.restrictFunctor W.ι).obj (divisorModules K D) ⟶
      (Modules.restrictFunctor W.ι).obj (divisorModules K E) where
  val := PresheafOfModules.homMk
    { app := fun V => AddCommGrpCat.ofHom
        (restrictDivisorModulesAppOfCoeffAtEqOn K D E W hDE V.unop).toAddMonoidHom
      naturality := by
        intro U V i
        ext s
        change restrictDivisorModulesAppOfCoeffAtEqOn K D E W hDE V.unop
            (divisorSectionsRes K D (W.ι.image_mono (leOfHom i.unop)) s) =
          divisorSectionsRes K E (W.ι.image_mono (leOfHom i.unop))
            (restrictDivisorModulesAppOfCoeffAtEqOn K D E W hDE U.unop s)
        by_cases hV : ((W.ι ''ᵁ V.unop : X.Opens) : Set X).Nonempty
        · apply Subtype.ext
          rw [restrictDivisorModulesAppOfCoeffAtEqOn_coe,
            divisorSectionsRes_coe K (W.ι.image_mono (leOfHom i.unop)) hV,
            divisorSectionsRes_coe K (W.ι.image_mono (leOfHom i.unop)) hV,
            restrictDivisorModulesAppOfCoeffAtEqOn_coe]
        · haveI := divisorSections_subsingleton_of_empty K (D := E) hV
          exact Subsingleton.elim (α := divisorSections K E (W.ι ''ᵁ V.unop)) _ _ }
    (fun V r s =>
      (restrictDivisorModulesAppOfCoeffAtEqOn K D E W hDE V.unop).map_smul r s)

/-- Divisor modules whose coefficients agree on an open have isomorphic restrictions. -/
noncomputable def restrictDivisorModulesIsoOfCoeffAtEqOn
    (D E : X.CurveDivisor) (W : X.Opens)
    (hDE : ∀ (z : X) (hz : z ≠ genericPoint X), z ∈ W → coeffAt hz D = coeffAt hz E) :
    (Modules.restrictFunctor W.ι).obj (divisorModules K D) ≅
      (Modules.restrictFunctor W.ι).obj (divisorModules K E) := by
  letI : IsIso (restrictDivisorModulesHomOfCoeffAtEqOn K D E W hDE) := by
    rw [Modules.Hom.isIso_iff_isIso_app]
    intro V
    rw [ConcreteCategory.isIso_iff_bijective]
    let e := LinearEquiv.ofEq (divisorSections K D (W.ι ''ᵁ V))
      (divisorSections K E (W.ι ''ᵁ V))
      (divisorSections_eq_of_coeffAt_eq_on K D E (W.ι ''ᵁ V)
        (fun z hz hzV => hDE z hz (W.ι_image_le V hzV)))
    change Function.Bijective (fun s => e s)
    exact e.bijective
  exact asIso (restrictDivisorModulesHomOfCoeffAtEqOn K D E W hDE)

/-- A uniformizer power realizes any prescribed divisor coefficient at a closed point. -/
lemma exists_unit_coeffAt_divOf (D : X.CurveDivisor) {x : X} (hx : x ≠ genericPoint X) :
    ∃ q : X.functionFieldˣ,
      coeffAt hx (divOf (X ↘ Spec (CommRingCat.of K)) q) = coeffAt hx D := by
  let q : X.functionFieldˣ := Units.mk0 (uniformizer K hx ^ coeffAt hx D)
    (zpow_ne_zero _ (uniformizer_ne_zero K hx))
  refine ⟨q, ?_⟩
  have hq : ord (X ↘ Spec (CommRingCat.of K)) hx (q : X.functionField) =
      divisorBound (-D) hx := by
    change ord (X ↘ Spec (CommRingCat.of K)) hx
      (uniformizer K hx ^ coeffAt hx D) = divisorBound (-D) hx
    rw [ord_uniformizer_zpow, divisorBound_eq_coeffAt, CurveDivisor.coeffAt_neg]
  have hb := (ord_val_eq K q hx).symm.trans hq
  rw [divisorBound_eq_coeffAt, divisorBound_eq_coeffAt,
    CurveDivisor.coeffAt_neg, CurveDivisor.coeffAt_neg] at hb
  exact neg_injective (congrArg Multiplicative.toAdd (WithZero.exp_injective hb))

/-- Every divisor is principal on an affine neighborhood of each point of the curve. -/
theorem exists_affineOpen_eq_divOf (D : X.CurveDivisor) (x : X) :
    ∃ (q : X.functionFieldˣ) (W : X.Opens), x ∈ W ∧ IsAffineOpen W ∧
      ∀ (z : X) (hz : z ≠ genericPoint X), z ∈ W →
        coeffAt hz (divOf (X ↘ Spec (CommRingCat.of K)) q) = coeffAt hz D := by
  classical
  obtain ⟨q, hq⟩ : ∃ q : X.functionFieldˣ, ∀ hx : x ≠ genericPoint X,
      coeffAt hx (divOf (X ↘ Spec (CommRingCat.of K)) q) = coeffAt hx D := by
    by_cases hx : x = genericPoint X
    · exact ⟨1, fun h => (h hx).elim⟩
    · obtain ⟨q, hq⟩ := exists_unit_coeffAt_divOf K D hx
      exact ⟨q, fun _ => hq⟩
  let Bad : Set X := {z | ∃ hz : z ≠ genericPoint X,
    coeffAt hz (divOf (X ↘ Spec (CommRingCat.of K)) q) ≠ coeffAt hz D}
  have hfin : Bad.Finite := by
    apply Set.Finite.subset
      ((toFinsupp (divOf (X ↘ Spec (CommRingCat.of K)) q - D)).support.finite_toSet.image
        Subtype.val)
    rintro z ⟨hz, hne⟩
    refine ⟨⟨z, hz⟩, Finsupp.mem_support_iff.mpr ?_, rfl⟩
    change coeffAt hz (divOf (X ↘ Spec (CommRingCat.of K)) q - D) ≠ 0
    rw [CurveDivisor.coeffAt_sub]
    exact sub_ne_zero.mpr hne
  have hclosed : IsClosed Bad := by
    rw [← Set.biUnion_of_singleton Bad]
    exact hfin.isClosed_biUnion (fun z hz =>
      isClosed_singleton_of_ne_genericPoint (X ↘ Spec (CommRingCat.of K)) hz.choose)
  let U : X.Opens := ⟨Badᶜ, hclosed.isOpen_compl⟩
  have hxU : x ∈ U := by
    rintro ⟨hx, hne⟩
    exact hne (hq hx)
  obtain ⟨W, hW, hxW, hWU⟩ := exists_isAffineOpen_mem_and_subset hxU
  refine ⟨q, W, hxW, hW, ?_⟩
  intro z hz hzW
  exact not_not.mp (fun hne => hWU hzW ⟨hz, hne⟩)

/-- A local principal equation trivializes the divisor module. -/
noncomputable def restrictDivisorModulesIsoUnitOfPrincipalization
    (D : X.CurveDivisor) (q : X.functionFieldˣ) (W : X.Opens)
    (hqW : ∀ (z : X) (hz : z ≠ genericPoint X), z ∈ W →
      coeffAt hz (divOf (X ↘ Spec (CommRingCat.of K)) q) = coeffAt hz D) :
    (divisorModules K D).restrict W.ι ≅ SheafOfModules.unit W.toScheme.ringCatSheaf := by
  have hzero : ∀ (z : X) (hz : z ≠ genericPoint X), z ∈ W →
      coeffAt hz (D - divOf (X ↘ Spec (CommRingCat.of K)) q) =
        coeffAt hz (0 : X.CurveDivisor) := by
    intro z hz hzW
    rw [CurveDivisor.coeffAt_sub, hqW z hz hzW, CurveDivisor.coeffAt_zero, sub_self]
  letI : (TopologicalSpace.Opens.map W.ι.base).Final :=
    CategoryTheory.final_of_representablyFlat _
  exact (Modules.restrictFunctor W.ι).mapIso (mulEquivDivisorModules K q D) ≪≫
    restrictDivisorModulesIsoOfCoeffAtEqOn K
      (D - divOf (X ↘ Spec (CommRingCat.of K)) q) 0 W hzero ≪≫
    (Modules.restrictFunctor W.ι).mapIso (divisorModulesZeroIso K) ≪≫
    (Modules.restrictFunctorIsoPullback W.ι).app _ ≪≫
    @asIso _ _ _ _ _ (inferInstance :
      IsIso (SheafOfModules.pullbackObjUnitToUnit W.ι.toRingCatSheafHom))

/-- Divisor modules on a smooth integral curve are locally trivial line bundles. -/
theorem divisorModules_isLocallyTrivial (D : X.CurveDivisor) :
    LineBundle.IsLocallyTrivial (divisorModules K D) := by
  intro x
  obtain ⟨q, W, hxW, hW, hqW⟩ := exists_affineOpen_eq_divOf K D x
  exact ⟨W, hxW, hW, ⟨restrictDivisorModulesIsoUnitOfPrincipalization K D q W hqW⟩⟩

end AlgebraicGeometry.Scheme
