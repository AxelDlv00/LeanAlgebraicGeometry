# Iter 042 — Plan (Quot-Foundations)

## TL;DR

iter-041 resolved two long-standing forks in opposite directions: **QUOT gap1 CLOSED axiom-clean** (the
~14-iter section-localization-descent arc) and **FBC's conjugate `gstar_transpose` route EXHAUSTED in-loop**
(5 iters, 037–041). This iter acts on both:

1. **QUOT (prover this iter).** gap1 unblocks its consumers. Dispatch ONE clean lane on `QuotScheme.lean`
   [mathlib-build]: build **G1-core** `isLocalizedModule_basicOpen_of_isQuasicoherent` (a one-line corollary
   of gap1) then **gap2** `isLocalizedModule_basicOpen` (general X, single-chart transport). HARD GATE
   re-cleared this iter (fast path).
2. **FBC (blueprint + pivot this iter; prover iter-043).** Honor the armed protocol — NO conjugate prover.
   Authored the **affine tilde-transport** blueprint (`lem:pushforward_base_change_mate_sections_direct` +
   revised `cancelBaseChange` proof) that bypasses the section-level mate. The writer confirmed the bypass
   is GENUINE (no strategy-modifying finding) — the strategy-critic's one load-bearing risk did not
   materialize. iter-043 dispatches the prover (progress-critic: mandatory, else CHURNING-by-avoidance).
3. **Coverage debt CLEARED.** Reconciled the 3 stale QuotScheme `\lean{}` pins + added the 4 helper blocks;
   leandag `unmatched` clean. **STRATEGY format fixed** (17.3 KB→12.9 KB).

## Decision made — FBC: pivot to affine tilde-transport (blueprint now, prover iter-043)

- **Option chosen:** abandon the conjugate calculus entirely; prove IsIso of the canonical
  `pushforwardBaseChangeMap` at the affine-local level via the proven `pullback_spec_tilde_iso` +
  `cancelBaseChange`, bypassing the section-level `gstar_transpose` identity. Author the blueprint this iter;
  prover iter-043. NO conjugate/analogist round (armed kill-criterion + progress-critic STUCK).
- **Why not escalate-and-wait:** the standing AUTONOMOUS-OPERATION directive forbids idling on a user steer.
  The reversal signal I armed was "if the bypass is illusory (the parent-frozen map forces the section
  identity), escalate." I tested that signal THIS iter by having the blueprint-writer attempt the explicit
  affine collapse — it succeeded honestly (`r'⊗m ↦ (r'⊗1)⊗m` falls out of the tensor universal property +
  `φ:R→A`, no mate identity). So the route is live; no escalation needed.
- **Why blueprint-this-iter / prover-iter-043 (not prover now):** the one ready prover slot is better spent
  on the gate-clear QUOT consumer (higher leverage — unblocks GF-G1). The FBC route needs a new decl built
  from a fresh blueprint; preparing it well this iter (writer + clean) and dispatching iter-043 is the
  disciplined sequencing the progress-critic endorsed (it set the HARD constraint that iter-043 MUST
  dispatch FBC).
- **LOC/risk:** iter-043 FBC ~150–350 LOC [mathlib-build]; main risk = the direct `Γ(α)` computation is
  heavier than the sketch (adjunction-unfold via `TensorProduct.induction_on`). Cheapest reversal signal: if
  the direct computation cannot avoid re-deriving the mate, the bypass was illusory → escalate (writer says
  genuine, so low probability).

## Decision made — QUOT: build the gap1 consumers (one lane), defer GF-G1 to iter-043

- **Option chosen:** one [mathlib-build] lane on `QuotScheme.lean` for G1-core + gap2. NOT a second parallel
  lane on `FlatteningStratification.lean` (GF-G1) this iter.
- **Why one lane:** GF-G1 = direct G1-core application, but `FlatteningStratification.lean` does NOT import
  `QuotScheme.lean` (verified) and G1-core is built (not yet committed) this iter. Opening GF-G1 in parallel
  would require a refactor to add the import AND race the prover against an uncommitted G1-core. Cleaner:
  land G1-core this iter, add the import + GF-G1 iter-043. progress-critic explicitly certified "1 file,
  dispatch OK, not under-dispatch."
- **gap2 de-risked:** the writer found gap2 is single-chart transport (statement fixes U affine), NOT
  cover-and-glue — so the progress-critic's "infinite onion" gluing worry does not arise. One new transport
  packaging lemma at most.

## Critic dispositions (no silent overrides)

- **strategy-critic `iter042` SOUND** — FBC pivot well-founded; gap1→consumers correct. Two must-fixes
  ADDRESSED in-iter: (1) STRATEGY trimmed to 12.9 KB, per-iter narrative + multi-sentence Risk cells
  removed; (2) `def:sectionGradedRing` tensor-powers given its own BLOCKED estimate row. Its caveat (make
  the affine collapse explicit) was passed verbatim to the FBC writer and discharged honestly.
- **progress-critic `iter042` FBC STUCK / QUOT UNCLEAR** — ACCEPTED. FBC pivot is a genuine corrective
  (structurally distinct, pre-armed). HARD constraint recorded: iter-043 MUST dispatch the FBC prover (a 2nd
  consecutive no-prover FBC iter = CHURNING-by-avoidance) — encoded in PROGRESS Iter-043 ramp + task_pending.
  QUOT consumer lane endorsed; gap2 affine-cover monitored (now known to be single-chart, lower risk).
- **blueprint-reviewer `iter042` + `quot-recheck`** — G1-core + gap2 gate-clear; FBC tilde-transport route
  fully outlined (§3) with all prereqs present. Fast-path re-review CLEARED QuotScheme.

## Subagent skips

(none — all three [HIGHLY RECOMMENDED] plan-phase subagents dispatched: blueprint-reviewer, strategy-critic,
progress-critic. Plus 2 blueprint-writers, blueprint-clean, and a fast-path scoped re-review.)

## Disproof / soundness notes

- FBC bypass soundness was the live risk (strategy-critic). Tested by directing the writer to make the
  affine collapse explicit OR report a strategy-modifying finding; it produced an honest explicit collapse
  ⟹ the statement is sound, not a hidden re-derivation. Not a multi-iter prover commitment without this
  check.
- G1-core is a one-liner corollary of two axiom-clean iter-041 decls — soundness inherited from gap1.
