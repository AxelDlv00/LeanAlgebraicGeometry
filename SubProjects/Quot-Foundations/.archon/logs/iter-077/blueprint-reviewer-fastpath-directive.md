# Blueprint-reviewer directive — iter-077 SCOPED fast-path re-review

Same-iter fast-path re-review (sanctioned). Earlier this iter you (slug iter077) flagged two
must-fix gate violations; blueprint-writers have now patched them. Re-audit ONLY these two chapters
and report whether each is now complete + correct with NO remaining must-fix:

1. `blueprint/src/chapters/Picard_GlueDescent.tex` — NEWLY CREATED. Confirm the 5 blocks
   (`def:gr_glue_equalizer`, `lem:glueOverlapBaseChangeIso`, `lem:glueRestrictionHom`,
   `thm:isIso_glueRestrictionHom`, `def:glueRestrictionIso`) cover both Lean sorries (GlueDescent.lean
   L1170, L1207) with formalizable proof sketches, valid `\uses`, and no broken refs.
2. `blueprint/src/chapters/Picard_GrassmannianQuot.tex` — the 6 Nitsure §5 inverse blocks were added
   (`lem:tautologicalQuotient_epi`, `def:isoLocus`, `lem:isIso_pullback_isoLocus_map`, `def:chartLocus`,
   `lem:chartLocus_isOpenCover`, `def:grPointOfRankQuotient`). Confirm they cover the sorries at
   L2065/L2147/L2160/L2249 with formalizable sketches. Also confirm the duplicate `glueRestrictionIso`
   `\lean{}` pin is resolved (the grquot `def:gr_modules_glueRestrictionIso` block now carries NO
   `\lean{}` and `\uses{def:glueRestrictionIso}`; canonical pin is in Picard_GlueDescent.tex).

Verdict per chapter: complete (bool), correct (bool), any must-fix-this-iter. Other chapters are
out of scope for this re-review. Report to your task_results file.
