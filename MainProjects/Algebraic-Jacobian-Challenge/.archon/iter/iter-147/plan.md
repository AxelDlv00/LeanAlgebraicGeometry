# Iter-147 plan-agent run

## Headline outcome

Iter-147 is a **prover lane iter** absorbing iter-146 close into a
single substantive prover dispatch on `Cotangent/ChartAlgebra.lean`.
The plan phase also lands two pre-prover-dispatch corrections per
user-hint absorption:

1. **STRATEGY.md canonical-skeleton restructure** (user-hint
   absorption + iter-147 watch criterion 4): 624 → **166 LOC**, well
   under the 250-line skeleton bound. Sections now match the
   prompt's mandated layout (`## Goal`, `## Phases & estimations`,
   `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new
   material`, `## Soundness rules`). Per-iter narrative excised
   completely; the iter-138/139/140/141/143/144/145 sunk-cost
   guardrail blocks are reduced to the rules that still actively
   constrain the next ~5 iters (no-axioms, sorry-must-be-named-
   declaration, the M2.a `df = 0` derivation chain, the false
   converse caveat, user-hint citation discipline). The iter-138 LOC
   trigger arm + iter-143 PARTIAL breakeven counter + iter-139/140
   analogist-overhead axis rules — all of which only existed to
   guard a route (bundled-route piece (i.b) Step 2) that was
   excised iter-145 — were dropped entirely. They are historical
   context preserved in `iter/iter-138/plan.md` ... `iter/iter-143/plan.md`.

2. **Blueprint-doctor empty-`\uses{}` fixes** (user-hint absorption
   on the iter-146 `leanblueprint web` build failure): the 5 empty
   `\uses{}` annotations in `Cohomology_MayerVietoris.tex` flagged by
   the deterministic blueprint-doctor were removed iter-147 plan
   phase (L136/L141, L186/L191, L634). All five attached to
   foundational definitions (`def:Scheme_ModuleCat_free_isLeftAdjoint`
   + proof; `def:Scheme_ModuleCat_free_preservesMonomorphisms` +
   proof; `def:Abelian_Ext_chgUnivLinearEquiv`) with no upstream
   blueprint dependencies; the empty annotation was the malformed-
   annotation root cause of the plastex failure (`Label '' could not
   be resolved` then leanblueprint depgraph infinite recursion). The
   user-hint claim about "unresolved labels in AbelJacobi.tex +
   AlgebraicJacobian_Cotangent_GrpObj.tex" was a diagnosis attempt;
   the actual root cause is the 5 empty-`\uses{}` items; AbelJacobi
   is `complete: true / correct: true` per iter-146 reviewer
   (verified iter-147), and the GrpObj pointer chapter was already
   absorbed by `blueprint-writer-pointer-iter146` (verified iter-147).
   Re-running `blueprint-doctor` after this iter's edits should show
   `malformed_refs: []`.

## Wave 1 (parallel) — 3 mandatory critics

