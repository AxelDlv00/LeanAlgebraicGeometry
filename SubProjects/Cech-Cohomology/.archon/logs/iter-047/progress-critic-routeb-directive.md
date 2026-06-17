# Progress-critic directive — 01I8 Route B (sheaf-axiom equalizer) convergence

Assess ONE active route. Output a per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR)
with a named corrective if CHURNING/STUCK.

## Route: 01I8 `F ≅ ~(ΓF)` via section-localization (Route B), file `QcohTildeSections.lean`

This route builds new axiom-clean declarations (a Mathlib-infrastructure chain), it does NOT
fill pre-existing sorries — so the project sorry count is a flat 2 throughout (both frozen/
superseded, unrelated to this route). Judge convergence by named-target completion and whether
the residual obstruction is shrinking, not by sorry count.

### Last 5 iters' signals (042–046)

| Iter | Decls added (axiom-clean) | Named target | Prover status | Blocker phrase |
|---|---|---|---|---|
| 042 | +1 (`tile_image_opens_identities`, Sub-lemma A) | (helper) | PARTIAL | "section-comparison not rfl" |
| 043 | +2 (two `rfl` scalar-action bridges) | (helpers) | PARTIAL | "reduce to one ring identity" |
| 044 | +5 (`tile_scalar_compat` ⊤ + 4 route-A helpers) | `tile_scalar_compat` | PARTIAL→done(helper) | "ring identity closed; tile assembly remains" |
| 045 | +5 (`tile_scalar_compat'` D(f̄) + companions) | `tile_section_localization` | PARTIAL (target BLOCKED) | "W1/W2/W3 Lean-engineering walls" |
| 046 | +5 (`tile_section_localization` SOLVED + 4 supporting) | `tile_section_localization` | **COMPLETE (target SOLVED)** | none — walls resolved by restrictScalars-carrier recipe |

- sorry count per iter: 2 → 2 → 2 → 2 → 2 (flat; both frozen/superseded, NOT this route).
- The obstruction shrank monotonically: section-comparison-not-rfl → one ring identity →
  named W1/W2/W3 engineering walls → RESOLVED. iter-046 is the FIRST clean SOLVE of a named
  target on this route since the decomposition began (the last keystone-feeding leaf).
- iter-045 progress-critic verdict was CHURNING; iter-046 SOLVED the flagged target on contact
  with the prescribed corrective (a mathlib-analogist consult → restrictScalars-carrier recipe).

### Strategy estimate vs elapsed
- STRATEGY `## Phases & estimations` 01I8 row: `Iters left ~2`, marked OVER_BUDGET (the
  tile-lemma sub-phase took 5 iters vs ~2 est, 041→046).
- The route entered its current phase (01I8 section-localization, sheaf-axiom equalizer) at
  iter-041.

### This iter's (047) proposed prover assignment
- **1 file**: `QcohTildeSections.lean`.
- **Target**: BUILD the new declaration `qcoh_section_kernel_comparison` (the Lean decl does NOT
  yet exist — `mathlib-build`, no-sorry). It is on the leandag READY frontier (all 4 `\uses` deps
  done: `qcoh_finite_presentation_cover`, `qcoh_section_equalizer`, `IsLocalizedModule.map_exact`,
  `tile_section_localization`). Effort estimate 3119 (high). Keystone `qcoh_section_isLocalizedModule`
  is a stretch in the same lane if the kernel comparison lands.
- This is a DIFFERENT, downstream target than the prior 5 iters' tile-lemma work — the tile leaf
  is DONE; the route advances to the next frontier node.

## Question for you
Is this route CONVERGING (proceed to the kernel-comparison build) or is the planner walking into
a churn pattern by dispatching another high-effort target on the same file? Name the corrective
type if CHURNING/STUCK.
