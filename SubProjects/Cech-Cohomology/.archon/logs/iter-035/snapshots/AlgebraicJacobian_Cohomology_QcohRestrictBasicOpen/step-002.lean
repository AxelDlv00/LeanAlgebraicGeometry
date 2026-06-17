/-
Copyright (c) 2026 Axel Delaval. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Axel Delaval
-/
import Mathlib.AlgebraicGeometry.Modules.Sheaf
import Mathlib.AlgebraicGeometry.Modules.Tilde
import Mathlib.AlgebraicGeometry.Restrict

/-!
# Restriction of an `𝒪_{Spec R}`-module to a basic open (Stacks 01I8) — Route-P step P1a

Project-local supplement for the affine quasi-coherence equivalence.
-/

open AlgebraicGeometry CategoryTheory

namespace AlgebraicGeometry

section ApiCheck

#check @AlgebraicGeometry.basicOpenIsoSpecAway
#check @AlgebraicGeometry.Scheme.Modules.restrict

-- understand what the basic open is as an opens / scheme
example (R : CommRingCat) (f : R) : (Spec R).Opens := PrimeSpectrum.basicOpen f

example (R : CommRingCat) (f : R) :
    ↑(PrimeSpectrum.basicOpen f) ≅ Spec (CommRingCat.of (Localization.Away f)) :=
  basicOpenIsoSpecAway f

-- the open immersion of the basic open into Spec R
example (R : CommRingCat) (f : R) :
    (PrimeSpectrum.basicOpen f : (Spec R).Opens).toScheme ⟶ Spec R :=
  (PrimeSpectrum.basicOpen f : (Spec R).Opens).ι

end ApiCheck

end AlgebraicGeometry