| Subagent | Slug | Verdict | Absorption |
|---|---|---|---|
| `progress-critic` | iter147 | **HEALTHY** — Route 1 (chart-algebra) UNCLEAR-leaning-positive (1 prover-data-point, monotone-decreasing sorry count, 0 helpers stacked); Route 2 (off-critical-path scaffolds) UNCLEAR-deliberately-dormant (correctly held per strategy); dispatch sanity OK on 1-file / 3-sorry / ~400–750 LOC lane. 0 must-fix items. Watch hook for iter-148: if constants substep 3 returns PARTIAL with the same geom-irr base-change phrase, escalate via blueprint expansion or Mathlib-idiom consult — NOT a second prover lane against the same wall. | Accepted. Iter-147 prover lane proceeds as proposed. |
| `blueprint-reviewer` | iter147 | **ALL CLEAN; HARD GATE CLEARS** — all 11 chapters `complete: true / correct: true`. Both iter-146 must-fix chapters (`RigidityKbar.tex` + `AlgebraicJacobian_Cotangent_GrpObj.tex`) re-confirmed clean post Wave-2 writer rounds + iter-147 plan-agent's `Cohomology_MayerVietoris.tex` empty-`\uses{}` fix verified correct. Multi-route coverage: Route A PASS, Route C PASS, Route B N/A (intentionally historical). 0 must-fix items. 2 informational items (orphan-helper count discrepancy 3 vs 4 between pointer chapter and STRATEGY.md; iter-146 signature reductions well-documented in NOTE blocks with iter-147+ refinement plans). | Accepted. Iter-147 watch criterion #1 GREEN. Plan-agent reconciled the 3-vs-4 orphan count by classifying `isIso_of_app_iso_module` as private internal (matching the pointer chapter's classification — Lean code has it as `private theorem`); STRATEGY.md restructure absorbed this implicitly (orphan-helper enumeration moved out of STRATEGY.md to task_pending.md per strategy-critic recommendation). |
| `strategy-critic` | iter147 | **CHALLENGE on Route C + Route A; major alternative (over-$\bar k$ + descent); format NON-COMPLIANT** — re-restructure of STRATEGY.md needed. (1) Route C: cite specific lemma underwriting "chart-Čech MV on $\Omega^{\oplus n}$" or state it as genuinely new infrastructure. (2) Route A: re-justify on merits over Route B + reconcile 6070-LOC midpoint against named sub-pieces. (3) Major: over-$\bar k$ + descent alternative should be on `## Routes` list, not parked. (4) Format: dissolve extra `## Soundness rules` section, excise ~25 iter-NNN tokens, remove accumulation (closed sub-pieces still listed). One phantom prerequisite UNVERIFIED: `Algebra.IsStandardSmooth.free_kaehlerDifferential`. | **All 4 CHALLENGEs absorbed iter-147 by full STRATEGY.md re-restructure** (post-strategy-critic edit, 178 LOC, 4 iter-NNN tokens all load-bearing references not narrative). (1) Route C MV-on-$\Omega^{\oplus n}$ now framed as "genuinely new instantiation" of the abstract MV theorem + budgeted under `## Mathlib gaps & new material`. (2) Route A merit-based vs Route B paragraph added (S_n-quotient infrastructure not closer; Route B still needs identity-component + Stein factorization composite to recover the Jacobian; Hilbert/Quot has cross-utility). (3) Over-$\bar k$ + descent is now an explicit `## Routes` § "Alternative (still on the table)" with rolling re-evaluation triggers and the iter-150 symmetric audit. (4) `## Soundness rules` dissolved into `## Mathlib gaps & new material` (caveat blocks for the no-axiom rule + sorry-must-be-named-decl rule preserved as "Soundness rules (operational, project-wide)" sub-block under Mathlib gaps; per-iter narrative excised). Phantom prerequisite VERIFIED via `lean_loogle`: `Algebra.IsStandardSmooth.free_kaehlerDifferential : ∀ {R S} [CommRing R] [CommRing S] [Algebra R S] [Algebra.IsStandardSmooth R S], Module.Free S Ω[S⁄R]` at `Mathlib.RingTheory.Smooth.StandardSmoothCotangent`; STRATEGY.md updated to `[verified]`. |

## Wave 2 (post-critics) — conditional

No Wave 2 dispatched yet; will be conditional on blueprint-reviewer
HARD GATE outcome. If HARD GATE fires on a chapter that the iter-147
prover lane depends on, drop the prover lane from `## Current
Objectives` per the descriptor's HARD GATE rule.

## Iter-146 → iter-147 carry-over absorbed

