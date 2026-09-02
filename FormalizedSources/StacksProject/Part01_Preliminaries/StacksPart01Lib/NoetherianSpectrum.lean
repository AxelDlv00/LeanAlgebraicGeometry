/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import StacksPart01Lib.Spectrum
import Mathlib.RingTheory.Spectrum.Prime.Noetherian

/-!
# Noetherian prime spectra

These wrappers expose the Noetherian topological consequences used in the
affine part of the preliminaries.
-/

namespace StacksPart01

open TopologicalSpace

/-! [Stacks tags 00FQ and 00FR] -/

/-- The prime spectrum of a Noetherian ring is a Noetherian space. -/
theorem spectrum_noetherian
    {R : Type*} [CommSemiring R] [IsNoetherianRing R] :
    NoetherianSpace (PrimeSpectrum R) := by
  infer_instance

/-- A Noetherian prime spectrum has finitely many irreducible components. -/
theorem spectrum_finite_irreducible_components
    {R : Type*} [CommSemiring R] [IsNoetherianRing R] :
    (irreducibleComponents (PrimeSpectrum R)).Finite := by
  exact TopologicalSpace.NoetherianSpace.finite_irreducibleComponents

/-- The minimal-prime points of a Noetherian prime spectrum form a finite set. -/
theorem spectrum_finite_minimal_points
    (R : Type*) [CommSemiring R] [IsNoetherianRing R] :
    {x : PrimeSpectrum R | IsMin x}.Finite := by
  exact PrimeSpectrum.finite_setOf_isMin R

end StacksPart01
