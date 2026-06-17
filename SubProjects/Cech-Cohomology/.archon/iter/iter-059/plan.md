# Iter-059 plan — Need#2 CLOSED; caught + corrected a Mathlib universe trap; resolved the Need#1-necessity CHALLENGE; dispatched the 2 ready assembly lanes

## Entering state (verified from iter-058 prover results)
- **Lane 1 (`AffineSerreVanishing.lean`): NEED#2 CLOSED end-to-end.** +2 axiom-clean decls
  (`affine_tildeVanishing_general` private + public `affine_serre_vanishing_general_open`). General-affine
  02KG cone closes; `#print axioms` kernel-only. sorry 0→0.
- **Lane 2 (`CechSectionIdentification.lean`): Stub-1 brick set COMPLETE.** +9 axiom-clean decls (4 leaves
  + `prodFinSuccIso` + 4 Over-S helpers). Every brick the induction needs now exists; only assembly glue
  remains. sorry 5→5.
- Inline sorry: 10 (stable). Build GREEN.
- Review subagents (iter-058): lean-auditor 0 must-fix / 2 MAJOR (universe `{ι:Type}` on
  `prod_coproduct_distrib`+`coproduct_fibrePower_reindex` — flagged as "trivial widen"); lvb-csi 1 MAJOR
  (σ-component slice-product blueprint bridge note); lvb-affineserre clean.

## What I did this phase
1. **Caught the universe trap empirically.** The lean-auditor's "trivial widen `{ι:Type}`→`{ι:Type*}`"
   MAJOR is WRONG: I made the edit and `lake env lean` REJECTED it — `FinitaryPreExtensive.isIso_sigmaDesc_fst`
   is `{α:Type}` (Type 0). Reverted both leaves to Type 0. Determined `𝒰.I₀ : Type v` (free universe) but
   `[Finite]`, so the correct fix is a **universe reduction**: induction at Type 0, reindex `𝒰.I₀≃Fin n`
   at the consumer. (Distinct from the auditor/progress-critic's naive widen.)
2. Processed both iter-058 prover results → `task_done.md` (iter-058 entry) + `task_pending.md` (iter-059
   status). Cleared the 2 prover + 3 review result files.
3. **3 read-only critics** (progress-critic, strategy-critic background; blueprint-reviewer after writer):
   - **progress-critic `iter059`:** Lane A (CSI) CHURNING (boundary PARTIAL×4), corrective claimed = the
     2-line widen → **REBUTTED** (see D1; it doesn't compile). Lane B (OpenImm) CONVERGING. 2-file proposal OK.
   - **strategy-critic `iter059`:** Route A SOUND; **CHALLENGE on Need#1 necessity → RESOLVED** (see D2).
     Format DRIFTED → trimmed active-table iter-tags.
   - **blueprint-reviewer `iter059`:** all chapters complete+correct, **BOTH HARD GATES CLEAR**; one
     soon-fix (`finitaryExtensive_scheme_mathlib` in the proof `\uses`) applied inline.
4. **blueprint-writer `iter059`** (consolidated chapter): σ-slice-product bridge notes, `Type 0`
   universe-reduction note + `lem:isIso_sigmaDesc_fst_mathlib` anchor, NEW `lem:overProd_coproduct_distrib`
   Over-S bridge + `lem:overProdLeftIsoPullback_mathlib` anchor, `\uses` on `lem:pushforward_iso_preserves_qcoh`,
   cleared all coverage debt (6 helper-name bundles). → **blueprint-clean `iter059`** (purity).
5. Updated STRATEGY (Need#2 → Completed row; CHALLENGE resolution in Open questions; universe trap in the
   P5a-resolution Risks cell; de-tagged active rows). Updated PROGRESS (2 lanes), task ledgers, this sidecar.

## Decisions made

### D1 — REBUT the progress-critic's CHURNING corrective ("2-line universe widen"); the real fix is a Type-0 reduction.
- **Rebuttal:** the corrective the progress-critic (citing lean-auditor iter-058) prescribes —
  `{ι:Type}`→`{ι:Type*}` on `prod_coproduct_distrib`/`coproduct_fibrePower_reindex` — **does not compile**.
  I applied it and `lake env lean` errored: `isIso_sigmaDesc_fst` is universe-0-only, so widening the leaf
  leaves the proof untypable. The CHURNING verdict itself is a boundary PARTIAL×4 trigger that the critic
  concedes is "boundary-condition" and that "after the fix, dispatch is sound (all bricks built)". The
  genuine fix (Type-0 induction + `𝒰.I₀≃Fin n` reindex at the consumer) is now documented in the blueprint
  and the lane directive. So Lane A IS dispatched this iter — not another decomposition round — because the
  route is brick-complete and the only open work is the assembly + the (now-understood) universe reduction.
- **Why not another effort-break:** the bricks are all built; the iter-058 prover handed off a complete
  step-by-step inductive recipe + named the `overProd_coproduct_distrib` bridge. There is nothing left to
  decompose — the work is to write the assembly. Re-decomposing would be the churn, not the cure.

### D2 — Resolve the strategy-critic's Need#1-necessity CHALLENGE in favor of KEEPING Need#1 (option 2).
- **Chosen:** Need#1 (`U.Modules ≌ (SpecΓU).Modules` standalone-Ext transport) is NECESSARY; do NOT pivot
  to direct re-instantiation of Need#2 at ambient=`U`.
- **Why:** I checked the actual leaf (OpenImmersionPushforward.lean:373): it is
  `IsZero (Ext_{U.Modules}(jShriekOU(j⁻¹W), H) q)` with `U` the ABSTRACT affine source scheme of `j`.
  `affine_serre_vanishing_general_open` is stated for ambient `Spec R` (its proof rests on tilde sheaves
  `~M`, 01I8 `F≅~ΓF`, section-localization — none available for an abstract affine scheme). Since `U` is
  NOT definitionally `Spec` of anything, the only way to reach Need#2 is to transport along `U≅SpecΓU`.
  The critic's option-1 (re-instantiate at ambient=`U`) is therefore impossible. Recorded as a RESOLVED
  bullet in STRATEGY Open questions. This keeps Lane B (Need#1) on its planned route.

### D3 — 2 prover lanes (CSI assembly + OpenImm Need#1), both mathlib-build.
Both hard-gate cleared, both brick-/decomposition-complete and frontier-ready. Lane 1 = the CSI inductive
assembly; Lane 2 = the OpenImm Need#1 transport sub-lemmas + Ext bridge → discharge the `_acyclic` leaf.
File-split parallelism per the standing directive; no shared file.

## Rebuttals to critic findings (live)
- progress-critic Lane A CHURNING corrective ("2-line widen") — REBUTTED (D1); the fix is the Type-0
  reduction, blueprint-documented; dispatch proceeds.

## Subagent skips
- (none — all three highly-recommended critics dispatched: progress-critic, strategy-critic, blueprint-reviewer.)

## Risks / watch items
- Lane B has a history of surfacing a new infra gap per dispatch (corepresentability iter-056, Ext-transport
  iter-057); if `pushforward_commutes_sheafify` or `yoneda_transport_along_homeo` hits a missing Mathlib
  anchor it will PARTIAL again — re-assess at iter-060 (progress-critic flagged this).
- Lane A universe reduction: the `𝒰.I₀≃Fin n` reindex of the cover family through the wide-pullback /
  coproduct must commute with the structure maps; if the reindex transport is fiddly, the prover should
  hand off the reduced-but-unwired consumer rather than stub.
