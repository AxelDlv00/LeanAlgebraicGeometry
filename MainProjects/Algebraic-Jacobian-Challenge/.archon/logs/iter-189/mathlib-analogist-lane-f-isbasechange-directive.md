# Mathlib Analogist Directive

## Slug
lane-f-isbasechange

## Mode
api-alignment

## Context

Lane F (`Picard/QuotScheme.lean`) is the A.2.b.iii Quot assembly lane.
iter-188 progress-critic verdict: STUCK (sorry +2 net over K=4 iters,
9→11; 6 helpers added across all 4 iters; PARTIAL×4 prover statuses;
deferral phrases "IsBaseChange Prop deferred" and "Step 4 deferred"
persisting ≥2 consecutive iters).

iter-188 progress: `pullback_app_isoTensor_baseMap_isBaseChange` body
closed axiom-clean (net 0; 1 closed + 1 added in a NEW named
typed-sorry helper `pullback_app_isoTensor_baseMap_sectionLinearEquiv`
at L630). The helper packages a `Nonempty (Σ' equiv, intertwining)`
sigma-pair for `IsBaseChange.of_equiv` consumption. The substantive
content is now fully localized into the helper.

iter-189 progress-critic recommends:
- **Primary corrective**: blueprint expansion of `_sectionLinearEquiv`
  / `IsBaseChange` step to a Lean-4-friendly decomposition.
- **Secondary corrective**: Mathlib analogy consult on `IsBaseChange.of_equiv`
  path taken in iter-188 — confirm whether this is the correct API path.

iter-187 analogy verdict (analogies/quotscheme-isbasechange-tilde.md):
the "wrong `Module.Flat.isBaseChange` framing" was identified as a
category mistake (stability lemma, NOT producer); fixed by threading
`[N.IsQuasicoherent]` through 9 consumer signatures + landing
`pullback_tildeIso` (Stacks 01HQ, ~115-200 LOC typed sorry) +
`pushforward_isQuasicoherent` (Stacks 01XJ, ~30 LOC typed sorry).

The remaining substrate is the iter-188 helper's body:
`pullback_app_isoTensor_baseMap_sectionLinearEquiv` returns
`Nonempty {f : TensorProduct Γ(X, V) Γ(Y, U) Γ(N, V) ≃ₗ[Γ(Y, U)]
Γ((pullback g).obj N, U) // ∀ x, f (1 ⊗ x) = baseMap g N e x}`. Body
documents a 5-step Tilde-isoTop route (Stacks 01HQ transport +
`hU.isoSpec` + `tilde.isoTop` + Spec-restriction transport + naturality
of adjunction unit).

## Question (api-alignment mode)

Look at Mathlib at b80f227 and report:

1. **Is `IsBaseChange.of_equiv` the correct API path** for the
   project's situation? Specifically:
   - The project wants to prove `IsBaseChange e (canonicalBaseChangeMap g e)`
     for the section-level `e` provided by `baseMap g N e`.
     `IsBaseChange.of_equiv` takes a `LinearEquiv` and a property:
     `∀ x, f (1 ⊗ x) = baseMap x`. Is this the intended consumer?
   - Or should the project instead use `IsBaseChange.of_lift_unique`
     or a different constructor? Name the alternative.

2. **What is the cleanest Mathlib-aligned recipe** for proving the
   `Nonempty` (or non-`Nonempty`) Σ-pair signature? Specifically:
   - Should the project drop the `Nonempty` wrapper and return a bare
     `∃ f, ∀ x, ...` proposition?
   - Or use `Sigma` (with `.snd` extracting the intertwining)?
   - Is there a Mathlib `LinearEquiv.intertwines` predicate that
     packages this?

3. **What is the natural Lean-4-friendly decomposition** of the
   5-step Tilde-isoTop route? Specifically, name the Mathlib lemmas
   needed for each step:
   - Step 1 (`N|_V ≅ tilde Γ(N,V)`): is this Mathlib's
     `Scheme.Modules.IsQuasicoherent.iso_tilde`? Verify at b80f227.
   - Step 2 (Stacks 01HQ pullback via Spec.map): `pullback_tildeIso`
     (project typed sorry). Any cleaner Mathlib API?
   - Step 3 (transport via `hU.isoSpec` back to `U`-sections): name
     the Mathlib lemma.
   - Step 4 (evaluate at `⊤` via `tilde.isoTop`): name the Mathlib lemma.
   - Step 5 (naturality of adjunction unit): name the Mathlib lemma.

4. **Verdict**:
   - **(A) STRUCTURAL OK**: the `IsBaseChange.of_equiv` path is right;
     iter-189 blueprint expansion + prover dispatch can proceed.
   - **(B) STRUCTURAL ALIGN**: use Mathlib's preferred API
     (`of_lift_unique` / direct `IsBaseChange.mk` / other); the
     project's path should pivot.
   - **(C) STRUCTURAL BLOCKED**: no Mathlib path; either need
     project-side substrate build OR route pivot (e.g., bypass
     `IsBaseChange` for this step entirely).

## Project-side declarations to consider

- `AlgebraicJacobian/Picard/QuotScheme.lean` — Lane F file (~600+ LOC).
- `blueprint/src/chapters/Picard_QuotScheme.tex` — iter-188 added
  `def:pullback_app_isoTensor_sigma` (plan-phase pin) + iter-187
  `lem:pullback_tildeIso` + `lem:pushforward_isQuasicoherent`.
- `analogies/quotscheme-isbasechange-tilde.md` — iter-187 verdict.

## Dead ends ruled out

- `Module.Flat.isBaseChange` (iter-187 category mistake; permanently
  ruled out).
- Direct `IsBaseChange.ofEquiv` without the `Nonempty` Σ-pair
  wrapper (iter-188 verified it doesn't elaborate cleanly on the
  Lane F situation due to typeclass instance friction on `e`).

## Expected report sections

- Section 1: `IsBaseChange.of_equiv` API survey at b80f227.
- Section 2: Σ-pair packaging idiom (Mathlib analogues / alternatives).
- Section 3: 5-step Tilde-isoTop route Mathlib lemmas per step.
- Section 4: STRICT verdict A / B / C with concrete recommendation.
