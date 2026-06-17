# Mathlib-analogist directive — iter-255

## Mode: api-alignment

## Question

In `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`, the lemma `pullbackTensorMap_natural`
(D1′, ~L2004) is blocked on ONE step: after `simp only [pullbackTensorMap]` unfolds the definition,
applying `Functor.OplaxMonoidal.δ_natural (F := PresheafOfModules.pullback φ') a.val b.val` FAILS
with `failed to synthesize MonoidalCategory (PresheafOfModules X.ringCatSheaf.obj)`.

The monoidal instance on `PresheafOfModules` is registered ONLY on the spelling
`X.presheaf ⋙ forget₂ CommRingCat RingCat` (Mathlib `Presheaf/Monoidal.lean:32,104-105`).
`X.ringCatSheaf.obj` is DEFEQ to that but syntactically different, so instance synthesis (syntactic)
never fires.

**Determine the MINIMAL fix and its blast radius. Specifically, rank these three options:**

(A) **LIGHT — proof-side normalisation.** Before applying `δ_natural`, a `show`/`change`/`Functor.comp`
    rewrite re-presents the domain category as the canonical `… ⋙ forget₂ …` spelling so the instance
    synthesizes — NO change to any definition. Is this viable? If so, give the exact `change`/`show`
    target (the canonical-spelling type the goal must be massaged to) and any `eqToHom`/`dsimp` lemma
    that bridges `X.ringCatSheaf.obj` ⇝ `X.presheaf ⋙ forget₂ CommRingCat RingCat`. You may TEST with
    `lean_multi_attempt` at the sorry position (L2064).

(B) **MEDIUM — local definition retype.** Change how `φ'` (and/or the δ-factor) is spelled INSIDE the
    `pullbackTensorMap` definition (~L1210-1226) so the canonical spelling survives `simp only`
    unfolding (e.g. avoid the `let φ' := φ.hom` inlining that re-exposes `X.ringCatSheaf.obj`; pin the
    δ-factor's functor to the canonical spelling via an explicit type ascription that does NOT unfold
    away). Does the def already annotate `φ'` canonically (L1214-1215) yet lose it on unfold? If a
    local retype fixes the proof WITHOUT changing the def's STATEMENT TYPE (so `pullbackTensorMap_unit_isIso`
    at L1848 — "D2′", verified axiom-clean — stays GREEN), describe it precisely.

(C) **HEAVY — structural restatement.** Restate `pullbackTensorMap` + `pullbackValIso` + the
    `sheafifyTensorUnitIso` helper isos on the canonical `⋙ forget₂` spelling throughout. Only if
    (A) and (B) both fail. Estimate LOC + whether D2′ survives.

## Project artifacts (read these)

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`:
  - `pullbackTensorMap` def: L1210–1226 (note `let φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶ … := φ.hom`
    at L1214-1215 — the δ-factor `Functor.OplaxMonoidal.δ (PresheafOfModules.pullback φ') M.val N.val`
    at L1219).
  - `pullbackValIso` def: L1193–1200.
  - `pullbackTensorMap_unit_isIso` (D2′, MUST stay green): L1848.
  - `pullbackTensorMap_natural` (the blocked D1′ proof): L2004–2064; the exact blocker + sorry at L2064
    with a long in-file comment.
  - STEP-A's working device (for context — how the project already beat a sibling instance-spelling
    collision): `sheafifyTensorUnitIso_hom_eq'` (private, ~L1882) + the `(C := …)`-pinned term-level
    application of `tensorHom_comp_tensorHom`. Note explicitly whether that `(C := …)` device transfers
    to `δ_natural` (the iter-254 prover claimed it does NOT — there is no instance-injection argument
    slot on `δ_natural`).

## What Mathlib does (the api-alignment angle)

How does Mathlib itself state/prove `δ_natural`-style naturality for a monoidal functor whose
domain category is given by a COMPOSITE-functor presheaf spelling? Does Mathlib ever face the
`X.ringCatSheaf.obj` vs `X.presheaf ⋙ forget₂` duality, and if so what is the canonical way it pins
the spelling (a def-level `abbrev`, a `Functor.comp`-normalising simp lemma, a bundled instance on the
`.obj` spelling)? Is the project's use of `X.ringCatSheaf.obj` where it should use the canonical
`⋙ forget₂` spelling itself a parallel-API misalignment worth fixing at the source?

## Deliverable

A ranked verdict: which of (A)/(B)/(C) is the fix, with the concrete recipe for the chosen one, an
explicit statement of whether D2′ (`pullbackTensorMap_unit_isIso`) is at risk, and — if (A) or (B) —
whether a single PROVER lane can execute it this iter (no separate refactor needed). Write
`analogies/mapin255.md`.
