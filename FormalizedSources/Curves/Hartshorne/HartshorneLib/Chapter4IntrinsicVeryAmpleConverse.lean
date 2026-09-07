/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4ProjectivePullbackIso
import HartshorneLib.Chapter4ProjectiveEmbeddingChartBridge

/-!
# Conditional arbitrary-embedding converse

An embedding defined by a complete section basis can be compared with the
complete-linear-system map through normalized chart restrictions. The
certificate below records these additional hypotheses. An arbitrary embedding
with a pullback isomorphism need not supply a complete basis: even the standard
inclusion of a projective line in a projective plane has a redundant coordinate.
The intrinsic converse therefore requires the finite pulled-back section family.
-/

set_option autoImplicit false

universe u

open CategoryTheory Opposite TopologicalSpace AlgebraicGeometry

namespace Hartshorne.BasePointFreeLocalRatioCover

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X}

/-- Data for an arbitrary projective embedding together with the normalized
chart restrictions needed to compare it with the complete-linear-system map.

The pullback isomorphism and its coordinate-section law record compatibility
with the supplied complete section basis.
The stored basis is a full basis of `H⁰(O(D))`; consequently this is a
conditional complete-linear-system interface, rather than an extraction theorem
for a bare projective embedding.
-/
structure ArbitraryProjectiveEmbeddingCertificate (D : CurveDivisor k X) where
  n : ℕ
  map : X.left ⟶ projectiveSpace k n
  map_over : map ≫ projectiveSpaceStructureMap k n = X.hom
  closedImmersion : IsClosedImmersion map
  basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D)
  hbase : BasePointFreeLinearSystem D
  pullbackIso : (Scheme.Modules.pullback map).obj
      (ProjectiveTwist.twistingSheafOne (k := k) (J := Fin (n + 1))) ≅ divisorModule D
  pullbackIso_coordinateSection : ∀ (W : (projectiveSpace k n).Opens)
      (j : Fin (n + 1)),
    pullbackIso.hom.app (map ⁻¹ᵁ W)
        (((Scheme.Modules.pullbackPushforwardAdjunction map).unit.app
          (ProjectiveTwist.twistingSheafOne (k := k) (J := Fin (n + 1)))).app W
            (ProjectiveTwist.coordinateSection j W)) =
      (show Γ(divisorModule D, map ⁻¹ᵁ W) from
        divisorSectionsRes D le_top (basisSections basis j))
  chart_restrictions : ∀ i : NonGenericPoint X,
    (LocalRatioProjectiveGluing.chartOpenCover
        (fun x : NonGenericPoint X => selectedCoordinates (D := D) basis hbase x)
        (selectedCoordinates_isOpenCover_of_smoothCurve basis hbase)).f i ≫ map =
      (selectedRegularization (D := D) basis hbase i).chartMap

/-- The full-basis hypothesis forces the target dimension to be the complete
section-space dimension minus one. This equality need not hold for an arbitrary
projective embedding with the same twisting-sheaf pullback. -/
theorem ArbitraryProjectiveEmbeddingCertificate.target_dimension
    (c : ArbitraryProjectiveEmbeddingCertificate D) :
    (c.n : ℤ) = linearSystemDimension D := by
  exact ProjectiveMapProducer.target_dimension
    (ProjectiveMapProducer.of_basis D c.n c.basis c.map c.map_over)

/-- The normalized chart restrictions identify an arbitrary certified map with
the explicit local-ratio gluing before it is compared with the fixed-basis
smooth-curve producer. -/
theorem ArbitraryProjectiveEmbeddingCertificate.map_eq_localRatioGluing
    (c : ArbitraryProjectiveEmbeddingCertificate D) :
    c.map = LocalRatioProjectiveGluing.gluedFromOpen
      (fun x : NonGenericPoint X =>
        selectedCoordinates (D := D) c.basis c.hbase x)
      (fun x : NonGenericPoint X =>
        selectedRegularization (D := D) c.basis c.hbase x)
      (selectedCoordinates_isOpenCover_of_smoothCurve c.basis c.hbase)
      (selectedCoordinates_sameSectionValues (D := D) c.basis c.hbase) := by
  symm
  apply LocalRatioProjectiveGluing.gluedFromOpen_eq_of_chart_restrictions
  exact c.chart_restrictions

