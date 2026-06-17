# Blueprint Review — iter-059

**Date:** 2026-06-10  
**Reviewer role:** READ-ONLY on all project source files  
**leandag snapshot:** 567 total nodes, 427 proved, 102 mathlib_ok, 13 has_sorry, 1217 edges  
**broken_uses:** [] — no broken `\uses{}` references  
**isolated nodes:** []

---

## 1. Executive Summary

All eight blueprint chapters have been audited. The overall proof-of-concept layer (Grassmannian cells, relative Spec, regroup helper) is **axiom-clean**. The FBC affine computation chain and generic flatness are **architecturally complete but sorry-carrying at key joints**. The Grassmannian Quot and Section Graded Ring chapters are the **live open frontiers**.

**13 nodes carry `has_sorry=True`** (all are proved=True except `relTensorProj`); 28 nodes are not proved at all.

Key gate: `thm:flat_base_change_pushforward` and `lem:affine_base_change_pushforward` are leanok with sorry — the FBC-A2 intermediaries feeding them (`lem:flat_base_change_separated`, `lem:flat_base_change_mayer_vietoris`, `lem:flat_base_change_reduce_global_sections`, `lem:base_changed_equalizer_diagram`) are NOT proved. The `fstar_reindex_legs_conj` and `gstar_transpose` crux nodes are leanok-with-sorry, pulling the affine and global FBC theorems into the sorry set.

---

## 2. Per-Chapter Audit

### 2.1 `Cohomology_RegroupHelper.tex`
**Status: COMPLETE AND CORRECT**

- Single node: `lem:base_change_regroup_linearEquiv` → `\lean{AlgebraicGeometry.base_change_regroup_linearEquiv}` — `\leanok`, proved=True, has_sorry=False.
- No open items.

---

### 2.2 `Cohomology_FlatBaseChange.tex`
**Status: ARCHITECTURALLY COMPLETE; SORRY-CARRYING AT CRUXES**

**Covers:** `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` + `AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean`

#### Complete and axiom-clean (leanok, no sorry)
All of the following are proved=True, has_sorry=False:
- Affine tilde dictionaries: `lem:pushforward_spec_tilde_iso`, `lem:pullback_spec_tilde_iso`, `lem:gammaPushforwardNatIso`
- Locality and unit reads: `lem:base_change_map_affine_local`, `lem:pullback_fst_snd_specMap_tensor`, `lem:base_change_mate_domain_read`, `lem:base_change_mate_codomain_read`, `lem:base_change_mate_regroupEquiv`, `lem:base_change_mate_unit_value`, `def:base_change_mate_inner_value`
- Conjugate-side chain (conj-0 through conj-2a): all leanok, no sorry — `lem:pullbackComp_inv_eq_leftAdjointCompIso_inv`, `lem:pullbackComp_eq_leftAdjointCompIso`, `lem:pullbackPushforward_unit_comp`, pushforward/pullback composition coherences, `def:base_change_mate_codomain_read_legs_param`, `def:conjPullbackFactor`, conj-1a/1b, conj-2b/2c/2d — all axiom-clean
- `def:keystone_adjR`, `def:keystone_beta`, conj-2a: all clean
- `lem:base_change_mate_fstar_reindex_legs` (leanok, no sorry), `lem:base_change_mate_fstar_reindex` (no sorry)
- eCancel atoms A-2a/b/c (all leanok, marked superseded by conjugate-side route)
- Gstar seam: `lem:base_change_mate_gstar_generator_close` (no sorry), `lem:base_change_mate_extendScalars_inner_value_counit` (no sorry), `lem:base_change_mate_gstar_counit_transport` (no sorry)
- `lem:base_change_mate_section_identity` (no sorry), `lem:base_change_mate_generator_trace` (no sorry)
- G1/G2 assembly: `lem:finite_affine_cover_qcqs`, `lem:gamma_finite_equalizer`, `lem:gamma_finite_equalizer_cover` — all no sorry

