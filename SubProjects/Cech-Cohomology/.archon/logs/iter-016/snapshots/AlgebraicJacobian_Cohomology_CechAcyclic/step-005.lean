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

/-! ### Dependent-coefficient port (planner **L3 port**)

The localised complex that `exact_of_isLocalized_span` (planner **L2**) consumes
node-by-node has *varying* coefficients `M_{s_σ}` — the away localisation of `M`
at the product `s_σ = ∏ₖ s_{σ k}` — not a single constant module `M`.  After
localising the whole extended complex at a spanning element `s_r`, the index `r`
is globally available and `s_r` becomes a unit, so the prepend
`σ ↦ Fin.cons r σ` is an *isomorphism* on the coefficients:
`M_{s_{cons r σ}} = M_{s_r · s_σ} ≅ M_{s_σ}` because `s_r` is already invertible.

This section ports the constant-coefficient cancellation
(`combHomotopy_spec`, `combDifferential_eq_of_cocycle`) to that dependent
setting.  The away-localisation restriction maps are abstracted as additive
coface maps `δ` (`M_{s_{σ∘dⱼ}} → M_{s_σ}`, well defined because `s_σ` carries the
extra factor `s_{σ j}`) and the prepend isomorphisms as additive maps `c`
(`M_{s_{cons r σ}} → M_{s_σ}`).  The two compatibility identities below are
exactly the ones the away-localisation maps satisfy:

* the **unit** identity `c ∘ δ₀ = id` (deleting the prepended `r` from `cons r σ`
  recovers `σ`; on localisations the composite restriction is the identity since
  `s_r` is a unit), and
* the **shift** identity `c ∘ δ_{k+1} = δ_k ∘ c` (prepend commutes with the later
  cofaces), which is `cons_comp_succAbove_succ` lifted to the localisation maps.

Threading the dependent family through the same alternating-sum cancellation as
the constant case then yields the dependent homotopy identity and the
cocycle⟹coboundary corollary that L2 consumes.  Constructing the actual `δ`/`c`
from `IsLocalizedModule.Away` (Mathlib `tilde` API:
`AlgebraicGeometry.Modules.Tilde`, `IsLocalizedModule (.powers f)`) and the L1
identification of the abstract `CechComplex` terms with `∏_σ M_{s_σ}` remain the
outstanding bridge (see `CechAcyclic.affine`). -/

section Dependent

variable {A : (m : ℕ) → (Fin m → ι) → Type*} [∀ m σ, AddCommGroup (A m σ)]
variable (r : ι)
variable (δ : (m : ℕ) → (σ : Fin (m + 1) → ι) → (j : Fin (m + 1)) →
    A m (σ ∘ j.succAbove) →+ A (m + 1) σ)
variable (c : (m : ℕ) → (σ : Fin m → ι) → A (m + 1) (Fin.cons r σ) →+ A m σ)

omit [∀ m σ, AddCommGroup (A m σ)] in
/-- Transport of a dependent cochain value along an equality of index tuples.
The transport friction that the constant-coefficient proof avoided (there every
coefficient is the same `M`) is isolated here. -/
private lemma depTransport {m : ℕ} {x y : Fin m → ι} (h : x = y)
    (t : ∀ σ : Fin m → ι, A m σ) : h ▸ t x = t y := by
  subst h; rfl

/-- Deleting the prepended index `r` (the `0`-th coface of `Fin.cons r σ`)
recovers `σ`. -/
private lemma cons_comp_zero_succAbove {m : ℕ} (σ : Fin m → ι) :
    (Fin.cons r σ : Fin (m + 1) → ι) ∘ (0 : Fin (m + 1)).succAbove = σ := by
  funext i; simp

/-- Dependent (varying-coefficient) alternating Čech differential built from the
coface (localisation restriction) maps `δ`. -/
private def depDiff {m : ℕ} (t : ∀ σ : Fin m → ι, A m σ) :
    ∀ σ : Fin (m + 1) → ι, A (m + 1) σ :=
  fun σ => ∑ j : Fin (m + 1), (-1 : ℤ) ^ (j : ℕ) • δ m σ j (t (σ ∘ j.succAbove))

