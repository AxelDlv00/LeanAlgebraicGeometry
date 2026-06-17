# Iter-198 plan-phase recommendations (from session_197)

## CRITICAL — Must-fix-this-iter (HARD GATE for iter-198 prover dispatch)

The iter-197 `lean-auditor iter197` returned **2 must-fix-this-iter**
findings (`task_results/lean-auditor-iter197.md`). Both predate iter-197
but hit the must-fix threshold this iter; the iter-198 plan agent must
either address them via a `refactor` subagent dispatch or record an
explicit rebuttal.

### CRIT-0a — `RelPicFunctor.lean:231-235` — `PicSharp.addCommGroup` excuse-`exact sorry`

`-- TODO (A.1.b gate): close once \`LineBundle.OnProduct\` is upgraded...`
immediately followed by `exact sorry` in a **data-producing
`AddCommGroup` instance**. This silently propagates `sorryAx` through
the data layer into any downstream code synthesizing `AddCommGroup`
on `PicSharp`.

**Recommended fix** (refactor subagent, ~30-60 LOC):
- Demote the instance to a `theorem` or extract the sorry-carrying
  data into a typed `private noncomputable def` so the instance shape
  matches the documented `Functor.IsRepresentable` carrier discipline
  established for `FGAPicRepresentability` in iter-196.
- The plan-phase `refactor must-fix-demotions` slug from iter-196 is
  the analogous prior fix; a similar approach should land cleanly.

### CRIT-0b — `AlbaneseUP.lean:183` — `bundle : Bundle C := sorry` placeholder

`noncomputable def bundle : Bundle C := sorry` with docstring
"File-internal **placeholder carrier**". The word "placeholder" in a
docstring on a `def := sorry` is an excuse-comment per audit rules.

`bundle` feeds `jacobianScheme`, `jacobianScheme_grpObj`,
`jacobianScheme_isProper`, `jacobianScheme_smooth`,
`jacobianScheme_geomIrred` — all the load-bearing Pic⁰ structure for
the positive-genus arm.

**Note**: iter-196's `lean-auditor iter196` already addressed instance
propagation (instance → def demotion). The `def` itself remains a
sorry-carrying load-bearing definition. The iter-197 audit re-flagged
it because the excuse-comment in the docstring meets the threshold.

**Recommended fix** (depends on Pic⁰ pivot status):
- Per the iter-195 `analogies/pic0-ker-deg-pivot.md` Pic⁰ via
  `PicScheme.degComp` route landed iter-195+196, `bundle` should be
  replaceable with the `degComp` strata extract — which collapses the
  excuse comment.
- Defer to the carrier-soundness probe end-of-probe verdict (CRIT-3
  below): if the probe closes with "structurally sound", apply the
  same `Functor.IsRepresentable`-style carrier discipline to `bundle`.

## HIGH priority

### CRIT-1 — Lane E push to consumer #1 closure (highest leverage)

`AbelianVarietyRigidity.lean:432` (`kbarChart1Ring_specMap_fac`)
is one helper away from axiom-clean closure. Iter-197 reduced the
iter-188—194 STUCK "Proj.appIso evaluation" residual to a strictly
smaller project-side `onePt.left.app(D₊(X_1))` evaluation by
substituting the three new helpers
(`Proj.basicOpenIsoSpec_inv_app_top`, `Proj.awayι_app_basicOpen`,
`Proj.awayι_appIso_top_inv`).

**Next step**: build a project-side helper
`Proj.fromOfGlobalSections_app_basicOpen` (or
`fromOfGlobalSections_appLE`) on top of
`Genus0BaseObjects/Points.lean`'s `evalIntoGlobal` /
`pointOfVec` infrastructure. Estimated ~50-100 LOC.

The Mathlib bridge to use: `Proj.fromOfGlobalSections_morphismRestrict`
(`Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean:493`) gives
the morphism-level restriction; lift to `.app`-level via the same
`Scheme.Hom.appTop`-helper discipline established in iter-197
(`change`-tactic for the dependent-motive issue; see KB).

