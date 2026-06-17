# Iter-048 plan — KEYSTONE SOLVED (iter-047); blueprint `\uses` inversion + coverage debt cleared; build the Route-B assembly

## Entering state (verified)
iter-047's one `mathlib-build` lane **SOLVED + EXCEEDED** the objective: it landed the Route-B **KEYSTONE**
`qcoh_section_isLocalizedModule` (for qcoh `F`, `ρ_f : Γ(X,F)→Γ(D(f),F)` is `IsLocalizedModule (powers f)`)
axiom-clean (`#print axioms` = {propext, Classical.choice, Quot.sound}), the original objective
`qcoh_section_kernel_comparison` (its packaged-iso corollary), the NEW abstract primitive
`isLocalizedModule_of_exact` (converse of Mathlib's `IsLocalizedModule.map_exact`), and +3 private helpers.
File 0-sorry; project inline-sorry = 2 (both frozen/superseded). New import
`Mathlib.RingTheory.TensorProduct.IsBaseChangePi`. The single hardest leaf of 01I8 is closed. lean-auditor
`iter047` + lean-vs-blueprint `qts`: 0 must-fix; all `change`/`Subsingleton.elim`/`@`-thread genuine.

## What I did this phase
1. Processed iter-047 lane → task_done (+6 axiom-clean, keystone SOLVED+EXCEEDED); refreshed task_pending +
   PROGRESS keystone-chain (keystone/kernel/`isLocalizedModule_of_exact` all marked DONE) to iter-048.
2. **Cleared the must-fix blueprint findings + coverage debt** (lean-vs-blueprint `qts`: 2 major):
   - blueprint-writer `fix-deps`: authored `lem:isLocalizedModule_of_exact` (the abstract left-exact-ladder
     primitive, Archon-original) + `lem:overlap_section_localization` (bundling the 2 bookkeeping privates
     `overlap_target_eq`/`presheaf_map_comp₂_apply`); **flipped the keystone↔corollary `\uses` edge** (the real
     DAG inversion the checker + blueprint self-NOTE flagged — keystone now `\uses isLocalizedModule_of_exact`,
     corollary `\uses qcoh_section_isLocalizedModule`); moved the equalizer→ladder→kernel chase into the
     keystone proof, reduced the corollary proof to a one-liner. `leandag`: `unknown_uses: []`, `conflicts: []`.
   - blueprint-clean `fix`: stripped Lean-field-name leakage + stale planner narrative from the new blocks.
   - **Planner edit:** wired the isolated `lem:isScalarTower_restrictScalars_obj` into the STATEMENT `\uses` of
     `lem:tile_section_localization` (it was proof-`\uses`-only; leandag reads statement-level only —
     ARCHON_MEMORY note). `unmatched` 6→1, `isolated` →1 (both = only the pre-existing dead `CechAcyclic.affine`).
3. **Same-iter fast path:** blueprint-reviewer `iter048` (whole-blueprint) → **HARD GATE CLEARS** for the
   assembly lane: `lem:qcoh_isIso_fromTildeGamma` fully ready (statement faithful to Stacks 01I8, 4-step proof
   sketch sufficient, all 5 `\uses` deps done); 0 must-fix; the flipped-`\uses` blocks acyclic + faithful.
   2 "soon" items = `\leanok` sync artifacts on the 2 new nodes (sync_leanok handles them, non-blocking).
4. Refreshed STRATEGY 01I8 row + Mathlib-gaps 01I8 bullet: keystone DONE; remaining = the
   `isIso_fromTildeΓ_iff` essImage assembly only; Iters-left ~2–3 → ~1.
5. Dispatched ONE prover lane: `QcohTildeSections.lean` → build `isIso_fromTildeΓ_of_quasicoherent`
   (mathlib-build, NEW decl), register as an instance ⟹ unconditional `qcoh_iso_tilde_sections`.

## Decision made

### D1 — ONE prover lane (the Route-B assembly); the keystone path is linear, no honest parallel lane.
`isIso_fromTildeΓ_of_quasicoherent` is the LAST 01I8 step: forget-reflects-isos + basis check; each `D(f)`-
component is `IsLocalizedModule.lift` of the keystone map; the keystone (now DONE) makes `ρ_f` a localization
⟹ the lift between two localizations is an iso. It is frontier-READY (all 5 `\uses` deps done — the keystone +
4 Mathlib anchors), the blueprint block is HARD-GATE-cleared, and registering it as an instance
`[F.IsQuasicoherent] → IsIso F.fromTildeΓ` upgrades `qcoh_iso_tilde_sections` to unconditional (the single
input the 02KG tops + P5a + P5b all gate on). The standing parallelism directive manufactures no honest
second lane THIS iter: the only other frontier nodes touching this route are GATED on the still-unbuilt
unconditional `qcoh_iso_tilde_sections` (`cechAugmented_exact` via `\uses{lem:qcoh_iso_tilde_sections}`,
frontier-honesty fix iter-043) or are dormant Route-P assets (`tilde_restrict_basicOpen`) / already-built
unpinned structural nodes (`cech_free_eval_prepend_homotopy` has NO standalone `\lean{}` pin — transported
from the engine complex, not a prover target). Parallel lanes open NEXT iter once the assembly lands.
**Effort:** assembly is effort ~1583, but mechanical recipe-application (the iter-047 handoff gives the exact
recipe + the `↑R`-Semiring-diamond workaround). **Reversal signal:** if the prover hits a genuinely missing
Mathlib component-identity lemma (how `fromTildeΓ`'s `D(f)`-component decomposes as `IsLocalizedModule.lift`),
mathlib-build leaves a precise handoff and next iter builds that ingredient axiom-clean first.

## Subagent skips
- **progress-critic**: skipped — the 01I8 route landed a clean SOLVE+EXCEED of the keystone (the single hardest
  leaf) in iter-047; prior verdict was CONVERGING with no must-fix; the proposed target is a DOWNSTREAM
  frontier-READY assembly node (not a re-attempt of any churned target). Convergence is manifest, not in
  question — there is no churning-risk trajectory to extrapolate. (Descriptor skip: "the only active route just
  completed/closed out the hardest part in the prior iter; next target is downstream-ready.")
- **strategy-critic**: skipped — STRATEGY.md edits this iter are a within-route progress refresh only (01I8 row
  Iters-left 2–3→1, keystone marked DONE in the Mathlib-gaps bullet); the route itself (Route B sheaf-axiom
  equalizer → `isIso_fromTildeΓ_iff` assembly) is UNCHANGED, and the prior verdict was SOUND with no live
  CHALLENGE/REJECT. No route swap, no phase split/merge, no new Mathlib gap, no resolved/new strategic question.

## Reversal signals (carry to next planner)
- If the assembly stalls on a missing Mathlib component-identity lemma → mathlib-build that ingredient first.
- If the `↑R`-Semiring diamond resurfaces on the lift map → apply the KB recipe (`change`/defeq +
  presheaf-abstracted helpers + `@`-threaded instances), exactly as iter-047 did for the keystone.
