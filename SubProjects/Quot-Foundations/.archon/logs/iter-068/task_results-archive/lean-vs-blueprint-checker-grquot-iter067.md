# Lean ↔ Blueprint Check Report

## Slug
grquot-iter067

## Iteration
067

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianQuot.lean`
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianQuot.tex`

---

## Per-declaration

### `\lean{Grassmannian.globalUnitSection}` (chapter: `def:gr_globalUnitSection`)
- **Lean target exists**: yes — line 38
- **Signature matches**: yes. `(a : Γ(X, ⊤)) : (SheafOfModules.unit X.ringCatSheaf).sections`. Blueprint: "section `a` determines a global section of the unit module by restricting to every open." ✓
- **Proof follows sketch**: yes — `PresheafOfModules.sectionsMk` with a naturality check, exactly the blueprint's "compatibility with restriction maps because restriction is functorial."
- **notes**: none

### `\lean{Grassmannian.scalarEnd}` (chapter: `def:gr_scalarEnd`)
- **Lean target exists**: yes — line 51
- **Signature matches**: yes. `(a : Γ(X, ⊤)) : SheafOfModules.unit X.ringCatSheaf ⟶ SheafOfModules.unit X.ringCatSheaf`. Blueprint: "multiplication by `a` on the unit module."
- **Proof follows sketch**: yes — uses `unitHomEquiv.symm (globalUnitSection a)`, matching "obtained from the global section under `End(1) ≅ Γ(X,1)`."
- **notes**: none

### `\lean{Grassmannian.scalarEnd_one}` (chapter: `lem:gr_scalarEnd_one`)
- **Lean target exists**: yes — line 57
- **Signature matches**: yes. `scalarEnd (1 : Γ(X, ⊤)) = 𝟙 _`
- **Proof follows sketch**: yes — uses `Equiv.symm_apply_eq` + section extensionality + `map_one`. Matches blueprint.
- **notes**: none

### `\lean{Grassmannian.scalarEnd_zero}` (chapter: `lem:gr_scalarEnd_zero`)
- **Lean target exists**: yes — line 68
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{Grassmannian.scalarEnd_comp}` (chapter: `lem:gr_scalarEnd_comp`)
- **Lean target exists**: yes — line 99
- **Signature matches**: yes. `scalarEnd a ≫ scalarEnd b = scalarEnd (a * b)`. Blueprint has "compose by multiplication," same statement.
- **Proof follows sketch**: yes — via `unitHomEquiv.injective`, section-ext, `RingHom.map_mul`. Matches blueprint's "section ring is commutative, restriction maps are ring homs."
- **notes**: none

### `\lean{Grassmannian.scalarEnd_add}` (chapter: `lem:gr_scalarEnd_add`)
- **Lean target exists**: yes — line 113
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{Grassmannian.scalarEnd_sum}` (chapter: `lem:gr_scalarEnd_sum`)
- **Lean target exists**: yes — line 125
- **Signature matches**: yes
- **Proof follows sketch**: yes — induction exactly as in blueprint
- **notes**: none

### `\lean{Grassmannian.matrixEnd}` (chapter: `def:gr_matrixEnd`)
- **Lean target exists**: yes — line 148
- **Signature matches**: yes. `(M : Matrix (Fin d) (Fin d) Γ(S, ⊤)) : free (Fin d) ⟶ free (Fin d)`. Blueprint: "assembled from scalarEnd components over the biproduct."
- **Proof follows sketch**: yes — `biproduct.isoCoproduct.symm.hom ≫ biproduct.matrix (fun i p => scalarEnd (M p i)) ≫ …hom`. Exact biproduct-assembly.
- **notes**: Column index order `M p i` (output-row `p`, input-col `i`) reflects the column-contravariance mentioned in the blueprint; consistent throughout.

