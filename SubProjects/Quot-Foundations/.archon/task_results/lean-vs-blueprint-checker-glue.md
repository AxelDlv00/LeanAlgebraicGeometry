# Lean ↔ Blueprint Check Report

## Slug
glue

## Iteration
080

## Files audited
- Lean: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GlueDescent.lean` (3409 lines)
- Blueprint: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GlueDescent.tex` (1268 lines)

---

## Per-declaration

All 43 `\lean{...}` blocks in `Picard_GlueDescent.tex` were checked. The chapter also
cross-references declarations whose `\lean{}` pins live in `Picard_GrassmannianQuot.tex`;
those cross-chapter references are validated separately in the "Unreferenced declarations"
section.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueProd}` (chapter: `def:gr_glue_equalizer`)
- **Lean target exists**: yes (line 940)
- **Signature matches**: yes — noncomputable def, the product `∏ᵢ (ιᵢ)_∗ Mᵢ` over the glued scheme, as described
- **Proof follows sketch**: N/A (definition body)
- **notes**: statement block has `\leanok` ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueOverlapBaseChangeIso}` (chapter: `lem:glueOverlapBaseChangeIso`)
- **Lean target exists**: yes (line 1178)
- **Signature matches**: yes — iso `(ιⱼ)_∗ ⋙ restrictFunctor ιᵢ ≅ restrictFunctor (tᵢⱼ ∘ fⱼᵢ) ⋙ (fᵢⱼ)_∗`
- **Proof follows sketch**: yes — 4-factor construction via `appLE_congr_mor` + `glueData_overlap_appIso_compat`
- **notes**: both `\leanok` markers present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrictionHom}` (chapter: `lem:glueRestrictionHom`)
- **Lean target exists**: yes (line 1042)
- **Signature matches**: yes — the hom-equiv adjoint transpose of the collection of `glueProj` maps
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_glueRestrictionHom}` (chapter: `thm:isIso_glueRestrictionHom`)
- **Lean target exists**: yes (line 3347)
- **Signature matches**: yes — `IsIso (glueRestrictionHom D M g)` for cocycle-satisfying input
- **Proof follows sketch**: yes — uses `glueRestrictEqualizerIso` (left leg) and `glueRestrictionInv` (right leg), exactly as sketched
- **notes**: both `\leanok` markers present ✓; this is the main theorem of the chapter

### `\lean{AlgebraicGeometry.Scheme.Modules.appLE_congr_mor}` (chapter: `lem:gr_appLE_congr_mor`)
- **Lean target exists**: yes (line 1143)
- **Signature matches**: yes — `appLE_congr_mor` reindexes an `appLE` along a commutative square of morphisms
- **Proof follows sketch**: yes — `dsimp` + `erw` + `rfl`
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueData_overlap_appIso_compat}` (chapter: `lem:gr_overlap_appIso_compat`)
- **Lean target exists**: yes (line 1155)
- **Signature matches**: yes — compatibility of `appIso` with the overlap pullback square
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueOverlapBaseChangeIso_inv_app_app}` (chapter: `lem:gr_overlapBaseChange_inv_app`)
- **Lean target exists**: yes (line 1256)
- **Signature matches**: yes — component formula for the inverse app
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueOverlapBaseChangeIso_hom_app_app}` (chapter: `lem:gr_overlapBaseChange_hom_app`)
- **Lean target exists**: yes (line 1265)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{...glueData_bridge_src, ...glueData_bridge_mid, ...glueData_bridge_tgt}` (chapter: `lem:gr_glueData_bridges`)
- **Lean target exists**: yes — all three at lines ~70–99, fully proved
- **Signature matches**: yes — three identities on the triple overlap V_ijk as described (source, middle, target legs)
- **Proof follows sketch**: yes — source uses pullback universality, middle uses `t'_ijk` factorisation, target combines involutivity + cocycle
- **notes**: **`\leanok` MISSING on both statement and proof blocks** — the three Lean declarations compile cleanly (0 sorry, file is axiom-clean since iter-056); `sync_leanok` missed this triple-declaration block. This is a major sync miss; see Severity summary.

