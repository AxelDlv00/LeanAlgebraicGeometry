# Lean ↔ blueprint check — CechAcyclic.lean

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechAcyclic.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(This consolidated chapter `% archon:covers` CechAcyclic.lean — see header.)

## What to verify
Bidirectional, narrow file-vs-chapter view.

1. The new public theorem `AlgebraicGeometry.sectionCech_homology_exact_of_localizationAway`
   (CechAcyclic.lean ~line 1868) is `\lean{}`-pinned by `lem:affine_cech_vanishing_tilde_subcover`
   (chapter line ~6189). Confirm the Lean STATEMENT matches the blueprint statement (ring `R`, module
   `M`, `f ∈ R`, finite family `g`/`s` with `D(f) = ⨆ D(gᵢ)`, conclusion: `Ȟ^p(~M) = 0` for `p > 0`),
   and that the proof is faithful to the route-B change-of-ring sketch in the blueprint proof block
   (lines ~6225+): instantiate polymorphic `dDiff_exact` over `R_f`, transport via ladder addEquiv.
   It must be a real proof, NOT a placeholder/fake/vacuous statement.

2. These NEW Lean decls have NO blueprint block yet (coverage debt — report as blueprint→Lean gaps,
   the planner will blueprint them next iter): `AwayComparison.isLocalizedModule_comp_away`,
   `SectionCechModule.dDiff_exact_of_localizationAway`, `sectionCechAbExact_loc` (private).
   Confirm whether the chapter has any block the planner intended for these (e.g.
   `lem:away_comparison_isLocalizedModule`, `lem:section_cech_module_exact`) and whether their
   `\lean{}` pins resolve.

3. Flag if the blueprint chapter is too thin to have guided this formalization, or conversely if the
   Lean diverged from the chapter's stated route.

Report Lean→blueprint AND blueprint→Lean findings with must-fix severity tags.
