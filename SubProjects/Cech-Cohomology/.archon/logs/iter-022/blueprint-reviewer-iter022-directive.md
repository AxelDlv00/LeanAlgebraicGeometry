# Blueprint-reviewer directive — iter-022 (whole blueprint, HARD GATE)

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`), per-chapter completeness +
correctness checklist as usual. This iter's HARD GATE decision concerns two prover lanes, both
backed by the consolidated chapter `Cohomology_CechHigherDirectImage.tex`:

1. `AlgebraicJacobian/Cohomology/CechAcyclic.lean` — the chapter's section-Čech blocks were just
   edited (blueprint-writer `cofacematch` + blueprint-clean `iter022`): `lem:section_cech_coface_match`
   decomposed into a new abstract-unfold sub-lemma `lem:section_cech_objd_apply` + an explicit
   two-layer (abstract / tilde-bridge) coface-match proof; `lem:section_cech_ab_exact` recast to
   precursor (`sectionCech_isZero_homology_of_objD_exact`) + ladder-transport
   (`Function.Exact.of_ladder_addEquiv_of_exact`) form; the five previously-unmatched `\lean{}` decls
   wired in. Confirm: are `lem:section_cech_objd_apply`, `lem:section_cech_coface_match`,
   `lem:section_cech_ab_exact`, `lem:section_cech_homology_exact`, `lem:cech_acyclic_affine` (§section
   form) now complete + correct, with proof sketches detailed enough to formalize the tilde-bridge
   (per-coordinate `IsLocalizedModule` iso + naturality square) and the ladder transport?

2. `AlgebraicJacobian/Cohomology/FreePresheafComplex.lean` — its blocks
   (`lem:cech_free_eval_engine_iso`, `lem:cech_free_eval_sectionwise`, `_empty`, `_prepend_homotopy`,
   `_prepend_homotopy_spec`, `_nonempty`, `lem:cech_free_complex_quasi_iso`, `lem:free_cech_engine`)
   were cleared complete+correct at iter-021 and are unchanged this iter. Re-confirm they still clear
   the gate (no regression, `\uses` intact).

Report per-chapter `complete:` / `correct:` verdicts and any must-fix-this-iter findings. Also report
your usual `## Unstarted-phase blueprint proposals` if any strategy phase lacks coverage.
