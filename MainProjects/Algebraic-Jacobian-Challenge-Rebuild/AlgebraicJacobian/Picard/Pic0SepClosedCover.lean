/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/

import AlgebraicJacobian.Picard.Pic0RankOneTranslatedCover
import AlgebraicJacobian.Curve.SepPointsDense
import AlgebraicJacobian.Tangent.TangentIdentitySection
import AlgebraicJacobian.RiemannRoch.ClosedPoint

/-!
# Rational-point residue bridge for the translated cover

The density oracle used by the translated-cover drop has to record residue degree one at the
chosen points.  This file supplies that arithmetic bridge from the actual section certificate,
rather than adding `residueDeg = 1` as an unrelated existential field.  The relative specialization
is the exact point produced by `Over.rationalPointBaseChange`.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory
open TopologicalSpace Opposite

namespace AlgebraicGeometry

attribute [local instance 10000] relCurve.instOver

/-! ## Sections have residue degree one -/

theorem residueDeg_one_of_section
    {K : Type u} [Field K]
    {X : Over (Spec (CommRingCat.of K))}
    {e : Spec (CommRingCat.of K) ⟶ X.left}
    (he : e ≫ X.hom = 𝟙 (Spec (CommRingCat.of K)))
    {x : X.left}
    (hx : e.base (IsLocalRing.closedPoint K) = x) :
    X.left.residueDeg K x = 1 := by
  letI : Algebra K (X.left.presheaf.stalk x) := stalkAlgebra X.hom x
  have h := bijective_algebraMap_residueField_of_section X he hx
  have hmap :
      algebraMap K (IsLocalRing.ResidueField (X.left.presheaf.stalk x)) =
        X.left.residueOverAlgebraMap K x := by
    ext c
    rw [IsScalarTower.algebraMap_apply K (X.left.presheaf.stalk x)
      (IsLocalRing.ResidueField (X.left.presheaf.stalk x)),
      IsLocalRing.ResidueField.algebraMap_eq, Scheme.residueOverAlgebraMap,
      algebraMap_overStalkAlgebra]
    simp [stalkStructureHom, Scheme.overAlgebraMap]
    rfl
  letI : Algebra K (X.left.residueField x) :=
    (X.left.residueOverAlgebraMap K x).toAlgebra
  unfold Scheme.residueDeg
  change Module.finrank K (X.left.residueField x) = 1
  apply Module.finrank_of_bijective_algebraMap
  change Function.Bijective (X.left.residueOverAlgebraMap K x)
  rw [← hmap]
  exact h

/-! ## The base-changed rational point is such a section -/

theorem residueDeg_one_of_rationalPointBaseChange
    {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    (L : Type u) [Field L] [Algebra k L]
    (p : Spec (.of k) ⟶ C.left)
    (hp : p ≫ C.hom = 𝟙 (Spec (.of k))) :
    ((C ⊗ overSpec k L).left).residueDeg L
      ((Over.rationalPointBaseChange C L p hp).base (IsLocalRing.closedPoint L)) = 1 := by
  apply residueDeg_one_of_section
    (X := Over.mk (snd C (overSpec k L)).left)
    (e := Over.rationalPointBaseChange C L p hp)
  · exact Over.rationalPointBaseChange_snd C L p hp
  · rfl

/-! ## Image-set packaging -/

theorem residueDeg_one_of_mem_rationalPointBaseChange_image
    {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    (L : Type u) [Field L] [Algebra k L]
    (P : Set (relCurve C L))
    (hP : ∀ x ∈ P, ∃ (p : Spec (.of k) ⟶ C.left)
      (hp : p ≫ C.hom = 𝟙 (Spec (.of k))),
      (Over.rationalPointBaseChange C L p hp).base (IsLocalRing.closedPoint L) = x) :
    ∀ x ∈ P, (relCurve C L).residueDeg L x = 1 := by
  intro x hx
  obtain ⟨p, hp, hpx⟩ := hP x hx
  rw [← hpx]
  exact residueDeg_one_of_rationalPointBaseChange C L p hp

/-! ## The dense point image used by the drop oracle -/

/-- The points obtained by base-changing actual `k`-rational sections of `C` to `L`.

The section certificate is retained in the membership predicate, so later consumers can recover
the base point and its exact residue-degree proof.  This is deliberately an image set, rather
than an existential carrier unrelated to the chosen curve and extension. -/
def rationalPointBaseChangeImage
    {k : Type u} [Field k] (C : Over (Spec (.of k)))
    (L : Type u) [Field L] [Algebra k L] : Set (relCurve C L) :=
  {x | ∃ (p : Spec (.of k) ⟶ C.left)
      (hp : p ≫ C.hom = 𝟙 (Spec (.of k))),
      (Over.rationalPointBaseChange C L p hp).base
        (IsLocalRing.closedPoint L) = x}

/-- Base-changed `k`-rational points are dense over a separably closed base. -/
theorem dense_rationalPointBaseChangeImage
    {k : Type u} [Field k] [IsSepClosed k]
    (C : Over (Spec (.of k)))
    (L : Type u) [Field L] [Algebra k L]
    [SmoothOfRelativeDimension 1 C.hom] [IsIntegral C.left]
    (U : (relCurve C L).Opens)
    (hU : (U : Set (relCurve C L)).Nonempty) :
    (rationalPointBaseChangeImage C L ∩ U).Nonempty := by
  obtain ⟨p, hp, hmem⟩ := Over.dense_baseChange_rationalPoints C L U hU
  exact ⟨_, ⟨⟨p, hp, rfl⟩, hmem⟩⟩

/-- Every point in the dense image has residue degree one, by its retained section certificate. -/
theorem residueDeg_one_of_mem_rationalPointBaseChangeImage'
    {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    (L : Type u) [Field L] [Algebra k L] :
    ∀ x ∈ rationalPointBaseChangeImage C L,
      (relCurve C L).residueDeg L x = 1 := by
  intro x hx
  obtain ⟨p, hp, hpx⟩ := hx
  rw [← hpx]
  exact residueDeg_one_of_rationalPointBaseChange C L p hp

end AlgebraicGeometry