### `\lean{Grassmannian.matrixEnd_comp}` (chapter: `lem:gr_matrixEnd_comp`)
- **Lean target exists**: yes — line 170
- **Signature matches**: yes. `matrixEnd M ≫ matrixEnd N = matrixEnd (N * M)` — reversed order noted in both blueprint and Lean.
- **Proof follows sketch**: yes — `biproduct_matrix_comp`, `scalarEnd_comp`, `scalarEnd_sum`, matching blueprint's categorical matrix product argument.
- **notes**: none

### `\lean{Grassmannian.matrixEnd_one}` (chapter: `lem:gr_matrixEnd_one`)
- **Lean target exists**: yes — line 186
- **Signature matches**: yes
- **Proof follows sketch**: yes — diagonal/off-diagonal case split using `scalarEnd_one`/`scalarEnd_zero`, exactly as blueprint.
- **notes**: none

### `\lean{Grassmannian.matrixToFreeIso}` (chapter: `def:gr_matrixToFreeIso`)
- **Lean target exists**: yes — line 202
- **Signature matches**: yes. Takes `M N` with `M * N = 1` and `N * M = 1`; hom=`matrixEnd M`, inv=`matrixEnd N`.
- **Proof follows sketch**: yes — `hom_inv_id` via `matrixEnd_comp` + `hNM` + `matrixEnd_one`.
- **notes**: none

### `\lean{Grassmannian.matrixToFreeIso_hom}` (chapter: `lem:gr_matrixToFreeIso_hom`)
- **Lean target exists**: yes — line 211 (`@[simp]`)
- **Signature matches**: yes — `(matrixToFreeIso M N hMN hNM).hom = matrixEnd M := rfl`
- **Proof follows sketch**: N/A (blueprint: "immediate from definition") — `rfl`.
- **notes**: none

### `\lean{Grassmannian.matrixToFreeIso_mul}` (chapter: `lem:gr_matrixToFreeIso_mul`)
- **Lean target exists**: yes — line 220
- **Signature matches**: yes. Blueprint: `matrixToFreeIso(A,A').hom ≫ matrixToFreeIso(B,B').hom = matrixEnd(B·A)`.
- **Proof follows sketch**: yes — `matrixToFreeIso_hom` + `matrixEnd_comp`.
- **notes**: none

### `\lean{Grassmannian.chartQuotientMap}` (chapter: `def:gr_chart_quotient`)
- **Lean target exists**: yes — line 298
- **Signature matches**: yes. `free (Fin r) ⟶ free (Fin d)` on `affineChart d r I`.
- **Proof follows sketch**: yes — biproduct-assembly over `scalarEnd` of the injected universal matrix entries, exactly matching blueprint.
- **notes**: none

### `\lean{Grassmannian.chartQuotientMap_ιFree}` (chapter: `lem:gr_chartQuotientMap_iFree`)
- **Lean target exists**: yes — line 314, but declared **`private`**
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: **minor** — the `\lean{...}` blueprint pin references a `private` declaration; fully-qualified names of private declarations are not externally accessible. The pin cannot be resolved by `lean_verify`/`sorry_analyzer` tooling. The proof content is correct.

### `\lean{Grassmannian.chartQuotientMap_epi}` (chapter: `lem:gr_chartQuotientMap_epi`)
- **Lean target exists**: yes — line 356
- **Signature matches**: yes
- **Proof follows sketch**: yes — split-epi via the `I`-coordinate inclusion, uses `chartQuotientMap_ιFree`, matches blueprint exactly.
- **notes**: none

