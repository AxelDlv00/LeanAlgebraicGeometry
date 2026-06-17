# Strategy Critic Report

## Slug
route172

## Iteration
172

## Routes audited

### Route: A.1 — Relative Picard / line-bundle pullback

- **Goal-alignment**: PASS — relative Picard functor is a genuine prerequisite for FGA representability of `Pic_{C/k}`, which is required for the positive-genus arm of the goal.
- **Mathematical soundness**: PASS — `RelativeSpec` → line-bundle pullback → relative Picard functor is the standard FGA staging.
- **Phantom prerequisites**: STRATEGY.md asserts "A.1.a `RelativeSpec` chapter prover-ready"; the chapter file `blueprint/src/chapters/Picard_RelativeSpec.tex` does NOT exist on disk (and is absent from `blueprint/src/chapters/`). `Jacobian.tex` L596 still refers to "the smallest entry point into Route A" generically. The "prover-ready" status is a phantom claim — the chapter has to be written first.
- **Effort honesty**: under-counted — `~700–1100 LOC` and `~0/it` realized over 5+ iters means the row implies a velocity jump to `~70–180 LOC/iter` to finish in `6–10 iters`. Since `genus-0 rigidity` is the only row achieving comparable velocity (`~80/it`) and it's a much narrower scope, A.1's `Iters left` is likely under-counted.
- **Parallelism under-exploited**: yes — A.1 is named "parallel-startable" and "first prover lane opens once a sub-chapter clears HARD GATE", yet 5 iters with no prover lane have elapsed; the parallel start has not actually happened.
- **Verdict**: CHALLENGE — fix the phantom `A.1.a prover-ready` claim, then either dispatch the missing chapter writer this iter OR accept that A.1's Iters-left needs to grow.

### Route: A.2 — Hilbert/Quot + FGA `Pic_{C/k}` representability

- **Goal-alignment**: PASS — `Pic_{C/k}` representability is the load-bearing FGA result and is mandatory for the positive-genus object.
- **Mathematical soundness**: PASS — Nitsure–Kleiman is the canonical route.
- **Infrastructure-deferral detected**: no (built in-tree with concrete sub-build plan and timeline).
- **Effort honesty**: under-counted *if* taken at face value — the inner-row prose says "two sub-builds, each ≤1500 LOC". The user's hint asks for sub-rows under 1000 LOC each; the strategy's own ceiling of 1500 LOC for flattening-stratification (the largest sub-piece) exceeds that target. The single-row presentation hides where the dependency seam actually is.
- **Parallelism under-exploited**: yes — only flattening-stratification is named as "independently startable" but it has not been started; the surrounding 2200–3000 LOC sits idle in a single sequential row.
- **Verdict**: CHALLENGE — split A.2 in `## Phases & estimations` into ≥3 sub-rows each under 1000 LOC (flattening-stratification | Quot construction | FGA Pic gluing). The single big row is concealing both the parallelism opportunity and the where-to-dispatch-prover question.

### Route: A.3 — `Pic⁰` identity component + degree map

- **Goal-alignment**: PASS — `Pic⁰` is the positive-genus Jacobian object.
- **Mathematical soundness**: PASS.
- **Phantom prerequisites**: `GroupScheme.IdentityComponent` and `LocallyConstantPushforward` are correctly flagged as absent in Mathlib; built in-tree.
- **Effort honesty**: reasonable conditional on A.2 — `~600–900 LOC / 5–8 iters` ≈ 75–180 LOC/iter, consistent with the row's gated status.
- **Parallelism under-exploited**: no for prover (genuinely gated on A.2), but the strategy correctly notes blueprint-side decomposition can start in parallel — that parallel start has not happened either.
- **Verdict**: SOUND on math; CHALLENGE only on the blueprint-decomposition parallel start that is asserted but not exercised.

### Route: A.4 — Albanese UP of `Pic⁰`

