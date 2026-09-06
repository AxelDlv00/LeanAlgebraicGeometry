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
import HartshorneLib.Chapter4ProjectivePointConverse
import HartshorneLib.Chapter4ProjectiveTangentConverse

/-!
# The projective closed-immersion criterion for a complete linear system

The fixed-basis projective morphism is finite and injective on points. At
closed points, tangent separation supplies maximal-ideal generation and the
ground field supplies residue-field surjectivity. Finite local Nakayama gives
stalk surjectivity there, and specialization gives it at the generic point.
The resulting finite monomorphism is a closed immersion.

Conversely, a closed immersion separates distinct points and is surjective on
stalks, which gives the repeated-point dimension drop. Thus for every complete
basis of a base-point-free system, the associated morphism is a closed immersion
if and only if the numerical very-ampleness criterion holds.
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

/-- A closed immersion of the actual complete linear-system map forces the
two-point dimension drops, including the repeated-point tangent condition. -/
theorem veryAmple_of_gluedMap_isClosedImmersion
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hbase : BasePointFreeLinearSystem D)
    [IsClosedImmersion (gluedMap_of_smoothCurve (D := D) basis hbase)] :
    VeryAmpleLinearSystem D := by
  intro x y hx hy
  by_cases hxy : x = y
  · subst y
    have hfirst := hbase x hx
    have hsecond := h0_sub_h0_twoDevissage_eq_one_of_gluedMap_stalkMap_surjective
      basis hbase ⟨x, hx⟩
      (SurjectiveOnStalks.stalkMap_surjective
        (gluedMap_of_smoothCurve (D := D) basis hbase) x)
    omega
  · exact h0_sub_h0_twoDevissage_eq_two_of_gluedMap_isClosedImmersion
      basis hbase x y hx hy hxy

/-- For a fixed complete basis of a base-point-free divisor system, the
associated projective morphism is a closed immersion exactly when deleting
any two closed points, possibly equal, lowers the section dimension by two. -/
theorem gluedMap_isClosedImmersion_iff_veryAmple
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hbase : BasePointFreeLinearSystem D) :
    IsClosedImmersion (gluedMap_of_smoothCurve (D := D) basis hbase) ↔
      VeryAmpleLinearSystem D := by
  constructor
  · intro h
    letI := h
    exact veryAmple_of_gluedMap_isClosedImmersion basis hbase
  · intro hD
    exact gluedMap_isClosedImmersion_of_veryAmple basis hD

/-- A base-point-free complete system has a nonempty finite basis, hence a
projective target of dimension one less than its section dimension. -/
theorem exists_basis_of_basePointFree (hD : BasePointFreeLinearSystem D) :
    ∃ n, Nonempty (Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D)) := by
  letI : Module.Finite k (CurveDivisorSectionSpace D) :=
    (hasFiniteDivisorCohomology_of_smoothProperIntegralCurve (k := k) X D).1
  obtain ⟨q⟩ := nonempty_nonGenericPoint_of_smoothCurve (X := X)
  have hdrop := hD q.1 q.2
  have hpos : 0 < CategoryTheory.Sheaf.h0 (divisorSheaf D) := by omega
  refine ⟨CategoryTheory.Sheaf.h0 (divisorSheaf D) - 1,
    ⟨Module.finBasisOfFinrankEq k _ ?_⟩⟩
  change CategoryTheory.Sheaf.h0 (divisorSheaf D) = _
  omega

/-- Numerical very ampleness is equivalent to existence of a complete basis
whose associated base-point-free projective morphism is a closed immersion.
The basis and the base-point-free proof are supplied by the forward direction. -/
theorem veryAmple_iff_exists_gluedMap_isClosedImmersion :
    VeryAmpleLinearSystem D ↔
      ∃ (n : ℕ) (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
        (hbase : BasePointFreeLinearSystem D),
        IsClosedImmersion (gluedMap_of_smoothCurve (D := D) basis hbase) := by
  constructor
  · intro hD
    let hbase := basePointFreeLinearSystem_of_veryAmple hD
    obtain ⟨n, ⟨basis⟩⟩ := exists_basis_of_basePointFree hbase
    exact ⟨n, basis, hbase, gluedMap_isClosedImmersion_of_veryAmple basis hD⟩
  · rintro ⟨n, basis, hbase, hclosed⟩
    exact (gluedMap_isClosedImmersion_iff_veryAmple basis hbase).mp hclosed

end BasePointFreeLocalRatioCover

end
end Hartshorne
