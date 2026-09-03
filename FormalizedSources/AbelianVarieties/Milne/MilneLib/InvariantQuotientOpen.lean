/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantLocalization
import Mathlib.AlgebraicGeometry.Restrict

/-!
# Invariant affine quotient basic opens

This file identifies a basic open in the spectrum of an invariant subalgebra with the
spectrum of the fixed subring of the corresponding localization.  It is the geometric form
of invariants commuting with localization at an invariant element.
-/

set_option autoImplicit false

universe u v

open CategoryTheory AlgebraicGeometry

namespace MilneLib
namespace InvariantLocalization

variable {k : Type u} {A : Type v} {G : Type*}
  [CommRing k] [CommRing A] [Algebra k A]
  [Group G] [MulSemiringAction G A] [SMulCommClass G k A]

/-- A basic open of the affine invariant quotient is the spectrum of the fixed localized
ring. -/
noncomputable def fixedSubalgebraBasicOpenIso [Finite G]
    (b : FixedPoints.subalgebra k A G) :
    Scheme.Opens.toScheme
      (X := Spec (CommRingCat.of (FixedPoints.subalgebra k A G)))
      (PrimeSpectrum.basicOpen b) ≅
      Spec (CommRingCat.of (fixedAway (b : A) b.property)) :=
  AlgebraicGeometry.basicOpenIsoSpecAway
      (R := CommRingCat.of (FixedPoints.subalgebra k A G)) b ≪≫
    AlgebraicGeometry.Scheme.Spec.mapIso
      (localizationAwayFixedRingEquiv b).symm.toCommRingCatIso.op

end InvariantLocalization
end MilneLib
