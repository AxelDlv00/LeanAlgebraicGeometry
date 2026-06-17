# lean-auditor directive — iter-224

## Files to audit
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Focus areas
- This file received prover work this iter. Pay extra attention to the declaration
  `PresheafOfModules.internalHomEval` (around line 1457) and its naturality proof body
  (the `erw [...]` + `change` + `naturality_apply`/`restr_map_homMk`/`hom_app_heq` block,
  roughly lines 1460–1500): confirm the proof is genuinely closed (no hidden `sorry`,
  no `admit`, no `native_decide`/`maxHeartbeats` brute force) and that its docstring
  claims match the code.
- Check ALL docstrings/comments edited this iter for accuracy against the actual code —
  in particular the file-header `## Status` block, the `internalHomEval` docstring, and the
  docstrings of `tensorObj_assoc_iso`, `tensorObjOnProduct`, `exists_tensorObj_inverse`.
  A prior iter momentarily wrote false "closed / axiom-clean" docstrings off an empty-diagnostics
  false positive; verify no such overclaim survives.
- The three remaining `sorry`s in this file are at the declarations
  `isLocallyInjective_whiskerLeft_of_W`, `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`.
  Audit their surrounding comments for staleness, not the proofs.
- Note any deprecated-API usage (e.g. `Sheaf.val` deprecation warnings) and `erw` fragility.

Read the file directly. Produce your per-declaration checklist plus a flagged-issues block.
