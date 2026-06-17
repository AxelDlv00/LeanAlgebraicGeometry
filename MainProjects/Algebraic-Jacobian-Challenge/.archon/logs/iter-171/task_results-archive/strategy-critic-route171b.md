# Strategy Critic Report

## Slug
route171b

## Iteration
171

## Routes audited

### Route: A — FGA Picard scheme (positive-genus arm), now 4-row split A.1/A.2/A.3/A.4

- **Goal-alignment**: PASS — the protected signature demands a real `J` of dim `g` even when `C(k)=∅`; only `Pic⁰_{C/k}` via FGA delivers this unconditionally.
- **Mathematical soundness**: PARTIAL — see effort honesty below. The A.1/A.2/A.3 sub-decomposition matches the standard FGA chain (line-bundle pullback ⟹ representability ⟹ identity component). A.4's "no new Mathlib namespace" claim is questionable (see Sunk-cost / Infrastructure-deferral).
- **Sunk-cost reasoning detected**: no — past assets (Rigidity Lemma, Cor 1.2/1.5) are correctly identified as Route C **and** Route A inputs, not as Route A justification.
- **Infrastructure-deferral detected**: yes — see "Infrastructure-deferral findings" below for the A.4 / Thm 3.2 ambiguity.
- **Phantom prerequisites**: `HilbertScheme`, `QuotScheme`, `GroupScheme.IdentityComponent`, `LocallyConstantPushforward`, `RelativeSpec` (all named as absent by the strategy; no phantom-positive claims).
- **Effort honesty**: reasonable on totals (A.1–A.4 sums to ~33–54 iters, honestly large) but A.4 estimate `~7–11 iters / ~900–1200 LOC` is the weak point. Milne III §6 Albanese UP uses morphism-extension machinery (Thm 3.1/3.2-style), and the same strategy elsewhere flags Lemma 3.3 as needing Auslander–Buchsbaum (absent in Mathlib). If A.4 needs even a smooth-source variant of Thm 3.2, the ~7–11 iter estimate is materially under-counted; if A.4 truly bypasses Thm 3.2 via Picard-functor functoriality alone, the strategy should say so explicitly.
- **Parallelism under-exploited**: yes — the iter-170 CHALLENGE on parallelism is only **partially addressed**. The 4-row split commits to *blueprint-side* parallel decomposition this iter, but the table itself records A.3 "gated on A.2" and A.4 "gated on A.1+A.3". So prover-side parallelism amounts to (A.1 blueprint ∥ A.2 blueprint ∥ A.3 blueprint ∥ A.4 blueprint ∥ genus-0 prover); on the prover side only A.1 can actually fire in parallel with the genus-0 stall, since A.2 is the dominant cost and the rest gate behind it. Honest statement, but it means the "parallel lanes from iter-172" framing oversells what the dependency graph allows.
- **Verdict**: CHALLENGE — the parallelism partial-fix and the A.4/Thm 3.2 ambiguity both require either a STRATEGY.md clarification or an explicit plan.md rebuttal this iter.

### Route: C — Milne §I.3 rigidity completion (genus-0 arm via `𝔾_m`-scaling)