### `\lean{Grassmannian.universalMinorInv_self}` (chapter: `lem:gr_universalMinorInv_self`)
- **Lean target exists**: yes — line 387
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{Grassmannian.bundleTransition}` (chapter: `def:gr_bundleTransition`)
- **Lean target exists**: yes — line 418
- **Signature matches**: yes. `pullbackFreeIso (chartIncl I J) ≪≫ matrixToFreeIso ((ΓSpecIso).inv • (X^I_J)⁻¹) … ≪≫ (pullbackFreeIso (t_IJ ≫ f_JI)).symm`. Matches blueprint's "conjugation of the matrix automorphism by the free-pullback comparisons."
- **Proof follows sketch**: N/A (term-mode definition)
- **notes**: none

### `\lean{Grassmannian.bundleTransition_self}` (chapter: `lem:gr_bundleCocycle_id`)
- **Lean target exists**: yes — line 452
- **Signature matches**: yes
- **Proof follows sketch**: yes. Blueprint route: "matrix automorphism collapses to Iso.refl since (X^I_I)⁻¹ = 1, then free-pullback comparisons cancel." Lean proof: `hB : matrixToFreeIso ... = Iso.refl _` (via `universalMinorInv_self`, `map_one`, `matrixEnd_one`), then `pullbackFreeIso_trans_symm_eqToIso` closes. Matches blueprint.
- **notes**: Resource note in the Lean docstring about iter-060 heartbeat budget is fine (not an excuse-comment).

### `\lean{Grassmannian.bundleTransitionData}` (chapter: `def:gr_bundleTransitionData`)
- **Lean target exists**: yes — line 485
- **Signature matches**: yes — thin packaging over `bundleTransition`
- **Proof follows sketch**: N/A
- **notes**: none

### `\lean{Grassmannian.bundleTransition_cocycle_matrix}` (chapter: `lem:gr_bundleCocycle_matrix`)
- **Lean target exists**: yes — line 644
- **Signature matches**: yes. Blueprint: `(X^J_K)⁻¹ (X^I_J)⁻¹ = (X^I_K)⁻¹` over the triple-overlap ring. Lean statement is the image-matrix version of this identity.
- **Proof follows sketch**: yes — takes the I-minor of `cocycle_imageMatrix_eq'`, decomposes via `imageMatrix` and `mul_submatrix_col'`, then cancels using `inv_mul_inv_mul_cancel'`. Matches blueprint's "take the I-indexed columns, apply (AB)⁻¹ = B⁻¹A⁻¹, cancel."
- **notes**: The private ports of GrassmannianCells lemmas (lines 503–637) are internal helpers; blueprint notes these as "already in hand" via `lem:gr_cocycle`. No concern.

### `\lean{Grassmannian.scalarEnd_pullback}` (chapter: `lem:gr_scalarEnd_pullback`)
- **Lean target exists**: yes — line 761
- **Signature matches**: yes. `(pullback p).map (scalarEnd a) ≫ pullbackObjUnitToUnit = pullbackObjUnitToUnit ≫ scalarEnd (p.appTop a)`. Blueprint: `q ∘ p^*(scalarEnd(a)) = scalarEnd(p♯a) ∘ q`.
- **Proof follows sketch**: yes — via pullback-pushforward adjunction transposition and `unitToPushforward_scalarEnd_comm`. Matches blueprint's "adjunction transposition."
- **notes**: none

### `\lean{Grassmannian.matrixEnd_pullback}` (chapter: `lem:gr_matrixEnd_pullback`)
- **Lean target exists**: yes — line 806
- **Signature matches**: yes. Blueprint: `p^*(matrixEnd M) = Q⁻¹ ∘ matrixEnd(p♯M) ∘ Q`. Lean form: `(pullback p).map (matrixEnd M) = Q.hom ≫ matrixEnd (...) ≫ Q.inv`.
- **Proof follows sketch**: yes — cofan extensionality, reduces to `scalarEnd_pullback` on each biproduct component.
- **notes**: none

### `\lean{Grassmannian.matrixEndRect}` (chapter: `def:gr_matrixEndRect`)
- **Lean target exists**: yes — line 244
- **Signature matches**: yes — rectangular `d×r` analogue of `matrixEnd`
- **Proof follows sketch**: N/A (definition)
- **notes**: none

### `\lean{Grassmannian.matrixEndRect_pullback}` (chapter: `lem:gr_matrixEndRect_pullback`)
- **Lean target exists**: yes — line 878
- **Signature matches**: yes
- **Proof follows sketch**: yes — identical skeleton to `matrixEnd_pullback`
- **notes**: none

