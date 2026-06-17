# Mathlib Analogist Report

## Mode
api-alignment

## Slug
lane-f-isbasechange

## Iteration
189

## Question

iter-189 directive three sub-questions:

1. Is `IsBaseChange.of_equiv` the correct Mathlib API path for proving
   `IsBaseChange e (pullback_app_isoTensor_baseMap g N e)` at Lane F,
   or should the project switch to `IsBaseChange.of_lift_unique` /
   `IsBaseChange.mk` / a different constructor?
2. What is the cleanest Mathlib-aligned recipe for the `Nonempty
   {f // ∀ x, ...}` Σ-pair signature?
3. What are the Mathlib lemmas behind each of the 5 steps of the
   Tilde-isoTop route?

Verdict: (A) STRUCTURAL OK / (B) STRUCTURAL ALIGN / (C) STRUCTURAL
BLOCKED.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. `IsBaseChange.of_equiv` API path | PROCEED — identical to Mathlib idiom | informational |
| 2. `Nonempty Σ-pair` packaging | PROCEED — divergent-equivalent | informational |
| 3a. 5-step route — Steps 4 (`tilde.isoTop`), 5 (`tilde.adjunction`) | PROCEED — Mathlib supplies | informational |
| 3b. 5-step route — Steps 1, 2, 3 | NEEDS_MATHLIB_GAP_FILL | high |
| 4. Pin Steps 1 and 3 separately (parallel to Step 2's `pullback_tildeIso` pin) | ALIGN_WITH_MATHLIB | critical |

## Must-fix-this-iter

- **Decision 4 — Pin Steps 1 and 3 as separately-named typed sorries.**
  Project's `pullback_app_isoTensor_baseMap_sectionLinearEquiv`
  (`Picard/QuotScheme.lean:597-649`) bundles THREE independent Mathlib
  gaps (Stacks 01I8 + 01HQ + the "pullback-along-open-immersion =
  restriction" lemma) into one typed sorry, while only ONE of them
  (Step 2 = `pullback_tildeIso` at L562, Stacks 01HQ) has a named pin.

  Refactor: add two new typed-sorry pins to
  `AlgebraicJacobian/Picard/QuotScheme.lean`, parallel to the existing
  `pullback_tildeIso`:

  - `tildeIso_of_isQuasicoherent_isAffineOpen`
    (Step 1, Stacks 01I8 content: extract `N|_V ≅ tilde Γ(N, V)` on
    `Spec Γ(X, V)` from `[N.IsQuasicoherent]` + `hV : IsAffineOpen V`).
    ~20-40 LOC body.

  - `pullback_of_openImmersion_iso_restrict`
    (Step 3: pullback along `U.ι` is restriction-to-`U`; the
    `hU.isoSpec` transport packages this for affine `U`). ~30-50 LOC.

  After this refactor, the body of
  `pullback_app_isoTensor_baseMap_sectionLinearEquiv` becomes pure
  compositional glue (`LinearEquiv.trans`-style chaining over the
  three named pins + `tilde.isoTop` + adjunction naturality) and
  closes axiom-clean. The STUCK pattern (iter-185 → iter-188; K=4
  iters; +2 sorry net; 6 helpers; PARTIAL×4) is caused by provers
  iterating on a bundled gap without a way to localize residual
  obstruction — pinning Steps 1 and 3 separately is the corrective.

## Informational

- **Decision 1 (`IsBaseChange.of_equiv` path)**: identical to Mathlib
  idiom. The Mathlib signature at b80f227 is
  ```
  lemma IsBaseChange.of_equiv (e : S ⊗[R] M ≃ₗ[S] N)
      (he : ∀ x, e (1 ⊗ₜ x) = f x) : IsBaseChange S f
  ```
  (`Mathlib/RingTheory/IsTensorProduct.lean:394`). The project's
  iter-188 dispatch
  `IsBaseChange.of_equiv equiv hApp` at
  `QuotScheme.lean:695` matches this verbatim. **NO PIVOT NEEDED.**

  Alternatives ruled out:
  - `IsBaseChange.of_lift_unique` (same file:428) requires a universal-
    property hypothesis `∀ Q [...], ∀ g : M →ₗ[R] Q, ∃! g' : N →ₗ[S] Q, ...` —
    structurally harder to discharge from a concrete Spec-side equiv,
    and requires the same Mathlib gaps anyway.
  - `IsBaseChange.ofEquiv` (capital E, same file:473) only handles
    `e : M ≃ₗ[R] N` (trivial `R → R` base change). Inapplicable.

- **Decision 2 (`Nonempty Σ-pair` packaging)**: Mathlib has no
  `LinearEquiv.intertwines` predicate. The three legal idioms are:
  (a) two declarations — `noncomputable def` for the equiv + `theorem`
      for the intertwining (best AFTER the body is closed);
  (b) bare `∃ f : LinearEquiv ..., ∀ x, ...` (Prop existential of a
      Type-valued witness — legal because `LinearEquiv` is a `Type`);
  (c) `Nonempty {f : LinearEquiv // ∀ x, ...}` — the project's choice.
  (c) is mildly noisier than (b) but functionally equivalent. PROCEED;
  optional cosmetic refactor to (b) would save ~1 LOC at the consumer.

- **Decision 3 (5-step route — Mathlib lemma map)**:
  - Step 1 (`N|_V ≅ tilde Γ(N,V)`): NEEDS_MATHLIB_GAP_FILL. Closest
    Mathlib pieces are `isIso_fromTildeΓ_iff` (`Tilde.lean:340`) and
    `isIso_fromTildeΓ_of_presentation` (`Tilde.lean:398`); the
    obstruction is extracting a presentation of `(N|_V).overSpec`
    from `[N.IsQuasicoherent]` (Stacks 01I8). `SheafOfModules.IsQuasicoherent`
    (`Quasicoherent.lean:249`) only supplies a cover + per-cover-
    element presentations, not a presentation on a chosen affine open.
  - Step 2 (`pullback_tildeIso`, Stacks 01HQ): NEEDS_MATHLIB_GAP_FILL.
    No Mathlib lemma at b80f227 — pinned project-side as
    `QuotScheme.lean:562`.
  - Step 3 (`hU.isoSpec` transport to `U`-sections):
    NEEDS_MATHLIB_GAP_FILL. `IsAffineOpen.isoSpec` (`AffineScheme.lean:380`)
    and `IsAffineOpen.fromSpec` (same file:414) supply the
    iso/morphism, but Mathlib lacks "module-pullback along an open
    immersion ≅ restriction to that open" at b80f227.
  - Step 4 (`tilde.isoTop`): MATHLIB HAS at `Tilde.lean:177`.
  - Step 5 (naturality of adjunction unit): MATHLIB HAS the adjunction
    (`Tilde.lean:279`) and `IsIso unit` instance (`Tilde.lean:307`);
    the specific intertwining with `pullback_app_isoTensor_unitAtV` is
    project-side glue (~20-40 LOC of bookkeeping), NOT a Mathlib gap.

## Persistent file
- `analogies/lane-f-isbasechange.md` — design-rationale captured for
  future iters (full per-decision write-up + Mathlib precedent table).

**Overall verdict**: **(A) STRUCTURAL OK.** The `IsBaseChange.of_equiv`
choice is the correct Mathlib API path; no pivot is warranted. iter-189
blueprint expansion can proceed, but should be paired with a critical
refactor that pins Steps 1 and 3 as separate named typed sorries
(parallel to Step 2's existing `pullback_tildeIso` pin) — this
unbundles the STUCK helper into three independent Mathlib gaps that
provers can target individually.
