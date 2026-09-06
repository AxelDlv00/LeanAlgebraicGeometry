/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter2LineBundleGluingPullbackIso
import HartshorneLib.Chapter4ProjectivePullbackComparison
import HartshorneLib.Chapter4ProjectiveMapClosedImmersion

/-!
# The linear-system pullback isomorphism

For the actual projective morphism associated with a complete base-point-free
linear system, the section-compatible comparison `f*O(1) -> O(D)` is an
isomorphism. Consequently the two-point numerical criterion supplies a closed
immersion over the ground field whose pullback of `O(1)` is the divisor module.
This proves the existence direction of the intrinsic very-ampleness criterion
in Hartshorne IV.3.1.
-/

set_option autoImplicit false

universe u

open CategoryTheory Opposite TopologicalSpace AlgebraicGeometry

namespace Hartshorne.BasePointFreeLocalRatioCover

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X} {n : ℕ}
variable (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
  (hD : BasePointFreeLinearSystem D)

/-- Pulling back projective frames gives exactly the denominator-cocycle module. -/
theorem isIso_pullbackTwistingToDenominator :
    IsIso (pullbackTwistingToDenominator basis hD) :=
  LineBundleGluing.isIso_pullbackHom.{u, 0}
    (gluedMap_of_smoothCurve basis hD) ProjectiveTwist.chart
    (fun x => (selectedCoordinates basis hD x).chart.U) ProjectiveTwist.matchingUnit
    (fun x y => LocalRatioDenominatorCocycle.transitionUnit
      (selectedCoordinates basis hD) (selectedRegularization basis hD) x y
      (selectedCoordinates_sameSectionValues basis hD x y))
    (fun x => (selectedCoordinates basis hD x).denominator_index)
    (selectedChart_le_preimage_chart basis hD) (appLE_matchingUnit basis hD)
    ProjectiveTwist.matchingCocycle
    (LocalRatioDenominatorCocycle.isCocycle (selectedCoordinates basis hD)
      (selectedRegularization basis hD) (selectedCoordinates_sameSectionValues basis hD))
    (selectedCoordinates_isOpenCover_of_smoothCurve basis hD)

/-- The section-compatible comparison with the actual divisor module is invertible. -/
theorem isIso_pullbackTwistingToDivisor :
    IsIso (pullbackTwistingToDivisor basis hD) := by
  letI := isIso_pullbackTwistingToDenominator basis hD
  change IsIso (pullbackTwistingToDenominator basis hD ≫
    (divisorModuleIsoSelectedGlued basis hD).inv)
  infer_instance

/-- The actual linear-system morphism pulls `O(1)` back to `O(D)`.
The construction retains the supplied basis and selected denominator frames. -/
def pullbackTwistingIsoDivisor :
    (Scheme.Modules.pullback (gluedMap_of_smoothCurve basis hD)).obj
        (ProjectiveTwist.twistingSheafOne (k := k) (J := Fin (n + 1))) ≅ divisorModule D := by
  letI := isIso_pullbackTwistingToDivisor basis hD
  exact asIso (pullbackTwistingToDivisor basis hD)

/-- The pullback isomorphism sends the homogeneous coordinate `X_j` to the
corresponding divisor basis section. -/
theorem pullbackTwistingIsoDivisor_coordinateSection
    (W : (projectiveSpace k n).Opens) (j : Fin (n + 1)) :
    (pullbackTwistingIsoDivisor basis hD).hom.app
        (gluedMap_of_smoothCurve basis hD ⁻¹ᵁ W)
        (((Scheme.Modules.pullbackPushforwardAdjunction
            (gluedMap_of_smoothCurve basis hD)).unit.app
          (ProjectiveTwist.twistingSheafOne (k := k) (J := Fin (n + 1)))).app W
            (ProjectiveTwist.coordinateSection j W)) =
      (show Γ(divisorModule D, gluedMap_of_smoothCurve basis hD ⁻¹ᵁ W) from
        divisorSectionsRes D le_top (basisSections basis j)) :=
  pullbackTwistingToDivisor_coordinateSection basis hD W j

/-- The two-point numerical criterion produces a projective closed immersion
over `k` whose twisting-sheaf pullback is the actual divisor module. -/
theorem exists_closedImmersion_pullbackTwisting_iso_of_veryAmple
    (hvery : VeryAmpleLinearSystem D) :
    ∃ (m : ℕ) (f : X.left ⟶ projectiveSpace k m),
      f ≫ projectiveSpaceStructureMap k m = X.hom ∧ IsClosedImmersion f ∧
        Nonempty ((Scheme.Modules.pullback f).obj
          (ProjectiveTwist.twistingSheafOne (k := k) (J := Fin (m + 1))) ≅ divisorModule D) := by
  let hbase := basePointFreeLinearSystem_of_veryAmple hvery
  obtain ⟨m, ⟨b⟩⟩ := exists_basis_of_basePointFree hbase
  exact ⟨m, gluedMap_of_smoothCurve b hbase, gluedMap_of_smoothCurve_over b hbase,
    gluedMap_isClosedImmersion_of_veryAmple b hvery, ⟨pullbackTwistingIsoDivisor b hbase⟩⟩

/-- A concrete projective embedding certificate records the basis, the
base-point-free proof, and the actual glued map. It is deliberately tied to
the canonical complete-linear-system construction; arbitrary embeddings still
require a separate pullback-section extraction theorem. -/
structure ProjectiveEmbeddingCertificate (D : CurveDivisor k X) where
  n : ℕ
  basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D)
  hbase : BasePointFreeLinearSystem D
  map : X.left ⟶ projectiveSpace k n
  map_over : map ≫ projectiveSpaceStructureMap k n = X.hom
  map_eq_glued : map = gluedMap_of_smoothCurve basis hbase
  closedImmersion : IsClosedImmersion map
  pullbackIso : (Scheme.Modules.pullback map).obj
      (ProjectiveTwist.twistingSheafOne (k := k) (J := Fin (n + 1))) ≅ divisorModule D
  pullbackIso_coordinateSection : ∀ (W : (projectiveSpace k n).Opens) (j : Fin (n + 1)),
    pullbackIso.hom.app (map ⁻¹ᵁ W)
        (((Scheme.Modules.pullbackPushforwardAdjunction map).unit.app
          (ProjectiveTwist.twistingSheafOne (k := k) (J := Fin (n + 1)))).app W
            (ProjectiveTwist.coordinateSection j W)) =
      (show Γ(divisorModule D, map ⁻¹ᵁ W) from divisorSectionsRes D le_top
        (basisSections basis j))

