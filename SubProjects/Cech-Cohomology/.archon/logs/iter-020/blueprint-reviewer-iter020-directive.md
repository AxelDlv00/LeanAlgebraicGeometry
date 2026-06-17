# Blueprint-reviewer directive — iter-020 (whole blueprint)

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`) per your standard per-chapter
completeness + correctness checklist. Do not scope-limit — the cross-chapter view is the point.

## Context (what changed this iter, for your attention but not to narrow the audit)
The consolidated chapter `Cohomology_CechHigherDirectImage.tex` was edited:
- `lem:cech_free_complex_quasi_iso` was split by an effort-breaker into a 6-link `\uses` chain:
  `lem:quasiIso_of_evaluation`, `lem:cech_free_eval_sectionwise`, `lem:cech_free_eval_empty`,
  `lem:cech_free_eval_prepend_homotopy`, `lem:cech_free_eval_prepend_homotopy_spec`,
  `lem:cech_free_eval_nonempty`. Verify this chain is mathematically complete + correct and that the
  proof sketches now carry enough detail (incl. the Lean packaging pathway) for a prover — the prior
  iter's lean-vs-blueprint-checker flagged the monolithic proof as under-specified; confirm that
  must-fix is resolved.
- New `def:section_cech_module_complex` + `lem:section_cech_module_exact` (P3 L1 step (a), the
  un-localised section Čech module complex `D•` and its positive-degree exactness) were added, plus
  coverage-debt helper bundling into several `\lean{}` lists.

## Gate question
For each chapter, report `complete` + `correct` per axis and list any must-fix-this-iter findings.
I am about to send provers this iter to THREE files, all backed by this consolidated chapter:
- `CechAcyclic.lean` (P3 L1 steps (b)–(d): `def:qcoh_sections_localized`,
  `lem:section_cech_homology_exact`, `lem:cech_acyclic_affine` §section form);
- `FreePresheafComplex.lean` (the new 6-link quasi-iso chain → `lem:cech_free_complex_quasi_iso`);
- `CechBridge.lean` (injective-acyclicity bridging infra under `lem:injective_cech_acyclic`).
State explicitly whether the chapter clears the HARD GATE for these three.

Also surface any `## Unstarted-phase blueprint proposals` as usual.
