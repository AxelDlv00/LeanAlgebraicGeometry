# Iter-174 plan-agent run

## Headline outcome

**The "honor user-hints (write all 10 NOT-YET-WRITTEN chapters + launch the two deferred refactors) + execute CHURNING corrective on Route 1" iter.**

User-hint `USER_HINTS.md` from iter-174 has two strong asks:
1. "There are several 'chapter NOT YET WRITTEN' in the strategy — launch writers to fill them in, because having completed the blueprints makes the strategy more robust." → 10 writers dispatched in parallel this plan-phase (Picard_FlatteningStratification, Picard_RelPicFunctor, Picard_QuotScheme, Picard_FGAPicRepresentability, Albanese_CodimOneExtension, Albanese_AuslanderBuchsbaum, Albanese_Thm32RationalMapExtension, Albanese_AlbaneseUP, RiemannRoch_OCofP, RiemannRoch_RationalCurveIso).
2. "Two refactors are deferred, launch them now so this is done." → both StructureSheafModuleK split + WeilDivisor hygiene refactor dispatched this plan-phase. **G0BO split** deferred to iter-175 with rationale recorded in `## Decision made` below (Lane A prover iter-174 needs the file's current state).

## Critic verdicts (this iter)

| Critic | Slug | Verdict |
|---|---|---|
| progress-critic | `route174` | **Route 1 CHURNING; Routes 2/3/4 UNCLEAR.** Corrective: mathlib-analogist consult on chart-bridge specialization in parallel with Lane A this iter. Plus hard scope-discipline on Lane A (close EXACTLY PRIMARY 2 + 3 via shared helper). |
| strategy-critic | `route174` | **CHALLENGE on Route A, SOUND on Route C.** Three LOC bands under-counted: A.2.a (600-900 → 1200-2000), A.2.b (800-1000 → 1500-2500), A.4.a (900-1200 → 1500-2500). Also 2 alternative-route omissions to record (Sym^g, Pic⁰-functor-of-points UP). Format DRIFTED (14% over byte budget). |

**Actions taken this plan-phase**:
- STRATEGY.md amended: A.2.a/A.2.b/A.4.a bands widened per strategy-critic. The 2 alternatives added under `## Open strategic questions`. Format trimmed (Route prose collapsed; deferred-refactor rows removed since both are launching this iter or next iter, so the strategy table is honest about what's live).
- Progress-critic CHURNING corrective: mathlib-analogist `chart-bridge-shared-helper` dispatched in parallel with Lane A. Hard scope-discipline encoded in Lane A directive (PRIMARY 2 + 3 only, no other sorries attacked).

## Plan-phase subagent dispatches

### Critics (parallel batch 1, COMPLETE)
- `progress-critic route174` — CHURNING on Route 1; corrective above.
- `strategy-critic route174` — CHALLENGE; rebuttals above.

### Mathlib-analogists (parallel batch 2, IN FLIGHT at plan time)
- `mathlib-analogist chart-bridge-shared-helper` — Route 1 corrective. Verdict feeds Lane A iter-174.
- `mathlib-analogist qcohalgebra-structure` — Route 2 prep (per progress-critic informational rec "dispatch now so iter-175 can open body lane immediately"). Persists `analogies/qcohalgebra-structure.md`.

### Refactors (parallel batch 3, IN FLIGHT)
- `refactor weildivisor-hygiene` — lean-auditor `iter173` must-fix-this-iter trio (WeilDivisor.lean docstring + redundant `noncomputable` + Genus0BaseObjects `push Not` → `push_neg`).
- `refactor structuresheaf-split` — user-hint user-deferred refactor; splits `Cohomology/StructureSheafModuleK.lean` 877 LOC → 3 sub-files + re-export. No conflict with active prover lanes.

### Writers (parallel batches 4-8, IN FLIGHT)

10 writers, one per NOT YET WRITTEN chapter, dispatched in parallel batches (max_parallel=2 queues them):

- `blueprint-writer a2a-flatteningstrat` → `Picard_FlatteningStratification.tex` (A.2.a — top parallel-startable Route A).
- `blueprint-writer a4a-codim1` → `Albanese_CodimOneExtension.tex` (A.4.a — risk-dominant; shares Weil-divisor with RR.1).
- `blueprint-writer rr3-ocp` → `RiemannRoch_OCofP.tex` (RR.3 — extracts non-constant function via genus-0 RR).
- `blueprint-writer rr4-rational-iso-p1` → `RiemannRoch_RationalCurveIso.tex` (RR.4 — finishes RR bridge ≅ ℙ¹).
- `blueprint-writer a4b-auslander` → `Albanese_AuslanderBuchsbaum.tex` (A.4.b — algebra import).
- `blueprint-writer a1c-relpic` → `Picard_RelPicFunctor.tex` (A.1.c — wires A.1.a + A.1.b).
- `blueprint-writer a2b-quot` → `Picard_QuotScheme.tex` (A.2.b — Quot via Nitsure §5).
- `blueprint-writer a4c-thm32` → `Albanese_Thm32RationalMapExtension.tex` (A.4.c — wires A.4.a + A.4.b).
- `blueprint-writer a4d-albanese` → `Albanese_AlbaneseUP.tex` (A.4.d — Albanese UP wiring).
- `blueprint-writer a2c-fga-pic-assembly` → `Picard_FGAPicRepresentability.tex` (A.2.c — small assembly chapter).

All writers carry `references/**` in their write-domain so they may dispatch a child reference-retriever mid-session.

## Decision made (G0BO refactor scheduling)

User-hint requested both deferred refactors launch THIS iter. I committed to:
- StructureSheafModuleK split — **launched this iter** (no active prover-lane conflict).
- G0BO split — **deferred to iter-175** (one-iter delay).

**Rationale**: the iter-174 Lane A prover targets `gmScalingP1_chart_agreement` (L944) + `gmScalingP1_over_coherence` (L961) in `Genus0BaseObjects.lean`. The G0BO split refactor would move these declarations across 4 sub-files, invalidating both Lane A's line-number references and the progress-critic's CHURNING corrective (which depends on Lane A firing this iter with hard scope-discipline). Running the refactor in plan-phase risks (i) breaking the file mid-iter, (ii) introducing new sorries at the chart-iso seams that Lane A then can't close, (iii) inducing a 4th consecutive PARTIAL on Route 1, which would escalate the route to STUCK at iter-175.

**Reversal trigger**: if iter-174 Lane A closes PRIMARY 2 + 3 axiom-clean, iter-175 plan-phase will fire G0BO split **before** any iter-175 prover lane on the file. If Lane A returns PARTIAL again, iter-175 fires the analogist-recommended structural refactor first (which may subsume the file-split), then G0BO split.

**Iter sidecar trace of user-hint resolution**: 1/2 refactors launched this iter (StructureSheafModuleK). 1/2 deferred (G0BO) with the above explicit reversal trigger.

## Prover lane scope (iter-174)

5 prover lanes total — within max-objectives=10 cap, per progress-critic dispatch-sanity OK.

### Lane A — `AlgebraicJacobian/Genus0BaseObjects.lean` (continuation, CHURNING corrective)

**Hard scope-discipline**: close EXACTLY PRIMARY 2 + 3 via the shared `gmScalingP1_chart_PLB_eq` helper. No other sorries attacked.

**Required reading**: `analogies/chart-bridge-shared-helper.md` (analogist returns this iter).

### Lane D — `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (continuation)

NARROW SCOPE: `ofClosedPoint` body (closed-point ↔ prime-divisor bridge). Per iter-173 review iter-174 recommendation #1.

### Lane E — `AlgebraicJacobian/Picard/LineBundlePullback.lean` (NEW FILE file-skeleton)

5 pins per `Picard_LineBundlePullback.tex` (LANDED iter-173).

### Lane F — `AlgebraicJacobian/RiemannRoch/RRFormula.lean` (NEW FILE file-skeleton)

4 pins per `RiemannRoch_RRFormula.tex` (LANDED iter-173).

### Lane G (OPTIONAL — gated on analogist) — `AlgebraicJacobian/Picard/RelativeSpec.lean` body lane on `QcohAlgebra`

Gated on `mathlib-analogist qcohalgebra-structure` returning a concrete structure recipe in plan-phase. If recipe lands, dispatch Lane G this iter; else defer to iter-175.

## Same-iter blueprint-reviewer fast-path

After writers + refactors land, plan-phase will dispatch `blueprint-reviewer 174-postwriters` SCOPED to the 10 new chapters + the 4 edited chapters (`AbelianVarietyRigidity.tex` post-G0BO carry-over, etc.) to clear HARD GATE for Lanes E + F + G.

If the scoped review returns blocking findings, Lane E or F defers.

## Skipped subagents this iter

(intentionally none under `## Subagent skips`; all 3 highly-recommended critics dispatched: progress-critic, strategy-critic, blueprint-reviewer — the latter via the scoped fast-path after writers, not as a whole-blueprint audit.)

Why no whole-blueprint audit this iter: 10 new chapters land mid-iter; a whole-blueprint audit BEFORE writers return would miss them; AFTER would be redundant with the scoped fast-path. Scoped fast-path on the 14 changed chapters is the right slice this iter.

## Alternative dispatch shapes considered

- **Smaller writer fan-out (3-4 most strategic only)**: rejected; user-hint is firm on "launch writers to fill them in" and the strategic gain of clearing all NOT YET WRITTEN chapters in one iter is large (every subsequent iter has parallel-startable prover lanes for the unblocked routes).
- **G0BO split this iter via prover-phase sequencing**: rejected; max_parallel=2 + plan-phase semaphore would either bottleneck the writers or require dispatching G0BO AFTER prover-phase via a separate dispatch, which the loop doesn't support cleanly. iter-175 with reversal trigger is cleaner.
- **Skip the progress-critic CHURNING corrective**: rejected; progress-critic was emphatic that the chart-bridge specialisation has recurred 2 iters as the bottleneck — an analogist consult is cheap insurance against a 4th consecutive PARTIAL.

## Strategy-modifying findings (post-writer audit)

### A.4.d: Sym^g committed (Route ii); Poincaré-bundle / autoduality route REJECTED

The `blueprint-writer a4d-albanese` report surfaced that the directive's moduli-theoretic proof outline (Poincaré bundle on `A × A^∨` + autoduality `J ≅ J^∨` via canonical principal polarisation) implicitly invokes Milne III.6.6 autoduality, which gates on the theorem of the cube — EXCISED iter-163. Re-introducing the cube on the A.4.d critical path would be a strategy reversal.

**Decision** (recorded `## Open strategic questions` in STRATEGY.md):
- **Commit to Route (ii)**: Sym^g C / symmetric-power Milne 6.1 verbatim proof. Uses only proven `lem:rational_map_to_av_extends` (A.4.c) + Stein factorisation + a new project-side `Sym^g C` sub-build.
- **Reject Route (i)**: autoduality (would reverse iter-163 cube excision).
- **Iter-175 plan-phase**: re-issue the A.4.d writer directive replacing moduli sub-lemmas with Sym^g sub-lemmas (`lem:symmetric_product_av_map`, `lem:symmetric_product_to_jacobian`, `lem:descent_through_birational_sigma`). The current iter-174 chapter is mostly Route-(ii)-compatible (Milne's verbatim proof is already there); the moduli sub-lemmas need to be retired.

### STRATEGY.md amendments (this iter)

- A.4.d row in `## Phases & estimations`: rewritten with Sym^g sub-build cost absorbed (~5–10 iters / ~500–900 LOC).
- `## Open strategic questions`: added the iter-174 A.4.d Route-ii commitment as a recorded decision with rejection rationale for Route (i).
- `## Mathlib gaps & new material`: added Sym^g of schemes as a project-side build, with LOC budget rolled into A.4.d row.

### Other writer notes acted on this iter

- **a2b-quot**: Grassmannian scheme is a sub-prerequisite; chapter recorded it inline. Reported NOT as a separate strategy change since STRATEGY.md L26 already widened A.2.b's band to include the Grassmannian (per strategy-critic). No action needed.
- **a2a-flatteningstrat**: Castelnuovo–Mumford dependency surfaced; not yet on critical path. Recorded internally; revisit if A.2.b prover lane needs CM Mathlib gap-fill.
- **a1c-relpic, a2c-fga-pic-assembly, a4a-codim1, a4b-auslander, a4c-thm32, rr3-ocp, rr4-rational-iso-p1**: all "Strategy-modifying findings = None" — chapters land cleanly against current strategy.

## Iter-175 commitments

1. **G0BO split refactor** (deferred from iter-174 per rationale above). Fires plan-phase iter-175 BEFORE any prover lane on the file.
2. **Lane A iter-175** — pivot decision based on iter-174 Lane A outcome:
   - COMPLETE (PRIMARY 2 + 3 closed): `gmScalingP1_collapse_at_zero` next.
   - PARTIAL-low: iter-175 plan fires the analogist-recommended structural refactor (chart-bridge rebrickeling).
3. **Lane B body lane on `QcohAlgebra`** — fires after `mathlib-analogist qcohalgebra-structure` consult lands and is verified scoped-clean.
4. **File-skeleton lanes** for chapters landed iter-174 — `Picard/FlatteningStratification.lean`, `Picard/QuotScheme.lean`, `Picard/RelPicFunctor.lean`, `Picard/FGAPicRepresentability.lean`, `Albanese/CodimOneExtension.lean`, `Albanese/AuslanderBuchsbaum.lean`, `Albanese/Thm32RationalMapExtension.lean`, `Albanese/AlbaneseUP.lean`, `RiemannRoch/OCofP.lean`, `RiemannRoch/RationalCurveIso.lean`. Prioritise by parallel-startability per STRATEGY.md L53.
5. **Strategy-critic round 2** — re-dispatch if iter-174 widens the LOC bands further or if any writer's "Notes for Plan Agent" surfaces a strategy-modifying finding.
6. **A.4.d writer re-dispatch** (Route ii) — replace moduli sub-lemmas with Sym^g sub-lemmas; absorbs the Sym^g sub-build prerequisite into the chapter's downstream-Lean-file plan.
7. **G0BO refactor** — per the deferral rationale above.
8. **Scoped blueprint-reviewer** on the 10 newly landed iter-174 chapters before opening their file-skeleton lanes (HARD GATE for the new files).
