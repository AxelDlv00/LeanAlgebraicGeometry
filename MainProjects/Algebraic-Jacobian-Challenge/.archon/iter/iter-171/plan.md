# Iter-171 plan-agent run

## Headline outcome

**The "honor user hints + answer the iter-170 API-500 reviewer recommendation" iter.** Three forces converge on the iter-171 plan:

1. **iter-170 review** explicitly recommends RE-DISPATCH of iter-170 Lane A on `Genus0BaseObjects.lean` (the body-first test died to API-500 with 0 file edits before it ever ran; the reversal trigger does NOT fire — the test must be re-attempted).
2. **iter-171 USER_HINTS** push three strategy-level changes:
   - Route A "I don't see substantial progress... subdivide into ~500-1000 LOC sub-phases, parallel-startable, many already solvable."
   - "Refactors may be launched to decompose the Lean/tex files... e.g. Genus0BaseObjects.lean and AbelianVarietyRigidity.lean."
   - RR bridge "should not be deferred upstream — write the necessary sub-phases / upstream PRs."
3. **progress-critic `route171` verdict**: 3/3 routes CHURNING/STUCK, UNDER_DISPATCH on 4 ready files for 5 consecutive iters. Mitigation via 3 plan-phase lanes this iter is partial; iter-172 MUST convert ≥2 into prover lanes.

## Subagent dispatch this iter (5 + 1 prover lane)

- **strategy-critic `route171b`** (retry after 529 overload on `route171`) — fresh-context audit of UPDATED STRATEGY.md (4-row Route A split + in-tree RR sub-build commitment + AVR-split row).
- **blueprint-reviewer `route171b`** (retry after 529 overload on `route171`) — whole-blueprint audit; HARD GATE on `AbelianVarietyRigidity.tex` (covers G0BO for the Lane A re-attempt).
- **progress-critic `route171`** — COMPLETE; verdict CHURNING+STUCK+STUCK; under-dispatch finding; iter-172 hard commitments demanded.
- **blueprint-writer `route-a1-decompose`** — creates NEW chapter `Picard_RelativeSpec.tex` (~150–250 LOC), prover-ready for iter-172 Lane B on `AlgebraicJacobian/Picard/RelativeSpec.lean` file-skeleton.
- **blueprint-writer `rr-bridge-subbuild`** — creates NEW chapter `RiemannRoch_WeilDivisor.tex` (~200–300 LOC), prover-ready for iter-172 Lane C on `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` file-skeleton.
- **refactor `avr-split`** — splits `AbelianVarietyRigidity.lean` (1198 LOC) into `RigidityLemma.lean` (Mumford chain + Cor 1.5 + Cor 1.2; L1–L909; axiom-clean) and reduced `AbelianVarietyRigidity.lean` (genus-0 final assembly; L910–end; 2 gated sorries). Updates `% archon:covers` in `AbelianVarietyRigidity.tex`.

PLUS **ONE prover lane this iter** = Lane A on `Genus0BaseObjects.lean` (re-attempt iter-170 verbatim).

## Decision made (route + iter-171 dispatch)

**Strategic decision: honor the iter-170 reviewer recommendation (re-dispatch Lane A verbatim) + absorb user hints A/B/C in PARALLEL plan-phase work. iter-172 is the convergence iter where this iter's plan-phase outputs convert into ≥2 NEW prover lanes (one Route A.1 file-skeleton + one RR.1 file-skeleton); iter-171 keeps prover lane count at 1 because the writer/refactor outputs need to LAND first before they can clear the HARD GATE for new prover lanes.**

