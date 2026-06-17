# Lean ↔ Blueprint Checker Directive

## Slug
ts-iter206

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Known issues
- The file currently carries 3 typed `sorry` bodies (on `tensorObj_restrict_iso`, `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`). These are acknowledged scaffold/blocked decls — do NOT report the bare presence of these sorries as new must-fix findings; instead assess whether the blueprint adequately guides their closure.
- Pay PARTICULAR attention to `lem:tensorobj_restrict_iso` (chapter §L329–380). The chapter was rewritten this iter to claim its proof is "elementary flat-exactness already available in Mathlib" for line bundles. The prover, however, reported (task_results/Picard_TensorObjSubstrate.lean.md and informal/tensorObj_restrict_iso.md) that the comparison MAP itself is missing — `PresheafOfModules.pullback φ` is an abstract left adjoint with no sectionwise formula, so flatness does NOT shortcut the construction (it only upgrades an already-existing map to an iso). I need your independent bidirectional judgement: is the blueprint's flat-exactness proof sketch actually formalizable as written, or does the chapter's proof omit the comparison-map construction step the Lean code clearly needs? Report this as a blueprint-adequacy assessment (Lean→blueprint AND blueprint→Lean), not just a Lean red flag.
- `lem:tensorobj_restrict_iso` has NO `\lean{...}` pin (the decl name `AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso` is named only in prose). Note whether you'd recommend adding the pin.
