# lean-auditor directive — iter-236

Audit the two `.lean` files that received prover edits this iteration, as Lean,
with no strategy bias. Report outdated comments, suspect/vacuous definitions,
dead-end proof structure, and bad Lean practices.

## Files (absolute paths)
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Focus areas
- StalkTensor.lean: the newly added `revBihom_balanced`, `stalkTensorRev`,
  `stalkTensorRev_germ_tmul`, `germ_tensorObj_map_tmul`, and the bundled
  `stalkTensorIso` (a `LinearEquiv`). Confirm the iso is NON-VACUOUS: that
  `toFun`/`invFun` are the genuine forward/reverse comparison maps and the
  `left_inv`/`right_inv` proofs are real (not closed by a degenerate/trivial
  defeq that would make the two sides equal regardless). Confirm no
  `erw`-shaped proof silently relies on a wrong-carrier coincidence.
- FlatBaseChange.lean: the new `globalSectionsIso_hom_comp_specMap_appTop`,
  `gammaPushforwardIso`, `gammaPushforwardTildeIso`. Confirm these are genuine
  isos at the claimed types (not `eqToIso`-of-`rfl` masking a real gap), and
  check the 2 remaining `sorry` sites (lines ~348, ~370) are honestly scoped.

Read the files at the absolute paths above. Report a per-file checklist plus a
flagged-issues block.
