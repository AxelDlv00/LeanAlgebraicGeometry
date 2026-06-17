# Blueprint-writer directive — GR/glue coverage debt, iter-067 (gr-coverage2)

Chapter: `blueprint/src/chapters/Picard_GrassmannianQuot.tex`.

## Task 1 — execute the queued iter-065 directive
READ AND EXECUTE Task 1 of `.archon/logs/iter-065/blueprint-writer-gr-coverage-directive.md`
(22 unmatched decls, full per-decl instructions there). Before writing each block, grep the
chapter — some may already be covered.

## Task 2 — addendum: iter-066 prover decls (all project-bespoke, no % SOURCE lines unless noted)
Same rules: faithful statement + `\label` + `\lean{}` + accurate `\uses{}` + informal proof
(one-liners fine for glue/cast helpers; substantive sketches for the sorry-bearing ones).
Derive real `\uses{}` by reading each decl in the Lean source. The decls live in
`AlgebraicJacobian/Picard/GrassmannianQuot.lean` — but a concurrent refactor may move the
`Scheme.Modules` ones to `AlgebraicJacobian/Picard/GlueDescent.lean` mid-phase; grep BOTH files.
Dependency notes: `## Needs blueprint entry`/`## Markers` sections of
`.archon/logs/iter-066/task_results-archive/AlgebraicJacobian_Picard_GrassmannianQuot.lean.md`
and the keystone docstring on `isIso_glueRestrictionHom`.

`AlgebraicGeometry.Scheme.Modules.`: glueProd, glueOverlapProd, glueLegA, glueLegB,
glueIsoEqualizer, glueProj, glueLift_glueProj, glueLift_cond_iff, glueRestrictionHom,
pullback_map_glueLift_glueRestrictionHom, restrictFunctor_isRightAdjoint,
restrictFunctor_preservesLimits, pullback_preservesLimits_of_isOpenImmersion,
glueData_preimage_image_eq, glueData_overlap_opensFunctor_eq, glueOverlapBaseChangeIso,
glueRestrictEqualizerIso, glueRestrictProdIso, isIso_glueRestrictionHom (SUBSTANTIVE — the
effective-descent keystone; transcribe the proof route from its Lean docstring),
homEquiv_comp_pushforwardCongr, homEquiv_comp_unit_pushforwardComp,
pullbackComp_inv_app_free_map, pullbackCongr_hom_app_free, pullbackCongr_inv_app_free,
pullbackFreeIso_inv_congr, pullbackFreeIso_inv_congr_hom.

`AlgebraicGeometry.Grassmannian.`: ιFree_matrixEndRect, biproduct_matrix_comp_rect,
chartQuotientMap_eq_matrixEndRect, matrixToFreeIso_inv, universalQuotient_restrictionIso,
universalQuotient_isLocallyFreeOfRank, tautologicalRankQuotient, tautologicalQuotient_epi
(SUBSTANTIVE — route in Lean docstring), grPointOfRankQuotient (SUBSTANTIVE — Nitsure §5
chart-loci inverse; the Lean docstring has the route; cite Nitsure only if you read
`references/nitsure-hilbert-quot-src/*.tex` and quote verbatim, else leave bespoke),
grPointOfRankQuotient_rel.

## Task 3 — reconciliation
- The effort-breaker's rectangular blocks (`def:gr_matrixEndRect`, `lem:gr_matrixEndRect_*`,
  ~L1381ff) may carry `\lean{}` pins that don't match the actually-landed Lean names —
  reconcile each pin to the real decl (grep the Lean file).
- Forward-decl blocks: `def:gr_modules_glueRestrictionIso` is now REALISED
  (`AlgebraicGeometry.Scheme.Modules.glueRestrictionIso`) — remove its stale
  "forward declaration / not yet realised" NOTE text. `def:gr_modules_glueHom`: if
  `Scheme.Modules.glueLift` faithfully realizes it, repoint its `\lean{}` to glueLift (per the
  iter-065 directive item 3). `lem:gr_modules_glue_unique` stays unrealized (it is next
  iter's joint-faithfulness target) — ensure its statement + `\uses{}` are complete.

EXCLUDE: every `private` decl (the SNAP ULift helpers in SectionGradedRing.lean are NOT yours).
NEVER add or remove `\leanok`. Keep `\uses{}` labels resolving (grep before citing).
