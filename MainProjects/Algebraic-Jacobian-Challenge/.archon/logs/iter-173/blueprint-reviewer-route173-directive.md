# Blueprint-reviewer directive — slug `route173`

## Scope

Whole-blueprint audit. Read every chapter under `blueprint/src/chapters/`.

## Specific HARD GATE requirements for iter-173

The planner intends to send prover lanes against three files this iter:

- `AlgebraicJacobian/Genus0BaseObjects.lean` → chapter `AbelianVarietyRigidity.tex` (covers G0BO via `% archon:covers`).
- `AlgebraicJacobian/Picard/RelativeSpec.lean` → chapter `Picard_RelativeSpec.tex` (NEW iter-172; first prover lane this iter — re-dispatch after iter-172 Lane B API-529).
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` → chapter `RiemannRoch_WeilDivisor.tex` (NEW iter-171; iter-172 landed file-skeleton; iter-173 targets `degree_hom` body + `PrimeDivisor` placeholder repair).

For each: report `complete: true/false` and `correct: true/false` separately and any must-fix-this-iter findings.

## Specific iter-172 review findings to follow up on

- **lean-vs-blueprint-checker `wd172`** flagged: blueprint chapter `RiemannRoch_WeilDivisor.tex` is **materially under-specified** on (a) how prime divisors should be encoded (no Mathlib predicate is named for codim-1 prime / Hartshorne $(*)$); (b) what hypothesis set `degree` / `principal` / `ofClosedPoint` should require. A `blueprint-writer wd-spec-refine` is dispatching THIS iter in parallel to repair this. Please flag both the chapter state pre-repair (so the writer's directive is correct) AND post-repair (re-fire scoped if needed).
- **lean-vs-blueprint-checker `g0bo172`** flagged: 3 named scaffold sorries (`gmScalingP1_chart`, `gmScalingP1_chart_agreement`, `gmScalingP1_over_coherence`) lack per-decl `\lean{...}` pins in `AbelianVarietyRigidity.tex`. A `blueprint-writer g0bo-pin-scaffolds` is dispatching THIS iter to add the pins.
- **lean-vs-blueprint-checker `jacobian172`** flagged: `Jacobian.tex` L344, L384–390, L425–427 still carry pre-audit "A.4 bypass-holds / ~7-11 iter / no new Mathlib namespace" prose that contradicts the iter-172 audit at L574–602 + L656. A `blueprint-writer jacobian-a4-prose-fix` is dispatching THIS iter to reconcile.

## Unstarted-phase proposal request

iter-172 returned 9 unstarted-phase chapter proposals (Picard_LineBundlePullback, Picard_RelPicFunctor, Picard_FGA_FlatteningStratification, Picard_FGA_QuotConstruction, Picard_Pic0_IdentityComponent, Picard_AlbaneseUP, RiemannRoch_RRFormula, RiemannRoch_OcOfD, RiemannRoch_RationalIsoP1) — 8 deferred to iter-173+. Please re-name these unstarted phases and propose chapter outlines for the **highest-leverage parallel-startable ones** (those whose `\uses{}` graph is rooted in already-landed chapters), so the iter-173 planner can dispatch their writers in parallel next iter.

## Constraints on your output

- Per-chapter checklist: `complete: true/partial/false`, `correct: true/partial/false`, must-fix-this-iter findings (or `none`).
- For each chapter that currently feeds a live prover lane (the 3 named above), the HARD GATE decision drives the planner's iter-173 dispatch — be precise.
- For each unstarted-phase proposal, give the chapter slug, the one-line topic, and a concrete chapter outline (skeleton headings, named definitions/theorems with placeholder `\lean{...}` pins).
