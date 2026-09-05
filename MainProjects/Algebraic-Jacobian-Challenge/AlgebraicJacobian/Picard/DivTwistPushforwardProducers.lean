/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivCurvePushforwardProducers

/-!
# Finite sections of twisted divisor pushforwards

The Grassmannian comparison uses the pushforward of a locally trivial twist of
a divisor family.  The curve support producer and the finite-support
section theorem already work over an arbitrary test object; this file exposes
their composition for the actual twisted target.  The result is the finite
module input for the later finite-flat/local-free and evaluation producers.

The finite-presentation fact for the twist is kept as an explicit argument.
This makes the current boundary visible: the theorem supplies finite sections
once the tensor finite-presentation producer is available, without importing a
large downstream embedding module or silently assuming that producer here.

No generation, rank, representability, or rational-point hypothesis is hidden
in this declaration.
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

/-- A locally trivial twist of a divisor family has finite pushforward sections
over every affine open of every test object.  This is the arbitrary-base finite
module producer used by the D2 Grassmannian route. -/
theorem module_finite_sections_pushforward_twist_of_curve
    [SmoothOfRelativeDimension 1 π] [GeometricallyIntegral π] [IsProper π]
    (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    (x : DivFamily π T)
    (hFp : (x.twist L).IsFinitePresentation)
    {V : T.left.Opens} (hV : IsAffineOpen V) :
    Module.Finite Γ(T.left, V)
      Γ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L), V) := by
  letI : (x.twist L).IsFinitePresentation := hFp
  exact Modules.module_finite_sections_pushforward_of_isFinite_schematicSupport
    (pullback.snd π T.hom) (x.twist L)
    (twist_isFiniteSupport_of_curve L hL x) hV

/-- On a locally noetherian test object, the finite sections producer upgrades
the twisted divisor pushforward to finite presentation.  This is the
coherence input for the later finite-flat/local-free Grassmannian step; the
finite presentation of the twist itself remains an explicit hypothesis. -/
theorem isFinitePresentation_pushforward_twist_of_curve
    [SmoothOfRelativeDimension 1 π] [GeometricallyIntegral π] [IsProper π]
    [IsLocallyNoetherian (T.left : Scheme.{u})]
    (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    (x : DivFamily π T)
    (hFp : (x.twist L).IsFinitePresentation) :
    ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)).IsFinitePresentation := by
  letI : (x.twist L).IsFinitePresentation := hFp
  letI : (x.twist L).IsQuasicoherent := inferInstance
  letI : ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)).IsQuasicoherent :=
    Modules.pushforward_isQuasicoherent (pullback.snd π T.hom) (x.twist L)
  apply Modules.isFinitePresentation_of_finite_sections
  intro V hV
  exact module_finite_sections_pushforward_twist_of_curve L hL x hFp hV

end DivFamily

end Scheme

end AlgebraicGeometry
