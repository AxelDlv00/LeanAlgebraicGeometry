/-
Copyright (c) 2026 The StacksPart03Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart03Lib Contributors
-/

import Mathlib.RingTheory.Length
import StacksPart03Lib.Cohomology

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

/-- The even cohomology module `ker(d₀) / range(d₁)`. -/
abbrev evenCohomology (C : TwoPeriodicComplex R M N) :=
  C.HZero

/-- The odd cohomology module `ker(d₁) / range(d₀)`. -/
abbrev oddCohomology (C : TwoPeriodicComplex R M N) :=
  C.HOne

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

/-- Finite-length ambient modules give finite-length periodic cohomology. -/
theorem hasFiniteLength_of_finite_ambient (C : TwoPeriodicComplex R M N)
    (hM : IsFiniteLength R M) (hN : IsFiniteLength R N) : C.HasFiniteLength := by
  constructor
  · apply IsFiniteLength.of_surjective ?_ (Submodule.mkQ_surjective _)
    apply IsFiniteLength.of_injective hM
    exact Submodule.subtype_injective _
  · apply IsFiniteLength.of_surjective ?_ (Submodule.mkQ_surjective _)
    apply IsFiniteLength.of_injective hN
    exact Submodule.subtype_injective _

/-- Exact periodic complexes have finite-length (indeed zero) cohomology. -/
theorem hasFiniteLength_of_isExact (C : TwoPeriodicComplex R M N)
    (hC : C.IsExact) : C.HasFiniteLength := by
  constructor
  · letI : Subsingleton C.evenCohomology := C.hZero_subsingleton_iff.mpr hC.1.symm
    exact IsFiniteLength.of_subsingleton
  · letI : Subsingleton C.oddCohomology := C.hOne_subsingleton_iff.mpr hC.2.symm
    exact IsFiniteLength.of_subsingleton

theorem evenLength_eq_zero_iff (C : TwoPeriodicComplex R M N) :
    C.evenLength = 0 ↔ Subsingleton C.evenCohomology := by
  exact Module.length_eq_zero_iff

theorem oddLength_eq_zero_iff (C : TwoPeriodicComplex R M N) :
    C.oddLength = 0 ↔ Subsingleton C.oddCohomology := by
  exact Module.length_eq_zero_iff

/-- Exactness identifies the even cohomology quotient with the zero module. -/
theorem exact_evenCohomology_subsingleton (C : TwoPeriodicComplex R M N)
    (hC : C.IsExact) : Subsingleton C.evenCohomology := by
  exact C.hZero_subsingleton_iff.mpr hC.1.symm

/-- Exactness identifies the odd cohomology quotient with the zero module. -/
theorem exact_oddCohomology_subsingleton (C : TwoPeriodicComplex R M N)
    (hC : C.IsExact) : Subsingleton C.oddCohomology := by
  exact C.hOne_subsingleton_iff.mpr hC.2.symm

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
