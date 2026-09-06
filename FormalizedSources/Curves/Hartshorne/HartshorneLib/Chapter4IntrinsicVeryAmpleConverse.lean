/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4ProjectivePullbackIso
import HartshorneLib.Chapter4ProjectiveEmbeddingChartBridge

/-!
# Conditional arbitrary-embedding converse

An arbitrary projective embedding can be used by the intrinsic converse once
its pullback isomorphism has been extracted in normalized chart coordinates.
This file records that extraction boundary explicitly and consumes it through
the proved chart-restriction converse.  The extraction of the chart data from
an unstructured pullback isomorphism remains a separate producer.
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

The pullback isomorphism and its coordinate-section law are intentionally
fields of the certificate: they are the interface a future extraction theorem
must construct from an arbitrary identification `f*O(1) ≅ O(D)`.
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

end
end Hartshorne.BasePointFreeLocalRatioCover