- **Iter-146 prover lane**: `Cotangent/ChartAlgebra.lean` closed 2 of
  3 in-scope sub-pieces sorry-free and partial-closed 1. Net file
  sorry change 5 → 3. (α) `algebra_isPushout_of_affine_product`
  sorry-free via `inferInstance` after re-enabling Mathlib's local
  `Algebra.TensorProduct.rightAlgebra` instance. (lift)
  `Scheme.Over.ext_of_diff_zero` sorry-free via **signature reduction**:
  the planner-spec `df = dg + smooth-proper-genus-0 + group-scheme`
  hypotheses are dropped; body is a one-line delegate to
  `Scheme.Over.ext_of_eqOnOpen` (iter-125 packaging). Iter-147+
  refines the signature to also take `df = dg` and derive `eqOnOpen`
  from it via the β-core sub-piece (once it lands). (β-aux)
  `constants_integral_over_base_field` signature refined to the
  surjectivity form `range ((X ↘ Spec (.of k)).appTop.hom) = ⊤` with
  `[Smooth] [IsProper] [IsReduced] [GeometricallyIrreducible]`
  hypotheses; substeps 1+2 closed; substep 3 (geom-irr base-change
  for `Γ` of proper schemes) deferred to iter-147+ with closure
  path documented inline at L167–176 of `ChartAlgebra.lean`.
- **Iter-146 lean-auditor MAJOR findings absorbed by iter-147 prover
  lane plan**: L97 + L107 `: True := sorry` placeholders MUST be
  refined this iter (they are the iter-147 prover lane β-core + KDM
  ring-side targets — refinement-to-real-signature IS the absorption).
  L208 `ext_of_diff_zero` signature mismatch with blueprint prose
  (Lean drops `df = dg`): documented by iter-146 prover honestly; the
  iter-147+ refinement plan is to add `df = dg` back to the signature
  and derive `eqOnOpen` from it via β-core; deferred iter-147 prover
  lane will only refine if it closes β-core first.
- **Iter-146 lean-vs-blueprint-checker MAJOR finding absorbed**:
  `ext_of_diff_zero` signature mismatch with `lem:Scheme_Over_ext_of_diff_zero`.
  Recommended fix is blueprint-side `% NOTE:` rather than re-adding
  `df = dg` as an unused parameter. **The iter-147 plan-agent does NOT
  write blueprint NOTEs (review-agent territory per role table)**;
  flagging here so the iter-147 review-agent picks it up.

## Iter-146 task_results cleared

The three iter-146 task_results files
(`AlgebraicJacobian_Cotangent_ChartAlgebra.lean.md`,
`lean-auditor-iter146.md`, `lean-vs-blueprint-checker-chart-algebra-iter146.md`)
were absorbed into `task_pending.md` + this sidecar + the prover-lane
plan, and cleared from `task_results/` per plan-agent role
(`prompts/plan.md` step 2). Archived copies remain at
`logs/iter-146/*-report.md` per the CLI auto-archive.

## Critical paths committed (carry-over from iter-144 + iter-145)

Unchanged from iter-146 close:

- Critical path: chart-algebra piece (ii) in `Cotangent/ChartAlgebra.lean`
  (5 sub-pieces; 2 closed iter-146; 1 partial; 2 OFF-LIMITS preserved).
  Iter-147 fires on the 3 remaining sorries.
- M2.a body closure gated on chart-algebra piece (ii) — iter-149+
  (unchanged).
- M2.b body closure + terminal-object cluster + vacuity branch —
  iter-151+ (unchanged).
- M2 closure (genus-stratified body restructure already landed
  iter-135) — iter-155+ (unchanged).
- M3 Route A scaffold scheduling — planner-level call each iter; not
  triggered iter-147 (chart-algebra critical path takes priority).

## Iter-147 prover lane scope (in `PROGRESS.md`)

**Single file, 3 sorries, ~400–750 LOC aggregate** (per user-hint to
scope prover work larger):

1. `Cotangent/ChartAlgebra.lean:97` — refine
   `df_zero_factors_through_constant_on_chart : True := sorry` to its
   real signature per blueprint
   `lem:chart_algebra_df_zero_factors_through_constant_on_chart`;
   close via the 5-step recipe (chart-Kähler kernel extraction +
   2-chart Čech MV on `Ω_{C/k}^{⊕n}` + char-p Frobenius patch).
   ~150–300 LOC.
