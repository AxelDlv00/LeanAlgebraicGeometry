# lean-vs-blueprint-checker directive — FreePresheafComplex (iter-022)

Verify one Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/FreePresheafComplex.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(consolidated chapter; relevant blocks are `lem:cech_free_eval_sectionwise`,
`lem:cech_free_eval_engine_iso`, `lem:cech_free_eval_prepend_homotopy`,
`lem:cech_free_eval_prepend_homotopy_spec`, `lem:cech_free_eval_nonempty`,
`lem:cech_free_complex_quasi_iso`, `lem:free_cech_engine`.)

## What landed this iter (claimed)
14 axiom-clean decls: `le_coverInterOpen_iff`, `survivingEquiv`, `cechFreeEvalDropZeros`,
`cechFreeEvalEngine_X` (object half of the engine iso), and the entire engine complex
machinery `coverSectionModule`, `cechEngineX`, `cechEngineD`(+`_ι`,`_comp`),
`cechEngineComplex`, `cechEnginePrepend`(+`_ι`,`_spec`), `cechEngineD_exact`.
The named target `cechFreeEvalEngineIso` (= `lem:cech_free_eval_engine_iso`, the
differential comm-square) was NOT built — left as a documented comment block, no sorry.

## Check specifically
- CRITICAL re-leveling: the blueprint block `lem:cech_free_eval_prepend_homotopy` pins
  `\lean{AlgebraicGeometry.cechFreeEvalPrependHomotopy}` and its prose describes the
  homotopy ON THE EVALUATED complex `K(𝒰)_•(V)`. The prover instead built the contraction
  at the ENGINE-complex level (`cechEnginePrepend` on `cechEngineComplex`). Same for
  `_spec` (`cechFreeEvalPrependHomotopy_spec` pinned vs `cechEnginePrepend_spec` built).
  Report this as a Lean↔blueprint mismatch: the pinned names do not exist, and the prose
  level differs from the built decl. State whether the right fix is (a) re-point `\lean{}`
  + re-level the prose to the engine complex, or (b) something else.
- Is the trailing "remaining bottleneck" comment for `cechFreeEvalEngineIso` an honest
  not-built note (no fake statement, no axiom, no placeholder)?
- Coverage: the engine-complex decls (`cechEngineX`, `cechEngineD`, `cechEngineComplex`,
  `cechEngineD_exact`, etc.) are not yet in any `\lean{}` list — report which block each
  attaches to (the prover suggested a new `lem:cech_engine_complex`).
- Blueprint → Lean: is `lem:cech_free_eval_engine_iso` detailed enough to guide the
  remaining comm-square proof, or too thin?

Write your report to task_results/.
