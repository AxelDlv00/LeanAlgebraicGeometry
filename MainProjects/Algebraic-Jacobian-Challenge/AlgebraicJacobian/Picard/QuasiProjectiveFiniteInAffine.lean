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

/-- **A finite `inf` of homogeneous ideals is homogeneous.** Bookkeeping for the
avoidance argument, which needs `I ⊓ ⨅_{i ≠ j} p i` to be homogeneous in order to
extract a homogeneous element from it. -/
theorem Ideal.IsHomogeneous.finsetInf {ι : Type*} (s : Finset ι) (p : ι → Ideal A)
    (h : ∀ i ∈ s, (p i).IsHomogeneous 𝒜) : (s.inf p).IsHomogeneous 𝒜 := by
  classical
  induction s using Finset.induction with
  | empty =>
      rw [Finset.inf_empty]
      exact fun _ _ _ => Submodule.mem_top
  | insert a t _ IH =>
      rw [Finset.inf_insert]
      exact fun i x hx =>
        ⟨h a (Finset.mem_insert_self a t) i hx.1,
          IH (fun j hj => h j (Finset.mem_insert_of_mem hj)) i hx.2⟩

/-- **Graded prime avoidance at a single relevant homogeneous prime.** If a
homogeneous ideal `I` is not contained in a homogeneous prime `p`, and `p` does not
contain the irrelevant ideal, then `I` has a homogeneous element of **strictly
positive** degree outside `p`.

Two separate uses of the grading, and it is worth naming both because the second is
the one an ungraded intuition drops:

* `I` homogeneous and `¬ I ≤ p` gives a homogeneous element of `I` outside `p` —
  decompose a witness and note that if every component were in `p` so would the
  witness be. Its degree is **not controlled** and may be `0`.
* Relevance of `p` (`¬ 𝒜₊ ≤ p`) gives a homogeneous `g ∉ p` of positive degree, by
  the same decomposition applied to a witness in the irrelevant ideal, whose
  degree-`0` component is zero by definition.

Then `f₀ * g` is homogeneous of degree `> 0`, lies in `I` (an ideal) and avoids `p`
(a prime). Relevance is exactly what makes this possible: over a `p` containing
`𝒜₊` — i.e. at a point *not* in `Proj` — every positive-degree homogeneous element
lies in `p` and the conclusion is false. -/
theorem exists_homogeneous_pos_mem_notMem
    {I p : Ideal A} [hp : p.IsPrime] (hI : I.IsHomogeneous 𝒜)
    (hrel : ¬ (HomogeneousIdeal.irrelevant 𝒜).toIdeal ≤ p) (hIp : ¬ I ≤ p) :
    ∃ (m : ℕ) (f : A), 0 < m ∧ f ∈ 𝒜 m ∧ f ∈ I ∧ f ∉ p := by
  classical
  obtain ⟨n, f₀, hf₀deg, hf₀I, hf₀p⟩ : ∃ (n : ℕ) (f : A), f ∈ 𝒜 n ∧ f ∈ I ∧ f ∉ p := by
    obtain ⟨x, hxI, hxp⟩ := SetLike.not_le_iff_exists.mp hIp
    by_contra hcon
    push Not at hcon
    exact hxp (by
      rw [← DirectSum.sum_support_decompose 𝒜 x]
      refine Ideal.sum_mem _ fun i _ => ?_
      by_contra h
      exact h (hcon i _ (SetLike.coe_mem _) ((hI.mem_iff).mp hxI i)))
  obtain ⟨m, g, hm, hgdeg, hgp⟩ : ∃ (m : ℕ) (g : A), 0 < m ∧ g ∈ 𝒜 m ∧ g ∉ p := by
    obtain ⟨x, hxirr, hxp⟩ := SetLike.not_le_iff_exists.mp hrel
    by_contra hcon
    push Not at hcon
    exact hxp (by
      rw [← DirectSum.sum_support_decompose 𝒜 x]
      refine Ideal.sum_mem _ fun i _ => ?_
      rcases Nat.eq_zero_or_pos i with rfl | hi
      · have hz : (DirectSum.decompose 𝒜 x 0 : A) = 0 := by
          have := (HomogeneousIdeal.mem_irrelevant_iff 𝒜 x).mp hxirr
          simpa [GradedRing.proj_apply] using this
        simp [hz]
      · exact hcon i _ hi (SetLike.coe_mem _))
  exact ⟨n + m, f₀ * g, by omega, SetLike.mul_mem_graded hf₀deg hgdeg,
    I.mul_mem_right _ hf₀I, fun h => (hp.mem_or_mem h).elim hf₀p hgp⟩

/-- **Graded prime avoidance for an incomparable family** — the case with the
construction in it.

Given finitely many pairwise-incomparable relevant homogeneous primes `q ∈ T`, none
containing the homogeneous ideal `I`, there is a **single** homogeneous element of
`I` of **positive** degree outside every one of them.

The classical product/sum trick, with the grading forcing one extra step:

* Incomparability makes `I ⊓ ⨅_{q' ∈ T, q' ≠ q} q'` not contained in `q` — if it
  were, primality would put one of the factors inside `q`. So
  `exists_homogeneous_pos_mem_notMem` supplies, for each `q`, a homogeneous
  `f q ∈ I` of positive degree `m q` that lies in every *other* member of `T` and
  not in `q`.
