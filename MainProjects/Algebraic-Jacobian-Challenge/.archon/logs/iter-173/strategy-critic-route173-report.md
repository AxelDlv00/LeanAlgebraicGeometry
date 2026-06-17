# Strategy Critic Report

## Slug
route173

## Iteration
173

## Routes audited

### Route: A.1.a — RelativeSpec

- **Goal-alignment**: PASS — qcoh-algebras → schemes is a prerequisite of `Pic_{C/k}` and so of the protected `Jacobian` for positive-genus `C`.
- **Mathematical soundness**: PASS — standard Stacks 01LL/01LO/01LS material.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — gap is named, with concrete LOC + iter budget and a writer attempt in flight.
- **Phantom prerequisites**: none. `RelativeSpec` is correctly named as absent.
- **Effort honesty**: reasonable — 200–400 LOC across 3–5 iters ≈ 40–133 LOC/it consistent with realized velocity on comparable AG infrastructure.
- **Parallelism under-exploited**: no — explicitly tagged parallel-startable.
- **Verdict**: SOUND

### Route: A.1.b — LineBundle.Pullback

- **Verdict**: SOUND — gated on A.1.a; estimates internally consistent; ingredient list (base-change + sheafification) is honest.

### Route: A.1.c — RelPic functor

- **Verdict**: SOUND — narrow assembly row gated on A.1.b; budget defensible.

### Route: A.2.a — Flattening stratification

- **Goal-alignment**: PASS — Stacks 052H is the load-bearing engine for Quot.
- **Mathematical soundness**: PASS — Mumford / Stacks `052H` is standard.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no with caveat — the chapter is "NOT YET WRITTEN" and the row is labelled parallel-startable with `~0/it`. This is the largest unscoped item in `## Mathlib gaps`. As long as the blueprint chapter is scheduled this iter or next, the parallel-startable label is honest; if it slips a third iter without a writer attempt, it tips into deferral.
- **Phantom prerequisites**: none; `Stacks 052H` correctly flagged as absent.
- **Effort honesty**: reasonable — 600–900 LOC over 5–8 iters ≈ 75–180 LOC/it, plausible for a flattening-stratification API built from scratch.
- **Parallelism under-exploited**: borderline — labelled parallel-startable but no prover lane active. Acceptable if gating on chapter writing, but should be tracked.
- **Verdict**: SOUND

### Route: A.2.b — Quot scheme representability

- **Verdict**: SOUND — biggest single FGA piece, budget 6–10 iters at 800–1000 LOC is honest given Nitsure §5 scope; no Mathlib `QuotScheme` confirmed.

### Route: A.2.c — `Pic_{C/k}` assembly

- **Verdict**: SOUND — small wiring row; budget plausible.

### Route: A.3 — `Pic⁰` + degree map

- **Verdict**: SOUND — `GroupScheme.IdentityComponent` and `LocallyConstantPushforward` correctly flagged absent; 5–8 iters / 600–900 LOC defensible.

### Route: A.4 — Albanese UP of `Pic⁰`

- **Goal-alignment**: PASS — Albanese UP is the headline `isAlbaneseFor` content.
- **Mathematical soundness**: PASS — Milne III §6 Prop 6.1 + Thm 3.2 + Lemma 3.3 is the standard chain.
- **Sunk-cost reasoning detected**: no — the iter-172 audit explicitly reversed the "bypass" hope on merits (Prop 6.1 invokes Thm 3.2).
- **Infrastructure-deferral detected**: no, but borderline — Auslander–Buchsbaum is an absent Mathlib piece and the row is one undifferentiated lump.
- **Phantom prerequisites**: none claimed as present.
- **Effort honesty**: **under-counted** — `~22–35 iters · 2500+ LOC` works out to `~70–115 LOC/it` for material substantially harder than any phase in A.1 / A.2. The `2500+` cap is open-ended (the `+` admits the estimate is upper-bound-free), and the row is the only Route-A phase NOT further decomposed into sub-phases despite being described as "the dominant Route A risk; project-fatal if Lemma 3.3 stalls". A.1 was split into a/b/c; A.2 was split into a/b/c — A.4 should be split into A.4.a (Lemma 3.3 codim-1 + Weil-divisor API), A.4.b (Auslander–Buchsbaum import), A.4.c (Thm 3.2 assembly), A.4.d (Albanese UP wiring). Without decomposition the row is the "huge phase reluctant to start" pattern named in the critic rubric §7.
- **Parallelism under-exploited**: yes — Lemma 3.3 Weil-divisor material is parallel-startable with RR.1 (the strategy itself flags this in `## Open strategic questions`), but the row is treated as a single gated block.
- **Verdict**: CHALLENGE — decompose A.4 into 3–4 sub-phases with their own LOC/iter rows and cap the LOC estimate (no open-ended `+`), so the project's largest single risk is scoped before it starts blocking critical path.

