# Audit directive — iter-264

Audit the following Lean files as Lean (no strategy bias). Read each in full.

Files (absolute paths):
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

Focus areas:
- Whether newly-claimed-closed declarations are genuinely proved or merely relocate a `sorry`
  into a helper / comment. In particular: `pushPullMap_id` (CechHigherDirectImage.lean),
  `sliceDualTransport.map_smul'` field (DualInverse.lean ~L300+), and the `leftAdjointUniqUnitEta_app`
  recovery brick + tail setup in TensorObjSubstrate.lean.
- Stale in-file status comments / docstrings whose sorry-counts or "DONE/PARTIAL" claims no longer
  match the actual `sorry` positions.
- Dead-end proof scaffolding (typed `sorry` bullets that have drifted from the goal).
- Bad Lean practices (over-broad `simp`, `erw` chains that could be `rw`, unused hypotheses).

Output the standard per-file checklist + flagged-issues block. Report must-fix vs major vs minor.
