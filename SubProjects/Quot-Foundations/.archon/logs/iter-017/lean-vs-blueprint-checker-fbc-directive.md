# Lean ↔ Blueprint Checker Directive

## Slug
fbc

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Known issues
- The Seam-2 work this iter introduced 5 new declarations that do NOT yet have `\lean{}` pins:
  `base_change_mate_codomain_read_legs`, `base_change_mate_fstar_reindex_legs`,
  `gammaMap_pushforwardComp_hom_eq_id`, `gammaMap_pushforwardComp_inv_eq_id`,
  `gammaMap_pushforwardCongr_hom`. These are known coverage debt (already slated for the planner to
  blueprint next iter) — report them under blueprint adequacy / coverage, but they are expected.
- Remaining open `sorry`s are expected scaffolding: the step-(iii) mate-unwinding crux inside
  `base_change_mate_fstar_reindex_legs`, Seam-3 `base_change_mate_gstar_transpose`, the affine
  reduction, and FBC-B. Focus on whether the chapter's Seam-2 decomposition (steps i/ii/iii)
  faithfully describes the landed `…_legs` decomposition, and whether the concrete
  `base_change_mate_fstar_reindex` reduction-to-`…_legs` matches the chapter.
- Pervasive predecessor-project iter-NNN STATUS comments are provenance noise, not your concern.