/-- Dependent contracting homotopy: prepend the distinguished index `r`, then
apply the prepend map `c`. -/
private def depHomotopy {m : ℕ} (u : ∀ σ : Fin (m + 1) → ι, A (m + 1) σ) :
    ∀ σ : Fin m → ι, A m σ :=
  fun σ => c m σ (u (Fin.cons r σ))

/-- **Dependent contracting-homotopy identity** (planner L3 port): `d ∘ h + h ∘ d
= id`, evaluated at a tuple `σ`.  Same alternating-sum cancellation as
`combHomotopy_spec`, threaded through the varying coefficients via the unit
identity `hu` (`c ∘ δ₀ = id`) and the shift identity `hsh`
(`c ∘ δ_{k+1} = δ_k ∘ c`). -/
private lemma depHomotopy_spec
    (hu : ∀ {m : ℕ} (σ : Fin (m + 1) → ι)
        (y : A (m + 1)
          ((Fin.cons r σ : Fin (m + 2) → ι) ∘ (0 : Fin (m + 2)).succAbove)),
        c (m + 1) σ (δ (m + 1) (Fin.cons r σ) 0 y)
          = (cons_comp_zero_succAbove r σ) ▸ y)
    (hsh : ∀ {m : ℕ} (σ : Fin (m + 1) → ι) (k : Fin (m + 1))
        (y : A (m + 1)
          ((Fin.cons r σ : Fin (m + 2) → ι) ∘ (k.succ).succAbove)),
        c (m + 1) σ (δ (m + 1) (Fin.cons r σ) (k.succ) y)
          = δ m σ k (c m (σ ∘ k.succAbove) ((cons_comp_succAbove_succ r σ k) ▸ y)))
    {m : ℕ} (t : ∀ σ : Fin (m + 1) → ι, A (m + 1) σ) (σ : Fin (m + 1) → ι) :
    depDiff δ (depHomotopy r c t) σ + depHomotopy r c (depDiff δ t) σ = t σ := by
  simp only [depDiff, depHomotopy]
  rw [map_sum]
  simp only [map_zsmul]
  rw [Fin.sum_univ_succ (f := fun k : Fin (m + 2) =>
    (-1 : ℤ) ^ (k : ℕ) • c (m + 1) σ
      (δ (m + 1) (Fin.cons r σ) k (t ((Fin.cons r σ : Fin (m + 2) → ι) ∘ k.succAbove))))]
  -- the `k = 0` term collapses to `t σ` via the unit identity
  rw [hu σ (t _)]
  rw [depTransport (cons_comp_zero_succAbove r σ) t]
  simp only [Fin.val_zero, pow_zero, one_smul, Fin.val_succ]
  -- the `k = j.succ` terms cancel against the `d ∘ h` sum in pairs of opposite sign
  rw [add_left_comm, ← Finset.sum_add_distrib]
  rw [Finset.sum_eq_zero (fun x _ => by
    rw [hsh σ x (t _), depTransport (cons_comp_succAbove_succ r σ x) t,
      pow_succ, mul_comm, neg_one_mul, neg_smul]
    abel), add_zero]

/-- Dependent cocycle⟹coboundary (the geometric half consumed by L2): if
`depDiff t = 0` then `t = depDiff (depHomotopy t)`. -/
private lemma depDiff_eq_of_cocycle
    (hu : ∀ {m : ℕ} (σ : Fin (m + 1) → ι)
        (y : A (m + 1)
          ((Fin.cons r σ : Fin (m + 2) → ι) ∘ (0 : Fin (m + 2)).succAbove)),
        c (m + 1) σ (δ (m + 1) (Fin.cons r σ) 0 y)
          = (cons_comp_zero_succAbove r σ) ▸ y)
    (hsh : ∀ {m : ℕ} (σ : Fin (m + 1) → ι) (k : Fin (m + 1))
        (y : A (m + 1)
          ((Fin.cons r σ : Fin (m + 2) → ι) ∘ (k.succ).succAbove)),
        c (m + 1) σ (δ (m + 1) (Fin.cons r σ) (k.succ) y)
          = δ m σ k (c m (σ ∘ k.succAbove) ((cons_comp_succAbove_succ r σ k) ▸ y)))
    {m : ℕ} (t : ∀ σ : Fin (m + 1) → ι, A (m + 1) σ)
    (ht : depDiff δ t = 0) (σ : Fin (m + 1) → ι) :
    depDiff δ (depHomotopy r c t) σ = t σ := by
  have h := depHomotopy_spec r δ c hu hsh t σ
  rw [show depHomotopy r c (depDiff δ t) σ = 0 by rw [ht]; simp [depHomotopy], add_zero] at h
  exact h