#### Sorry-carrying nodes (proved=True, has_sorry=True)
| Node | Lean name | Note |
|------|-----------|------|
| `lem:base_change_mate_fstar_reindex_legs_conj` | `…fstar_reindex_legs_conj` | Full conjugate identity; keystone with open sorry |
| `lem:base_change_mate_gstar_transpose` | `…gstar_transpose` | Crux of section computation; has sorry (steps (a)/(c)) |
| `lem:affine_base_change_pushforward` | `affineBaseChange_pushforward_iso` | **Key affine FBC lemma; has sorry** |
| `thm:flat_base_change_pushforward` | `flatBaseChange_pushforward_isIso` | **Main FBC theorem; has sorry** |

#### Not proved (no leanok in blueprint, proved=False in dag)
| Node | Lean name | Note |
|------|-----------|------|
| `lem:pushforward_base_change_mate_sections_direct` | `…sections_direct` | Abandoned route record — NOTE in blueprint: "do NOT dispatch a prover at it" |
| `lem:base_changed_equalizer_diagram` | `baseChange_sheafConditionFork_tensorIso` | FBC-A2: Čech fork base-change compatibility |
| `lem:flat_base_change_separated` | `flatBaseChange_pushforward_isIso_of_isSeparated` | FBC-A2: separated case |
| `lem:flat_base_change_mayer_vietoris` | `flatBaseChange_pushforward_mayerVietoris` | FBC-A2: quasi-separated Mayer–Vietoris induction |
| `lem:flat_base_change_reduce_global_sections` | `flatBaseChange_isIso_iff_gammaTensorComparison` | FBC-A2: sheaf-level ↔ module-level reduction |

**Correctness flags:**
- `lem:pushforward_base_change_mate_sections_direct` is an abandoned route record with NO Lean target added (per blueprint NOTE). The dag node exists from when it was in scope but is explicitly marked do-not-prove.
- Blueprint NOTE at `thm:grassmannian_representable` ALSO applies here: the `thm:flat_base_change_pushforward` \lean{} pin points at a sorry-carrying skeleton.

**Gate decision for FBC:** The FBC-A2 intermediaries need to be proved to clear the sorry from `affineBaseChange_pushforward_iso` and `flatBaseChange_pushforward_isIso`. The proof sketches in the blueprint are correct and detailed. Scaffold-ready for FBC-A2 lane.

---

### 2.3 `Picard_RelativeSpec.tex`
**Status: COMPLETE AND CORRECT**

All 5 nodes leanok, proved=True, has_sorry=False:
- `def:adjunction_restriction_extension`, `lem:relative_spec_adjunction_counit_iso`, `lem:relative_spec_adjunction_unit_iso`, `thm:relative_spec_exists`, `thm:relative_spec_univ`

---

### 2.4 `Picard_GrassmannianCells.tex`
**Status: COMPLETE AND CORRECT**

All nodes leanok through properness (E1–E5, `lem:gr_proper`), proved=True, has_sorry=False. The chapter covers chart construction, separatedness, existence lift, valuative properness, and properness assembly.

---

### 2.5 `Picard_GrassmannianQuot.tex`
**Status: PARTIALLY COMPLETE; SORRY-HEAVY; BUNDLE COCYCLE OPEN**

#### Clean proved nodes (no sorry)
- All chart morphism infrastructure (chartQuotientMap, pullbackιIso, pullbackFreeIso, universalMatrix/minor/minor_inv atoms) — axiom-clean
- `lem:gr_pullbackObjUnitToUnit_comp`, `lem:gr_pullbackFreeIso_comp`, `lem:gr_homEquiv_conjugateEquiv_app` — axiom-clean
- `def:grassmannian_functor`, `thm:grassmannian_universal_property` — proved=True, **has_sorry=True**

#### Sorry-carrying nodes
| Node | Lean name | proved | has_sorry |
|------|-----------|--------|-----------|
| `def:gr_universal_quotient_sheaf` | `Grassmannian.universalQuotientSheaf` | True | True |
| `def:tautological_quotient` | `Grassmannian.tautologicalQuotient` | True | True |
| `thm:grassmannian_universal_property` | `Grassmannian.universalProperty` | True | True |
| `thm:grassmannian_representable` | `Grassmannian.representable` | True | True |