### `\lean{Grassmannian.matrixEndRect_comp}` (chapter: `lem:gr_matrixEndRect_comp`)
- **Lean target exists**: yes — line 271
- **Signature matches**: yes. `matrixEndRect M ≫ matrixEnd N = matrixEndRect (N * M)`.
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{Grassmannian.baseChange_bridge_gammaSpec}` (chapter: `lem:gr_baseChange_bridge_gammaSpec`)
- **Lean target exists**: yes — line 1016
- **Signature matches**: yes. Blueprint: "comorphism of `Spec φ` is identified with `φ`." Lean: `(ΓSpecIso A).inv ≫ (Spec.map φ).appTop = φ ≫ (ΓSpecIso B).inv`.
- **Proof follows sketch**: yes — `Scheme.ΓSpecIso_naturality`; blueprint says "naturality of the counit."
- **notes**: none

### `\lean{Grassmannian.baseChange_bridge_left}` (chapter: `lem:gr_baseChange_bridge_left`)
- **Lean target exists**: yes — line 1039
- **Signature matches**: yes
- **Proof follows sketch**: yes — uses `awayPullbackIso_inv_fst` + `baseChange_bridge_gammaSpec`
- **notes**: none

### `\lean{Grassmannian.baseChange_bridge_right}` (chapter: `lem:gr_baseChange_bridge_right`)
- **Lean target exists**: yes — line 1071
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{Grassmannian.baseChange_bridge_transition}` (chapter: `lem:gr_baseChange_bridge_transition`)
- **Lean target exists**: yes — line 1105
- **Signature matches**: yes. Blueprint identifies `t'_{IJK}` comorphism with `Θ_{IJ} ∘ awayInclRight`. Lean proves the `appTop` of the transition composite equals that composite ring hom.
- **Proof follows sketch**: yes — uses `awayPullbackIso_inv_fst`, `htail` (the three `Spec.map` fusion), `awayMulCommEquiv_comp_awayInclLeft`, `baseChange_bridge_gammaSpec`.
- **notes**: none

### `\lean{Grassmannian.baseChange_bridge}` (chapter: `lem:gr_baseChange_bridge`)
- **Lean target exists**: yes — line 1162
- **Signature matches**: yes — assembles the three projection bridges into a single matrix-cocycle identity at the scheme level
- **Proof follows sketch**: yes — routes through the three individual bridges, applies `bundleTransition_cocycle_matrix` via a `calc` chain
- **notes**: none

### `\lean{Grassmannian.bundleTransition_cocycle_transport}` (chapter: `lem:gr_bundleCocycle_transport`)
- **Lean target exists**: yes — line 1239 (with `set_option maxHeartbeats 1600000`)
- **Signature matches**: yes. Blueprint: "each transport = matrixEnd(base-changed Cramer inverse) after conjugation by free comparisons; the composite satisfies ĝ_{JK} ∘ ĝ_{IJ} = ĝ_{IK}."
- **Proof follows sketch**: yes — (1) expands three transports via `pullbackBaseChangeTransport_matrixToFreeIso`, (2) applies `baseChange_bridge` for the matrix identity, (3) uses endpoint-cast collapse lemmas (`pullbackFreeIso_inv_congr_hom_assoc` etc.) and `matrixEnd_comp`. Route matches blueprint description.
- **notes**: The `set_option maxHeartbeats 1600000` is documented in-file as covering `isDefEq` cost on heavy localisation objects; not a red flag (see `bundleTransition_self` precedent).

### `\lean{Grassmannian.bundleTransition_cocycle}` (chapter: `lem:gr_bundleCocycle_mul`)
- **Lean target exists**: yes — line 1401 (with `set_option maxHeartbeats 1600000`)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `Iso.ext` reduces to `bundleTransition_cocycle_transport`
- **notes**: none

