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
  --     is contracted by the prepend homotopy.  TWO forms are now available:
  --       - constant coefficients: `combDifferential_exact` (`Function.Exact`);
  --       - *varying* coefficients `M_{s_σ}` (the dependent-coefficient port the
  --         localised complex actually has): `CombinatorialCech.Dependent.*`,
  --         culminating in `depDiff_exact` — the `Function.Exact` of the
  --         dependent alternating differential, given the away-localisation
  --         maps `δ` (cofaces), `c` (prepend isos), and their unit/shift/comm
  --         compatibilities `hu`/`hsh`/`hcomm`.  This is the exact shape L2
  --         consumes per node after localising at `s_r`.
  -- L3 (both forms) is the from-scratch combinatorial core that the iter-011
  -- prover was blocked on; it is now available as `CombinatorialCech.*` and
  -- `CombinatorialCech.Dependent.*`, all axiom-clean.  The remaining hole is
  -- purely the L1 categorical identification of `CechComplex`'s terms with the
  -- away-localisation modules `M_{s_σ}` (and of `IsZero (homology p)` with the
  -- `Function.Exact` of the localised differentials), together with the
  -- construction of the concrete `δ`/`c` maps from `IsLocalizedModule.Away`
  -- (Mathlib `AlgebraicGeometry.Modules.Tilde`:
  -- `IsLocalizedModule (.powers f) (tilde.toOpen M (basicOpen f)).hom`) and the
  -- discharge of `hu`/`hsh`/`hcomm` for those maps.  This bridge needs new
  -- sheaf-section infrastructure (sections of `pushPullObj F` over basic opens =
  -- localised modules; the abstract cosimplicial differential = the alternating
  -- localisation coboundary) — see `task_results` for the precise gap.
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
    simp only []
    rw [hcomm σ j i (t _), depTransport (comp_succAbove_swap σ j i).symm t,
      ← add_smul, combSign_flip j i]
    simp
  · rintro ⟨j, i⟩ _ _
    simp only [ne_eq, Prod.mk.injEq, not_and]
    intro hj
    exact absurd hj (Fin.succAbove_ne j i)
  · rintro ⟨j, i⟩ _
    simp only [Prod.mk.injEq]
    exact ⟨Fin.succAbove_succAbove_predAbove j i, Fin.predAbove_predAbove_succAbove j i⟩
  · intro a _; exact Finset.mem_univ _

/-- **Dependent positive-degree exactness** in the `Function.Exact` form that
`exact_of_isLocalized_span` (planner **L2**) consumes after localising at a
spanning element `s_r`.  Combines `depDiff_comp` (`im ⊆ ker`) with
`depDiff_eq_of_cocycle` (`ker ⊆ im`, the homotopy half carrying the
`s_r`-invertibility input).  This is the dependent-coefficient analogue of
`combDifferential_exact`. -/
private lemma depDiff_exact
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
    (hcomm : ∀ {m : ℕ} (σ : Fin (m + 2) → ι) (j : Fin (m + 2)) (i : Fin (m + 1))
        (z : A m ((σ ∘ j.succAbove) ∘ i.succAbove)),
        δ (m + 1) σ j (δ m (σ ∘ j.succAbove) i z)
          = δ (m + 1) σ (j.succAbove i)
              (δ m (σ ∘ (j.succAbove i).succAbove) (i.predAbove j)
                ((comp_succAbove_swap σ j i).symm ▸ z)))
    (m : ℕ) :
    Function.Exact (depDiff δ (m := m + 1)) (depDiff δ (m := m + 2)) := by
  intro x
  constructor
  · intro hx
    exact ⟨depHomotopy r c x,
      funext fun σ => depDiff_eq_of_cocycle r δ c hu hsh x hx σ⟩
  · rintro ⟨y, rfl⟩
    exact depDiff_comp δ hcomm y

end Dependent

end CombinatorialCech

/-! ## Project-local Mathlib supplement — away-localisation comparison maps

The concrete `δ` (coface) and `c` (prepend) maps that the dependent combinatorial
core `CombinatorialCech.Dependent.depDiff_exact` consumes are, for the standard
affine cover, the canonical comparison maps between away-localisations
`M_a → M_b` available whenever `a ∣ b` — so that `a`, a divisor of the invertible
`b`, is itself invertible in `M_b`.  This section builds that comparison map and
its functoriality from `IsLocalizedModule` abstractly, independent of the sheaf
identification (L1), so it can be assembled into the localised {\v C}ech complex.