**Note on `thm:grassmannian_representable`:** Blueprint comment (lines 5525–5529) explicitly states "The Lean statement is currently a weakened existence skeleton that omits smoothness, properness, relative dimension d(r-d), the tautological rank-d quotient, and the Plucker embedding. The `\lean{}` pin points at a declaration that under-delivers the prose statement."

#### Not proved
| Node | Lean name | Note |
|------|-----------|------|
| `def:gr_bundleTransition` | `Grassmannian.bundleTransition` | **Bundle cocycle: forward decl** |
| `lem:gr_bundleCocycle_id` | `Grassmannian.bundleTransition_self` | **Bundle cocycle: identity** |
| `lem:gr_bundleCocycle_mul` | `Grassmannian.bundleTransition_cocycle` | **Bundle cocycle: "the hard step"** |
| `lem:gr_glueData_bridges` | `glueData_bridge_{src,mid,tgt}` | GL_d bundle for gluing downstream |
| `def:gr_modules_glueRestrictionIso` | `Modules.glueRestrictionIso` | Glue downstream |
| `lem:gr_modules_glue_unique` | `Modules.glue_unique` | Glue downstream |
| `def:gr_modules_glueHom` | `Modules.glueHom` | Glue downstream |
| `def:gr_rankQuotient` | `Grassmannian.RankQuotient` + variants | Rank quotient predicate |

**GATE DECISION — GL_d bundle cocycle scaffold:** YES, scaffold and prove this iter.
- `def:gr_bundleTransition`: blueprint entry complete, correct statement (chart-to-chart GL_d matrix), proof sketch adequate
- `lem:gr_bundleCocycle_id`: blueprint entry complete, `gII = 1` proof by `Matrix.nonsing_inv_cancel`-style
- `lem:gr_bundleCocycle_mul`: blueprint entry present, "hard step" acknowledged — proof via `submatrix_mul` + `Matrix.nonsing_inv_mul` across charts. Mathematically sound. The blueprint prose at this entry gives the essential computation route.
- **Dependency chain:** `glueData_bridges` directly depends on the bundle cocycle; `glue` (already proved axiom-clean in iter-056 using sorry placeholders) can be discharged once cocycle is clean.

---

### 2.6 `Picard_FlatteningStratification.tex`
**Status: NEARLY COMPLETE; G3 GATE OPEN; 4 BLUEPRINT DEBT ITEMS**

#### Generic flatness chain (all proved=True, no sorry except thm)
- Algebraic dévissage (G0 base case through G2 annihilator step) — all axiom-clean
- Module transport helpers (`isLocalizedModule_powers_transport`, `isLocalizedModule_ringEquiv_semilinear`, `isLocalizedModule_restrictScalars_powers_algebraMap`) — all axiom-clean
- GF seam-1 + G1 base case + `gf_qcoh_finite_sections_of_genSections` — all axiom-clean
- `thm:generic_flatness` — proved=True, **has_sorry=True** (gated on G3)

#### Not proved
| Node | Lean name | Note |
|------|-----------|------|
| `lem:gf_finite_gen_iff_free_epi` | `gf_finite_gen_iff_free_epi` | G3 gate: split-epi + finitely-generated criterion |

#### Directive helpers — coverage debt (leandag unmatched)
| Directive name | Lean decl | Blueprint status |
|---------------|-----------|-----------------|
| `gf_flat_isLocalizedModule_sameBase` | `AlgebraicGeometry.gf_flat_isLocalizedModule_sameBase` | Blueprint has `lem:gf_flat_localizedModule_sameBase` but `\lean{}` pin uses wrong name (`gf_flat_localizedModule_sameBase` vs `gf_flat_isLocalizedModule_sameBase`). **Name mismatch — counts as unmatched.** |
| `flat_of_ringEquiv_semilinear` | `AlgebraicGeometry.flat_of_ringEquiv_semilinear` | Blueprint has `lem:module_finite_of_ringEquiv_semilinear` with different Lean name. **Name mismatch.** |
| `flat_localization_models` | `AlgebraicGeometry.flat_localization_models` | **NO blueprint entry.** Proved axiom-clean (proved=True, has_sorry=False). |
| `isLocalizedModule_powers_restrictScalars` | `AlgebraicGeometry.isLocalizedModule_powers_restrictScalars` | **NO blueprint entry.** Proved axiom-clean (proved=True, has_sorry=False). |

