# lean-vs-blueprint-checker — GlueDescent

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GlueDescent.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GlueDescent.tex

## Check
Bidirectional. This iter the keystone `isIso_glueRestrictionHom` body was completed
and reduced to 2 named sorries (glueChartFamily_equalizes, glueOverlapFactor_transpose);
~20 new helper decls landed (appLE_congr_mor, glueData_overlap_appIso_compat,
glueOverlapFactorIso, glueChartComponent/Family, glueRestrictionInv, glueRestrict_*,
glueChartComponent_self_counit, glueRestrictionHom_glueChartComponent,
glueOverlapFactor_mate, pullback_map_jointly_faithful). Verify: (a) Lean statements
match the chapter's informal claims, no fake/placeholder statements; (b) chapter has
the level of detail the proof needed, or flag it as too thin; (c) whether the ~20 new
helpers have blueprint coverage or are uncovered (1-to-1 debt).
