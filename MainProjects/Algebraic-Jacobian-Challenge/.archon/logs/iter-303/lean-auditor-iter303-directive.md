# lean-auditor directive — iter-303 touched files

Audit the following Lean files as Lean (no strategy context). Report per-file
checklist (outdated comments, suspect definitions, dead-end proofs, bad Lean
practices, commented-out declarations left in place) plus a flagged-issues block.

Pay extra attention to:
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean` — a composition lemma
  (`rawPushPullMap_comp` / `pushPullMap_comp`) was reduced then COMMENTED OUT (a
  large `/- ... -/` block around lines 438–477) because it kernel-times-out. Assess
  whether the four retained helper lemmas (`rawPushPullMap`, `pushPullMap_eq_raw`,
  `pushPull_unit_comp`, `pushforwardComp_hom_app_id`) are well-formed and whether
  the commented-out block + `set_option maxHeartbeats 1000000` on `pushPullMap_eq_raw`
  is acceptable or a smell.
- `AlgebraicJacobian/Picard/FlatteningStratification.lean` — a new
  `GenericFreeness` namespace section (~lines 160–210) with three lemmas, plus the
  pre-existing `genericFlatness` whose `F : X.Modules` binder may be too weak.
- `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean` — new helpers
  `unitRelabelSwap`, `isIso_ε_restrictScalars_presheafMap`, and a now-closed `app`
  component of `sliceDualTransportInv` that carries an `hβ` hypothesis binder.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` — one forward step committed.

Absolute paths to read:
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/FlatteningStratification.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean
