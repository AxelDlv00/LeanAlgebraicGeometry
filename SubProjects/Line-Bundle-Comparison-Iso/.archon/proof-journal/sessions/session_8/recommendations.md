# Recommendations — next plan iter (post iter-008)

## TOP: re-run both lanes — iter-008 was a capacity failure, NOT a math stall
The `fable` prover model died at session start on both lanes (0 tokens, ~1s, immediate
session_end). No directive change is warranted — the iter-008 objectives were never executed.
**Re-dispatch BOTH lanes with the identical PROGRESS.md objectives.** If `fable` fails the same
way again next iter, switch the prover model for the round before treating either route as stuck.

Do NOT let the progress-critic read this as a STUCK route: there is no new trajectory data
(0 prover events). The CONVERGING verdicts from iter-007 remain the live read for both lanes.

## Closest-to-completion (unchanged, ready, unexecuted)
1. **`SliceTransport.lean` — DUAL ROOT `sliceDualTransportInv.naturality` (L444).** Mirror of the
   already-closed forward `sliceDualTransport.toFun.naturality`; all helpers in place. Recipe
   (`analogies/dualnat006.md`): rotate `inv ε` MORPHISM-LEVEL via `IsIso.inv_comp_eq` → forward
   ε-square; close through `appIso_hom_naturality_apply` + `dualUnitRingSwap_apply`. **DEAD END (do
   not retry):** `ext z; simp [dualUnitRingSwap_apply]` / any `inv ε` through `whnf` → ≥6-iter
   deterministic timeout. Once L444 lands, `left_inv` (L724) / `right_inv` (L726) are cheap
   `hom_inv_id` round-trips.
2. **`TensorObjSubstrate.lean` — D3′ bricks then `pullbackTensorMap_restrict` (L3144).** Introduce
   the 3 scaffolded bricks (`sheafifyMap_pullbackComp_hom_inv_id` easiest, `sheafifyTensorUnitIso_comp`
   Sq3, `pullbackValIso_comp` Sq4) bottom-up, splice with `erw` (Sheaf.val carrier mismatch — `rw`
   won't fire), then assemble the four-square merge.

## Blocked — do NOT re-assign directly
- `exists_tensorObj_inverse` (L712): import-cycle; closes downstream via the DUAL chain only.
- Scaffold seeds (`pullbackTensorIsoOfLocallyTrivial`, `pullback_tensorObj_iso`,
  `PicSharp.addCommGroup_via_tensorObj`): build only after their cones close.

## Coverage debt (carried, non-blocking)
- `archon dag-query unmatched` not re-checked this iter (no new helpers created — 0 prover edits).
  The ~97 `lean_aux` decls flagged at iter-007 stand unchanged; the `Coverage + file-split cleanup`
  STRATEGY phase still owns them, plus the deferred `TensorObjSubstrate.lean` (3152 LOC) split.

## Infra note
- blueprint-doctor (iter-008): clean. `sync_leanok` (iter 8): 0 added / 0 removed. No structural
  findings to action.
