# Lean-vs-Blueprint Checker directive — iter-250

## File pair (exactly one)

- Lean: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## What changed this iter (for your focus, not as ground truth)

The prover closed the D2′ unit-square residual. New/closed declarations to verify against their
blueprint `\lean{...}` blocks:

- `pullbackEtaUnitSquare`  ↔ `lem:eta_bridge_unit_square`
- `pullbackTensorMap_unit_isIso` ↔ `lem:pullback_tensor_iso_unit`
- `epsilonPresheafToSheafUnit` ↔ `lem:epsilon_presheaf_to_sheaf_unit`
- `presheafUnit_comp_map_eta` ↔ `lem:presheaf_unit_comp_map_eta`
- `restrictScalarsId_map`, `pullbackSheafifyUnitEtaTriangle` — reported as project-local helpers
  with NO blueprint pin; confirm whether that is acceptable or whether they warrant a pin.

## Report bidirectionally

(a) Lean → blueprint: do the Lean signatures/statements match the `\lean{...}` hints and the
    informal statements? Any fake/placeholder/over-claimed statements? Any signature mismatch?
(b) Blueprint → Lean: is the chapter detailed enough to have guided this formalization, or is it
    too thin (especially for the D2′ telescope / unit-square close)? Flag inadequate sections.

Note: do NOT comment on `\leanok` placement (managed by a separate deterministic sync).

## Output

Bidirectional report with any must-fix findings. Write to
`task_results/lean-vs-blueprint-ts250.md`.