### Route: genus-0 rigidity (`gmScalingP1`)

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PASS — the 𝔾_m-scaling shortcut via Cor 1.5 with `V=ℙ¹, W=𝔾_m, base points 0,1` correctly collapses to `f(λx)=f(x)`, and density of `𝔾_m ⊂ ℙ¹` + separatedness of `A` gives constancy. Spot-checked the corollary application: with `0` a scaling fixed point, the `W`-axis restriction `h(0,λ) = f(λ·0) = f(0)` is constant, so the additive Cor-1.5 decomposition `h(x,λ) = h(x,1) + h(0,λ) - h(0,1)` reduces to `h(x,λ) = f(x)`.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no.
- **Phantom prerequisites**: `Scheme.OpenCover.glueMorphismsOfLocallyDirected` VERIFIED in `Mathlib.AlgebraicGeometry.Cover.Directed`; `Scheme.Cover.glueMorphisms` VERIFIED in `Mathlib.AlgebraicGeometry.Gluing`; `pullbackSpecIso` VERIFIED in `Mathlib.AlgebraicGeometry.Pullbacks`.
- **Effort honesty**: **under-counted at the row level, but only mildly** — the `LOC (remaining · realized/it)` cell reads `~150–220 · ~80/it`. Naïve arithmetic gives `220 ÷ 80 ≈ 2.75 iters`, contradicting the `~4–7 iters left` claim. Either remaining LOC is larger than stated, or realized velocity is going to fall sharply on the harder cocycle / over-coherence sorries, or the iter estimate is padded. The row Status string still names "3 named scaffold sorries + 1 surjective helper", but per the directive the surjective helper closed iter-172 (PRIMARY 1 axiom-clean) — so the Status text is stale and should be `3 named scaffold sorries` only. Refreshing both signals shifts the realistic estimate to **~3–6 iters / 100–170 LOC remaining**, and the `~4–7` upper bound becomes defensible only if cocycle/over-coherence are genuinely much harder than the surjective helper was. The row should be updated post-PRIMARY-1.
- **Parallelism under-exploited**: no.
- **Verdict**: CHALLENGE — refresh the Status cell to drop the now-closed surjective helper, and reconcile the LOC × velocity × iter triple so they're arithmetically consistent. Recommend `Iters left ~3–6`.

### Route: RR.1 — Weil divisors

- **Verdict**: SOUND — chapter landed; file-skeleton lane open; honest about closed-point-order / divisor-degree gaps.

### Route: RR.2 / RR.3 / RR.4

- **Verdict**: SOUND — chain of three small ≤500-LOC rows, each gated linearly. Budget 3–5 iters each is defensible for sequential RR material.

### Route: `genusZeroWitness` body + `k̄→k` descent

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PARTIAL — the strategy itself flags "descent direction unconfirmed" under `## Open strategic questions`. The `Pic⁰`-over-`k` branch avoids descent but pulls more Route-A machinery into the genus-0 case; the `C_{k̄}≅ℙ¹` branch needs faithfully-flat descent of a morphism equality. The 3–5 iter estimate covers either, but commits to neither.
- **Verdict**: SOUND with watch — the open question is acknowledged; planner should pick the branch before this row's first prover lane opens.

