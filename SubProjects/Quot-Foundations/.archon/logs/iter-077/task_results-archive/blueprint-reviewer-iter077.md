# Blueprint Review: iter077
**Iter:** 077

## Top-level summaries

- **Incomplete**: `Picard_GlueDescent.tex` MISSING (no file — critical); `Picard_GrassmannianQuot.tex` (4 Nitsure §5 blocks absent); `Picard_SectionGradedRing.tex` (5 SNAP targets not leanok).
- **Bad Lean targets**: `Picard_QuotScheme.tex` `thm:grassmannian_representable` — `\lean{Grassmannian.representable}` under-delivers: Lean statement omits smoothness, properness, rank-d quotient, Plucker (per blueprint NOTE at §5444); pin should be strengthened or split.
- **Forward decls unresolved**: `Picard_GrassmannianQuot.tex` `lem:gr_modules_glue_unique` / `def:gr_modules_glueHom` — `\lean{}` targets (`Scheme.Modules.glue_unique`, `Scheme.Modules.glueHom`) not yet in Lean; marked "planned work", NOT leanok — prover needed.
- **Deps/Isolated**: `Picard_FlatteningStratification.tex` — 4 mathlibok anchors (`lem:mathlib_flat_localization_preserves`, `lem:mathlib_flat_of_localized_maximal`, `lem:mathlib_free_of_isLocalizedModule`, `lem:isLocalizedModule_powers_restrictScalars`) used only in proof-level `\uses{}`, isolated from DAG → **wire-up**: add to statement-level `\uses{}` of their consuming blocks.
- **DAG**: 0 `unknown_uses` (all `\uses{}` refs valid). 118 `unmatched_lean` — majority are expected `\mathlibok` anchors (Mathlib not in Lean scan) plus the 2 forward-decl project targets above.
- **Rendering**: blueprint-doctor clean — 0 malformed_refs, 0 broken_refs, 0 orphan chapters.

## Unstarted-phase proposals

