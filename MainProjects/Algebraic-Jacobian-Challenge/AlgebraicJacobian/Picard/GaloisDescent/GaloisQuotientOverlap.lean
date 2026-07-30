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

/-- The quotient map from the source intersection to its quotient-side overlap. -/
noncomputable def overlapQuotientMap [FiniteDimensional K L]
    (i j : StableAffineOpen ρ) :
    (i.U ⊓ j.U).toScheme ⟶ quotientOverlap ρ i j := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  exact SemilinearGalAction.stableAffineQuotientMapRestrict
    ρ i.stable i.affine inf_le_left (inf_stable ρ i j)

/-- The pairwise overlap projection followed by its chart inclusion is the
ambient affine quotient map restricted from the source overlap. -/
@[reassoc]
theorem overlapQuotientMap_fac [FiniteDimensional K L]
    (i j : StableAffineOpen ρ) :
    overlapQuotientMap ρ i j ≫ quotientOverlapι ρ i j =
      X.homOfLE inf_le_left ≫
        SemilinearGalAction.stableAffineQuotientMap
          ρ i.stable i.affine := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  exact SemilinearGalAction.stableAffineQuotientMapRestrict_fac
    ρ i.stable i.affine inf_le_left (inf_stable ρ i j)

/-- The specified restricted quotient witness on a pairwise overlap. -/
noncomputable def overlapWitness [FiniteDimensional K L] [IsGalois K L]
    (i j : StableAffineOpen ρ) :
    GaloisQuotientWitnessWithProjection (ρ.restrict (inf_stable ρ i j))
      (quotientOverlap ρ i j)
      (quotientOverlapι ρ i j ≫ quotientChartMap ρ i)
      (overlapQuotientMap ρ i j) := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  exact SemilinearGalAction.galoisQuotientWitness_quotientOpenOfStableSubopen
    ρ i.stable i.affine inf_le_left (inf_stable ρ i j)

/-- The source open underlying the triple overlap in chart `i` is stable. -/
theorem triple_stable (i j k : StableAffineOpen ρ) :
    ρ.IsStableOpen ((i.U ⊓ j.U) ⊓ (i.U ⊓ k.U)) := by
  intro γ
  simp only [Scheme.Hom.preimage_inf, i.stable γ, j.stable γ, k.stable γ]

/-- The quotient open corresponding to the triple overlap in chart `i`. -/
noncomputable def quotientTriple (i j k : StableAffineOpen ρ) : Scheme.{u} := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  exact (SemilinearGalAction.quotientOpenOfStableSubopen ρ i.stable
    ((i.U ⊓ j.U) ⊓ (i.U ⊓ k.U))).toScheme

/-- The triple-overlap inclusion into its quotient chart. -/
noncomputable def quotientTripleι (i j k : StableAffineOpen ρ) :
    quotientTriple ρ i j k ⟶ quotientChart ρ i := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  exact (SemilinearGalAction.quotientOpenOfStableSubopen ρ i.stable
    ((i.U ⊓ j.U) ⊓ (i.U ⊓ k.U))).ι

/-- The triple quotient open has the full quotient universal property. -/
theorem isGaloisQuotient_triple [FiniteDimensional K L] [IsGalois K L]
    (i j k : StableAffineOpen ρ) :
    IsGaloisQuotient (ρ.restrict (triple_stable ρ i j k))
      (quotientTripleι ρ i j k ≫ quotientChartMap ρ i) := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  exact SemilinearGalAction.isGaloisQuotient_quotientOpenOfStableSubopen
    ρ i.stable i.affine (le_trans inf_le_left inf_le_left)
      (triple_stable ρ i j k)

/-- The quotient map from the source triple intersection to its quotient open. -/
noncomputable def tripleQuotientMap [FiniteDimensional K L]
    (i j k : StableAffineOpen ρ) :
    ((i.U ⊓ j.U) ⊓ (i.U ⊓ k.U)).toScheme ⟶
      quotientTriple ρ i j k := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  exact SemilinearGalAction.stableAffineQuotientMapRestrict
    ρ i.stable i.affine (le_trans inf_le_left inf_le_left)
      (triple_stable ρ i j k)

/-- The triple-overlap projection followed by its chart inclusion is the
ambient affine quotient map restricted from the source triple intersection. -/
@[reassoc]
theorem tripleQuotientMap_fac [FiniteDimensional K L]
    (i j k : StableAffineOpen ρ) :
    tripleQuotientMap ρ i j k ≫ quotientTripleι ρ i j k =
      X.homOfLE (le_trans inf_le_left inf_le_left) ≫
        SemilinearGalAction.stableAffineQuotientMap
          ρ i.stable i.affine := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  exact SemilinearGalAction.stableAffineQuotientMapRestrict_fac
    ρ i.stable i.affine (le_trans inf_le_left inf_le_left)
      (triple_stable ρ i j k)

