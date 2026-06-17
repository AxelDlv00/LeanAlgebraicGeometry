# lean-vs-blueprint-checker — OpenImmersionPushforward (iter-063)

Lean file: /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean
Blueprint chapter: /home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(consolidated chapter; relevant labels: `lem:pushforward_slice_two_adjunction`,
`lem:pushforward_slice_pullback_iso`, `lem:pushforward_iso_preserves_qcoh`,
`lem:slice_structureSheaf_hom`, `lem:pushforward_iso_qcoh_of_slice_qcoh`, and the slice-equivalence
continuity helpers).

This iter the prover added 6 axiom-clean helpers (`opensMapHomBase_isEquivalence`, `opensEquivOfIso`,
`sliceOversEquiv`, `sliceOversEquiv_functor_isContinuous`, `overPost_slice_inverse_isContinuous`,
`sliceOversEquiv_inverse_isContinuous`) building the slice equivalence + both continuity instances.
Two sorries remain: `hqc` (line ~795) and `_comp` (line ~837). The three downstream decls
(`pushforwardSliceTwoAdjunction`, `pushforwardSlicePullbackIso`, `pushforward_iso_preserves_qcoh`)
are NOT yet in the Lean (still `% NOTE: build target` blocks at ~10011/10064/10125).

Report bidirectionally:
- Lean→blueprint: do the 6 landed helpers have any blueprint coverage? (They are currently `lean_aux`
  unmatched.) Are their `\lean{}` correspondences correct anywhere they ARE referenced?
- Blueprint→Lean: is `lem:pushforward_slice_pullback_iso`'s informal proof mathematically COMPLETE
  enough to formalize the φ''/H₁/H₂ coherence wall? iter-062's checker flagged it as
  mathematically incomplete (unit-module-only). The prover's KEY INSIGHT this iter is that φ'' is
  object-level correction-FREE (the `Over.map (unitIso.inv)` correction affects only H₁/H₂, not the
  object/section level). Does the blueprint reflect this, or does it still under-specify φ''/H₁/H₂?

Write your report under task_results/.
