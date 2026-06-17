# Lean ↔ blueprint check directive

Verify one Lean file against its blueprint chapter, bidirectionally.

## Lean file (absolute path)
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean

## Blueprint chapter (absolute path)
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(This is the consolidated chapter declaring `% archon:covers` for the Cohomology files. The relevant
blocks for this iter are `lem:qcoh_section_equalizer` and `lem:tile_section_localization`.)

## What to check
- **Lean → blueprint:** Are `qcoh_section_equalizer`, `isLocalizedModule_powers_restrictScalars_of_algebraMap`,
  and `res_trans_apply` faithfully represented in the chapter? Note especially that the Lean
  `qcoh_section_equalizer` is STRICTLY MORE GENERAL than the blueprint statement (arbitrary index `ι` and
  an abstract open cover of `W`, vs the blueprint's basic-open `U i = W ∩ D(gᵢ)`). Is this generalization
  acceptable / does the blueprint need updating? `isLocalizedModule_powers_restrictScalars_of_algebraMap`
  has NO blueprint block yet (a `\uses` for `lem:tile_section_localization` references the descent informally).
- **Blueprint → Lean:** `lem:tile_section_localization` is blueprinted but NOT yet formalized (the prover
  found the planned `restrict_obj`-rfl recipe is unsound — the section comparison is a real ~100-150 LOC
  lemma, not wiring). Is the blueprint's proof sketch for `lem:tile_section_localization` adequate to guide
  the actual formalization, or is it too thin (does it still claim the reconciliation is rfl/wiring)?
- Report any fake/placeholder statements, signature mismatches, or `\lean{}` targets that don't resolve.

## Output
Bidirectional report (Lean→blueprint and blueprint→Lean), red flags + major/minor, with severities.
Write to your task_results file.