### Route: `nonempty_jacobianWitness` body

- **Verdict**: SOUND — trivial `by_cases` row, correctly scoped.

### Route: Refactor — `Genus0BaseObjects.lean` split

- **Verdict**: SOUND — housekeeping, low risk, scheduled.

### Route: Refactor — `StructureSheafModuleK.lean` split

- **Verdict**: SOUND — housekeeping, deferred without blocking; user-hint A.

## Format compliance

- **Size**: 94 lines / 14.0 KB — within line budget; KB slightly over the 12 KB soft cap (a few long status cells are the cause).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order.
- **Per-iter narrative detected**: yes — pervasive. Representative quotes: `"3rd writer attempt iter-172"` (L22), `"body skeleton LANDED iter-171"` (L30), `"re-estimated iter-172 per progress-critic OVER_BUDGET (7 elapsed vs prior ~3-5)"` (L30), `"chapter `RiemannRoch_WeilDivisor.tex` landed iter-171 (445 LOC, 9 pins); file-skeleton lane iter-172"` (L31), `"gated on iter-172 Lane A sorry residual stabilising"` (L37), `"RESOLVED iter-172: audit Outcome (b)"` (L65), `"Schedule a blueprint cross-reference audit iter-173"` (L65), `"(split iter-171)"` (L90). At least 12 distinct `iter-NNN` references across phase status cells, the Routes prose, and the Open-questions block.
- **Accumulation detected**: minor — `"New project material introduced (in tree, current as of restructure):"` (L88) heads a 5-item file list. The list is informational, not historical, but the `(current as of restructure)` parenthetical is per-iter-narrative-flavoured.
- **Table discipline**: PASS structurally — columns are correct; one-line-per-cell discipline is the violation, since several Status cells span 4–6 clauses (e.g. A.4 row, L29). Re-classifying these from "table discipline FAIL" to "per-iter narrative FAIL" because the bloat is largely iter-history attached to the status string.
- **Appendix sections**: none.
- **Format verdict**: DRIFTED — heading skeleton and table columns are canonical, but per-iter narrative is pervasive enough to make the document age out of its own canonical form. Treat the next iter's restructure as obligatory cleanup, not optional cosmetics.

## Alternative routes (suggested)

### Alternative: Decompose A.4 in the same way A.1 and A.2 are decomposed

- **What it looks like**: split A.4 into A.4.a (Weil-divisor + codim-1 indeterminacy locus + Lemma 3.3), A.4.b (Auslander–Buchsbaum import — depth/projective-dim machinery in Mathlib `RingTheory.Depth`), A.4.c (Thm 3.2 rational-map-extension assembly), A.4.d (Albanese UP wiring on top of A.3 + A.4.c). Give each its own row in the phases table with bounded LOC + iter estimates.
- **Why it might be cheaper or sounder**: the project's stated "dominant Route A risk; project-fatal if Lemma 3.3 stalls" language is exactly the signal that a single undifferentiated 22–35-iter row is hiding a structural risk. Decomposition forces the planner to face each sub-risk on its own LOC + iter estimate, surfaces parallelism (A.4.a shares Weil-divisor material with RR.1; A.4.b is independently startable), and removes the open-ended `2500+` LOC figure that currently caps no upper bound.
- **What the current strategy may have rejected**: the Open-questions block hints the planner is aware of A.4 ↔ RR.1 sharing but is deferring the structural decision. The audit verdict on A.4 (Outcome (b)) was made very recently; the planner may be giving themselves a row-as-placeholder for one iter before splitting.
- **Severity of the omission**: major — A.4 is the largest single phase and the only one not decomposed. The "huge phases reluctant to start" pattern named in the critic rubric is present.

## Sunk-cost flags

(none — the strategy justifies all routes on current-merits, including the iter-172 reversal of the A.4 bypass attempt.)

## Prerequisite verification