### `\lean{AlgebraicGeometry.Scheme.Modules.glueData_triple_square}` (chapter: `lem:gr_glueData_triple_square`)
- **Lean target exists**: yes (line 1291)
- **Signature matches**: yes — commutativity of the triple-overlap base-change square
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueData_preimage_image_eq₃}` (chapter: `lem:gr_glueData_triple_preimage`)
- **Lean target exists**: yes (line 1305)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueData_triple_opensFunctor_eq}` (chapter: `lem:gr_glueData_triple_opensFunctor_eq`)
- **Lean target exists**: yes (line 1346)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueData_triple_appIso_compat}` (chapter: `lem:gr_glueData_triple_appIso_compat`)
- **Lean target exists**: yes (line 1358)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueTripleBaseChangeIso}` (chapter: `lem:gr_glueTripleBaseChangeIso`)
- **Lean target exists**: yes (line 1379)
- **Signature matches**: yes — triple-overlap base-change iso, the C2 analogue of `glueOverlapBaseChangeIso`
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueTripleBaseChangeIso_inv_app_app}` (chapter: `lem:gr_glueTripleBaseChangeIso_inv_app`)
- **Lean target exists**: yes (line 1409)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueTripleBaseChangeIso_hom_app_app}` (chapter: `lem:gr_glueTripleBaseChangeIso_hom_app`)
- **Lean target exists**: yes (line 1420)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.restrictAdjunction_unit_app_iso}` (chapter: `lem:gr_restrictAdjunction_unit_iso`)
- **Lean target exists**: yes (line 1443)
- **Signature matches**: yes — `@[reassoc]` lemma identifying the adjunction unit with the `restrictFunctorIsoPullback` component
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.restrictFunctorIsoPullback_hom_app_counit}` (chapter: `lem:gr_restrictIsoPullback_counit`)
- **Lean target exists**: yes (line 1453)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackCongr_hom_app_eqToHom}` (chapter: `lem:gr_pullbackCongr_hom_eqToHom`)
- **Lean target exists**: yes (line 1463)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.restrictFunctorCongr_rfl_hom_app}` (chapter: `lem:gr_restrictFunctorCongr_rfl`)
- **Lean target exists**: yes (line 1471)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.restrictFunctorIsoPullback_congr}` (chapter: `lem:gr_restrictIsoPullback_congr`)
- **Lean target exists**: yes (line 1483)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueTripleFactorIso}` (chapter: `lem:gr_glueTripleFactorIso`)
- **Lean target exists**: yes (line 1497)
- **Signature matches**: yes — the factor iso deconstructing the triple base-change into pairwise base-changes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueTripleFactor_transpose}` (chapter: `lem:gr_glueTripleFactor_transpose`)
- **Lean target exists**: yes (line 1517)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueTripleFactor_mate}` (chapter: `lem:gr_glueTripleFactor_mate`)
- **Lean target exists**: yes (line 1688)
- **Signature matches**: yes — the mate identity, key for C2 transport
- **Proof follows sketch**: yes — mate construction against hom-equivalences as described; references `lem:gr_homEquiv_conjugateEquiv_app` (cross-chapter, resolved to `Picard_GrassmannianQuot.tex:2033`)
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueLegA_component_transpose}` (chapter: `lem:gr_glueLegA_component_transpose`)
- **Lean target exists**: yes (line 1826)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueOverlapFactorIso}` (chapter: `def:gr_glueOverlapFactorIso`)
- **Lean target exists**: yes (line 2220)
- **Signature matches**: yes — iso between the two representations of the overlap base-change applied to the chart component
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueChartComponent}` (chapter: `def:gr_glueChartComponent`)
- **Lean target exists**: yes (line 2237)
- **Signature matches**: yes — for each chart index `i`, the map `M_i → ι_i^* (glue D M g)` built from unit + transition pushforward + inverse overlap factor
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueChartFamily}` (chapter: `def:gr_glueChartFamily`)
- **Lean target exists**: yes (line 2247)
- **Signature matches**: yes — the family `(glueChartComponent D M g i)` as a natural transformation
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueLegB_component_transpose}` (chapter: `lem:gr_glueLegB_component_transpose`)
- **Lean target exists**: yes (line 2257)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueOverlapFactor_transpose}` (chapter: `lem:gr_glueOverlapFactor_transpose`)
- **Lean target exists**: yes (line 2336)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueOverlapFactor_mate}` (chapter: `lem:gr_glueOverlapFactor_mate`)
- **Lean target exists**: yes (line 2480)
- **Signature matches**: yes — the overlap analogue of `glueTripleFactor_mate`
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueChartComponent_overlap_collapse}` — NOT in blueprint
- (informational only — see Unreferenced declarations)

