# Mathlib Analogist Report

## Mode
api-alignment

## Slug
stub1-coproduct

## Iteration
057

## Question
Identify Stub 1 `cechBackbone_left_sigma`: the degree-`p` Čech-nerve object of the cover arrow
`q = Sigma.desc 𝒰.f : ∐ᵢ Uᵢ → X` (the `(p+1)`-fold fibre power of `q` over `X`) ≅
`∐_{σ:Fin(p+1)→𝒰.I₀} coverInterOpen 𝒰 σ` in `Over X` — i.e. coproducts distribute over the
(iterated) fibre product. Does Mathlib supply A (binary distributivity), B (open-immersion pullback
= intersection), C (the wide/iterated version)? PROCEED/ALIGN/GAP, cheapest decomposition + LOC, and
one-session-vs-multi-iter.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| A — binary coproduct × pullback distributivity for `Scheme` | PROCEED (present in Mathlib) | informational |
| B — pullback of open immersions = intersection (binary) | PROCEED (present in Mathlib) | informational |
| C — iterated / wide fibre power of a coproduct | NEEDS_MATHLIB_GAP_FILL | informational |

## Key correction to the iter-056 prover report
The prover wrote "Mathlib has **no** coproduct-distributes-over-fibre-product for `Scheme`". That is
**false for the binary case**: `Scheme` is `FinitaryExtensive`
(`AlgebraicGeometry.instFinitaryExtensiveScheme`, module `Mathlib.AlgebraicGeometry.Limits`), and the
binary distributivity ships as an `IsIso` instance
`CategoryTheory.FinitaryPreExtensive.isIso_sigmaDesc_map` (`Mathlib/CategoryTheory/Extensive.lean:568`):
`(∐ X) ×_S (∐ Y) ≅ ∐_{(i,j)} (X i ×_S Y j)`, needing only `[HasPullbacks C] [FinitaryPreExtensive C]`
— both hold for `Scheme` (`HasPullbacks Scheme`, `Pullbacks.lean:470`). Open-immersion pullback =
intersection is also present: `AlgebraicGeometry.isPullback_opens_inf` (`Restrict.lean:548`). So A and
B are off-the-shelf. Only the **wide/iterated** step (C) is genuinely missing.

## Verified Mathlib declarations

**A (binary distributivity, `Scheme`):**
- `AlgebraicGeometry.instFinitaryExtensiveScheme : FinitaryExtensive Scheme` — `Mathlib.AlgebraicGeometry.Limits`. VERIFIED.
- `AlgebraicGeometry.instHasFiniteCoproductsScheme : HasFiniteCoproducts Scheme` — same. VERIFIED.
- `instance : HasPullbacks Scheme` — `AlgebraicGeometry/Pullbacks.lean:470`. VERIFIED.
- `CategoryTheory.FinitaryPreExtensive.isIso_sigmaDesc_map` — `CategoryTheory/Extensive.lean:568` (instance). VERIFIED.
- `CategoryTheory.FinitaryPreExtensive.isPullback_sigmaDesc` — `Extensive.lean:590`. VERIFIED.
- `CategoryTheory.FinitaryPreExtensive.isIso_sigmaDesc_fst` — `Extensive.lean:552`. VERIFIED — but its
  hypothesis is `IsIso (Sigma.desc π)` (family already iso to `X`); the general one-sided form
  `(∐X) ×_S Y ≅ ∐(X_i ×_S Y)` is `isIso_sigmaDesc_map` with `ι' := PUnit`.

**B (open-immersion pullback = intersection, binary):**
- `AlgebraicGeometry.isPullback_opens_inf (U V : X.Opens) : IsPullback (X.homOfLE inf_le_left) (X.homOfLE inf_le_right) U.ι V.ι`
  — `AlgebraicGeometry/Restrict.lean:548`. VERIFIED. (⇒ `pullback U.ι V.ι ≅ (U ⊓ V).toScheme`.)
- `AlgebraicGeometry.isPullback_opens_inf_le` — `Restrict.lean:542` (relative). VERIFIED.
- `AlgebraicGeometry.isPullback_morphismRestrict` — `Restrict.lean:530`. VERIFIED.

