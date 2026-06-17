/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.CechHigherDirectImage

/-!
# Čech acyclicity on affines — standard-cover specialisation (P3)

This file contains the P3 lemma: positive-degree vanishing of the Čech complex
of a standard affine open cover of an affine scheme.  The lemma is stated over
the spanning-family bundle `(s : ι → R, hs : Ideal.span (Set.range s) = ⊤)`,
which simultaneously determines the cover (via
`Scheme.affineOpenCoverOfSpanRangeEqTop`) and the algebra-side exactness
certifier (`exact_of_isLocalized_span`).  The proof body is `sorry`; filling
it is the task of the P3 prover lane.

See `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`,
Lemma `lem:cech_acyclic_affine`.

Source: Stacks Project, Cohomology of Schemes, Tags 02KG
(`lemma-quasi-coherent-affine-cohomology-zero`) and
`lemma-cech-cohomology-quasi-coherent-trivial`.
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

open Scheme.Modules

/- Planner strategy (P3, see analogies/p3-localisation.md):

   L1 (gap-fill): identify `CechComplex` on this standard cover with the module
   complex `∏_σ M_{s_σ}` via `Γ(D(s_σ)) = M_{s_σ}` (Away localisation).  The
   key equation is `affineOpenCoverOfSpanRangeEqTop_f i = Spec.map (algebraMap R
   (Localization.Away (s i)))`, so the sections over the `i`-th piece are exactly
   the away-localisation `M_{s_i} = IsLocalizedModule.Away (s i) M`.

   L2 (ALIGN): feed each positive-degree exactness node to
   `exact_of_isLocalized_span (Set.range s) hs`
   (`Mathlib.RingTheory.LocalProperties.Exactness`), localising at the spanning
   elements `Away (s r)` (not at primes).  After L1, each degree-`p` term of the
   complex is `∏_σ M_{s_σ}` and the differential is the alternating Čech
   coboundary; `exact_of_isLocalized_span` reduces `Function.Exact d^{p-1} d^p`
   to the same exactness after inverting each `s_r` individually.

   L3 (gap-fill): in the localisation `A_{s_r}` the fixed index `i_fix = r`
   makes `s_r` invertible, so the contracting homotopy
   `h(σ)_{i₀…i_p} = σ_{r i₀…i_p}` is well-defined globally on `M_{s_r}`
   (no passage to a prime needed) and gives `Function.Exact` of the localised
   differentials via `dh + hd = id`.  Do NOT route through Mathlib's simplicial
   `ExtraDegeneracy` (wrong variance — chain vs. cochain — and no cosimplicial
   dual exists in Mathlib); instead prove the module homotopy directly.
-/

/-- **Standard-cover Čech-complex vanishing on affines** (P3; Stacks 02KG,
`lemma-cech-cohomology-quasi-coherent-trivial`).

Let `R` be a commutative ring, `s : ι → R` a spanning family
(`Ideal.span (Set.range s) = ⊤`), and `F` a quasi-coherent `O_{Spec R}`-module.
The relative Čech complex of the standard affine cover
`Scheme.affineOpenCoverOfSpanRangeEqTop s hs` has vanishing cohomology in all
positive degrees: `Hᵖ = 0` for `p ≥ 1`.

Route: (L1) identify the complex with `∏_σ M_{s_σ}` via away-localisation
sections; (L2) reduce positive-degree exactness to the localised complexes via
`exact_of_isLocalized_span`; (L3) supply the explicit contracting homotopy
`h(σ)_{i₀…i_p} = σ_{r i₀…i_p}` on `M_{s_r}` (where `s_r` is invertible). -/
theorem CechAcyclic.affine {R : CommRingCat.{u}} {S : Scheme.{u}}
    (f : Spec R ⟶ S) [IsAffineHom f]
    {ι : Type u} [Finite ι] (s : ι → R) (hs : Ideal.span (Set.range s) = ⊤)
    (F : (Spec R).Modules) (hF : F.IsQuasicoherent) (p : ℕ) (hp : 1 ≤ p) :
    IsZero ((CechComplex f ((Scheme.affineOpenCoverOfSpanRangeEqTop s hs).openCover) F).homology p) := by
  -- Reduction route (planner L1/L2/L3, `analogies/p3-localisation.md`):
  --   * L1 (categorical→module bridge, STILL MISSING): identify the abstract
  --     `CechComplex` on the standard cover with the concrete module complex
  --     `∏_σ M_{s_σ}` of away-localisations, degreewise and on differentials;
  --   * L2 (`exact_of_isLocalized_span`, Mathlib): reduce positive-degree
  --     exactness to exactness after inverting each spanning element `s_r`;
  --   * L3 (`CombinatorialCech` below, NOW PROVED axiom-clean): after inverting
  --     `s_r` the fixed index `r` is global, so the alternating Čech coboundary
  --     of the constant-coefficient complex is contracted by `combHomotopy`,
  --     giving `combDifferential_exact` (the exact shape L2 consumes).
  -- L3 is the from-scratch combinatorial core that the iter-011 prover was
  -- blocked on; it is now available as `CombinatorialCech.*`.  The remaining
  -- hole is purely the L1 categorical identification of `CechComplex`'s terms
  -- with the localisation modules — see `task_results` for the precise gap.
  sorry