**ρ-agreement / STEP-3 prose:** The `flatV`/STEP-3 prose in the chapter specifies the semilinearity (ρ-agreement) close through the `isLocalizedModule_ringEquiv_semilinear` transport — this is correct and sufficiently detailed. The gap is the `flat_localization_models` and `isLocalizedModule_powers_restrictScalars` helpers which exist in Lean but are not blueprinted.

---

### 2.7 `Picard_SectionGradedRing.tex`
**Status: CRITICALLY INCOMPLETE; `relTensorActR`/`relTensorProj` ABSENT FROM BLUEPRINT**

#### Proved and clean
- `def:relTensorDomainPresheaf`, `def:relTensorTriplePresheaf` — axiom-clean
- `def:relTensorActL` — proved=True, has_sorry=False (leanok in blueprint)
- `def:sectionMul` — proved=True, has_sorry=False
- `def:sheafTensorObj`, `def:sheafTensorPow` — proved=True, has_sorry=False

#### Directive focus: `relTensorActR` and `relTensorProj` coverage
- `lean:AlgebraicGeometry.Scheme.Modules.relTensorActR` — **proved=True, has_sorry=False, but NO blueprint entry.** The Lean decl exists and is axiom-clean but the blueprint has no node for it.
- `lean:AlgebraicGeometry.Scheme.Modules.relTensorProj` — **proved=False, has_sorry=True, and NO blueprint entry.** A sorry stub in Lean with no blueprint spec.

**`lem:relativeTensor_as_coequalizer` step-2 naturality:** The blueprint entry exists (Lean: `relativeTensorCoequalizerIso`) but is proved=False. The blueprint describes step-2 as "naturality of the coequalizer": the presheaf-level coequalizer via `evaluationJointlyReflectsColimits`. **The blueprint does NOT specify the naturality route for `relTensorProj`** (the `forget₂ CommRingCat→RingCat` carrier obstacle / ModuleCat-presheaf-level route). The step-2 prose at `lem:relativeTensor_as_coequalizer` only describes the object-level isomorphism, not the `relTensorProj` morphism route. **This is the gap the directive asked about: `relTensorProj` has no blueprint coverage at all.**

#### Not proved
| Node | Lean name | Note |
|------|-----------|------|
| `lem:relativeTensor_as_coequalizer` | `relativeTensorCoequalizerIso` | Step-2 naturality: presheaf promotion crux |
| `lem:snap_ztensor_whisker_localIso` | (none assigned) | SNAP ℤ-tensor local iso; no Lean target |
| `lem:isIso_sheafification_whiskerRight_unit` | `isIso_sheafification_whiskerRight_unit` | Sheafification unit iso |
| `cor:sheafTensorObjAssoc` | `tensorObjAssoc` | Sheaf tensor associativity |
| `lem:sheafTensorPow_add` | `tensorPowAdd` | Graded ring tensor pow addition |
| `lem:sectionMul_coherent` | `sectionsMul_assoc_unit` | Graded ring coherence (assoc + unit) |
| `lem:sectionGradedRing_gcommSemiring` | `sectionGradedRing_gcommSemiring` | Gcomm semiring instance |
| `lem:sectionGradedModule_gmodule` | `sectionGradedModule_gmodule` | Gmodule instance |
| `def:sectionGradedRing` | `sectionGradedRing` | Top-level graded ring def |
| `def:sectionGradedModule` | `sectionGradedModule` | Top-level graded module def |
| `lem:sectionGradedModule_fg` | `sectionGradedModule_fg` | Finite generation of section graded module |

**Correctness:** The SNAP presheaf-promotion approach (`evaluationJointlyReflectsColimits`) is sound in principle, but `relTensorProj` has a carrier obstacle (`↥(P.obj U)` vs `↥((P.presheaf).obj U)`) that breaks `map_tmul`. The current blueprint spec does not address this obstacle.

---

