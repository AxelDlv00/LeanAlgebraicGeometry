Whole-blueprint audit (standard). Per-chapter completeness + correctness checklist.

This iter's prover lanes depend on three chapters being complete+correct (HARD GATE). Pay particular attention to the blocks edited this iter:
- Picard_FlatteningStratification.tex: `lem:gf_qcoh_finite_sections_of_genSections` (NEW G1 base case — verify the a/b/c sub-steps are mathematically sound + detailed enough to formalize; this is the SOLE GF prover target this iter), the GeneratingSections.map engine blocks, and the edited `gf_localGenerators_restrict` / `gf_finiteType_affine_finite_cover_generated`. NOTE: G3 (`lem:gf_flat_locality_assembly`) is NOT a prover target this iter — flag if its stub is too thin for a future dispatch.
- Picard_GrassmannianQuot.tex: `lem:gr_chartQuotientMap_epi` (NEW — verify split-epi proof sketch is formalizable; prover target this iter), `globalUnitSection`/`scalarEnd` infra, `def:scheme_modules_glue` cocycle hypotheses.
- Picard_SectionGradedRing.tex: the crux `lem:isIso_sheafification_whiskerRight_unit` + `cor:sheafTensorObjAssoc` + `lem:sheafTensorPow_add` (SNAP prover targets — confirm still complete+correct) and the 10 new coverage-debt helper blocks.

Report the per-chapter `complete`/`correct` verdict and any must-fix-this-iter findings, plus unstarted-phase proposals as usual.