Everything here is `R`-module algebra; no sheaf theory enters. The maps are
characterised by uniqueness of localisation lifts (`IsLocalizedModule.lift_unique`),
which is what makes the composition/identity laws — the algebraic heart of the
`hu`/`hsh`/`hcomm` compatibilities — provable. -/

namespace AwayComparison

variable {R : Type u} [CommRing R] {M : Type u} [AddCommGroup M] [Module R M]

/-- The clean hypothesis under which a canonical comparison `M_a → Mb` exists: the
element `a` acts invertibly on the target localisation `Mb`. Because the scalar
action is `algebraMap` into the (central) endomorphism ring, this is closed under
multiplication and holds for any divisor of an already-invertible element — exactly
the two ways `δ` (divisibility) and `c` (a product of invertible factors) arise. -/
def Inverts (a : R) (Mb : Type u) [AddCommGroup Mb] [Module R Mb] : Prop :=
  IsUnit (algebraMap R (Module.End R Mb) a)

/-- A divisor `a` of `b` acts invertibly on any localisation `M_b` of `M` away
from `b`: since `b` is a unit there and `b = a · c` with the scalar actions
commuting (both lie in the image of the central `algebraMap`), `a` is a unit too. -/
lemma Inverts.of_dvd {a b : R} (hab : a ∣ b)
    {Mb : Type u} [AddCommGroup Mb] [Module R Mb] (fb : M →ₗ[R] Mb)
    [IsLocalizedModule (Submonoid.powers b) fb] :
    Inverts a Mb := by
  obtain ⟨c, rfl⟩ := hab
  have hb : IsUnit (algebraMap R (Module.End R Mb) (a * c)) :=
    IsLocalizedModule.map_units fb ⟨a * c, Submonoid.mem_powers _⟩
  rw [map_mul] at hb
  have hcomm : Commute (algebraMap R (Module.End R Mb) a) (algebraMap R (Module.End R Mb) c) :=
    (Commute.all a c).map _
  exact (hcomm.isUnit_mul_iff.mp hb).1