- **Goal-alignment**: PASS — Albanese UP is exactly the `isAlbaneseFor` content required by `nonempty_jacobianWitness`.
- **Mathematical soundness**: PARTIAL — the "Picard-functoriality bypass" of Thm 3.2 is asserted but un-resolved (it's also the lone item in `## Open strategic questions`). The strategy is honest that the bypass is contingent.
- **Infrastructure-deferral detected**: yes (conditional) — if the bypass fails, Auslander–Buchsbaum is required and absent in Mathlib, with no project-side plan. The row text reads "*if* Picard-functoriality bypass holds, otherwise +Auslander–Buchsbaum sub-build (open-ended)" — "open-ended" with no iter estimate is exactly the goal-required deferral pattern.
- **Effort honesty**: under-counted by best-case bias — `~7–11 iters *if* bypass holds`. The user's question pinpoints this: the strategy carries only the best-case number, not the dual `~22–30+ otherwise` figure that would honestly reflect the unresolved open question. A single best-case-only iter estimate paired with an `Open strategic question` is dishonest accounting.
- **Verdict**: CHALLENGE — either (a) dispatch a blueprint-writer this iter to resolve the bypass question (preferred — Milne III §6 is `~3 pages`, an audit is cheap), or (b) re-state the row's Iters-left as a range covering both scenarios (e.g. `~7–11 if bypass, otherwise ~22–35`).

### Route: genus-0 rigidity (`gmScalingP1` body + collapse-at-zero)

- **Goal-alignment**: PASS — proves the genus-0 base case `ℙ¹ → A const` that `genusZeroWitness.key` consumes.
- **Mathematical soundness**: PASS — the `𝔾_m`-scaling argument is clean (Cor 1.5 collapse + density on `𝔾_m ⊆ ℙ¹`). The strategy's explanation of why the Thm-3.2 circularity was illusory is rigorous.
- **Phantom prerequisites**: `Scheme.Cover.glueMorphisms` exists in Mathlib as `Scheme.OpenCover.glueMorphisms*` variants — the exact name is slightly different, recommend the strategy quote the actual Mathlib name. `Algebra.compHom` instance bridge is via the `tensoraway-instance.md` analogy — the recipe is project-internal, not a phantom Mathlib claim.
- **Effort honesty**: reasonable — `~200–270 LOC / 3–5 iters · ~80/it` is internally consistent; this is the only critical-path row with realized velocity.
- **Verdict**: SOUND — the user's question about decrementing `Iters left` to `~2–3` is reasonable but premature: the body skeleton just landed; the 3 internal sorries are isolated mechanical/deep targets, so keeping `~3–5` is the honest estimate. Tighten *after* a sorry closes.

### Route: genus-0 RR bridge (`genusZero_curve_iso_P1`)

- **Goal-alignment**: PASS — required to identify a genus-0 `k̄`-curve with `ℙ¹` so the `𝔾_m`-scaling argument applies.
- **Mathematical soundness**: PASS — RR.1–RR.4 sub-phases (Weil divisor → RR formula → `O_C(P)` global sections → rational ⟹ ≅ ℙ¹) is the standard Hartshorne IV.1.3.5 path.
- **Infrastructure-deferral detected**: no — the 4 sub-phases are explicitly named, RR.1 chapter exists (`RiemannRoch_WeilDivisor.tex`), the in-tree build is committed.
- **Effort honesty**: under-counted *as presented* — `~1500–2500 LOC / 12–20 iters · ~0/it` carries the same velocity inconsistency as Route A rows; given RR.1–RR.4 are serial, the single-row presentation hides which sub-phase the planner should fire prover lanes on first.
- **Parallelism under-exploited**: yes (sub-phase visibility) — RR.1 is the lone parallel-startable entry but it is buried inside a single row. Per user hint 3, the row should be 4 sub-rows.
- **Verdict**: CHALLENGE — expand into 4 sub-rows (RR.1 / RR.2 / RR.3 / RR.4) in `## Phases & estimations`. Without that, the planner can't see that RR.1 is the only firable lane and the rest are gated downstream.

### Route: `genusZeroWitness` body + terminal cluster + `k̄→k` descent

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PARTIAL — the strategy's `## Open strategic questions` admits `k̄→k` descent direction is unconfirmed; the row honestly carries that uncertainty.
- **Verdict**: SOUND on the gated status; the open question is documented and gates fire correctly.

### Route: `nonempty_jacobianWitness` genus-stratified body

- **Verdict**: SOUND — trivial `by_cases` glue, 1 iter, gated on both arms.

### Route: AVR refactor (housekeeping)

- **Verdict**: SOUND — 1198 LOC redistribution, low risk.

### Route: Route C overall (genus-0 via Milne §I.3)

- **Goal-alignment**: PASS — `J = Spec k` + `isAlbaneseFor` via `rigidity_over_kbar` is the right shape.
- **Mathematical soundness**: PASS — the `𝔾_m`-scaling shortcut avoids the differential route's deep prerequisites cleanly; the explanation of why apparent Thm-3.2 circularity is illusory is rigorous.
- **Sunk-cost reasoning detected**: no — Route C was selected on its merits per the iter-163 decision (Mathlib-support survey + char-general); the strategy reuses the proven Rigidity Lemma + Cor 1.5/1.2 because they are foundational, not because they are sunk.
- **Verdict**: SOUND.

### Route: Route A overall (Picard via FGA)

- **Goal-alignment**: PASS — mandatory for the positive-genus object.
- **Mathematical soundness**: PASS at the route level; load-bearing risk is concentrated in A.2 (representability) and the A.4 bypass question.
- **Infrastructure-deferral detected**: see A.4 finding above.
- **Parallelism under-exploited**: yes — the route prose says blueprint-side A.1/A.2/A.3/A.4 "happens in parallel" and prover-side "A.1 file-skeletons, A.2 flattening-stratification, genus-0 prover" are parallel-startable; 5 of those are at `~0/it`. The asserted parallelism has not been exercised.
- **Verdict**: CHALLENGE — strategy correctly identifies what should be parallel; the planner has not been firing those lanes.

## Format compliance

- **Size**: 81 lines / 12541 bytes — within line budget (≤250); marginally over the ~12 KB advisory ceiling (12.25 KiB) — non-material.
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material` in canonical order.
- **Per-iter narrative detected**: no — no `iter-NNN` or `this iter` / `last iter` references in STRATEGY.md itself. (Per-iter refs in `Jacobian.tex` L360 / L600 are blueprint-level, not strategy-level, and outside this audit's scope.)
- **Accumulation detected**: no — the AVR-refactor row is still a live phase (1 iter left); no completed phases or excised routes linger.
- **Table discipline**: PASS — LOC cells carry both `remaining · realized/it` (e.g. `~700–1100 · ~0/it`). Several Status cells are multi-clause but stay one-line. Phase column has multi-clause titles in three rows; cosmetic.
- **Format verdict**: COMPLIANT

## Infrastructure-deferral findings

### Deferred: Auslander–Buchsbaum (Mathlib gap, required if A.4 bypass fails)

- **Required by goal**: conditionally — required iff the Picard-functoriality bypass of Milne Thm 3.2 fails. The bypass is unresolved (it's in `## Open strategic questions`).
- **Current plan for building it**: none — the strategy says "+Auslander–Buchsbaum sub-build (open-ended)" with no concrete plan.
- **Timeline**: absent (open-ended).
- **Verdict**: CHALLENGE — the bypass question must be resolved before scheduling A.4 prover lanes. The fix is cheap (blueprint-writer audit of Milne III §6 §Albanese UP, ~3 pages); the cost of leaving it open is that the A.4 iter estimate is silently best-case-only, biasing planner judgement on overall project velocity.

### Deferred: `RelativeSpec` blueprint chapter (A.1.a "prover-ready" phantom)

- **Required by goal**: yes — A.1.a is the smallest Route A entry and the strategy depends on it being prover-ready to open the first Route A lane.
- **Current plan for building it**: STRATEGY.md asserts it IS prover-ready; the file does not exist. Per the user-supplied iter-171 context, a writer dispatch was attempted and killed mid-write before commit.
- **Timeline**: implicit "next iter" but no concrete commitment in STRATEGY.md.
- **Verdict**: CHALLENGE — either correct the readiness claim in STRATEGY.md (it's currently false) or dispatch the writer this iter to make it true.

## Sunk-cost flags

(none detected — pivots are justified on merits, not on prior investment)

## Prerequisite verification

- `Scheme.Cover.glueMorphisms`: RENAMED (as `Scheme.OpenCover.glueMorphismsOfLocallyDirected` / variants in `Mathlib.AlgebraicGeometry.Cover.Directed`) — recommend updating the strategy quote to the actual Mathlib name.

## Must-fix-this-iter

- Route A.1: CHALLENGE — fix the phantom "A.1.a prover-ready" claim; either dispatch the writer this iter or correct the row.
- Route A.2: CHALLENGE — split A.2 into ≥3 sub-rows each <1000 LOC (per user hint 3). The single-row presentation conceals where to dispatch prover lanes.
- Route A.4: CHALLENGE — resolve the Picard-functoriality bypass question (cheap blueprint-writer audit) OR re-state Iters-left as a dual range carrying the worst-case `+Auslander–Buchsbaum` scenario.
- Route RR bridge: CHALLENGE — expand into 4 sub-rows (RR.1 / RR.2 / RR.3 / RR.4) so the lone parallel-startable RR.1 lane is visible to the planner.
- Route A overall: CHALLENGE — the asserted parallelism (A.1 file-skeletons, A.2 flattening-stratification, genus-0 prover) has not been exercised across 5+ iters at `~0/it`. The iter-172 plan must actually open those lanes, not just re-name them as parallel-startable.
- Infrastructure-deferral CHALLENGE: Auslander–Buchsbaum required by goal *if* A.4 bypass fails — no project-side plan, no timeline. Planner must resolve the bypass question OR commit to a build.
- Infrastructure-deferral CHALLENGE: `Picard_RelativeSpec.tex` chapter is asserted prover-ready in STRATEGY.md but absent on disk.

## Overall verdict

The strategy is **mathematically sound in route selection** (Route A for positive-genus, Route C for genus-0 — both well-justified, no goal weakening) but **suffers from velocity-and-decomposition discipline gaps that have compounded into a real under-dispatch pattern**: 5 of 9 phase rows realize `~0/it` over 5+ iters while the route prose asserts those lanes are parallel-startable. The strategy defers Auslander–Buchsbaum, which is required for the stated goal if the A.4 Picard-functoriality bypass fails, with no concrete project-side plan and no timeline — the bypass question is the load-bearing uncertainty in the entire Route A budget and must be resolved this iter (the audit is ~3 pages of Milne III §6, cheap). Combined with the phantom "A.1.a prover-ready" claim and the missing per-user-hint decomposition of A.2 + RR bridge into sub-rows under 1000 LOC each, the format is COMPLIANT but the table content is not pulling its weight: the planner needs finer rows to know what to actually dispatch. The iter-172 plan to "open Lane B + Lane C parallel file-skeleton lanes" is the right corrective in direction; it is insufficient in scope — the planner should also (a) dispatch refactor subagents on the 880-LOC `Genus0BaseObjects.lean` and 877-LOC `Cohomology/StructureSheafModuleK.lean` in the same iter (user hint 1, parallelism budget allows it), (b) dispatch the A.4-bypass blueprint audit, and (c) restructure A.2 + RR-bridge rows in STRATEGY.md before the next plan phase.
