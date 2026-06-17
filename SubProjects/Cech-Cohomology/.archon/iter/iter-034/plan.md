# Iter-034 plan — RE-DISPATCH Route A (lost to a dispatch shortfall) + Route B tilde continuation; P1a decomposed for next iter

## Entering state (verified)
iter-033's two planned lanes processed:
- **Lane B `TildeExactness.lean` (NEW) PARTIAL +3** axiom-clean (`tilde_preservesFiniteColimits`,
  `tilde_toStalk_map_injective`, `tilde_preservesFiniteLimits_of_preservesKernels`); named target
  `tildePreservesFiniteLimits` left ABSENT (no pin). 01I8 Route-P step P3.
- **Lane A `AffineSerreVanishing.lean` DID NOT RUN** — iter-033 review confirmed the prover phase launched
  a SINGLE prover (`provers-combined.jsonl` one `session_start`); the file is byte-unchanged since iter-032.
  This was a dispatch/parallelism shortfall, NOT a math block. The lane was blueprint-gate-cleared iter-033
  and recipe-ready (`analogies/tosheaf-epi.md`).
- Project sorry = 2 (both frozen/superseded: `CechHigherDirectImage:679` frozen P5b, `CechAcyclic` dead
  `affine`). Both prover files 0-sorry. `unmatched` was 4 (3 tilde helpers + dead node).

## What I did this iter (plan phase)
1. Processed both lanes (task_done += TildeExactness +3; task_pending header refreshed; PROGRESS rewritten).
   Cleared the 3-helper coverage debt by bundling `tilde_preservesFiniteColimits`,
   `tilde_toStalk_map_injective`, `tilde_preservesFiniteLimits_of_preservesKernels` into the
   `lem:tilde_preserves_kernels` `\lean{}` list (`unmatched` 4→1; residual = documented dead
   `CechAcyclic.affine`).
2. **progress-critic `iter034`: CONVERGING ×2**, dispatch=OK. Route A's non-run was mechanical → re-dispatch
   correct. Route B genuine COMPLETE×2→PARTIAL trajectory on a fresh file, no recurring blocker. Watchpoint:
   a 2nd TildeExactness PARTIAL on the SAME Ab-stalk blocker at iter-035 triggers re-classification.
3. **blueprint-reviewer `iter034` (whole blueprint): HARD GATE CLEARS** both lanes (6 target blocks complete +
   correct). DAG clean (0 gaps, 1 intentional lean_aux). 2 soon findings (`lem:cech_free_eval_prepend_homotopy`
   + `_spec` missing `\lean`) — but I verified both already carry a `% NOTE:` documenting they are
   intentionally pin-less transport-exposition steps (content realized via `cechEnginePrepend`/`_spec` under
   `lem:cech_engine_complex`); NOT real coverage debt, off both active lanes → no action.
4. **refactor `tilde-import`:** wired `import AlgebraicJacobian.Cohomology.TildeExactness` into the root barrel
   (planner can't edit `.lean`; prover flagged it as action item 1). `lake build` EXIT 0 (8331 jobs). This
   pulls the new file into the loop's project-wide build / sync_leanok so a closed target is recognized.
5. **effort-breaker `p1a` + blueprint-clean `p1a`:** decomposed P1a `lem:isQuasicoherent_restrict_basicOpen`
   into a `\uses`-linked 3-lemma chain — `modules_restrict_basicOpen` (L1 geometry primitive, NO deps;
   scaffolds BOTH the transported sheaf-of-modules AND a comparison iso `modulesRestrictBasicOpenIso`),
   `tilde_restrict_basicOpen` (L2 widetilde-pullback), `presentation_restrict_basicOpen` (L3 presentation
   transport) — top block now a short composition. Citations verbatim against `references/stacks-schemes.tex`
   (L1241–1276, L1287–1303); Lean leakage + project-history NOTEs stripped by clean. This is NEXT iter's P1a
   prover lane (not this iter).
6. **STRATEGY.md** — two clarifying refinements (NOT a route change): 01I8 row now records (a) P1a is a
   3-lemma chain, (b) tilde P3 reduced to ONE build (Ab-stalk mono-transport — the kernel→finite-limit
   reduction is Mathlib-supplied, the earlier "categorical glue" gap was FALSE per lean-auditor). Iters-left
   ~5–8→~5–7, LOC ~500–900→~450–800.
7. Wrote PROGRESS.md (two mathlib-build lanes, scaffold keywords on both path lines), task ledgers, this
   sidecar, objectives.md, TO_USER.md.

## Decisions made

### D1 — This iter's two lanes: RE-DISPATCH Route A (cover-system) + Route B tilde continuation.
**Chosen.** Lane A never ran iter-033 (mechanical shortfall), is gate-cleared and recipe-ready, and is the
high-value convergence lane (cover-system bundle → `affineCoverSystem`). Lane B has a single precise residual
(Ab-stalk mono-transport) with the route fully specified in the iter-033 task result. Both are independent
files, both mathlib-build, both gate-cleared. The progress-critic confirmed re-dispatch is correct and the
2-file proposal is well-formed/within cap. Reversal signal: if EITHER lane PARTIALs on the SAME named blocker
next iter, escalate to a mathlib-analogist consult on that specific idiom (cover-system surjectivity or
Ab-stalk transport) rather than re-dispatching the same recipe.

### D2 — P1a effort-breaker NOW (forward investment), not deferred.
**Chosen.** iter-033's PROGRESS scheduled the P1a effort-breaker for this iter. P1a is load-bearing on the
critical path to the unconditional qcoh result (gates the 02KG top theorem). Decomposing it now (while the two
prover lanes consume idle capacity elsewhere in the chapter) exposes a dispatchable 3-lemma chain so a P1a
prover lane can run in parallel with the tilde lane next iter. The effort-breaker touched ONLY the P1a region;
the two active lanes' blocks stayed byte-stable.

## Subagent skips
- **strategy-critic**: STRATEGY.md changed only by two CLARIFYING refinements that REDUCE scope/risk (P1a
  decomposed into smaller pieces; tilde P3 shown to be ONE build not two — the feared categorical-glue gap was
  false). No route swap, no new route, no circularity introduced, no estimate change >~30%. Prior verdict
  (`iter033`) was SOUND with no live CHALLENGE; the two-front 02KG-vs-01I8 structure is unchanged. A fresh
  strategy critique would re-confirm an unchanged arc. Skipped per the "clarifying refinement only" condition.

## Risks / watchpoints carried to iter-035
- **Dispatch shortfall recurrence.** Lane A was lost to a single-prover launch iter-033. Verify the loop
  fans out BOTH provers this iter (2 files in `## Current Objectives`). If a lane silently no-runs again,
  this is an infra issue to surface in TO_USER, not a math block.
- **TildeExactness 2nd-PARTIAL watch** (progress-critic): if the Ab-stalk mono-transport doesn't close this
  iter, next iter dispatch a mathlib-analogist on the germ-naturality / stalk-as-`IsLocalizedModule.map`
  idiom before re-dispatching the same recipe.
- **P1a `modules_restrict_basicOpen`** bundles two Lean names to scaffold (functor + comparison iso) and L3
  `presentation_restrict_basicOpen` is the heaviest new node (re-break candidate if it stalls) — recorded in
  PROGRESS next-iter plan + the effort-breaker report.
