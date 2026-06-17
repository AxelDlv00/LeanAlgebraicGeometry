# Progress-critic directive — keystone Route B (01I8 section-localization)

Assess convergence of the single active route. One route, one file.

## Route: 01I8 keystone — `tile_section_localization` chain (file `QcohTildeSections.lean`)

The route closes the keystone `qcoh_section_isLocalizedModule` via the sheaf-axiom-equalizer decomposition
(`qcoh_section_equalizer` DONE → `tile_section_localization` → `qcoh_section_kernel_comparison` → keystone).
The active sub-target across the last several iters has been the per-tile section-localisation lemma
`tile_section_localization` and its last ingredient, Sub-lemma B `tile_section_comparison`.

### Last 5 iters' signals (extracted)

| iter | file sorry | helpers/decls added (axiom-clean) | prover status | residual / blocker phrase |
|---|---|---|---|---|
| 040 | 0 | +4 | PARTIAL | tile section comparison "not rfl" suspected |
| 041 | 0 | +3 (`qcoh_section_equalizer`, base-ring descent, `res_trans_apply`) | PARTIAL | span-cover descent found CIRCULAR → re-routed to sheaf-axiom equalizer |
| 042 | 0 | +1 (`tile_image_opens_identities` = Sub-lemma A) | PARTIAL | Sub-lemma B confirmed non-definitional (different `ModuleCat`s) |
| 043 | 0 | +2 (two rfl scalar bridges) | PARTIAL | Sub-lemma B REDUCED: ~150 LOC wall → ONE structure-sheaf ring identity |
| 044 | 0 | +5 (`tile_scalar_compat` = Sub-lemma B's residual ring identity, CLOSED, + 4 route-(A) helpers `appTop_appIso_inv_eq_res`/`key_morph`/`tile_appIso_comp`/`tile_section_ring_identity`) | PARTIAL on downstream `tile_section_localization`, but the iter-044 NAMED TARGET (close the residual ring identity → finish Sub-lemma B's scalar core) WAS achieved | next = `tile_section_localization` assembly; obstruction precisely characterised (bundled-`ModuleCat` carrier mismatch ⟹ descend at underlying-type level) |

Notes for your read:
- The active file `QcohTildeSections.lean` has been 0-sorry every iter (no papered sorries; mathlib-build mode).
- The named ingredient targets landed monotonically: Sub-lemma A (042) → reduction (043) → Sub-lemma B's
  residual ring identity `tile_scalar_compat` (044). The obstruction shrank each iter
  (section-comparison-not-rfl → ~150 LOC wall → one ring identity → CLOSED).
- iter-044 verdict from you was CHURNING (on the "PARTIAL × 3" rule); the planner's corrective that iter was
  blueprint expansion before re-dispatch (writer rewrote the sketch + reviewer HARD-GATE-CLEARED), and the
  iter-044 named target then landed.
- This iter the planner has ALSO already dispatched a blueprint-writer to fix the `tile_section_localization`
  Step 4 sketch (which referenced the unformalized `tile_section_comparison`) + clear the 5-helper coverage
  debt + acknowledge a newly-surfaced V=D(f̄) scalar-compat sub-need — i.e. the corrective is again applied
  BEFORE the prover lane, not after.

### Strategy estimate (verbatim from STRATEGY `## Phases & estimations`, row "01I8 …")
- Iters left: ~2
- Phase entered current form (sheaf-axiom equalizer re-route): iter-041 (so ~4 iters elapsed in this phase).

## This iter's PROGRESS.md `## Current Objectives` proposal
- ONE prover lane, one file: `AlgebraicJacobian/Cohomology/QcohTildeSections.lean` —
  `[prover-mode: mathlib-build]` — assemble `tile_section_localization` (the 5-step base-ring descent;
  all ingredients now axiom-clean and present), building the V=D(f̄) scalar-compat analogue if the descent
  needs it. No other lane (no honest off-keystone parallel lane exists: `cech_augmented_resolution` is gated
  on 01I8).

## Question for you
Is this route CONVERGING, CHURNING, STUCK, or UNCLEAR? In particular: does the iter-044 landing of the
named target (`tile_scalar_compat`) plus the monotone shrinking of the obstruction change your iter-044
CHURNING read? If you still see churn, name the corrective TYPE (blueprint expansion / Mathlib-idiom consult
/ structural refactor / route pivot). Note the planner is NOT adding "another helper round on the same
recipe" — `tile_section_localization` is the assembly target itself, with every ingredient now landed.
