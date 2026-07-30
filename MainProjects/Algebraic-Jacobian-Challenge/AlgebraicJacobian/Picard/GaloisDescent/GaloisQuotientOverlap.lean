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

end StableAffineOpen

end AlgebraicJacobian.GaloisDescent
