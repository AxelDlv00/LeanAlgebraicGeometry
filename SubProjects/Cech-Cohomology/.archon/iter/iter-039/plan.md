# Iter-039 plan — Route B B3 engine processed (DONE); B3 object iso + B4 re-dispatched

## Entering state (verified)
iter-038's one lane processed: `QcohRestrictBasicOpen.lean` +8 axiom-clean, headlined by the **B3 engine**
`modulesOverBasicOpenEquivalence` (the analogist-designated single load-bearing lane of B3 — the
`pushforwardPushforwardEquivalence` equivalence, H₁/H₂ coherence discharged kernel-soundly) + 7 B3a helpers.
The named B3 **object iso** `overBasicOpenIsoRestrict` + B4 left ABSENT (mathlib-build no-sorry invariant),
precise in-file TODO. Project inline-sorry = 2 (both frozen/superseded). Build green. Coverage debt = 9
unmatched (8 new iter-038 decls + dead `CechAcyclic.affine`).

## What I did this phase
1. Processed the iter-038 lane → task_done (+8, B3 engine closed); refreshed task_pending (header→iter-039,
   rewrote the stale iter-034 "THIS ITER Lane A/B" Route-P blocks: 02KG cover-system marked COMPLETE+gated,
   01I8 rewritten as the live Route B B0–B6 chain with Route P marked DORMANT).
2. **Cleared the 8-decl coverage debt directly** (planner-authored — project-bespoke categorical plumbing,
   no external citation needed): added `def:modules_over_basicOpen_equivalence` pinning the engine + 5 B3a
   helpers (`overForgetIso`, `overForgetInvIso`, `overBasicOpenRingHom`, `overBasicOpenRingInvHom`, the
   private image–preimage helper) with `\uses{lem:overEquivalence_isContinuous,
   lem:pushforwardPushforwardEquivalence_mathlib}`; folded the two `_isContinuous_toScheme` instances into
   `lem:overEquivalence_isContinuous`'s `\lean{}`; wired `def:modules_over_basicOpen_equivalence` into the B3
   lemma `\uses` (statement + proof). Reworded one B3a prose line to drop a raw Lean identifier (Lean leakage).
   Residual unmatched after this = 1 (dead `CechAcyclic.affine`, deferred — protected file references it).
3. **progress-critic `iter039` → CONVERGING** (mandatory; dispatched). Confirmed B1→B2→B3-engine is monotone
   named-target progress with evolving (non-recurring) blockers; the one slip of the B3 object-iso wrapper is
   correct prioritization (engine first), not churn — disconfirmed by "no math wall remains" + typechecking
   skeleton. Litmus watch recorded (see Decision/Reversal).
4. Dispatched ONE prover lane: `QcohRestrictBasicOpen.lean` → B3 object iso `overBasicOpenIsoRestrict` + B4
   (mathlib-build; recipe = the iter-038 in-file TODO, transcribed into the objective). Wrote sidecars,
   ARCHON_MEMORY, TO_USER.

## Decision made

### D1 — ONE prover lane (QcohRestrictBasicOpen only); QcohTildeSections genuinely import-blocked.
The B3 object iso + B4 are the only remaining QcohRestrictBasicOpen targets, and the keystone-assembly lane
(`qcoh_section_isLocalizedModule`, QcohTildeSections) requires importing B3/B4 — decls that do not exist yet.
Re-deriving B3 inside QcohTildeSections would duplicate the load-bearing bridge against the deliberate file
split. The dependency graph is linear here; the standing parallelism directive does not manufacture honest
parallel work. progress-critic independently confirmed the single-lane constraint. **Reversal signal:** B3
object iso lands + B4 trivial ⟹ next iter opens the keystone-assembly lane immediately.

### D2 — Build the B3 object iso; do NOT pivot/escalate. Litmus watch armed for iter-040.
The engine is done and the object iso is a bounded mechanical assembly (`(pushforwardCongr h).app M` skeleton
typechecks against the target; remaining = the `h` ring-sheaf data equality with the site functor `F` pinned).
analogist `bridge` (iter-037) confirmed B3 bounded, no math obstruction. The standing AUTONOMOUS directive
forbids escalation. **Litmus watch (progress-critic `iter039`):** if `overBasicOpenIsoRestrict` slips AGAIN
this iter, iter-040 shifts to CHURNING — the corrective is then a mathlib-analogist consult on the
`pushforwardCongr`/`ι_appIso` term-mode assembly (the stuck-metavariable `F`), NOT another bare prover round.

## Subagent skips
- blueprint-reviewer: the B3/B4 prover-target blocks (`lem:restrict_over_compat`,
  `lem:presentation_modulesRestrictBasicOpen`) are UNCHANGED from iter-038's HARD-GATE-CLEAR review (0
  must-fix); my chapter edits are purely ADDITIVE coverage-debt entries (a new engine def block + bundled
  `\lean{}` pins) that do not touch the gated statements → the HARD GATE for QcohRestrictBasicOpen remains
  valid. No must-fix-this-iter finding from the prior dispatch is live (the lvb-checker `qrbo` flagged 2
  MAJOR coverage gaps, both cleared this phase by the engine-node addition; explicitly "no must-fix").
- strategy-critic: STRATEGY route unchanged (Route B, same B0–B6 chain; no route swap / phase split-merge /
  reorder). My STRATEGY edits are status-cell refreshes (B3 engine DONE, iters-left ~2–3→~2) within the
  active phase, not a strategy change. Prior strategy-critic verdict (iter-036) was SOUND with no live
  CHALLENGE on Route B.
- blueprint-writer / blueprint-clean: no writer round — I authored the trivial coverage-debt entries myself
  (planner-sanctioned: project-bespoke plumbing, no citation/source). Edits are math-only prose + `\lean{}`
  pins, so no purity pass needed.

## Coverage / DAG
- unmatched 9 → 1 (sole residual = dead `CechAcyclic.affine`, deferred to P5b rework).
- New blueprint node `def:modules_over_basicOpen_equivalence` (engine + B3a helpers), wired into the B3
  lemma cone. Continuity node `lem:overEquivalence_isContinuous` now pins 6 names (4 generic + 2 toScheme).

## Notes for next planner
- If B3 object iso + B4 land: add `import QcohRestrictBasicOpen` to QcohTildeSections and open the keystone-
  assembly lane (`qcoh_section_isLocalizedModule`) — item 1 of PROGRESS Next-iter plan.
- lean-auditor `iter038` MAJOR (non-blocking): deprecated `Sheaf.val` at 5 sites in QcohRestrictBasicOpen
  (lines 195/213/232/239/240) → migrate to `ObjectProperty.obj` before the next Mathlib bump (polish-phase item).
