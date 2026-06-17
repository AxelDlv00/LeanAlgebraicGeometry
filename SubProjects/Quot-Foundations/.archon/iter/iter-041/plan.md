# Iter 041 — Plan (Quot-Foundations)

## TL;DR

iter-040 landed QUOT producer (a) (the critical object-level `fromTildeΓ` iso) + range-half of (b), and
deferred the TOP producer as a 3-bridge ring-identification build. This iter dispatches **2 parallel,
import-independent prover lanes**:

1. **QUOT keystone-close** [mathlib-build] — build the rest of the producer chain (b-flocus/c/d→TOP) then the
   keystone + gap1 one-liners. The CHURNING corrective: **close gap1 this iter, or stop+flag the precise
   blocking gap** (no silent feeder-defer). De-risked by an api-alignment analogist that proved the hardest
   bridge (ModuleCat-R_s ↔ Γ(Spec R_s,⊤)) is **DEFEQ**.
2. **FBC `_legs_conj`** [fine-grained] — the FINAL in-loop Fallback-B round; escalate if it closes nothing.

Plan-cycle subagents: progress-critic (FBC STUCK, QUOT CHURNING), mathlib-analogist (σ-rebasing → DEFEQ),
blueprint-reviewer fast-path (Picard_QuotScheme re-cleared after the block split). Blueprint: split the
bundled producer-(b) block (range done / f-locus open), cleared 3 coverage-debt isolated nodes, folded the
defeq finding into the TOP sketch. STRATEGY: revised both OVER_BUDGET estimate cells.

## Decision made — both lanes dispatched per the pre-armed protocols, with the CHURNING corrective executed

- **Option chosen:** dispatch BOTH the QUOT keystone-close lane and the FBC FINAL Fallback-B round this
  iter (different files → parallel). For QUOT (CHURNING), the concrete corrective is (i) a mathlib-analogist
  consult on the riskiest deferred bridge BEFORE the prover runs, and (ii) a keystone-close-or-flag directive
  discipline. For FBC (STUCK), the corrective is the planner's own already-armed FINAL-round + escalation
  protocol, which the progress-critic explicitly endorsed.
- **Why (QUOT — not "another helper round"):** the progress-critic flagged QUOT CHURNING (PARTIAL×4, keystone
  never closes). The named corrective is "address deferred infrastructure," NOT route pivot — the critic
  certifies genuine structural progress (producer (a) is the closest-yet piece) and the blueprint complete.
  The deferred infrastructure's hardest piece was the "genuine hard core" the iter-040 prover named: the
  `ModuleCat R_s` ↔ `Γ(Spec R_s,⊤)` structure-sheaf re-basing through `ΓSpecIso`. I dispatched the analogist
  on exactly that, and it returned a decisive **DEFEQ** verdict (`modulesSpecToSheaf` is *defined* via
  `restrictScalars (globalSectionsIso R_s).hom`; σ = `(ΓSpecIso).symm ≪≫ gammaImageRingEquiv` is the inverse
  of the baked-in rebasing; no transport lemma needed). That converts the critic's conditional "if a new gap
  surfaces, consult the analogist" into a this-iter concrete action AND removes the main risk the assembly
  would defer again. This is a structural corrective (subagent + directive-discipline change), not a reworded
  repeat of the iter-040 lane (which targeted the feeders, not the assembly).
- **Why (FBC — dispatch the FINAL round, not immediate escalation):** the iter-040 plan + iter-040
  progress-critic pre-committed iter-041 as the FINAL in-loop FBC attempt before escalation; the iter-041
  progress-critic re-confirmed STUCK and explicitly endorsed running this final Fallback-B round (materially
  different from the iter-039 one-shot reframing) with the escalation gate. Escalating WITHOUT running the
  decided alternative would waste the analogist-selected route.
- **LOC/risk:** QUOT ~120–250 LOC (assembly + 2 one-liners); the defeq finding removes the largest risk.
  FBC ~80–150 LOC fine-grained; risk: Fallback B is still a conjugate-class discharge — if layer-by-layer
  peeling also resists, the route is genuinely exhausted in-loop (→ escalation, already wired).