### `\lean{AlgebraicGeometry.Scheme.Modules.glueChartFamily_pullback_map_π}` (chapter: `lem:gr_glueChartFamily_pullback_map_pi`)
- **Lean target exists**: yes (line 2683)
- **Signature matches**: yes — `@[reassoc]` lemma; `glueChartFamily` composed with the pullback map of a projection equals the appropriate `glueProj`
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueChartComponent_leg_compat}` (chapter: `lem:gr_glueChartComponent_leg_compat`)
- **Lean target exists**: yes (line 2855)
- **Signature matches**: yes — the equalizing compatibility condition (C2 on the triple overlap): `legA (glueChartFamily) = legB (glueChartFamily)` as families of maps
- **Proof follows sketch**: yes — the blueprint's 3-item decomposition (factor iso, triple mate, pair collapse) is exactly the proof structure in Lean; the proof is the keystone of this iteration and landed at 0 sorry
- **notes**: both `\leanok` markers present ✓; this is the iter-080 keystone

### `\lean{AlgebraicGeometry.Scheme.Modules.glueChartFamily_equalizes}` (chapter: `lem:gr_glueChartFamily_equalizes`)
- **Lean target exists**: yes (line 2945)
- **Signature matches**: yes — `glueChartFamily` lands in the equalizer of the two legs of the restriction diagram
- **Proof follows sketch**: yes — combines `glueChartFamily_pullback_map_π` + `glueChartComponent_leg_compat`
- **notes**: both `\leanok` markers present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrictionInv}` (chapter: `def:gr_glueRestrictionInv`)
- **Lean target exists**: yes (line 3009)
- **Signature matches**: yes — the inverse morphism constructed from `glueChartFamily_equalizes` via the equalizer universal property
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrict_proj_compat}` (chapter: `lem:gr_glueRestrict_proj_compat`)
- **Lean target exists**: yes (line 3019)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrictionInv_pullback_map_glueProj}` (chapter: `lem:gr_glueRestrictionInv_proj`)
- **Lean target exists**: yes (line 3048)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrict_hom_ext}` (chapter: `lem:gr_glueRestrict_hom_ext`)
- **Lean target exists**: yes (line 3062)
- **Signature matches**: yes — the extension lemma: two maps out of the glued object are equal if they agree on all `glueProj` maps
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueChartComponent_self_counit}` (chapter: `lem:gr_glueChartComponent_self_counit`)
- **Lean target exists**: yes (line 3083)
- **Signature matches**: yes — self-counit identity: `glueRestrictionHom ∘ glueChartComponent = counit`
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueRestriction_overlap_compat}` (chapter: `lem:gr_glueRestriction_overlap_compat`)
- **Lean target exists**: yes (line 3180)
- **Signature matches**: yes — overlap compatibility of the restriction hom
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrictionHom_glueChartComponent}` (chapter: `lem:gr_glueRestrictionHom_glueChartComponent`)
- **Lean target exists**: yes (line 3260)
- **Signature matches**: yes — the section `glueRestrictionHom ∘ glueChartFamily = id` direction for the inverse argument
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.pullback_map_jointly_faithful}` (chapter: `lem:gr_pullback_jointly_faithful`)
- **Lean target exists**: yes (line 1210)
- **Signature matches**: yes — joint faithfulness of the family of pullback functors along the chart immersions
- **Proof follows sketch**: yes
- **notes**: `\leanok` present ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrictionIso}` (chapter: `def:glueRestrictionIso`)
- **Lean target exists**: yes (line 3388)
- **Signature matches**: yes — `glueRestrictionHom` promoted to an isomorphism via `isIso_glueRestrictionHom`
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present ✓. The `% NOTE:` in this chapter (lines 1249–1253) says the GrassmannianQuot block `def:gr_modules_glueRestrictionIso` "should be reconciled"; this is stale — inspection of `Picard_GrassmannianQuot.tex:297-301` confirms the reconciliation already happened: `def:gr_modules_glueRestrictionIso` now carries NO `\lean{}` pin and explicitly notes it is a cross-reference node. The `% NOTE:` in GlueDescent.tex should be updated to reflect the resolved status; see Severity summary.

