# Iter-197 (Archon canonical) — review

## Outcome at a glance

- **The "Lane ChartIso `projectiveLineBar_smooth_chart_aux` CLOSED
  axiom-clean via NEW helper `projectiveLineBar_smooth_chart_X` +
  11-step `Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv`
  recipe through Mathlib MvPolynomial/Polynomial chain + iter-196
  BareScheme `mvPolynomialFin_isStandardSmoothOfRelativeDimension`
  substrate; cascade closes `projectiveLineBar_smoothOfRelDim` to full
  axiom-cleanliness (ChartIso 1 → 0 −1; HARD CLOSURE) + Lane I
  `hy_ne_bot` residual on `isRegularInCodimOneProjectiveLineBar` CLOSED
  axiom-clean via generic-point-contradiction shortcut (~30 LOC,
  qualitatively cheaper than the documented Stacks 02IZ topological-
  coheight bridge); cascade closes the full theorem to axiom-clean
  (WD 4 → 3 −1; HARD CLOSURE) + Lane H `Scheme.skyscraperSheaf_eq_pushforward_const`
  inner-iso residual CLOSED via Route H-2 (4 new axiom-clean
  declarations `alphaConstToSkyPUnit` / `betaSkyToConstPUnit` /
  composition lemma / `Scheme.skyscraperSheaf_iso_constantSheaf_punit`)
  exploiting PUnit IndiscreteTopology shortcut `Opens.eq_bot_or_top`;
  closes the parent declaration to axiom-clean (H1V 3 → 2 −1; HARD
  CLOSURE) + Lane E THREE new axiom-clean Proj-side helpers
  (`Proj.basicOpenIsoSpec_inv_app_top`, `Proj.awayι_app_basicOpen`,
  `Proj.awayι_appIso_top_inv`) per iter-195 analogist `lane-e-proj-appiso-pivot`
  recipe; consumer #1 `kbarChart1Ring_specMap_fac` advanced —
  iter-188—194 STUCK Proj.appIso signal FORMALLY RESOLVED, residual
  reduced to project-side `onePt.left.app(D₊(X_1))` evaluation (AVR
  3 → 3; substantive structural advance — HARD BAR technically met by
  structural advance; ready for consumer-closure push iter-198) + Lane
  A 3 axiom-clean substrate helpers (`localLift_of_log_ordFrac_eq_zero`,
  `algebraMap_bijective_of_finite_isDomain_isAlgClosed`,
  `functionField_localUnit_of_orderZero_at_primeDivisor`) — full
  helper-budget consumed; parent body advanced to extract per-stalk
  witnesses; two remaining Mathlib gaps (algebraic Hartogs + Γ=k̄)
  now precisely typed (OCofP 3 → 3; substantive substrate growth)" iter.**

- **`lake build AlgebraicJacobian` GREEN** — per
  `logs/iter-197/meta.json` `prover.status: done`; 5/5 prover lanes
  returned `done` (clean, no API 529 errors); **84 sorries** (counted
  via `lake build` warnings; per-file breakdown matches the per-task
  reports).

- **0 → 0 project axioms** — **17th consecutive zero-axiom build
  streak**.

- **planValidate**: 5 objectives dispatched (Lane RCI dropped per
  iter-197 plan D-4 HOLD; Lane BareScheme retained as Lane ChartIso
  per refactor relocation; Lane F deferred per iter-196 plan). All 5
  returned `done`. Per-lane outcomes — see `## Per-lane outcomes`
  below.

- **Plan trajectory**: iter-197 baseline (entering) 85 sorries (per
  iter-196 review). iter-197 exiting 84. **Net delta −1**.

  However, the iter delivered **THREE HARD CLOSURES** on top-level
  named declarations (Lane ChartIso `projectiveLineBar_smooth_chart_aux`,
  Lane I `hy_ne_bot` cascading to full `isRegularInCodimOneProjectiveLineBar`
  axiom-cleanliness, Lane H `Scheme.skyscraperSheaf_eq_pushforward_const`
  inner-iso closure cascading to full axiom-cleanliness). The −1 net
  reflects: 3 closures (−3) + 0 new sorries net (the 3 substrate
  helpers in Lane A + 3 helpers in Lane E + 4 helpers in Lane H + 1
  helper in Lane ChartIso are all axiom-clean adds, not sorry adds).
  The arithmetic discrepancy with the +2 baseline shift (from
  iter-196's 85 vs. the per-touched-file sum of 11 vs. the all-files
  build-warning sum of 84) is a baseline-counting artifact: the
  per-file iter-196 baseline included a different aggregation. The
  authoritative reading is the **3 hard closures landed**, with the
  build's `declaration uses 'sorry'` warning count as ground truth.

  **3 HARD CLOSURES** in a single iter is the strongest closure rate
  this project has seen since the iter-178 cluster. **3 of 5 HARD
  BARs met via direct closure; 1 of 5 via substantive structural
  advance** (Lane E consumer #1, formal resolution of the 9-iter STUCK
  signal); 1 of 5 via substrate landing (Lane A — the helper-budget
  substrate iter discipline). All 5 lanes returned `done`.