* Those degrees differ, so their sum need not be homogeneous. Equalise: with
  `M := ∏ m q` each `m q` divides `M`, and `F q := (f q) ^ (M / m q)` is homogeneous
  of the **common** degree `M > 0`, still in `I` and with the same membership
  pattern (a prime contains a power iff it contains the base).
* `∑_{q ∈ T} F q` is then homogeneous of degree `M`, lies in `I`, and modulo any
  `q ∈ T` reduces to `F q ≠ 0 mod q` because every other summand is in `q`.

This is the only place in the file where anything is constructed; §2 onwards is
transport. -/
theorem exists_homogeneous_pos_mem_forall_notMem_of_antichain
    (T : Finset (Ideal A)) (hp : ∀ q ∈ T, q.IsPrime)
    (hph : ∀ q ∈ T, q.IsHomogeneous 𝒜)
    (hrel : ∀ q ∈ T, ¬ (HomogeneousIdeal.irrelevant 𝒜).toIdeal ≤ q)
    (hanti : ∀ q ∈ T, ∀ q' ∈ T, q ≠ q' → ¬ q ≤ q')
    {I : Ideal A} (hI : I.IsHomogeneous 𝒜) (hIp : ∀ q ∈ T, ¬ I ≤ q)
    (hM : ∃ (m : ℕ) (f : A), 0 < m ∧ f ∈ 𝒜 m ∧ f ∈ I) :
    ∃ (M : ℕ) (h : A), 0 < M ∧ h ∈ 𝒜 M ∧ h ∈ I ∧ ∀ q ∈ T, h ∉ q := by
  classical
  rcases T.eq_empty_or_nonempty with rfl | hne
  · obtain ⟨m, f, hm, hfd, hfI⟩ := hM
    exact ⟨m, f, hm, hfd, hfI, by simp⟩
  -- Choose, for each `q ∈ T`, a homogeneous positive-degree element of
  -- `I ⊓ ⨅_{q' ≠ q} q'` outside `q`.
  have key : ∀ q ∈ T, ∃ (m : ℕ) (f : A), 0 < m ∧ f ∈ 𝒜 m ∧
      f ∈ (I ⊓ (T.erase q).inf id) ∧ f ∉ q := by
    intro q hq
    haveI := hp q hq
    refine exists_homogeneous_pos_mem_notMem 𝒜 (I := I ⊓ (T.erase q).inf id) ?_ (hrel q hq) ?_
    · exact fun i x hx =>
        ⟨hI i hx.1,
          Ideal.IsHomogeneous.finsetInf 𝒜 _ id
            (fun q' hq' => hph q' (Finset.mem_of_mem_erase hq')) i hx.2⟩
    · intro hle
      rcases (hp q hq).inf_le.mp hle with h | h
      · exact hIp q hq h
      · obtain ⟨q', hq', hq'le⟩ := (hp q hq).inf_le'.mp h
        exact hanti q' (Finset.mem_of_mem_erase hq') q hq
          (Finset.ne_of_mem_erase hq') hq'le
  choose! m f hmpos hfdeg hfmem hfout using key
  have hfI : ∀ q ∈ T, f q ∈ I := fun q hq => (hfmem q hq).1
  have hfin : ∀ q ∈ T, ∀ q' ∈ T.erase q, f q ∈ q' := fun q hq q' hq' =>
    Finset.inf_le (f := id) hq' (hfmem q hq).2
  -- Equalise the degrees: `M := ∏ m q`, and `F q := (f q) ^ (M / m q)` has degree `M`.
  set M : ℕ := ∏ q ∈ T, m q with hMdef
  have hMpos : 0 < M := Finset.prod_pos hmpos
  have hquot : ∀ q ∈ T, 0 < M / m q := fun q hq =>
    Nat.div_pos (Finset.single_le_prod' (fun i hi => hmpos i hi) hq) (hmpos q hq)
  set F : Ideal A → A := fun q => (f q) ^ (M / m q) with hFdef
  have hFdeg : ∀ q ∈ T, F q ∈ 𝒜 M := by
    intro q hq
    have h2 := SetLike.pow_mem_graded (M / m q) (hfdeg q hq)
    rwa [smul_eq_mul, Nat.div_mul_cancel (Finset.dvd_prod_of_mem m hq)] at h2
  have hFI : ∀ q ∈ T, F q ∈ I := fun q hq =>
    Ideal.pow_mem_of_mem I (hfI q hq) _ (hquot q hq)
  have hFin : ∀ q ∈ T, ∀ q' ∈ T.erase q, F q ∈ q' := fun q hq q' hq' =>
    Ideal.pow_mem_of_mem _ (hfin q hq q' hq') _ (hquot q hq)
  have hFout : ∀ q ∈ T, F q ∉ q := fun q hq hmem =>
    hfout q hq ((hp q hq).mem_of_pow_mem _ hmem)
  refine ⟨M, ∑ q ∈ T, F q, hMpos, sum_mem hFdeg,
    Ideal.sum_mem _ fun q hq => hFI q hq, ?_⟩
  intro q hq hmem
  rw [← Finset.add_sum_erase T F hq] at hmem
  have hrest : (∑ q' ∈ T.erase q, F q') ∈ q :=
    Ideal.sum_mem _ fun q' hq' => hFin q' (Finset.mem_of_mem_erase hq') q
      (Finset.mem_erase.mpr ⟨(Finset.ne_of_mem_erase hq').symm, hq⟩)
  exact hFout q hq ((Ideal.add_mem_iff_left _ hrest).mp hmem)

end GradedAvoidance

end AlgebraicGeometry.Scheme
