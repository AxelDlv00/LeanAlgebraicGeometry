# Lean ↔ Blueprint check — FreePresheafComplex.lean (iter-023)

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

## Lean file

/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/FreePresheafComplex.lean

## Blueprint chapter

/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

(This is a consolidated chapter declaring `% archon:covers ... FreePresheafComplex.lean ...`;
the relevant blocks include `lem:cech_free_eval_engine_iso` (\lean{AlgebraicGeometry.cechFreeEvalEngineIso}),
`lem:cech_free_complex_quasi_iso` (\lean{AlgebraicGeometry.cechFreeComplex_quasiIso}),
`lem:cech_engine_complex`, `lem:free_cech_engine`, `lem:cech_free_eval_sectionwise`,
`lem:cech_free_eval_empty`, `lem:cech_free_eval_nonempty`, `lem:cech_free_eval_prepend_homotopy`.)

## What to check

(a) Lean → blueprint: Are the new decls faithful to the blueprint statements? In particular
   `cechFreeEvalEngineIso` (the named (1) target, claimed RESOLVED this iter) — does the Lean
   statement match `lem:cech_free_eval_engine_iso`? Any fake/placeholder/over-claimed statements?
   Note that `cechFreeComplex_quasiIso` is `\lean`-named in the blueprint but is NOT yet built in
   the Lean file (only its prerequisites are) — confirm whether the Lean side has it as a real
   proved decl or it is absent.
(b) Blueprint → Lean: Is the chapter detailed enough to have guided these formalizations? Several
   new helper decls (`cechFreeEvalEngine_comm`, `cechEngineComplex_exactAt`, `cechEngineAug0*`,
   `cechEngineComplexAug`, `freeYonedaEval_iso_of_le_natural`, etc.) are `lean_aux` (no blueprint
   block). Flag which need blueprint coverage and whether the chapter's existing proof sketches
   adequately describe the engine-iso / engine-augmentation route.

Report bidirectionally with must-fix-this-iter findings clearly marked.
