# Mathlib-analogist directive — GF generic-rank-SES Lean API (slug: gf-genrank)

## Mode: api-alignment

## Background
Project file `AlgebraicJacobian/Picard/FlatteningStratification.lean`, namespace `GenericFreeness`.
We are formalizing the polynomial-ring core of generic freeness (Nitsure §4), Lean decl
`exists_free_localizationAway_polynomial`:

  Let `A` be a noetherian domain, `d ≥ 0`, and `N` a finite module over `P_d := MvPolynomial (Fin d) A`,
  also an `A`-module with `IsScalarTower A P_d N`. Then ∃ f : A, f ≠ 0 ∧
  `Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) N)`.

The proof is strong induction on `d` (`Nat.strong_induction_on generalizing N` — already landed). The
NON-TORSION inductive step is the Mathlib-absent residue. Following Nitsure §4 verbatim:

  Let `m` = generic rank of `N` over the domain `P_d = A[X_1,…,X_d]`. There is a short exact sequence
  of `P_d`-modules  `0 → P_d^{⊕m} → N_g → T → 0`  (after inverting some `g ≠ 0` in `A`), with `T` a
  finite torsion `P_d`-module. The support of `K ⊗ T` (K = Frac A) has dimension `< d`, so `T` is
  finite over a polynomial ring in fewer variables after a further inversion; the IH applied to `T`
  gives `h ≠ 0` with `T_h` free over `A_{gh}`; splicing the SES (already-proved L3
  `exists_free_localizationAway_of_shortExact`) gives `N_f` free over `A_f`, `f = gh`.

## The decision I need you to align (this is the named STUCK-risk for the route)
The iter-006 prover stopped short of stubbing the sub-lemmas because "exact type signatures depend on
the generic-rank API one chooses." I need the Mathlib-idiomatic Lean encoding for THREE things, so a
blueprint-writer can pin concretely-typed sub-lemma signatures that a prover can actually formalize:

1. **Generic rank.** How does Mathlib idiomatically express "the generic rank of a finite module `N`
   over a polynomial ring `P_d = MvPolynomial (Fin d) A` (A a noetherian domain)"? Candidates to
   assess: `Module.finrank (FractionRing P_d) (LocalizedModule (nonZeroDivisors P_d) N)`; or
   `Module.rank`; or base-changing `N` to `FractionRing P_d` via `TensorProduct`. Which gives the
   cleanest path to "choose `m` elements of `N` whose images are a basis of `N ⊗ Frac(P_d)`"? Is there
   a Mathlib lemma giving a basis / linear independence of lifted elements (e.g. `Basis`, 
   `Module.Free.chooseBasis`, `FiniteDimensional` over the fraction field, `Module.finBasis`)?

2. **The generic-rank SES `0 → P_d^{⊕m} → N_g → T → 0`.** What is the Mathlib idiom for: choosing `m`
   elements of `N`, building the `P_d`-linear map `P_d^{⊕m} → N` (`Fintype.linearCombination` /
   `Finsupp.linearCombination` / `Basis.constr`), showing it is injective after inverting a suitable
   `g` (so the cokernel `T` is torsion), and defining `T` as the cokernel? Is there existing API for
   "a map of f.g. modules over a Noetherian domain that is injective after localization at the generic
   point becomes injective after inverting a single element" (denominator-clearing / `LocalizedModule`
   / `IsLocalizedModule` exactness)? Name the relevant `LocalizedModule` / `Submodule.span` /
   `Module.Finite` lemmas.

3. **Support-dimension-drop reindex of `T`.** `T` is a finite torsion `P_d`-module; we need it
   re-presented as a finite module over `MvPolynomial (Fin m') A` with `m' < d` so the IH (which
   universally quantifies the module type over `MvPolynomial (Fin m') A`) applies. What Mathlib API
   exists for: the annihilator of a torsion f.g. module over `P_d` being a nonzero ideal, Noether
   normalization of the quotient `P_d / Ann(T)` giving a module-finite polynomial subring in fewer
   variables (`MvPolynomial (Fin m') A`)? Relevant: `Module.support`, `Module.annihilator`,
   `Ideal.height`/`Ring.KrullDim`, `Algebra.IsIntegral`, Noether normalization
   (`exists_finite_inj_algHom_of_fg` / `MvPolynomial` normalization). Is the "dimension < d ⟹ finite
   over fewer variables" step available, or is it itself a project-side build?

Also re-confirm the existence/spelling of `induction_on_isQuotientEquivQuotientPrime` (the
prime-filtration device named in STRATEGY.md) — the strategy-critic flagged it as a name to verify.

## Deliverable
For each of the three pieces: the Mathlib-idiomatic API path (named declarations, verified to exist
via lean search), OR an explicit "Mathlib-absent → project must build it" verdict with the closest
existing scaffolding. Recommend the concrete Lean SIGNATURE shape for the two sub-lemmas the
blueprint will pin: `gf_generic_rank_ses` (constructs the SES) and `gf_torsion_reindex` (re-presents
T over fewer variables). Write the persistent rationale to `analogies/gf-generic-rank-ses.md`.
