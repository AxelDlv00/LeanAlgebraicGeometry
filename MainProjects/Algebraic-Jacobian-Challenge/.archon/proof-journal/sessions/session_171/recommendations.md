# Recommendations for iter-172 plan

## CRITICAL must-fix (from `lean-auditor iter171`)

### Excuse-comment + headline-sorry closure path: `Jacobian.lean:237-263`

**Finding (severity: critical)**: `AlgebraicJacobian/Jacobian.lean:237-263` contains a 28-line excuse-comment block under `genusZeroWitness.isAlbaneseFor.key`'s `sorry`, asserting the proof "cannot be wired" due to three "out-of-file / plan-level" gates:
1. "Import cycle `Jacobian → RigidityKbar → Rigidity → Jacobian`."
2. "[CharZero] requirement of `rigidity_over_kbar`."
3. "Base-change functor missing."

**All three gates are INVALID under the iter-163 committed Route C.** `AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme` (in `AlgebraicJacobian/AbelianVarietyRigidity.lean:300+` after the iter-171 refactor-split) is:
- Import-clean — AVR imports `Genus`, `Genus0BaseObjects`, `RigidityLemma`; none of these import `Jacobian`. So `Jacobian.lean` importing AVR introduces no cycle.
- Char-free — explicitly drops `[CharZero kbar]`.
- Self-contained — doesn't require a base-change functor (the iso `genusZero_curve_iso_P1` plays the role).

**Recommended iter-172 action**: dispatch a `refactor` subagent (slug `jacobian-key-route-c-wiring`) to:
1. Delete the L237-263 excuse-comment block.
2. Add `import AlgebraicJacobian.AbelianVarietyRigidity` to `Jacobian.lean`.
3. Refactor `genusZeroWitness.isAlbaneseFor.key`'s sorry body to consume `rigidity_genus0_curve_to_grpScheme` directly.
4. Rewrite the L182-208 docstring of `genusZeroWitness` to reference route C instead of the OLD CharZero-fallback `rigidity_over_kbar` strategy.

**WARNING**: per the project memory KB (`route-c-cube-not-needed-iter163.md`), Route C requires `rigidity_genus0_curve_to_grpScheme` to be axiom-clean. That lemma still has 2 gated sorries (`iotaGm_isDominant` AVR L86, `genusZero_curve_iso_P1` AVR L290). So the iter-172 refactor will wire the body but the closure will still depend on those upstream sorries. The point is to **stop documenting wrong reasons** for "can't close" when the actual blocker is now identifiable as a concrete chain of named sorries.

This is **must-fix-this-iter** per the lean-auditor strict-severity rule: every excuse-comment lands at must-fix at minimum, and one that hides a now-available closure path on a load-bearing declaration is critical.

## HIGH priority (from `lean-vs-blueprint-checker g0bo171`, iter-172 plan-phase work)

### Blueprint-writer dispatch: pin the new substantive sorry residual

**Finding (severity: major)**: `mvPolyToHomogeneousLocalizationAway_surjective` (Genus0BaseObjects.lean:372, NEW iter-171 substantive `sorry` that the `homogeneousLocalizationAwayIso_aux_left` body now depends on) is NOT `\lean{...}`-pinned in `AbelianVarietyRigidity.tex`. The chapter sketches its closure path under `lem:proj_chart_ring_iso_aux_left` ("prove the inverse map `k̄[u] → Away 𝒜 X_i` is surjective via `Away.adjoin_mk_prod_pow_eq_top` specialised to `d=1, v=(X 0, X 1), dv=(1, 1)`") but no pinned sub-lemma exists. **Recommended iter-172 plan-phase action**: dispatch the blueprint-writer for `AbelianVarietyRigidity.tex` with a focused directive to add a sub-lemma block under `lem:proj_chart_ring_iso_aux_left` pinning `\lean{AlgebraicGeometry.mvPolyToHomogeneousLocalizationAway_surjective}`. Without this pin, `sync_leanok` cannot track the residual sorry-status per-declaration.

