# Refactor directive — break the TensorObjSubstrate ↔ RelPicFunctor import cycle (iter-247)

## Goal
Break the import cycle that currently forces `Picard/TensorObjSubstrate.lean` to import
`Picard/RelPicFunctor.lean`. After this refactor, the dependency must flow ONE way:

  LineBundlePullback → TensorObjSubstrate → RelPicFunctor

so that `RelPicFunctor.lean` is *downstream* of the tensor substrate and can cite the real upstream
decls (`tensorObj`, `tensorObj_assoc_iso`, `tensorObj_isLocallyTrivial`, `tensorObj_braiding`,
`tensorObj_left_unitor`, `tensorObj_right_unitor`, `tensorObj_unit_iso`, `exists_tensorObj_inverse`,
`pullbackUnitIso`, the comparison-iso machinery) directly.

## Why this is safe (verified by the planner)
- The ONLY reason `TensorObjSubstrate.lean:9` imports `RelPicFunctor` is two declarations:
  `tensorObjOnProduct` (≈L706) and `addCommGroup_via_tensorObj` (≈L1532). They are the only decls in
  the whole file that reference `RelPicFunctor`'s `LineBundle.OnProduct` / `RelPicPresheaf.preimage_subgroup`.
- BOTH are currently DEAD: `tensorObjOnProduct` is used nowhere (only its own def line);
  `addCommGroup_via_tensorObj` is used nowhere (only prose comments). Grep-confirmed.
- Nothing in `RelPicFunctor.lean` currently references any `TensorObjSubstrate` decl (only prose
  comments mention them), so adding the reverse import introduces no cycle.

## Exact changes

### 1. `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- DELETE the import line `import AlgebraicJacobian.Picard.RelPicFunctor` (line 9).
- MOVE the definition `tensorObjOnProduct` (≈L706–722, signature
  `noncomputable def tensorObjOnProduct {S C T : Scheme.{u}} (πC : C ⟶ S) (πT : T ⟶ S) (L L' : LineBundle.OnProduct πC πT) : LineBundle.OnProduct πC πT`)
  OUT of this file and INTO `RelPicFunctor.lean` (see step 2). Preserve its body verbatim.
- DELETE the definition `addCommGroup_via_tensorObj` (≈L1532 to its `end`/EOF). It is an obsolete
  dead stub (a `def` whose body is `sorry`); the live `PicSharp.addCommGroup` now lives in
  `RelPicFunctor.lean`. Removing it lowers the file's sorry count by 1.
- Update/trim the stale file-header comments that reference the two removed decls
  (TensorObjSubstrate.lean lines ≈44, 51, 79, 115 mention `addCommGroup_via_tensorObj` /
  `tensorObjOnProduct` as in-file). Replace with a one-line note that these now live downstream in
  `RelPicFunctor.lean`. Do NOT rewrite unrelated header prose.

### 2. `AlgebraicJacobian/Picard/RelPicFunctor.lean`
- ADD the import `import AlgebraicJacobian.Picard.TensorObjSubstrate` (alongside the existing
  `import AlgebraicJacobian.Picard.LineBundlePullback`).
- INSERT the moved `tensorObjOnProduct` definition at an appropriate place AFTER `LineBundle.OnProduct`
  is in scope (it cites the now-upstream `tensorObj`). Keep its body verbatim; it should typecheck once
  `tensorObj` resolves from the upstream import. If any name no longer resolves after the move, insert a
  `sorry` at that exact site (do NOT invent a proof) and note it in your report — but it is expected to
  resolve cleanly since `tensorObj` is now importable.
- DO NOT otherwise modify the existing `PicSharp.addCommGroup` body or its four local typed-`sorry`
  bridges / local `private` substrate copies (`pTensor`, `pAssoc`, `pLeftUnitor`, …). Those are the
  prover's to rewire next; your job is purely the structural import-flip + decl move.

### 3. `AlgebraicJacobian.lean`
- Reorder the Picard import block so `TensorObjSubstrate` is imported BEFORE `RelPicFunctor`
  (currently line 20 = RelPicFunctor, line 21 = TensorObjSubstrate — swap them, keeping all other
  imports). The new order: `... LineBundlePullback`, `TensorObjSubstrate`, `RelPicFunctor`, `...`.

## Constraints
- Do NOT fill any proof. Do NOT touch `.tex` blueprint files.
- Insert `sorry` ONLY at a genuinely broken proof site created by the move; never to "simplify".
- Preserve all protected signatures verbatim (check `archon-protected.yaml`).
- After the edits, run `lake build AlgebraicJacobian.Picard.RelPicFunctor` (and
  `lake build AlgebraicJacobian.Picard.TensorObjSubstrate`) and report the result. The build MUST be
  green (modulo the pre-existing `exists_tensorObj_inverse` sorry in TensorObjSubstrate and the
  pre-existing `PicSharp.addCommGroup` bridge sorries in RelPicFunctor — those are not yours to close).
- Report: the exact decls moved/deleted, the final import lines of all three files, the sorry count
  delta per file, and the build status.
