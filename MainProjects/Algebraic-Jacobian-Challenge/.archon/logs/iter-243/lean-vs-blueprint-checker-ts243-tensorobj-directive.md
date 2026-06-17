# lean-vs-blueprint-checker directive — iter-243 (TensorObjSubstrate)

Verify ONE Lean file against ONE blueprint chapter, bidirectionally.

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## What changed this iter (focus)
The prover added two axiom-clean declarations:
- `AlgebraicGeometry.Scheme.Modules.pullbackTensorMap` (~L1220) — the sheaf-level comparison map
  `f^*(M⊗N) ⟶ f^*M ⊗ f^*N` for general `M,N`; pinned in the blueprint as `lem:pullback_tensor_map`
  (`\lean{...pullbackTensorMap}`).
- `AlgebraicGeometry.Scheme.Modules.pullbackValIso` (~L1203) — helper, unpinned.

Two further deliverables were left UN-formalized (no decl, no sorry), each with a blueprint pin:
- `lem:isinvertible_implies_locallytrivial`
  (`\lean{...IsInvertible.isLocallyTrivial}`) — confirmed Mathlib-scale.
- `lem:isinvertible_pullback` (`\lean{...IsInvertible.pullback}`) — blocked on the above.

## Report (bidirectional)
1. Lean → blueprint: does `pullbackTensorMap`'s actual signature/statement match what
   `lem:pullback_tensor_map` claims? Is the statement faithful (general M,N comparison map), not a
   weakened/placeholder version? Is the `\lean{...}` pin name correct?
2. Blueprint → Lean: are `lem:isinvertible_implies_locallytrivial` and `lem:isinvertible_pullback`
   blueprinted in enough detail to guide a future formalization, or are they too thin? Do their
   `\lean{...}` pins point at names that do not yet exist in the Lean file (expected — flag as
   "pinned-but-absent", not as an error, but confirm the names match the intended decls)?
3. Flag any signature mismatch, fake/placeholder statement, or stale `\lean{...}` pin.

Write findings to your task_results report. Mark any must-fix-this-iter items explicitly.