- `AlgebraicGeometry.pullbackSpecIso`: VERIFIED in `Mathlib.AlgebraicGeometry.Pullbacks`.
- `AlgebraicGeometry.Scheme.Cover.glueMorphisms`: VERIFIED in `Mathlib.AlgebraicGeometry.Gluing`.
- `AlgebraicGeometry.Scheme.OpenCover.glueMorphismsOfLocallyDirected`: VERIFIED in `Mathlib.AlgebraicGeometry.Cover.Directed`.
- `RelativeSpec` functor (qcoh-algebras → schemes): MISSING — strategy honest.
- `QuotScheme`: MISSING — strategy honest.
- `Stacks 052H` flattening stratification: MISSING — strategy honest.
- `GroupScheme.IdentityComponent`: MISSING — strategy honest.
- `LocallyConstantPushforward`: MISSING — strategy honest.
- `AuslanderBuchsbaum` formula (depth + pd ⇒ codim): MISSING from `Mathlib.RingTheory.Depth` family at the form needed for Lemma 3.3 — strategy honest about absence.

## Must-fix-this-iter

- Route A.4: CHALLENGE — decompose into A.4.a/b/c/d sub-rows mirroring A.1 and A.2; cap the LOC estimate (drop the open-ended `+`); explicitly route A.4.a ↔ RR.1 shared Weil-divisor material via a single source file so the parallel-startable lane is real.
- Route genus-0 rigidity: CHALLENGE — refresh Status to drop the surjective helper (closed iter-172 PRIMARY 1) and reconcile `LOC remaining · realized/it · iters left` so the three figures are arithmetically consistent (recommended shift: `Iters left ~3–6`).
- Alternative "decompose A.4": major omission — addressed by the A.4 CHALLENGE above.
- Format: DRIFTED — restructure STRATEGY.md in-place to evict per-iter narrative from phase Status cells, the `## Open strategic questions` block (line 65 `"RESOLVED iter-172"` / `"Schedule a blueprint cross-reference audit iter-173"`), the `## Mathlib gaps` block (line 88 `"current as of restructure"` and line 90 `"(split iter-171)"`), and the Routes prose. Iter-historical material belongs in `iter/iter-NNN/plan.md`. The two or three most impactful deviations to clean: (i) drop all `iter-NNN` strings from Status cells (rewrite them as plain present-tense scoping: "chapter PENDING; file-skeleton lane gated on landing"); (ii) replace `"RESOLVED iter-172"` in the A.4 Open-question with a current-state restatement of the conclusion; (iii) replace the "current as of restructure" parenthetical with no qualifier (the file is always current).

## Overall verdict

The post-restructure `STRATEGY.md` is structurally healthy — the 12-row per-sub-phase decomposition of Route A makes the dependency graph honest, the `## Routes` prose still makes sense, and the genus-0 + RR rows are sound. Two substantive content findings: (1) Route A.4 is the only Route-A phase not further decomposed, and at `2500+ LOC · ~22–35 iters · ~0/it · "project-fatal if Lemma 3.3 stalls"` it carries every hallmark of the "huge phase reluctant to start" pattern — split it into A.4.a/b/c/d before the row starts blocking critical path; (2) the genus-0 rigidity row's LOC × velocity × iter triple is arithmetically inconsistent (`~150–220 ÷ ~80/it ≠ ~4–7`) and the Status cell hasn't been refreshed for the iter-172 PRIMARY 1 close — recommend `Iters left ~3–6` and drop the surjective helper from the Status string. The A.4 ↔ RR.1 material-sharing question is well-posed but should be sharpened into a concrete proposal (single shared `WeilDivisor` source file, or A.4.a depends on RR.1 file directly). One format finding: the per-iter narrative (`iter-NNN` strings, "RESOLVED iter-172", "current as of restructure", "(split iter-171)") is pervasive enough to drift the document from its canonical form — restructure in place this iter to evict iter-historical material into iter sidecars. No sunk-cost reasoning detected; no phantom Mathlib prerequisites detected; all named gaps verified honest.
