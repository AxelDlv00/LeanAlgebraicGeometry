# Lean ↔ Blueprint Checker Directive

## Slug
basicopencech-iter108

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/BasicOpenCech.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Cohomology_MayerVietoris.tex

## Known issues
- Iter-108 introduced a `-- DEFERRED (budget): ...` annotation at L1846 (replacing the bare `sorry`) per strategy-critic-iter108 CHALLENGE on labelling. Mathlib name citations inside the annotation: `IsLocalizedModule.Away`, `IsLocalizedModule.pi`, `IsLocalizedModule.prodMap`, `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid`. Audit whether the annotation prose matches the blueprint's Cohomology_MayerVietoris.tex Step 2 sub-block (a labelled "Implementation status (iter-108 escape-valve)" remark added this iter at the chapter side).
- Inline iter-108 + iter-109 narrative scaffolding at L1786-L1834 (5 `have`s: `h_V_le_U`, `h_slice_eq`, `h_pi_eq_inf'`, `h_V_affine`, `h_isLoc`) is preserved as inert infrastructure. The blueprint's Step 2 was expanded this iter by `blueprint-writer mv-step2` to preview the four Mathlib API pieces by name; audit whether the Lean scaffolding matches the blueprint's enumerated substeps (i)-(iv) by name.
- `cechCofaceMap_pi_smul` at L1062-L1120 has a PAUSED partial-proof scaffold (iter-105/107). Skip auditing this slot for blueprint alignment unless a divergence is glaring; the blueprint side correctly describes the *target* (the lemma's statement) but not the iter-107 partial-tactic-state preserved in the proof body.
- Carry-over from iter-107 lean-vs-blueprint-checker: PASS verdict with 1 minor "soon" item (now addressed via this iter's blueprint-writer mv-step2). Verify the iter-108 expansion actually closed that gap.