---

## Red flags

*(Section present; no actionable red flags found, but all subcategories enumerated for completeness.)*

### Placeholder / suspect bodies
None. A full scan of the 3409-line file found zero `:= sorry` bodies, zero `:= True`, zero `:= Classical.choice _` on substantive claims. The file header confirms "axiom-clean since iter-056".

### Excuse-comments
None. All comments in the file are mathematical annotations (proof strategies, docstring slugs, bridge identifications) — no `-- TODO replace`, `-- temporary`, `-- placeholder`, or `-- wrong but works` comments.

### Axioms / Classical.choice on non-trivial claims
None. No `axiom` declarations found in the file.

---

## Unreferenced declarations (informational)

The following declarations in `GlueDescent.lean` have no `\lean{}` pin in `Picard_GlueDescent.tex`. Those pinned in `Picard_GrassmannianQuot.tex` (cross-chapter distribution) are marked [GrQ].

### Cross-chapter (pinned in `Picard_GrassmannianQuot.tex`) — NOT issues

| Declaration | GrQ line | Status |
|-------------|----------|--------|
| `pullbackBaseChangeTransport` | 79 | `\leanok` present in GrQ |
| `glue` | 200 | `\leanok` present in GrQ |
| `opensMap_final` | 407 | pinned in GrQ |
| `pullbackFreeIso` | 427 | pinned in GrQ |
| `pullbackFreeIso_eqToHom` | 451 | pinned in GrQ |
| `pullbackFreeIso_trans_symm_eqToIso` | 471 | pinned in GrQ |
| `pullback_isLocallyFreeOfRank` | 491 | pinned in GrQ |
| `pullbackObjUnitToUnit_id` | 1963 | pinned in GrQ |
| `pullbackFreeIso_id` | 1988 | pinned in GrQ |
| `pullbackObjUnitToUnit_comp` | 2008 | pinned in GrQ |
| `homEquiv_conjugateEquiv_app` | 2034 | pinned in GrQ (also resolves `\uses{lem:gr_homEquiv_conjugateEquiv_app}` in this chapter) |
| `pullbackFreeIso_comp` | 2056 | pinned in GrQ |

### Genuinely unpinned — notable

**`glueLift`** (line ~204): the primary equalizer lift — the universal property morphism into `glue D M g`. This is the `glueLift_cond_iff`'s subject and is used in `glueRestrictionHom` via `glueProd`. No `\lean{}` pin in any chapter. Given that `def:scheme_modules_glue` in GrassmannianQuot only pins `glue`, the universal lift has no blueprint home. Flag: **major** (see below).

**`glueLift_cond_iff`** (line ~425): the biconditional characterisation of when a map lifts through the equalizer. This is a key interface lemma between the equalizer API and the glue construction. No blueprint pin anywhere. Flag: **minor**.

**GlueRestriction section** (9 declarations, lines 940–1101): `glueOverlapProd`, `glueLegA`, `glueLegB`, `glueIsoEqualizer`, `glueProj`, `glueLift_glueProj`, `glueRestrictEqualizerIso`, `glueRestrictProdIso`, `pullback_map_glueLift_glueRestrictionHom`. These form the equalizer API on which `glueRestrictionHom` and `glueRestrictionInv` are built; they are not trivial one-liners (several have non-trivial proofs). No blueprint coverage anywhere. Flag: **minor** (they are infrastructure, but represent significant effort).

**Site-opens identity pair** (lines 1103–1200): `glueData_preimage_image_eq`, `glueData_overlap_opensFunctor_eq`. Used inside the proof of `glueOverlapBaseChangeIso`; the blueprint's proof sketch does not enumerate these sub-steps by name. Flag: **minor** (internal sub-steps).

