# Blueprint-reviewer directive — iter-021 (HARD GATE, fast path)

Audit the whole blueprint as usual (per-chapter completeness + correctness checklist). The focus this
iter is the consolidated chapter `Cohomology_CechHigherDirectImage.tex`, which a blueprint-writer +
blueprint-clean pass just edited to clear the iter-020 lean-vs-blueprint-checker must-fix/major items.
I need a fresh complete+correct verdict to gate the iter-021 prover dispatch on TWO files:

- `FreePresheafComplex.lean` (chapter blocks: `lem:free_cech_engine`, `lem:cech_free_eval_engine_iso`,
  `lem:cech_free_eval_sectionwise`, `lem:cech_free_eval_empty`, `lem:cech_free_eval_prepend_homotopy`,
  `lem:cech_free_eval_prepend_homotopy_spec`, `lem:cech_free_eval_nonempty`,
  `lem:cech_free_complex_quasi_iso`).
- `CechAcyclic.lean` (chapter blocks: `def:qcoh_sections_localized`, `lem:section_cech_homology_exact`
  and its new 3 sub-lemma children, `lem:cech_acyclic_affine` §section form,
  `def:section_cech_module_complex`, `lem:section_cech_module_exact`).

Specifically confirm these previously-flagged items are now resolved:
1. The free-eval proof sketches no longer reference the PRIVATE `CombinatorialCech.*` names (they
   should now reference the public `FreeCechEngine.*`).
2. The `FreeCechEngine` namespace is now blueprinted (`lem:free_cech_engine`).
3. A differential-match node `lem:cech_free_eval_engine_iso` exists with accurate `\uses{}` and a real
   proof sketch (this is the node that unblocks the churning `cechFreeComplex_quasiIso` route).
4. `lem:section_cech_homology_exact` now references `ShortComplex.ab_exact_iff` (NOT
   `moduleCat_exact_iff`) and is decomposed into a 3-sub-lemma chain with explicit intended signatures.
5. `def:qcoh_sections_localized` now lists `basicOpen_sprod` + `qcohRestriction_eq_comparison`.

Report per-chapter `complete:` / `correct:` and any must-fix-this-iter findings. The four new
to-be-built `\lean{}` names (`cechFreeEvalEngineIso`, `sectionCechProductEquiv`, `sectionCechCofaceMatch`,
`sectionCechAbExact`) are intentional prover targets that do not yet exist in Lean — their absence is
NOT a defect.
