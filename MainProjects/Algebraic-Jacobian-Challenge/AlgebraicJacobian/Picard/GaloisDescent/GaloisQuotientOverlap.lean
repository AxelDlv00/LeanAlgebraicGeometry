/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.GaloisDescent.GaloisQuotientRestrict
import AlgebraicJacobian.Picard.GaloisDescent.GaloisQuotientUniqueness
import AlgebraicJacobian.Picard.GaloisQuotientAffineGeneral

/-!
# Overlap charts for a finite Galois quotient

This file packages the invariant-ring quotient charts attached to stable affine
opens and their quotient-side overlaps.  Every overlap carries the full
`IsGaloisQuotient` witness for the restricted action.  The reversed overlap
comparison is then canonical by uniqueness.
-/

open CategoryTheory Limits AlgebraicGeometry TopologicalSpace

namespace AlgebraicJacobian.GaloisDescent

universe u

set_option autoImplicit false

namespace SemilinearGalAction

variable {K L : Type u} [Field K] [Field L] [Algebra K L]
variable {X : Scheme.{u}} {f : X ⟶ Spec (CommRingCat.of L)}
variable (ρ : SemilinearGalAction K L X f)

/-- Equality of stable opens induces an equivariant isomorphism between the
corresponding restricted actions. -/
theorem restrict_isoOfEq_isEquivariant {U V : X.Opens}
    (hU : ρ.IsStableOpen U) (hV : ρ.IsStableOpen V) (e : U = V) :
    (ρ.restrict hU).IsEquivariant (ρ.restrict hV) (X.isoOfEq e).hom := by
  intro γ
  rw [restrict_act_hom, restrict_act_hom]
  rw [← cancel_mono V.ι]
  simp

end SemilinearGalAction

/-- A stable affine open for a fixed semilinear Galois action. -/
structure StableAffineOpen
    {K L : Type u} [Field K] [Field L] [Algebra K L]
    {X : Scheme.{u}} {f : X ⟶ Spec (CommRingCat.of L)}
    (ρ : SemilinearGalAction K L X f) where
  U : X.Opens
  affine : IsAffineOpen U
  stable : ρ.IsStableOpen U

namespace StableAffineOpen

variable {K L : Type u} [Field K] [Field L] [Algebra K L]
variable {X : Scheme.{u}} {f : X ⟶ Spec (CommRingCat.of L)}
variable (ρ : SemilinearGalAction K L X f)

/-- The intersection of two stable opens is stable. -/
theorem inf_stable (i j : StableAffineOpen ρ) :
    ρ.IsStableOpen (i.U ⊓ j.U) := by
  intro γ
  rw [Scheme.Hom.preimage_inf, i.stable γ, j.stable γ]

/-- The affine invariant-ring quotient chart attached to a stable affine open. -/
noncomputable def quotientChart (i : StableAffineOpen ρ) : Scheme.{u} := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  exact Spec (CommRingCat.of
    (SemilinearAction.invariantsSubalgebra K L Γ(X, i.U)))

/-- The structure map of an invariant-ring quotient chart to `Spec K`. -/
noncomputable def quotientChartMap (i : StableAffineOpen ρ) :
    quotientChart ρ i ⟶ Spec (CommRingCat.of K) := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  exact Spec.map (CommRingCat.ofHom
    (algebraMap K (SemilinearAction.invariantsSubalgebra K L Γ(X, i.U))))

/-- The quotient-side overlap in chart `i` corresponding to `i.U ⊓ j.U`. -/
noncomputable def quotientOverlap (i j : StableAffineOpen ρ) : Scheme.{u} := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  exact (SemilinearGalAction.quotientOpenOfStableSubopen
    ρ i.stable (i.U ⊓ j.U)).toScheme

/-- The overlap inclusion into its quotient chart. -/
noncomputable def quotientOverlapι (i j : StableAffineOpen ρ) :
    quotientOverlap ρ i j ⟶ quotientChart ρ i := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  exact (SemilinearGalAction.quotientOpenOfStableSubopen
    ρ i.stable (i.U ⊓ j.U)).ι

instance quotientOverlapι_isOpenImmersion (i j : StableAffineOpen ρ) :
    IsOpenImmersion (quotientOverlapι ρ i j) := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  unfold quotientOverlapι quotientOverlap quotientChart
  infer_instance

/-- Each quotient-side overlap represents the full Galois quotient of the
restricted action on the corresponding source overlap. -/
theorem isGaloisQuotient_overlap [FiniteDimensional K L] [IsGalois K L]
    (i j : StableAffineOpen ρ) :
    IsGaloisQuotient (ρ.restrict (inf_stable ρ i j))
      (quotientOverlapι ρ i j ≫ quotientChartMap ρ i) := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  exact SemilinearGalAction.isGaloisQuotient_quotientOpenOfStableSubopen
    ρ i.stable i.affine inf_le_left (inf_stable ρ i j)

/-- The quotient constructed from the reversed chart is also a quotient of the
restriction to `i.U ⊓ j.U`, transported along commutativity of intersection. -/
theorem isGaloisQuotient_overlap_rev [FiniteDimensional K L] [IsGalois K L]
    (i j : StableAffineOpen ρ) :
    IsGaloisQuotient (ρ.restrict (inf_stable ρ i j))
      (quotientOverlapι ρ j i ≫ quotientChartMap ρ j) := by
  let e := X.isoOfEq (inf_comm i.U j.U)
  have hef : e.hom ≫ ((j.U ⊓ i.U).ι ≫ f) = (i.U ⊓ j.U).ι ≫ f := by
    dsimp only [e]
    rw [← Category.assoc, Scheme.isoOfEq_hom_ι]
  exact isGaloisQuotient_congr
    (ρ.restrict (inf_stable ρ i j)) (ρ.restrict (inf_stable ρ j i))
    e hef (SemilinearGalAction.restrict_isoOfEq_isEquivariant ρ _ _ _)
    (isGaloisQuotient_overlap ρ j i)

/-- The canonical transition isomorphism between the two quotient presentations
of an overlap. -/
noncomputable def overlapIso [FiniteDimensional K L] [IsGalois K L]
    (i j : StableAffineOpen ρ) :
    quotientOverlap ρ i j ≅ quotientOverlap ρ j i :=
  quotientUniqueIso (ρ.restrict (inf_stable ρ i j))
    (isGaloisQuotient_overlap ρ i j)
    (isGaloisQuotient_overlap_rev ρ i j)

/-- The overlap transition lies over `Spec K`. -/
@[reassoc]
theorem overlapIso_hom_base [FiniteDimensional K L] [IsGalois K L]
    (i j : StableAffineOpen ρ) :
    (overlapIso ρ i j).hom ≫
        (quotientOverlapι ρ j i ≫ quotientChartMap ρ j) =
      quotientOverlapι ρ i j ≫ quotientChartMap ρ i :=
  quotientUniqueIso_hom_base (ρ.restrict (inf_stable ρ i j))
    (isGaloisQuotient_overlap ρ i j)
    (isGaloisQuotient_overlap_rev ρ i j)

/-- The self-transition is the identity. -/
@[simp]
theorem overlapIso_self [FiniteDimensional K L] [IsGalois K L]
    (i : StableAffineOpen ρ) : overlapIso ρ i i = Iso.refl _ := by
  have hproof : isGaloisQuotient_overlap_rev ρ i i =
      isGaloisQuotient_overlap ρ i i := Subsingleton.elim _ _
  rw [overlapIso, hproof, quotientUniqueIso_self]

end StableAffineOpen

end AlgebraicJacobian.GaloisDescent