### 2.8 `Picard_QuotScheme.tex`
**Status: MOSTLY COMPLETE; SORRY-HEAVY AT TOP; GRADED RING BLOCKED**

**Covers:** `AlgebraicJacobian/Picard/QuotScheme.lean` + `AlgebraicJacobian/Picard/GradedHilbertSerre.lean`

#### Complete and axiom-clean (selected key nodes)
All gap1/G1 chain nodes, G2 descent chain, annihilator infrastructure — all proved=True, has_sorry=False:
- `lem:qcoh_section_localization_basicOpen`, `lem:isLocalizedModule_basicOpen_of_hP1`, gap2 chain (L1–L6), `isQuasicoherent_pullback_fromSpec` — all clean
- Gap1 keystone infrastructure: `lem:section_localization_descent`, `lem:qcoh_affine_isIso_fromTildeΓ` — clean
- All gap1 ring-iso semilinearity builds: `lem:isLocalizedModule_ringEquiv_semilinear`, `lem:isLocalizedModule_restrictScalars_powers_algebraMap`, `lem:isLocalizedModule_powers_transport` — clean
- Section transport chain: `lem:pullback_gamma_top_iso`, `lem:gamma_pullback_image_iso`, `lem:gamma_pullback_image_iso_hom_semilinear`, `def:gamma_image_ring_equiv` — clean
- Composite basic-open immersion infrastructure (5 nodes) — clean
- G1 assembly: `lem:bijective_comp_of_localizations`, `lem:isIso_sheaf_of_isIso_app_basicOpen`, `lem:isIso_fromTildeΓ_of_isLocalizedModule_restrict`, `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict` — clean
- Schematic support: `def:schematic_support`, `def:schematic_support_immersion`, `def:HasProperSupport`, `def:is_locally_free_of_rank` — clean
- GradedHilbertSerre chain (SubquotientDatum, ker/coker, degreewise diff, finite transfer, base case, `lem:graded_subquotient_isRatHilb`) — all clean
- ratHilb toolkit, `lem:gradedHilbertSerre_rational` — clean

#### Sorry-carrying nodes
| Node | Lean name | proved | has_sorry |
|------|-----------|--------|-----------|
| `def:hilbert_polynomial` | `Scheme.hilbertPolynomial` | True | True |
| `def:quot_functor` | `Scheme.QuotFunctor` | True | True |
| `def:grassmannian_scheme` | `Scheme.Grassmannian` | True | True |
| `thm:grassmannian_representable` | `Scheme.Grassmannian.representable` | True | True |

**Note on `thm:grassmannian_representable`:** Blueprint explicitly states the Lean pin points at a weakened skeleton (no smoothness, properness, tautological quotient, or Plücker embedding). This is a known limitation documented in the blueprint.

#### Not proved
| Node | Lean name | Note |
|------|-----------|------|
| `def:sectionGradedRing` | `sectionGradedRing` | Blocked on SGR chapter |
| `def:sectionGradedModule` | `sectionGradedModule` | Blocked on SGR chapter |
| `thm:hilbertPoly_of_sectionModule` | `Scheme.hilbertPolynomialOfSectionModule` | Blocked on sectionGradedRing |
| `lem:composite_immersion_flocus_basicOpen` | `section_localization_hfr_basicOpen` | **Duplicate pin** — same Lean name as `lem:section_localization_hfr_basicOpen` which IS proved. Blueprint node name mismatch. |

---

## 3. Directive Focus Areas

### 3.1 `Picard_GrassmannianQuot.tex` — GL_d bundle-cocycle gate decision

**VERDICT: SCAFFOLD YES.**

- `def:gr_bundleTransition` (Lean: `Grassmannian.bundleTransition`): Blueprint entry present, correct statement. The transition map $g_{IJ} = (X^I_J)^{-1}$ on the overlap $U^I \cap U^J$ is well-specified.
- `lem:gr_bundleCocycle_id` (Lean: `Grassmannian.bundleTransition_self`): `gII = 1` — proof sketch identifies `Matrix.nonsing_inv_cancel` as the Mathlib mechanism. Correct.
- `lem:gr_bundleCocycle_mul` (Lean: `Grassmannian.bundleTransition_cocycle`): "The hard step" — $g_{IK} = g_{IJ} \cdot g_{JK}$. Proof sketch: `submatrix_mul` + `Matrix.nonsing_inv_mul` across compatible charts. Mathematically correct. Blueprint prose adequately sketches the argument.

