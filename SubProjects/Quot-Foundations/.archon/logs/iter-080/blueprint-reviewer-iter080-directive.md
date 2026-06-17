# Blueprint review — iter 080 (whole blueprint)

Audit the ENTIRE blueprint at `blueprint/src/chapters/*.tex`. Per-chapter completeness +
correctness checklist as usual. No scope limit — the cross-chapter view is the point.

Focus questions to answer explicitly (they gate this iter's prover dispatch):

1. **`Picard_GlueDescent.tex`** — is the proof sketch of `lem:gr_glueChartFamily_equalizes`
   item (3) (the residual sorry `glueChartComponent_leg_compat`: the C2 cocycle applied at the
   triple `(i,p,q)` after expanding `glueChartComponent` and cancelling unit/counit pairs)
   detailed enough to formalize? The undefined `\uses{lem:gr_glueData_bridges}` (referenced at
   L513/522/556, no block exists) — confirm it is a broken ref. Are the ~13 new triple-overlap
   helpers (`glueData_triple_square`, `glueData_preimage_image_eq₃`, `glueTripleBaseChangeIso`,
   `glueTripleFactor_transpose/_mate`, `glueLegA/B_component_transpose`, …) blueprinted?

2. **`Picard_GrassmannianQuot.tex`** — is `sec:grquot_universal` detailed enough to formalize
   `represents.left_inv` / `right_inv` (the two inverse laws, needing chart-locus pullback
   comparison + the tautological-quotient chart-locus identification keyed on
   `universalQuotient_restrictionIso`)? Are the 7 iter-079 additions (`chartMorphism_glue_compat`,
   `comp_chartMorphism`, `presentedMatrix_comp`, `chart_point_eq`,
   `universalMatrix_map_presentedMatrix`, `imageMatrix_map_ringHom`, `chartComposite_rqPullback`)
   and `tautologicalRankQuotient`, `universalQuotient_restrictionIso` pinned?

3. **`Cohomology_FlatBaseChange.tex`** (covers FlatBaseChange + FlatBaseChangeGlobal) — is
   `thm:fbcb_global_direct` (FBC-B DIRECT route: per-chart Stacks 01I9 identification of the
   base-changed legs with `g'^*F`, assembling `baseChangeGammaPullbackEquiv`, then discharging the
   named `flatBaseChange_pushforward_isIso` + `affineBaseChange_pushforward_iso` bodies) complete +
   correct enough to scaffold+prove THIS iter? This is the queued ACTIVE route — verdict decides
   whether it becomes a lane now.

Also report: FlatteningStratification isolated `lem:mathlib_*` nodes status; any other chapter with
must-fix gaps. Include your `## Unstarted-phase blueprint proposals` section.
