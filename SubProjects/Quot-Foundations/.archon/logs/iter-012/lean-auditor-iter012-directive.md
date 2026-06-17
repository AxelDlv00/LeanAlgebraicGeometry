# lean-auditor — iter-012

Audit the four `.lean` files that received prover edits this iteration. Audit the Lean as Lean:
outdated comments, suspect/weakened definitions, dead-end proofs, bad practices, fake statements,
and any `sorry` whose surrounding comment overstates progress.

## Files (absolute paths)
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean

## Focus areas
- FlatBaseChange.lean: three new `sorry` "seam" lemmas (`base_change_mate_unit_value`,
  `_fstar_reindex`, `_gstar_transpose`) and a claimed-proven `base_change_mate_section_identity`
  that depends on them — confirm the dependency is real and no statement was weakened to dodge a
  seam. Also check for stale STATUS comment blocks referencing foreign iteration numbers
  (e.g. iter-234/236/240/241 from a prior project) and any docstring that mislocates a dependency.
- FlatteningStratification.lean: `gf_torsion_reindex` still carries a `sorry`; verify the in-body
  comment chain (a)-(e) and the `set_option ... maxHeartbeats 1000000` raises are honestly
  described and not masking a broken statement.
- GrassmannianCells.lean: 12 new decls, `cocycleCondition` claimed axiom-clean and sorry-free —
  spot-check the cocycle proof is not circular and the private helpers state what they claim.
- QuotScheme.lean: 8 new private power-series helpers; confirm none are `sorry`-bearing and the
  `IsRatHilb` predicate / `ofDiffEq` engine are genuine.

Report per-file checklist + flagged issues with severity. Do NOT propose strategy.
