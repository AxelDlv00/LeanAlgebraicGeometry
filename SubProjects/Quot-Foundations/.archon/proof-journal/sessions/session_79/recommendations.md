# Recommendations — for iter-080 plan

## HIGH — closest-to-completion prover target
1. **GlueDescent `glueChartComponent_leg_compat`** (the ONE residual GlueDescent sorry, @L2081). All
   blueprint-(1)/(2) triple-overlap infrastructure is DONE and compiling; only adjunction/pseudofunctor
   calculus remains (est 200–400 LOC, NO new geometry). Concrete route in
   `task_results/AlgebraicJacobian_Picard_GlueDescent.lean.md` "REMAINING CORE":
   expand `glueChartComponent i p` under `q^*`, use pair mate `glueOverlapFactor_mate (i,p)`, triangle
   identity at `f_ip` through `pullbackComp fst f_ip` casts, then `hC2 i p q` whiskered. Do NOT case-split
   degenerate pairs early. **This unblocks `tautologicalQuotient_epi`** (currently pinned on GlueDescent=0).

## HIGH — blueprint debt that BLOCKS the gate next iter (must dispatch blueprint-writer)
2. **`Picard_GlueDescent.tex` — broken `\uses` + missing blocks.** lean-vs-blueprint-checker glue (major):
   - `\uses{lem:gr_glueData_bridges}` (in `lem:gr_glueChartFamily_equalizes` proof) points at a label that
     has **no `\begin{lemma}`** — add a lemma block for `glueData_bridge_src/mid/tgt` (L66–98) with that label.
   - Add blocks for the ~13 triple-overlap helpers + `glueChartComponent_leg_compat` (1-to-1 debt; currently
     covered in one sentence each). Authoritative dep list in the GlueDescent task result "Needs blueprint entry".
   - **Expand proof item(3) of `lem:gr_glueChartFamily_equalizes`** — it names the destination but omits the
     algebraic path (which unit/counit pairs cancel, the three `glueData_bridge_*` endpoint casts, C1
     degenerate handling). The Lean "REMAINING CORE" comment is more specific than the blueprint; lift it.
3. **`Picard_GrassmannianQuot.tex` — 7 missing `\lean{}` pins + under-specified universal section.**
   lean-vs-blueprint-checker grquot: add `\lean{}` blocks for the 7 iter-079 substantive additions:
   `chartMorphism_glue_compat`, `comp_chartMorphism`, `presentedMatrix_comp`, `chart_point_eq`,
   `universalMatrix_map_presentedMatrix`, `imageMatrix_map_ringHom`, `chartComposite_rqPullback`.
   `def:grPointOfRankQuotient` proof should `\uses{chartMorphism_glue_compat}`. `sec:grquot_universal` needs a
   real sketch of the presentedMatrix/conjPullback infrastructure (~20 lemmas built blueprint-blind this iter).

## MEDIUM — next GrassmannianQuot lane (after blueprint catches up)
4. **`represents` inverse laws** (L4435/4440). Bridge layer (a) `chartComposite_rqPullback` landed. Next:
   `chartLocus_rqPullback : ψ⁻¹ᵁ chartLocus y I ≤ chartLocus (rqPullback ψ y) I` (factor `U.ι≫ψ` through
   `(chartLocus y I).ι`, `isIso_pullback_map_comp` + `pullbackComp` NatIso + `chartComposite_rqPullback`,
   `le_sSup`), then taut-specific layer (c) keyed on `universalQuotient_restrictionIso`. Each 100–300 lines.

## DO NOT RE-ASSIGN
5. **`tautologicalQuotient_epi` (L2470)** — keep pinned until GlueDescent reaches 0 sorries. Gate still closed.
   Assigning it now forces resting on the open `glueChartComponent_leg_compat` sorry.

## LOW — hygiene (no correctness impact)
6. Add inline attribution comments to 3 `set_option maxHeartbeats 800000` blocks in GrassmannianQuot
   (L1020 `matrixEndRect_unitEndSection`, L1059 `pullback_map_freeMap_pullbackFreeIso`, L3842 `chartMatrix_minor`)
   — the rest of the file consistently attributes the X.Modules-diamond cost driver; these three don't.
   (Prover-side cleanup; not a blocker.)

## 1-to-1 coverage debt (unmatched leandag — for the planner to blueprint)
`archon dag-query unmatched` = 133 nodes. New this iter (highest priority — they back the closed/reduced sorries):
- **GlueDescent:** `glueData_triple_square`, `glueData_preimage_image_eq₃`, `glueData_triple_opensFunctor_eq`,
  `glueData_triple_appIso_compat`, `glueTripleBaseChangeIso` (+`_inv_app_app`/`_hom_app_app`), `glueTripleFactorIso`,
  `glueTripleFactor_transpose`, `glueTripleFactor_mate`, `glueLegA_component_transpose`,
  `glueLegB_component_transpose`, `glueChartFamily_pullback_map_π`, `glueChartComponent_leg_compat`.
- **GrassmannianQuot:** `chartMorphism_glue_compat`, `comp_chartMorphism`, `presentedMatrix_comp`,
  `presentedMatrix_congr`, `chartMatrix_eq_presentedMatrix`, `presentedMatrix_submatrix_self`,
  `universalMatrix_map_presentedMatrix`, `matrixMap_nonsing_inv`, `imageMatrix_map_ringHom`,
  `chart_point_eq`, `chartComposite_rqPullback`, `isIso_pullback_map_comp`.
Full dep lists in both task_results "Needs blueprint entry" sections.

## Reusable proof patterns (this session)
- **Pair→triple verbatim transcription**: build triple-overlap lemmas by substituting `ι_j↦f_pq≫ι_p`,
  `t_ij≫f_ji↦τ`, `f_ij↦q` into existing pair-level proofs (compiled first/second try).
- **Post-`rw` diamond escape**: after any `rw` under X.Modules, `simp only [Category.assoc]`/bare instance
  synthesis fail — use `congrArg (· ≫ g) h`, `@CategoryTheory.inv _ _ _ _ (...) hinst`, `IsIso.comp_isIso'`.
- **Unused-`[Field K]` generalization**: copy a `[Field K]` proof verbatim over `CommRing K` when the proof
  never uses field structure (`chart_point_eq`).
- **`rw [hε]` counit-wrapper miss**: when codomain carries `(𝟭 _).obj`, use `(eq_whisker hε _).symm.trans h`.