/-- Every numerically very ample divisor has a concrete embedding certificate. -/
def projectiveEmbeddingCertificate_of_veryAmple
    (hvery : VeryAmpleLinearSystem D) :
    ProjectiveEmbeddingCertificate D := by
  classical
  let hbase := basePointFreeLinearSystem_of_veryAmple hvery
  let hbases := exists_basis_of_basePointFree hbase
  let n := Classical.choose hbases
  let basis := Classical.choice (Classical.choose_spec hbases)
  let map := gluedMap_of_smoothCurve basis hbase
  exact
    { n := n
      basis := basis
      hbase := hbase
      map := map
      map_over := gluedMap_of_smoothCurve_over basis hbase
      map_eq_glued := rfl
      closedImmersion := gluedMap_isClosedImmersion_of_veryAmple basis hvery
      pullbackIso := pullbackTwistingIsoDivisor basis hbase
      pullbackIso_coordinateSection := pullbackTwistingIsoDivisor_coordinateSection
        basis hbase }

/-- A projective embedding certificate recovers the numerical very-ampleness
criterion through the closed-immersion converse. -/
theorem veryAmple_of_projectiveEmbeddingCertificate
    (c : ProjectiveEmbeddingCertificate D) :
    VeryAmpleLinearSystem D := by
  have hclosed : IsClosedImmersion (gluedMap_of_smoothCurve c.basis c.hbase) := by
    rw [← c.map_eq_glued]
    exact c.closedImmersion
  letI := hclosed
  exact veryAmple_of_gluedMap_isClosedImmersion c.basis c.hbase

end
end Hartshorne.BasePointFreeLocalRatioCover
