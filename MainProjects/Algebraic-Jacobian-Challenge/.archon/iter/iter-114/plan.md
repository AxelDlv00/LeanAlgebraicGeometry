# Iter-114 (Archon canonical) plan-agent run

## Headline outcome

**Deeper-think iter: NO prover lane dispatched.** Six subagent dispatches: 3 mandatory critics (strategy-critic, blueprint-reviewer, progress-critic) + 2 blueprint-writers (Differentials.tex; the second is a recipe-fix follow-up after the analogist's must-fix audit) + 1 mathlib-analogist (affine-basis-to-Scheme sheaf bridge). Two independent must-fix signals converged on **DEFER** of the L175 prover lane that was iter-114's prima facie target:

1. **Blueprint-reviewer-iter114 fired the HARD GATE** on `Differentials.tex` (`complete: partial` × `correct: partial`): the new iter-113 unique-gluing sub-helper `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` has NO declaration block in the chapter; three stale `% NOTE (iter-112 review)` blocks actively misdirect; Serre-duality prose mismatches Lean signature.

2. **Progress-critic-iter114 returned STUCK** on the Differentials Phase B helper #1 / unique-gluing route: 0 sorry-eliminations across 4 iters, recurring "no off-the-shelf Mathlib bridge" blocker phrase across 3 of those iters, iter-113 prover's self-classified "reformulation rather than genuine mathematical progress" framing. Primary corrective: dispatch `mathlib-analogist` on the `Scheme.PresheafOfModules`-from-affine-basis predicate BEFORE another prover round.

Project sorry count entering iter-114: 16. Post-iter-114 plan-phase: 16 (deeper-think; blueprint-writer edits are prose-only). Iter-115 plan-phase will green-light the L175 prover lane subject to the next blueprint-reviewer confirming the chapter is clean.

**Mid-iter discovery**: the mathlib-analogist-iter114 audit returned a `must-fix` correction on the iter-113 prover's docstring recipe at `Differentials.lean:148–167`. Specifically, Step 1 "project compatible Ω-families to compatible O_X-families via the universal derivation `d`" is **mathematically not well-defined** (`d` is a multilinear derivation, NOT invertible). The corrected recipe runs through **affine-basis identification via `KaehlerDifferential.isLocalizedModule_map`** + **hand-rolled cofinality descent** against the four-form sheaf-condition equivalents. The basis-to-X bridge is confirmed as `NEEDS_MATHLIB_GAP_FILL` (no off-the-shelf Mathlib lemma; the project's hand-rolled descent in Step 2 is unavoidable). The follow-up writer `blueprint-writer-differentials-recipe-fix-iter114` landed the corrected recipe in the chapter THIS iter; the Lean docstring at `Differentials.lean:148–167` remains stale (to be fixed by the iter-115 prover when they attack the unique-gluing body).

## What I consumed

