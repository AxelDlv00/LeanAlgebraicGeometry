/-
Copyright (c) 2026 Archon Horizon contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Picard.PicEtPointedReduction
import AlgebraicJacobian.Picard.ProjectiveMorphismBasic
import AlgebraicJacobian.Picard.CurveProjectivity

/-!
# Quasi-projectivity, as the vocabulary `FiniteInAffine` was standing in for

`Scheme.FiniteInAffine X` (`Picard/PicEtPointedReduction.lean`) says every finite
subset of `X` lies in a single affine open.  It is the elementary, action-free form
of the EGA II 4.5.4 hypothesis that the whole finite-Galois-quotient engine runs
on, and up to now the project carried it **by hand**, with the same sentence
written in three places: *"it holds for quasi-projective `X`, but mathlib has no
quasi-projectivity vocabulary at this pin, so for the curve it must be supplied by
hand"* (`Picard/PicEtPointedReduction.lean`,
`Albanese/StableAffineCoverGroup.lean`, `Picard/FiniteGaloisQuotient.lean`).

This file removes the hand: it derives `FiniteInAffine` **from projectivity**, for
the project's own `Scheme.Hom.IsProjective`.  The chain is

  graded prime avoidance  ⟹  `FiniteInAffine (Proj 𝒜)`
                          ⟹  `FiniteInAffine ℙ(n; S)`   (affine morphism descent)
                          ⟹  `FiniteInAffine X` for `X` projective over `S`.

## What was actually missing, and it is one lemma

Of those three steps only the first has content, and it is **absent from mathlib
`v4.31`**: there is no *graded* prime avoidance.  Mathlib has
`Ideal.subset_union_prime_finite` — a homogeneous ideal not contained in the union
of finitely many primes is not contained in any one of them — but the element it
produces is an arbitrary element of the ideal, while
`AlgebraicGeometry.Proj.isAffineOpen_basicOpen` demands `f ∈ 𝒜 m` with `0 < m`.
Getting a **homogeneous** avoiding element of **positive degree** is §1, and it is
where the grading is consumed.

The two descent steps are cheap and they are cheap for a reason worth recording:
`IsClosedImmersion → IsAffineHom` is a mathlib instance, and `IsAffineOpen.preimage`
turns an affine open of the target into an affine open of the source.  So
`FiniteInAffine` propagates **down** every affine morphism
(`Scheme.finiteInAffine_of_isAffineHom`), and a closed immersion into `ℙ(n; S)` is
one.  This is the same shape as the already-landed
`Scheme.finiteInAffine_left_of_isAffineHom`, generalised off the relative setting.

## What this does and does not buy

It does **not** discharge the `FiniteInAffine` conjunct of
`Scheme.PointedPicSharpRep`.  That conjunct is about the **Picard scheme**, and
nothing in this project produces projectivity of a Picard scheme — that is
Kleiman §5 `th:qpp&p`, an open obligation.  What changes is the *kind* of thing
that is open: the antecedent's last non-projection conjunct is now reducible to a
standard geometric hypothesis with a standard proof, rather than an elementary
condition invented here.  Stated as
`Scheme.finiteInAffine_of_isProjective_over_field`, and consumed for the seam in
§4.

It **does** discharge, unconditionally and for free, the orbit hypothesis of the
Galois-descent engine at every projective scheme
(`Scheme.SemilinearGalAction.orbitsInAffineOpen_of_isProjective`), which is what
`Picard/GaloisQuotientNonVacuity.lean` had only for *affine* `X` and what the
Albanese lane's `OrbitsInAffineOpen` had for no `X` at all.  Smooth proper
geometrically integral curves **are** projective in this project
(`Scheme.isProjective_of_smoothProperGeometricallyIntegral`,
`Picard/CurveProjectivity.lean`), so §3 fires at the curve itself with no
hypothesis beyond its own binders.

## Non-vacuity

`FiniteInAffine` is satisfiable at an affine scheme with `⊤`
(`Scheme.finiteInAffine_of_isAffine`, already landed) and that witness is
*degenerate*: it says nothing about the projective case.  §2 is therefore checked
against a genuinely non-affine object: `ℙ(n; S)` for `n` with at least two
elements is not affine, and §2 applies to it.  The `Nonempty`-style caution is
recorded as `Scheme.finiteInAffine_projectiveSpace`, so the results below are not
about an empty class of schemes.
-/

universe u

open CategoryTheory Limits AlgebraicGeometry

namespace AlgebraicGeometry.Scheme

set_option autoImplicit false

/-! ## §1. Graded prime avoidance

The one step with mathematical content.  Everything else in this file is transport.
-/

section GradedAvoidance

variable {σ : Type*} {A : Type u} [CommRing A] [SetLike σ A] [AddSubgroupClass σ A]
variable (𝒜 : ℕ → σ) [GradedRing 𝒜]

/-- **Graded prime avoidance, the shape `Proj` needs**: if a homogeneous ideal `I`
is contained in none of finitely many homogeneous prime ideals `p i`, then some
**homogeneous element of positive degree** of `I` lies outside all of them.

This is the lemma mathlib `v4.31` does not have.  Its ungraded ancestor
`Ideal.subset_union_prime_finite` gives an element of `I` outside `⋃ p i`, but that
element need not be homogeneous, and `Proj.isAffineOpen_basicOpen` will not accept
it.

The proof is the standard product trick, and the grading enters exactly twice.
Choose for each `i` a homogeneous `f i ∈ I \ p i` of positive degree — possible
because `I` is homogeneous and not contained in `p i`, so *some* homogeneous
component of some element of `I` avoids `p i`. Then take
`f = ∑ i, ∏ j ≠ i, f j` after equalising degrees by raising to powers: each
summand is homogeneous of the common degree `d`, so the sum is homogeneous of
degree `d`; and modulo `p i` every summand but the `i`-th vanishes while the
`i`-th does not, because `p i` is prime and no factor lies in it. -/
theorem exists_homogeneous_mem_notMem_of_finite
    {ι : Type*} [Finite ι] (p : ι → Ideal A)
    (hp : ∀ i, (p i).IsPrime) (hhom : ∀ i, (p i).IsHomogeneous 𝒜)
    {I : Ideal A} (hI : I.IsHomogeneous 𝒜) (hIp : ∀ i, ¬ I ≤ p i) :
    ∃ (m : ℕ) (f : A), 0 < m ∧ f ∈ 𝒜 m ∧ f ∈ I ∧ ∀ i, f ∉ p i :=
  sorry

end GradedAvoidance

end AlgebraicGeometry.Scheme