**`glueChartComponent_overlap_collapse`** (line ~2680): The collapse identity used inside the proof of the keystone `glueChartComponent_leg_compat`. No blueprint block. Flag: **minor** (important sub-lemma for the keystone, worth a blueprint block in the next iter).

**CastCoherence section** (10 public declarations, lines 1852–2195): `pullbackCongr_inv_app_eqToHom`, `pullbackComp_assoc_app`, `pullbackComp_comp_fst_hom_app`, `pullback_map_inv_comp_hom_app`, `pullbackComp_inv_comp_map_inv_app`, `pullback_map_congr_inv_comp_hom_app`, `pullbackComp_inv_comp_map_congr_inv_app`, `pullbackComp_inv_comp_congr_hom_app`, `pullbackComp_hom_app_congr_fst`, `pullback_cast_compat`. These are pure algebraic cast-collapse lemmas with no independent mathematical content; the fact that they are needed is evidence of proof engineering overhead. Blueprint coverage is not expected. Flag: **informational only**.

**Cast-collapse free helpers** (5 declarations, lines 387–430): `pullbackFreeIso_inv_congr_hom`, `pullbackCongr_hom_app_free`, `pullbackFreeIso_inv_congr`, `pullbackCongr_inv_app_free`, `pullbackComp_inv_app_free_map`. Companions to the `pullbackFreeIso` family (which is pinned in GrQ); these are the cast-collapse variants. Flag: **informational** (low-level companions to GrQ-pinned decls).

**`homEquiv_comp_unit_pushforwardComp`, `homEquiv_comp_pushforwardCongr`** (lines ~442–455): adjunction engine helpers. The docstring references `lem:gr_tautologicalQuotientComponent_transpose`; no such label exists in either chapter. These are intermediate engine steps with no blueprint home. Flag: **minor**.

**Instances**: `restrictFunctor_isRightAdjoint`, `restrictFunctor_preservesLimits`, `pullback_preservesLimits_of_isOpenImmersion`. Typeclass instances; no blueprint entry expected. Flag: **informational**.

**Private declarations** (9 total): `comp4_solve_last/mid/front`, `comp5_rearrange`, `map_fold₅`, `side_collapse_left/right`, `final_cancel` (CastCoherence section), `glueChart_legCompat_left/right` (GlueRestrictionInverse section). Private; no blueprint coverage expected.

---

## Blueprint adequacy for this file

### Coverage
43 of ~73 substantive public Lean declarations in this file have a `\lean{...}` pin (42 in this chapter + 12 cross-chapter in GrassmannianQuot, with 11 pinned only here and 12 only there; the total of pinned-in-either-chapter is ~55). The genuinely unpinned substantive declarations are: `glueLift` (major), `glueLift_cond_iff`, the 9-declaration GlueRestriction infrastructure, the 10-declaration CastCoherence section, `glueChartComponent_overlap_collapse`, and the adjunction-engine pair (`homEquiv_comp_unit_pushforwardComp`, `homEquiv_comp_pushforwardCongr`). Excluding the CastCoherence section (which has no independent mathematical content), coverage is **adequate** for the mathematically substantive declarations.

### Proof-sketch depth
**Adequate.** Every `\begin{proof}` block for a `\lean{...}`-pinned declaration gives a sketch that matches the actual Lean proof structure. The keystone `lem:gr_glueChartComponent_leg_compat` has the most detailed sketch (3-item decomposition: factor iso → triple mate → pair collapse), and the Lean proof follows it precisely.

### Hint precision
**Precise.** All `\lean{...}` pins use fully-qualified `AlgebraicGeometry.Scheme.Modules.*` names. No loose hints.

### Generality
**Matches need.** All covered declarations are formalized at the correct generality for the project's use.

### Recommended chapter-side actions (for blueprint-writing subagent)

1. **`lem:gr_glueData_bridges`: add `\leanok` to statement and proof blocks.** Three declarations are complete (`glueData_bridge_src/mid/tgt`), `sync_leanok` missed this triple-declaration block. The review agent may apply the markers directly (certain sync miss, no semantic judgement required).

