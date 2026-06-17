# Iter 053 — Plan (Quot-Foundations)

## TL;DR
GF stalk route confirmed DEAD → re-spec'd to source-span descent (STRATEGY + blueprint). 3 prover lanes
after a full blueprint-prep round (2 writers + clean + whole-reviewer + scoped recheck). All 3 mandatory
critics dispatched; gate MET on all three edited chapters.

## Critic verdicts (actioned)
- **strategy-critic `iter053`: SOUND.** GF source-span re-spec validated as a genuine pivot (not avoidance):
  hardest prereq moved from phantom `SheafOfModules.stalk` to the buildable `flat_of_isLocalized_span` +
  B1 brick. FBC keystone + Q1 re-verified. (soft: STRATEGY format at size edge — trim on next add.)
- **progress-critic `iter053`: GF=STUCK, SNAP=CHURNING, GR=UNCLEAR.** Correctives all = blueprint expansion
  (taken). Hard close deadline iter-055 for genericFlatness; GR MUST drop ≥1 sorry this iter; SNAP brick is
  the make-or-break (escalate if not constructible in 1 iter).

## Decision made — GF re-spec + 3 lanes
- **GF:** abandon stalk G3.2; close `genericFlatness` via source-span descent. blueprint-writer `gf-srcspan`
  added B1.0 (`gf_localizedModule_baseChange_tensor_comm`) → B1 (`gf_flat_localizedModule_sameBase`) → B2
  (`gf_section_localization_flat_descent`) → rewritten assembly over `Module.flat_of_isLocalized_span`.
  Lane = mathlib-build the chain bottom-up + CLOSE.
- **GR-quot:** fill `glue` body (overRestrictPullbackIso + existsUnique_gluing') + `functor` (glue-indep).
- **SNAP:** mathlib-build the coequalizer brick `relativeTensor_as_coequalizer` (writer `snap-coeq`) → crux.

## Rebuttal — progress-critic "dispatch all 4 GF sub-lemmas / UNDER_DISPATCH"
Misinformed: G3.1/G3.3/G3.4 already landed axiom-clean iter-052 (0 sorries — un-redispatchable). Only the
dead-stalk G3.2 + assembly remain; the re-spec replaces them with B1.0/B1/B2/assembly. One file = ONE lane,
loaded with the full re-spec'd chain (NOT throttled to B1) — the substance (don't under-dispatch) is honored.

## Coverage debt CLEARED
3 GR bridges (`lem:gr_glueData_bridges`, self-written) + 3 SNAP reductions (writer) blueprinted. `opensTopology`
stays private (impl detail).

## Gate (HARD GATE — fast path)
Whole-reviewer `iter053`: GF+GR `partial` (missing `\uses` edges / implicit assembly step). Self-patched all
3 must-fixes (B1.0 anchor+edges, assembly f-invertibility prose, GR bridge wire-up). Scoped recheck
`iter053recheck`: **GATE MET both**. SNAP was CLEAR on first pass.

## Subagent skips
- None (all 3 mandatory + 2 writers + clean + 2 reviewer passes dispatched).