/-! ## Project-local Mathlib supplement — `CombinatorialCech`

The constant-coefficient combinatorial core of standard-cover Čech acyclicity
(planner step **L3**, `analogies/p3-localisation.md`).  After localising the
extended Čech complex at a spanning element `s_r` (planner step L2, via
`exact_of_isLocalized_span`), the fixed index `r` becomes globally available, and
the alternating Čech coboundary admits the explicit contracting homotopy
`h(t)_{i₀…i_p} = t_{r i₀…i_p}` of Stacks
`lemma-cech-cohomology-quasi-coherent-trivial`.

This section formalises that homotopy and its consequences for the **constant
coefficient** complex `Cᵖ = (Fin (p+1) → ι) → M` with alternating coface
differential — abstracted away from the localisation/geometry so the purely
combinatorial cancellation (`combHomotopy`) and the simplicial identity
(`combDifferential_comp`, `d² = 0`) are isolated and reusable.  The remaining
work to close `CechAcyclic.affine` is the **L1** categorical bridge identifying
the abstract `CechComplex` terms with the away-localisation modules `M_{s_σ}` and
its differential with this `combDifferential` (after localising at `s_r`); these
lemmas are then fed to `exact_of_isLocalized_span` node by node.

These declarations are `private`: they exist only to close `CechAcyclic.affine`
in this file.  The intended blueprint home is the `\lean{...}` bundle of
`lem:cech_acyclic_affine`. -/

namespace CombinatorialCech

variable {ι : Type*} {M : Type*} [AddCommGroup M] {n : ℕ}

/-- Alternating coface (Čech) differential with constant coefficients in `M`:
`Cⁿ = (Fin n → ι) → M ⟶ Cⁿ⁺¹`, `(d t)(σ) = ∑ⱼ (-1)ʲ • t (σ ∘ j.succAbove)`.
The argument `σ ∘ j.succAbove` is the `(n)`-tuple obtained from the `(n+1)`-tuple
`σ` by deleting the `j`-th index. -/
private def combDifferential (t : (Fin n → ι) → M) : (Fin (n + 1) → ι) → M :=
  fun σ => ∑ j : Fin (n + 1), (-1 : ℤ) ^ (j : ℕ) • t (σ ∘ j.succAbove)

/-- The contracting homotopy of the localised complex: prepend the fixed
(globally invertible after localising at `s_r`) index `r`.
`(h u)(τ) = u (Fin.cons r τ)`. -/
private def combHomotopy (r : ι) (u : (Fin (n + 1) → ι) → M) : (Fin n → ι) → M :=
  fun τ => u (Fin.cons r τ)

@[simp] private lemma combHomotopy_zero (r : ι) :
    combHomotopy (M := M) (n := n) r 0 = 0 := by
  funext τ; simp [combHomotopy]

/-- Composing `Fin.cons r` with the `(j+1)`-th coface map is `Fin.cons r` of the
`j`-th coface map: the bookkeeping identity behind the homotopy computation. -/
private lemma cons_comp_succAbove_succ (r : ι) (σ : Fin (n + 1) → ι) (k : Fin (n + 1)) :
    (Fin.cons r σ : Fin (n + 2) → ι) ∘ (k.succ).succAbove
      = Fin.cons r (σ ∘ k.succAbove) := by
  funext l
  refine Fin.cases ?_ ?_ l
  · simp
  · intro i; simp [Fin.succ_succAbove_succ]

/-- **Contracting-homotopy identity** (planner L3; Stacks
`lemma-cech-cohomology-quasi-coherent-trivial`):
`d ∘ h + h ∘ d = id` on `Cⁿ⁺¹`.  This is the alternating-sum cancellation: the
`j = 0` term of `h (d t)` is `t`, and the remaining terms cancel against `d (h t)`
in pairs of opposite sign. -/
private lemma combHomotopy_spec (r : ι) (t : (Fin (n + 1) → ι) → M) :
    combDifferential (combHomotopy r t) + combHomotopy r (combDifferential t) = t := by
  funext σ
  simp only [combDifferential, combHomotopy, Pi.add_apply]
  rw [Fin.sum_univ_succ (f := fun j : Fin (n + 2) =>
    (-1 : ℤ) ^ (j : ℕ) • t ((Fin.cons r σ : Fin (n + 2) → ι) ∘ j.succAbove))]
  have h0 : (Fin.cons r σ : Fin (n + 2) → ι) ∘ (0 : Fin (n + 2)).succAbove = σ := by
    funext i; simp
  rw [h0]
  simp only [Fin.val_zero, pow_zero, one_smul, Fin.val_succ]
  rw [add_left_comm, ← Finset.sum_add_distrib]
  rw [Finset.sum_eq_zero (fun x _ => by
    rw [cons_comp_succAbove_succ, pow_succ, mul_comm, neg_one_mul, neg_smul]; abel), add_zero]

