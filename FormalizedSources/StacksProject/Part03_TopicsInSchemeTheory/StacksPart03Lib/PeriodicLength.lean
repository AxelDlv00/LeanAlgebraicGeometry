/-
Copyright (c) 2026 The StacksPart03Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart03Lib Contributors
-/

import Mathlib.RingTheory.Length
import StacksPart03Lib.Periodic

/-!
# Finite-length cohomology of two-periodic complexes

For a two-periodic complex, the even and odd cohomology modules are the
kernel/range quotients.  Mathlib's `IsFiniteLength` and `Module.length` give a
source-faithful, axiom-free finite-length package, while retaining `ℕ∞` so
that no finiteness hypothesis is hidden in the definitions.
-/

namespace StacksPart03

variable {R M N : Type*} [Ring R]
  [AddCommGroup M] [AddCommGroup N] [Module R M] [Module R N]

namespace TwoPeriodicComplex

/-- The even cycles and boundaries, with boundaries regarded as a submodule of
the cycle module via the kernel subtype. -/
abbrev evenCycles (C : TwoPeriodicComplex R M N) := LinearMap.ker C.d₀

abbrev evenBoundaries (C : TwoPeriodicComplex R M N) :
    Submodule R C.evenCycles :=
  (LinearMap.range C.d₁).comap C.evenCycles.subtype

/-- The even cohomology module `ker(d₀) / range(d₁)`. -/
abbrev evenCohomology (C : TwoPeriodicComplex R M N) :=
  C.evenCycles ⧸ C.evenBoundaries

/-- The odd cycles and boundaries, with boundaries regarded as a submodule of
the cycle module via the kernel subtype. -/
abbrev oddCycles (C : TwoPeriodicComplex R M N) := LinearMap.ker C.d₁

abbrev oddBoundaries (C : TwoPeriodicComplex R M N) :
    Submodule R C.oddCycles :=
  (LinearMap.range C.d₀).comap C.oddCycles.subtype

/-- The odd cohomology module `ker(d₁) / range(d₀)`. -/
abbrev oddCohomology (C : TwoPeriodicComplex R M N) :=
  C.oddCycles ⧸ C.oddBoundaries

/-- Both cohomology modules have finite length. -/
def HasFiniteLength (C : TwoPeriodicComplex R M N) : Prop :=
  IsFiniteLength R C.evenCohomology ∧ IsFiniteLength R C.oddCohomology

/-- Length of the even cohomology module. -/
noncomputable def evenLength (C : TwoPeriodicComplex R M N) : ℕ∞ :=
  Module.length R C.evenCohomology

/-- Length of the odd cohomology module. -/
noncomputable def oddLength (C : TwoPeriodicComplex R M N) : ℕ∞ :=
  Module.length R C.oddCohomology

/-- The alternating (even minus odd) cohomology length in `ℕ∞`.

Subtraction is the canonical truncated subtraction on `ℕ∞`; under
`HasFiniteLength` this is the usual difference of finite natural lengths. -/
noncomputable def lengthDifference (C : TwoPeriodicComplex R M N) : ℕ∞ :=
  C.evenLength - C.oddLength

theorem hasFiniteLength_iff (C : TwoPeriodicComplex R M N) :
    C.HasFiniteLength ↔
      IsFiniteLength R C.evenCohomology ∧ IsFiniteLength R C.oddCohomology :=
  Iff.rfl

theorem evenLength_eq_zero_iff (C : TwoPeriodicComplex R M N) :
    C.evenLength = 0 ↔ Subsingleton C.evenCohomology := by
  exact Module.length_eq_zero_iff

theorem oddLength_eq_zero_iff (C : TwoPeriodicComplex R M N) :
    C.oddLength = 0 ↔ Subsingleton C.oddCohomology := by
  exact Module.length_eq_zero_iff

/-- Exactness identifies the even cohomology quotient with the zero module. -/
theorem exact_evenCohomology_subsingleton (C : TwoPeriodicComplex R M N)
    (hC : C.IsExact) : Subsingleton C.evenCohomology := by
  rw [Submodule.Quotient.subsingleton_iff]
  simp [evenBoundaries, hC.1]

/-- Exactness identifies the odd cohomology quotient with the zero module. -/
theorem exact_oddCohomology_subsingleton (C : TwoPeriodicComplex R M N)
    (hC : C.IsExact) : Subsingleton C.oddCohomology := by
  rw [Submodule.Quotient.subsingleton_iff]
  simp [oddBoundaries, hC.2]

@[simp]
theorem exact_evenLength_eq_zero (C : TwoPeriodicComplex R M N)
    (hC : C.IsExact) : C.evenLength = 0 := by
  exact C.evenLength_eq_zero_iff.mpr (C.exact_evenCohomology_subsingleton hC)

@[simp]
theorem exact_oddLength_eq_zero (C : TwoPeriodicComplex R M N)
    (hC : C.IsExact) : C.oddLength = 0 := by
  exact C.oddLength_eq_zero_iff.mpr (C.exact_oddCohomology_subsingleton hC)

@[simp]
theorem exact_lengthDifference_eq_zero (C : TwoPeriodicComplex R M N)
    (hC : C.IsExact) : C.lengthDifference = 0 := by
  simp [lengthDifference, C.exact_evenLength_eq_zero hC, C.exact_oddLength_eq_zero hC]

end TwoPeriodicComplex

end StacksPart03
