# Lean ↔ Blueprint Check Report

## Slug
grquot

## Iteration
079

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianQuot.lean`
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianQuot.tex`

---

## Per-declaration

The blueprint chapter has ~67 `\lean{...}` pins. Only the non-trivially-resolvable ones are called out individually below; the full list is appended in the Unreferenced section. All declarations verified by direct `grep` against the Lean file.

### `\lean{AlgebraicGeometry.Grassmannian.tautologicalQuotient_epi}` (lem:tautologicalQuotient_epi)
- **Lean target exists**: yes (line 2469)
- **Signature matches**: yes — `Epi (tautologicalQuotient d r)`
- **Proof follows sketch**: **no** — body is `:= sorry` (line 2470); blueprint chapter claims `\leanok` (line 2187)
- **notes**: Blueprint `\leanok` marker is stale (sync_leanok must have misclassified or the sorry was introduced post-sync). This is a must-fix.

### `\lean{AlgebraicGeometry.Grassmannian.represents}` (thm:grassmannian_universal_property)
- **Lean target exists**: yes (line 4425)
- **Signature matches**: yes — `(functor d r).RepresentableBy (scheme d r)` with `hd : 1 ≤ d`, `hdr : d ≤ r`
- **Proof follows sketch**: **no** — `homEquiv.left_inv` and `homEquiv.right_inv` are both `:= sorry` (lines 4435, 4440); blueprint has `\leanok` (line 2405)
- **notes**: The `homEquiv_comp` direction is closed (line 4441-4446 using `(functor d r).map_comp`). Only the two inverse-law halves remain open. Still, two sorrys inside a `\leanok`-tagged block is a must-fix.

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree}` (lem:gr_chartQuotientMap_iFree)
- **Lean target exists**: yes (line 314), but declared **`private`**
- **Signature matches**: partial — blueprint calls it a public lemma; Lean makes it private so `AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree` is not an accessible name. The proof content is correct.
- **Proof follows sketch**: yes
- **notes**: The `\lean{}` pin references an inaccessible private name. Minor issue; `sync_leanok` cannot verify private declarations. Blueprint should either remove the pin or the Lean should make it non-private.

### `\lean{AlgebraicGeometry.Grassmannian.exists_isUnit_submatrix}` (lem:gr_exists_isUnit_submatrix)
- **Lean target exists**: yes (line 2544), but declared **`private`**
- **Signature matches**: partial — same situation as `chartQuotientMap_ιFree`
- **Proof follows sketch**: yes
- **notes**: Same private-pin issue as above. Minor.

### All other `\lean{}` pins (resolved, no sorry, signature OK)

The following were verified to exist in the Lean file with no sorry and matching signatures. Listed for completeness:

`globalUnitSection`, `scalarEnd`, `scalarEnd_one`, `scalarEnd_zero`, `scalarEnd_comp`, `scalarEnd_add`, `scalarEnd_sum`, `matrixEnd`, `matrixEnd_comp`, `matrixEnd_one`, `matrixToFreeIso`, `matrixToFreeIso_hom`, `matrixToFreeIso_mul`, `chartQuotientMap`, `chartQuotientMap_epi`, `universalMinorInv_self`, `bundleTransition`, `bundleTransition_self`, `bundleTransitionData`, `bundleTransition_cocycle_matrix`, `scalarEnd_pullback`, `matrixEnd_pullback`, `baseChange_bridge_gammaSpec`, `baseChange_bridge_left`, `baseChange_bridge_right`, `baseChange_bridge_transition`, `baseChange_bridge`, `bundleTransition_cocycle_transport`, `bundleTransition_cocycle`, `universalQuotient`, `matrixEnd_eq_matrixEndRect`, `matrixEndRect_one`, `matrixEndRect_comp_rect`, `matrixEndRect_injective`, `freeMap_matrixEndRect`, `exists_section_of_epi_free_spec`, `exists_rightInverse_of_epi_matrixEndRect_spec`, `exists_rightInverse_of_epi_matrixEndRect`, `pullbackFreeIso_inv_freeMap`, `presentedMatrix`, `matrixEndRect_presentedMatrix`, `matrixEndRect_presentedMatrix_minor`, `presentedMatrix_changeOfBasis`, `isUnit_of_isIso_matrixEndRect`, `matrixEndRect`, `matrixEndRect_pullback`, `matrixEndRect_comp`, `tautologicalQuotientComponent_transpose`, `tautologicalQuotient_overlap`, `tautologicalQuotient`, `RankQuotient`, `RankQuotient.Rel`, `RankQuotient.rel_refl`, `RankQuotient.rel_symm`, `RankQuotient.rel_trans`, `rqSetoid`, `rqPullback`, `rqPullback_rel`, `functor`, `isoLocus`, `isIso_pullback_isoLocus_map`, `chartLocus`, `chartLocus_isOpenCover`, `grPointOfRankQuotient`.

Notes on Mathlib-backed declarations (verified by `\mathlibok` or `% NOTE: forward declaration`):
- `pullbackComp` — Mathlib (`\mathlibok`), not in GrassmannianQuot.lean (correct)
- `glue_unique`, `glueHom` — forward declarations with `% NOTE: ... not yet realised`; not expected in Lean file (correct)
- `pullbackBaseChangeTransport`, `glueData_bridge_*`, `glue`, `opensMap_final`, `pullbackFreeIso`, `pullbackFreeIso_eqToHom`, `pullbackFreeIso_trans_symm_eqToIso`, `pullback_isLocallyFreeOfRank`, `pullbackObjUnitToUnit_id`, `pullbackFreeIso_id`, `pullbackObjUnitToUnit_comp`, `homEquiv_conjugateEquiv_app`, `pullbackFreeIso_comp` — all live in `GlueDescent.lean` (imported); not expected in this file (correct)
- `isIso_of_stalkFunctor_map_iso` — Mathlib, correct

---

## Red flags

### Placeholder / suspect bodies — **MUST FIX**

- **`tautologicalQuotient_epi`** at line 2470: `:= sorry`; blueprint `lem:tautologicalQuotient_epi` has `\leanok`. The proof is described in the blueprint (`u^I` is split epi on each chart, epimorphism is local). Stale `\leanok` marker. **Must-fix-this-iter.**

- **`represents.homEquiv.left_inv`** at line 4435: `:= sorry`; the outer `represents` block has `\leanok` at blueprint line 2405. The left inverse law (`grPointOfRankQuotient(ψ^* (U, u)) = ψ`) is the harder uniqueness direction. **Must-fix-this-iter** (the containing `represents` carries `\leanok` but its proof is incomplete).

- **`represents.homEquiv.right_inv`** at line 4440: `:= sorry`; same container, same `\leanok` issue. The right inverse (`(grPointOfRankQuotient x)^* (U, u) ~ x`) requires `universalQuotient_restrictionIso`. **Must-fix-this-iter.**

### Private declarations with public `\lean{}` pins — **minor**

- `chartQuotientMap_ιFree` (line 314): declared `private`; blueprint pin `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree}` with `\leanok`. The pin names an inaccessible identifier. `sync_leanok` cannot find it; the `\leanok` marker is unreliable for private decls.
- `exists_isUnit_submatrix` (line 2544): same situation.

### False positive "broken pins" from iter-078 — **resolved**

All previously-flagged relocations are confirmed to resolve correctly in the current file state. The ~11 new supporting lemmas for `chartMorphism_glue_compat` are present and well-below the `conjPullback` transport block (lines 3273–3341), consistent with the relocation note. None produce broken pins because they have no `\lean{}` references in the blueprint to mislocate.

---

## Unreferenced declarations (informational)

The following are **substantive** declarations in the Lean file with no corresponding `\lean{}` pin in the blueprint. Pure helpers and `private` utilities are omitted.

### Iter-079 additions (new this iteration — 1-to-1 debt)

| Declaration | Line | Why notable |
|---|---|---|
| `chartMorphism_glue_compat` | 4194 | Main new lemma closing the overlap-compatibility sorry; substantive |
| `comp_chartMorphism` | 4116 | Key lemma: `p ≫ chartMorphism I = ...`; used in glue_compat |
| `presentedMatrix_comp` | 3927 | Pullback-composition of presentedMatrix; foundational |
| `chart_point_eq` | 4070 | Identifies chart morphism at a field point; key for uniqueness |
| `universalMatrix_map_presentedMatrix` | 3995 | Image matrix identity for presentedMatrix |
| `imageMatrix_map_ringHom` | 4038 | Ring-hom naturality for imageMatrix; bridges matrix and geometry |
| `chartComposite_rqPullback` | 3201 | chartComposite respects rqPullback; needed for functor coherence |

### Pre-existing unreferenced substantive declarations

| Declaration | Line | Why notable |
|---|---|---|
| `tautologicalRankQuotient` | 2475 | Packages (U,u) as a RankQuotient; used in `represents` |
| `universalQuotient_restrictionIso` | 2419 | Restriction iso for universal quotient |
| `universalQuotient_isLocallyFreeOfRank` | 2434 | Local freeness of U |
| `grPointOfRankQuotient_rel` | 4389 | grPointOfRankQuotient respects equivalence |
| `mem_isoLocus` | 2502 | Characterises points in isoLocus |
| `isIso_pullback_map_of_le` | 2511 | Open restriction is iso if on isoLocus |
| `chartComposite` | 2527 | Chart composite s_I ∘ q as a sheaf morphism |
| `chartMatrixHom` | 2919 | Free-sheaf hom reading off presented matrix |
| `chartMatrix` | 2935 | Presented matrix over chart locus |
| `chartMorphism` | 2945 | The chart morphism T_I → U^I |
| `conjPullback_congr` | 3273 | Generic subst for IsIso under morph eq |
| `pullbackFreeIso_inv_pullbackComp` | 3291 | Free-pullback vs pullback-comp interaction |
| `conjPullback_comp` | 3311 | Pullback-conjugated composition |
| `isIso_pullback_chartLocus_map` | 3696 | IsIso instance for chart composite at chart locus |
| `freeMap_chartMatrixHom` | 3706 | freeMap vs chartMatrixHom identity |
| `chartComposite_rel` | 3189 | chartComposite respects Rel |
| `chartLocus_rel` | 3235 | chartLocus respects Rel |
| `chartMorphism_rel` | 3618 | chartMorphism respects Rel |
| `chartMatrixHom_rel` | 3493 | chartMatrixHom respects Rel |
| `chartMatrixHom_transport` | 3534 | chartMatrixHom transport under Rel |
| `chartMatrix_rel` | 3587 | chartMatrix respects Rel |
| `presentedMatrix_congr` | 3907 | presentedMatrix congruence in morphism |
| `chartMatrix_eq_presentedMatrix` | 3916 | chartMatrix = presentedMatrix at chartLocus |
| `presentedMatrix_submatrix_self` | 3978 | Self-minor of presentedMatrix is identity |
| `chartMatrix_minor` | 3846 | Minor of chartMatrix |
| `isIso_pullback_map_comp` | 3897 | IsIso composes correctly |
| `matrixMap_nonsing_inv` | 4026 | Ring-hom naturality for nonsing_inv |
| `unitEndSection_id`, `unitEndSection_zero` | 3834, 3838 | Helper lemmas for unitEndSection |
| `tripleOverlapSections` | 1431 | Helper structure for triple-overlap base change |

---

## Blueprint adequacy for this file

- **Coverage**: ~67 `\lean{...}` pins in the chapter; approximately 150+ Lean declarations in the file. The pinned declarations cover: the entire infrastructure (scalar/matrix endomorphisms, gluing, bundle transitions, cocycles), the tautological quotient, and the functor/universal-property definitions. Unreferenced: ~35 substantive helper declarations (listed above).
- **Proof-sketch depth**: **under-specified**. The universal property section (§ `sec:grquot_universal`) describes `grPointOfRankQuotient` at a high level but does not sketch the 20+ supporting lemmas the Lean requires: chart morphism construction, presentedMatrix API, conjPullback transport lemmas, and the `chartMorphism_glue_compat` overlap proof. The prover was clearly forced to build this infrastructure without blueprint guidance.
- **Hint precision**: **mostly precise** for the covered declarations. All `\lean{...}` pins name correct, existing Lean identifiers (modulo the two private-declaration issues). No wrong-predicate issues detected.
- **Generality**: **matches need** for covered declarations. The rectangular `matrixEndRect` API was added to the blueprint (§ Matrix-calculus toolbox) and correctly matches the Lean implementation.

**Recommended chapter-side actions** (for the blueprint-writing subagent):
1. Add `\lean{}` blocks for `chartMorphism_glue_compat`, `comp_chartMorphism`, `presentedMatrix_comp`, `chart_point_eq`, `universalMatrix_map_presentedMatrix`, `imageMatrix_map_ringHom`, `chartComposite_rqPullback` — the seven iter-079 substantive additions.
2. Add proof sketches for `tautologicalQuotient_epi` (currently `\leanok` but sorry'd — the epimorphism-is-local argument is there in the blueprint comment but needs to be turned into a real proof sketch that the prover can follow).
3. Add `\lean{}` blocks for `tautologicalRankQuotient`, `universalQuotient_restrictionIso`, `universalQuotient_isLocallyFreeOfRank` — these are needed to complete `represents`.
4. Add a `chartMorphism` definition block with a brief description of the chart-by-chart construction and its Lean realisation (the existing `def:grPointOfRankQuotient` block describes the mathematical content, but the Lean splits this into `chartMorphism`, `chartMatrix`, `chartComposite`, etc.).
5. Fix the two `private`-declaration `\lean{}` pins: either make `chartQuotientMap_ιFree` and `exists_isUnit_submatrix` non-private, or remove those `\lean{}` pins from the blueprint (or replace with `\mathlibok` noting them as project-internal helpers).
6. The `def:gr_rankQuotient` block (line 1958 in blueprint) has no `\leanok` — consistent with the Lean having it implemented but `def:gr_rankQuotient` being a container for many sub-items some of which may still be in progress.

---

## Severity summary

| Finding | Severity |
|---|---|
| `tautologicalQuotient_epi`: `:= sorry` with `\leanok` in blueprint | **must-fix-this-iter** |
| `represents.left_inv`: `:= sorry` inside `\leanok`-tagged `represents` | **must-fix-this-iter** |
| `represents.right_inv`: `:= sorry` inside `\leanok`-tagged `represents` | **must-fix-this-iter** |
| 7 iter-079 new lemmas with no `\lean{}` blueprint pins (1:1 debt) | **major** |
| ~20 pre-existing unreferenced substantive declarations | **major** |
| `chartQuotientMap_ιFree`: private but `\lean{}` pin present | **minor** |
| `exists_isUnit_submatrix`: private but `\lean{}` pin present | **minor** |
| Blueprint proof-sketch depth insufficient for the universal-property section | **major** (blocks prover for `represents` left/right_inv) |

**Overall verdict**: Three must-fix-this-iter findings (two sorry'd inverse-law proofs inside a `\leanok`-tagged `represents`, one sorry'd `tautologicalQuotient_epi`) block the chapter from being considered closed; the blueprint chapter is under-specified for the Nitsure-inverse construction and needs expansion to support closing those sorries.
