/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.FlatBaseChange

/-!
# Flat base change for the pushforward, global (`H⁰`-as-equalizer) chain

This file builds the global ("FBC-B") leg of the `i = 0` flat-base-change package:
`H⁰(X, F) = Γ(X, F)` of a quasi-compact, quasi-separated scheme is the equalizer of
a *finite* affine cover, and flat base change commutes with that finite equalizer.

It is the companion of `AlgebraicJacobian.Cohomology.FlatBaseChange`, which it imports
read-only (using the affine global-sections comparison as a per-term black box).

See `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (FBC-B section).
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

/-! ## Project-local Mathlib supplement — finite affine covers with quasi-compact overlaps -/

end AlgebraicGeometry
