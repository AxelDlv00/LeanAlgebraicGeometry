# Strategy Critic Report

## Slug
iter181

## Iteration
181

## Routes audited

### Route: A — Picard scheme via FGA

- **Goal-alignment**: PASS — `Pic⁰_{C/k}` is the correct witness for the positive-genus arm; Kleiman §4–§5 + Nitsure §5 + Milne III §6 cover existence + Albanese UP.
- **Mathematical soundness**: PASS — decomposition A.1 → A.2 → A.3 → A.4 is the standard FGA architecture; dependency graph in `## Routes` is acyclic and faithful.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — every gap has an in-tree owner (each row names a `.lean` path that is the project's deliverable). The "Axiomatise-then-replace" lever is explicitly TRACKED, NOT COMMITTED with a velocity-based trigger; this is acceptable contingency, not deferral.
- **Phantom prerequisites**: none verified phantom; `GroupScheme.IdentityComponent` is correctly flagged as UNOWNED/new-project-material, not assumed to exist.
- **Effort honesty**: under-counted on A.4.c — see Must-fix-this-iter.
- **Parallelism under-exploited**: no — RR.1 is flagged "parallel-startable" and the A.4.a / A.4.b split is independently startable; dependency graph allows fan-out.
- **Verdict**: CHALLENGE — A.4.c estimate is missing a sub-phase (codim-≥2 standalone lemma exposure) that the row itself flags ("codim-≥2 exposure owed") without isolating it as its own line item with its own iter estimate. Either split A.4.c into A.4.c.0 (codim-≥2 exposure) + A.4.c.1 (Thm 3.2 assembly) with separate iter budgets, or expand the Risks cell with a verifiable claim that the ~12–18 estimate already absorbs the exposure work.

### Route: C — Genus-0 rigidity via Milne §I.3

- **Goal-alignment**: PASS — `J = Spec k`, char-general, matches the `[Field k]`-only signature contract; rigidity + 𝔾_m-scaling + RR bridge close the genus-0 arm without `CharZero`.
- **Mathematical soundness**: PASS — Rigidity Lemma + Cor 1.5 + Cor 1.2 are recorded as axiom-clean in `## Open strategic questions`; the chart-bridge 𝔾_m-scaling shortcut is the documented Milne idiom.
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags below for the chart-bridge defense.
- **Infrastructure-deferral detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: under-counted on the chart-bridge row — the LOC velocity anchor (`~25/it`) is from the `respectTransparency` recipe's PRIMARY closure, but the row's own Risks cell concedes the two remaining sorries (cross case + collapse-at-zero) "use different idiom from PRIMARY". Anchoring the projection to the recipe's velocity when the recipe does not apply is a velocity inheritance fallacy.
- **Parallelism under-exploited**: no — Genus-0 RR.1 is flagged parallel-startable against the chart-bridge.
- **Verdict**: CHALLENGE — re-anchor the chart-bridge `Iters left` on the slower realized velocity of cocycle-style ring identities (which, by definition, has no realized rate yet — so the row should read `Iters left: ~3–6 · ~? /it` with a NOT-YET-MEASURED marker), or split the row into two sub-rows, one per remaining sorry, each with a conservative independent estimate.

## Format compliance

- **Size**: 182 lines / 12995 bytes — within line budget (~250) but **over the byte budget** (~12 KB; file is 12.7 KB). Marginal; flag as DRIFTED on size alone.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — 13 explicit `iter-NNN` references across the table cells (lines 43, 46), the Open strategic questions section (lines 89–91, 102–127), and the Mathlib gaps section (line 172). Representative phrases (verbatim): "TEMP axioms RETIRED iter-180 via `respectTransparency` recipe"; "iter-180 saw Lane C close `coequifibered` axiom-clean"; "**Pre-committed replacement candidate (DEMOTED iter-181)**"; "iter-181 plan-phase fix: refactor + chapter-side prose tightening". This is per-iter narrative that the format rule explicitly forbids ("Per-iter history belongs in iter/iter-NNN/plan.md, never in STRATEGY.md").
- **Accumulation detected**: yes — the "**Pre-committed replacement candidate (DEMOTED iter-181)**" block (lines 106–115) is an excised route still occupying ~10 lines of strategic-question real estate. Per the format rule, demoted alternatives belong in iter sidecars, not in STRATEGY.md. Similarly, the long parenthetical on lines 102–105 narrating which lanes closed which axioms in iter-180 is accumulation, not strategy.
- **Table discipline**: PASS — table columns match canonical (`Phase | Status | Iters left | LOC (remaining · realized/it) | Key Mathlib needs | Risks`); LOC cells carry both figures where realized; rows that are gated honestly mark `gated` in the velocity slot.
- **Appendix sections**: none.
- **Format verdict**: NON-COMPLIANT — per-iter narrative pollution is pervasive (13 hits across 4 sections) and accumulation is present in two sub-bullets. The byte-budget overage is symptomatic, not the cause.

## Sunk-cost flags

- `**Genus-0 rigidity — chart-bridge body** | TEMP axioms RETIRED iter-180 via 'respectTransparency' recipe; 2 honest sorries remain` (line 46) and `**Status: DEMOTED to off-path fallback (was "pre-committed replacement"); to be invoked only if either of the 2 remaining chart-bridge sorries proves intractable to even state.**` (lines 113–115) — Why this is sunk-cost: the strategy defends the chart-bridge approach by appealing to the recipe-validated PRIMARY closure, then in the same breath concedes that the remaining sorries use a different idiom. The PRIMARY-closure success is a fact about a different lemma; it does not bear on the velocity or tractability of cross-case + collapse-at-zero. The DEMOTION of the separated-locus alternative is justified entirely by "the recipe worked twice on the load-bearing lemma" — an inference about validation on one lemma being elevated to a route-level decision about a fallback. Recommendation: reframe the fallback gating on a concrete signal about the cocycle-bridge sorries themselves (e.g. "if cross-case sorry remains open after two iters with no analogist recipe surfacing, re-promote separated-locus"), not on the recipe's PRIMARY success.

## Must-fix-this-iter

- Route A: CHALLENGE — A.4.c row must either split out the codim-≥2 exposure as a sub-row with its own iter estimate, or expand the Risks cell to make explicit that the ~12–18 estimate absorbs that sub-phase. The current row's status line ("codim-≥2 exposure owed") is informational only and is not reflected in the estimate.
- Route C: CHALLENGE — chart-bridge `Iters left: ~2–4 · ~25/it` anchored on the wrong velocity (PRIMARY recipe is empirically validated, remaining sorries use a different ring-level idiom). Re-anchor on a NOT-YET-MEASURED velocity for cocycle-style work, OR split the row per remaining sorry, OR widen the band to ~3–6 with explicit "recipe does not transfer" note.
- Format: NON-COMPLIANT — restructure STRATEGY.md in-place this iter. Three concrete deviations:
  1. **13 per-iter `iter-NNN` references** must be excised from table cells (lines 43, 46), the End-state-contract bullet (lines 89–91), the Axiomatise lever bullet (lines 102–105), the DEMOTED-replacement bullet (lines 106–115), the Critic-disclosure-discipline bullet (line 116), the Signature-drift-watchlist bullet (lines 123–127), and the Mathlib-gaps chart-bridge bullet (line 172). Move the per-iter narrative into `iter/iter-NNN/plan.md`; in STRATEGY.md, keep only the timeless strategic content (e.g. "0 project axioms entering this iter" without naming which iter retired what).
  2. **DEMOTED-replacement block** (lines 106–115, ~10 lines) is an excised route still resident in the strategy. Either delete it (its replacement-candidate status has been resolved) or compress to a single line under `## Open strategic questions` naming the gating condition without the iter-by-iter history.
  3. **Iter-tagged parenthetical on lines 102–105** narrating which lanes closed which axioms is accumulation. Replace with a single timeless line: "Trigger not currently met (Route A velocity is non-zero on file-skeleton lanes)."

  Once the per-iter pollution is removed, the file should drop to ~140–160 lines / ~10 KB, comfortably under the format budget.

## Overall verdict

The two-arm spine (Route A pointed + Route C genus-0) is sound, goal-aligned, and the witness object `J` is unconditional; the strategy correctly recognizes the `[Field k]`-only char-general contract and keeps the genus-0 arm char-general via Milne §I.3. The dependency graph is acyclic; parallelism is exploited; no infrastructure-deferral patterns are present (every gap is in-tree owned). The two strategic CHALLENGEs are local-estimate honesty issues, not route-level breakage: the A.4.c row hides a sub-phase, and the chart-bridge row inherits a velocity from a recipe that does not apply to the remaining sorries. The dominant finding is the format NON-COMPLIANCE — pervasive per-iter narrative pollution (13 `iter-NNN` references) plus accumulation of a now-demoted alternative-route block. This is the third format dimension where the file is drifting (per-iter narrative + accumulation + byte-budget overage), and the canonical fix — moving the per-iter history into `iter/iter-181/plan.md` — will simultaneously address the byte overage and the accumulation. Re-render STRATEGY.md timeless; let the iter sidecar carry the narrative.