Optional follow-up adds (iter-172 plan agent's discretion):
- `\lean{...}` blocks for the three internal `gmScalingP1_*` helpers (chart, chart_agreement, over_coherence) so each tracked sorry surfaces in `sync_leanok` separately.
- `\lean{AlgebraicGeometry.projectiveLineBar_isProper}` sub-lemma pin (axiom-clean, substantive `Algebra.FiniteType` + bijection chain).
- Pin the affine-Spec encoding choice in `def:gm` prose (currently only documented in the Lean header docstring).

These are all minor blueprint adequacy improvements — bundle into the same writer round.

## HIGH priority (from lean-auditor, iter-172 plan-phase work)

### Stale strategic-framing docstrings (5 MAJOR findings)

Each of these documents a STRATEGY that the project has since SUPERSEDED. They are not load-bearing wrong-code issues, but they mislead future readers and dilute the iter-163 Route C commitment:

1. **`Jacobian.lean:182-208`** — `genusZeroWitness` docstring frames `key` via the OLD CharZero-fallback `rigidity_over_kbar` + faithfully-flat-descent. Bundle this rewrite with the must-fix refactor above.
2. **`Cotangent/ChartAlgebra.lean:36-79`** — file-level docstring sells the file as the "iter-144 chart-algebra pivot route" — decommitted iter-163 (Route C) / iter-164 (𝔾ₘ-scaling shortcut). Resolution: either trim the file to a thin placeholder OR rewrite the docstring as "off-path artifact retained for possible char-0 sub-case." 459 LOC of substantive (proven) lemmas — trimming would lose work, so prefer the docstring rewrite.
3. **`Cotangent/GrpObj.lean:428-525`** — long docstring blocks describe `basechange_along_proj_two_inv*` and `relativeDifferentialsPresheaf_basechange_along_proj_two` — both EXCISED at iter-145 (acknowledged at L552-560 of the same file). Internally contradictory; trim the L428-525 block.
4. **`RigidityKbar.lean:21-46`** — status block frames the file as the "iter-126 scaffold" gated on the cotangent-vanishing Mathlib pile. Superseded iter-156 ("RED HERRING") + iter-163 (Route C). File's role is now (per AVR.lean L16-17) the route-(a) [CharZero] fallback artifact; rewrite the status block to say so.
5. **`AbelianVarietyRigidity.lean:245-247, 311-314, 288-289`** — iter-166/iter-167 status time-stamps in docstrings rot. Convert to "status: open/partial/closed" idiom rather than time-stamping.

**Recommended iter-172 action**: bundle items 1+2+3+4 into a single `refactor` lane (slug `legacy-docstring-purge`); item 5 can be a blueprint-reviewer auto-fix follow-up or rolled into the same lane. Total scope ≈ 5 files of docstring rewrites; no code changes.

### Stale `% NOTE:` blueprint markers

Already addressed this review:
- `AbelianVarietyRigidity.tex:1147-1156` `def:gaTranslationP1` `% NOTE:` refreshed to iter-171 "body landed as concrete `Over.homMk + Scheme.Cover.glueMorphisms` with 3 named internal sorries".
- `AbelianVarietyRigidity.tex:1208-1213` `lem:gmScaling_fixes_zero` `% NOTE:` refreshed to iter-171 "gate is now NARROWER on the three internal helpers".
- `AbelianVarietyRigidity.tex:1091-1094` `def:proj_chart_ring_iso` `% NOTE (iter-169):` refreshed to iter-171 "the reverse round-trip body lands real this iter; sorry residual moved one node downstream to `mvPolyToHomogeneousLocalizationAway_surjective`".

No further iter-172 blueprint-marker action required from these.

## Continued route progress (closest-to-completion targets)

### Top iter-172 prover lane: close `mvPolyToHomogeneousLocalizationAway_surjective` (`Genus0BaseObjects.lean:372`)

This is the focused surjectivity helper that the iter-171 prover added to enable a real cancel-surjective body on `homogeneousLocalizationAwayIso_aux_left`. Closure is well-isolated (~60-80 LOC) via `Away.adjoin_mk_prod_pow_eq_top` specialised to `d=1, ι'=Fin 2, v=![X 0, X 1], dv=![1,1]`.

Once landed:
- `homogeneousLocalizationAwayIso_aux_left` becomes axiom-clean (the proof body already lands; only the helper sorry propagates).
- `homogeneousLocalizationAwayIso` becomes axiom-clean.
- `projGm_isReduced` (L876) becomes attemptable (its chart-local branch needs the iso).
- `gmScalingP1_chart` body (L695) becomes attemptable (its construction needs the iso).

This unblocks 3 downstream closures. **Highest leverage** per LOC for iter-172.

### Lane A continuation: `gmScalingP1_chart` (`Genus0BaseObjects.lean:695`)

After the iso is axiom-clean: chart-`i` scheme morphism via `pullbackSpecIso ≫ Spec.map (gmScalingP1_chart_i_ringMap) ≫ Spec.map (homogeneousLocalizationAwayIso.symm) ≫ Proj.awayι`. ~30 LOC per chart, ~60 LOC total. Two PRIMARY sub-targets stacked.

### Lane B + Lane C: file-skeleton drops per iter-171 plan's decomposition commitment

- **Lane B**: `AlgebraicJacobian/Picard/RelativeSpec.lean` (NEW file-skeleton based on `blueprint/src/chapters/Picard_RelativeSpec.tex`). HARD GATE: scoped blueprint-reviewer re-check on the new chapter via same-iter fast path.
- **Lane C**: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (NEW file-skeleton based on `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`). HARD GATE: same.

These are committed by the iter-171 plan. **The blueprint-doctor reports the iter-171 chapter `RiemannRoch_WeilDivisor.tex` covers a file that doesn't yet exist** — the Lane C dispatch will resolve this finding. If Lane C is deferred past iter-172, the blueprint-doctor flag persists; either close it via dispatch or update the chapter's `% archon:covers` to defer.

## Mid-priority follow-ups

### MINOR build hygiene (from lean-auditor):

- `Genus0BaseObjects.lean:237` — `push Not at h` is non-standard syntax (probable typo for `push_neg at h`). Verified this review: the line literally reads `push Not at h`, and the build is green, so it works somehow. Fix to `push_neg at h` for idiomatic clarity.
- `Genus0BaseObjects.lean:262-263` — `@[simp]` on `private lemma otherFin_zero/_one` mildly inconsistent (`private` only controls API visibility but `@[simp]` registers globally).
- `AbelianVarietyRigidity.lean:196` — `haveI hιDom : ... := iotaGm_isDominant` has unused name `hιDom`; drop or use anonymous `haveI`.
- `RigidityLemma.lean:685-690` — `rigidity_core` inlines a copy of `Scheme.Over.ext_of_eqOnOpen` because the wrapper lives downstream. Future cleanup: promote the wrapper upstream and consume.

These are low-leverage — bundle into a polish iter or roll into the docstring-purge lane.

## Blocked / do NOT retry (with reasons)

- **`projectiveLineBar_geomIrred`** (L188) and **`gm_geomIrred`** (L844) — genuine Mathlib gap (no `GeometricallyIrreducible` for `Proj` of polynomial ring, no `GeometricallyReduced` for `Spec(domain)`-style claims). Do NOT re-assign without first dispatching a `mathlib-analogist` consult to confirm no recent Mathlib addition has filled the gap.
- **`projectiveLineBar_smoothOfRelDim`** (L195) — genuine Mathlib gap (no `SmoothOfRelativeDimension 1` for `Proj` of polynomial ring). Same rule.
- **`gm_grpObj`** (L624) — deferred 3 iters via the iter-167 analogist "FREE 2-3 LOC" verdict-correction (the actual closure needs an explicit `RepresentableBy` functor + naturality bundle, ~80-150 LOC). Per KB pattern, do NOT re-attempt via single-line `GrpObj.ofRepresentableBy` calls; if iter-172 wants to attempt, dispatch a proper `mathlib-analogist` consult first with the explicit "concrete witness construction sketch" follow-up.
- **`genusZero_curve_iso_P1`** (AVR L290) — the RR bridge. iter-168 `rrbridge` analogist returned NOT_DISPATCHABLE in-tree (Mathlib lacks the scheme-level divisor/Pic/RR stack). The iter-171 plan COMMITTED an in-tree sub-build via the new `RiemannRoch_WeilDivisor.tex` chapter + Lane C — wait for Lane C to scaffold before attempting closure.
- **`iotaGm_isDominant`** (AVR L86) — gated on `gmScalingP1` body being concrete enough that `infer_instance` can find the `IsOpenImmersion → IsDominant` chain. The iter-171 body skeleton is a concrete `Over.homMk + glueMorphisms` invocation but the chart sorries propagate; `iotaGm_isDominant` becomes attemptable once `gmScalingP1_chart` body lands (PRIMARY iter-172 above).

## Reusable proof patterns discovered this iter (added to PROJECT_STATUS.md KB)

See the new entries appended to `PROJECT_STATUS.md` Knowledge Base section.

## Summary for the next plan agent

iter-172 should:

1. **MUST-FIX**: dispatch a `refactor` lane (slug `jacobian-key-route-c-wiring`) to delete the excuse-comment + wire `genusZeroWitness.key` to `rigidity_genus0_curve_to_grpScheme`.
2. **High-leverage**: open a Lane A continuation on `Genus0BaseObjects.lean` attacking `mvPolyToHomogeneousLocalizationAway_surjective` (unblocks 3 downstream closures).
3. **Decomposition commitment from iter-171**: open Lane B + Lane C file-skeletons on `Picard/RelativeSpec.lean` + `RiemannRoch/WeilDivisor.lean` (the latter ALSO clears the blueprint-doctor's "file does not exist" finding).
4. **MAJOR polish bundle**: dispatch a `refactor` lane (slug `legacy-docstring-purge`) to rewrite the 4 stale strategic-framing docstrings.
5. The iter-170 → iter-171 reversal trigger DOES NOT FIRE; Route C with option (c) inline chart-glue remains committed.