### `\lean{Grassmannian.universalQuotient}` (chapter: `def:gr_universal_quotient_sheaf`)
- **Lean target exists**: yes — line 1434
- **Signature matches**: yes. `Scheme.Modules.glue (theGlueData d r) (fun I => free (Fin d)) bundleTransitionData bundleTransition_self bundleTransition_cocycle`.
- **Proof follows sketch**: N/A (definition)
- **notes**: none

### `\lean{Grassmannian.tautologicalQuotientComponent_transpose}` (chapter: `lem:gr_tautologicalQuotientComponent_transpose`)
- **Lean target exists**: yes — line 1769
- **Signature matches**: yes. Blueprint: "descent condition ↔ pullback-level identity `g_{IJ} ∘ f*u^I = (t∘f)* u^J`."
- **Proof follows sketch**: yes — `Scheme.Modules.glueLift_cond_iff` (the generic adjunction transpose lemma).
- **notes**: none

### `\lean{Grassmannian.tautologicalQuotient_overlap}` (chapter: `lem:gr_tautologicalQuotient_overlap`)
- **Lean target exists**: yes — line 1468 (with `set_option maxHeartbeats 1600000`)
- **Signature matches**: yes. Blueprint: "pullback-level identity `g_{IJ} ∘ f*u^I = (t∘f)*u^J`."
- **Proof follows sketch**: yes. Blueprint route: (i) expand both sides as `matrixEndRect` of d×r matrices, (ii) LHS uses `matrixEndRect_comp` + `(X^I_J)⁻¹·X^I = X^J` identity, (iii) RHS uses `matrixEndRect_pullback` along `t∘f`. Lean proof follows this route using `matrixEndRect_pullback`, `matrixEndRect_comp`, `universalMatrix_map_transitionPreMap`, `imageMatrix`, `universalMinorInv_mul_cancel`.
- **notes**: The proof is complex (≈300 lines) due to the `X.Modules` diamond defeq issues, but the mathematical content matches the blueprint.

### `\lean{Grassmannian.tautologicalQuotient}` (chapter: `def:tautological_quotient`)
- **Lean target exists**: yes — line 1828
- **Signature matches**: yes. `SheafOfModules.free (Fin r) ⟶ universalQuotient d r`. Blueprint: `u : O^r ↠ U`.
- **Proof follows sketch**: N/A (`glueLift` of `tautologicalQuotientComponent`, uses `tautologicalQuotientComponent_transpose.mpr tautologicalQuotient_overlap`)
- **notes**: none

### `\lean{Grassmannian.RankQuotient, ...rqPullback_rel}` (chapter: `def:gr_rankQuotient`)
- **Lean target exists**: yes — lines 1857–1924. All six sub-targets present: `RankQuotient` (structure), `RankQuotient.Rel` (def), `rel_refl`, `rel_symm`, `rel_trans`, `rqSetoid` (instance), `rqPullback` (def), `rqPullback_rel` (lemma).
- **Signature matches**: yes. Blueprint: "triple ⟨F, q⟩ with F loc-free rank d and q epi; equivalence is an isomorphism of F's commuting with q maps." Lean structure has `F`, `q`, `epi`, `locFree`. `Rel` is `∃ f : F ≅ F', q ≫ f.hom = q'`. ✓
- **Proof follows sketch**: yes — `rel_refl`/`rel_symm`/`rel_trans` match blueprint's explicit proofs; `rqPullback_rel` uses functoriality of pullback.
- **notes**: none

### `\lean{Grassmannian.functor}` (chapter: `def:grassmannian_functor`)
- **Lean target exists**: yes — line 1939
- **Signature matches**: yes. `Scheme.{0}ᵒᵖ ⥤ Type 1`. Blueprint says `Grass(r,d)` is a functor to sets. Universe `Type 1` is documented in the Lean comment as a correction from `Type 0` (sheaves of modules are large objects); this is a correct fix, not a signature mismatch.
- **Proof follows sketch**: yes — `map_id` and `map_comp` use `pullbackFreeIso_id`/`pullbackFreeIso_comp` as described in blueprint's "two coherence blocks."
- **notes**: none