/-- Every cocycle is a coboundary in positive degree: if `d t = 0` then
`t = d (h t)`.  This is the homological content of `combHomotopy_spec` and is the
half (`ker d ⊆ im d`) carrying the geometric input. -/
private lemma combDifferential_eq_of_cocycle (r : ι) (t : (Fin (n + 1) → ι) → M)
    (ht : combDifferential t = 0) : combDifferential (combHomotopy r t) = t := by
  have h := combHomotopy_spec r t
  rw [ht, combHomotopy_zero, add_zero] at h
  exact h

/-- Sign-cancellation behind `d² = 0`: under the index swap
`(j, i) ↦ (j.succAbove i, i.predAbove j)` the alternating sign flips. -/
private lemma combSign_flip (j : Fin (n + 2)) (i : Fin (n + 1)) :
    ((-1 : ℤ) ^ (j : ℕ)) * ((-1) ^ (i : ℕ))
      = - (((-1 : ℤ) ^ ((j.succAbove i : Fin (n + 2)) : ℕ))
            * ((-1) ^ ((i.predAbove j : Fin (n + 1)) : ℕ))) := by
  rcases lt_or_ge (i.castSucc) j with h | h
  · rw [Fin.succAbove_of_castSucc_lt _ _ h, Fin.predAbove_of_castSucc_lt _ _ h,
        Fin.val_castSucc, Fin.val_pred]
    have hpos : 0 < (j : ℕ) := lt_of_le_of_lt (Nat.zero_le _) (by exact_mod_cast h)
    obtain ⟨m, hm⟩ : ∃ m, (j : ℕ) = m + 1 := ⟨(j : ℕ) - 1, by omega⟩
    rw [hm]; simp only [Nat.add_sub_cancel, pow_succ]; ring
  · rw [Fin.succAbove_of_le_castSucc _ _ h, Fin.predAbove_of_le_castSucc _ _ h,
        Fin.val_succ, Fin.coe_castPred]
    rw [pow_succ]; ring

/-- **`d² = 0`** for the constant-coefficient alternating Čech complex.  Proved by
the standard sign-reversing involution `(j, i) ↦ (j.succAbove i, i.predAbove j)` on
the double sum: the swap fixes the underlying composite coface
(`Fin.succAbove_succAbove_succAbove_predAbove`), is an involution
(`Fin.succAbove_succAbove_predAbove`, `Fin.predAbove_predAbove_succAbove`), has no
fixed point (`Fin.succAbove_ne`), and flips the sign (`combSign_flip`). -/
private lemma combDifferential_comp (t : (Fin n → ι) → M) :
    combDifferential (combDifferential t) = 0 := by
  funext σ
  simp only [combDifferential, Pi.zero_apply, Finset.smul_sum, smul_smul]
  rw [← Fintype.sum_prod_type (f := fun p : Fin (n + 2) × Fin (n + 1) =>
    ((-1 : ℤ) ^ (p.1 : ℕ) * (-1) ^ (p.2 : ℕ)) • t ((σ ∘ p.1.succAbove) ∘ p.2.succAbove))]
  apply Finset.sum_involution (fun p _ => (p.1.succAbove p.2, p.2.predAbove p.1))
  · rintro ⟨j, i⟩ _
    have harg : (σ ∘ (j.succAbove i).succAbove) ∘ (i.predAbove j).succAbove
        = (σ ∘ j.succAbove) ∘ i.succAbove := by
      funext k
      simp only [Function.comp_apply]
      rw [Fin.succAbove_succAbove_succAbove_predAbove]
    simp only [harg]
    rw [← add_smul, combSign_flip j i]
    simp
  · rintro ⟨j, i⟩ _ _
    simp only [ne_eq, Prod.mk.injEq, not_and]
    intro hj
    exact absurd hj (Fin.succAbove_ne j i)
  · rintro ⟨j, i⟩ _
    simp only [Prod.mk.injEq]
    exact ⟨Fin.succAbove_succAbove_predAbove j i, Fin.predAbove_predAbove_succAbove j i⟩
  · intro a _; exact Finset.mem_univ _

/-- **Positive-degree exactness** of the constant-coefficient Čech complex in the
`Function.Exact` form that `exact_of_isLocalized_span` (planner L2) consumes node
by node.  Combines `combDifferential_comp` (`im ⊆ ker`) with
`combDifferential_eq_of_cocycle` (`ker ⊆ im`, the homotopy half).  Requires a
distinguished index `r : ι` — supplied, after localising at `s_r`, by the
spanning element itself. -/
private lemma combDifferential_exact (r : ι) (n : ℕ) :
    Function.Exact (combDifferential : ((Fin (n + 1) → ι) → M) → ((Fin (n + 2) → ι) → M))
      (combDifferential : ((Fin (n + 2) → ι) → M) → ((Fin (n + 3) → ι) → M)) := by
  intro x
  constructor
  · intro hx
    exact ⟨combHomotopy r x, combDifferential_eq_of_cocycle r x hx⟩
  · rintro ⟨y, rfl⟩
    exact combDifferential_comp y

end CombinatorialCech

end AlgebraicGeometry