omit [∀ m σ, AddCommGroup (A m σ)] in
/-- The composite coface tuple is symmetric under the `d²=0` index swap
`(j, i) ↦ (j.succAbove i, i.predAbove j)` (dependent analogue of the `harg` step
inside `combDifferential_comp`). -/
private lemma comp_succAbove_swap {m : ℕ} (σ : Fin (m + 2) → ι)
    (j : Fin (m + 2)) (i : Fin (m + 1)) :
    (σ ∘ (j.succAbove i).succAbove) ∘ (i.predAbove j).succAbove
      = (σ ∘ j.succAbove) ∘ i.succAbove := by
  funext k
  simp only [Function.comp_apply]
  rw [Fin.succAbove_succAbove_succAbove_predAbove]

/-- **Dependent `d² = 0`** for the varying-coefficient alternating Čech complex.
Same sign-reversing involution `(j, i) ↦ (j.succAbove i, i.predAbove j)` as
`combDifferential_comp`, with the coefficient transport handled by
`comp_succAbove_swap` and the coface-commutation hypothesis `hcomm` (the two
restriction maps into `M_{s_σ}` agree — a formal property of localisation maps,
independent of the choice of `r`). -/
private lemma depDiff_comp
    (hcomm : ∀ {m : ℕ} (σ : Fin (m + 2) → ι) (j : Fin (m + 2)) (i : Fin (m + 1))
        (z : A m ((σ ∘ j.succAbove) ∘ i.succAbove)),
        δ (m + 1) σ j (δ m (σ ∘ j.succAbove) i z)
          = δ (m + 1) σ (j.succAbove i)
              (δ m (σ ∘ (j.succAbove i).succAbove) (i.predAbove j)
                ((comp_succAbove_swap σ j i).symm ▸ z)))
    {m : ℕ} (t : ∀ σ : Fin m → ι, A m σ) :
    depDiff δ (depDiff δ t) = 0 := by
  funext σ
  simp only [depDiff, Pi.zero_apply, map_sum, map_zsmul, Finset.smul_sum, smul_smul]
  rw [← Fintype.sum_prod_type (f := fun p : Fin (m + 2) × Fin (m + 1) =>
    ((-1 : ℤ) ^ (p.1 : ℕ) * (-1) ^ (p.2 : ℕ)) •
      δ (m + 1) σ p.1 (δ m (σ ∘ p.1.succAbove) p.2 (t ((σ ∘ p.1.succAbove) ∘ p.2.succAbove))))]
  apply Finset.sum_involution (fun p _ => (p.1.succAbove p.2, p.2.predAbove p.1))
  · rintro ⟨j, i⟩ _
    rw [← add_smul, combSign_flip j i]
    rw [hcomm σ j i, depTransport (comp_succAbove_swap σ j i) t]
    simp
  · rintro ⟨j, i⟩ _ _
    simp only [ne_eq, Prod.mk.injEq, not_and]
    intro hj
    exact absurd hj (Fin.succAbove_ne j i)
  · rintro ⟨j, i⟩ _
    simp only [Prod.mk.injEq]
    exact ⟨Fin.succAbove_succAbove_predAbove j i, Fin.predAbove_predAbove_succAbove j i⟩
  · intro a _; exact Finset.mem_univ _

end Dependent

end CombinatorialCech

end AlgebraicGeometry
