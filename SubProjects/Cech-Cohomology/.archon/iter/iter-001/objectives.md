# Iter-001 objectives

Foundation/validation iter. No prover proof dispatch (mechanical + blueprint HARD GATE; see
plan.md). Deliverables produced this iter:

1. 4-way parallel audit (strategy-critic, strategy-auditor, blueprint-reviewer,
   mathlib-analogist) — all reports collected and acted on.
2. STRATEGY.md restructured to canonical skeleton; comparison theorem pivoted to the
   acyclic-resolution route (Route A); spectral sequences demoted to fallback (Route B).
3. Blueprint rewritten to Route A (2 writers + clean): new `Cohomology_AcyclicResolution.tex`;
   comparison proof + `lem:cech_acyclic_affine` split + `lem:push_pull_functor` split.
4. content.tex updated; graph rebuilt (`unknown_uses: []`, acyclic).

## Hand-off to iter-002
- Scaffold the 8 to-build `\lean{}` targets (lean-scaffolder), `AcyclicResolution.lean` new file.
- Re-run blueprint-reviewer to clear the HARD GATE (targets now matched).
- Prove: `pushPullMap_comp` (mate route) ‖ `rightDerivedIsoOfAcyclicResolution` (mathlib-build,
  comparison-of-resolutions).