Closing consumer #1 cascades:
- Same helper-substitution unlocks consumer #2
  (`iotaGm_chart1_appIso_eval`, L640) — closure path mechanical
  modulo `pullbackSpecIso` chain unfold.
- Both consumers were the iter-188-194 STUCK signal; closing them is
  the strongest possible visible-headline-progress for iter-198.

**Effort**: 1 prover lane (~50-100 LOC project-side helper + 2
consumer closures). Suggested directive: "build
`Proj.fromOfGlobalSections_app_basicOpen` then close consumer #1
axiom-clean; if helper budget allows, attempt consumer #2".

### CRIT-2 — Lane H route pivot (stalk-based iso bridge)

The iter-197 prover task explicitly flagged that the
`IsFlasque.constant_of_irreducible` non-empty branch (L138) should
NOT be retried via the blueprint's described Route A (Full+Faithful
constantSheaf — a Mathlib gap).

**Recommended pivot**: stalk-based iso bridge via
`TopCat.Presheaf.isIso_iff_stalkFunctor_map_iso`. On an irreducible
space X with non-empty `U`, the constant sheaf has stalks `A` at
every point of `U`. A restriction map between two non-empty opens
induces identity-on-stalks (after the canonical `stalkFunctor`-iso
`A ≅ stalk`). By `isIso_iff_stalkFunctor_map_iso`, this implies the
restriction is iso (in particular surjective). This route AVOIDS
the F+F Mathlib gap entirely.

**Effort**: 1 prover lane. Possible blueprint-writer dispatch
upstream to align Route H-1 prose with the new path (mark as
"strategy-modifying finding" — see the iter-197 lean-vs-blueprint-checker
H1V report for details).

**Do NOT retry** (recorded as anti-pattern):
- `Full + Faithful constantSheaf` on irreducible spaces — verified
  Mathlib gap at snapshot `b80f227`; neither `Sheaf.IsConstant`
  irreducible-space instance nor `stalkFunctor`-based
  `presheafToSheaf` iso bridge exist.

### CRIT-3 — Carrier-soundness probe end (iter-198)

Iter-196 plan committed to a 2-3 iter probe period ending iter-198.
Iter-197 smoke check returned **PROBE STATE NEUTRAL** (no downstream
consumers exist yet; `sorryAx` propagation through `HasPicScheme`
typeclasses is the designed single-site behavior).

The iter-198 plan agent must make the end-of-probe call:
1. **Extend** with explicit downstream consumer to exercise the
   typeclass-synthesis chain and observe whether silent `sorryAx`
   leaks; OR
2. **Close** the probe with a "no signal observed; structurally
   sound" verdict and proceed with the `Functor.IsRepresentable` +
   `⟨sorry⟩` instance pattern as the long-term carrier shape.

Recommendation: **(2) close**. The pattern is mathematically
sound; the silent-propagation concern was hypothetical and the
documented single-site behavior is what we want.

## MEDIUM priority

### MED-1 — Lane A substrate-build follow-on

The iter-197 prover task report types both remaining ingredients
precisely:

- (i) Hartogs gluing on integral locally-Noetherian
  `IsRegularInCodimensionOne` X: `∀ Q, ∃ a : stalk Q, algebraMap a = f`
  ⟹ `∃ s : Γ(X, ⊤), germ s = f`.
- (ii) `Module.Finite kbar Γ(C, 𝒪_C)` on proper geometrically-
  irreducible C.

Both are Mathlib gaps. Iter-198 should choose ONE to build
project-side as a substrate iter (mathlib-build helper budget = 3).
Recommend (i) first — Stacks 0BCK has a direct algebraic statement
amenable to project-side formalization (~150-300 LOC). (ii) needs
Hartshorne III.5.2 cohomology substrate (substantially heavier).

### MED-2 — Lane I substrate-build for the function-field bridge

The remaining 3 WeilDivisor sorries
(`degree_positivePart_principal_eq_finrank`,
`principal_degree_zero`, `rationalMap_order_finite_support`) all
gate on the SAME Hartshorne I.6.12 / II.6.9 substrate — the
function-field-determines-curve morphism. Analogist verdict:
`NEEDS_MATHLIB_GAP_FILL`.

