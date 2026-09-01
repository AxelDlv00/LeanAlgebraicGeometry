/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import Mathlib.RingTheory.Finiteness.Basic
import Mathlib.LinearAlgebra.Isomorphisms

/-!
# Finite and cyclic modules

The finiteness lemmas in this file package the scalar-tower arguments used in
the Stacks Project's discussion of finite modules (Tags 0560, 00GJ, and 00KZ).
-/

namespace StacksPart01

/-- If an `R`-module is finite, then it is finite over any larger scalar ring
`S` acting through a scalar tower (Stacks, Tag 0560). -/
theorem finite_over_subring
    {R S M : Type*} [Semiring R] [Semiring S] [AddCommMonoid M]
    [Module R M] [Module S M] [SMul R S] [IsScalarTower R S M]
    [Module.Finite R M] :
    Module.Finite S M := by
  exact Module.Finite.of_restrictScalars_finite R S M

/-- For a finite scalar extension, finiteness of a module over the two scalar
rings is equivalent (Stacks, Tag 00GJ). -/
theorem finite_module_iff_of_finite_extension
    {R S M : Type*} [Semiring R] [Semiring S] [AddCommMonoid M]
    [Module R S] [Module S M] [Module R M] [IsScalarTower R S M]
    [Module.Finite R S] :
    Module.Finite R M ↔ Module.Finite S M := by
  constructor
  · intro h
    letI : Module.Finite R M := h
    exact Module.Finite.of_restrictScalars_finite R S M
  · intro h
    letI : Module.Finite S M := h
    exact Module.Finite.trans S M

/-- A cyclic module is linearly equivalent to the quotient of its scalar ring
by an ideal.  The ideal is the kernel of the map sending a scalar to its
multiple of the chosen generator. -/
theorem exists_ideal_quotient_equiv_of_cyclic
    {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    (h : ∃ m : M, Function.Surjective
      (LinearMap.toSpanSingleton R M m)) :
    ∃ I : Ideal R, Nonempty ((R ⧸ I) ≃ₗ[R] M) := by
  obtain ⟨m, hm⟩ := h
  let f := LinearMap.toSpanSingleton R M m
  exact ⟨LinearMap.ker f, ⟨f.quotKerEquivOfSurjective hm⟩⟩

/-- The quotient obtained by adjoining one generator to a submodule is cyclic.

This is the one-step construction used in the finite-module filtration lemma
(Stacks, Tag 00KZ). -/
theorem exists_ideal_quotient_equiv_sup_span
    {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    (N : Submodule R M) (x : M) :
    ∃ I : Ideal R, Nonempty (((↥((R ∙ x : Submodule R M) ⊔ N)) ⧸
      Submodule.comap ((R ∙ x : Submodule R M) ⊔ N).subtype N) ≃ₗ[R] (R ⧸ I)) := by
  let P : Submodule R M := (R ∙ x : Submodule R M) ⊔ N
  let p : Submodule R M := R ∙ x
  let f₀ : R →ₗ[R] p :=
    LinearMap.toSpanSingleton R p ⟨x, Submodule.mem_span_singleton.mpr ⟨1, by simp⟩⟩
  let D : Submodule R p :=
    Submodule.comap p.subtype p ⊓ Submodule.comap p.subtype N
  let q : p →ₗ[R] p ⧸ D := Submodule.mkQ D
  let f : R →ₗ[R] p ⧸ D := q.comp f₀
  have hf₀ : Function.Surjective f₀ := by
    intro y
    rcases (Submodule.mem_span_singleton.mp y.property) with ⟨a, ha⟩
    refine ⟨a, ?_⟩
    apply Subtype.ext
    simpa [f₀, LinearMap.toSpanSingleton_apply] using ha
  have hq : Function.Surjective q := Submodule.mkQ_surjective D
  have hf : Function.Surjective f := hq.comp hf₀
  let e : (p ⧸ D) ≃ₗ[R]
      (↥P ⧸ Submodule.comap P.subtype N) :=
    by simpa [P, D] using (LinearMap.quotientInfEquivSupQuotient p N)
  let e₀ : (R ⧸ LinearMap.ker f) ≃ₗ[R]
      (↥P ⧸ Submodule.comap P.subtype N) :=
    (f.quotKerEquivOfSurjective hf).trans e
  exact ⟨LinearMap.ker f, ⟨e₀.symm⟩⟩

end StacksPart01