### `\lean{Grassmannian.represents}` (chapter: `thm:grassmannian_universal_property`)
- **Lean target exists**: yes — line 3107
- **Signature matches**: yes. `(functor d r).RepresentableBy (scheme d r)` given `1 ≤ d`, `d ≤ r`. Blueprint: "Gr(r,d) with ⟨U,u⟩ represents Grass(r,d)."
- **Proof follows sketch**: partial. Blueprint describes three parts: forward map, inverse, two inverse laws. Lean implements: `toFun` ✓, `invFun` (via `grPointOfRankQuotient`) ✓, `homEquiv_comp` ✓; both `left_inv` and `right_inv` are **sorried** with route comments. Per the directive, these are pre-known sorried components.
- **notes**: The `homEquiv_comp` proof (`(functor d r).map_comp` at the tautological point) is non-trivial and fully proved. ✓

---

## Red flags

### Placeholder / suspect bodies

The following sorried declarations are **pre-acknowledged in the directive** as known-incomplete; statement-`\leanok` is documented project semantics:

- `tautologicalQuotient_epi` (line 2065): sorry with route comment. Blueprint's informal proof describes the route (epi-ness is chart-local, chart-level epi given by `chartQuotientMap_epi`).
- `chartLocus_isOpenCover` (line 2145): sorry with route comment.
- `isIso_pullback_isoLocus_map` (line 2158): sorry with route comment.
- Inner overlap-compatibility sorry inside `grPointOfRankQuotient` (line 2249): sorry with route comment.
- `represents.left_inv` (line 3117): sorry with route comment.
- `represents.right_inv` (line 3120): sorry with route comment.

**None of these are surprise red flags.** The route comments are implementation plans (e.g. "PROOF ROUTE (scoped iter-067, not yet formalized): …"), not "TODO: replace with real def" excuse-comments. They document legitimate open proof obligations.

### Excuse-comments
None found.

### Axioms / Classical.choice on non-trivial claims
None found.

### Private declaration with `\lean{}` pin

`\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree}` at `lem:gr_chartQuotientMap_iFree` (chapter line ~817) pins a `private lemma` (Lean file line 314). Private declarations in Lean 4 do not acquire fully-qualified namespace names for external access, so `lean_verify` / `sorry_analyzer` cannot resolve this pin. The proof is correct; the declaration just should not be private if the blueprint references it, or the `\lean{}` pin should be removed.

---

## Unreferenced declarations (informational)

### Substantive declarations with no `\lean{}` reference — missing coverage, not laundering

**Category A — ~18 transport-chain helpers for `grPointOfRankQuotient_rel` (directive pre-noted; coverage writer was killed):**
| Declaration | Line | Notes |
|---|---|---|
| `scalarEnd_unitEndSection` | 2302 | Converse of `unitEndSection_scalarEnd`; real lemma |
| `ιFree_projFree` | 2321 | Entry extraction helper |
| `ιFree_matrixEndRect_projFree` | 2334 | Entry extraction for `matrixEndRect` |
| `matrixEndRect_unitEndSection` | 2349 | Matrix presentation of free-sheaf morphisms |
| `pullback_conj_matrixEndRect` | 2374 | Naturality rearranged |
| `conjPullback_congr` | 2386 | Congruence for conjugated pullbacks |
| `pullbackFreeIso_inv_pullbackComp` | 2404 | Inverse-side free coherence |
| `conjPullback_comp` | 2424 | Pseudofunctor coherence for conjugated chart data |
| `chartMatrixHom_rel` | 2606 | iso-cancellation in presenting morphism |
| `chartMatrixHom_transport` | 2647 | Transport of presenting morphism along locus inclusion |
| `chartMatrix_rel` | 2700 | Transport of presenting matrix |
| `chartMorphism_rel` | 2731 | Transport of chart morphism |
| `isIso_pullback_chartLocus_map` | 2809 | Instance spelling for `isIso_pullback_isoLocus_map` |
| `pullback_map_freeMap_pullbackFreeIso` | 2818 | Naturality of `pullbackFreeIso` in index |
| `freeMap_chartMatrixHom` | 2892 | `I`-minor of presenting morphism is identity (morphism level) |
| `unitEndSection_id` | 3019 | Trivial unit instance |
| `unitEndSection_zero` | 3023 | Trivial zero instance |
| `chartMatrix_minor` | 3032 | `I`-minor of presenting matrix is identity (entry level) |