- `task_results/AlgebraicJacobian_Differentials.lean.md` — iter-113 prover report (PARTIAL Bar B variant; helper #1 closed via Mathlib framework chain; new sub-helper `_isSheafUniqueGluing_type` at L168 with sorry body; prover's own honest assessment: "reformulation rather than genuine mathematical progress"). Archived to `logs/iter-113/prover-iter113-differentials-report.md` and cleared from `task_results/`.
- `task_results/lean-auditor-iter113.md` + `task_results/lean-vs-blueprint-checker-differentials-iter113.md` — iter-113 review-phase subagent reports. Archived to `logs/iter-113/` and cleared. Key residual finding from lean-vs-blueprint-checker-iter113: blueprint route divergence (chapter Route (a) ≠ iter-113 unique-gluing pivot) + Serre-duality hypothesis-strength mismatch.
- `USER_HINTS.md` — empty entering iter-114; left empty.
- `STRATEGY.md` — read for the 7+1 named-gap roster + scope rationale + Phase B framing. **Edited THIS iter** in three places per strategy-critic-iter114 must-fix:
  - Phase B row: L880 effort decomposed into forward + converse with separate budgets; revised estimate to ~5–12 iters / ~250–400 LOC (was ~4–8 / ~200, under-counted on the converse).
  - Scope rationale: added explicit "Narrower L880+L897-only trim" alternative section per strategy-critic-iter114 major omission; reframed reason (ii) on current-correctness merits (was sunk-cost framing on iter-109 effort-erasure).
  - "Path from today" mid-term Phase B section: pinned iter-114 DEFERRAL of the L175 prover lane pending the blueprint-writer + analogist findings; renamed iter-115+ as the re-open point.
- `PROGRESS.md` — read for iter-113 outcome; rewritten for iter-114.
- `task_pending.md` / `task_done.md` — read. `task_pending.md` updated with iter-114 entry status (L175 deferred; line numbers refreshed per iter-113 file state). `task_done.md` unchanged (no closures).
- `archon-protected.yaml` — unchanged. 9 protected declarations.
- Iter-111 / iter-112 / iter-113 (Archon canonical) sidecars from injected context window.

## Independent verification (pre-action)

- `sorry_analyzer.py AlgebraicJacobian/ --format=summary` → 16 total across 6 files (BasicOpenCech 6, Differentials 5, LineBundle 2, Jacobian 1, Modules/Monoidal 1, Picard/Functor 1). Matches iter-113 end-state.
- `lean_diagnostic_messages severity=error` on `Differentials.lean` → `[]`. 5 `declaration uses sorry` warnings (L168 / L679 / L873 / L889 / L1033, declaration-start lines) + 2 cosmetic `IsSmoothOfRelativeDimension` deprecation warnings (L875 / L892, on the now-deprecated typeclass aliases used in the iter-113 refactor) + 1 cosmetic line-length linter warning on L788.
- `grep -rn '^axiom\b' AlgebraicJacobian/` → only matches inside comments. No real axioms.
- `archon-protected.yaml` — unchanged (9 protected declarations).

## Iter-113 outcome assessment

**PARTIAL Bar B variant (as iter-113 plan agent intended, with caveat)** — the structural state change landed: helper #1 closed; new sub-helper `_isSheafUniqueGluing_type` introduced as the load-bearing residual. The reviewer's iter-113 honest framing is correct: this is a *reformulation* with the same mathematical content as the prior helper #1 sorry. From the iter-113 plan agent's success-bar definitions:

- Bar A: NOT met (no closure).
- Bar B (liberal reading: "≥1 new sorry-bodied helper, helper #1 closes, sorry count preserved"): MET.
- Bar C (regression — "TWO new sorry-bodied sub-helpers without closure"): NOT triggered (only ONE new helper added).

So mechanically Bar B held. But the 4-iter signal (progress-critic's K=4 audit) is now CHURNING-trending-STUCK: 2 consecutive Bar B outcomes without any net sorry elimination, identical residual content in two different framings. The progress-critic's verdict-rule trace shows the route trips BOTH STUCK disjuncts (sorry count unchanged + recurring blocker; helpers added + no sorry elimination across K iters) — STUCK > CHURNING under the tiebreaker. **Acted on as STUCK**: deferred the L175 prover lane this iter; dispatched mathlib-analogist to audit the load-bearing Mathlib bridge.

## Mandatory subagent dispatches

Three mandatory per the canonical plan-phase ordering.

### strategy-critic (slug `iter114`)

**Verdict**: 0 REJECT, 2 CHALLENGE, 1 minor sunk-cost reframe — strategy substantially approved, three challenges localised to Phase B mid-term work (none gate this iter).

Routes audited (7):
- Phase A — SOUND
- Phase B — **CHALLENGE** (L880 effort under-counted relative to Hartshorne II.8.15 converse via Nakayama + standard-smooth-chart reconstruction).
- Phase C0 — SOUND
- Phase C1 — SOUND
- Phase C2 — SOUND
- Phase C3 — SOUND
- D / E — SOUND

Alternatives flagged:
- **Decompose L880 into forward + converse with separate budgets** — minor (matches cost structure; lets planner stage dispatch).
- **Plain-language Phase B trim with explicit blueprint-coverage disclosure (narrower variant)** — *major* (strategy considered + rejected aggressive trim, but did not enumerate narrower L880+L897-only deferral as serious alternative).
- Tighten L1039 `serre_duality_genus` Lean signature rather than relax blueprint prose — *minor*.

Sunk-cost flag (minor): scope-rationale reason (ii) "erase the post-C1 monoidal-X.Modules work that establishes the *correct* sheaf-theoretic `LineBundle` as the iter-109 promotion delivered" leans on effort-erasure as merit framing rather than current-correctness merit.

Phantom prerequisites: NONE. All claimed Mathlib infra verified present or correctly named-missing per strategy-critic spot-checks.

**Acted on this iter**: STRATEGY.md edited in three places (Phase B row L880 decomposition; scope-rationale narrower-trim alternative; sunk-cost reframe). No rebuttal in plan.md needed.

### blueprint-reviewer (slug `iter114`)

**Verdict**: **HARD GATE FIRED on `Differentials.tex`** (complete: partial × correct: partial). 13 chapters audited; 12 are complete + correct; `Differentials.tex` flagged as the single must-fix chapter for this iter's prover lane.

Four must-fix items for the blueprint-writer dispatch:
1. Add `\lemma{...}` declaration block + `\lean{...}` hint for the iter-113 NEW sub-helper `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` with the 3-step closure recipe (universal property of `KaehlerDifferential` + structure-sheaf gluing + `span_range_derivation` uniqueness).
2. Rewrite proof of `\thm:relative_kaehler_isSheaf` to delegate via the Mathlib framework chain to the new lemma (replaces Route (a) refinement-cofinality prose).
3. Remove three stale `% NOTE (iter-112 review)` blocks at chapter L183–188, L209–212, L233–240 — the iter-113 refactor landed the signatures these notes flag.
4. Relax `\thm:serre_duality_genus` prose to match the Lean (`IsIntegral` + `IsProper` + `Smooth`; no "geometrically irreducible" assertion; no dimension-1 assertion). Add explanatory remark on the Mathlib gap.

Soon-severity items (non-blocking; queue for opportunistic cleanup):
- `Differentials.tex` L51 stale Lean line-ref ("lines 113–122"); chapter quasi-coherence claim on `\def:relative_kaehler_sheaf`; `\thm:cotangent_exact_sequence` existential-vs-equational formulation mismatch.
- `Cohomology_MayerVietoris.tex` line-ref drift (iter-112 known issue).
- `Picard_FunctorAb.tex` "scaffolded" wording — verified obsolete in current text (the iter-112 known-issue flag may itself be stale).

**Acted on this iter**: dispatched `blueprint-writer-differentials-iter114` with all 4 must-fix items + optional opportunistic cleanup. Re-dispatch of blueprint-reviewer this iter is optional per HARD GATE rule; the iter-115 mandatory dispatch will confirm.

### progress-critic (slug `iter114`)

**Verdict**: **STUCK** on the single audited route (Differentials.lean Phase B helper #1 / unique-gluing). Both STUCK disjuncts independently met:

- Sorry trajectory: file-level 5 → 5 → 5 → 5 across iter-110 to iter-113. Project total 16 → 16 → 16 → 16. Zero sorry-eliminations.
- Recurring blocker phrase: "no off-the-shelf Mathlib lemma packages sheaf-on-affine-basis-of-Scheme ⇒ sheaf for Scheme.PresheafOfModules" appears verbatim in iter-110 blueprint-writer report, iter-112 prover report, and iter-113 blueprint chapter `[gap]` callout. 3 of 4 audited iters.
- Helpers added across 2 of 2 prover-bearing iters without any net sorry elimination.
- Prover status pattern: PARTIAL → PARTIAL (iter-112 + iter-113), second PARTIAL self-flagged as non-substantive.

Primary corrective: **mathlib analogy consult** on `Scheme.PresheafOfModules`-sheaf-from-affine-basis predicate BEFORE iter-114 prover slot.
Secondary corrective: **route pivot** conditional on analogist confirming Mathlib gap is real.

**Acted on this iter**: dispatched `mathlib-analogist-affine-basis-sheaf-bridge-iter114` per the primary corrective. The L175 prover lane is DEFERRED to iter-115. No rebuttal in plan.md; following the corrective.

## Additional subagent dispatches (3)

### blueprint-writer (slug `differentials-iter114`) — initial round

Dispatched per the blueprint-reviewer HARD GATE. Directive contained all 4 must-fix items + optional opportunistic cleanup (stale Lean line-ref at chapter L51; quasi-coherence prose softening). Write-domain: `blueprint/src/chapters/Differentials.tex` only.

**Status: COMPLETE.** Writer landed all 4 must-fix items: (i) added `\lem:relative_kaehler_isSheafUniqueGluing` declaration block with `\lean{...}` hint pointing at the iter-113 sub-helper; (ii) rewrote proof of `\thm:relative_kaehler_isSheaf` as Option (i) delegation through the framework Mathlib chain; (iii) removed the 3 stale `% NOTE (iter-112 review)` blocks; (iv) relaxed `\thm:serre_duality_genus` prose to match the Lean (`IsIntegral` + `Smooth`; no "geometrically irreducible"). Plus opportunistic cleanup (quasi-coherence prose softened on `\def:relative_kaehler_sheaf`; stale Lean line-ref dropped).

The writer **faithfully transcribed the iter-113 prover's 3-step recipe** (Step 1 "project Ω-families via d") into the new lemma's proof body. This was a problem (see analogist verdict below) — addressed by the follow-up writer dispatch.

### mathlib-analogist (slug `affine-basis-sheaf-bridge-iter114`)

Dispatched per the progress-critic STUCK primary corrective. Directive contained 4 specific sub-questions about Mathlib b80f227's API for the `Scheme.PresheafOfModules`-from-affine-basis bridge + alternative routes (SheafOfModules / `Sheaf (Opens X)` / `AlgebraicGeometry.Modules.tilde`). Write-domain: `task_results/**,analogies/**`.

**Status: COMPLETE. Verdict: PROCEED with iter-115+ closure on the existing route, with two corrections.**

Detailed sub-question verdicts:

| Decision | Verdict | Severity |
|---|---|---|
| 1: Off-the-shelf "sheaf-on-basis ⇒ sheaf" theorem for `Scheme.PresheafOfModules` | NEEDS_MATHLIB_GAP_FILL | informational |
| 2: `IsSheafUniqueGluing` as the iter-113 framework reformulation | PROCEED | informational |
| 3: `relativeDifferentialsPresheaf` + IsSheaf-proof vs. `PresheafOfModules.sheafification` | DIVERGE_INTENTIONALLY | major |
| 4: tilde + affine-cover gluing as Route (d) | NEEDS_MATHLIB_GAP_FILL | informational |
| 5: recipe at `Differentials.lean:148–167` (Step 1 "project Ω-families via d") | **ALIGN_WITH_MATHLIB** | **must-fix** |

Analogist's persistent file: `analogies/affine-basis-sheaf-bridge.md` (for future iters' rationale).

**Key consequence**: the iter-113 prover's docstring recipe in the Lean file is mathematically wrong on Step 1 (uses `d` as if invertible). The blueprint-writer's initial round inherited this wrong recipe verbatim from the iter-113 prover's docstring. **Both** the chapter prose (iter-114) **and** the Lean docstring (iter-113, still on disk) need correcting. The chapter is fixed THIS iter via the follow-up writer below; the Lean docstring is the iter-115 prover's responsibility (the docstring is informational only, not load-bearing for compilation).

The basis-to-X bridge gap is independently re-verified by the analogist: no off-the-shelf Mathlib lemma exists (`Functor.IsCoverDense`, `IsDenseSubsite`, 1-hypercover-dense infrastructure all considered and rejected as off-the-shelf bridges). The project's hand-rolled cofinality descent in Step 2 of the corrected recipe is unavoidable.

### blueprint-writer (slug `differentials-recipe-fix-iter114`) — follow-up round

Dispatched mid-iter to correct the inherited iter-113 wrong recipe (analogist Decision 5 must-fix). Directive contained the analogist-verified Mathlib-name recipe (Step 1 affine-basis identification via `KaehlerDifferential.isLocalizedModule_map` + `AlgebraicGeometry.Modules.tilde`; Step 2 hand-rolled cofinality descent against `isSheaf_iff_isSheafOpensLeCover`; Step 3 uniqueness via `eq_of_locally_eq` + `span_range_derivation`). Write-domain: `blueprint/src/chapters/Differentials.tex` only.

**Status: COMPLETE.** Writer replaced the proof body of `\lem:relative_kaehler_isSheafUniqueGluing` with the corrected recipe. Added an explicit `[gap]` callout in Step 2 stating "No off-the-shelf Mathlib lemma packages `Scheme.PresheafOfModules`-sheaf-on-affine-basis ⇒ sheaf on X; the cofinality descent above is hand-rolled this iter, and the iter-115 prover must build it inline (verified by the iter-114 Mathlib analogist)". Other earlier-this-iter writer edits (Option (i) delegation in `\thm:relative_kaehler_isSheaf`; stale NOTE removals; Serre prose; QC softening; statement-line `\leanok` on the new lemma) preserved intact.

## Mathlib name re-verification (iter-114)

Per plan.md "past iters' verification status does NOT carry forward — Mathlib bumps can rename or remove declarations," I re-verified the load-bearing names cited by the new blueprint lemma's 3-step recipe (the recipe the writer will encode) via `lean_loogle` / `lean_leansearch` THIS iter:

- `KaehlerDifferential.span_range_derivation` — **[verified]** (`Mathlib.RingTheory.Kaehler.Basic`; signature `Submodule.span S (Set.range ⇑(KaehlerDifferential.D R S)) = ⊤`).
- `TopCat.Presheaf.IsSheafUniqueGluing` — **[verified]** (`Mathlib.Topology.Sheaves.SheafCondition.UniqueGluing`).
- `TopCat.Presheaf.isSheaf_of_isSheafUniqueGluing_types` — **[verified]** (same module; the iter-113 Lean uses this).
- `TopCat.Presheaf.IsSheaf.isSheafOpensLeCover` — **[verified-inline]** (the iter-113 Lean uses this and the file compiles; `Mathlib.Topology.Sheaves.SheafCondition.OpensLeCover` is the module).
- `TopCat.Presheaf.isSheaf_iff_isSheafOpensLeCover` — **[verified]** (`Mathlib.Topology.Sheaves.SheafCondition.OpensLeCover`).
- `TopCat.Presheaf.Sheaf.eq_of_locally_eq` + `eq_of_locally_eq'` — **[verified]** (`Mathlib.Topology.Sheaves.SheafCondition.UniqueGluing`). Used in the uniqueness step.
- `ModuleCat.Derivation.desc` — **[verified]** (`Mathlib.Algebra.Category.ModuleCat.Differentials.Basic`; signature `{A B : CommRingCat} → {f : A ⟶ B} → {M : ModuleCat ↑B} → M.Derivation f → (CommRingCat.KaehlerDifferential f ⟶ M)`).
- `CommRingCat.KaehlerDifferential.d` — **[verified]** (same module; abbrev form).
- `PresheafOfModules.DifferentialsConstruction.isUniversal'` — **[verified]** (`Mathlib.Algebra.Category.ModuleCat.Differentials.Presheaf`; the universal-property hook for the presheaf-of-modules derivative; useful for descending the section construction on `iSup U`).

No `[gap]` results this iter (the `IsGeometricallyIntegral`-for-schemes gap is carried forward from iter-113 and is now resolved by the blueprint-writer-differentials-iter114 prose relaxation, not by a refactor).

## Current Objectives (iter-114) — none

**iter-114 dispatches NO prover lane.** Per the convergent must-fix signals (blueprint-reviewer HARD GATE on `Differentials.tex`; progress-critic STUCK on the route), the L175 prover lane is deferred to iter-115. This iter delivers:

- 6 subagent dispatches (3 mandatory critics + 2 blueprint-writers + 1 mathlib-analogist).
- 1 STRATEGY.md update absorbing strategy-critic-iter114 must-fix items.
- 1 Differentials.tex chapter update via the two-pass writer round (first pass: 4 must-fix items; second pass: recipe correction per analogist Decision 5).
- 1 persistent analogist summary at `analogies/affine-basis-sheaf-bridge.md` for the load-bearing Mathlib-bridge question.

**Analogist verdict resolved iter-114**: **PROCEED with iter-115+ closure on the existing route** after rewriting the recipe (both chapter and Lean docstring). The basis-to-X bridge remains `NEEDS_MATHLIB_GAP_FILL`; the project's hand-rolled cofinality descent in Step 2 of the corrected recipe is unavoidable. Iter-115 prover lane recipe: affine-basis identification via `KaehlerDifferential.isLocalizedModule_map` + `AlgebraicGeometry.Modules.tilde`; hand-rolled cofinality descent against `isSheaf_iff_isSheafOpensLeCover`; uniqueness via `eq_of_locally_eq` + `span_range_derivation`.

**Anticipated iter-115**:

- Re-dispatch `blueprint-reviewer` as standard plan-phase mandatory; expected verdict on `Differentials.tex`: `complete: true × correct: true` (the iter-114 two-pass writer round addressed all 4 must-fix items + the analogist recipe error).
- Open the L175 prover lane with the corrected recipe. Success bars:
  - **Bar A (preferred)**: close L175's sorry — file sorry count 5 → 4, project total 16 → 15.
  - **Bar B (acceptable)**: at least one of the 3 recipe steps fully closed as a sub-helper; the others exposed with sorry. The prover should **build the hand-rolled cofinality descent inline** (do NOT search for a Mathlib lemma — the analogist confirmed none exists; do NOT introduce a sorry-bodied helper with a universally-false signature in lieu of building the descent — Soundness rule).
  - **Bar C (regression — flips to CHURNING again)**: another reformulation without substantive closure. The iter-115 plan agent must catch this and pivot (the narrower-trim alternative documented in STRATEGY.md scope-rationale becomes the option to consider).
- The iter-115 prover should also be told the iter-113 Lean docstring at `Differentials.lean:148–167` is **mathematically wrong on Step 1** per the iter-114 analogist; their first task is to rewrite the docstring with the corrected recipe (mirror the chapter at `blueprint/src/chapters/Differentials.tex:35–133`) **before** attacking the proof body. The docstring is informational-only (not load-bearing for compilation), but it sends future provers down the wrong path.

## Verification (pre-handoff, iter-114 plan pass)

| Check | Status |
|---|---|
| Sorry count per file | BasicOpenCech 6, LineBundle 2, Modules/Monoidal 1, Picard/Functor 1, Differentials 5, Jacobian 1, others 0 = **16 total**. Verified via `sorry_analyzer.py --format=summary`. |
| File compilation (Differentials.lean) | `lean_diagnostic_messages severity=error` → `[]`. 5 `declaration uses sorry` (expected) + 2 cosmetic `IsSmoothOfRelativeDimension` deprecation warnings + 1 cosmetic line-length warning. |
| `archon-protected.yaml` | unchanged (9 protected declarations). |
| New axioms | none across the project (only doc-comment mentions in `MayerVietorisCover.lean:506–507`). |
| Subagent dispatches | 6 total — 3 mandatory critics + 2 blueprint-writers + 1 mathlib-analogist. All COMPLETE at handoff. |
| Strategy-critic CHALLENGE response | both CHALLENGEs (L880 effort + narrower trim alt) addressed via STRATEGY.md edits this iter. No rebuttal in plan.md needed. |
| Blueprint-reviewer HARD GATE response | acted on: L175 prover lane DEFERRED iter-114; blueprint-writer dispatched THIS iter with all 4 must-fix items. |
| Progress-critic STUCK response | acted on: primary corrective `mathlib-analogist` dispatched THIS iter; L175 prover lane DEFERRED iter-114 pending analogist verdict. No rebuttal in plan.md. |
| Mathlib name re-verification | 9 load-bearing names re-verified `[verified]` this iter. No `[gap]` surfaced (the iter-113 `IsGeometricallyIntegral`-for-schemes gap is now reconciled by the chapter prose relaxation rather than a Lean-side refactor). |
| `USER_HINTS.md` | empty entering iter-114; left empty (no clearing needed). |
| `task_results/` | 6 reports archived to `logs/iter-114/` (3 critics + 2 writers + 1 analogist) + 3 reports archived to `logs/iter-113/` (last-iter prover + auditor + lean-vs-blueprint-checker). All present in `task_results/` for the next phase to read; the prover phase will sync_leanok + dispatch a review-phase whose lean-auditor + lean-vs-blueprint-checker will validate the Differentials chapter is now clean. |
| Build env | mathlib available in `.lake/packages/`. |

## Notes for iter-115 plan agent

- The analogist's verdict file at `analogies/affine-basis-sheaf-bridge.md` is the persistent design-rationale for the iter-115 prover lane recipe. Re-read it iter-115 before composing PROGRESS.md.
- The strategy-critic-iter114 "narrower L880+L897-only trim" option is documented as an OPEN OPTION in STRATEGY.md scope-rationale, conditional on iter-115+ progress-critic returning CHURNING on L880-converse for 2+ iters. The iter-115 plan does NOT trigger this option yet (no L880 lane has been dispatched); only iter-117+ at earliest.
- The blueprint-writer-iter114's chapter update will alter the proof of `\thm:relative_kaehler_isSheaf` (delegating to the new lemma). If the writer adds `\leanok` to the statement of `\lem:relative_kaehler_isSheafUniqueGluing` (it should, per directive Item 1 caveat), the `sync_leanok` phase between iter-114 prover and iter-114 review will reconcile.