Per the iter-197 prover task, this is now the SINGLE load-bearing
missing piece for all 3 sorries. Iter-198 should NOT attempt
tactical closures on any of the 3 bodies — instead, decide between:
- (a) Mathlib upstream PR (~400-600 LOC if done correctly).
- (b) Project-side substrate-build (faster, narrower).
- (c) Continue parking and route around it.

The strategy-critic / blueprint-writer dispatches for this
substrate decision should be SCHEDULED iter-198 plan phase.

### MED-3 — Lane RCI HOLD (continues per iter-197 plan D-4)

Per the iter-197 progress-critic OVER_BUDGET verdict, Lane RCI
remains HELD until STRATEGY.md decision on `IsNormalScheme` scope
+ LQF closed-point scope OR USER RR.4 input. iter-198 plan agent
should re-evaluate after Lane I substrate-build decision (MED-2).

### MED-4 — Lane F deferred (per iter-196 plan)

`QuotScheme.lean` Lane F deferred to iter-197 unless other lanes
free up — they did not, and Lane F was NOT dispatched iter-197.
Iter-198 should re-evaluate Lane F dispatch given Lane E closure
landed.

## LOW priority / notes

### LOW-1 — Blueprint prose follow-up on Lane E

The iter-197 review patched the `\lean{...}` pin for
`lem:awayi_appIso_top_inv_apply_isLocElem` from the point-value form
(never built) to the morphism-level form. The prose still describes
the point-value form. A blueprint-writer dispatch (`avr-lane-e-prose-iter198`)
could reshape the prose to describe the morphism-level result and
its point-value corollary. Not blocking.

### LOW-2 — `change`-tactic polish opportunities

Iter-197's Lane E + Lane H closures used multiple `change` tactics
to bridge dependent-motive issues. One `change` in
`Scheme.skyscraperSheaf_iso_constantSheaf_punit` was flagged by the
linter as not changing the goal (kept for documentation). A polish
pass could clean these up but it's not load-bearing.

### LOW-3 — `Algebra.SubmersivePresentation` Mathlib upstream PR

The iter-196 KB entry on `mvPolynomialFin_isStandardSmoothOfRelativeDimension`
(used as substrate by the iter-197 Lane ChartIso closure) is a clean
~50 LOC kernel-clean addition usable in any project. **Strong Mathlib
upstream PR candidate**. The user (or the project lead) could file
this when convenient; it's not blocking the loop.

## Plan agent — recommended iter-198 prover dispatch (4 lanes)

Suggested final shape after blueprint-doctor / blueprint-reviewer /
progress-critic / strategy-critic clear:

1. **AbelianVarietyRigidity.lean** (Lane E) — `mathlib-build` mode;
   build `Proj.fromOfGlobalSections_app_basicOpen` helper, close
   consumer #1 axiom-clean, attempt consumer #2 if budget allows.
   **HIGHEST LEVERAGE** (closes the 9-iter STUCK Lane E
   substantively).
2. **H1Vanishing.lean** (Lane H) — `prove` mode; close
   `IsFlasque.constant_of_irreducible` non-empty branch via the
   stalk-based iso bridge pivot. CRIT-2 above.
3. **OCofP.lean** (Lane A) — `mathlib-build` mode; begin substrate
   for sub-helper (i) algebraic Hartogs on
   `Scheme.IsRegularInCodimensionOne` X. MED-1 above.
4. **Cohomology / WeilDivisor substrate** (Lane I substrate) — if
   strategy-critic clears the I.6.12 substrate-build path. MED-2
   above. ALTERNATIVELY defer to iter-199.

(Total: 3-4 prover lanes, all with explicit substrate or closure
targets per the iter-192 user hint "push beyond HARD BAR".)

## Recordings of subagent reports

