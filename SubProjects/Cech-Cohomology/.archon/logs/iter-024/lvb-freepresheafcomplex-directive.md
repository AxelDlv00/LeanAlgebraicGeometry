# lean-vs-blueprint-checker directive — FreePresheafComplex (iter-024)

Verify one Lean file against its blueprint chapter, bidirectionally.

## Lean file
`/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/FreePresheafComplex.lean`

## Blueprint chapter
`/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(consolidated chapter; declares `% archon:covers ... FreePresheafComplex.lean`. Relevant nodes:
`lem:cech_free_complex_quasi_iso` `\lean{AlgebraicGeometry.cechFreeComplex_quasiIso}` ~line 2320;
`lem:cech_free_eval_nonempty`; `lem:cech_engine_complex`; `lem:cech_free_eval_engine_iso`.)

## What landed this iter
- `AlgebraicGeometry.cechFreeComplex_quasiIso` — THE named target (the multi-iter P3b bottleneck):
  the free Čech complex augmentation is a quasi-isomorphism / free resolution of `O_𝒰`. Built
  axiom-clean this iter.
- 10 new helpers: `cechEngineAug0_split`, `cechEngineComplexAug_f_zero`,
  `cechEngineComplexAug_quasiIso`, `cechFreeAug_eval_eq` (private), `epi_cechEngineAug0` (private),
  `coverStructurePresheafEval_iso`, `cechFreeEvalEngineIso_hom_f` (private),
  `coverStructurePresheafEval_iso_hom` (private), `cechFreeEval_quasiIso_of_nonempty`.

## Checks
- Does `cechFreeComplex_quasiIso`'s Lean statement faithfully realize
  `lem:cech_free_complex_quasi_iso`? Is the resolution claim genuine (augmentation is a real
  QuasiIso over all opens via `quasiIso_of_evaluation`), not a trivial/weakened form?
- Bidirectional: is the chapter detailed enough to have guided this proof? Flag any
  fake/placeholder statements or signature mismatches with the `\lean{}` pins.
- Note new non-private declarations lacking a blueprint entry (coverage debt) — informational.