- **Cheapest reversal signals:** QUOT — if a sub-step hits a genuinely Mathlib-absent component, the prover
  stops+flags it (→ iter-042 analogist on that ONE gap, not another bare assembly). FBC — if Fallback B
  closes nothing, escalate via TO_USER.md and open the affine tilde-transport route (NOT another conjugate
  round, NOT another analogist).

## Disposition of critic verdicts (no silent overrides)

- **progress-critic `iter041` — FBC STUCK / QUOT CHURNING (both must-fix).** ACCEPTED, both addressed:
  - FBC STUCK → corrective = the FINAL-round + escalation protocol the critic endorsed; dispatched as
    objective 2 with the explicit escalation gate. OVER_BUDGET estimate revised in STRATEGY (elapsed ~6 vs 1).
  - QUOT CHURNING → corrective = address deferred infrastructure as a keystone-close-or-flag iter. Executed
    via (a) the analogist consult that de-risked bridge-1 to defeq, (b) the keystone-close-or-flag discipline
    written into objective 1 (close gap1 OR stop+hand off the ONE precise gap — no silent feeder-defer), and
    (c) the OVER_BUDGET estimate revision in STRATEGY (elapsed ~14 vs 1–3). This is a concrete corrective
    (subagent + directive discipline), not a reworded repeat of the prior lane.
- **mathlib-analogist `quot-sigma-rebasing` (api-alignment) — PROCEED (bridge is DEFEQ).** Folded into the
  TOP producer blueprint proof + PROGRESS objective + standing notes; recipe `analogies/quot-sigma-rebasing.md`.
- **blueprint-reviewer `quot-recheck` (fast-path) — HARD GATE CLEARS.** Picard_QuotScheme complete+correct
  after the edits; 0 must-fix; the one `\uses` inconsistency (proof block of `lem:flocus_section_scalar_tower`)
  fixed inline. The informational e₁-attribution nit is non-blocking.

## Blueprint edits this iter (Picard_QuotScheme.tex only)

- **Split the producer-(b) block** (fixing the iter-040 lean-vs-blueprint-checker must-fix — broken `\lean{}`
  pin): `lem:composite_immersion_range_basicOpen` is now range-only, pin → existing
  `compositeBasicOpenImmersion_opensRange`; NEW `lem:composite_immersion_flocus_basicOpen` holds the open
  f-locus/σ claims (pin → to-be-created `compositeBasicOpenImmersion_flocus_image`). Downstream `\uses`
  rewired.
- **Cleared 3 coverage-debt isolated nodes:** `def:composite_basic_open_immersion`,
  `lem:composite_basic_open_immersion_isOpenImmersion`, and `lem:isIso_unitToPushforwardObjUnit_of_isIso`
  (pins the existing private helper) — all leandag isolated nodes from the injected graph state.
- **Enriched the TOP producer proof** with the defeq scalar-base reconciliation paragraph (analogist).

## Subagent skips

- strategy-critic: STRATEGY route structure unchanged (no swap/decomposition change/new strategic question);
  the only edits this iter are the two progress-critic-mandated OVER_BUDGET estimate-cell revisions + an FBC
  FINAL-round status note — non-strategic. The prior (iter-040) strategy-critic FBC CHALLENGE was
  sequencing-only and was addressed (A2 parallel lane + tilde-transport escalation fallback, both still in
  STRATEGY). No live CHALLENGE remains.
- blueprint-reviewer (full whole-blueprint): the iter-040 dispatch cleared the HARD GATE for both active
  chapters; the only chapter edited this iter is Picard_QuotScheme.tex, and I re-cleared it via the
  sanctioned same-iter fast-path (`quot-recheck`, complete+correct, 0 must-fix). FBC chapter unedited. A
  second full whole-blueprint pass this iter would be redundant.
- lean-auditor / lean-vs-blueprint-checker: review-phase subagents — not part of the plan phase.

## Risks / watch

- QUOT 15th PARTIAL: if the prover defers the keystone AGAIN without a precise flagged gap, that is the
  CHURNING failure the critic named — iter-042 must NOT re-dispatch a bare assembly round; act on the flag.
- FBC: this is the terminal in-loop attempt. Escalation is wired in PROGRESS iter-042 ramp + TO_USER.md.