- **Goal-alignment**: PASS — the genus-0 OBJECT is `Spec k` (skeleton 6/7 closed); only the `ℙ¹→A const` content remains.
- **Mathematical soundness**: PASS — the `𝔾_m`-scaling shortcut is correct: `σ_×(0,λ)=0` makes the W-axis restriction constant, Cor 1.5 (proven, axiom-clean) collapses the additive decomposition, and density of `𝔾_m` in `ℙ¹` + separated target closes via `ext_of_isDominant` (present). No Thm 3.2, no `Hom(𝔾_a,A)=0`, no cube — char-general. Foundation is the already-proven Rigidity Lemma.
- **Sunk-cost reasoning detected**: no — the route is justified on merits (char-general, less Mathlib-blocked than the differential route, sidesteps the `Hom(𝔾_a,A)=0` and Lemma 3.3 gaps).
- **Infrastructure-deferral detected**: no — `σ_×` is committed to in-tree chart-glue with concrete LOC budget (~200–270 LOC over ~3–5 iters); `genusZero_curve_iso_P1` is committed to a 4-sub-phase in-tree RR sub-build with concrete LOC budget.
- **Phantom prerequisites**: none flagged (`Scheme.Cover.glueMorphisms`, `pullbackSpecIso`, `Proj.fromOfGlobalSections`, `Algebra.compHom` all called as present; consistent with the strategy's iter-170 mathlib-analogist consult).
- **Effort honesty**: reasonable — the RR-bridge `~12–20 iters / ~1500–2500 LOC` looks correctly sized given that Mathlib has no divisors / Pic / RR at scheme level and the 4 sub-phases are mutually serial (RR.1 → RR.2 → RR.3 → RR.4). If anything, the upper bound (~2500 LOC) may itself be optimistic, but it is in the honest neighborhood.
- **Parallelism under-exploited**: no — the RR.1 parallel-startable note is appropriate; the other three sub-phases are genuinely serial.
- **Verdict**: SOUND

### Route: Off-path fallbacks (c-hybrid / c-cube / b / a)

- **Verdict**: SOUND (kept correctly off the critical path; not pursued).

## Format compliance

- **Size**: 171 lines / 13866 bytes — line budget OK; **byte budget ~14 KB exceeds the ~12 KB cap** (over budget).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material` in order.
- **Per-iter narrative detected**: yes — 16 occurrences of `iter-NNN` references in the file. Representative phrases verbatim:
  - "**Route A (COMMITTED, parallel-decomposed iter-171) — Picard scheme / Albanese via FGA**"
  - "iter-171 commits to splitting A.1 into A.1.a `RelativeSpec` + A.1.b ..."
  - "the iter-170 `Algebra.compHom` bridge per `analogies/tensoraway-instance.md`"
  - "Cor 1.5 (additivity) + Cor 1.2 (AV maps are homs) — DONE axiom-clean iter-162"
  - "G0BO refactor deferred to iter-172 (avoid contention with the active body-first test)"
  - "rather than the previous 'serialise behind genus-0 stack' stance which the strategy-critic iter-170 challenged"

  This is a MATERIAL violation: per-iter narrative belongs in `iter/iter-NNN/plan.md`, never in STRATEGY.md. The file reads as the iter-171 planner's diary rather than a stable strategic document.
- **Accumulation detected**: yes — three accumulation patterns:
  1. The "Off-path fallbacks (kept in tree, NOT pursued)" sub-section in `## Routes` is a "Considered alternatives" appendix that the format rules explicitly forbid in STRATEGY.md (belongs in iter sidecars).
  2. `## Mathlib gaps & new material` lists completed-and-axiom-clean assets (`Cotangent/ChartAlgebra.lean — CLOSED, axiom-clean`, `Cotangent/GrpObj.lean — Design template`, Rigidity Lemma "DONE, axiom-clean", Cor 1.5/1.2 "DONE axiom-clean iter-162"). Completed phases should be archived; the file must shrink toward "complete", not document past wins.
  3. The trailing "Soundness rules (operational)" paragraph at the bottom of `## Mathlib gaps & new material` is a quasi-appendix that does not belong in any of the five canonical sections; it should live in a CLAUDE.md or a prompt, not in STRATEGY.md.
- **Table discipline**: PASS — six-column table is intact, single-line cells (though dense). Caveat: `~0/it` velocity rows (A.1–A.4, genus-0 RR bridge) are flagged by the audit rule "rows reading `~0/it` that are still claimed as actively progressing". Here the strategy meaningfully scopes "progress" to blueprint-side (LOC velocity tracks Lean code, not blueprint code), which is internally consistent — note rather than flag.
- **Appendix sections**: "Off-path fallbacks (kept in tree, NOT pursued)", "Soundness rules (operational)".
- **Format verdict**: NON-COMPLIANT (per-iter narrative is pervasive + accumulation + byte budget exceeded + two appendix sections; any one would be DRIFTED, the combination is NON-COMPLIANT).

## Infrastructure-deferral findings

### Deferred: A.4 Albanese UP — implicit Thm 3.2 / morphism-extension dependency

- **Required by goal**: yes — A.4 is the Albanese UP of `Pic⁰` and is on the critical path for the positive-genus protected witness `isAlbaneseFor`.
- **Current plan for building it**: A.4 row claims "reuses in-tree Rigidity Lemma + Cor 1.2/1.5; no new Mathlib namespace", but `## Mathlib gaps & new material` simultaneously says "Rational-map extension to an AV (Thm 3.1/3.2) — now a **Route-A-only** item (Albanese UP), OFF the genus-0 path. Codim-1 half buildable via Mathlib `ValuativeCriterion`/`RationalMap`/`SpreadingOut`; emptiness half (Lemma 3.3) needs Auslander–Buchsbaum (absent) — re-examine the complete-source escape before scheduling." The "re-examine ... before scheduling" is an explicit deferral, and it is co-located with the precise Mathlib gap (Auslander–Buchsbaum) that the strategy elsewhere flags as fatal.
- **Timeline**: absent — "re-examine before scheduling" carries no iter estimate. Meanwhile the A.4 row's `~7–11 iters` estimate implicitly assumes the Thm 3.2 question is resolved.
- **Verdict**: CHALLENGE — the planner must either (i) prove that A.4 truly factors through Picard-functor functoriality with NO need for Thm 3.2 / Lemma 3.3 (and document the chain explicitly in `Jacobian.tex`), or (ii) acknowledge that A.4 includes a Thm 3.2 sub-build and update both the iter and LOC estimates upward, including a concrete plan for the Auslander–Buchsbaum gap.

## Sunk-cost flags

(None — the strategy does not lean on past investment to justify current routes.)

## Must-fix-this-iter

- Route A: CHALLENGE — clarify A.4's actual dependency on Thm 3.2 / morphism-extension; either prove the no-dependency claim in the blueprint or re-estimate A.4 and produce a concrete plan for the Auslander–Buchsbaum gap.
- Route A: CHALLENGE (parallelism under-exploited, still partially live) — the 4-row split addresses the iter-170 challenge at the *blueprint* level but the dependency graph (A.3 gated on A.2; A.4 gated on A.1+A.3) means prover-side parallelism is essentially `A.1 ∥ A.2-blueprint ∥ A.3-blueprint ∥ A.4-blueprint ∥ genus-0-prover`. Either accept this (and adjust the framing — the gates are real, not avoidance) or surface a sub-decomposition of A.2 that actually opens parallel A.2 prover lanes, since A.2 is the dominant cost.
- Infrastructure-deferral CHALLENGE: A.4 Albanese UP — Thm 3.2 / Auslander–Buchsbaum dependency required by the protected goal `isAlbaneseFor` (positive-genus arm) has no concrete timeline. Planner must produce a concrete plan with iter estimate this iter, OR document in the blueprint why Picard-functor functoriality lets A.4 bypass Thm 3.2 cleanly.
- Format: NON-COMPLIANT — restructure STRATEGY.md in-place this iter. Three most impactful deviations:
  1. Strip 16 occurrences of `iter-NNN` per-iter narrative; the document must read stably across iters.
  2. Delete the "Off-path fallbacks (kept in tree, NOT pursued)" and "Soundness rules (operational)" appendix sections (move to iter sidecars / CLAUDE.md respectively).
  3. Prune `## Mathlib gaps & new material` of completed-and-axiom-clean assets (`Cotangent/ChartAlgebra.lean`, `Cotangent/GrpObj.lean`, the "DONE" line items); the file must shrink toward "complete". Aim for the ~12 KB cap.

## Overall verdict

The 4-row Route A split is a real strategic improvement on the iter-170 "parallelism under-exploited" CHALLENGE, but it addresses the challenge only at the blueprint-decomposition layer — the prover-side dependency graph (A.3→A.2→A.1, A.4→A.1+A.3) still serialises the dominant cost, so the iter-170 challenge is **partially live**. The RR-bridge in-tree sub-build COMMITTED iter-171 is a SOUND mathematical decision: the project's zero-sorry kernel-clean target forbids reliance on hypothetical Mathlib upstream, and Hartshorne's RR.1–RR.4 chain is the right minimal in-tree work. The AVR split is appropriate 1-iter housekeeping, not scope-creep. The strategy defers Thm 3.2 / Auslander–Buchsbaum, which is required for the stated goal's positive-genus arm (Albanese UP) on the A.4 row — this is an infrastructure-deferral CHALLENGE the planner must address this iter, by either documenting that A.4 truly bypasses Thm 3.2 via Picard-functor functoriality or by re-estimating A.4 upward with a concrete Auslander–Buchsbaum plan. Format is NON-COMPLIANT (16 iter-NNN references, two appendix sections, accumulation of completed assets, byte budget exceeded) and requires in-place restructure this iter.
