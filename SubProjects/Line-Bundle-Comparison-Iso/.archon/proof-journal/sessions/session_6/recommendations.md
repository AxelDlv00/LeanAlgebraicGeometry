# Recommendations — next plan iter (after iter-006)

## CRITICAL — repair `DualInverse.lean` FIRST (it is RED)

`DualInverse.lean` does not compile (6 errors, confirmed by `lake build` this review). It has been
broken since iter-005 and was **not repaired in iter-006** — the scoped DUAL repair lane delivered no
edits. A RED dependency blocks the whole DUAL chain and, transitively, `exists_tensorObj_inverse`.

- **Dispatch the DUAL repair-then-prove lane FIRST, with `analogies/dualnat006.md` pre-loaded into
  the prover directive** (the iter-006 failure was that the analogist ran concurrently with the
  prover, so the recipe was never in hand). Recipe: at `sliceDualTransport.naturality` (~L547) and
  `sliceDualTransportInv.naturality` (~L398), `apply PresheafOfModules.hom_ext; intro W`, then
  `haveI := isIso_ε_restrictScalars_appIso f _; rw [IsIso.inv_comp_eq]` to rotate the `inv ε`
  (`dualUnitRingSwap`) edge to the RHS → forward `ε`-square; close with `φ.naturality` +
  `ModuleCat.restrictScalars_η` + `restrictScalarsComp'App`.
- **DO NOT re-attempt** `ext z` + `exact hφ z` on the naturality holes, nor pointwise
  `ext z; simp [dualUnitRingSwap_apply]` — that forces `inv ε` through `whnf` and is the documented
  ≥6-iter timeout cause. `subsingleton` closes only the outer dual-valued square (L803 cascade), not
  these section squares.
- Reversal signal (from the iter-006 plan): if the recipe still doesn't move the residual, escalate
  the `sliceDualTransport` shape to an effort-breaker / refactor target rather than another prover round.

## HIGH — D3′ is converging; finish `pullbackTensorMap_restrict` (TensorObjSubstrate L3144)

The 6-iter STUCK `comp_tail` node CLOSED this iter; the only non-deferred TOS sorry left is the
`pullbackTensorMap_restrict` final paste. The residual is **project-lemma construction, not a tactic
or Mathlib-search gap** — build the two Mathlib-absent coherence sub-lemmas (iter-257 roadmap):
- **Sq3**: `sheafifyTensorUnitIso` composition coherence.
- **Sq4**: `pullbackValIso` composition coherence — should reduce to the now-CLOSED
  `sheafificationCompPullback_comp` + counit naturality.
- Then in the paste: (i) cancel the adjacent `aZ.map (PrPbComp.hom.app) ≫ aZ.map (pb.inv.app)` pair by
  building the cancellation equation standalone (`Iso.hom_inv_id_app` + `congrArg aZ.map`, the `hδ`
  technique) and splicing with `erw`; (ii) split `δcomp` by `Functor.OplaxMonoidal.comp_δ`.
- **Reusable**: every cross-elaboration / `Sheaf.val`-spelled / `show`-pinned rewrite in this region
  needs `erw`; plain `rw`/`simp only` silently no-ops. `erw [Functor.map_comp]` on a δ unfolds it into
  its mate expansion — never do that.
- Consider an effort-breaker on `pullbackTensorMap_restrict` to land Sq3/Sq4 as separate frontier
  lemmas before the next prover round (the residual is now structural, not tactical).

## MEDIUM — blueprint attribution fix (lean-vs-blueprint-checker, major)

`lem:tensorobj_lift_onproduct` in `Picard_TensorObjSubstrate.tex` pins
`\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}`, but that declaration now lives in
`RelPicFunctor.lean` (moved iter-247) and the chapter's `% archon:covers` does not list that file.
Dispatch a blueprint-writer to fix chapter↔file attribution (add `RelPicFunctor.lean` to the covers
set, or relocate the block). Report: `task_results/lean-vs-blueprint-checker-tos-rerun.md`.

## MEDIUM — 1:1 coverage debt (new this iter, plus a backlog)

`archon dag-query unmatched` = 93 `lean_aux` nodes with no blueprint entry. **New this iter** (blueprint
these so the dependency graph stays honest):
- `AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_comp_natTrans` (TOS ~L2469, private) —
  the NatTrans-level cocycle; now the load-bearing proof of `lem:sheafificationcomppullback_comp_tail`.
  Uses: `Adjunction.leftAdjointCompNatTrans_assoc`, `conjugateEquiv_symm_id`,
  `Scheme.Modules.pullbackComp`, `SheafOfModules.pushforwardComp`, `PresheafOfModules.pullbackComp/pushforwardComp`.
  Add a `\label`+`\lean`+`\uses` block and add it to `lem:sheafificationcomppullback_comp_tail`'s `\uses`.
- `AlgebraicGeometry.Scheme.Modules.sheafifyIdOf` (TOS ~L2461, private abbrev) — notation brick; trivial.
- (Backlog: the other ~90 `lean_aux` are pre-existing — `PicSharp.*`, `InternalHom.*`, etc.; surface
  incrementally, not all at once.)

## LOW — hygiene (lean-auditor, all minor; non-blocking)

Defer until a route is otherwise idle; none blocks proving:
- `DualInverse.lean` stale sorry-state docstrings (module head + L797 "currently a `sorry`", L835–837)
  — the file has build *errors*, not `sorry` *keywords*; update once it is repaired.
- TOS dead scaffolding: `iter-230 C-wiring diagnostic` (L620–663), empty `PullbackLanDecomposition`
  (L1244–1249); 100-line iter-history module docstring (L39–140) belongs in the journal.
- Heavy `maxHeartbeats 3200000` bumps (TOS L1718 `pullbackEtaUnitSquare`, L1977 `pullbackTensorMap_natural`)
  — brittleness yellow-flag if surrounding types are refactored.
- Minor blueprint shared-pin: `PicGroup` pinned by both `lem:tensorobj_isoclass_commgroup` and
  `def:pic_carrier` without a `% NOTE:` (the `isLocallyInjective_whiskerLeft_of_W` double-pin is
  already acknowledged with a `% NOTE:`, intentional).

## Do NOT re-assign
- `exists_tensorObj_inverse` (TOS L712) — import-cycle gated; only unblocks after the DUAL chain repairs.
- `comp_tail`, `comp_natTrans`, `comp`, `hδ` — CLOSED this iter; do not reopen.