/-- The specified restricted quotient witness on a triple overlap. -/
noncomputable def tripleWitness [FiniteDimensional K L] [IsGalois K L]
    (i j k : StableAffineOpen ρ) :
    GaloisQuotientWitnessWithProjection (ρ.restrict (triple_stable ρ i j k))
      (quotientTriple ρ i j k)
      (quotientTripleι ρ i j k ≫ quotientChartMap ρ i)
      (tripleQuotientMap ρ i j k) := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  exact SemilinearGalAction.galoisQuotientWitness_quotientOpenOfStableSubopen
    ρ i.stable i.affine (le_trans inf_le_left inf_le_left)
      (triple_stable ρ i j k)

/-- The triple quotient open in chart `i` lies in its pairwise overlap with
chart `j`. -/
theorem quotientTriple_le_overlapLeft [FiniteDimensional K L]
    (i j k : StableAffineOpen ρ) :
    letI := ρ.sectionsMulSemiringAction i.stable
    letI := SemilinearGalAction.sectionsAlgebra f i.U
    letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
    letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
    letI := ρ.isSemilinear_sections i.stable
    SemilinearGalAction.quotientOpenOfStableSubopen ρ i.stable
        ((i.U ⊓ j.U) ⊓ (i.U ⊓ k.U)) ≤
      SemilinearGalAction.quotientOpenOfStableSubopen ρ i.stable
        (i.U ⊓ j.U) := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  exact SemilinearGalAction.quotientOpenOfStableSubopen_mono
    ρ i.stable i.affine
    (le_trans inf_le_left inf_le_left) inf_le_left inf_le_left
    (triple_stable ρ i j k) (inf_stable ρ i j)

/-- The canonical restriction from a triple quotient open to its left
pairwise overlap. -/
noncomputable def tripleToOverlapLeft [FiniteDimensional K L]
    (i j k : StableAffineOpen ρ) :
    quotientTriple ρ i j k ⟶ quotientOverlap ρ i j := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  unfold quotientTriple quotientOverlap
  exact Scheme.homOfLE _ (quotientTriple_le_overlapLeft ρ i j k)

/-- Restricting a triple quotient open and then including the pairwise overlap
is its original inclusion into the quotient chart. -/
@[reassoc]
theorem tripleToOverlapLeft_fac [FiniteDimensional K L]
    (i j k : StableAffineOpen ρ) :
    tripleToOverlapLeft ρ i j k ≫ quotientOverlapι ρ i j =
      quotientTripleι ρ i j k := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  unfold tripleToOverlapLeft quotientOverlapι quotientTripleι
    quotientOverlap quotientTriple
  exact Scheme.homOfLE_ι _ (quotientTriple_le_overlapLeft ρ i j k)

/-- The pinned triple quotient projection restricts to the pinned pairwise
quotient projection. -/
@[reassoc]
theorem tripleQuotientMap_tripleToOverlapLeft [FiniteDimensional K L]
    (i j k : StableAffineOpen ρ) :
    tripleQuotientMap ρ i j k ≫ tripleToOverlapLeft ρ i j k =
      X.homOfLE inf_le_left ≫ overlapQuotientMap ρ i j := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  rw [← cancel_mono (quotientOverlapι ρ i j)]
  rw [Category.assoc, tripleToOverlapLeft_fac]
  rw [tripleQuotientMap_fac, Category.assoc, overlapQuotientMap_fac]
  rw [← Scheme.homOfLE_homOfLE X
    (show ((i.U ⊓ j.U) ⊓ (i.U ⊓ k.U)) ≤ i.U ⊓ j.U from inf_le_left)
    (show i.U ⊓ j.U ≤ i.U from inf_le_left), Category.assoc]
  rfl