**Downstream readiness:** Once cocycle is proved, `lem:gr_glueData_bridges` can be discharged, which unblocks `def:gr_modules_glueRestrictionIso`, `lem:gr_modules_glue_unique`, and `def:gr_modules_glueHom`. This clears the sorry from `def:gr_universal_quotient_sheaf`, `def:tautological_quotient`, `thm:grassmannian_universal_property`, and eventually `thm:grassmannian_representable`.

**Risk flag:** `lem:gr_bundleCocycle_mul` is marked "the hard step" — expect 50–100 LOC of matrix algebra with potential `nonsing_inv_mul` / `submatrix` API friction in Lean.

---

### 3.2 `Picard_FlatteningStratification.tex` — flatV/STEP-3 and 4 new helpers

**STEP-3 prose completeness:** The `flatV`/STEP-3 section fully specifies the semilinearity (ρ-agreement) close via the `isLocalizedModule_ringEquiv_semilinear` combiner + `isLocalizedModule_restrictScalars_powers_algebraMap` bridge. The prose is **complete and correct for what is blueprinted**.

**4 new helpers coverage:**

| Helper | Blueprint entry | Lean status | Assessment |
|--------|----------------|-------------|------------|
| `gf_flat_isLocalizedModule_sameBase` | `lem:gf_flat_localizedModule_sameBase` (leanok) | proved, no sorry; `\lean{}` pin has name mismatch | **Covered in concept; pin needs fix** |
| `flat_of_ringEquiv_semilinear` | `lem:module_finite_of_ringEquiv_semilinear` (leanok) | proved, no sorry; `\lean{}` pin has name mismatch | **Covered in concept; pin needs fix** |
| `flat_localization_models` | **NO blueprint entry** | proved=True, has_sorry=False | **Missing blueprint entry** |
| `isLocalizedModule_powers_restrictScalars` | **NO blueprint entry** | proved=True, has_sorry=False | **Missing blueprint entry** |

**Action required:** Add blueprint entries for `flat_localization_models` and `isLocalizedModule_powers_restrictScalars`. Fix the `\lean{}` pins on `lem:gf_flat_localizedModule_sameBase` and `lem:module_finite_of_ringEquiv_semilinear` to match the actual Lean declaration names.

---

### 3.3 `Picard_SectionGradedRing.tex` — `relTensorActR`/`relTensorProj` coverage

**`lem:relativeTensor_as_coequalizer` step-2 naturality:** The blueprint describes the step-2 naturality only at the object level (coequalizer isomorphism). It does NOT specify the `relTensorProj` naturality route (the `forget₂ CommRingCat→RingCat` carrier obstacle or the ModuleCat-presheaf-level route). **The blueprint is incomplete on the naturality step.**

**`relTensorActR` coverage:** `lean:AlgebraicGeometry.Scheme.Modules.relTensorActR` is proved and clean in Lean but has **no blueprint entry**. Coverage debt.

**`relTensorProj` coverage:** `lean:AlgebraicGeometry.Scheme.Modules.relTensorProj` is a sorry stub in Lean (proved=False, has_sorry=True) with **no blueprint entry**. Both the Lean proof and the blueprint spec are absent. This is the critical blocker for step-2 naturality.

**SNAP carrier obstacle:** The memory records the `↥(P.obj U)` vs `↥((P.presheaf).obj U)` carrier gap breaking `map_tmul` for `relTensorActL`. This obstacle is real and the blueprint does not describe a resolution route for `relTensorProj`. A blueprint entry specifying the exact ModuleCat-presheaf route is needed before `relTensorProj` can be proved.

---

## 4. Coverage Debt (Lean decls with no blueprint entry)

All project-internal unmatched Lean decls (bare `lean:` nodes in leandag):