**C (wide/iterated — direct lemma ABSENT; bricks + combinatorics present):**
- `Arrow.cechNerve` obj `= widePullback f.right (fun _:Fin(n+1)=>f.left) (fun _=>f.hom)`
  — `AlgebraicTopology/CechNerve.lean:56`. VERIFIED (this pins the LHS as a wide pullback).
- `CategoryTheory.Limits.WidePullbackCone.isLimitOfFan` — `Limits/Constructions/WidePullbackOfTerminal.lean:46`:
  wide pullback over a **terminal** base = product of the legs (⇒ in `Over X`, wide-pullback-over-X ↔
  product-in-`Over X` ↔ fibre power). VERIFIED.
- `CategoryTheory.Limits.sigmaSigmaIso` — `Limits/Shapes/Products.lean:621`: `∐ᵢ ∐ⱼ ≅ ∐_{(i,j)}`. VERIFIED.
- `CategoryTheory.Limits.FormalCoproduct.cechIsoCechNerve` / `cechIsoAugmentedCechNerve`
  — `Limits/FormalCoproducts/ExtraDegeneracy.lean:78,86`: coproduct-distributes-over-Čech-nerve, but
  **internal to `FormalCoproduct C`**. NOT portable for free — there is **no** product-preserving
  realization `FormalCoproduct C ⥤ C` in Mathlib (Basic.lean:31 leaves it open; only `incl : C ⥤ FormalCoproduct C`
  exists). Product-preservation of such a realization *is* the extensivity content, so this packages
  only the indexing/simplicial combinatorics, not the geometry. VERIFIED.

## Informational

**Scope / cost (Decision D).** Stub 1 is **multi-iter, ≈250–350 LOC**, decomposing into four blueprint
sub-lemmas (cheapest aligned route):

1. `backbone_obj_widePullback` (≈30 LOC) — unfold `coverCechNerveOver`/`augmentedCechNerve`/`cechNerve`
   to expose the underlying scheme as `widePullback X (fun _:Fin(p+1)=>∐U) (fun _=>q)`, structure map `WidePullback.base`.
2. `coproduct_distrib_fibrePower` (≈120–200 LOC) — **the gap (C)**. Induction on `p`, each step using
   `isIso_sigmaDesc_map` (singleton second family ⇒ one-sided `(∐U) ×_X W ≅ ∐ᵢ (Uᵢ ×_X W)`) +
   `sigmaSigmaIso` to reindex to `σ : Fin(p+1)→ι`; use `WidePullbackCone.isLimitOfFan` to recast the
   wide pullback over `X` as a product in `Over X` (terminal base) where the iterated product recurses
   cleanly. **Best stated abstractly for `FinitaryPreExtensive C`** (Mathlib-aligned, reusable), then
   instantiated at `Scheme` — this also avoids a parallel scheme-only API. This is the load-bearing
   lane (a 2–3-cycle prover build on its own).
3. `widePullback_openImm_inter` (≈50–80 LOC) — `widePullback X (fun k=>U_{σk}) (fun k=>j_{σk}) ≅ (coverInterOpen 𝒰 σ).toScheme`
   over `X`, by iterating `isPullback_opens_inf` (B) along `Fin(p+1)`; `⨅ₖ` = `coverInterOpen` def.
4. `cechBackbone_left_sigma` (≈40 LOC) — assemble 1–3 in `Over X`; structure-map agreement is automatic.

**Recommendation to the dispatcher.** Effort-break Stub 1 into the blueprint (the four sub-lemmas
above) **before** dispatching a prover. Then dispatch a prover on sub-lemma 2 first (the abstract wide
distributivity); 1, 3, 4 become mechanical once 2 lands. Do NOT attempt Stub 1 as a single one-session
prover task. Note Stub 2 (`pushPull_sigma_iso`) and Stub 4 depend on Stub 1, so this unblocks the whole
Sub-brick A geometric chain.

## Persistent file
- `analogies/stub1-scheme-coproduct.md` — design-rationale + verified decl list captured for future iters.

Overall verdict: GAP is narrow — A and B are off-the-shelf (`Scheme` is `FinitaryExtensive`,
`isIso_sigmaDesc_map` + `isPullback_opens_inf`); only the wide/iterated distributivity (C) is a genuine
build, best done as an abstract `FinitaryPreExtensive` lemma by iterating A, multi-iter ≈250–350 LOC,
so effort-break into the blueprint before dispatching a prover.
