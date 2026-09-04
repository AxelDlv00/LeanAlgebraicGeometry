/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivPushforwardFlat
import AlgebraicJacobian.Picard.DivTwistRank
import AlgebraicJacobian.Projective.EffectiveCartierSupport

/-!
# Curve-specific finite pushforward producers

The divisor-to-Grassmannian route spends finiteness of the effective divisor over
the test base before it can form finite pushforward sections.  For a smooth
proper geometrically integral relative curve this finiteness is a theorem, not a
caller-supplied `LocallyQuasiFinite` instance.  The declarations here expose
that curve specialization for arbitrary test objects and for the locally
trivial twist used by D2'.

These are substrate producers only: they do not assert evaluation surjectivity,
construct a Grassmannian point, or discharge Picard representability.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits
open scoped AlgebraicGeometry TensorProduct

noncomputable section

namespace AlgebraicGeometry

namespace Scheme

namespace DivFamily

variable {S X : Scheme.{u}} {π : X ⟶ S} {T : Over S}

/-- The schematic support of a relative effective Cartier divisor on a smooth
proper geometrically integral curve is finite over every test base.  Properness
is the `DivFamily` support field, while quasi-finiteness is supplied by the
curve-fibre theorem. -/
theorem isFinite_support_of_curve
    [SmoothOfRelativeDimension 1 π] [GeometricallyIntegral π] [IsProper π]
    (x : DivFamily π T) :
    IsFinite (Modules.schematicSupportι x.F ≫ pullback.snd π T.hom) := by
  letI : IsProper (Modules.schematicSupportι x.F ≫ pullback.snd π T.hom) :=
    x.properSupport
  letI : LocallyQuasiFinite
      (Modules.schematicSupportι x.F ≫ pullback.snd π T.hom) :=
    locallyQuasiFinite_support_of_curve T π x
  exact IsFinite.of_isProper_of_locallyQuasiFinite _

/-! The curve support producer also discharges the quasi-finiteness input of
`coherentSheafFlat_id_pushforward`.  Keeping this bridge here makes the
flattening-stratification consumer usable without repeating a geometric
instance argument at each call site. -/

/-- The pushforward of the structure sheaf of a curve divisor is flat over an
arbitrary test object once the curve hypotheses supply finite fibres. -/
theorem coherentSheafFlat_id_pushforward_of_curve
    [SmoothOfRelativeDimension 1 π] [GeometricallyIntegral π] [IsProper π]
    (x : DivFamily π T) :
    CoherentSheafFlat (𝟙 (T.left : Scheme.{u}))
      ((Modules.pushforward (pullback.snd π T.hom)).obj x.F) := by
  letI : LocallyQuasiFinite
      (Modules.schematicSupportι x.F ≫ pullback.snd π T.hom) :=
    locallyQuasiFinite_support_of_curve T π x
  intro U hU V hV e
  exact (Scheme.DivFamily.coherentSheafFlat_id_pushforward (T := T) x) hU hV e

/-- The finite-presentation input for the pushforward tower on a locally
noetherian test base, with the support finiteness supplied by curve geometry. -/
theorem isFinitePresentation_pushforward_of_curve
    [IsProper π] [SmoothOfRelativeDimension 1 π]
    [GeometricallyIntegral π]
    [IsLocallyNoetherian (T.left : Scheme.{u})]
    (x : DivFamily π T) :
    ((Modules.pushforward (pullback.snd π T.hom)).obj x.F).IsFinitePresentation := by
  letI : LocallyQuasiFinite
      (Modules.schematicSupportι x.F ≫ pullback.snd π T.hom) :=
    locallyQuasiFinite_support_of_curve T π x
  exact isFinitePresentation_pushforward x

/-- A locally trivial line-bundle twist has finite support over every test base.
The support equality is the tensor-inverse argument, and the remaining finite
map is the curve producer above. -/
theorem twist_isFiniteSupport_of_curve
    [SmoothOfRelativeDimension 1 π] [GeometricallyIntegral π] [IsProper π]
    (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    (x : DivFamily π T) :
    IsFinite (Modules.schematicSupportι (x.twist L) ≫ pullback.snd π T.hom) := by
  dsimp [twist]
  rw [Modules.isFinite_tensorObj_left_iff_support
    (pullback.snd π T.hom)
    ((Modules.pullback (pullback.fst π T.hom)).obj L) x.F
    (hL.pullback (pullback.fst π T.hom))]
  exact isFinite_support_of_curve x

end DivFamily

end Scheme

end AlgebraicGeometry