| Lean declaration | proved | has_sorry | Priority |
|-----------------|--------|-----------|----------|
| `Scheme.Modules.relTensorActR` | True | False | **HIGH** — directive focus, no blueprint entry |
| `Scheme.Modules.relTensorProj` | False | True | **HIGH** — sorry stub, no blueprint spec |
| `flat_localization_models` | True | False | **HIGH** — directive helper, missing entry |
| `isLocalizedModule_powers_restrictScalars` | True | False | **HIGH** — directive helper, missing entry |
| `flat_of_ringEquiv_semilinear` | True | False | MEDIUM — name mismatch with `lem:module_finite_of_ringEquiv_semilinear` pin |
| `gf_flat_isLocalizedModule_sameBase` | True | False | MEDIUM — name mismatch with `lem:gf_flat_localizedModule_sameBase` pin |
| `Scheme.Modules.objRestrict` | True | False | LOW — infrastructure helper |
| `Scheme.Modules.objRestrict_apply` | True | False | LOW |
| `Scheme.Modules.objRestrict_comp` | True | False | LOW |
| `Scheme.Modules.objRestrict_id` | True | False | LOW |
| `Scheme.Modules.opensTopology` | True | False | LOW |

**Also note:** `lem:composite_immersion_flocus_basicOpen` in `Picard_QuotScheme.tex` pins the same Lean name (`section_localization_hfr_basicOpen`) as the proved `lem:section_localization_hfr_basicOpen`. The duplicate is a dead node — the proof is already captured. Can be removed or relabelled.

---

## 5. Broken `\uses{}` References

**None found.** The leandag reports `broken_uses: []`. All `\uses{}` targets resolve to existing blueprint nodes.

---

## 6. Sorry-bearing nodes summary

13 nodes have `has_sorry=True` in the leandag:

| Node id | Chapter | proved | Note |
|---------|---------|--------|------|
| `lem:base_change_mate_fstar_reindex_legs_conj` | FBC | True | Full conjugate identity — core crux |
| `lem:base_change_mate_gstar_transpose` | FBC | True | Section-level crux (steps a/c) |
| `lem:affine_base_change_pushforward` | FBC | True | Key affine lemma |
| `thm:flat_base_change_pushforward` | FBC | True | Main FBC theorem |
| `thm:generic_flatness` | GF | True | Gated on G3 |
| `def:hilbert_polynomial` | QS | True | Depends on sectionGradedRing |
| `def:quot_functor` | QS | True | Depends on hilbert_polynomial |
| `def:grassmannian_scheme` | QS | True | Depends on quot_functor |
| `thm:grassmannian_representable` | QS | True | Weakened skeleton |
| `def:gr_universal_quotient_sheaf` | GRQ | True | Awaits bundle cocycle + glue |
| `def:tautological_quotient` | GRQ | True | Awaits bundle cocycle + glue |
| `thm:grassmannian_universal_property` | GRQ | True | Awaits glue clean |
| `lean:Scheme.Modules.relTensorProj` | SGR/SNAP | **False** | Sorry stub — no blueprint spec |

---

## 7. Not-proved nodes by chapter (28 total)

**FBC (5):** `sections_direct` (abandoned), `base_changed_equalizer_diagram`, `flat_base_change_separated`, `flat_base_change_mayer_vietoris`, `flat_base_change_reduce_global_sections`

**GF (1):** `gf_finite_gen_iff_free_epi` (G3 gate)

**SGR/SNAP (11):** `snap_ztensor_whisker_localIso`, `relativeTensor_as_coequalizer`, `isIso_sheafification_whiskerRight_unit`, `sheafTensorObjAssoc`, `sheafTensorPow_add`, `sectionMul_coherent`, `sectionGradedRing_gcommSemiring`, `sectionGradedModule_gmodule`, `sectionGradedRing`, `sectionGradedModule`, `sectionGradedModule_fg`

**QS (3):** `sectionGradedRing` (duplicate with SGR), `sectionGradedModule` (duplicate), `hilbertPoly_of_sectionModule`, `composite_immersion_flocus_basicOpen` (duplicate pin)

**GRQ (8):** `gr_bundleTransition`, `gr_bundleCocycle_id`, `gr_bundleCocycle_mul`, `gr_glueData_bridges`, `gr_modules_glueRestrictionIso`, `gr_modules_glue_unique`, `gr_modules_glueHom`, `gr_rankQuotient`