2. **Update the `% NOTE:` at `def:glueRestrictionIso` lines 1249–1253.** The issue it flags (duplicate pin in GrassmannianQuot) was already resolved: `def:gr_modules_glueRestrictionIso` in GrassmannianQuot now carries no `\lean{}` pin. Rewrite the note to say "reconciliation complete as of iter-080; `def:gr_modules_glueRestrictionIso` is now a cross-reference node only."

3. **Add a blueprint block for `glueLift`.** It is the primary lift constructor into the glue equalizer — the analogue of `glue` for the universal-property direction. A `\lean{AlgebraicGeometry.Scheme.Modules.glueLift}` entry in GlueDescent.tex (or GrassmannianQuot.tex alongside `def:scheme_modules_glue`) would complete the equalizer API coverage.

4. **Add `\lean{}` pins for `glueLift_cond_iff` and `glueChartComponent_overlap_collapse`.** Both are non-trivial sub-results that appear in proofs of pinned declarations; naming them in the blueprint would help future provers and avoid reinvention.

5. **Consider adding a GlueRestriction subsection** covering `glueLegA`, `glueLegB`, `glueIsoEqualizer`, and `glueProj`. The current `def:gr_glue_equalizer` block covers `glueProd` but not the decomposition that makes the equalizer diagram explicit.

---

## Severity summary

### must-fix-this-iter
None.

### major

1. **`lem:gr_glueData_bridges`: missing `\leanok` on statement and proof blocks** (GlueDescent.tex ~lines 548–578).
   All three Lean declarations (`glueData_bridge_src`, `glueData_bridge_mid`, `glueData_bridge_tgt`) are fully proved with 0 sorry; the file is axiom-clean since iter-056. This is a `sync_leanok` miss, likely caused by the multi-declaration `\lean{..., ..., ...}` syntax confusing the sync pass. The review agent may apply the two `\leanok` markers directly (both statement block and proof block); no semantic judgement needed.

2. **`glueLift` (line ~204) has no `\lean{}` pin in any blueprint chapter.**
   `glueLift` is the primary lift morphism into the glued-object equalizer — the dual of `glue` for the universal property side. It is used directly in `glueRestrictionHom` (line 1042, which IS pinned), so it is not purely internal. A plan-agent blueprint-writing action should add a pin alongside `def:scheme_modules_glue`.

3. **Stale `% NOTE:` in GlueDescent.tex lines 1249–1253.**
   The note asserts that `def:gr_modules_glueRestrictionIso` in GrassmannianQuot.tex "should be reconciled" to remove a duplicate `\lean{}` pin. Inspection of GrassmannianQuot.tex lines 297–301 shows the reconciliation already happened this iter: the block carries no `\lean{}` pin and explicitly states it is "a cross-reference node only." The note in GlueDescent.tex now points at a resolved issue and should be updated; leaving it as-is will mislead the plan agent into dispatching unnecessary work next iter.

### minor

1. **`glueLift_cond_iff`** has no blueprint pin. Important interface lemma (biconditional for the lift condition).
2. **`glueChartComponent_overlap_collapse`**: no blueprint block. This lemma does significant work collapsing the pair component in the keystone proof and deserves a brief blueprint entry.
3. **`homEquiv_comp_unit_pushforwardComp` / `homEquiv_comp_pushforwardCongr`**: no blueprint block; the docstring references `lem:gr_tautologicalQuotientComponent_transpose` which does not exist as a label anywhere.
4. **GlueRestriction equalizer API** (9 declarations: `glueOverlapProd`, `glueLegA`, `glueLegB`, `glueIsoEqualizer`, `glueProj`, `glueLift_glueProj`, `glueRestrictEqualizerIso`, `glueRestrictProdIso`, `pullback_map_glueLift_glueRestrictionHom`): no blueprint coverage. These are substantive but internal infrastructure; a brief subsection would aid future provers.

**Overall verdict**: PASS — the Lean file is axiom-clean, sorry-free, and faithfully implements all 43 blueprint-documented declarations; the iter-080 keystone `glueChartComponent_leg_compat` landed at 0 sorry with the proof structure matching the blueprint sketch exactly. The three major findings are all blueprint-side: a `sync_leanok` miss on `lem:gr_glueData_bridges`, a missing pin for `glueLift`, and a stale `% NOTE:` pointing at an already-resolved duplicate.
