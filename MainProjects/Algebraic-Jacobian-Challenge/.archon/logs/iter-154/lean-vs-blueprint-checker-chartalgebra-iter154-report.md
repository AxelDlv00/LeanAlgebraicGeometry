# Lean ↔ Blueprint Check Report

## Slug
chartalgebra-iter154

## Iteration
154

## Files audited
- Lean: `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
- Blueprint: `blueprint/src/chapters/RigidityKbar.tex` (piece-(ii) chart-algebra block,
  `\label{subsec:RigidityKbar_piece_ii_chart_algebra_decomposition}`)

## Per-declaration

### `\lean{AlgebraicGeometry.GrpObj.algebra_isPushout_of_affine_product}` (chapter: `lem:chart_algebra_isPushout_of_affine_product`)
- **Lean target exists**: yes (ChartAlgebra.lean:102).
- **Signature matches**: yes — `Algebra.IsPushout k B₁ B₂ (TensorProduct k B₁ B₂)`; matches the prose `Algebra.IsPushout k B₁ B₂ B` with `B = B₁ ⊗_k B₂`.
- **Proof follows sketch**: yes — discharged by `inferInstance`; the blueprint proof-block + iter-146/147 NOTEs explicitly document the collapse of the three-step `pullbackSpecIso`/`isPullback_SpecMap_of_isPushout`/`CommRingCat.isPushout_iff_isPushout` chain into one `inferInstance` after re-enabling `Algebra.TensorProduct.rightAlgebra`. Consistent.
- **notes**: blueprint `\leanok` on both statement + proof; unchanged this iter.

### `\lean{AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero}` (chapter: `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`)
- **Lean target exists**: yes (ChartAlgebra.lean:197).
- **Signature matches**: **yes, exact.** Lean: `{k} [Field k] [IsAlgClosed k] [CharZero k] {B} [CommRing B] [IsDomain B] [Algebra k B] [Algebra.FiniteType k B] {n} [Algebra.IsStandardSmoothOfRelativeDimension n k B] {b} (hDb : D k B b = 0) : b ∈ (algebraMap k B).range`. Blueprint prose (L2360) pins precisely the same hypothesis set (`[Field k] [IsAlgClosed k] [CharZero k]`, `[Algebra.FiniteType k B]`, `[Algebra.IsStandardSmoothOfRelativeDimension n k B]`, `[IsDomain B]`) and the same conclusion. The iter-152 counterexample NOTE (CE1 `k×k`, CE2 `ℚ(√2)/ℚ`) correctly justifies the joint `[IsAlgClosed k]`+`[IsDomain B]`.
- **Proof follows sketch**: **yes, step-for-step.** The Lean body is a faithful formalization of the blueprint's live (FT.1)–(FT.3) route:
  - (FT.1) push to `K = FractionRing B` via `map_D`, reduce by `IsFractionRing.injective` (Lean L218–228 ↔ blueprint L2381).
  - (FT.2) `by_contra` transcendental → embed `F = FractionRing (Polynomial k)` via `IsFractionRing.lift`, `IsScalarTower k F K`, `EssFiniteType.comp`/`.of_comp`, `PerfectField.ofCharZero`, `FormallySmooth.of_perfectField`, `H1Cotangent.exact_δ_mapBaseChange` → `mapBaseChange` injective, `mapBaseChange_tmul`+`map_D` identity, `FaithfullyFlat.one_tmul_eq_zero_iff` → `D_F X = 0` (Lean L232–285 ↔ blueprint L2382–2386).
  - (FT.3) base case `_ratfunc_D_X_ne_zero` contradiction + closer `_algebraic_mem_range` (Lean L231,287 ↔ blueprint L2387–2392).
- **notes**: **VERIFIED axiom-clean** via `lean_verify`: axioms = `{propext, Classical.choice, Quot.sound}`, **no `sorryAx`**. The directive's "CLOSED iter-154, axiom-clean" claim is confirmed. The blueprint's live-route prose and the iter-154 "STOP verdict OVERTURNED" NOTE (L2394–2406) accurately describe the actual proof; the demoted (C.a)–(C.c)/(p1)/(p2) records are explicitly fenced as historical and off-critical-path. See Red flags for one stale statement-block `\uses`.

### `\lean{AlgebraicGeometry.GrpObj.df_zero_factors_through_constant_on_chart}` (chapter: `lem:chart_algebra_df_zero_factors_through_constant_on_chart`)
- **Lean target exists**: yes (ChartAlgebra.lean:315).
- **Signature matches**: yes for the thin-delegate disposition — carries `[IsAlgClosed k] [CharZero k]`, chart-of-proper-curve typeclasses on `C`, finite-type standard-smooth `[IsDomain B]`, delegates to KDM with `(n := n) hDb`. The blueprint statement prose describes the full chart-pair lemma; the iter-148/iter-152 NOTEs document that the Lean signature is the reduced one-line delegate (the full five-step recipe is the load-bearing *target*, not the current Lean). Documented disposition, consistent.
- **Proof follows sketch**: N/A for the current Lean (one-line delegate). The five-step blueprint proof remains the target; honestly flagged as such.
- **notes**: **VERIFIED axiom-clean** (`{propext, Classical.choice, Quot.sound}`, no `sorryAx`). This **contradicts** the iter-152 proof-block NOTE (L1934–1943) — see Red flags.

### `\lean{AlgebraicGeometry.constants_integral_over_base_field}` (chapter: `lem:constants_integral_over_base_field`)
- **Lean target exists**: yes (ChartAlgebra.lean:368).
- **Signature matches**: yes — `[Field k] [IsAlgClosed k] {X} [X.Over (Spec (.of k))] [IsProper ...] [Smooth ...] [IsReduced X] [GeometricallyIrreducible ...] : RingHom.range (appTop.hom) = ⊤`. The explicit `[IsReduced X]` is documented in the iter-146 NOTE (Mathlib `b80f227` lacks `Smooth ⇒ IsReduced` over a field). Matches prose + iter-152 alg-closed pivot note.
- **Proof follows sketch**: yes — three-step alg-closed proof (`irreducibleSpace_of_subsingleton` → `isIntegral_of_irreducibleSpace_of_isReduced` → `isField_of_universallyClosed`; `finite_appTop_of_universallyClosed` → integral; `IsAlgClosed.algebraMap_bijective_of_isIntegral` → surjective) maps step-for-step to blueprint L2298–2302.
- **notes**: not modified this iter (closed iter-153); included as a sibling in the same file. Consistent.

### `\lean{AlgebraicGeometry.Scheme.Over.ext_of_diff_zero}` (chapter: `lem:Scheme_Over_ext_of_diff_zero`)
- **Lean target exists**: yes (ChartAlgebra.lean:442).
- **Signature matches**: thin-wrapper disposition — Lean takes `[IsSeparated A.hom] [IsReduced C.left] [GeometricallyIrreducible C.hom]` + `eqOnOpen` data and delegates to `Scheme.Over.ext_of_eqOnOpen`. Blueprint prose states the fuller `df = dg`, genus-0, smooth-proper lemma; the iter-146 NOTE (L2494–2508) documents the dropped hypotheses. Documented divergence, not a hidden mismatch.
- **Proof follows sketch**: N/A (thin renaming); blueprint Steps 1–3 are the deferred target.
- **notes**: the iter-147 NOTE (L2509–2517) is now stale — see Red flags.

### Intermediate (no `\lean{}`): `lem:KaehlerDifferential_constants_in_chart_of_proper_curve` (L2310)
- No Lean declaration (intentional — it is an intermediary helper that, per the iter-154 live route, is **not consumed**). The KDM proof NOTE (L2369–2376) correctly states its `\cref` survives only in the demoted historical records. Acceptable.

## Red flags

### Excuse-comments / stale claims contradicted by the iter-154 closure

- **`RigidityKbar.tex` L1934–1943 (MAJOR)** — iter-152 proof-block NOTE on `lem:chart_algebra_df_zero_factors_through_constant_on_chart` states: *"`df_zero_factors_through_constant_on_chart` transitively depends on the open `sorry` in `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` (verified: its axiom set contains `sorryAx`)"* and *"the warning-based sorry count still undercounts the unsound surface here until KDM closes."* This is now **factually false**: `lean_verify` shows both KDM and this delegate are axiom-clean (`{propext, Classical.choice, Quot.sound}`, no `sorryAx`). Actively misleading — must be updated/removed by the review agent (it owns `% NOTE`).

- **`RigidityKbar.tex` L2509–2517 (MAJOR)** — iter-147 NOTE on `lem:Scheme_Over_ext_of_diff_zero` states *"KDM itself still carries a structured `sorry` at the forward direction (`ker D ⊆ range algebraMap`)"* and gates the lift-lemma refinement on "KDM body closure." KDM is now closed axiom-clean; this NOTE is stale and contradicts the iter-154 closure. Should be refreshed.

### Stale dependency edges (`\uses`)

- **`RigidityKbar.tex` L2340 (MINOR/MAJOR housekeeping)** — the KDM **statement-block** `\uses{lem:chart_algebra_isPushout_of_affine_product, lem:KaehlerDifferential_constants_in_chart_of_proper_curve}` was **not** pruned, even though the **proof-block** `\uses` *was* pruned (the iter-154 NOTE at L2369–2376 explicitly says the live FT route "depends on NO blueprint label" and these `\cref`s "survive only inside the demoted historical records … and create no live dependency edge"). The statement `\uses` therefore advertises two live dependency edges the closed proof does not have. Both labels still resolve (lemmas remain defined), so `blueprint-doctor` will not flag it as broken — but the dependency graph is inaccurate. Recommend pruning L2340's `\uses` to match the proof block (or reducing it to reflect that the live route is a self-contained Mathlib assembly).

## Unreferenced declarations (informational)

- `_ratfunc_D_X_ne_zero` (L118, `private`) — FT.3 base case helper. Not `\lean{}`-referenced (private), but the blueprint KDM proof (L2389) describes its content exactly (localization formally-étale, `isLocalizedModule_map`, `IsLocalizedModule.eq_zero_iff`, `polynomialEquiv_D`/`derivative_X`, `nonZeroDivisors.coe_ne_zero`). Well-documented; acceptable.
- `_algebraic_mem_range` (L145, `private`) — FT.3 closer. Blueprint L2390 describes it exactly (`IntermediateField.adjoin.finiteDimensional`, `Algebra.IsIntegral.of_finite`, `IsAlgClosed.algebraMap_bijective_of_isIntegral`). Well-documented; acceptable.
- The previously-flagged `_mvPoly_*` helpers are **absent** from the Lean file (removed iter-154, as the directive expected). No `\uses` ever pointed at them (they were never blueprint-labeled). Blueprint prose (C.a, L2414) still *names* them, but inside the explicitly-fenced "Historical record … DEAD code" block; it says they "may be removed," whereas they are already removed — minor staleness only, acceptable as historical record.

## Blueprint adequacy for this file

- **Coverage**: 5/5 substantive `\lean{}`-targets in this file map to chapter blocks (`algebra_isPushout_of_affine_product`, `mem_range_algebraMap_of_D_eq_zero`, `df_zero_factors_through_constant_on_chart`, `constants_integral_over_base_field`, `ext_of_diff_zero`). 2 unreferenced declarations, both `private` FT.3 helpers documented in-prose inside the KDM proof block. No substantive unreferenced declarations.
- **Proof-sketch depth**: **adequate** (indeed exemplary for KDM). The (FT.1)–(FT.3) prose names every Mathlib lemma the Lean uses, in order, with file locations; a prover could (and evidently did) formalize directly from it. The `constants_integral_over_base_field` three-step sketch is likewise tight.
- **Hint precision**: **precise**. All `\lean{...}` names resolve to the correct declarations with matching signatures; the KDM hint pins exactly the alg-closed/char-zero/domain hypothesis set the prose specifies.
- **Generality**: **matches need.** The KDM signature retains the (harmless, unused-by-route) standard-smooth/relative-dimension hypotheses for the downstream consumer; the blueprint documents this slack honestly (L2377, "harmless slack for this proof").
- **Recommended chapter-side actions** (for the review agent / blueprint-writing subagent):
  1. Update/remove the stale iter-152 NOTE at L1934–1943 (claims a `sorryAx` that no longer exists).
  2. Refresh the stale iter-147 NOTE at L2509–2517 ("KDM still carries a structured sorry").
  3. Prune the KDM statement-block `\uses` at L2340 to match the already-pruned proof-block `\uses` (live route is a self-contained Mathlib assembly).
  4. (Optional) tighten the (C.a) historical note (L2414) from "may be removed" to "removed iter-154."

## Severity summary

- **must-fix-this-iter**: none. The closed KDM lemma's signature and proof match the blueprint exactly; verified axiom-clean (no `sorryAx`, no unauthorized axioms); no placeholder bodies, no signature mismatch, no excuse-comments on Lean declarations.
- **major**: 2 — stale blueprint NOTEs (L1934–1943, L2509–2517) that assert a KDM open `sorry`/unsound surface the iter-154 closure has eliminated; both are review-agent `% NOTE` corrections, not Lean fixes.
- **minor**: 2 — stale statement-block `\uses` at L2340 (dependency-graph inaccuracy vs. the pruned proof-block); conditional "may be removed" wording for the already-removed `_mvPoly_*` helpers at L2414. Plus the documented (already-known) prose-vs-Lean signature divergence on `ext_of_diff_zero`.

Overall verdict: The iter-154 KDM closure is faithful and axiom-clean and its (FT.1)–(FT.3) blueprint prose matches the Lean step-for-step; the only issues are blueprint-side stale NOTEs/`\uses` that still describe the now-eliminated KDM sorry and should be refreshed by the review agent (no Lean must-fix).
