# Iter-067 plan — iter-066 closed the OPEN-IMMERSION ARC (sorry 9→6, OpenImm `_comp` 4→0 ⟹ P5a-consumer DONE); CSI is now the sole active route. progress-critic CHURNING on CSI → executed the named corrective (decompose `coreIso`) + cleared the gate, dispatched 1 `prove` lane

## Entering state (verified from iter-066 prover results + iter-066 audit reports)
- **iter-066 ran 2 `prove` lanes, sorry 9→6, 0 papered (lean-auditor iter-066: 0 must-fix, both OpenImm closures genuine — `hacyc` adjoint route real, no thin-cat kernel trap).**
  - **OpenImm (4→0): `higherDirectImage_openImmersion_comp` FULLY CLOSED axiom-clean ⟹ P5a-consumer DONE.** The
    whole open-immersion pushforward arc is complete (`_acyclic` iter-065 + `_comp` iter-066). `hacyc` = the
    iter-066-corrected adjoint route (`unfold restrictFunctor`+`inferInstanceAs (pushforward _).IsRightAdjoint` →
    `injective_of_adjoint (restrictAdjunction j)` → `IsRightAcyclic.ofInjective`); eRes/hexact/transport mechanical.
    Termwise `f_*`-acyclicity P5b needs = DONE. File 0 sorries.
  - **CSI (2→3, structural advance): Stub 5 reduced.** 3 sorry-free augmentation helpers + peeling assembly built;
    Stub 5 isolated to `coreIso` (1492) + `hcompat` (1504). Stub 6 untouched.
- **Project inline-sorry: 6** (CSI 1492/1504/1585 + CechAugmentedResolution 229 + frozen P5b CechHigherDirectImage 780 + dead CechAcyclic.affine 110).
- iter-066 audit: lean-auditor 0 must-fix / 2 major (stale OpenImm planning-comments, now-historical since arc done)
  / 2 minor; lvb-csi 0 must-fix, hcompat sketch THIN + 3-helper coverage debt (both cleared this phase).

## What I did this phase
1. **progress-critic `iter067`** (dispatched first): **CSI CHURNING** (mechanical 5×PARTIAL rule) but the
   iter-062→066 trajectory is genuine incremental convergence (leg coherence → Option step → induction leaves →
   augmentation framework), NOT helper-churn. **Primary corrective (must-fix): blueprint expansion — decompose
   `coreIso`'s differential-match into 2–4 typed sub-lemmas BEFORE dispatch** (else the iter-066 "near budget"
   decline recurs). Dispatch shape OK (single warm lane; the 3 sorries are strictly sequential). Also: P5a-resolution
   OVER_BUDGET (~14 vs est 1–3) → revise STRATEGY estimate (DONE).
2. **Executed the CHURNING corrective (the structural action, not a re-dispatch):**
   - **blueprint-writer `csi067`:** added the 3 augmentation-helper blocks (coverage debt cleared) + expanded the
     thin `hcompat` sketch (definitional-up-to-adapter) + reduced-`coreIso` shape note.
   - **effort-breaker `coreiso067`:** decomposed `coreIso` into `lem:coverInterOpen_inf_distrib` (effort 595) →
     `lem:coreIso_obj_iso` (1213) → `lem:coreIso_comm` (2242, the differential match; `hcompat` folded into p=0).
     New Lean names confirmed FREE; the prover scaffolds + proves, then assembles `isoOfComponents` inline.
   - **blueprint-clean `iter067`:** 5 Lean-syntax leaks scrubbed.
   - **blueprint-reviewer `iter067` (whole-blueprint, mandatory):** gate did NOT clear — 1 must-fix: the 3
     augmentation helpers were in the PROOF `\uses` but not the STATEMENT `\uses` of `lem:cechSection_complex_iso`
     (leandag edges are statement-level only → isolated nodes). **Planner patched the chapter directly** (added the
     3 helpers + `lem:map_augment_cond` to the relevant statement `\uses`); `dag-query` confirms them connected
     (only the 2 long-known dead nodes remain isolated/unmatched).
   - **blueprint-reviewer `rescope067` (fast-path, scoped): HARD GATE CLEARS** — `unknown_uses=[]`, helpers
     connected, `coreIso` chain adequate + wired, Stub 6 adequate. CSI cleared for dispatch.
3. **STRATEGY.md:** moved P5a-consumer (open-immersion arc) to `## Completed`; revised P5a-resolution estimate
   (~2–4 iters, OVER_BUDGET, `coreIso_comm` the genuine wall); removed the now-completed consumer row; updated P5b
   gating (termwise acyclicity DONE; gated only on P5a-resolution + EnoughInjectives connector).
4. Updated PROGRESS (iter-067 context + decisions + 1 `prove` objective + revised Next-iter plan), task_done
   (iter-066 entry), task_pending (iter-067 status), this sidecar, objectives.md, TO_USER. Condensed the
   now-historical OpenImm-internal dead-end notes. Cleared the 2 processed prover result files + 3 iter-066 audits.

## Decision made — D1: ONE `prove` lane on CSI with the decomposed `coreIso` (NOT fine-grained, NOT a split)
- **Option chosen:** single warm-context `prove` lane on `CechSectionIdentification.lean`, closing the 3 residuals
  (`coreIso` via the new chain, `hcompat`, Stub 6) sequentially.
- **Why `prove` not fine-grained:** the fine-grained trigger is "previous prove passes made NO visible progress";
  iter-066 made real progress (framework built, 1 opaque sorry → 2 typed leaves). progress-critic explicitly: a
  well-budgeted `prove` lane on the now-decomposed blueprint "has a reasonable chance" of closing all 3. The
  CHURNING corrective is the blueprint DECOMPOSITION (done), not a mode-switch. The prover scaffolds the 3 new
  named lemmas and assembles `coreIso` inline.
- **Why not split CSI into 2 files for parallelism (the standing parallelism directive):** progress-critic
  directly addressed this — the 3 sorries are STRICTLY sequential (`hcompat` depends on `coreIso`, Stub 6 on both),
  "parallelism is not available here"; a mid-development file-split risks destabilizing a clean compile for zero
  real parallelism. One warm lane is the correct shape.
- **Cheapest reversal signal:** if the lane lands `coreIso` but stalls at `coreIso_comm` or Stub 6 "near budget"
  again, next iter the escalation is a Lean-level per-coface helper (effort-breaker's named next step) for
  `coreIso_comm`, or an effort-break of Stub 6's degree-0 augmentation node — a typed sub-lemma, NOT a whole-lane
  re-dispatch.

## Subagent skips
- strategy-critic: STRATEGY.md changed only by (a) moving the COMPLETED P5a-consumer phase to `## Completed` and
  (b) revising the P5a-resolution iters-left estimate (OVER_BUDGET) — no route swap, no new strategic question, no
  decomposition change. Route A unchanged; prior verdict SOUND with no live CHALLENGE. The strategy a fresh
  mathematician would audit is identical in substance to the last SOUND review.

## Rebuttal note (progress-critic CHURNING)
Not a rebuttal — I accept the verdict and executed the named corrective (blueprint decomposition of `coreIso`,
scoped exactly as the critic required: "the differential-match into 2–4 typed sub-lemmas, not just hcompat").
Recording that the CHURNING is the mechanical 5×PARTIAL rule firing on a route the critic itself calls "genuine
incremental convergence, not stuck, not circling" — so the corrective is decomposition (done), not a route pivot.
