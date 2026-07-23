---
author: sync
content_type: lemma
created: '2026-07-16T21:14:25'
decl: AlgebraicGeometry.CombinatorialCech.combDifferential_exact
docstring: '**Positive-degree exactness** of the constant-coefficient Čech complex
  in the

  `Function.Exact` form that `exact_of_isLocalized_span` (planner L2) consumes node

  by node.  Combines `combDifferential_comp` (`im ⊆ ker`) with

  `combDifferential_eq_of_cocycle` (`ker ⊆ im`, the homotopy half).  Requires a

  distinguished index `r : ι` — supplied, after localising at `s_r`, by the

  spanning element itself.'
file: AlgebraicJacobian/Cohomology/CechAcyclic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.CombinatorialCech.combDifferential_exact
type: lean
updated: '2026-07-16T21:14:25'
---
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