---

## 8. Unstarted-phase blueprint proposals

The following blueprint entries do not yet exist and should be added to unblock current or near-term proof lanes:

### SGR: `relTensorActR` blueprint entry
**Proposed node:** `def:relTensorActR`  
**Lean target:** `AlgebraicGeometry.Scheme.Modules.relTensorActR`  
**Content:** Right action natural transformation for the relative tensor presheaf, mirroring `def:relTensorActL`. State the ModuleCat-presheaf-level construction that sidesteps the `forget₂ CommRingCat→RingCat` carrier obstacle. Must address the `↥(P.obj U)` vs `↥((P.presheaf).obj U)` carrier gap explicitly.  
**Blocking:** `lem:relativeTensor_as_coequalizer` (step-2 naturality)

### SGR: `relTensorProj` blueprint entry
**Proposed node:** `def:relTensorProj` (or `lem:relTensorProj_isNatTrans`)  
**Lean target:** `AlgebraicGeometry.Scheme.Modules.relTensorProj`  
**Content:** The projection natural transformation for the relative tensor presheaf. Specify the ModuleCat-presheaf route that avoids the `map_tmul` carrier mismatch. This is the missing step-2 naturality spec the directive asks about.  
**Blocking:** `lem:relativeTensor_as_coequalizer`

### FS: `flat_localization_models` blueprint entry
**Proposed node:** `lem:flat_localization_models`  
**Lean target:** `AlgebraicGeometry.flat_localization_models`  
**Content:** Flatness is preserved by localization: if $M$ is flat over $R$, then $S^{-1}M$ is flat over $S^{-1}R$. Direct consequence of `Module.Flat.comp` + localization-is-flat.  
**Priority:** HIGH (proved axiom-clean in Lean, blueprint entry missing)

### FS: `isLocalizedModule_powers_restrictScalars` blueprint entry
**Proposed node:** `lem:isLocalizedModule_powers_restrictScalars`  
**Lean target:** `AlgebraicGeometry.isLocalizedModule_powers_restrictScalars`  
**Content:** `IsLocalizedModule (powers f)` is preserved under restriction of scalars along a compatible ring map. Bridge lemma for the ρ-agreement close in STEP-3.  
**Priority:** HIGH (proved axiom-clean in Lean, blueprint entry missing)

### FBC: Fix `\lean{}` name pins in FlatteningStratification
**Proposed action (not a new node, but a correction):**
- Fix `lem:module_finite_of_ringEquiv_semilinear` pin: `\lean{AlgebraicGeometry.flat_of_ringEquiv_semilinear}`
- Fix `lem:gf_flat_localizedModule_sameBase` pin: `\lean{AlgebraicGeometry.gf_flat_isLocalizedModule_sameBase}`

### GRQ: `def:gr_rankQuotient` blueprint completion
**Proposed node:** Extend current `def:gr_rankQuotient` entry with proof sketch  
**Content:** The rank-$d$ quotient predicate on modules over Grassmannian chart rings, serving as the fibre-type predicate for the tautological quotient. Required for cleaning `def:tautological_quotient` from sorry.

### FBC: FBC-A2 scaffold proposals (if clearing the sorry lane this iter)
If targeting FBC-A2 this iter:
- `lem:base_changed_equalizer_diagram`: Čech fork tensor-compatibility — proof is a direct naturality square over affine opens from `lem:affine_base_change_pushforward`. Scaffold-ready.
- `lem:flat_base_change_separated`: Flat equalizer commutation — proof is `flat_preserves_equalizer_mathlib` applied to the Čech fork. Scaffold-ready.
- `lem:flat_base_change_mayer_vietoris`: Mayer–Vietoris induction on finite cover size. Scaffold-ready.
- `lem:flat_base_change_reduce_global_sections`: Sheaf-level ↔ module-level reduction via tilde fully-faithful. Scaffold-ready.

These four, once proved, will clear the sorry from `lem:affine_base_change_pushforward` and `thm:flat_base_change_pushforward`.
