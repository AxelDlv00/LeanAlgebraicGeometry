/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4ProjectivePointSeparation
import Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Proper
import Mathlib.AlgebraicGeometry.ZariskisMainTheorem

/-!
# Finiteness of the separated divisor-section morphism

The fixed-basis projective morphism of a base-point-free system on a proper
curve is proper. Numerical very ampleness makes that same morphism injective
on scheme points, hence quasi-finite and therefore finite. This supplies the
finite algebra input for the remaining tangent-to-stalk-surjectivity step of
Hartshorne IV.3.1; it does not assert a closed immersion.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace AlgebraicGeometry

namespace Hartshorne

noncomputable section

instance isSeparated_projectiveSpaceStructureMap
    (k : Type u) [Field k] (n : ℕ) :
    IsSeparated (projectiveSpaceStructureMap k n) := by
  unfold projectiveSpaceStructureMap
  exact MorphismProperty.comp_mem @IsSeparated
    (Proj.toSpecZero (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k))
    (Spec.map (CommRingCat.ofHom
      (algebraMap k
        ((MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k) 0))))
    (Proj.isSeparated _) inferInstance

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X} {n : ℕ}

namespace BasePointFreeLocalRatioCover

/-- The actual glued map of a base-point-free system on a proper curve is
proper, since its projective target is separated over the ground field. -/
theorem gluedMap_isProper
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) :
    IsProper (gluedMap_of_smoothCurve (D := D) basis hD) := by
  letI : IsProper (gluedMap_of_smoothCurve (D := D) basis hD ≫
      projectiveSpaceStructureMap k n) := by
    rw [gluedMap_of_smoothCurve_over]
    infer_instance
  exact IsProper.of_comp _ (projectiveSpaceStructureMap k n)

/-- Numerical very ampleness makes the fixed-basis glued map finite. The
point-injectivity theorem supplies quasi-finiteness; properness supplies the
other hypothesis of Zariski's main theorem. -/
theorem gluedMap_isFinite_of_veryAmple
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : VeryAmpleLinearSystem D) :
    IsFinite (gluedMap_of_smoothCurve (D := D) basis
      (basePointFreeLinearSystem_of_veryAmple hD)) := by
  let f := gluedMap_of_smoothCurve (D := D) basis
    (basePointFreeLinearSystem_of_veryAmple hD)
  letI : IsProper f :=
    gluedMap_isProper basis (basePointFreeLinearSystem_of_veryAmple hD)
  letI : LocallyQuasiFinite f :=
    LocallyQuasiFinite.of_injective (gluedMap_injective_of_veryAmple basis hD)
  exact IsFinite.of_isProper_of_locallyQuasiFinite f

end BasePointFreeLocalRatioCover

end
end Hartshorne
