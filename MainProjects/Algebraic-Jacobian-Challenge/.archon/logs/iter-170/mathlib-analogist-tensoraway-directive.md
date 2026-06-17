# Mathlib-Analogist Directive — Slug `tensoraway`

## Mode: api-alignment

## Why we are dispatching you

The iter-169 prover lane on `AlgebraicJacobian/Genus0BaseObjects.lean` (the `gmScalingP1` body) cited a specific Mathlib-side blocker that the planner cannot resolve from the docstring alone:

> Mathlib's `TensorProduct kbar (HomogeneousLocalization.Away 𝒜 _) (GmRing kbar)` has no `CommRing`/`Algebra` instance shipped — the `HomogeneousLocalization.Away` ring is not a `CommSemiring` in the form `TensorProduct.instCommSemiring` consumes; the bridge requires either upstreaming a `CommRing` instance (likely already there via `HomogeneousLocalization.instCommRing` — to verify) or building the chart target as an explicit `Localization.Away` quotient.

The prover explicitly flagged "likely already there via `HomogeneousLocalization.instCommRing` — to verify". The planner needs a definitive answer before deciding between escalation options (a) [Mathlib upstream PR] and (c) [inline chart-glue at scale, ~3 iters].

## The concrete declarations involved

Let:
- `kbar : Type u` with `[Field kbar]`
- `𝒜 := projectiveLineBarGrading kbar : ℕ → Submodule kbar (MvPolynomial (Fin 2) kbar)` (the standard ℕ-grading on `k̄[X_0, X_1]`)
- `Away𝒜i := HomogeneousLocalization.Away 𝒜 (X i : MvPolynomial (Fin 2) kbar)` for `i ∈ Fin 2`
- `GmRing := Localization.Away (MvPolynomial.X () : MvPolynomial Unit kbar)`

`Away𝒜i` is a `CommRing` and a `kbar`-algebra in standard Mathlib (the `instCommRing` shipped on `HomogeneousLocalization` plus the `IsScalarTower`/`Algebra` instance from the homogeneous-grading at degree 0). `GmRing` is a `CommRing` and a `kbar`-algebra (via `Localization.Away` over a `kbar`-algebra structure on `MvPolynomial Unit kbar`).

The desired ring is `TensorProduct kbar Away𝒜i GmRing` — the `kbar`-algebra tensor product. Mathlib's `Algebra.TensorProduct.instCommRing` should fire for any pair of commutative `kbar`-algebras.

## Question 1 — Does the instance actually exist?

In current Mathlib, is `TensorProduct kbar (HomogeneousLocalization.Away 𝒜 (X i : MvPolynomial (Fin 2) kbar)) (Localization.Away (MvPolynomial.X () : MvPolynomial Unit kbar))` recognized as a `CommRing` via existing `inferInstance` resolution? If not, what is the precise missing instance hop? Is it:

(i) **A real Mathlib gap** — e.g. `HomogeneousLocalization.Away` doesn't carry the right `Algebra kbar` or `CommRing` instance for `Algebra.TensorProduct.instCommRing` to fire?

(ii) **A synthesis-friction issue** — the instance exists in principle but the unification doesn't go through without a manual `letI` / `show` / `change` insertion (e.g. because `HomogeneousLocalization.Away` is an `abbrev` over `HomogeneousLocalization`, or because `IsScalarTower` propagation hits a typeclass diamond)?

(iii) **A trivial inferInstance hit** — the prover was simply mistaken; the instance fires directly.

Verify by reading the relevant Mathlib files (`Mathlib/RingTheory/GradedAlgebra/HomogeneousLocalization.lean`, `Mathlib/RingTheory/TensorProduct/Basic.lean`, `Mathlib/RingTheory/Localization/Away/Basic.lean`) AND if needed by running a 5-line MWE through `lean_run_code` instantiating the desired tensor product and asking for `inferInstance : CommRing _`.

## Question 2 — If synthesis-friction, the canonical fix

Assuming the instance exists in some form but doesn't unify directly: what is the canonical Mathlib idiom to make it fire? Examples of patterns we want named:

- `letI : Algebra kbar Away𝒜i := inferInstance` followed by the tensor (does this kick the synthesis?)
- A `change` to unfold `HomogeneousLocalization.Away` to its underlying type
- A wrapper definition that re-bundles `Away𝒜i` as a `CommAlgebra kbar Away𝒜i`-like beast

The mathematician's analogies file `analogies/gmscaling-deep.md` already discusses `HomogeneousLocalization.Away` and the chart-glue plan in detail; cite from there if relevant.

## Question 3 — If real Mathlib gap, the cost of upstreaming

If question 1 returns (i), estimate:
- How many LOC of Mathlib upstream would close the gap (with concrete file paths)?
- Is this upstream piece independently valuable to Mathlib (i.e. would a PR be accepted)?
- Cite analogous lemmas already in Mathlib for `Localization.Away` tensored with another `Algebra`, if any.

## Question 4 — Is there an alternative chart-target representation?

The iter-169 prover suggested "building the chart target as an explicit `Localization.Away` quotient". Concretely: instead of building the chart morphism via the tensor product `Away𝒜i ⊗ GmRing`, could we route through a single `Localization.Away` of a polynomial ring (e.g. `k̄[X_0, X_1, t][X_i^{-1}, t^{-1}]` or similar) whose `CommRing`/`Algebra` instances are uncontroversial? What does this cost in terms of identifying the resulting ring with the actual chart structure that `pullbackSpecIso` consumes?

Read `analogies/gmscaling-deep.md` for the prior decomposition. The chart-glue Q3 specifically uses `pullbackSpecIso`. The Q3 spelling is at `analogies/gmscaling-deep.md` ~L280-380.

## Question 5 — Does `projGm_isReduced` close via the same chart-cover idiom?

Beyond the main question: in `Genus0BaseObjects.lean` at L819, the auditor identified `projGm_isReduced : IsReduced ((ProjectiveLineBar kbar) ⊗ Gm kbar).left` as BORDERLINE — likely closable via `IsReduced.of_openCover` over the pullback cover of `D₊(X i) × Gm` (each chart `Spec(Away 𝒜 (X i) ⊗_{k̄} k̄[t, t⁻¹])`). The chart-side strategy needs that tensor to be a domain. The Mathlib lemma `Algebra.TensorProduct.NoZeroDivisors` (or equivalent for `IsDomain` / `IsReduced` over a field) — does it ship in a form that fires here? If so, ~30-60 LOC of `IsReduced.of_openCover` + chart-ring-is-domain should close this. Confirm or refute.

## Output expected

Standard api-alignment report. Verdict on each question. Recommended action for the iter-170 prover lane in <50 words: which approach to take and why. Update or create `analogies/<slug>.md` (suggest `analogies/tensoraway-instance.md`) for persistent record. Report at `task_results/mathlib-analogist-tensoraway.md`.

## Out of scope

- The functoriality-of-Proj route (route (b) per the iter-169 prover taxonomy) is gated on a separate Mathlib gap (relative-Proj base-change iso) that the iter-169 prover already verified absent. Do NOT spend cycles on that route.
- Do NOT explore strategic alternatives — that's the strategy-critic's role.
