import Mathlib.RingTheory.Finiteness.Basic
import Mathlib.LinearAlgebra.FreeModule.Finite.Basic

/-!
# Finite generation for coherent-module arguments

This file records the algebraic finiteness step used when a stalk is generated
by finitely many sections.  The statements are deliberately independent of
the sheaf implementation: a finite generating family is converted to a
`Module.Finite` instance, and a surjection from a module with a finite basis
transfers finiteness to its target.
-/

open Function

namespace MilneLib

universe u v w

/-- A finite set of generators makes a module finite. -/
theorem moduleFinite_of_finite_generating_set
    {R : Type u} {M : Type v} [Semiring R] [AddCommMonoid M] [Module R M]
    {s : Set M} (hs : s.Finite)
    (hspan : Submodule.span R s = ⊤) : Module.Finite R M := by
  apply Module.Finite.of_fg_top
  rw [← hspan]
  exact Submodule.fg_span hs

/-- A finite-indexed family spanning a module makes it finite. -/
theorem moduleFinite_of_finite_generating_family
    {R : Type u} {M : Type v} {ι : Type w}
    [Semiring R] [AddCommMonoid M] [Module R M] [Finite ι]
    (s : ι → M) (hspan : Submodule.span R (Set.range s) = ⊤) :
    Module.Finite R M := by
  apply Module.Finite.of_fg_top
  exact (Submodule.fg_iff_exists_finite_generating_family).2
    ⟨ι, inferInstance, s, hspan⟩

/-- Finiteness descends along a surjective linear map from a finite-basis
module.  The basis may be indexed by any finite type. -/
theorem moduleFinite_of_surjective_of_finite_basis
    {R : Type u} {P : Type v} {M : Type w} {ι : Type*}
    [Semiring R] [AddCommMonoid P] [Module R P]
    [AddCommMonoid M] [Module R M] [Finite ι]
    (b : Module.Basis ι R P) (f : P →ₗ[R] M) (hf : Function.Surjective f) :
    Module.Finite R M := by
  letI : Module.Finite R P := Module.Finite.of_basis b
  exact Module.Finite.of_surjective f hf

end MilneLib
