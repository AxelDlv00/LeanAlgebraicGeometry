# Lean ↔ blueprint check — TensorObjSubstrate (iter-241)

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## What changed this iter
`pullbackUnitIso` (blueprint `lem:pullback_unit_iso`, ~L2827) was closed sorry-free and
axiom-clean, plus 3 bricks (`isIso_pbu_of_final`, `pullbackObjUnitToUnitIso`,
`pullbackObjUnitToUnitIso_hom`). The file sorry count stayed 2 → 2 (the two pre-existing
deferred dual-bridge sorries `exists_tensorObj_inverse` and `addCommGroup_via_tensorObj`).

## Specifically check
- That `\lean{AlgebraicGeometry.Scheme.Modules.pullbackUnitIso}` (L2828) resolves to the
  real decl with matching signature.
- IMPORTANT discrepancy to assess: the blueprint proof of `lem:pullback_unit_iso` describes
  an **affine chart-chase** (see ~L2693, L2908). The prover instead proved it in ONE line
  via representable flatness — `(Opens.map f.base).Final` holds unconditionally, so
  `pullbackObjUnitToUnit f` is iso for every `f`. Report this as a blueprint→Lean
  prose-vs-code mismatch: the chapter's chart-chase proof is now over-engineered relative to
  the actual (much simpler) Lean proof. Recommend whether the blueprint prose should be
  simplified.
- Whether `lem:pullback_tensor_iso` (Phase 2, ~L2622) and `lem:isinvertible_pullback`
  (Phase 3) are still only blueprinted (no Lean decl) — confirm they correctly carry no
  `\lean{}` pin to a non-existent decl.

## Output
Bidirectional report, must-fix-this-iter findings called out. Write to
`task_results/lean-vs-blueprint-checker-tos.md`.