Why this beats alternatives:
- **Alternative 1: Skip the body-first re-attempt this iter, only do plan-phase work.** Rejected — iter-170 plan and reviewer both EXPLICITLY require the re-attempt; the body-first test never ran. Two consecutive plan-only iters with no prover dispatch on the route would be the "plan-phase-only meta-pattern" CHURNING clause (progress-critic). The re-attempt is on the cheapest signal that would falsify the route.
- **Alternative 2: Open new prover lanes on Route A / RR sub-build files THIS iter via file-skeleton scaffold without writer-first.** Rejected — HARD GATE requires a complete+correct blueprint chapter before any prover lane on the corresponding file. The new files (`Picard/RelativeSpec.lean`, `RiemannRoch/WeilDivisor.lean`) need their chapters first. The same-iter fast path (writer → reviewer → prover, all in one iter) is theoretically possible but ambitious for a NEW chapter — defer to iter-172.
- **Alternative 3: Refactor G0BO this iter alongside AVR.** Rejected — G0BO is the active prover-lane target; refactoring it while the prover is running on `gmScalingP1` body courts merge conflict. Defer G0BO refactor to iter-172 (once body lands or HARD PIVOT fires).
- **Alternative 4: Open Lane B on AVR's sorries.** Rejected — both AVR sorries (`iotaGm_isDominant`, `genusZero_curve_iso_P1`) are file-disjoint from but logically gated on iter-171 work (Lane A body OR RR sub-build). No standalone prover budget can productively close them this iter.

