# Lean Auditor directive — iter-250

## Files to audit

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

This is the only `.lean` file modified this iter.

## Focus areas

Audit as Lean, with no bias toward what the proof "should" achieve. Pay extra attention to the
region roughly lines 1500–1856 (the new declarations and the inline assembly added this iter):

- `restrictScalarsId_map`, `epsilonPresheafToSheafUnit`, `pullbackSheafifyUnitEtaTriangle`,
  `presheafUnit_comp_map_eta`, `pullbackEtaUnitSquare`, `pullbackTensorMap_unit_isIso`.

Specifically check and report on:
1. Whether `pullbackEtaUnitSquare` and `pullbackTensorMap_unit_isIso` are GENUINELY closed (no
   hidden `sorry`, no `admit`, no `native_decide`/`decide` laundering, no axiom-shimmed escape).
2. The `set_option maxHeartbeats 3200000` (pullbackEtaUnitSquare) and `1600000`
   (pullbackSheafifyUnitEtaTriangle) and `backward.isDefEq.respectTransparency false`
   (epsilonPresheafToSheafUnit) — are these reasonable, or do they mask a fragile/incorrect proof?
   Flag any proof whose correctness depends on a non-standard `set_option`.
3. `erw` usage in `pullbackEtaUnitSquare` (the final `erw [Category.assoc, ← Functor.map_comp, ...]`
   chain) — is it load-bearing in a fragile way (keyed-defeq tolerance) that could silently break?
4. Any dead/unused declarations, stale or now-false docstrings/comments (the module-status block was
   reportedly updated this iter — verify it is accurate), and excuse-comments.
5. The remaining `sorry` at the `exists_tensorObj_inverse` declaration (~line 705) — is it cleanly
   guard-railed/documented, or is it presented misleadingly?

## Output

Per-file checklist + flagged-issues block. Mark any finding must-fix / major / minor.
Write your report to `task_results/lean-auditor-ts250.md`.
