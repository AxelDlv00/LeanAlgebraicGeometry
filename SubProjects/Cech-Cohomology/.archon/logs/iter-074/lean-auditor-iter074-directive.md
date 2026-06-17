## Files to audit
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechSectionIdentification.lean
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechSectionIdentificationBase.lean

## Focus
- These three files were just split from one large file and heavily edited (67 edits this iter).
- Pay extra attention to: heartbeat-bumped proofs (`set_option maxHeartbeats`), thin-category
  `eqToHom`/`Subsingleton.elim` fusions, and any `have key := ... ; exact key` kernel-defeq tricks —
  confirm they are not masking unsound rfl-terms (the LSP accepts terms `lake env lean` rejects).
- Flag dead code, outdated comments referencing the pre-split single file, and any `sorry` besides
  the one known residual `pushPull_interLegHom_sections` (Leg ~line 1012).

## Out of scope
- No strategy framing. Audit the Lean as Lean.
