# Lean ↔ Blueprint Check Report

## Slug
tos259

## Iteration
259

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict}` (chapter: `\lem:pullback_tensor_map_basechange`)

- **Lean target exists**: yes (line 2327)
- **Signature matches**: yes — both blueprint and Lean use the general composition form:
  `pullbackTensorMap (h≫f) M N = (pullbackComp h f).inv.app (tensorObj M N) ≫ (pullback h).map (pullbackTensorMap f M N) ≫ pullbackTensorMap h (f^*M) (f^*N) ≫ (tensorObjIsoOfIso (pullbackComp h f).app M (pullbackComp h f).app N).hom`.
  The iter-257 mismatch (base-change-square form vs general-composition form) is resolved: the current blueprint states the lemma in the general composition form with the open-immersion base-change square noted as a "Remark (specialisation)".
- **Proof follows sketch**: **partial / blueprint is materially wrong in Sq2b** — see Red Flags below.
- **notes**: `pullbackTensorMap_restrict` body is `sorry` (line 2399). The `\leanok` marker on the statement block is correct per semantics (sorry present). The top-level lemma structure and the `pullbackComp_δ` sub-lemma (lines 2185–2304) are proved modulo the single sorry in `pushforwardComp_lax_μ` (line 2169).

### `pullbackComp_δ` (no `\lean{}` pin — `private` sub-lemma)

- **Lean target exists**: yes (line 2185), declared `private`
- **Signature matches**: N/A — no `\lean{}` anchor in blueprint; this is the Sq2b monoidality of `pullbackComp` sub-lemma
- **Proof follows sketch**: **partial** — the mate-calculus derivation matches the blueprint's Sq2b description up to the final reduction to `pushforwardComp_lax_μ`; from line 2243 onward all rewrites are concrete (LHS U-step wired with `erw`); the remaining goal is exactly `pushforwardComp_lax_μ` which is sorry (see below).
- **notes**: Being `private`, absence of a `\lean{}` pin is acceptable. The declaration is a faithful Lean implementation of the "monoidality of `pullbackComp`" fact the blueprint describes for Sq2b, complete except for the μ-coherence residual.

### `pushforwardComp_lax_μ` (no `\lean{}` pin — `private` sub-lemma)

- **Lean target exists**: yes (line 2143), declared `private`
- **Signature matches**: N/A — no `\lean{}` anchor
- **Proof follows sketch**: **no — blueprint claims this is definitional, Lean disproves it** — see Red Flags.
- **notes**: This is the genuine `~150-LOC ModuleCat change-of-rings coherence` residual. Body is `ext W x; sorry` (line 2168–2169). The docstring at lines 2134–2142 explicitly documents the refutation of the blueprint's rfl/trivial prediction.

---

## Red Flags

### Must-fix-this-iter: Blueprint Sq2b paragraph falsely predicts the μ-residual is definitional

**Location:** `Picard_TensorObjSubstrate.tex`, lines 4000–4001 (inside `\begin{proof}` of `\lem:pullback_tensor_map_basechange`).

**Exact erroneous text:**
> "...reduces the goal to the lax-μ composition coherence of `PresheafOfModules.pushforward` across `pushforwardComp` --- a concrete, sectionwise identity, **exactly as the unit twin `unitToPushforwardObjUnit_comp` holds definitionally**. The only new bookkeeping relative to the unit twin is the two-argument `tensorHom`/`δ_natural` shuffle, which follows the same template as Mathlib's `CategoryTheory.Adjunction.isMonoidal_comp`."

**What the Lean proves instead:** The docstring of `pushforwardComp_lax_μ` (lines 2127–2169) states:

> "**Status (iter-259): NOT closed.** Unlike the unit-side analog `unitToPushforwardObjUnit_comp` (which is `rfl`), this μ-equality is a genuine `ModuleCat` base-change coherence: unfolding both sides sectionwise (`ext W x`) exposes `ModuleCat.extendRestrictScalarsAdj.homEquiv (δ (ModuleCat.extendScalars …) …)` for the composite ring map versus the two-step composite, i.e. the associativity coherence of `ModuleCat.restrictScalarsComp` / `ModuleCat.extendScalarsComp`. It is `rfl`-false and `simp`-resistant; closing it is a ~150-LOC `ModuleCat` change-of-rings coherence (the 'pushforwardComp is monoidal' theorem). **This is the precise residual that the `d3sq2b258` recipe predicted would be 'rfl/short ext' — that prediction is empirically false.**"

**Classification:** MUST-FIX-THIS-ITER. The blueprint proof sketch for Sq2b makes a false claim that a sorry-carrying residual would close trivially. This directly misleads any prover dispatched to close `pullbackTensorMap_restrict`.

**Required fix:** The Sq2b paragraph in the proof of `\lem:pullback_tensor_map_basechange` must be corrected to:
1. Remove "exactly as the unit twin ... holds definitionally" and replace with a statement that `pushforwardComp_lax_μ` is the genuine remaining residual (NOT rfl or short-ext);
2. State that closing it requires the `ModuleCat.restrictScalarsComp` / `ModuleCat.extendScalarsComp` associativity coherence (~150 LOC);
3. Remove "The only new bookkeeping relative to the unit twin is the two-argument `tensorHom`/`δ_natural` shuffle" (the shuffle is actually wired correctly in `pullbackComp_δ`, but the claim that the μ-coherence is "the same template" as the unit twin is false).

---

## Unreferenced declarations (informational)

These Lean declarations have no `\lean{}` pin in the chapter. Most are helpers or internal; only the notable ones are listed:

- `pushforwardComp_lax_μ` (line 2143, `private`) — the genuine Sq2b μ-residual. Not pinned; since it's `private`, this is formally acceptable. The plan agent should track this as the active sorry for `pullbackTensorMap_restrict`.
- `pullbackComp_δ` (line 2185, `private`) — the Sq2b monoidality sub-lemma, proven modulo the above. Not pinned; `private`, acceptable.
- `toRingCatSheafHom_comp_hom_reconcile` (line 2121, `private`) — the ring-map reconciliation that is definitional (`rfl`). Not pinned; helper.

---

## Blueprint adequacy for this file

- **Coverage:** The public Lean declarations for D3′ are:
  - `pullbackTensorMap_restrict` → pinned by `\lean{...}` in `\lem:pullback_tensor_map_basechange` ✓
  All other D3′ declarations (`pullbackComp_δ`, `pushforwardComp_lax_μ`, `toRingCatSheafHom_comp_hom_reconcile`) are `private` helpers; no pin required.
  Coverage for the public API: 1/1 declarations pinned ✓.
- **Proof-sketch depth:** **under-specified at the critical μ-residual point.** The Sq2b sub-proof correctly describes the mate-calculus reduction route (transpose under `homEquiv.injective`, use `conjugateEquiv_pullbackComp_inv`, identify via `unit_conjugateEquiv` + `comp_unit_app`), but falsely predicts the final reduction step is definitional. The actual gap is a ~150-LOC `ModuleCat` coherence absent from Mathlib.
- **Hint precision:** The `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict}` hint is correct and points to the right declaration with the right signature.
- **Generality:** Matches need — the statement is in the general composition form; the open-immersion base-change square form is correctly identified as a specialisation in the Remark.
- **Recommended chapter-side actions:**
  - **[MUST-FIX]** Correct the Sq2b paragraph: replace the "definitionally / same template" claim with an honest statement that `pushforwardComp_lax_μ` is the genuine `~150-LOC ModuleCat` residual, naming the specific Mathlib lemmas needed (`ModuleCat.restrictScalarsComp`, `ModuleCat.homEquiv_extendScalarsComp`). Optionally add a `% NOTE: pushforwardComp_lax_μ is sorry (iter-259 open residual)` annotation.

---

## Severity summary

| # | Finding | Severity |
|---|---------|----------|
| 1 | Blueprint Sq2b proof paragraph falsely claims `pushforwardComp_lax_μ` is definitional/"exactly as unit twin" — the Lean has a `sorry` at line 2169 with explicit docstring refuting this | **MUST-FIX-THIS-ITER** |
| 2 | `pullbackComp_δ` (the Sq2b sub-lemma, proven modulo the sorry) has no `\lean{}` pin | minor (private, acceptable) |
| 3 | `pushforwardComp_lax_μ` (the genuine residual) has no `\lean{}` pin | minor (private, acceptable) |

**Overall verdict:** The public API statement and signature for `pullbackTensorMap_restrict` are faithful to the blueprint; the must-fix is in the blueprint's *proof sketch*, which falsely predicts the μ-residual closes trivially, directly contradicting the Lean's empirical evidence.

1 declaration checked against its `\lean{}` anchor; 1 red flag (must-fix blueprint proof sketch correction).
