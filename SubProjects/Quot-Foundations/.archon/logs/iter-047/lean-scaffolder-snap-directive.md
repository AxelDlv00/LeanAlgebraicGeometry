# Scaffold SectionGradedRing.lean (SNAP Layer 1–3)

Target: create NEW file `AlgebraicJacobian/Picard/SectionGradedRing.lean` and wire its import.
Blueprint: `blueprint/src/chapters/Picard_SectionGradedRing.tex` (complete+correct, HARD GATE passed).
All 8 decls already carry `\lean{}` tags in the chapter — use these EXACT names:

- `AlgebraicGeometry.Scheme.Modules.tensorObj`        (`def:sheafTensorObj`, L126)
- `AlgebraicGeometry.Scheme.Modules.tensorPow`        (`def:sheafTensorPow`, L171)
- `AlgebraicGeometry.Scheme.Modules.moduleTensorPow`  (`def:sheafModuleTwist`, L206)
- `AlgebraicGeometry.Scheme.Modules.tensorPowAdd`     (`lem:sheafTensorPow_add`, L224)
- `AlgebraicGeometry.Scheme.Modules.sectionsMul`      (`def:sectionMul`, L294)
- `AlgebraicGeometry.Scheme.Modules.sectionsMul_assoc_unit` (`lem:sectionMul_coherent`, L324)
- `AlgebraicGeometry.sectionGradedRing_gcommSemiring` (`lem:sectionGradedRing_gcommSemiring`, L401)
- `AlgebraicGeometry.sectionGradedModule_gmodule`     (`lem:sectionGradedModule_gmodule`, L460)

## Action
Scaffold each with a `sorry` body and a rich `/- Planner strategy: ... -/` comment carrying the
blueprint mechanism + the Mathlib anchor to use. Faithful signatures from the blueprint prose.
Mathlib anchors (verified present): `PresheafOfModules.monoidalCategory`
(Mathlib.Algebra.Category.ModuleCat.Presheaf.Monoidal), `PresheafOfModules.sheafification`,
`SheafOfModules.unit`, `DirectSum.GCommSemiring` (Mathlib.Algebra.DirectSum.Ring),
`DirectSum.Gmodule` (Mathlib.Algebra.Module.GradedModule). Layer 1 `tensorObj` = objectwise tensor
on `PresheafOfModules` then sheafify — REUSE `PresheafOfModules.monoidalCategory`, do NOT re-derive.

## Constraints
- Imports: `Mathlib.Algebra.Category.ModuleCat.Presheaf.Monoidal`, `Mathlib.Algebra.DirectSum.Ring`,
  `Mathlib.Algebra.Module.GradedModule`, plus the `SheafOfModules`/scheme imports the existing Picard
  files use for `X.Modules` (mirror `AlgebraicJacobian/Picard/QuotScheme.lean`'s header).
- Add `import AlgebraicJacobian.Picard.SectionGradedRing` to root `AlgebraicJacobian.lean`. Keep
  acyclic: SectionGradedRing imports only Mathlib (no project-side imports unless strictly needed).
- Output MUST compile (`lake build AlgebraicJacobian.Picard.SectionGradedRing` green) with only
  `sorry` warnings. DO NOT attempt proofs. Do NOT touch any blueprint file.