/-- The pullback of two quotient overlaps in a chart is the quotient of their
triple source intersection. -/
noncomputable def pullbackOverlapIsoTriple [FiniteDimensional K L]
    (i j k : StableAffineOpen ρ) :
    pullback (quotientOverlapι ρ i j) (quotientOverlapι ρ i k) ≅
      quotientTriple ρ i j k := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  unfold quotientOverlapι quotientOverlap quotientChart quotientTriple
  let A := SemilinearGalAction.quotientOpenOfStableSubopen
    ρ i.stable (i.U ⊓ j.U)
  let B := SemilinearGalAction.quotientOpenOfStableSubopen
    ρ i.stable (i.U ⊓ k.U)
  let Q := Spec (CommRingCat.of
    (SemilinearAction.invariantsSubalgebra K L Γ(X, i.U)))
  have himage : A.ι ''ᵁ (A.ι ⁻¹ᵁ B) = A ⊓ B := by
    rw [Scheme.Hom.image_preimage_eq_opensRange_inf,
      Scheme.Opens.opensRange_ι]
  have hinf :
      SemilinearGalAction.quotientOpenOfStableSubopen ρ i.stable
          ((i.U ⊓ j.U) ⊓ (i.U ⊓ k.U)) = A ⊓ B :=
    SemilinearGalAction.quotientOpenOfStableSubopen_inf
      ρ i.stable i.affine inf_le_left inf_le_left
      (inf_stable ρ i j) (inf_stable ρ i k)
  exact pullbackRestrictIsoRestrict A.ι B ≪≫
    A.ι.isoImage (A.ι ⁻¹ᵁ B) ≪≫
    Q.isoOfEq himage ≪≫
    Q.isoOfEq hinf.symm

/-- The next cyclic chart's triple quotient is a quotient of the same restricted
action, transported along associativity and commutativity of intersection. -/
theorem isGaloisQuotient_triple_rot [FiniteDimensional K L] [IsGalois K L]
    (i j k : StableAffineOpen ρ) :
    IsGaloisQuotient (ρ.restrict (triple_stable ρ i j k))
      (quotientTripleι ρ j k i ≫ quotientChartMap ρ j) := by
  let eOpen : ((i.U ⊓ j.U) ⊓ (i.U ⊓ k.U)) =
      ((j.U ⊓ k.U) ⊓ (j.U ⊓ i.U)) := by ac_rfl
  let e := X.isoOfEq eOpen
  have hef : e.hom ≫
      (((j.U ⊓ k.U) ⊓ (j.U ⊓ i.U)).ι ≫ f) =
        ((i.U ⊓ j.U) ⊓ (i.U ⊓ k.U)).ι ≫ f := by
    dsimp only [e]
    rw [← Category.assoc, Scheme.isoOfEq_hom_ι]
  exact isGaloisQuotient_congr
    (ρ.restrict (triple_stable ρ i j k))
    (ρ.restrict (triple_stable ρ j k i))
    e hef (SemilinearGalAction.restrict_isoOfEq_isEquivariant ρ _ _ _)
    (isGaloisQuotient_triple ρ j k i)

/-- The next cyclic triple witness, transported to the source triple action. -/
noncomputable def tripleWitnessRot [FiniteDimensional K L] [IsGalois K L]
    (i j k : StableAffineOpen ρ) :
    GaloisQuotientWitnessWithProjection (ρ.restrict (triple_stable ρ i j k))
      (quotientTriple ρ j k i)
      (quotientTripleι ρ j k i ≫ quotientChartMap ρ j)
      ((X.isoOfEq (show ((i.U ⊓ j.U) ⊓ (i.U ⊓ k.U)) =
        ((j.U ⊓ k.U) ⊓ (j.U ⊓ i.U)) by ac_rfl)).hom ≫
          tripleQuotientMap ρ j k i) := by
  let eOpen : ((i.U ⊓ j.U) ⊓ (i.U ⊓ k.U)) =
      ((j.U ⊓ k.U) ⊓ (j.U ⊓ i.U)) := by ac_rfl
  let e := X.isoOfEq eOpen
  have hef : e.hom ≫
      (((j.U ⊓ k.U) ⊓ (j.U ⊓ i.U)).ι ≫ f) =
        ((i.U ⊓ j.U) ⊓ (i.U ⊓ k.U)).ι ≫ f := by
    dsimp only [e]
    rw [← Category.assoc, Scheme.isoOfEq_hom_ι]
  exact GaloisQuotientWitnessWithProjection.transport
    (ρ.restrict (triple_stable ρ i j k))
    (ρ.restrict (triple_stable ρ j k i))
    e hef (SemilinearGalAction.restrict_isoOfEq_isEquivariant ρ _ _ _)
    (tripleWitness ρ j k i)

/-- The canonical cyclic comparison between two presentations of a triple
quotient overlap. -/
noncomputable def tripleIso [FiniteDimensional K L] [IsGalois K L]
    (i j k : StableAffineOpen ρ) :
    quotientTriple ρ i j k ≅ quotientTriple ρ j k i :=
  GaloisQuotientWitness.uniqueIso
    (tripleWitness ρ i j k).toGaloisQuotientWitness
    (tripleWitnessRot ρ i j k).toGaloisQuotientWitness

