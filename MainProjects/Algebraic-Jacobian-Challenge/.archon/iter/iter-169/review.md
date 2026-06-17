# Iter-169 (Archon canonical) — review

## Outcome at a glance
- **The "armed-trigger escalation triggered — three independent routes to `gmScalingP1` body each hit a different Mathlib gap" iter.** iter-168 + iter-169 plans both committed: "if the iter-169 prover lands PARTIAL/INCOMPLETE on `gmScalingP1`, iter-170 plan opens with user escalation via TO_USER.md — NOT another helper-supports round." The iter-169 prover dispatched ONE lane on `Genus0BaseObjects.lean` per the iter-169 plan, attempted **three** distinct routes (the planned Option B + two off-plan alternatives), and each terminated at a Mathlib infrastructure gap. **The trigger is now armed for iter-170.**
- **Substantive iter-169 advances** (not body-closure but informative):
  - SECONDARY-4: `ga_grpObj` instance + the downstream-only `ga_smooth` instance DELETED. `Ga` no longer carries a `GrpObj` instance in the Lean tree. **Blueprint pin `\lean{ga_grpObj}` (AVR.tex L1023) now ORPHANED.**
  - SECONDARY-1/-2/-3: three docstring + section-header refreshes addressing iter-168 lean-auditor must-fix items (#3, #9, header consistency). Two of these (`projectiveLineBar_isReduced`, section-(E) header) explicitly resolve the "stale-Mathlib-gap-claim" KB anti-pattern surfaced iter-168.
  - PRIMARY docstrings: `gmScalingP1` (L685) + `gmScalingP1_collapse_at_zero` (L709) now carry honest iter-169 PARTIAL findings explicitly naming the three attempted routes + their Mathlib-side blockers.
- **Mathlib observations confirmed** (these matter for the iter-170 escalation):
  - `Proj.map` IS in Mathlib (`ProjectiveSpectrum/Functor.lean:144`); cleanest morphism shape for `σ_×` IF the relative-Proj base-change iso were available.
  - `Proj.iso_pullback_Spec` / `ProjPolynomial` / `relativeProj` / relative-Proj base-change iso ARE NOT in Mathlib (verified `Glob`+`Grep` across the whole `Mathlib/AlgebraicGeometry/` tree).
  - `Mathlib/AlgebraicGeometry/GroupAction/*` directory does NOT exist; no precedent for "scheme action by a group scheme."
  - `TensorProduct kbar (HomogeneousLocalization.Away _ _) (GmRing _)` has NO `CommRing` / `Algebra` instance shipped by Mathlib under `inferInstance`. The decisive Option-B blocker.
- **Dispatch MATCHED the plan — 12th consecutive iter** with no plan/dispatch contradiction. The plan specified ONE lane on G0BO.lean attacking `gmScalingP1` body via Option B + SECONDARY hygiene; the prover stayed inside that scope and reported PARTIAL per the plan's "armed-trigger escalation" criterion.
- **Global bare-sorry 14 → 13 (NET −1).** Per-file (verified via Grep this review):
  - `AbelianVarietyRigidity.lean` — **2** at L934 (`iotaGm_isDominant`, unchanged) and L1141 (`genusZero_curve_iso_P1`, unchanged).
  - `Genus0BaseObjects.lean` — **9 → 8** (substitution: `ga_grpObj` L537 DELETED; `gmScalingP1` L685 + `gmScalingP1_collapse_at_zero` L709 unchanged).
  - `Jacobian.lean` — **2** (unchanged).
  - `RigidityKbar.lean` — **1** (unchanged).
  No new `axiom`; no protected signature touched; `lake build AlgebraicJacobian` GREEN (sorry warnings only).

## The advance, independently verified this review
1. **`ga_grpObj` + `ga_smooth` DELETED from `Genus0BaseObjects.lean`.** Verified post-edit via `grep -rn "ga_grpObj\|ga_smooth" AlgebraicJacobian/` returning empty. No other file referenced these. The blueprint pin at AVR.tex L1023 (`\lean{AlgebraicGeometry.ga_grpObj}`) is now ORPHANED and flagged for iter-170 plan-writer cleanup.
2. **Three routes to `gmScalingP1` body explicitly attempted and recorded with concrete Mathlib blockers.** The prover's task_result (read this review) lists per-attempt code descriptions + the specific Mathlib lemma names whose absence terminated each. This is the kind of "fresh evidence that the route is blocked, not the proof" the progress-critic asks for as the cheapest reversal signal on the route. The body's `sorry` is preserved; the docstring records the three attempts honestly.
3. **`projectiveLineBar_isReduced` docstring + section-(E) header brought into honesty with the iter-168 axiom-clean body.** iter-168's review flagged "Stale-'Mathlib gap'-docstring detection" as a KB pattern; iter-169 SECONDARY-2/-3 cured that exact instance.

## What the prover did NOT do (per the plan, and the plan acknowledged the risk)
- No PRIMARY body closures landed.
- The 4 still-deferred "Mathlib gap"-framed scaffold sorries (`projectiveLineBar_geomIrred`, `projectiveLineBar_smoothOfRelDim`, `gm_geomIrred`, `projGm_isReduced`) remain — the prover deferred SECONDARY-5 (optional re-audit) under primary-investigation budget pressure. Honest assessment given but not verified per-scaffold.
- The 5 lean-auditor stale-narrative majors in fallback-route files (iter-168 carryover) were unchanged this iter (plan flagged as off-limits).

## Comparison to recent iter trajectory (no progress-critic dispatched this review, see Subagent skips)
Sorry-count trajectory across the last 5 iters on `Genus0BaseObjects.lean`:

| iter | G0BO sorry | helpers added | substantive closures |
|------|-----------|---------------|----------------------|
| 165  | 4 (scaffold) | scaffold landed | 0 |
| 166  | 6 | +3 (split aux into 5 helper sorries) | 3 (zeroPt/onePt/inftyPt axiom-clean) |
| 167  | 9 | +4 axiom-clean exports + 3 scaffold-sorry exports | 4 axiom-clean exports |
| 168  | 9 | +5 ring-hom helpers + 1 partial iso | 2 axiom-clean (`projectiveLineBarAffineCover`, `projectiveLineBar_isReduced`) + 5 helpers |
| 169  | 8 | 0 helpers; SECONDARY-4 deletion | 0 body closures; 4 docstring/structure hygiene + 1 deletion |

**The headline `gmScalingP1` body has been sorry-bodied for FIVE iters (165-169).** Helpers and infrastructure have piled around it without convergence. Iter-169's explicit verdict: the three routes to that body each terminate at a different missing Mathlib piece; ONE more helper round will not unblock the body.

## Risks and known traps re-confirmed this review
- **Multi-route helper-supports churn pattern.** Per iter-166/167/168/169 progress-critic verdicts, the genus-0 route has been adding helpers without convergence. The iter-170 plan must NOT add another helper-supports round (this is the iter-169 plan's binding commitment). The iter-170 plan must execute one of options (a)/(b)/(c) in `recommendations.md`.
- **Strategy-critic iter-163 char-free stance is now in tension with option (b).** The strategy critic's iter-163 verdict (Route C, char-free via Milne §I) is preserved IF iter-170 picks options (a) or (c); option (b) abandons char-freeness for the genus-0 arm (project ships char-0-only headline + later char-general cleanup). The iter-170 planner should re-run the strategy critic when committing to option (b) (the strategy critic skip-condition "STRATEGY.md unchanged + no live CHALLENGE" will explicitly FAIL when the planner amends STRATEGY.md to weaken to `[CharZero]`).

## Subagent dispatches this review
- **lean-auditor `iter169`** [HIGHLY RECOMMENDED] — DISPATCHED + returned. 18 issues (8 must-fix / 3 major / 3 minor / 4 excuse-comments). **Headline finding**: of the 4 "Mathlib gap"-framed scaffold sorries re-audited, **3 of 4 are genuine** (`projectiveLineBar_geomIrred` L175, `projectiveLineBar_smoothOfRelDim` L182, `gm_geomIrred` L789 — `GeometricallyIrreducible` / `SmoothOfRelativeDimension` APIs lack `of_openCover` / chart-stability lemmas), but **`projGm_isReduced` L819 is BORDERLINE** — closable via the iter-168 `IsReduced.of_openCover` precedent + tensor-of-domains-over-field adaptation (~30-60 LOC). Folded into `recommendations.md` HIGH #3. Other major findings: long iter-status docstrings on `gmScalingP1`/`_collapse_at_zero` encode plan churn into git history (folded into MEDIUM #5a); `gm_grpObj` docstring still references deleted `ga_grpObj` (MEDIUM #5b); `homogeneousLocalizationAwayIso` is publicly exported with `sorry`-bottomed body but has zero consumers — structural decision needed (HIGH #4). Report: `task_results/lean-auditor-iter169.md`.
- **lean-vs-blueprint-checker `g0bo-iter169`** [HIGHLY RECOMMENDED] — DISPATCHED + returned. Verdict: structurally sound Lean↔blueprint pairing, but 8 red flags (3 must-fix sorry-on-substantive-pin, 1 orphaned `\lean{ga_grpObj}`, 1 stale narrative, 1 documented-soft, 2 minor coverage). **Headline finding**: `\lean{AlgebraicGeometry.ga_grpObj}` at AVR.tex L1023 **CONFIRMED ORPHANED** via `lean_verify` ("Axiom check failed: Unknown constant"); `blueprint/lean_decls:134` also lists the orphan entry. Review agent applied `% NOTE (iter-169)` markers to `def:ga_grpObj`, `def:gaTranslationP1`, and `lem:gmScaling_fixes_zero` flagging the orphan + escalation status; the actual block-deletion and lean_decls regen are iter-170 plan-writer scope (informal prose). Report: `task_results/lean-vs-blueprint-checker-g0bo-iter169.md`.

## Subagent skips
- **progress-critic**: NOT a review-phase subagent; the descriptor is mandatory for the plan phase. The iter-170 plan agent will re-dispatch it before deciding the escalation option (per the plan-phase descriptor "do NOT skip on open routes with CHURNING verdicts"). The iter-169 plan's `progress-critic routec169` verdict was CHURNING and is still live until the body lands or the planner commits to a non-helper option.

## Blueprint doctor (iter-169)
- Report at `.archon/logs/iter-169/blueprint-doctor.md` — "No structural findings: every chapter is `\input`'d by `content.tex`, every `\ref{...}` / `\uses{...}` resolves to a defined `\label{...}`, every annotation has a non-empty argument, and no `axiom` declarations are present under the project's `.lean` files." (Note: the doctor runs on the pre-this-iter tree state; the `ga_grpObj` orphan was created BY this iter's prover, so it will appear in the iter-170 doctor run, not iter-169.)

## Final sorry distribution post-iter-169 (verified `grep -nE "^\s*sorry\s*$|:= sorry\s*$"`)
- `AlgebraicJacobian/Genus0BaseObjects.lean` — **8**: L177, L184, L364, L593, L687, L713, L791, L823.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean` — **2**: L934, L1141.
- `AlgebraicJacobian/Jacobian.lean` — **2**: L265, L303.
- `AlgebraicJacobian/RigidityKbar.lean` — **1**: L88.
- **Total: 13.** Net delta iter-168 → iter-169: **−1**.

## TO_USER (this review)
Reset; written for the iter-169 plan's `## Decision made` on the iter-170 escalation pivot. See `.archon/TO_USER.md`.
