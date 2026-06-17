# Lean audit — iter-265 edited files

Audit the Lean code (as Lean, no strategy bias) in these three files, paying
attention to declarations added/edited this iteration:

- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
  (new: `pushPull_unit_mate`; a removed/abandoned `pushPullMap_unit` warm-up + a
   removed `pushforward_unit_eqToHom` private helper — check no dangling refs/stubs)
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean
  (new: `forget_map_pushforward_map`; edits to `sheafificationCompPullback_comp_tail`)
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean
  (new: `dualUnitRingSwapInv`, `dualUnitRingSwapInv_comp_dualUnitRingSwap`,
   `dualUnitRingSwap_comp_dualUnitRingSwapInv`, `isIso_ε_restrictScalars_appIso_hom`,
   `dualUnitRingSwapHom`; edits to `sliceDualTransport` invFun comment recipe)

Focus areas:
- Outdated/contradictory status comments (in-file headers claiming counts/states
  that no longer match the code).
- Suspect definitions: any new lemma whose statement is vacuous, mis-typed, or
  weaker than its name implies; any `sorry` mislabeled as closed.
- Dead-end scaffolding left behind (orphan helpers, removed-decl references).
- Bad Lean practice in the new declarations.

Per-file checklist + flagged-issues block as usual. Report to your task_results file.
