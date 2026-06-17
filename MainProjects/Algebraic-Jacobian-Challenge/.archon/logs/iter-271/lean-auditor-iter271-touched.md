# lean-auditor directive — iter-271 touched files

Audit the three `.lean` files edited this iteration as Lean code (no strategy bias).
Report per-file: outdated/misleading comments, suspect definitions, dead-end proof
scaffolding, bad Lean practices, and any declaration that claims more than it proves.

Files (absolute paths):
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

Focus areas:
- New top-level declarations added this iter: `AlgebraicGeometry.pushPull_transport_cancel`
  (CechHigherDirectImage) and `AlgebraicGeometry.Scheme.Modules.sliceDualTransportInv`
  (DualInverse). Confirm their stated signatures match what their bodies actually establish,
  and that `sliceDualTransportInv` (which still contains `sorry` in its `app`/`naturality`)
  is honestly documented as partial rather than presented as complete.
- Large in-file comment blocks describing "remaining route" / "breakthrough" — check they
  are accurate and not laundering a sorry as done. In particular the `pushPullMap_comp`
  block in CechHigherDirectImage describes a route but adds no declaration.
- The `sheafificationCompPullback_comp_tail` scaffolding in TensorObjSubstrate (a `have hwr`
  device + a retained `sorry`): confirm the proof body compiles and the sorry is genuinely scoped.
- Any `eqToHom` / `erw` transport bookkeeping that could be silently wrong.

Output a per-file checklist plus a flagged-issues block (CRITICAL/HIGH/MEDIUM/LOW).
