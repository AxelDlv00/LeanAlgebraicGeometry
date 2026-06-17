# Iter 006 — Plan

## Decision made
- **User ask = completeness audit vs AJC.** Ran it: union of 3 seed cones = 108 nodes, ALL
  present locally; local cone sizes match AJC exactly (52/36/32); `DualInverse.lean` has all 18
  AJC decls (+1). Only Lean diffs: AJC's `extendScalars`/`pullback0`/`pullbackLanDecomposition`
  Lan block (DEAD in AJC — never used downstream, AJC comment says active route "does NOT consume"
  it) and Route-A `etSheaf`/`functorial`/`pullback_pullback_eq` (OUT OF SCOPE, A.2.c). **Verdict:
  nothing required is missing.** Chose NOT to port the Lan block (dead code; AJC kept it and is
  still stuck on the same cocycle → not the lever; would only add coverage debt to a CHURNING route).
- **Ground-truth build check overturned the prover self-reports.** DUAL prover claimed "4 closed,
  0 sorries" — FALSE: `DualInverse.lean` is RED (6 compile errors incl. `Unknown identifier
  sliceDualTransport`). `TensorObjSubstrate.lean` is GREEN (3 sorries). So the real blocker is a
  DUAL **regression**, not missing deps.
- **progress-critic = STUCK ×2** (must-fix). Took the named corrective for BOTH: dispatched
  mathlib-analogist (cross-domain) per route. Both returned ANALOGUE_FOUND with root-cause fixes:
  - DUAL (`dualnat006.md`): never apply `inv ε` pointwise (cause of 30-iter whnf timeout); rotate
    the iso edge morphism-level via `IsIso.inv_comp_eq` → forward ε-square.
  - D3′ (`d3cocycle006.md`): stop splicing a component δ-square; work at NatTrans level via
    `conjugateEquiv_comp`, mirror the project's own working `pullbackObjUnitToUnit_comp` (L920–993).
- Both lanes kept on `prove`, re-scoped to the new recipes. DUAL is REPAIR-then-prove (compiling
  state first). Reversal signal: if the analogist recipes still don't move the residual next iter,
  the DUAL naturality becomes an effort-breaker / refactor target (the `sliceDualTransport` shape).

## Subagent skips
- blueprint-reviewer: consolidated chapter `Picard_TensorObjSubstrate.tex` cleared the HARD GATE
  iter-001; no chapter content edited this iter (the new guidance is tactic-level → lives in
  `analogies/*.md`, not the blueprint); both active lanes target already-cleared decls.
- strategy-critic: STRATEGY.md edits are non-strategic (route-lever recipe notes + completeness-audit
  resolution; same 2 routes, same goal, same phases/estimates); prior verdict SOUND with no live challenge.