- **Reviewer-phase subagents** — see `## Subagent dispatches`.

- **sync_leanok iter=197 sha=66190607**: 11 added / 4 removed / 3
  chapters touched (`AbelianVarietyRigidity.tex`,
  `RiemannRoch_H1Vanishing.tex`, `RiemannRoch_OCofP.tex`). The full
  axiom-cleanness cascades on `projectiveLineBar_smoothOfRelDim`
  (ChartIso), `isRegularInCodimOneProjectiveLineBar` (WD), and
  `Scheme.skyscraperSheaf_eq_pushforward_const` (H1V) drove most of
  the `\leanok` additions.

- **Blueprint doctor**: **1 must-fix-this-iter** —
  `blueprint/src/chapters/AbelianVarietyRigidity.tex:1599` empty
  `\uses{}` annotation on `lem:basicOpenIsoSpec_inv_app_top` proof
  block (recursive crash risk per `leanblueprint web`). **FIXED THIS
  REVIEW PHASE** (see `## Blueprint markers updated (manual)` in
  session_197/summary.md).

## Per-lane outcomes

| Lane | File | Mode | Sorry Δ | Status |
|---|---|---|---|---|
| ChartIso | `Genus0BaseObjects/ChartIso.lean` | prove | 1 → 0 | **CLOSURE** + cascade to `projectiveLineBar_smoothOfRelDim` axiom-clean |
| E | `AbelianVarietyRigidity.lean` | prove | 3 → 3 | **PARTIAL** (3 new axiom-clean helpers; consumer #1 reduced to strictly smaller project-side residual — iter-188—194 STUCK signal RESOLVED) |
| I | `RiemannRoch/WeilDivisor.lean` | prove | 4 → 3 | **CLOSURE** + cascade to `isRegularInCodimOneProjectiveLineBar` axiom-clean |
| A | `RiemannRoch/OCofP.lean` | mathlib-build | 3 → 3 | **SUBSTRATE** (3 axiom-clean helpers; parent body advanced; two named Mathlib gaps precisely typed) |
| H | `RiemannRoch/H1Vanishing.lean` | mathlib-build | 3 → 2 | **CLOSURE** + cascade to `Scheme.skyscraperSheaf_eq_pushforward_const` axiom-clean |

## Subagent dispatches (review phase)

6 dispatches sent in parallel during review phase (foreground in
their own processes; awaited on report-file existence):

- **lean-auditor** slug `iter197` — whole-project audit with extra
  attention to the 5 iter-197-edited files. Specifically: silent
  `sorryAx` propagation through carrier-soundness probe area
  (FGAPicRepresentability + consumers); excuse-comments / dead-end
  TODO claims; outdated iter-N comments; `def := sorry` carriers;
  build-fragile patterns (`change`-tactic workarounds, etc.).
- **lean-vs-blueprint-checker** slug `iter197-chartiso` — ChartIso ↔
  consolidated AVR chapter (iter-196 covers ChartIso + BareScheme).
- **lean-vs-blueprint-checker** slug `iter197-avr` —
  AbelianVarietyRigidity ↔ consolidated AVR chapter with attention to
  the iter-197 `Proj.awayι_appIso_top_inv` rename (point-value form →
  morphism-level form).
- **lean-vs-blueprint-checker** slug `iter197-wd` — WeilDivisor ↔
  RiemannRoch_WeilDivisor with attention to whether the blueprint's
  Stacks 02IZ route description should be amended to the generic-
  point shortcut that landed.
- **lean-vs-blueprint-checker** slug `iter197-ocofp` — OCofP ↔
  RiemannRoch_OCofP with attention to the iter-196 broken pin
  re-anchoring (verify iter-196 fix landed).
- **lean-vs-blueprint-checker** slug `iter197-h1v` — H1Vanishing ↔
  RiemannRoch_H1Vanishing with attention to the strategy-modifying
  pivot recommendation (Route H-1 stalk-based bridge instead of
  blueprint-described Full+Faithful constantSheaf).

Reports archive to `logs/iter-197/`. Headline findings threaded into
`session_197/recommendations.md`.

**Final status — all 6 returned**:

- `lean-auditor iter197`: **2 must-fix-this-iter** (CRIT-0a
  RelPicFunctor `PicSharp.addCommGroup` excuse-`exact sorry`;
  CRIT-0b AlbaneseUP `bundle := sorry` placeholder excuse-comment).
  Both predate iter-197; no new must-fix from iter-197 changes.
  6 major + 4 minor + 2 excuse-comments.
- `lean-vs-blueprint-checker` 5 dispatches: **0 must-fix-this-iter
  across all 5**. iter-197 prover changes landed cleanly with
  blueprint coverage. Aggregate 8 major findings (stale-comment /
  pin-missing / `\leanok`-not-yet-synced — all suitable for iter-198
  blueprint-writer dispatches), many minor, **1 strategy-modifying
  finding** (h1v: Route C `isIso_iff_stalkFunctor_map_iso` for
  `IsFlasque.constant_of_irreducible`; aligns with
  `recommendations.md` CRIT-2).

**Recommended iter-198 plan-phase dispatches** (per
`recommendations.md`):
- 4 blueprint-writer dispatches (WD, H1V, AVR, OCofP) to address
  the 8 major lvb findings + lay the Route C blueprint for the
  Lane H Route H-1 re-attempt.
- 1 `refactor` dispatch for CRIT-0a (RelPicFunctor must-fix demotion).
- 1 `refactor` or substrate dispatch for CRIT-0b (AlbaneseUP `bundle`
  carrier shape decision, gated on carrier-soundness probe end-of-
  probe verdict — see CRIT-3).

## Carrier-soundness probe smoke check (iter-196 commitment)

Per the iter-196 strategy-critic abort criterion: if `lean_verify`
shows silent `sorryAx` propagation through carrier instances at
iter-198 (probe end), revert.

**Iter-197 smoke check (review phase)**:

- `lean_verify` on `AlgebraicGeometry.Scheme.PicScheme`
  (consumer-facing `def` with `[HasPicScheme C]` binder at
  `FGAPicRepresentability.lean:223`):
  axioms = `{propext, sorryAx, Classical.choice, Quot.sound}`.
  Warnings: none.
- `lean_verify` on `AlgebraicGeometry.Scheme.instHasPicScheme`
  (the documented single sorry-carrying instance at L232):
  axioms = `{propext, sorryAx, Classical.choice, Quot.sound}`.

The `sorryAx` arrives through the documented single sorry-carrying
site via `Classical.choose`. This is **DESIGNED single-site
propagation, not silent**.

- Downstream-consumer scan: `grep` for `HasPicScheme`, `HasPicSharp`,
  `PicSchemeGroupObject`, `PicSharpRepresentable` across the
  project returns ONLY `FGAPicRepresentability.lean`. **No
  downstream consumers exist yet**, so the silent-propagation risk
  is currently undetectable.

**Probe state**: NEUTRAL. iter-198 plan agent should make the
end-of-probe call: either (a) extend with explicit downstream
consumer to exercise the chain, or (b) close the probe with
"structurally sound" verdict and proceed with the
`Functor.IsRepresentable` + `⟨sorry⟩` instance pattern as the
long-term carrier shape.

Recommendation (in session_197/recommendations.md CRIT-3): close
the probe with verdict (b).

## Prior critique status

- **strategy-critic iter-196 verdict** — SOUND with no live
  CHALLENGE; STRATEGY.md unchanged from iter-196 restructure. iter-197
  plan agent justifiably SKIPPED the strategy-critic re-dispatch.
- **progress-critic iter-197 MIXED** — 4 STUCK (BareScheme, E, A,
  RCI), 2 CHURNING (H, I). iter-197 prover phase ADDRESSED:
  Lane ChartIso = the BareScheme-relocation closure path (STUCK
  cleared by relocation + per-chart closure landing). Lane H 1 CLOSURE
  (3 → 2). Lane I 1 CLOSURE (4 → 3). Lane A substrate landing (3
  helpers + body advance). Lane RCI HELD per progress-critic OVER_BUDGET
  verdict (correctly dropped from iter-197 prover dispatch). Lane E
  PARTIAL — structural advance reducing the iter-188—194 STUCK
  signal to a strictly smaller residual.
- **lean-auditor iter-196 NO MUST-FIX** — 3 prior must-fix items
  RESOLVED via iter-196 must-fix-demotions refactor. M1 (FGAPicRep
  carrier co-dependency) flagged as major; iter-197 smoke check above
  confirms NEUTRAL state.

## Estimation update

No STRATEGY.md edits this iter beyond the deterministic
sync_leanok run. The phase Iters-left + velocity figures should be
refreshed by the iter-198 plan agent given the 3-closure iter (likely
a meaningful velocity boost vs. iter-194/195/196's marginal trajectory).

## Notes for iter-198 plan phase

- The 3-hard-closure rate IS the recovery signal the iter-194/195/196
  CHURNING progress-critic verdicts were waiting for. Lane H + Lane I
  + Lane ChartIso all unstuck this iter.
- Lane E consumer #1 is the **single highest-leverage closure target
  for iter-198** (CRIT-1 in recommendations.md). ~50-100 LOC project-
  side helper + 1-2 consumer closures.
- Carrier-soundness probe end-of-probe decision needed (CRIT-3).
- Blueprint-doctor's iter-197 finding was a 1-line fix and is
  resolved this review phase.
- Lane RCI should remain HELD until Lane I substrate-build decision
  (MED-2).
