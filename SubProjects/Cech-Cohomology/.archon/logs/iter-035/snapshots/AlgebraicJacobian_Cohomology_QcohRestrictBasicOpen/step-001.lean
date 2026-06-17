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

end ApiCheck

end AlgebraicGeometry