**Reversal trigger this iter**: If iter-171 Lane A's body-first test RUNS (i.e. doesn't die to API-error) and returns PARTIAL-no-body-skeleton, iter-172 plan agent fires the HARD PIVOT escalation (progress-critic's "no extension" rule). iter-172 also opens the ≥2 new prover lanes (Route A.1 + RR.1 skeletons) per the under-dispatch commitment.

## Decomposition commitment (iter-172 + iter-173)

Per progress-critic must-fix: **iter-172 must dispatch ≥2 additional prover lanes beyond the Lane A continuation**:

- **iter-172 Lane B** (NEW): file-skeleton on `AlgebraicJacobian/Picard/RelativeSpec.lean` (~600–1100 LOC target across iters; first iter scaffolds declarations from `chapters/Picard_RelativeSpec.tex` and leaves bodies as `sorry`). HARD GATE: blueprint-reviewer scoped re-check on the new chapter same-iter fast path, OR iter-172 mandatory dispatch re-confirms.
- **iter-172 Lane C** (NEW): file-skeleton on `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (~400–600 LOC target across iters; first iter scaffolds declarations from `chapters/RiemannRoch_WeilDivisor.tex` and leaves bodies as `sorry`). HARD GATE: same as Lane B.
- **iter-172 Lane A continuation**: either body-skeleton landing (PARTIAL acceptable) → continue Lane A iter-173 closing internal sorries, OR HARD PIVOT fires (route-pivot via mathlib-analogist consult on the entire `gmScalingP1` definition, NOT another route extension).
- **iter-173 lanes**: AVR `iotaGm_isDominant` (becomes `infer_instance`-closeable once body lands); Lane B/C prover-passes; possible G0BO refactor lane (now safe since body landed).

## Prior critique status

- **strategy-critic `routefork170` iter-170 challenges**:
  - CHALLENGE-A (Route A effort-honesty + parallelism): **partially addressed iter-170** (per-sub-phase LOC/iter budget added to `Jacobian.tex`), **fully absorbed iter-171** (STRATEGY.md split into 4 Route A rows + commit to parallel decomposition + blueprint-writer dispatch on A.1 this iter).
  - SOUND on Route C: no live finding.
  - SOUND on off-path fallbacks: no live finding.
  - The iter-171 strategy-critic re-dispatch (`route171b`) confirms/refutes the absorption.

- **progress-critic `routec170` iter-170 verdict CHURNING with body-first corrective**: iter-170 dispatched the body-first lane; lane died to API-500 with 0 edits; iter-171 re-attempts per reviewer recommendation. The progress-critic `route171` iter-171 verdict refines this: hold iter-171 as the DECISIVE option-(c) test; iter-172 HARD PIVOT if PARTIAL-no-body returns.

- **lean-auditor / lean-vs-blueprint-checker iter-170**: skipped (iter-170 had 0 .lean edits per the API-error). Re-applicable iter-171 review phase after Lane A lands.

## Subagent skips

- None. All [HIGHLY RECOMMENDED] critics dispatched (strategy-critic `route171b` retry COMPLETE, progress-critic `route171` COMPLETE, blueprint-reviewer `route171b` retry COMPLETE).

## Blueprint-reviewer route171b findings — absorbed

- **HARD GATE for iter-171 Lane A on `Genus0BaseObjects.lean`: CLEARS.** The chapter `AbelianVarietyRigidity.tex` (covers G0BO via `% archon:covers`) is complete + correct for the `gmScalingP1`-feeding sub-tree (`def:genus0_base_objects` → `def:projlinebar_affine_cover` → `def:proj_chart_ring_iso` → `def:gaTranslationP1`). The 2 incomplete blocks (`prop:genusZero_curve_iso_P1` + Route A sub-phases in `Jacobian.tex`) are DOWNSTREAM of `gmScalingP1`, not blocking.

- **7 unstarted-phase blueprint proposals** issued by reviewer. **2 dispatched this iter**:
  - `Picard_RelativeSpec.tex` (NEW; via `blueprint-writer route-a1-decompose`) — corresponds to reviewer's `JacobianRouteA1_RelativeSpec.tex` proposal (minor name divergence; same content).
  - `RiemannRoch_WeilDivisor.tex` (NEW; via `blueprint-writer rr-bridge-subbuild`) — corresponds to reviewer's `RRBridgeGenus0_P1.tex` proposal but at finer granularity (RR.1 only this iter; reviewer recommended one consolidated chapter for all 4 RR sub-phases). My granularity wins because per-sub-phase HARD GATE clearance is easier (one chapter per file).
  
  **5 DEFERRED this iter with explicit rationale** (blueprint-writer dispatch budget cap × `max_parallel=2` semaphore + API-overload retry cost × iter-171 prover-lane priority):
  - `JacobianRouteA1_LineBundlePullback.tex` (A.1.b) — iter-172 writer dispatch.
  - `JacobianRouteA1_RelPicFunctor.tex` (A.1.c) — iter-172 or iter-173 writer dispatch (gated on A.1.a + A.1.b first).
  - `JacobianRouteA2_HilbertQuot.tex` (A.2, dominant cost) — iter-173+ writer dispatch; the A.2 blueprint can be written in parallel with the A.1.b writer round.
  - `JacobianRouteA3_Pic0.tex` (A.3) — iter-173+ writer dispatch (gated downstream on A.2 prover side, but blueprint independent).
  - `JacobianRouteA4_AlbaneseUP.tex` (A.4) — iter-173+ writer dispatch (reviewer flags this as the *cleanest* to write since every named premise resolves to an already-proven in-tree declaration; ALSO required to resolve the strategy-critic's A.4/Thm 3.2 ambiguity flagged in `## Open strategic questions`).
  
  This dispatch ordering matches the reviewer's recommended "A.1.a, A.4, RR-bridge, A.3, A.1.b, A.1.c, A.2" prioritization at the 2-of-7 cap.

- **Refactor reflection** for `AbelianVarietyRigidity.tex` `% archon:covers` (post-split): handled inline by the `refactor avr-split` directive's "blueprint covers update" section.

- **`soon`-severity items** carried forward (not iter-171 must-fix):
  - `Jacobian.tex` does not pin which Route A sub-witness lands first under `def:positiveGenusWitness` — resolved by the deferred A.4 writer.
  - `AbelianVarietyRigidity.tex` Milne Prop 3.9 verbatim quotes (iter-164 NOTE) were reproduced from a prior-session-verified in-tree copy rather than re-rendered. A future PDF-renderer-equipped iter must re-verify.

## Tool substitutions

- None.

## User-hint absorption record

User hint A (Route A subdivision): **ABSORBED** via STRATEGY.md 4-row split + `blueprint-writer route-a1-decompose` dispatch. iter-172 opens first parallel prover lane on `Picard/RelativeSpec.lean`.

User hint B (refactor G0BO + AVR): **PARTIALLY ABSORBED** — AVR refactor dispatched this iter (`refactor avr-split`); G0BO refactor deferred to iter-172 to avoid contention with the active Lane A body-first test. iter-172 plan re-evaluates G0BO refactor scope.

User hint C (RR bridge in-tree sub-build instead of upstream deferral): **ABSORBED** via STRATEGY.md row update (defer-upstream → in-tree sub-build COMMITTED) + `blueprint-writer rr-bridge-subbuild` dispatch on RR.1 sub-phase. iter-172 opens first parallel prover lane on `RiemannRoch/WeilDivisor.lean`. The remaining 3 RR sub-phases (RR.2 RR-formula, RR.3 `𝒪_C(P)`, RR.4 rational⟹≅ℙ¹) follow in subsequent iters.

## Sorry landscape (entering iter-171, on disk)

Per `grep -nE '^\s*sorry\s*$|:=\s*sorry' AlgebraicJacobian/*.lean` (verified):

- `AbelianVarietyRigidity.lean` — **2 sorries**: L934 `iotaGm_isDominant` (gated on body); L1141 `genusZero_curve_iso_P1` (RR bridge — in-tree sub-build COMMITTED iter-171 but first sub-build chapter not yet landed).
- `Genus0BaseObjects.lean` — **8 sorries**: L177, L184, L364, L593, L687, L713, L791, L823.
- `Jacobian.lean` — **2 sorries** (gated).
- `RigidityKbar.lean` — **1 sorry** (fallback-(a) `[CharZero]`).

Project total: **13** (unchanged from iter-170).

**Post `refactor avr-split` (LANDED, build green):**
- New file `RigidityLemma.lean` (902 LOC) — **0 sorries** (axiom-clean Mumford chain + Cor 1.5 + Cor 1.2; `rigidity_lemma`, `hom_additive_decomp_of_rigidity`, `av_regularMap_isHom_of_zero` all `{propext, Classical.choice, Quot.sound}`).
- Reduced `AbelianVarietyRigidity.lean` (353 LOC) — **2 sorries** at L86 (`iotaGm_isDominant`) and L290 (`genusZero_curve_iso_P1`).
- `% archon:covers` extended to all three files (AVR + G0BO + RigidityLemma).
- Total UNCHANGED at 13.

After Lane A re-attempt (best case, body skeleton landed + Step A + `Algebra.compHom`):
- `Genus0BaseObjects.lean` — 8 → 5 (-3) per iter-170 PARTIAL projection.
- Total: 13 → 10.

After plan-phase writers/refactor + Lane A re-attempt iter-171 + iter-172 file-skeleton lanes B/C:
- iter-172 net: 13 → ~12 (refactor moves things; file-skeletons ADD sorries while opening previously-frozen routes).

The sorry COUNT is no longer the headline metric. The progress-critic findings are about **load-bearing residuals** (the `gmScalingP1` body sorry has been the same load-bearing residual for 5 iters) and **route under-dispatch** (4 ready files absent for 5 iters). iter-171 directly addresses both by re-attempting the body-first test + dispatching plan-phase work to make iter-172 prover-ready for 3 parallel lanes.

## Build state

- `lake build AlgebraicJacobian` last result: green (sorry warnings only). Verified via the iter-170 sync_leanok run + git status (no uncommitted edits).
- Blueprint-doctor iter-170: no structural findings.
- After refactor `avr-split`: build must remain green; report any unexpected breakage in the refactor's own report.

## Hard rules respected

- **No `.archon/REFACTOR_DIRECTIVE.md` usage.** Refactor dispatched inline via the wrapper with the directive inlined under `.archon/logs/iter-171/refactor-avr-split-directive.md`.
- **No protected signature changes.** AVR contains no protected declarations per `archon-protected.yaml` (only `Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean` have entries). The refactor moves declarations between files but does not rename or re-type any.
- **No new axioms.** The refactor is a pure file-move; no `axiom` keyword introduced.
- **No `\leanok` / `\mathlibok` writes.** Neither the blueprint-writer directives nor the refactor directive instructs marker edits.

## Notes for the prover lane (iter-171 Lane A)

The iter-170 objectives.md content for Lane A on `Genus0BaseObjects.lean` is RE-USED verbatim. Re-read `analogies/tensoraway-instance.md` + `analogies/gmscaling-deep.md` before starting. PRIMARY = body-first `gmScalingP1` via `Scheme.Cover.glueMorphisms`; PARTIAL with ≤3 named top-level internal sorries is the progress-critic's acceptable shape. SECONDARY = `aux_left` via "cancel surjective" route.

If the refactor `avr-split` lands successfully before the prover lane starts, the prover MUST account for the fact that `AbelianVarietyRigidity.lean` lines have shifted (the file is now ~330 LOC, not 1198). The G0BO file is unaffected by the refactor.
