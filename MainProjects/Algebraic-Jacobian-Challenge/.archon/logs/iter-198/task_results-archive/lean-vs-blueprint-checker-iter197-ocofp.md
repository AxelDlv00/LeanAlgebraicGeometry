# Lean ↔ Blueprint Check Report

## Slug
iter197-ocofp

## Iteration
197

## Files audited
- Lean: `AlgebraicJacobian/RiemannRoch/OCofP.lean`
- Blueprint: `blueprint/src/chapters/RiemannRoch_OCofP.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.carrierPresheaf}` (chapter: `def:lineBundleAtClosedPoint_carrierPresheaf`)
- **Lean target exists**: yes (L488, `private noncomputable def`)
- **Signature matches**: yes — `(Opens C.left)ᵒᵖ ⥤ ModuleCat.{u} kbar`, object `carrierSubmoduleSheaf P hPcoh U`, maps via `Submodule.inclusion` or zero depending on bot-check; matches blueprint prose.
- **Proof follows sketch**: yes / N/A — definition body matches the case-based restriction described; functor laws closed axiom-clean.
- **notes**: `\leanok` on statement block correct; no sorry in body.

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.carrierPresheaf_isSheaf}` (chapter: `lem:lineBundleAtClosedPoint_carrierPresheaf_isSheaf`)
- **Lean target exists**: yes (L577, `private lemma`)
- **Signature matches**: yes — `Presheaf.IsSheaf (Opens.grothendieckTopology C.left.toTopCat) (carrierPresheaf P hPcoh)`.
- **Proof follows sketch**: yes — Case A (empty cover) and Case B (nonempty cover) as described; full close via `isSheaf_iff_isSheafUniqueGluing`, irreducibility, and the `carrierTypeSubfunctor` Subfunctor trick.
- **notes**: `\leanok` on statement block correct; no sorry in body. **Stale strategy comment** at L663–678 of Lean says "single typed sorry below" — the sorry was closed in a prior iteration and the comment is now misleading. See Red Flags §1.

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.carrierSubmoduleSheaf}` (chapter: `def:lineBundleAtClosedPoint_carrierSubmoduleSheaf`)
- **Lean target exists**: yes (L388, `private noncomputable def`)
- **Signature matches**: yes — `carrierSubmodule P hPcoh U ⊓ trivAtBot U`, forces `F(⊥) = 0` as described.
- **Proof follows sketch**: N/A (definition, no proof sketch in chapter).
- **notes**: `\leanok` correct; axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint}` (chapter: `def:lineBundleAtClosedPoint`)
- **Lean target exists**: yes (L806, `noncomputable def`)
- **Signature matches**: yes — returns `Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} kbar)` built from `⟨carrierPresheaf P hPcoh, carrierPresheaf_isSheaf P hPcoh⟩`.
- **Proof follows sketch**: N/A (definition body).
- **notes**: `\leanok` correct; no sorry.

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.toFunctionField}` (chapter: `def:lineBundleAtClosedPoint_toFunctionField`)
- **Lean target exists**: yes (L848, `noncomputable def`)
- **Signature matches**: yes — takes `s : Scheme.HModule kbar (lineBundleAtClosedPoint P hP hPcoh) 0`, returns `C.left.functionField`; the five-layer chain (`HModule_zero_linearEquiv → sheafToPresheaf.map → constantSheafAdj.unit → .hom → .1`) matches blueprint prose exactly.
- **Proof follows sketch**: N/A (definition body, substantive).
- **notes**: `\leanok` correct; no sorry.

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.globalSections_iff}` (chapter: `lem:lineBundleAtClosedPoint_globalSections_iff`)
- **Lean target exists**: yes (L1095, `lemma`)
- **Signature matches**: yes — biconditional between order conditions `(∀ Q ≠ P, 0 ≤ ord_Q f) ∧ -1 ≤ ord_P f` and the existential `∃ s, toFunctionField s = f`; matches blueprint Riemann–Roch space description.
- **Proof follows sketch**: yes — one-liner combinator `⟨globalSections_iff_mp, globalSections_iff_mpr⟩`; the blueprint proof body is the mathematical content that `_mp` and `_mpr` carry.
- **notes**: `\leanok` on statement block correct; no sorry in body (both directional helpers are sorry-free). Blueprint proof block lacks `\leanok` — see Blueprint Adequacy §4.

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.h1_vanishing_genusZero}` (chapter: `lem:H1_vanishing_lineBundleAtClosedPoint_genusZero`)
- **Lean target exists**: yes (L1147, `lemma`)
- **Signature matches**: yes — `Module.finrank kbar (HModule kbar (lineBundleAtClosedPoint P hP hPcoh) 1) = 0` under the genus-0 hypothesis.
- **Proof follows sketch**: N/A — proof body is `sorry`; blueprint proof block correctly lacks `\leanok`.
- **notes**: `\leanok` on statement block only; sorry body expected per the standing H¹-vanishing gate.

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.dim_eq_two_of_genusZero}` (chapter: `thm:lineBundleAtClosedPoint_dim_eq_two_of_genusZero`)
- **Lean target exists**: yes (L1247, `theorem`)
- **Signature matches**: yes — `Module.finrank kbar (HModule kbar (lineBundleAtClosedPoint P hP hPcoh) 0) = 2` on genus-0 curve.
- **Proof follows sketch**: yes — invokes `h1_vanishing_genusZero` (step 1) and `h0_sub_h1_lineBundleAtClosedPoint_eq_two` (step 2; χ-identity), then arithmetic; matches blueprint's "Specialise χ-identity at D=[P]" route.
- **notes**: `\leanok` on statement block correct; no direct sorry in body, but transitively dependent on two sorried substrate helpers.

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.exists_nonconstant_genusZero}` (chapter: `cor:lineBundleAtClosedPoint_exists_nonconstant_genusZero`)
- **Lean target exists**: yes (L1797, `theorem`)
- **Signature matches**: yes — returns `∃ (f : K(C)) (hf : f ≠ 0), (∀ Q ≠ P, 0 ≤ ord_Q f) ∧ -1 ≤ ord_P f ∧ WeilDivisor.principal f hf ≠ 0`; aligns with blueprint three-bullet statement.
- **Proof follows sketch**: yes — one-liner delegation to `exists_nonconstant_rational_from_dim_eq_two` supplied with `dim_eq_two_of_genusZero`.
- **notes**: `\leanok` on statement block correct; transitively depends on one typed sorry in `functionField_const_of_complete_curve_of_orderZero`.

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.toFunctionField_injective}` (chapter: `lem:lineBundleAtClosedPoint_toFunctionField_injective`)
- **Lean target exists**: yes (L1287, `private lemma`)
- **Signature matches**: yes — `Function.Injective (toFunctionField P hP hPcoh)`.
- **Proof follows sketch**: yes — unfolds via `Subtype.ext`, `adj.homEquiv_unit`, `LinearMap.ext_ring`, `adj.homEquiv.injective`, and `HModule_zero_linearEquiv.injective`; the five-layer chain described in the blueprint proof.
- **notes**: Sorry-free. Blueprint statement block has `\leanok`; proof block lacks `\leanok`. This is likely a `sync_leanok` gap on private declarations — see Blueprint Adequacy §4.

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.globalSections_iff_mpr}` (chapter: `lem:lineBundleAtClosedPoint_globalSections_iff_mpr`)
- **Lean target exists**: yes (L1024, `private lemma`)
- **Signature matches**: yes — given `∃ s, toFunctionField s = f`, produces the order-condition pair.
- **Proof follows sketch**: yes — unfolds via `carrierSubmoduleSheaf` membership projection; blueprint proof matches.
- **notes**: Sorry-free. Blueprint statement block has `\leanok`; proof block lacks `\leanok`. Same `sync_leanok` gap as above. See Blueprint Adequacy §4.

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.functionField_const_of_complete_curve_of_orderZero}` (chapter: `lem:lineBundleAtClosedPoint_functionField_const_of_complete_curve_of_orderZero`)
- **Lean target exists**: yes (L1492, `private lemma`)
- **Signature matches**: yes — `f ≠ 0 → (∀ Q, ord_Q f = 0) → ∃ c : kbar, f = algebraMap kbar K(C) c`.
- **Proof follows sketch**: partial — the blueprint's Step (i)/(ii) framing is preserved; the iter-197 advance (`stalkLift` extraction via `functionField_localUnit_of_orderZero_at_primeDivisor`) is in the Lean body comments but NOT reflected in the blueprint proof text. Single typed sorry on "global Hartogs gluing + Γ=k̄ step" as documented.
- **notes**: `\leanok` on statement block correct; proof block correctly lacks `\leanok` (sorry present). The `stalkLift` progress (iter-197 advance) is documented in the Lean body comments but not in the blueprint proof. Minor framing gap — see Blueprint Adequacy §3.

---

## Red flags

### Stale excuse-comment (minor)

- `OCofP.lean:663–678`: Inside the `Case B` branch of `carrierPresheaf_isSheaf`, the block comment reads "Strategy for the iter-190+ prover close (single typed sorry below):" — but **there is no sorry below**. The sorry was closed in a prior iteration (iter-189/190) and the roadmap comment was not removed. It is not an excuse-comment for wrong code (the proof is correct), but a reader will look for a sorry that does not exist. This should be cleaned up to avoid confusion.

### Potentially missing `\leanok` markers on proof blocks

- Blueprint `lem:lineBundleAtClosedPoint_toFunctionField_injective` proof block: `toFunctionField_injective` (L1287–1354) is sorry-free, but the proof block in the blueprint lacks `\leanok`. Likely a `sync_leanok` gap on private declarations.
- Blueprint `lem:lineBundleAtClosedPoint_globalSections_iff_mpr` proof block: `globalSections_iff_mpr` (L1024–1056) is sorry-free, but the proof block in the blueprint lacks `\leanok`. Same issue.
- These are tooling-side omissions (no agent writes proof-block `\leanok`), not content errors. Noted for the plan agent to verify that `sync_leanok` correctly handles private declarations.

---

## Unreferenced declarations (informational)

Private sub-helpers without blueprint pins — all are private implementation scaffolding for pinned parent declarations; none have names that suggest they should be directly in the blueprint:

| Declaration | Line | Status |
|---|---|---|
| `carrierSet` | 153 | private, helper for `carrierSubmodule` |
| `carrierSet_mono` | 181 | private, antitone monotonicity lemma |
| `instNonemptyTopOpen` | 199 | instance, helper |
| `instAlgebraKbarFunctionField` | 213 | instance, helper |
| `carrierSubmodule` | 238 | private, upgraded from `carrierSet` |
| `trivAtBot` | 364 | private, bot-trivialization helper |
| `carrierSubmoduleSheaf_le` | 405 | private, monotonicity for `carrierSubmoduleSheaf` |
| `carrierTypeSubfunctor` | 439 | private, Subfunctor packaging |
| `globalSections_iff_mp` | 923 | private, forward direction helper |
| `h0_sub_h1_lineBundleAtClosedPoint_eq_two` | 1209 | private, χ-arithmetic substrate |
| `exists_nonconstant_rational_from_dim_eq_two` | 1597 | private, main content helper |
| **`localLift_of_log_ordFrac_eq_zero`** | **1390** | **private, iter-197 NEW; no blueprint pin** |
| **`algebraMap_bijective_of_finite_isDomain_isAlgClosed`** | **1427** | **private, iter-197 NEW; no blueprint pin** |
| **`functionField_localUnit_of_orderZero_at_primeDivisor`** | **1445** | **private, iter-197 NEW; no blueprint pin** |

### Iter-197 new helpers — name match verification

The directive asks whether the iter-196 blueprint-writer `ocofp-leanrecipes` pins for sub-claims (a)/(b)/(c) match the iter-197 prover's actual declaration names. **They do:**

| Blueprint pin | Lean declaration | Match |
|---|---|---|
| `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.toFunctionField_injective` | `private lemma toFunctionField_injective` (L1287) | ✅ |
| `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.globalSections_iff_mpr` | `private lemma globalSections_iff_mpr` (L1024) | ✅ |
| `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.functionField_const_of_complete_curve_of_orderZero` | `private lemma functionField_const_of_complete_curve_of_orderZero` (L1492) | ✅ |

The three NEW iter-197 helpers (`localLift_of_log_ordFrac_eq_zero`, `algebraMap_bijective_of_finite_isDomain_isAlgClosed`, `functionField_localUnit_of_orderZero_at_primeDivisor`) are private sub-sub-helpers of `functionField_const_of_complete_curve_of_orderZero` — they are not the "sub-claims (a)/(b)/(c)" of the corollary and do not need blueprint pins. Their mathematical roles correspond to the documented "Step (i) per-stalk lift" in the blueprint proof.

### Iter-196 broken-label cleanup — confirmed resolved

The directive flagged broken labels `order_conditions_of_globalSection` and `principal_ne_zero_of_nonconstant` from iter-196. **These labels do not appear anywhere in the current blueprint chapter.** The iter-197 `blueprint-writer ocofp-pin-cleanup-iter197` dispatch successfully removed/re-anchored them. The current chapter uses:
- `lem:lineBundleAtClosedPoint_globalSections_iff_mpr` (formerly `order_conditions_of_globalSection`)
- `lem:lineBundleAtClosedPoint_functionField_const_of_complete_curve_of_orderZero` with the iter-197 NOTE block (formerly `principal_ne_zero_of_nonconstant`)

No stale `\uses{...order_conditions_of_globalSection...}` or `\uses{...principal_ne_zero_of_nonconstant...}` references survive. ✅

---

## Blueprint adequacy for this file

### Coverage
12/12 pinned `\lean{...}` declarations exist in the Lean file with matching names. Unreferenced declarations: 13 helpers (all private, all acceptable) + 0 substantive unpinned. The three new iter-197 private helpers are sub-helpers of a pinned parent and are correctly not separately pinned.

### Proof-sketch depth
**Adequate** for the 10 sorry-free declarations. For the two sorry-bearing declarations (`h1_vanishing_genusZero`, `h0_sub_h1_lineBundleAtClosedPoint_eq_two`), the blueprint correctly documents them as substrate gaps gated on upstream work. For `functionField_const_of_complete_curve_of_orderZero`, the blueprint proof gives the two-step Stacks 0BCK + Hartshorne I.3.4 framing.

**Minor adequacy gap (§3):** The blueprint proof of `lem:lineBundleAtClosedPoint_functionField_const_of_complete_curve_of_orderZero` describes Step (i) ("algebraic Hartogs") and Step (ii) ("Γ=k̄") at the mathematical prose level, but does not reflect the iter-197 advance: the per-stalk unit lift `stalkLift` (produced by the new `functionField_localUnit_of_orderZero_at_primeDivisor`) is now axiom-clean and in-scope. The Lean body comments (L1499–1548) document the tentative Lean names for the two remaining gaps (`Scheme.functionField_extend_global` / `Scheme.globalSections_eq_field_of_isProper_of_isGeometricallyIrreducible`). The blueprint proof says only "both ingredients are project-bespoke Mathlib gaps: the Lean substrate helper carries a single typed sorry" — which is still accurate, but does not capture the partial progress. The framing is **reasonable** but could more precisely reflect the current state.

### Hint precision
**Precise.** Every `\lean{...}` pin names the correct fully-qualified declaration. No loose hints (prose references to a predicate the `\lean{...}` doesn't pin).

### Generality
**Matches need.** All declarations are at the correct level of generality for the project's consumption chain. No parallel API discovered that indicates a blueprint-generality mismatch.

### `\leanok` marker consistency
The `sync_leanok` rules (CLAUDE.md: statement-block `\leanok` = "at least a sorry present"; proof-block `\leanok` = "proof closed, no sorry") are respected for all blocks — **except** the proof blocks of `toFunctionField_injective` and `globalSections_iff_mpr`, both of which are sorry-free in Lean but whose proof blocks lack `\leanok` in the blueprint. This is likely a `sync_leanok` limitation with `private` declarations (the sorry_analyzer may not find private names). No agent-side error; tooling-side issue.

### Recommended chapter-side actions
1. **Minor cleanup** (not blocking): Add a brief note to the `lem:lineBundleAtClosedPoint_carrierPresheaf_isSheaf` proof block (or remove the stale comment from the Lean body L663–678) acknowledging that Case B is now closed. The current blueprint proof block (`\uses{...}` + prose) correctly has `\leanok` on the statement but the Lean body has the misleading "single typed sorry below" roadmap comment.
2. **Minor enhancement**: In the `lem:lineBundleAtClosedPoint_functionField_const_of_complete_curve_of_orderZero` proof, add a sentence reflecting the iter-197 advance: "The per-stalk unit lift (`functionField_localUnit_of_orderZero_at_primeDivisor`) is now axiom-clean; the single remaining sorry covers the global Hartogs gluing (`Scheme.functionField_extend_global`) and the global-sections-equal-k̄ step (`Scheme.globalSections_eq_field_of_isProper_of_isGeometricallyIrreducible`)."
3. **Tooling follow-up** (not a blueprint-content action): Verify that `sync_leanok` correctly handles `private` declarations when updating proof-block `\leanok` markers for `toFunctionField_injective` and `globalSections_iff_mpr`.

---

## Severity summary

### must-fix-this-iter
*None.*

### major
1. **Missing proof-block `\leanok` markers** for `toFunctionField_injective` and `globalSections_iff_mpr` — both are sorry-free in Lean but their blueprint proof blocks lack `\leanok`. Most likely a `sync_leanok` tooling gap on private declarations, not a blueprint content error. The plan agent should verify `sync_leanok` behavior and/or manually add `\leanok` to these proof blocks at next review.

### minor
1. **Stale strategy comment** in `carrierPresheaf_isSheaf` Lean body at L663–678: "Strategy for the iter-190+ prover close (single typed sorry below)" — the sorry has been closed; the comment should be removed to avoid confusing future readers.
2. **Blueprint proof framing for `functionField_const_of_complete_curve_of_orderZero`** does not reflect the iter-197 per-stalk-lift advance. The prose says "a single typed sorry pending upstream development" (still accurate) but does not document the tentative Lean names for the two remaining gap lemmas (which the Lean body comments do document). Low impact.
3. **Three iter-197 private helpers** (`localLift_of_log_ordFrac_eq_zero`, `algebraMap_bijective_of_finite_isDomain_isAlgClosed`, `functionField_localUnit_of_orderZero_at_primeDivisor`) have no blueprint pins. Expected for private sub-helpers of a pinned parent — informational only.

**Overall verdict:** The OCofP file pair is in a well-maintained state. All 12 blueprint `\lean{...}` pins are correctly anchored and match existing Lean declarations; the iter-196 broken-label cleanup landed correctly; the three iter-197 helpers are correctly named and support the pinned parent `functionField_const_of_complete_curve_of_orderZero`. No must-fix-this-iter findings.
