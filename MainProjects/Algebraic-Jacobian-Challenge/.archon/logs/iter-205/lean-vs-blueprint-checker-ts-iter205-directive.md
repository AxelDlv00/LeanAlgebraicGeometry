# Lean ↔ Blueprint Checker Directive

## Slug
ts-iter205

## Lean file
AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Blueprint chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Known issues
- Four typed-`sorry` bodies are KNOWN scaffold stubs from the Lane TS body-fill
  effort: `monoidalCategory` (L150), `tensorObj_restrict_iso` (L249),
  `exists_tensorObj_inverse` (L300), `addCommGroup_via_tensorObj` (L339).
  Report their blueprint correspondence, but they are not new regressions.
- Two new `noncomputable def`s were added this iter in a project-local Mathlib
  supplement section near the end of the file:
  `isMonoidal_W_of_whiskerLeft` and `monoidalCategoryOfIsMonoidalW`. The prover
  stated these are project-local Mathlib infrastructure and are NOT `\lean{...}`
  -pinned blueprint declarations. Confirm whether the chapter's
  `thm:scheme_modules_monoidal` proof sketch now adequately previews this
  transport + reduction decomposition, or whether the chapter is under-specified
  relative to what the Lean now contains.
