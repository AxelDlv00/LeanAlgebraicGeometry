# Iter-058 plan — honored 2 CHURNING correctives (decompose-before-prover), closed the must-fix, dispatched the 2 ready lanes

## Entering state (verified)
- iter-057 ran 3 mathlib-build lanes, all PARTIAL with strong progress (+16 axiom-clean decls):
  - **CechAcyclic:** Need#2 change-of-ring seed `sectionCech_homology_exact_of_affineOpen` CLOSED in one
    iter (route B1, +6 decls). Discharges `htilde`.
  - **CechSectionIdentification:** Stub-1 geometric backbone (+6 decls); hard `coproduct_distrib_fibrePower`
    deferred not stubbed.
  - **OpenImmersionPushforward:** Need#1 Ext-transport core `modulesIsoSpecExtTransport` (+4 decls).
- Inline sorry: 10 (stable; helpers landed below the assembly sorries). Build GREEN.
- Carry-over must-fix (lean-auditor + lvb iter-057): CSI Stubs 5/6 `.lean` signatures still pointed at the
  provably-false NON-augmented target with an excuse-comment block. Coverage debt: 13 lean_aux nodes.

## What I did this phase
1. Processed all 3 iter-057 prover results → `task_done.md` (iter-057 entry) + `task_pending.md` (iter-058
   status). Cleared the 3 prover result files + the 4 iter-057 review reports (lean-auditor, 3 lvb).
2. **progress-critic `iter058`** → Route 1 **CONVERGING**; Routes 2 & 3 **CHURNING** (corrective =
   blueprint decomposition before any prover; Route 3 = no prover this iter). Acted on both.
3. **effort-breaker `coproduct-distrib`** (Route-2 corrective) → split `lem:coproduct_distrib_fibrePower`
   into 4 `\uses`-linked sub-lemmas + reduced assembly + Mathlib anchor.
4. **refactor `csi-resign`** (must-fix) → re-signed CSI Stubs 5/6 to the augmented `D'_aug` (Option A:
   parametrized `ε`/`hε`, no new sorry), removed the excuse block. File compiles.
5. **blueprint-writer `need1-coverage`** → (a) Route-3 corrective: decomposed the jShriekOU transport into
   5 build-target sub-lemmas + anchor; (b) cleared the 13-node coverage debt; (c) repointed
   `lem:affine_cech_vanishing_general_seed` → `sectionCech_homology_exact_of_affineOpen` and
   `lem:affine_serre_vanishing_general_open` off `_TODO`.
6. **blueprint-clean `iter058`** (purity) → **blueprint-reviewer `iter058`**: **both prover-lane HARD GATES
   CLEAR** (Lanes 1 & 2). Route-3 decomposition sound for next iter; one soon-fix (`\uses{}` on
   `lem:pushforward_iso_preserves_qcoh`) recorded.
7. Updated STRATEGY.md (two active rows: Need#2 seed DONE → consumer is the close, iters-left ~2–4;
   Stub-1 decomposed, iters-left ~3–6), PROGRESS.md (2 lanes), task files, this sidecar.
8. Set 2 prover lanes in PROGRESS.md `## Current Objectives` (the loop fans them out): Lane 1
   `AffineSerreVanishing.lean`, Lane 2 `CechSectionIdentification.lean`.

## Decisions made

### D1 — Honor both CHURNING verdicts with decomposition, not another prover round on the monolith.
- **Route 2:** effort-breaker decomposed `coproduct_distrib_fibrePower`; the Lane-2 prover now gets the
  small ready leaves (mechanical `widePullback_overX_eq_prod` + base case first), NOT the black-box. This
  is the sanctioned post-decomposition dispatch, not a re-dispatch of the same monolith.
- **Route 3:** NO prover this iter (per the critic). Decomposed-only; dispatch next iter. This keeps the
  parallelism at 2 solid lanes rather than forcing a 3rd lane onto an un-decomposed wall the HARD GATE
  would (correctly) block.

### D2 — Must-fix CSI Stubs 5/6: re-sign (Option A), not defer.
The two stubs are consumed by nothing in code (CechSectionIdentification is imported by no file; the
references in CechAugmentedResolution are comments only). I chose to re-sign them to the correct augmented
type now (parametrized `ε`/`hε` → no new sorry, no false statement, `\lean{}` pins stay valid) rather than
delete-and-defer, so the graph stays honest and the blueprint↔Lean augmented form agrees (confirmed by the
blueprint-reviewer). The actual augmentation construction + filling is the post-Stub-1 round (next iter).

### D3 — 2 prover lanes, not 1 or 3.
Lane 1 (CONVERGING, ~10–30 LOC, closes Need#2) and Lane 2 (decomposed leaves) are both gate-cleared and
genuinely ready. Route 3 is decomposed-only. This respects the parallelism directive without dispatching a
prover at a CHURNING/un-gated target.

## Subagent skips
- strategy-critic: STRATEGY.md edits this iter are bounded status/estimate refreshes within the SAME routes
  (Need#2 seed DONE → consumer is the close; Stub-1/jShriekOU decomposed) — no route swap, no new fork, no
  decomposition change. iter-057 verdict was SOUND with no live CHALLENGE. The strategic arc (Route A, P5a
  resolution + P5a consumer + P5b) is unchanged, so a fresh strategic-soundness pass adds no signal.
- strategy-auditor: not dispatched — no new phase/route started; the active routes are continuations whose
  reference alignment (Stacks 02KE/02KG/01HV) was audited in prior iters and is unchanged.

## Risk / reversal signals
- Lane 1: if the seed application hits a defeq/instance trap (the `Algebra Γ(V) Γ(D a)` family), the recipe
  is in the iter-057 `CechAcyclic.md` result; confirm only with `lake env lean`.
- Lane 2: if `prod_coproduct_distrib` / the assembly stays hard after this round, re-dispatch the
  effort-breaker on the still-hard sub-lemma (finer granularity) — do NOT re-dispatch the monolith.