/-- The triple-overlap transition in the shape required by
`CategoryTheory.GlueData.t'`. -/
noncomputable def overlapTransition' [FiniteDimensional K L] [IsGalois K L]
    (i j k : StableAffineOpen ρ) :
    pullback (quotientOverlapι ρ i j) (quotientOverlapι ρ i k) ⟶
      pullback (quotientOverlapι ρ j k) (quotientOverlapι ρ j i) :=
  (pullbackOverlapIsoTriple ρ i j k).hom ≫
    (tripleIso ρ i j k).hom ≫
    (pullbackOverlapIsoTriple ρ j k i).inv

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

/-- The reversed pairwise overlap witness, transported to the same restricted
action as `overlapWitness ρ i j`. -/
noncomputable def overlapWitnessRev [FiniteDimensional K L] [IsGalois K L]
    (i j : StableAffineOpen ρ) :
    GaloisQuotientWitnessWithProjection (ρ.restrict (inf_stable ρ i j))
      (quotientOverlap ρ j i)
      (quotientOverlapι ρ j i ≫ quotientChartMap ρ j)
      ((X.isoOfEq (inf_comm i.U j.U)).hom ≫ overlapQuotientMap ρ j i) := by
  let e := X.isoOfEq (inf_comm i.U j.U)
  have hef : e.hom ≫ ((j.U ⊓ i.U).ι ≫ f) = (i.U ⊓ j.U).ι ≫ f := by
    dsimp only [e]
    rw [← Category.assoc, Scheme.isoOfEq_hom_ι]
  exact GaloisQuotientWitnessWithProjection.transport
    (ρ.restrict (inf_stable ρ i j)) (ρ.restrict (inf_stable ρ j i))
    e hef (SemilinearGalAction.restrict_isoOfEq_isEquivariant ρ _ _ _)
    (overlapWitness ρ j i)

/-- The canonical transition isomorphism between the two quotient presentations
of an overlap. -/
noncomputable def overlapIso [FiniteDimensional K L] [IsGalois K L]
    (i j : StableAffineOpen ρ) :
    quotientOverlap ρ i j ≅ quotientOverlap ρ j i := by
  classical
  by_cases h : i = j
  · subst j
    exact Iso.refl _
  · exact GaloisQuotientWitness.uniqueIso
      (overlapWitness ρ i j).toGaloisQuotientWitness
      (overlapWitnessRev ρ i j).toGaloisQuotientWitness

/-- The overlap transition intertwines the two pinned quotient projections. -/
@[reassoc]
theorem overlapIso_hom_quotientMap [FiniteDimensional K L] [IsGalois K L]
    (i j : StableAffineOpen ρ) :
    overlapQuotientMap ρ i j ≫ (overlapIso ρ i j).hom =
      (X.isoOfEq (inf_comm i.U j.U)).hom ≫
        overlapQuotientMap ρ j i := by
  classical
  by_cases h : i = j
  · subst j
    simp [overlapIso]
  · simpa [overlapIso, h, GaloisQuotientWitness.uniqueIso] using
      GaloisQuotientWitness.comparison_quotientMap
        (overlapWitness ρ i j) (overlapWitnessRev ρ i j)

/-- The overlap transition lies over `Spec K`. -/
@[reassoc]
theorem overlapIso_hom_base [FiniteDimensional K L] [IsGalois K L]
    (i j : StableAffineOpen ρ) :
    (overlapIso ρ i j).hom ≫
        (quotientOverlapι ρ j i ≫ quotientChartMap ρ j) =
      quotientOverlapι ρ i j ≫ quotientChartMap ρ i := by
  classical
  by_cases h : i = j
  · subst j
    simp [overlapIso]
  · simpa [overlapIso, h, GaloisQuotientWitness.uniqueIso] using
      (GaloisQuotientWitness.comparison
        (overlapWitness ρ i j).toGaloisQuotientWitness
        (overlapWitnessRev ρ i j).toGaloisQuotientWitness).2

/-- The self-transition is the identity. -/
@[simp]
theorem overlapIso_self [FiniteDimensional K L] [IsGalois K L]
    (i : StableAffineOpen ρ) : overlapIso ρ i i = Iso.refl _ := by
  simp [overlapIso]

end StableAffineOpen

end AlgebraicJacobian.GaloisDescent