/-- `Inverts` is closed under multiplication: a product of invertibly-acting
elements acts invertibly. This supplies the `c` (prepend) comparison, whose source
localising element `s_r · s_{cons r σ}` factors into divisors of the target. -/
lemma Inverts.mul {a a' : R} {Mb : Type u} [AddCommGroup Mb] [Module R Mb]
    (ha : Inverts a Mb) (ha' : Inverts a' Mb) : Inverts (a * a') Mb := by
  rw [Inverts, map_mul]
  exact IsUnit.mul ha ha'

/-- The power version of the `Inverts` hypothesis, as the `IsLocalizedModule.lift`
universal property consumes it (`∀ x ∈ powers a`). -/
lemma Inverts.isUnit_powers {a : R} {Mb : Type u} [AddCommGroup Mb] [Module R Mb]
    (ha : Inverts a Mb) (x : Submonoid.powers a) :
    IsUnit (algebraMap R (Module.End R Mb) (x : R)) := by
  obtain ⟨n, hn⟩ := x.2
  rw [← hn, map_pow]
  exact ha.pow n

/-- The canonical comparison map `M_a → Mb` between localisations of `M`, defined
whenever `a` acts invertibly on `Mb` (`Inverts a Mb`). It is the unique `R`-linear
map `M_a → Mb` commuting with the localisation structure maps (`comparison_unique`);
this universal characterisation is what makes the functoriality laws below provable. -/
noncomputable def comparison {a : R}
    {Ma Mb : Type u} [AddCommGroup Ma] [Module R Ma] [AddCommGroup Mb] [Module R Mb]
    (fa : M →ₗ[R] Ma) [IsLocalizedModule (Submonoid.powers a) fa]
    (fb : M →ₗ[R] Mb) (hb : Inverts a Mb) :
    Ma →ₗ[R] Mb :=
  IsLocalizedModule.lift (Submonoid.powers a) fa fb hb.isUnit_powers

@[simp] lemma comparison_apply {a : R}
    {Ma Mb : Type u} [AddCommGroup Ma] [Module R Ma] [AddCommGroup Mb] [Module R Mb]
    (fa : M →ₗ[R] Ma) [IsLocalizedModule (Submonoid.powers a) fa]
    (fb : M →ₗ[R] Mb) (hb : Inverts a Mb) (x : M) :
    comparison fa fb hb (fa x) = fb x :=
  IsLocalizedModule.lift_apply _ _ _ _ x

lemma comparison_comp_structure {a : R}
    {Ma Mb : Type u} [AddCommGroup Ma] [Module R Ma] [AddCommGroup Mb] [Module R Mb]
    (fa : M →ₗ[R] Ma) [IsLocalizedModule (Submonoid.powers a) fa]
    (fb : M →ₗ[R] Mb) (hb : Inverts a Mb) :
    comparison fa fb hb ∘ₗ fa = fb :=
  IsLocalizedModule.lift_comp _ _ _ _

/-- Uniqueness: any `R`-linear `l : M_a → Mb` commuting with the structure maps
equals the comparison map. -/
lemma comparison_unique {a : R}
    {Ma Mb : Type u} [AddCommGroup Ma] [Module R Ma] [AddCommGroup Mb] [Module R Mb]
    (fa : M →ₗ[R] Ma) [IsLocalizedModule (Submonoid.powers a) fa]
    (fb : M →ₗ[R] Mb) (hb : Inverts a Mb)
    (l : Ma →ₗ[R] Mb) (hl : l ∘ₗ fa = fb) :
    comparison fa fb hb = l :=
  IsLocalizedModule.lift_unique _ _ _ _ l hl

/-- **Identity law.** The comparison of a localisation with itself is the identity. -/
@[simp] lemma comparison_self {a : R}
    {Ma : Type u} [AddCommGroup Ma] [Module R Ma]
    (fa : M →ₗ[R] Ma) [IsLocalizedModule (Submonoid.powers a) fa] (ha : Inverts a Ma) :
    comparison fa fa ha = LinearMap.id :=
  comparison_unique _ _ _ _ (by ext x; simp)

/-- **Composition law** (functoriality): comparison maps compose.  Proved by
uniqueness — both sides become `fc` after precomposing with the structure map `fa`.
This is the reusable algebraic core underlying the `hsh`/`hcomm` compatibilities of
the dependent {\v C}ech port. -/
lemma comparison_comp {a b : R}
    {Ma Mb Mc : Type u} [AddCommGroup Ma] [Module R Ma] [AddCommGroup Mb] [Module R Mb]
    [AddCommGroup Mc] [Module R Mc]
    (fa : M →ₗ[R] Ma) [IsLocalizedModule (Submonoid.powers a) fa]
    (fb : M →ₗ[R] Mb) [IsLocalizedModule (Submonoid.powers b) fb]
    (fc : M →ₗ[R] Mc)
    (hb : Inverts a Mb) (hc : Inverts b Mc) (hac : Inverts a Mc) :
    (comparison fb fc hc) ∘ₗ (comparison fa fb hb) = comparison fa fc hac :=
  (comparison_unique fa fc hac _ (by
    ext x
    simp only [LinearMap.coe_comp, Function.comp_apply, comparison_apply])).symm

/-- Pointwise form of the composition law. -/
lemma comparison_comp_apply {a b : R}
    {Ma Mb Mc : Type u} [AddCommGroup Ma] [Module R Ma] [AddCommGroup Mb] [Module R Mb]
    [AddCommGroup Mc] [Module R Mc]
    (fa : M →ₗ[R] Ma) [IsLocalizedModule (Submonoid.powers a) fa]
    (fb : M →ₗ[R] Mb) [IsLocalizedModule (Submonoid.powers b) fb]
    (fc : M →ₗ[R] Mc)
    (hb : Inverts a Mb) (hc : Inverts b Mc) (hac : Inverts a Mc) (x : Ma) :
    comparison fb fc hc (comparison fa fb hb x) = comparison fa fc hac x :=
  LinearMap.congr_fun (comparison_comp fa fb fc hb hc hac) x

end AwayComparison

/-! ## Project-local Mathlib supplement — multi-index localising elements

The localising element attached to a {\v C}ech multi-index `σ : Fin m → ι` is the
product `s_σ = ∏ₖ s (σ k)`.  The two divisibility facts below are exactly the
hypotheses the away-comparison maps of `AwayComparison` need to become the
coface `δ` and prepend `c` maps of the dependent combinatorial core: a coface
deletes an index (so `s_{σ∘dⱼ} ∣ s_σ`), and the prepend multiplies by `s r`. -/

namespace CechLocalized

variable {R : Type u} [CommRing R] {ι : Type*} (s : ι → R)

/-- `s_σ = ∏ₖ s (σ k)`, the localising element for the multi-index `σ`. -/
def sprod {m : ℕ} (σ : Fin m → ι) : R := ∏ k, s (σ k)

@[simp] lemma sprod_cons {m : ℕ} (i : ι) (σ : Fin m → ι) :
    sprod s (Fin.cons i σ) = s i * sprod s σ := by
  simp [sprod, Fin.prod_univ_succ]

/-- A coface (index deletion) only drops the factor `s (σ j)`, so the smaller
product divides the larger: `s_{σ∘dⱼ} ∣ s_σ`.  This supplies the `Inverts`
hypothesis for the coface comparison `δ`. -/
lemma sprod_succAbove_dvd {m : ℕ} (σ : Fin (m + 1) → ι) (j : Fin (m + 1)) :
    sprod s (σ ∘ j.succAbove) ∣ sprod s σ := by
  have h : sprod s σ = s (σ j) * sprod s (σ ∘ j.succAbove) := by
    rw [sprod, sprod, Fin.prod_univ_succAbove _ j]; rfl
  exact ⟨s (σ j), by rw [h]; ring⟩

/-! ### The localised coefficient family and the concrete `δ`/`c` maps

After localising the whole section {\v C}ech complex at a spanning element `s r`,
its degree-`p` coefficient at the multi-index `σ` is `M` localised at the product
`s r · s_σ` (the away localisation at `s_σ`, further localised at `s r`).  We model
that double localisation by the single away localisation at `s r · s_σ`.  The coface
`δ` and prepend `c` maps are the away-comparison maps of `AwayComparison`; the
`Inverts` hypotheses come from `sprod_succAbove_dvd` (for `δ`) and from
`Inverts.mul` together with `sprod_cons` (for `c`). -/

variable (M : Type u) [AddCommGroup M] [Module R M] (r : ι)

/-- The localised {\v C}ech coefficient `A_σ = M_{s r · s_σ}` (after localising at the
fixed index `r`). -/
abbrev cechCoeff {m : ℕ} (σ : Fin m → ι) : Type u :=
  LocalizedModule (Submonoid.powers (s r * sprod s σ)) M

/-- The coface comparison `δ : A_{σ∘dⱼ} → A_σ`, the canonical localisation map for the
divisibility `s r · s_{σ∘dⱼ} ∣ s r · s_σ`. -/
noncomputable def cechCoface (m : ℕ) (σ : Fin (m + 1) → ι) (j : Fin (m + 1)) :
    cechCoeff s M r (σ ∘ j.succAbove) →+ cechCoeff s M r σ :=
  (AwayComparison.comparison (M := M)
    (LocalizedModule.mkLinearMap (Submonoid.powers (s r * sprod s (σ ∘ j.succAbove))) M)
    (LocalizedModule.mkLinearMap (Submonoid.powers (s r * sprod s σ)) M)
    (AwayComparison.Inverts.of_dvd (mul_dvd_mul_left (s r) (sprod_succAbove_dvd s σ j))
      (LocalizedModule.mkLinearMap (Submonoid.powers (s r * sprod s σ)) M))).toAddMonoidHom

/-- The prepend comparison `c : A_{cons r σ} → A_σ`, the canonical localisation map.
Its source localises at `s r · s_{cons r σ} = s r · (s r · s_σ)`, a product whose
factors are all invertible in `A_σ`, supplied by `Inverts.mul`. -/
noncomputable def cechPrepend (m : ℕ) (σ : Fin m → ι) :
    cechCoeff s M r (Fin.cons r σ) →+ cechCoeff s M r σ :=
  (AwayComparison.comparison (M := M)
    (LocalizedModule.mkLinearMap (Submonoid.powers (s r * sprod s (Fin.cons r σ))) M)
    (LocalizedModule.mkLinearMap (Submonoid.powers (s r * sprod s σ)) M)
    (by
      change AwayComparison.Inverts (s r * sprod s (Fin.cons r σ))
        (LocalizedModule (Submonoid.powers (s r * sprod s σ)) M)
      have h : s r * sprod s (Fin.cons r σ) = s r * (s r * sprod s σ) := by
        rw [sprod_cons]
      rw [h]
      exact AwayComparison.Inverts.mul
        (AwayComparison.Inverts.of_dvd ⟨sprod s σ, rfl⟩
          (LocalizedModule.mkLinearMap (Submonoid.powers (s r * sprod s σ)) M))
        (AwayComparison.Inverts.of_dvd dvd_rfl
          (LocalizedModule.mkLinearMap (Submonoid.powers (s r * sprod s σ)) M)))).toAddMonoidHom

/-- A transport of a {\v C}ech coefficient along an equality of multi-index tuples
`τ₁ = τ₂` is the canonical comparison map (both localise `M` at the *same* element
`s r · s_τ`, since `s_τ` depends only on the function `τ`). This is the bridge
between the dependent-type transports `▸` of the combinatorial core and the
away-comparison maps. -/
lemma cechCoeff_transport_eq_comparison {m : ℕ} {τ₁ τ₂ : Fin m → ι} (hτ : τ₁ = τ₂)
    (hinv : AwayComparison.Inverts (s r * sprod s τ₁) (cechCoeff s M r τ₂))
    (y : cechCoeff s M r τ₁) :
    hτ ▸ y = AwayComparison.comparison
      (LocalizedModule.mkLinearMap (Submonoid.powers (s r * sprod s τ₁)) M)
      (LocalizedModule.mkLinearMap (Submonoid.powers (s r * sprod s τ₂)) M) hinv y := by
  subst hτ
  rw [AwayComparison.comparison_self]
  rfl

/-- **Unit compatibility** `hu` for the concrete localised {\v C}ech maps:
`c ∘ δ₀ = transport`.  Deleting the prepended `r` (the `0`-th coface) and then
applying the prepend `c` is, on the away localisations, the identity transport,
because all three maps are away-comparison maps and compose by `comparison_comp`. -/
lemma cech_hu {m : ℕ} (σ : Fin (m + 1) → ι)
    (y : cechCoeff s M r ((Fin.cons r σ : Fin (m + 2) → ι) ∘ (0 : Fin (m + 2)).succAbove)) :
    cechPrepend s M r (m + 1) σ (cechCoface s M r (m + 1) (Fin.cons r σ) 0 y)
      = (CombinatorialCech.cons_comp_zero_succAbove r σ) ▸ y := by
  have heq : (Fin.cons r σ : Fin (m + 2) → ι) ∘ (0 : Fin (m + 2)).succAbove = σ :=
    CombinatorialCech.cons_comp_zero_succAbove r σ
  have hinv : AwayComparison.Inverts
      (s r * sprod s ((Fin.cons r σ : Fin (m + 2) → ι) ∘ (0 : Fin (m + 2)).succAbove))
      (cechCoeff s M r σ) :=
    AwayComparison.Inverts.of_dvd (dvd_of_eq (by rw [heq])) (LocalizedModule.mkLinearMap _ M)
  simp only [cechPrepend, cechCoface, LinearMap.toAddMonoidHom_coe]
  change _ = heq ▸ y
  rw [cechCoeff_transport_eq_comparison s M r heq hinv,
    AwayComparison.comparison_comp_apply]

/-- **Shift compatibility** `hsh` for the concrete localised {\v C}ech maps:
`c ∘ δ_{k+1} = δ_k ∘ c` (modulo the index transport).  Both composites are
away-comparison maps from the same source localisation to the same target, hence
equal — assembled from `comparison_comp` and the transport bridge. -/
lemma cech_hsh {m : ℕ} (σ : Fin (m + 1) → ι) (k : Fin (m + 1))
    (y : cechCoeff s M r ((Fin.cons r σ : Fin (m + 2) → ι) ∘ (k.succ).succAbove)) :
    cechPrepend s M r σ (cechCoface s M r (Fin.cons r σ) k.succ y)
      = cechCoface s M r σ k
          (cechPrepend s M r (σ ∘ k.succAbove)
            ((CombinatorialCech.cons_comp_succAbove_succ r σ k) ▸ y)) := by
  have heq' : (Fin.cons r σ : Fin (m + 2) → ι) ∘ (k.succ).succAbove
      = Fin.cons r (σ ∘ k.succAbove) := CombinatorialCech.cons_comp_succAbove_succ r σ k
  have hinv' : AwayComparison.Inverts
      (s r * sprod s ((Fin.cons r σ : Fin (m + 2) → ι) ∘ (k.succ).succAbove))
      (cechCoeff s M r (Fin.cons r (σ ∘ k.succAbove))) :=
    AwayComparison.Inverts.of_dvd (dvd_of_eq (by rw [heq'])) (LocalizedModule.mkLinearMap _ M)
  have key : AwayComparison.Inverts (s r * sprod s (Fin.cons r (σ ∘ k.succAbove)))
      (cechCoeff s M r σ) := by
    rw [show s r * sprod s (Fin.cons r (σ ∘ k.succAbove))
          = s r * (s r * sprod s (σ ∘ k.succAbove)) from by rw [sprod_cons]]
    exact AwayComparison.Inverts.mul
      (AwayComparison.Inverts.of_dvd (dvd_mul_right (s r) (sprod s σ))
        (LocalizedModule.mkLinearMap _ M))
      (AwayComparison.Inverts.of_dvd (mul_dvd_mul_left (s r) (sprod_succAbove_dvd s σ k))
        (LocalizedModule.mkLinearMap _ M))
  simp only [cechPrepend, cechCoface, LinearMap.toAddMonoidHom_coe]
  rw [cechCoeff_transport_eq_comparison s M r heq' hinv',
    AwayComparison.comparison_comp_apply, AwayComparison.comparison_comp_apply,
    AwayComparison.comparison_comp_apply]
  · rw [heq']; exact key
  · exact key

/-- **Coface commutation** `hcomm` (the `d² = 0` swap identity) for the concrete
localised {\v C}ech maps.  Both bracketings of the double coface are away-comparison
maps from the (swap-invariant) double-deletion localisation to `A_σ`, hence equal. -/
lemma cech_hcomm {m : ℕ} (σ : Fin (m + 2) → ι) (j : Fin (m + 2)) (i : Fin (m + 1))
    (z : cechCoeff s M r ((σ ∘ j.succAbove) ∘ i.succAbove)) :
    cechCoface s M r σ j (cechCoface s M r (σ ∘ j.succAbove) i z)
      = cechCoface s M r σ (j.succAbove i)
          (cechCoface s M r (σ ∘ (j.succAbove i).succAbove) (i.predAbove j)
            ((CombinatorialCech.comp_succAbove_swap σ j i).symm ▸ z)) := by
  have heqc : (σ ∘ j.succAbove) ∘ i.succAbove
      = (σ ∘ (j.succAbove i).succAbove) ∘ (i.predAbove j).succAbove :=
    (CombinatorialCech.comp_succAbove_swap σ j i).symm
  have hinvc : AwayComparison.Inverts (s r * sprod s ((σ ∘ j.succAbove) ∘ i.succAbove))
      (cechCoeff s M r ((σ ∘ (j.succAbove i).succAbove) ∘ (i.predAbove j).succAbove)) :=
    AwayComparison.Inverts.of_dvd (dvd_of_eq (by rw [heqc])) (LocalizedModule.mkLinearMap _ M)
  have key : AwayComparison.Inverts (s r * sprod s ((σ ∘ j.succAbove) ∘ i.succAbove))
      (cechCoeff s M r σ) :=
    AwayComparison.Inverts.of_dvd
      (mul_dvd_mul_left (s r)
        (dvd_trans (sprod_succAbove_dvd s (σ ∘ j.succAbove) i) (sprod_succAbove_dvd s σ j)))
      (LocalizedModule.mkLinearMap _ M)
  simp only [cechCoface, LinearMap.toAddMonoidHom_coe]
  rw [cechCoeff_transport_eq_comparison s M r heqc hinvc,
    AwayComparison.comparison_comp_apply, AwayComparison.comparison_comp_apply,
    AwayComparison.comparison_comp_apply]
  · exact key
  · rw [CombinatorialCech.comp_succAbove_swap]; exact key

end CechLocalized

end AlgebraicGeometry