The 6 review-phase subagent reports auto-archive to
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/logs/iter-197/`.

- `lean-auditor iter197` — **COMPLETE** (9.2 min, $2.16). Report at
  `.archon/task_results/lean-auditor-iter197.md`. **2 must-fix-this-iter**
  threaded into CRIT-0a / CRIT-0b above. 6 major / 4 minor / 2
  excuse-comments. No new must-fix introduced by iter-197; both
  must-fix items predate iter-197.

- `lean-vs-blueprint-checker` 5 dispatches — **ALL COMPLETE**.
  **Zero must-fix-this-iter findings across all 5 reports**. iter-197
  prover changes landed cleanly with blueprint coverage. Summary:

  - `iter197-chartiso` — 0 must-fix, 1 major (stale "Status (iter-196)"
    note on `lem:projectiveLineBar_smoothOfRelDim` should be updated
    to "Status (iter-197): axiom-clean, closed"), 2 minor.
  - `iter197-avr` — 0 must-fix, 2 major: (i) `lem:awayi_appIso_top_inv_apply_isLocElem`
    lacks `\leanok` on statement/proof blocks despite the Lean
    declaration being axiom-clean — the iter-197 review-phase rename
    likely arrived AFTER `sync_leanok` ran; the next `sync_leanok`
    (iter-198) should pick it up via the now-matching `\lean{...}`
    pin; (ii) "Consumer dispatch" paragraph (blueprint L1858-1888)
    stale — its 3-step closure prediction for `kbarChart1Ring_specMap_fac`
    was partially wrong; should describe the new `onePt.left.app(D₊(X_1))`
    residual. 3 minor.
  - `iter197-wd` — 0 must-fix, 2 major: (i) `isRegularInCodimOneProjectiveLineBar`
    (now axiom-clean) has no `lem:isRegularInCodimOneProjectiveLineBar`
    blueprint entry — blueprint-coverage gap; (ii) `Scheme.IsRegularInCodimensionOne`
    class (used in subsequent signatures) has no `\lean{...}` pin.
    2 minor.
  - `iter197-ocofp` — 0 must-fix, 1 major (missing proof-block
    `\leanok` markers for `toFunctionField_injective` and
    `globalSections_iff_mpr` — `sync_leanok` tooling gap on private
    declarations; plan agent should verify sync behavior or manually
    add `\leanok` at next review). 3 minor.
  - `iter197-h1v` — 0 must-fix, 2 major (both pre-existing standing
    sorries on `IsFlasque.constant_of_irreducible` non-empty and
    `IsFlasque.injective_flasque`; the latter is the j_! standing
    deferral). 5 minor. **⚑ STRATEGY-MODIFYING FINDING**: blueprint
    `% NOTE` for `lem:isFlasque_constant_irreducible` (L183-219)
    currently documents Route A (Full+Faithful constantSheaf, Mathlib
    gap) as preferred + Route B (alternate sheaf, ~150-200 LOC); the
    iter-197 prover's Route C (stalk-based via
    `isIso_iff_stalkFunctor_map_iso`, ~50-80 LOC) AVOIDS both. iter-198
    plan agent should dispatch a blueprint-writer to add Route C and
    re-prioritise. **This finding directly aligns with CRIT-2 above.**

  **Recommended iter-198 plan-phase blueprint-writer dispatches** (4
  chapters), each carrying the corresponding major findings:
  1. `RiemannRoch_WeilDivisor.tex` — add `lem:isRegularInCodimOneProjectiveLineBar`
     statement + `\lean{...}` pin on `Scheme.IsRegularInCodimensionOne`.
  2. `RiemannRoch_H1Vanishing.tex` — add Route C to the `% NOTE`,
     update stale `% NOTE M-2`, update stale Lean docstring.
  3. `AbelianVarietyRigidity.tex` — update stale "Status (iter-196)"
     note on `lem:projectiveLineBar_smoothOfRelDim` + stale "Consumer
     dispatch" paragraph + label/title for the renamed
     `awayι_appIso_top_inv` lemma.
  4. `RiemannRoch_OCofP.tex` — remove stale "iter-190+ strategy"
     comment from `carrierPresheaf_isSheaf` (Lean side, not chapter);
     optionally pin the 3 iter-197 helpers.

  The iter-197 review intentionally did NOT proactively patch these
  beyond the malformed `\uses{}` (blueprint-doctor crash risk) and
  the `\lean{...}` rename (immediate-impact). The major findings
  above are correctly the iter-198 plan-phase's domain (blueprint-writer
  dispatches, not review-agent patching).