**Category B — Nitsure §1 inverse-construction infrastructure, no blueprint blocks:**
| Declaration | Line | Notes |
|---|---|---|
| `isoLocus` | 2093 | Largest open on which a morphism is invertible |
| `mem_isoLocus` | 2098 | Membership criterion |
| `isIso_pullback_map_of_le` | 2107 | Restriction stability (non-sorried) |
| `chartComposite` | 2123 | `s_I ≫ q` Nitsure §1 |
| `chartLocus` | 2130 | `T_I ⊆ T` Nitsure §1 |
| `projFree` | 2164 | Companion projection to `ιFree` |
| `unitEndSection` | 2172 | Extract global section from unit-sheaf endomorphism |
| `unitEndSection_scalarEnd` | 2179 | `unitEndSection (scalarEnd a) = a` |
| `chartMatrixHom` | 2192 | Presenting morphism over `T_I` |
| `chartMatrix` | 2208 | Presenting matrix `M^I` |
| `chartMorphism` | 2218 | `T_I ⟶ U^I` Nitsure §1 |
| `grPointOfRankQuotient` | 2237 | Global inverse map `T ⟶ Gr(d,r)` |
| `chartComposite_rel` | 2254 | Chart composites are iso-intertwined |
| `chartLocus_rel` | 2264 | Equivalent quotients have equal chart loci |
| `grPointOfRankQuotient_rel` | 3071 | **Key iter-067 result**: inverse is constant on equiv classes |
| `tripleOverlapSections` | 1027 | Global-sections bridge to triple-overlap ring |
| `tautologicalRankQuotient` | 2071 | Tautological `RankQuotient` on `Gr(d,r)` |
| `universalQuotient_restrictionIso` | 2015 | Chart restriction iso of `U` |
| `universalQuotient_isLocallyFreeOfRank` | 2030 | `U` is loc-free rank `d` |

**Category C — Internal helpers, clearly project-local, no blueprint obligation:**
`scalarEnd_val_app`, `unitHomEquiv_scalarEnd`, `scalarEnd_val_app_one`, `hasFiniteBiproducts_modules`, `biproduct_matrix_comp` (private), `biproduct_matrix_comp_rect` (private), `matrixToFreeIso_inv`, private ports from GrassmannianCells (7 lemmas), `unitToPushforward_scalarEnd_comm`, `ιFree_matrixEnd`, `ιFree_matrixEndRect`, `chartQuotientMap_eq_matrixEndRect`, `pullbackBaseChangeTransport_matrixToFreeIso`, `tautologicalQuotientComponent`, `bundleMatrix_cancel` (private).

---

## Blueprint adequacy for this file

- **Coverage**: Of the ~50 substantive Grassmannian declarations in this file that the blueprint should reference, approximately 37 have corresponding `\lean{}` blocks. The ~18 transport-chain helpers (Category A) and the ~19 Nitsure inverse-construction declarations (Category B) have **no `\lean{}`coverage at all** — they represent approximately 37 unreferenced substantive declarations. Internal helpers (Category C, ~16 entries) are acceptably unlisted.

