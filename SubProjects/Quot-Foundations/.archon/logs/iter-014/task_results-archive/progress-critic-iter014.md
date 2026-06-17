# Progress Critic Report

## Slug
iter014

## Iteration
014

## Routes audited

---

### Route: GF — `AlgebraicJacobian/Picard/FlatteningStratification.lean`

- **Sorry trajectory**: 5 (iter-009) → 5 (iter-011) → 5 (iter-012). Net: flat across all 3
  prover iters in phase. Current file has 5 active `sorry` lines (verified: lines 516, 1016,
  1101, 1168, 1235).
- **Helper accumulation**: iter-011: +3 axiom-clean Nagata sub-lemmas (`gf_torsion_annihilator`,
  `gf_nagata_monic_lastVar`, `mvPolynomial_quotient_finite_of_monic_lastVar`) — genuine
  mathematical payoff, wired into `gf_torsion_reindex` body. iter-012: in-body helpers at proof
  positions (not top-level decls — this is the root of the heartbeat wall). Helpers added in **2
  of K iters** (iter-011 and iter-012).
- **Recurring blockers**: Lean engineering heartbeat wall from deep inline instance stacking —
  first named in iter-012: "the (a)–(e) bookkeeping residue, assembled INLINE, blows
  `isDefEq`/`whnf` heartbeats even at 1,000,000." The underlying localization-module transport
  plumbing was first flagged in iter-011 ("localization-module transport plumbing / instance
  diamonds"). Now precisely characterized across 2 prover iters.
- **Prover status pattern**: PARTIAL (iter-009), PARTIAL (iter-011), PARTIAL (iter-012) — 3
  consecutive PARTIAL.
- **Throughput**: SLIPPING — strategy `Iters left` = 2–4 at phase entry (iter-009); 3 prover
  iters elapsed. Iter-014 will be prover iter 4, at or just over the estimate ceiling.
- **Verdict**: **CHURNING**

Raw rule fires verbatim (same reasoning as iter-012 critic):
1. Helpers added in iter-011 and iter-012 (2 of K prover iters). ✓
2. Sorry count net unchanged: 5 → 5 → 5, zero decrease across all 3 prover iters. ✓
3. No structural change in approach since iter-009 effort-break: iter-011 and iter-012 both
   executed the effort-break plan (bottom-up Nagata sub-lemma fill → assembly). The approach
   label has not changed. ✓

Mitigation is real: the hard mathematical content (`Module.Finite (P_g/span{F_g}) Tg'`) landed
and compiles in iter-012; the remaining obligation is pure Lean engineering (instance stacking
factoring). But the rule fires regardless, and the sorry count has not moved in 3 prover iters.

- **Primary corrective**: **Dispatch prover immediately on `gf_torsion_reindex` assembly using
  the top-level helper factoring recipe.** The prover's own iter-012 report is the recipe: factor
  each of (a)–(e) into a standalone top-level lemma with its own minimal instance context, then
  assemble. No additional blueprint work, no additional sub-lemma staging — the math is complete.
  This IS what iter-014 proposes; the CHURNING verdict makes it a hard must-close, not best-effort.
  If the assembly sorry is not eliminated in iter-014, the corrective escalates in iter-015 to a
  Mathlib-analogy consult on `IsLocalization.algEquivOfAlgEquiv` + `IsLocalizedModule` descent
  (the (e) transport glue is the one piece still labeled "search for a descent lemma").

---

### Route: FBC — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

- **Sorry trajectory**: ~5 (iter-008) → 3 (iter-011) → 5 (iter-012). Net across K window
  (iter-011 → iter-012): **unchanged** (3 → 5 → net 5). The rise in iter-012 was plan-directed
  (intentional decomposition of 1 opaque sorry into 3 typed seam sorrys + 1 axiom-clean proven
  decl + section_identity own body proven). Current file: 5 active `sorry` lines (verified: lines
  1010, 1091, 1136, 1309, 1331).
- **Helper accumulation**: iter-011: `base_change_mate_regroupEquiv` closed axiom-clean. iter-012:
  `base_change_mate_inner_value` proven axiom-clean + 3 seam decls with typed sorrys created.
  Helpers in **2 of K prover iters** (iter-011, iter-012). 2 genuine axiom-clean closes in the
  K window.
- **Recurring blocker**: "`conjugateIsoEquiv` element action is opaque; element-level `ext` chases
  dead-end; closing needs abstract `Adjunction.conjugateEquiv` naturality." First characterized in
  iter-011 ("adjoint-mate unwinding Mathlib-absent"); recurs explicitly in iter-012 prover report
  ("element-level `ext` chase — `pullback_spec_tilde_iso` is built via `conjugateIsoEquiv`, so its
  action on elements is opaque; an element chase cannot proceed"). **2 consecutive prover iters**
  with this blocker. One more iter without closing = STUCK.
- **Prover status pattern**: PARTIAL (iter-008), PARTIAL (iter-011), PARTIAL (iter-012) — 3
  consecutive PARTIAL across the full prover history.
- **Throughput**: SLIPPING — strategy `Iters left` = 2–4; 3 prover iters elapsed (iter-008,
  iter-011, iter-012).
- **Verdict**: **CHURNING**

Raw rule fires:
1. Helpers added in iter-011 and iter-012 (2 of K prover iters). ✓
2. Sorry count net unchanged across K window (5 at iter-011 start, 5 at iter-012 end; the interim
   3 is inside the window, not the net). ✓
3. Structural change in approach: the iter-012 decomposition into 3 typed seam decls with exact
   signatures IS structural progress (section_identity own body proven; inner_value proven). However,
   the **approach to the remaining crux** (abstract conjugateEquiv route) was identified in iter-011
   and is still the identified route in iter-012 — it has not been executed across 2 prover iters.
   Sub-condition 3 is borderline; the approach label is unchanged even if the scaffolding improved.

The mitigation (2 genuine closes, structured seam decomposition) is real and the sorry-5 after
iter-012 is genuinely better characterized than the sorry-5 before iter-011. But the rule fires
and the conjugateEquiv wall is now 2 prover iters old. Applying the verdict is the failure-
prevention function of this critic, not a rejection of the structural progress.

- **Primary corrective**: **Mathlib analogy consult on `conjugateEquiv`/`conjugateIsoEquiv`
  naturality BEFORE the iter-014 prover dispatch.** The prover explicitly requested this in both
  iter-011 and iter-012 reports. The iter-014 proposal (mathlib-analogist analogies file first,
  then prover on Seam 1 via abstract conjugateEquiv route) is the correct CHURNING-corrective
  response. The plan must commit that the prover does NOT dispatch on the conjugateEquiv seam
  without the analogies file in hand — repeating the element-level ext chase a third time is the
  exact failure mode this corrective exists to prevent.

  Must-close target: Seam 1 (`base_change_mate_unit_value`, the square-free base case). If Seam 1
  closes, Seam 2 and Seam 3 cascade (they are compositional atop Seam 1). If Seam 1 does NOT
  close in iter-014 with the analogy in hand, the conjugateEquiv wall becomes STUCK and the
  corrective escalates to user escalation (no automated corrective remains — the Mathlib API either
  has a `conjugateEquiv_unit`-style lemma or it does not).

---

### Route: QUOT — `AlgebraicJacobian/Picard/QuotScheme.lean`

- **Sorry trajectory**: 4 (iter-011, first prover iter) → 4 (iter-012, prover not dispatched) →
  4 (iter-014 proposed, prover not dispatched again). Net: unchanged at 4. Current file: 4 active
  `sorry` lines (verified: lines 126, 165, 201, 228). All 4 remain downstream-blocked stubs.
- **Helper accumulation**: iter-011: +5 axiom-clean predicate/annihilator decls; iter-012: +8
  axiom-clean power-series-engine decls (the complete power-series half of Stacks 00K1). Genuine
  definition-layer progress; the proof sorries are infrastructure-blocked, not math-blocked.
- **Prover dispatch pattern (consecutive zero-dispatch window)**:
  - iter-012: 0 QUOT prover dispatches (bridge writer round, legitimate gate).
  - iter-013: 0 QUOT prover dispatches (DAG-only iter, no prover phase for any route).
  - iter-014 proposed: 0 QUOT prover dispatches (mathlib-analogist consult, legitimate gate).
  - **3 consecutive iters with zero QUOT prover dispatches.**
- **Throughput**: ON_SCHEDULE — strategy `Iters left` = 2–4; SNAP-S2 first proved in iter-012;
  1 prover iter elapsed.
- **Prior verdict**: UNCLEAR (iter-012 critic).
- **Verdict**: **CHURNING** (meta-pattern)

The plan-phase-only rule fires: ≥3 consecutive iters with zero prover dispatches for this route.
The iter-012 critic warned explicitly: "if iter-013 proposes a third consecutive non-prover iter
for QUOT, the ≥3 consecutive zero-dispatch CHURNING rule will fire again." That warning is now
realized (iter-013 = DAG-only, iter-014 = mathlib-analogist).

Blocking reasons are distinct per iter (bridge writer → DAG infrastructure → graded API gap) and
concrete, NOT the same deferral phrase. The graded-module quotient/kernel/regrading API gap is
a genuine Mathlib infrastructure gap. This is not avoidance in the planner-laziness sense.
Nevertheless, the rule fires on the pattern, and the corrective is warranted.

- **Primary corrective**: **Address deferred infrastructure — the mathlib-analogist consult must
  produce a concrete API alignment file that enables an unconditional QUOT prover dispatch in
  iter-015.** The corrective is NOT "do the consult and see." The iter-014 plan must include an
  explicit commitment: QUOT prover lane in iter-015 regardless of bridge completeness — dispatch
  on whatever sub-lemma of the graded-module API chain is furthest-available. A fourth consecutive
  non-prover iter for QUOT (iter-015) would bring the total to 4; the STUCK rule would fire on
  identical-sorry-count + no prover progress across K iters.

---

### Route: GR — `AlgebraicJacobian/Picard/GrassmannianCells.lean`

File GREEN (0 sorry) as of iter-012; `lem:gr_cocycle` closed. Route file complete. No prover
dispatch in iter-014 is correct. Next GR target (`def:gr_glued_scheme`) requires scheme-gluing
API not yet chosen — out of scope for this file and this critic's assessment.

---

## PROGRESS.md dispatch sanity

- **File count**: 2 prover lanes (FlatteningStratification.lean, FlatBaseChange.lean). Cap: 10.
- **Ready but not dispatched**: QUOT has 4 open sorrys, all downstream-blocked on graded-module
  API; dispatching a prover on blocked stubs is correctly deferred. GR: file complete. No other
  ready file with complete blueprint chapter and open actionable sorrys identified.
- **Over the cap**: no.
- **Under-dispatch finding**: no — both files with actionable prover work are in the proposal.
  QUOT and GR exclusions are valid.
- **Iter-over-iter trend**: [iter-011: 4 dispatched] → [iter-012: 2 provers + 2 writers] →
  [iter-013: 0 provers, DAG-only] → [iter-014 proposed: 2 provers]. The iter-013 zero is a
  structural iteration type, not plan avoidance. Iter-014 resumes at 2 lanes — appropriate.
- **Verdict**: OK — file count 2 within cap 10, no ready-and-actionable files left undispatched.

---

## Must-fix-this-iter

- **Route GF: CHURNING** — primary corrective: dispatch prover immediately on `gf_torsion_reindex`
  with top-level (a)–(e) helper factoring. The prover's own iter-012 recipe is the directive.
  **Hard must-close**: if the assembly sorry at line ~1016 is not eliminated in iter-014, the
  corrective escalates in iter-015 to Mathlib-analogy consult on `IsLocalization.algEquivOfAlgEquiv`
  and `IsLocalizedModule` descent — no further inline assembly attempts.

- **Route FBC: CHURNING** — primary corrective: mathlib-analogist consult on
  `conjugateEquiv`/`conjugateIsoEquiv` naturality is a prerequisite for the prover dispatch;
  prover must then close Seam 1 (`base_change_mate_unit_value`). **Hard must-close for Seam 1.**
  If Seam 1 is not eliminated with the analogy in hand, the conjugateEquiv wall becomes STUCK and
  the corrective escalates to user escalation.

- **Route QUOT: CHURNING (meta-pattern)** — mathlib-analogist consult must yield a concrete API
  alignment file AND the iter-014 plan must commit unconditionally to a QUOT prover lane in
  iter-015. No further deferral language acceptable; four consecutive non-prover iters = STUCK.

---

## Informational

- **2-lane dispatch is the right call.** The planner asks: "is 2 lanes right, or am I walking
  GF/FBC into the same wall with a reworded recipe?" Answer: the lanes are correct; the correctives
  are different types and the recipes are specific. GF's wall is Lean instance-stacking engineering
  (precise remedy: top-level helper factoring, recipe in-code). FBC's wall is Mathlib-absent
  adjunction coherence (precise remedy: mathlib-analogist consult before the prover, not ext chase
  inside the prover). These are distinct walls with distinct correctives. The risk of "reworded
  recipe" is real for FBC if the prover is dispatched WITHOUT the analogist report and falls back
  to ext chase; the gate (analogist first) is the mitigation.

- **GF throughput note**: iter-014 is the 4th prover iter in phase GF-alg (strategy estimate 2–4).
  If GF does not close in iter-014, the route is OVER_BUDGET and the strategy estimate requires
  revision upward. Plan for this contingency now.

- **FBC conjugateEquiv watch**: If iter-014's prover cannot close Seam 1 even with the analogy
  file in hand, the `conjugateEquiv`/`conjugateIsoEquiv` Mathlib gap should be verified empirically
  (grep `conjugateEquiv_unit` or `conjugateEquiv_naturality` in Mathlib — if absent, the route
  needs a user escalation to decide between in-project proof of conjugateEquiv naturality vs. a
  Mathlib contribution vs. a route pivot).

- **QUOT iter-015 commitment**: the iter-015 planner must treat QUOT as a prover lane obligation
  regardless of graded-module API completeness. "Furthest-available sub-lemma" dispatch is always
  available; there is no circumstance in which a fifth non-prover iter for QUOT is acceptable
  without a user-level route decision.

---

## Overall verdict

Three of four active routes are CHURNING: GF for the third consecutive prover iter (sorry flat,
helpers added, top-level factoring wall precisely characterized but not yet executed); FBC for the
first explicit CHURNING call (sorry net unchanged 5→5 across K window, conjugateEquiv wall across
2 prover iters, abstract route identified but not executed); QUOT by meta-pattern (3 consecutive
non-prover iters, concrete blocking reasons, but the pattern cannot be soft-pedaled). GR is
complete. The 2-lane dispatch (GF, FBC) is the correct scope for iter-014, but **both lanes carry
hard must-close obligations, not best-effort targets** — a second PARTIAL on either GF or FBC
triggers STUCK at iter-015. The QUOT CHURNING meta-pattern is mitigated by the mathlib-analogist
consult in iter-014 IFF the iter-014 plan commits to an unconditional iter-015 QUOT prover
dispatch. No avoidance patterns detected at the planning level beyond the QUOT zero-dispatch
window; no under-dispatch of actionable ready files; no cap violation. The must-fix list is three
items: GF hard-close, FBC Seam-1 hard-close, QUOT iter-015 commitment.