### Proposed: `blueprint/src/chapters/Picard_GlueDescent.tex`
- **Covers**: `AlgebraicJacobian/Picard/GlueDescent.lean` | **Phase**: GR-quot effective-descent lane (GlueDescent infra for `Picard_GrassmannianQuot.lean`'s tautological quotient construction)
- **Why now**: `GlueDescent.lean` contains 2 sorries (in `isIso_glueRestrictionHom` and a helper); neither has a proof sketch → prover cannot be dispatched at all without this chapter.
- **Key declarations** (dependency order):
  1. `\definition` `\label{def:gr_glue_equalizer}` — equalizer-of-pushforwards object `glueProd ⇉ glueOverlapProd`. `\lean{AlgebraicGeometry.Scheme.Modules.glueProd}` [expected]. Source: GlueDescent.lean infrastructure + `def:scheme_modules_glue` blueprint.
  2. `\lemma` `\label{lem:glueOverlapBaseChangeIso}` — iso β_ij: the pullback `ι_i^* (ι_j)_* M_j ≅ f_{ij}^* M_j` (base-change iso between pushforwards on overlaps). `\lean{AlgebraicGeometry.Scheme.Modules.glueOverlapBaseChangeIso}` [actual — in GlueDescent.lean L1148]. Source: GlueDescent.lean + `lem:modules_restrictFunctorIsoPullback_mathlib` mathlibok anchor.
  3. `\lemma` `\label{lem:glueRestrictionHom}` — restriction hom `ι_i^* (glue D M g) ⟶ M i`. `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrictionHom}` [actual — GlueDescent.lean L1042]. Source: equalizer universal property.
  4. `\theorem` `\label{thm:isIso_glueRestrictionHom}` — effective descent: `glueRestrictionHom` is an iso (sorry at GlueDescent.lean L1207). `\lean{AlgebraicGeometry.Scheme.Modules.isIso_glueRestrictionHom}` [actual]. Source: sheaf equalizer + Mathlib `lem:isLimitPullbackCone_mathlib` / `lem:eq_of_locally_eq_mathlib`.
  5. `\definition` `\label{def:glueRestrictionIso}` — packaged iso form. `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrictionIso}` [actual — GlueDescent.lean L1214]. Depends on `thm:isIso_glueRestrictionHom`.
- **`\uses` skeleton**:
  - `thm:isIso_glueRestrictionHom` uses `lem:glueRestrictionHom`, `lem:glueOverlapBaseChangeIso`, `lem:isLimitPullbackCone_mathlib`, `lem:eq_of_locally_eq_mathlib`
  - `def:glueRestrictionIso` uses `thm:isIso_glueRestrictionHom`
  - `lem:glueRestrictionHom` uses `def:gr_glue_equalizer`, `def:scheme_modules_glue`
  - `lem:glueOverlapBaseChangeIso` uses `lem:modules_restrictFunctorIsoPullback_mathlib`
- **Main theorem proof strategy**: The glued sheaf `glue D M g` is built as the equalizer `eq(glueLegA, glueLegB)` in `D.glued.Modules`. The restriction hom `glueRestrictionHom i` extracts the i-th component via the equalizer projection `glueProj`. Effective descent (`isIso_glueRestrictionHom`) follows from the fact that `ι_i^*` is an equivalence on the open `U_i`; the equalizer in sheaves of modules restricted to a chart recovers exactly `M_i`, since the overlap factors `(ι_i^* (ι_j)_* M_j)` are identified with `f_{ij}^* M_j` via `glueOverlapBaseChangeIso`. The inner sorry at L1170 is in `glueRestrictEqualizerIso` which bridges the equalizer structure to the pullback. Writer should use `Mathlib.Topology.Sheaves.IsLimit` / `lem:isLimitPullbackCone_mathlib`.
- **References for writer**:
  - Lean source `AlgebraicJacobian/Picard/GlueDescent.lean` — read the docstrings on `glueRestrictionHom` (L899), `glueOverlapBaseChangeIso` (L1148), `isIso_glueRestrictionHom` (L1191) for the intended proof shape.
  - `blueprint/src/chapters/Picard_GrassmannianQuot.tex` `def:scheme_modules_glue` — the equalizer construction this chapter extends.
  - `references/summary.md` — check for SheafOfModules / Mathlib topology sheaves references.
- **Subphase choices exposed**:
  - Two sorry locations: inner sorry at L1170 (`glueRestrictEqualizerIso`) and main sorry at L1207 (`isIso_glueRestrictionHom`). Writer may close either first; L1170 is smaller and likely prerequisite.

### Proposed additions to `Picard_GrassmannianQuot.tex` (not a new file but new section)
- **Phase**: GR-quot Nitsure §5 inverse chain (blocks the `represents` leanok)
- **Why now**: `tautologicalQuotient_epi`, `chartLocus_isOpenCover`, `isIso_pullback_isoLocus_map`, `grPointOfRankQuotient` all have sorries in GrassmannianQuot.lean (L2065, L2147, L2160, L2249) with NO blueprint blocks — prover has no proof sketch.
- **Key declarations** (new blocks needed in §`sec:grquot_universal`):
  1. `\lemma` `\label{lem:tautologicalQuotient_epi}` — `u : O^r ↠ U` is epi. `\lean{Grassmannian.tautologicalQuotient_epi}` [actual]. Proof: epi since each `u^I` is split-epi (`lem:gr_chartQuotientMap_epi`) and epi is local on the cover.
  2. `\definition` `\label{def:isoLocus}` — open sub `isoLocus φ ⊆ X` where `φ : M ⟶ N` is locally an iso. `\lean{Grassmannian.isoLocus}` [actual].
  3. `\lemma` `\label{lem:isIso_pullback_isoLocus_map}` — pullback of φ to `isoLocus φ` is an iso. `\lean{Grassmannian.isIso_pullback_isoLocus_map}` [actual]. Source: sheaf locality + Mathlib `isIso_of_stalkFunctor_map_iso`.
  4. `\definition` `\label{def:chartLocus}` — `chartLocus x I ⊆ T`, the locus where the I-columns of the quotient are a basis. `\lean{Grassmannian.chartLocus}` [actual]. Uses `def:isoLocus` + chart composite.
  5. `\lemma` `\label{lem:chartLocus_isOpenCover}` — the `chartLocus x I` cover T. `\lean{Grassmannian.chartLocus_isOpenCover}` [actual]. Proof: at any point t, the fiber quotient is surjective so some I gives an iso; Nakayama extends to a neighbourhood.
  6. `\definition` `\label{def:grPointOfRankQuotient}` — the morphism `T → Gr(d,r)` induced by a rank-d quotient `x`. `\lean{Grassmannian.grPointOfRankQuotient}` [actual, sorry at L2249]. Glues the chart-local classifying morphisms `T_I → U^I` via `lem:chartLocus_isOpenCover`.
- **`\uses` skeleton**:
  - `lem:tautologicalQuotient_epi` uses `lem:gr_chartQuotientMap_epi`, `def:tautological_quotient`
  - `lem:isIso_pullback_isoLocus_map` uses `def:isoLocus`, `lem:isIso_of_stalkFunctor_map_iso_mathlib`
  - `def:chartLocus` uses `def:isoLocus`, `def:gr_chart_quotient`
  - `lem:chartLocus_isOpenCover` uses `def:chartLocus`, `def:gr_rankQuotient`
  - `def:grPointOfRankQuotient` uses `lem:chartLocus_isOpenCover`, `lem:isIso_pullback_isoLocus_map`, `def:gr_affine_chart`, `lem:gr_cocycle`
- **Strategy**: The proof of `thm:grassmannian_universal_property` (represents) already has a complete sketch. These 5 blocks are the sub-lemmas it invokes for the "from quotient to morphism" half. `isIso_pullback_isoLocus_map` needs the Mathlib stalk-iso criterion; the rest are elementary.
- **References**: `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` §1 (the "T_I covers T" argument, Nakayama).

## Per-chapter

### `Cohomology_RegroupHelper.tex`
- **Complete**: true
- **Correct**: true

### `Cohomology_FlatBaseChange.tex`
- **Complete**: partial — FBC-B globalization targets (`lem:flat_base_change_separated`, `lem:flat_base_change_mayer_vietoris`, `lem:flat_base_change_reduce_global_sections`, `lem:base_changed_equalizer_diagram`) present as blueprint blocks with unmatched `\lean{}` (scaffold needed in `FlatBaseChangeGlobal.lean`); FBC-A2 core (`lem:affine_base_change_pushforward`) and mate chain all leanok.
- **Correct**: true

### `Picard_FlatteningStratification.tex`
- **Complete**: true — both `thm:generic_flatness_algebraic` and `thm:generic_flatness` leanok; all devissage sub-lemmas closed.
- **Correct**: true
- **Notes**: 4 isolated mathlibok anchors (wire-up — proof-level \uses{} only): `lem:mathlib_flat_localization_preserves` (used in proof of `lem:gf_localizedModule_baseChange_tensor_comm`), `lem:mathlib_flat_of_localized_maximal` (used in proof of `lem:gf_patch_free_imp_flat`), `lem:mathlib_free_of_isLocalizedModule` (used in proof of `lem:gf_patch_free_imp_flat`), `lem:isLocalizedModule_powers_restrictScalars` (used in proof of `lem:gf_patch_free_imp_flat`). Add these to statement-level `\uses{}` of those blocks.

### `Picard_GrassmannianCells.tex`
- **Complete**: true — all cells/cocycle/glue/separated/proper blocks leanok.
- **Correct**: true

### `Picard_GrassmannianQuot.tex`
- **Complete**: false
- **Correct**: true
- **Notes**:
  - MISSING 4 blocks for Nitsure §5 inverse chain (see unstarted-phase proposal above): `tautologicalQuotient_epi`, `isoLocus`/`chartLocus`, `chartLocus_isOpenCover`, `isIso_pullback_isoLocus_map`, `grPointOfRankQuotient` — all sorry in Lean (L2065, L2147, L2160, L2249), zero blueprint coverage.
  - `lem:gr_modules_glue_unique` (L334), `def:gr_modules_glueHom` (L362): forward declarations with `% NOTE: planned work`; `\lean{}` targets not yet in Lean (unmatched_lean); not leanok. Proof sketches present and sound — prover can close once blueprint writer adds `\leanok` trigger.
  - `def:gr_modules_glueRestrictionIso` (L296): leanok ✓ — implemented in `GlueDescent.lean`.
  - `thm:grassmannian_universal_property` (`represents`, L1858): proof sketch complete and detailed; NOT leanok (blocked on sub-lemmas above).
  - HARD GATE: chapter is `partial` → prover for the 4 sorry'd targets DEFERRED until the 5 new blocks are written. Existing leanok blocks (gluing infra, bundle cocycle, tautological quotient) may proceed.

### `Picard_QuotScheme.tex`
- **Complete**: partial — `thm:grassmannian_representable` is leanok but `\lean{}` under-delivers (see correctness note).
- **Correct**: partial
- **Notes**: `thm:grassmannian_representable` lean target `Grassmannian.representable` is a "weakened existence skeleton" per blueprint NOTE — missing smoothness, properness, rank-d quotient, Plucker. The `\lean{}` pin under-delivers the stated theorem (**must-fix correctness**: either strengthen the Lean statement or split into separate skeleton label and annotate prose accordingly). All other leanok blocks (gap1, gap2, G1-core, annihilator, P1/P2 predicates, `def:hilbert_polynomial`, `def:quot_functor`) correct.

### `Picard_RelativeSpec.tex`
- **Complete**: true — `thm:relative_spec_exists`, `def:relspec_structure_morphism`, `thm:relative_spec_univ`, `thm:relative_spec_affine_base` all leanok.
- **Correct**: true

### `Picard_SectionGradedRing.tex`
- **Complete**: partial
- **Correct**: true
- **Notes**: Open (not leanok) targets:
  - `cor:sheafTensorObjAssoc` (L1050, `Scheme.Modules.tensorObjAssoc`) — SNAP `tensorObjAssoc` step, no leanok.
  - `lem:sheafTensorPow_add` (L1129, `Scheme.Modules.tensorPowAdd`) — SNAP `tensorPowAdd` step, no leanok.
  - `lem:sectionMul_coherent` (L1287, `Scheme.Modules.sectionsMul_assoc_unit`) — lax-monoidal Γ coherence, no leanok.
  - `lem:sectionGradedRing_gcommSemiring` (L1364, `AlgebraicGeometry.sectionGradedRing_gcommSemiring`) — graded ring assembly, no leanok.
  - `lem:sectionGradedModule_gmodule` (L1423, `AlgebraicGeometry.sectionGradedModule_gmodule`) — graded module assembly, no leanok.
  - `lem:isIso_sheafification_whiskerRight_unit` (L980): leanok ✓ (SNAP crux closed).
  - `lem:snap_ztensor_whisker_localIso` (L717): leanok ✓.

## Severity summary

- **must-fix this iter**:
  - `Picard_GlueDescent.tex` MISSING — unstarted-phase proposal, dispatch blueprint-writer this iter.
  - `Picard_GrassmannianQuot.tex` 4 inverse-chain blocks MISSING — writer directive this iter, then prover.
  - `Picard_QuotScheme.tex` `thm:grassmannian_representable` lean target under-delivers — correctness fix needed (writer or direct edit).
- **soon**:
  - `Picard_FlatteningStratification.tex`: 4 isolated anchors → wire-up (add statement-level `\uses{}`).
  - `Picard_SectionGradedRing.tex`: 5 SNAP targets need prover (proof sketches present, no leanok yet).
  - `Picard_GrassmannianQuot.tex`: `lem:gr_modules_glue_unique`, `def:gr_modules_glueHom` need Lean implementation (forward decls ready for prover).