2. `Cotangent/ChartAlgebra.lean:107` — refine
   `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero : True := sorry`
   to its real signature per blueprint
   `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`;
   close via the iter-146 blueprint-writer's KDM (p1) 4-substep
   recipe + new helper `lem:KaehlerDifferential_constants_in_chart_of_proper_curve`.
   ~200–350 LOC.
3. `Cotangent/ChartAlgebra.lean:177` — complete the geom-irr
   base-change substep 3 inside `constants_integral_over_base_field`
   per iter-146 prover's documented closure path (5-step chain via
   `IsBaseChange` + `Module.finrank_baseChange` +
   `Subalgebra.eq_top_of_finrank_eq` or
   `IntermediateField.bot_eq_top_iff_finrank_eq_one`).
   ~50–100 LOC.

## Watch criteria committed for iter-148

1. Iter-148 mandatory blueprint-reviewer confirms iter-147 prover-
   lane outcome did not introduce new blueprint drift.
2. Iter-148 mandatory progress-critic: Route 1 verdict moves from
   UNCLEAR (iter-146 + iter-147 data) to CONVERGING / CHURNING /
   UNCLEAR per the iter-147 prover-lane outcome. Per iter-147
   progress-critic's escalation hook: if constants substep 3 returns
   PARTIAL with the same geom-irr base-change phrase as iter-146,
   escalate via blueprint expansion or Mathlib-idiom consult — NOT a
   second prover lane against the same wall.
3. Iter-148 mandatory strategy-critic re-verifies iter-147
   STRATEGY.md canonical-skeleton restructure stuck (LOC under 250,
   no per-iter narrative regressed).
4. Iter-148+ orphan-cleanup of 5 helpers in `Cotangent/GrpObj.lean`
   (carry-over from iter-146 watch criterion #6; not blocked, just
   not iter-147 priority).
5. Iter-148+ informal-agent literature cross-check (carry-over from
   user-hint absorbed iter-147 plan phase): DEFERRED iter-148+ until
   OPENAI_API_KEY / GEMINI_API_KEY / OPENROUTER_API_KEY is configured
   in environment. The user-hint is recorded; the loop cannot
   dispatch without the key.
6. Iter-149+ M2.a body closure `rigidity_over_kbar` (gated on chart-
   algebra piece (ii) closure).
7. Iter-151+ M2.b body closure + terminal-object cluster + vacuity
   branch.
8. Iter-155+ M2 closure.
9. Iter-150 over-k symmetric audit (preserved per iter-145 Q6
   reframing).
10. Iter-150 RelativeSpec scaffold trigger preserved per iter-142
    Edit 4.
11. Iter-170+ M3 Route A audit re-refresh.

## Open items for the iter-147 review agent

- `lem:Scheme_Over_ext_of_diff_zero` (in `RigidityKbar.tex`): add a
  `% NOTE:` documenting that the iter-146 Lean closure is a thin
  renaming of `ext_of_eqOnOpen` with the `df = dg` hypothesis and
  chart-algebra (β) chain deferred to iter-147+. Iter-146 lean-vs-
  blueprint-checker recommended this as the cleaner disposition than
  re-adding `df = dg` as an unused parameter to the Lean side.
- `lem:constants_integral_over_base_field`: add a `% NOTE:`
  documenting the explicit `[IsReduced X]` hypothesis discipline
  (Mathlib `b80f227` lacks `Smooth ⇒ IsReduced` over a general
  field; the project carries `[IsReduced X]` explicitly until that
  Mathlib gap closes). Matches the `Rigidity.lean` "Hypothesis
  history" block discipline.
- `lem:chart_algebra_isPushout_of_affine_product`: optional `% NOTE:`
  that Mathlib's `Algebra.IsPushout` instance on `TensorProduct k B₁ B₂`
  collapses the blueprint's 3-step chain into a single
  `inferInstance`, so the explicit chain is informational rather
  than load-bearing.