- **Proof-sketch depth**: **partially adequate / under-specified** for the Nitsure inverse section. The proof of `thm:grassmannian_universal_property` in the blueprint describes the inverse construction at a conceptually sufficient level ("chart composites, chart loci, trivialisation, chart morphisms, uniqueness by universal property"), but does not enumerate the large supporting API (`isoLocus`, `chartMatrix`, `chartMatrixHom`, `projFree`, `unitEndSection`, the rel-invariance transport chain). A prover could correctly implement the construction from the blueprint's prose, but the many intermediate lemmas — especially the 18 transport-chain helpers for `grPointOfRankQuotient_rel` — cannot be guided from the current blueprint text alone.

  The following blocks are specifically under-specified:
  - `thm:grassmannian_universal_property` proof: mentions equivalence-class well-definedness implicitly but has no standalone statement for `grPointOfRankQuotient_rel`.
  - No block for `isoLocus` (a non-trivial project-local concept).
  - No block for the `unitEndSection ↔ scalarEnd` correspondence (the bridge enabling the transport chain).
  - No block for `freeMap_chartMatrixHom` / `chartMatrix_minor` (the `M^I_I = 1` ingredients needed for the overlap compatibility).

- **Hint precision**: **precise** for all `\lean{}` blocks that exist. Every declaration name in the `\lean{...}` hints corresponds exactly to a Lean declaration with a matching signature.

  **Exception — minor**: `lem:gr_chartQuotientMap_iFree` pins `chartQuotientMap_ιFree`, which is `private`; the tooling cannot resolve this pin.

- **Generality**: **matches need** for all referenced declarations. No parallel API was invented to work around blueprint-level narrowness.

- **Recommended chapter-side actions** (for a blueprint-writing subagent):
  1. Add a standalone block for `grPointOfRankQuotient_rel` (statement: "the map `T ⟶ Gr(d,r)` induced by a rank-d quotient is constant on equivalence classes") with a proof sketch describing the transport chain through `chartLocus_rel` → `chartMatrix_rel` → `chartMorphism_rel` → `hom_ext`.
  2. Add blocks for `isoLocus`, `chartComposite`, `chartLocus`, `chartMatrix`, `chartMatrixHom`, `chartMorphism`, `grPointOfRankQuotient` (the complete Nitsure §1 inverse construction API).
  3. Add a block for `unitEndSection` / `scalarEnd_unitEndSection` (the `End(1) ↔ Γ(X,1)` inverse direction).
  4. Add a block for `universalQuotient_isLocallyFreeOfRank` (a substantive theorem that feeds `tautologicalRankQuotient`).
  5. Make `chartQuotientMap_ιFree` non-private, or remove its `\lean{}` pin.
  6. The 18 transport-chain helpers (Category A) can be grouped into one or two "transport infrastructure" lemma blocks rather than 18 individual blocks.

---

## Severity summary

| Finding | Severity |
|---|---|
| `chartQuotientMap_ιFree` is `private` but has a `\lean{}` pin | **minor** |
| ~18 Category A transport-chain helpers have no blueprint blocks (directive pre-noted) | **major** (missing coverage) |
| ~19 Category B Nitsure inverse-construction declarations have no blueprint blocks | **major** (missing coverage) |
| Blueprint's proof sketch for `thm:grassmannian_universal_property` does not enumerate the `grPointOfRankQuotient_rel` transport infrastructure | **major** (chapter under-specified for these components) |
| Pre-acknowledged sorried declarations (`tautologicalQuotient_epi`, `chartLocus_isOpenCover`, `isIso_pullback_isoLocus_map`, overlap sorry in `grPointOfRankQuotient`, two `represents` inverse laws) | **not a red flag** (documented project semantics) |

No must-fix-this-iter findings: no fake/placeholder definitions, no wrong signatures, no excuse-comments, no unauthorized axioms, no weakened-wrong definitions. The Lean file faithfully formalizes the blueprint for all `\lean{}`-tagged declarations. The coverage gaps are documentation deficiencies, not formalization errors.

**Overall verdict**: The Lean file is a faithful formalization of every `\lean{}`-tagged blueprint declaration; no must-fix findings. Two major gaps in chapter coverage — the ~18 iter-067 transport-chain helpers and the ~19 Nitsure §1 inverse-construction declarations — need blueprint blocks to close the bidirectional correspondence.