/-- The normalized restrictions force the arbitrary map to be the canonical
complete-linear-system map. -/
theorem ArbitraryProjectiveEmbeddingCertificate.map_eq_glued
    (c : ArbitraryProjectiveEmbeddingCertificate D) :
    c.map = gluedMap_of_smoothCurve c.basis c.hbase := by
  rw [← projectiveMapProducer_of_smoothCurve_map]
  exact projectiveMapProducer_of_smoothCurve_eq_of_chart_restrictions
    c.basis c.hbase c.map c.chart_restrictions

/-- Normalized chart data on an arbitrary closed immersion recovers numerical
very ampleness through the complete-linear-system converse. -/
theorem veryAmple_of_arbitraryProjectiveEmbeddingCertificate
    (c : ArbitraryProjectiveEmbeddingCertificate D) :
    VeryAmpleLinearSystem D := by
  letI := c.closedImmersion
  exact veryAmple_of_closedImmersion_of_chart_restrictions
    c.basis c.hbase c.map c.chart_restrictions

/-! ### Distinct-point consumers -/

/-- A certified arbitrary embedding separates distinct closed points in the
intrinsic divisor-section model.  The proof factors through the certificate's
map equality, so the closed-immersion hypothesis is used load-bearingly. -/
theorem ArbitraryProjectiveEmbeddingCertificate.exists_section_devissage_x_not_devissage_y
    (c : ArbitraryProjectiveEmbeddingCertificate D)
    (x y : X.left) (hx : x ≠ genericPoint X.left)
    (hy : y ≠ genericPoint X.left) (hxy : x ≠ y) :
    ∃ s : divisorSections (CurveDivisor.devissageDivisor hx D) ⊤,
      (s : X.left.functionField) ∉
        divisorSections (CurveDivisor.devissageDivisor hy D) ⊤ := by
  exact exists_section_devissage_x_not_devissage_y_of_gluedMap_injective
    c.basis c.hbase (by
      rw [← c.map_eq_glued]
      exact c.closedImmersion.isClosedEmbedding.injective) x y hx hy hxy

/-- The distinct-point dimension drop follows from an arbitrary certified
embedding, after identifying its map with the canonical glued map. -/
theorem ArbitraryProjectiveEmbeddingCertificate.h0_sub_h0_twoDevissage_eq_two
    (c : ArbitraryProjectiveEmbeddingCertificate D)
    (x y : X.left) (hx : x ≠ genericPoint X.left)
    (hy : y ≠ genericPoint X.left) (hxy : x ≠ y) :
    (CategoryTheory.Sheaf.h0 (divisorSheaf D) : ℤ) -
      CategoryTheory.Sheaf.h0 (divisorSheaf (CurveDivisor.devissageDivisor hy
        (CurveDivisor.devissageDivisor hx D))) = 2 := by
  exact h0_sub_h0_twoDevissage_eq_two_of_gluedMap_injective c.basis c.hbase (by
    rw [← c.map_eq_glued]
    exact c.closedImmersion.isClosedEmbedding.injective) x y hx hy hxy

/-- Surjective stalk maps from the closed immersion supply the repeated-point
tangent dimension drop for a certified arbitrary embedding. -/
theorem ArbitraryProjectiveEmbeddingCertificate.h0_sub_h0_twoDevissage_eq_one
    (c : ArbitraryProjectiveEmbeddingCertificate D)
    (x : X.left) (hx : x ≠ genericPoint X.left) :
    (CategoryTheory.Sheaf.h0 (divisorSheaf (CurveDivisor.devissageDivisor hx D)) : ℤ) -
      CategoryTheory.Sheaf.h0 (divisorSheaf
        (CurveDivisor.devissageDivisor hx (CurveDivisor.devissageDivisor hx D))) = 1 := by
  letI : IsClosedImmersion c.map := c.closedImmersion
  apply h0_sub_h0_twoDevissage_eq_one_of_gluedMap_stalkMap_surjective
    c.basis c.hbase ⟨x, hx⟩
  rw [← c.map_eq_glued]
  exact SurjectiveOnStalks.stalkMap_surjective c.map x

end
end Hartshorne.BasePointFreeLocalRatioCover
