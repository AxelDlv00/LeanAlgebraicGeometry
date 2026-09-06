/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4ProjectiveMapFinite
import HartshorneLib.Chapter4ProjectiveMapTangent
import HartshorneLib.Chapter4FiniteInjectiveStalks
import HartshorneLib.Chapter4GenericStalkSurjectivity
import HartshorneLib.Chapter4ResidueMap

/-!
# Numerical very ampleness gives a projective closed immersion

The fixed-basis projective morphism is finite and injective on points. At
closed points, tangent separation supplies maximal-ideal generation and the
ground field supplies residue-field surjectivity. Finite local Nakayama gives
stalk surjectivity there, and specialization gives it at the generic point.
The resulting finite monomorphism is a closed immersion.

This proves the forward geometric implication in Hartshorne IV.3.1.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace AlgebraicGeometry

namespace Hartshorne

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X} {n : ℕ}

namespace BasePointFreeLocalRatioCover

/-- The actual projective stalk map is surjective at every closed curve point. -/
theorem gluedMap_stalkMap_surjective_of_veryAmple_of_ne_genericPoint
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : VeryAmpleLinearSystem D) (x : X.left)
    (hx : x ≠ genericPoint X.left) :
    Function.Surjective ((gluedMap_of_smoothCurve (D := D) basis
      (basePointFreeLinearSystem_of_veryAmple hD)).stalkMap x).hom := by
  let f := gluedMap_of_smoothCurve (D := D) basis
    (basePointFreeLinearSystem_of_veryAmple hD)
  letI : IsFinite f := gluedMap_isFinite_of_veryAmple basis hD
  letI : X.left.Over (Spec (CommRingCat.of k)) := ⟨X.hom⟩
  letI : SmoothOfRelativeDimension 1 (X.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 X.hom)
  letI : (projectiveSpace k n).Over (Spec (CommRingCat.of k)) :=
    ⟨projectiveSpaceStructureMap k n⟩
  apply surjective_of_finite_of_map_maximalIdeal_eq_of_residueFieldMap_surjective
    (f.stalkMap x).hom
    (finite_stalkMap_of_injective f (gluedMap_injective_of_veryAmple basis hD) x)
    (gluedMap_stalkMap_map_maximalIdeal_of_veryAmple basis hD x hx)
  exact f.residueFieldMap_surjective_of_smoothCurve
    (gluedMap_of_smoothCurve_over basis
      (basePointFreeLinearSystem_of_veryAmple hD)) x hx

/-- Numerical very ampleness makes the glued morphism surjective on all
stalks, including the generic stalk. -/
theorem gluedMap_surjectiveOnStalks_of_veryAmple
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : VeryAmpleLinearSystem D) :
    SurjectiveOnStalks (gluedMap_of_smoothCurve (D := D) basis
      (basePointFreeLinearSystem_of_veryAmple hD)) := by
  constructor
  intro x
  by_cases hx : x = genericPoint X.left
  · subst x
    obtain ⟨y, hy⟩ := exists_ne_genericPoint_of_smoothCurve X.hom
    exact stalkMap_genericPoint_surjective_of_surjective _ y
      (gluedMap_stalkMap_surjective_of_veryAmple_of_ne_genericPoint basis hD y hy)
  · exact gluedMap_stalkMap_surjective_of_veryAmple_of_ne_genericPoint basis hD x hx

/-- The morphism defined by a complete basis of a numerically very ample
divisor system on a smooth proper integral curve is a closed immersion. -/
theorem gluedMap_isClosedImmersion_of_veryAmple
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : VeryAmpleLinearSystem D) :
    IsClosedImmersion (gluedMap_of_smoothCurve (D := D) basis
      (basePointFreeLinearSystem_of_veryAmple hD)) := by
  let f := gluedMap_of_smoothCurve (D := D) basis
    (basePointFreeLinearSystem_of_veryAmple hD)
  letI : IsFinite f := gluedMap_isFinite_of_veryAmple basis hD
  letI : SurjectiveOnStalks f := gluedMap_surjectiveOnStalks_of_veryAmple basis hD
  letI : Mono f :=
    SurjectiveOnStalks.mono_of_injective (gluedMap_injective_of_veryAmple basis hD)
  exact (IsClosedImmersion.iff_isFinite_and_mono f).mpr ⟨inferInstance, inferInstance⟩

end BasePointFreeLocalRatioCover

end
end Hartshorne
