# Lean ↔ Blueprint Check Report

## Slug
grassmanniancells-iter034

## Iteration
034

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianCells.lean` (1423 lines)
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianCells.tex` (2111 lines)

---

## Per-declaration

62 project-level `\lean{...}` blocks audited (8 additional `\mathlibok` Mathlib anchors excluded).

### `\lean{AlgebraicGeometry.Grassmannian.affineChart}` (chapter: `def:gr_affine_chart`)
- **Lean target exists**: yes
- **Signature matches**: yes — `Scheme := AlgebraicGeometry.Spec (CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ))`; matches blueprint's `U^I = Spec ℤ[X^I]` with `d(r-d)` free entries
- **Proof follows sketch**: N/A (definition)
- **notes**: clean, no sorry, `\leanok` correct

### `\lean{AlgebraicGeometry.Grassmannian.universalMatrix}` (chapter: `def:gr_universal_matrix`)
- **Lean target exists**: yes
- **Signature matches**: yes — `Matrix (Fin d) (Fin r) (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)` with identity `I`-block and free indeterminates `X (p,⟨q,h⟩)` for `q ∉ I`
- **Proof follows sketch**: N/A
- **notes**: exact match to blueprint formula

### `\lean{AlgebraicGeometry.Grassmannian.minorDet}` (chapter: `def:gr_minor_det`)
- **Lean target exists**: yes
- **Signature matches**: yes — `MvPolynomial … ℤ`, body is `(universalMatrix … .submatrix id (J.orderIsoOfFin hJ –)).det`
- **Proof follows sketch**: N/A
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.universalMinor}` (chapter: `def:gr_universal_minor`)
- **Lean target exists**: yes
- **Signature matches**: yes — `Matrix (Fin d) (Fin d) (Localization.Away (minorDet …))`, base-changed via `algebraMap`
- **Proof follows sketch**: N/A
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.isUnit_det_universalMinor}` (chapter: `lem:gr_minorDet_unit`)
- **Lean target exists**: yes
- **Signature matches**: yes — `IsUnit (universalMinor d r I J hI hJ).det`
- **Proof follows sketch**: yes — uses `RingHom.map_det` then `IsLocalization.Away.algebraMap_isUnit`
- **notes**: `\leanok` on both statement and proof; correct

### `\lean{AlgebraicGeometry.Grassmannian.universalMinorInv}` (chapter: `def:gr_universalMinorInv`)
- **Lean target exists**: yes
- **Signature matches**: yes — `:= (universalMinor …)⁻¹` (Mathlib nonsingular inverse)
- **Proof follows sketch**: N/A
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.universalMinorInv_mul_cancel}` (chapter: `lem:gr_universalMinorInv_identities`)
- **Lean target exists**: yes
- **Signature matches**: yes — conjunction `… * … = 1 ∧ … * … = 1`
- **Proof follows sketch**: yes — uses `Matrix.nonsing_inv_mul` / `Matrix.mul_nonsing_inv` on the unit det
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.imageMatrix}` (chapter: `def:gr_image_matrix`)
- **Lean target exists**: yes
- **Signature matches**: yes — `universalMinorInv … * (universalMatrix …).map (algebraMap _ _)`
- **Proof follows sketch**: N/A
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.transitionPreMap}` (chapter: `def:gr_transition_pre`)
- **Lean target exists**: yes
- **Signature matches**: yes — `MvPolynomial (Fin d × {q : Fin r // q ∉ J}) ℤ →ₐ[ℤ] Localization.Away (minorDet d r I J hI hJ)` via `MvPolynomial.aeval (fun e => imageMatrix … e.1 e.2.1)`
- **Proof follows sketch**: N/A
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.isUnit_transitionPreMap_minorDet}` (chapter: `lem:gr_transition_pre_unit`)
- **Lean target exists**: yes
- **Signature matches**: yes — `IsUnit (transitionPreMap d r I J hI hJ (minorDet d r J I hJ hI))`
- **Proof follows sketch**: yes — computes `det((X^I_J)⁻¹)` via `imageMatrix_submatrix_I` and `IsUnit.of_mul_eq_one`
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.transitionMap}` (chapter: `def:gr_transition`)
- **Lean target exists**: yes
- **Signature matches**: yes — `Localization.Away (minorDet d r J I hJ hI) →+* Localization.Away (minorDet d r I J hI hJ)` via `IsLocalization.Away.lift`
- **Proof follows sketch**: N/A
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.transitionMap_self}` (chapter: `lem:gr_transition_self`)
- **Lean target exists**: yes
- **Signature matches**: yes — `transitionMap d r I I hI hI = RingHom.id _`
- **Proof follows sketch**: yes — minor is identity, pre-hom is structure map, lift is identity; uses `IsLocalization.ringHom_ext`
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.mul_submatrix_col}` (chapter: `lem:gr_mul_submatrix_col`)
- **Lean target exists**: yes (but **PRIVATE** — `private lemma mul_submatrix_col`)
- **Signature matches**: yes — `(A * B).submatrix id g = A * B.submatrix id g`
- **Proof follows sketch**: yes
- **notes**: ⚠ `private` declaration: the name `AlgebraicGeometry.Grassmannian.mul_submatrix_col` is **not exported** and not verifiable by external tools. See Red Flags.

### `\lean{AlgebraicGeometry.Grassmannian.map_nonsing_inv}` (chapter: `lem:gr_map_nonsing_inv`)
- **Lean target exists**: yes (but **PRIVATE**)
- **Signature matches**: yes — `(A.map f)⁻¹ = A⁻¹.map f` when `IsUnit A.det`
- **Proof follows sketch**: yes
- **notes**: ⚠ same `private` issue

### `\lean{AlgebraicGeometry.Grassmannian.map_map_eq_of_comp}` (chapter: `lem:gr_map_map_eq_of_comp`)
- **Lean target exists**: yes (but **PRIVATE**)
- **Signature matches**: yes — `(M.map f).map g = M.map h` when `g.comp f = h`
- **Proof follows sketch**: yes
- **notes**: ⚠ same `private` issue

### `\lean{AlgebraicGeometry.Grassmannian.inv_mul_inv_mul_cancel}` (chapter: `lem:gr_inv_mul_inv_mul_cancel`)
- **Lean target exists**: yes (but **PRIVATE**)
- **Signature matches**: yes — `(B⁻¹ * A) * (A⁻¹ * M) = B⁻¹ * M` when `IsUnit A.det`
- **Proof follows sketch**: yes
- **notes**: ⚠ same `private` issue

### `\lean{AlgebraicGeometry.Grassmannian.universalMatrix_submatrix_self}` (chapter: `lem:gr_universalMatrix_submatrix_self`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(universalMatrix …).submatrix id (fun j => I.orderIsoOfFin hI j) = 1`
- **Proof follows sketch**: yes — by definition of `universalMatrix` and bijectivity of `orderIsoOfFin`
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.imageMatrix_submatrix_self}` (chapter: `lem:gr_imageMatrix_submatrix_self`)
- **Lean target exists**: yes
- **Signature matches**: yes — `J`-minor of `imageMatrix` is `1`
- **Proof follows sketch**: yes — uses `mul_submatrix_col` then `universalMinorInv_mul_cancel`
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.imageMatrix_submatrix_I}` (chapter: `lem:gr_imageMatrix_submatrix_I`)
- **Lean target exists**: yes
- **Signature matches**: yes — `I`-minor of `imageMatrix` is `universalMinorInv`
- **Proof follows sketch**: yes — via `universalMatrix_submatrix_self` and `mul_submatrix_col`
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.universalMatrix_map_transitionPreMap}` (chapter: `lem:gr_universalMatrix_map_transitionPreMap`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(universalMatrix d r J hJ).map (transitionPreMap …) = imageMatrix …`
- **Proof follows sketch**: yes — case split on `q ∈ J`; uses `imageMatrix_submatrix_self` for the identity block
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.transitionPreMap_minorDet}` (chapter: `lem:gr_transitionPreMap_minorDet`)
- **Lean target exists**: yes
- **Signature matches**: yes — image of `minorDet d r J K` under `transitionPreMap d r I J` = det of `K`-minor of `imageMatrix`
- **Proof follows sketch**: yes
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.imageMatrix_map_eq}` (chapter: `lem:gr_imageMatrix_map_eq`)
- **Lean target exists**: yes (but **PRIVATE**)
- **Signature matches**: yes — naturality of image matrix: `(imageMatrix I X).map incl = (Y_X)⁻¹ * Y` when `incl` lies over `R^I → D`
- **Proof follows sketch**: yes
- **notes**: ⚠ same `private` issue

### `\lean{AlgebraicGeometry.Grassmannian.awayInclLeft}` (chapter: `def:gr_away_incl_left`)
- **Lean target exists**: yes
- **Signature matches**: yes — `Localization.Away x →+* Localization.Away (x * y)` via `IsLocalization.Away.lift`
- **Proof follows sketch**: N/A
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.awayInclRight}` (chapter: `def:gr_away_incl_right`)
- **Lean target exists**: yes
- **Signature matches**: yes — `Localization.Away y →+* Localization.Away (x * y)`
- **Proof follows sketch**: N/A
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.awayInclLeft_comp_algebraMap}` (chapter: `lem:gr_awayInclLeft_comp_algebraMap`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — `IsLocalization.Away.lift_comp`
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.awayInclRight_comp_algebraMap}` (chapter: `lem:gr_awayInclRight_comp_algebraMap`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.isUnit_algebraMap_away_left}` (chapter: `lem:gr_isUnit_algebraMap_away_left`)
- **Lean target exists**: yes (but **PRIVATE**)
- **Signature matches**: yes — `IsUnit (algebraMap R (Localization.Away (x * y)) x)`
- **Proof follows sketch**: yes
- **notes**: ⚠ same `private` issue

### `\lean{AlgebraicGeometry.Grassmannian.isUnit_algebraMap_away_right}` (chapter: `lem:gr_isUnit_algebraMap_away_right`)
- **Lean target exists**: yes (but **PRIVATE**)
- **Signature matches**: yes — `IsUnit (algebraMap R (Localization.Away (x * y)) y)`
- **Proof follows sketch**: yes
- **notes**: ⚠ same `private` issue

### `\lean{AlgebraicGeometry.Grassmannian.isUnit_incl_transitionPreMap_cross}` (chapter: `lem:gr_isUnit_incl_transitionPreMap_cross`)
- **Lean target exists**: yes (but **PRIVATE**)
- **Signature matches**: yes — the "cross minor" unitality lemma; general `incl : Localization.Away (minorDet A B) →+* D` lying over `R^A → D`, with `P^A_C` a unit of `D` → `incl(θ̃_{A,B}(P^B_C))` is a unit
- **Proof follows sketch**: yes — splits as `det((X^A_B)⁻¹) · P^A_C`
- **notes**: ⚠ same `private` issue

### `\lean{AlgebraicGeometry.Grassmannian.cocycleΘIJ}` (chapter: `def:gr_cocycle_theta_ij`)
- **Lean target exists**: yes
- **Signature matches**: yes — `Localization.Away (minorDet d r J I hJ hI * minorDet d r J K hJ hK) →+* Localization.Away (minorDet d r I J hI hJ * minorDet d r I K hI hK)`
- **Proof follows sketch**: N/A
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.cocycleΘJK}` (chapter: `def:gr_cocycle_theta_jk`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: N/A
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.cocycleΘIK}` (chapter: `def:gr_cocycle_theta_ik`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: N/A
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.cocycle_imageMatrix_eq}` (chapter: `lem:gr_cocycle_imageMatrix_eq`)
- **Lean target exists**: yes (but **PRIVATE**)
- **Signature matches**: yes — the matrix identity `(imageMatrix I K).map (awayInclRight …) = (imageMatrix J K).map (cocycleΘIJ.comp (awayInclRight …))`
- **Proof follows sketch**: yes — reduces both sides to `(Y_K)⁻¹ Y`; substantial proof (line 524–599)
- **notes**: ⚠ same `private` issue; the blueprint's `lem:gr_cocycle_imageMatrix_eq` has `\leanok` which sync_leanok confirmed

### `\lean{AlgebraicGeometry.Grassmannian.cocycleCondition}` (chapter: `lem:gr_cocycle`)
- **Lean target exists**: yes
- **Signature matches**: yes — `cocycleΘIK = (cocycleΘIJ).comp (cocycleΘJK)` as ring homs `S_K →+* S_I`
- **Proof follows sketch**: yes — uses `IsLocalization.ringHom_ext`, reduces to `MvPolynomial.ringHom_ext`, the `X`-generator case is closed by `cocycle_imageMatrix_eq`
- **notes**: blueprint proof sketch is a bit informal about "both reduce to `(Y_K)⁻¹ Y`" — the Lean proof makes the reduction to chart-ring generators explicit

### `\lean{AlgebraicGeometry.Grassmannian.minorDet_self}` (chapter: `lem:gr_minorDet_self`)
- **Lean target exists**: yes
- **Signature matches**: yes — `minorDet d r I I hI hI = 1`
- **Proof follows sketch**: yes — `universalMatrix_submatrix_self` then `Matrix.det_one`
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.chartOverlap}` (chapter: `def:gr_chart_overlap`)
- **Lean target exists**: yes
- **Signature matches**: yes — `Spec (CommRingCat.of (Localization.Away (minorDet d r I J hI hJ)))`
- **Proof follows sketch**: N/A
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.chartIncl}` (chapter: `def:gr_chart_incl`)
- **Lean target exists**: yes
- **Signature matches**: yes — `chartOverlap d r I J hI hJ ⟶ affineChart d r I` via `Spec.map` of `algebraMap`
- **Proof follows sketch**: N/A
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.chartIncl_isOpenImmersion}` (chapter: `lem:gr_chartIncl_isOpenImmersion`)
- **Lean target exists**: yes (as `instance`)
- **Signature matches**: yes — `IsOpenImmersion (chartIncl d r I J hI hJ)`
- **Proof follows sketch**: yes — `inferInstanceAs` of the away-localisation open-immersion fact
- **notes**: clean; blueprint correctly flags this as an open immersion

### `\lean{AlgebraicGeometry.Grassmannian.chartIncl_self_isIso}` (chapter: `lem:gr_chartIncl_self_isIso`)
- **Lean target exists**: yes
- **Signature matches**: yes — `IsIso (chartIncl d r I I hI hI)`
- **Proof follows sketch**: yes — `minorDet_self` gives unit 1; `IsLocalization.atUnit` gives the algEquiv; bijectivity → `ConcreteCategory.isIso_iff_bijective`
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.chartTransition}` (chapter: `def:gr_chart_transition`)
- **Lean target exists**: yes
- **Signature matches**: yes — `chartOverlap d r I J hI hJ ⟶ chartOverlap d r J I hJ hI` via `Spec.map (CommRingCat.ofHom (transitionMap …))`
- **Proof follows sketch**: N/A
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.chartTransition_self}` (chapter: `lem:gr_chartTransition_self`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.awayPullbackIso}` (chapter: `def:gr_away_pullback_iso`)
- **Lean target exists**: yes
- **Signature matches**: yes — `Limits.pullback (Spec.map …) (Spec.map …) ≅ Spec (CommRingCat.of (Localization.Away (x * y)))`; composite via `pullbackSpecIso` and `IsLocalization.algEquiv`
- **Proof follows sketch**: N/A
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.awayPullbackIso_inv_fst}` (chapter: `lem:gr_awayPullbackIso_inv_fst`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(awayPullbackIso x y).inv ≫ pullback.fst = Spec.map (CommRingCat.ofHom (awayInclLeft x y))`
- **Proof follows sketch**: yes — uses `pullbackSpecIso_inv_fst` and universal property of `awayInclLeft`
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.awayPullbackIso_inv_snd}` (chapter: `lem:gr_awayPullbackIso_inv_snd`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.awayMulCommEquiv}` (chapter: `def:gr_away_mul_comm_equiv`)
- **Lean target exists**: yes
- **Signature matches**: yes — `Localization.Away (x * y) ≃+* Localization.Away (y * x)` via `IsLocalization.algEquiv`
- **Proof follows sketch**: N/A
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.awayMulCommEquiv_comp_algebraMap}` (chapter: `lem:gr_awayMulCommEquiv_comp_algebraMap`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.awayMulCommEquiv_comp_awayInclLeft}` (chapter: `lem:gr_awayMulCommEquiv_comp_awayInclLeft`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(awayMulCommEquiv x y).toRingHom.comp (awayInclLeft x y) = awayInclRight y x`
- **Proof follows sketch**: yes
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.chartTransition'}` (chapter: `def:gr_chart_transition'`)
- **Lean target exists**: yes
- **Signature matches**: yes — `Limits.pullback (chartIncl d r I J …) (chartIncl d r I K …) ⟶ Limits.pullback (chartIncl d r J K …) (chartIncl d r J I …)`
- **Proof follows sketch**: N/A
- **notes**: clean; uses `awayPullbackIso.hom ≫ Spec.map Θ_{I,J} ≫ Spec.map swap ≫ awayPullbackIso.inv` exactly as blueprint describes

### `\lean{AlgebraicGeometry.Grassmannian.chartTransition'_ringIdentity}` (chapter: `lem:gr_chartTransition'_ringIdentity`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(cocycleΘIJ …).comp (swap.comp (awayInclRight …)) = (awayInclLeft …).comp (transitionMap …)`
- **Proof follows sketch**: yes — reduces both to `ι^L ∘ θ̃_{I,J}` using `IsLocalization.ringHom_ext`
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.chartTransition'_fac}` (chapter: `lem:gr_chartTransition'_fac`)
- **Lean target exists**: yes
- **Signature matches**: yes — `t'_{I,J,K} ≫ pr₂ = pr₁ ≫ t_{I,J}`
- **Proof follows sketch**: yes — uses leg lemmas, ring identity, and `erw` for the `HasPullback` diamond; `set_option maxHeartbeats 1600000` is noted in both Lean and blueprint NOTE
- **notes**: clean; blueprint NOTE accurately describes the `erw` workaround

### `\lean{AlgebraicGeometry.Grassmannian.chartTransition'_cocycle}` (chapter: `lem:gr_chartTransition'_cocycle`)
- **Lean target exists**: yes
- **Signature matches**: yes — `t'_{I,J,K} ≫ t'_{J,K,I} ≫ t'_{K,I,J} = id`
- **Proof follows sketch**: yes — the two internal `ap⁻¹ ≫ ap` pairs cancel (`Iso.inv_hom_id_assoc`), six `Spec`-arrows collapse via `cocyclePhiId`; `set_option maxHeartbeats 1600000`
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.cocyclePhiId}` (chapter: `lem:gr_cocycle_phi_id`)
- **Lean target exists**: yes
- **Signature matches**: yes — `Θ_{I,J} ∘ swap_J ∘ Θ_{J,K,I} ∘ swap_K ∘ Θ_{K,I,J} ∘ swap_I = RingHom.id (Localization.Away (P^I_J · P^I_K))`
- **Proof follows sketch**: yes — `rotMid` collapses `swap_J ∘ Θ_{J,K,I} ∘ swap_K` to `Θ_{J,K}`; then `cocycleCondition` gives `Θ_{I,J} ∘ Θ_{J,K} = Θ_{I,K}`; then `transitionInvPair` closes it
- **notes**: clean; proof strategy precisely matches blueprint description

### `\lean{AlgebraicGeometry.Grassmannian.theGlueData}` (chapter: `def:gr_the_glue_data`)
- **Lean target exists**: yes
- **Signature matches**: yes — `Scheme.GlueData` with all fields
- **Proof follows sketch**: N/A
- **notes**: clean; `f_mono` and `f_hasPullback` discharged by `infer_instance` as blueprint states

### `\lean{AlgebraicGeometry.Grassmannian.scheme}` (chapter: `def:gr_glued_scheme`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(theGlueData d r).glued`
- **Proof follows sketch**: N/A
- **notes**: clean; blueprint NOTE `% NOTE (iter-031): FULLY FORMALIZED and axiom-clean` is historically accurate

### `\lean{AlgebraicGeometry.Grassmannian.transitionPreMap_minorDet_swap_mul}` (chapter: `lem:gr_transitionPreMap_minorDet_swap_mul`)
- **Lean target exists**: yes
- **Signature matches**: yes — `transitionPreMap … (minorDet d r J I hJ hI) * algebraMap … (minorDet d r I J hI hJ) = 1`
- **Proof follows sketch**: yes
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.diagonalRingMap}` (chapter: `def:gr_diagonalRingMap`)
- **Lean target exists**: yes
- **Signature matches**: yes — `Algebra.TensorProduct.lift` of structure map and `transitionPreMap`; type is `MvPolynomial … ⊗[ℤ] MvPolynomial … →ₐ[ℤ] Localization.Away (minorDet …)` (the type is inferred; the `.toRingHom` used in `isSeparatedToSpecZ` matches blueprint)
- **Proof follows sketch**: N/A
- **notes**: clean; blueprint's "construction" block (with `\begin{proof}…\leanok`) accurately describes the lift

### `\lean{AlgebraicGeometry.Grassmannian.diagonalRingMap_left}` / `_right` / `_surjective`
- **Lean target exists**: yes (all three)
- **Signature matches**: yes — left component is `algebraMap`, right is `transitionPreMap`, surjectivity via `IsLocalization.surj`
- **Proof follows sketch**: yes — surjectivity witness is `a ⊗ₜ (minorDet d r J I hJ hI)^n` exactly as blueprint describes
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.pullbackιIso}` (chapter: `def:gr_pullbackιIso`)
- **Lean target exists**: yes
- **Signature matches**: yes — `Limits.pullback ((theGlueData d r).ι i) ((theGlueData d r).ι j) ≅ chartOverlap …` via `vPullbackConeIsLimit`
- **Proof follows sketch**: yes
- **notes**: clean

### `\lean{AlgebraicGeometry.Grassmannian.isSeparated}` (chapter: `lem:gr_separated`)
- **Lean target exists**: yes (lines 1413–1421)
- **Signature matches**: yes — `(scheme d r).IsSeparated`
- **Proof follows sketch**: yes — uses `isSeparatedToSpecZ` then `Scheme.isSeparated_iff` and `terminal.hom_ext`
- **notes**: ⚠ Blueprint contains a stale NOTE `% NOTE (iter-033): the pinned decl 'Grassmannian.isSeparated' does NOT yet exist.` — this was accurate in iter-033 but is **now false**; the declaration landed in iter-034. The review agent must clear this NOTE. See Red Flags section.

### `\lean{AlgebraicGeometry.Grassmannian.isProper}` (chapter: `lem:gr_proper`)
- **Lean target exists**: **no** — no `isProper` declaration found anywhere in the 1423-line file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint has no `\leanok` marker on statement or proof; this correctly reflects unformalized status. Blueprint proof sketch (valuative criterion via DVR) is detailed and could guide a future formalization. No action required this iter.

---

## Red Flags

### Private declarations pinned by blueprint `\lean{...}` (9 occurrences)

The following blueprint `\lean{...}` hints name declarations that are `private` in Lean and are therefore **not accessible by their fully-qualified names** from outside the file. The blueprint-doctor's per-declaration lookup (and `lean_verify` tool) will report "declaration not found" for each:

| Blueprint label | Blueprint pin | Lean visibility |
|---|---|---|
| `lem:gr_mul_submatrix_col` | `…mul_submatrix_col` | `private lemma` |
| `lem:gr_map_nonsing_inv` | `…map_nonsing_inv` | `private lemma` |
| `lem:gr_map_map_eq_of_comp` | `…map_map_eq_of_comp` | `private lemma` |
| `lem:gr_inv_mul_inv_mul_cancel` | `…inv_mul_inv_mul_cancel` | `private lemma` |
| `lem:gr_imageMatrix_map_eq` | `…imageMatrix_map_eq` | `private lemma` |
| `lem:gr_isUnit_algebraMap_away_left` | `…isUnit_algebraMap_away_left` | `private lemma` |
| `lem:gr_isUnit_algebraMap_away_right` | `…isUnit_algebraMap_away_right` | `private lemma` |
| `lem:gr_isUnit_incl_transitionPreMap_cross` | `…isUnit_incl_transitionPreMap_cross` | `private lemma` |
| `lem:gr_cocycle_imageMatrix_eq` | `…cocycle_imageMatrix_eq` | `private lemma` |

The mathematical content of all 9 is correct and matches the blueprint prose. The issue is purely one of Lean namespace visibility: `private` prevents the name from being exported. Two fixes are possible:
1. Remove `private` from these declarations, or
2. Annotate the blueprint blocks with `lean_aux` and drop the `\lean{...}` pins (treating them as internals not subject to external verification).

The `\leanok` markers on these blocks were set by `sync_leanok` via whole-file sorry analysis (not per-declaration lookup), so they are technically correct about sorry-freedom. But any blueprint-doctor or `lean_verify` call using the pinned names will fail.

### Stale `% NOTE` annotation on `lem:gr_separated`

The blueprint at the `lem:gr_separated` block contains:
```
% NOTE (iter-033): the pinned decl `Grassmannian.isSeparated` does NOT yet exist.
% The ring-theoretic heart IS landed axiom-clean ...
% Remaining: the multi-piece glue assembly ...
```

This note was accurate at iter-033 but **is now false**: `Grassmannian.isSeparated` exists and is sorry-free (landed in iter-034, lines 1413–1421 of the Lean file). The NOTE is **actively misleading** — it will cause future agents to believe `isSeparated` is unformalized when it is complete. The review agent must remove or update this NOTE.

---

## Unreferenced declarations (informational)

The following non-private declarations exist in the Lean file but have no corresponding `\lean{...}` blueprint block:

| Lean declaration | Line | Nature |
|---|---|---|
| `toSpecZ` | ~1288 | `noncomputable def` — the structure morphism `Gr(d,r) → Spec ℤ`; used by `isSeparatedToSpecZ` and `ι_toSpecZ` |
| `ι_toSpecZ` | ~1294 | `theorem` — chart inclusion ≫ structure morphism = affine structure map; used in `isSeparatedToSpecZ` |
| `pullbackιIso_inv_fst` | ~1303 | `theorem` — first leg of `pullbackιIso`; used in `isSeparatedToSpecZ` |
| `pullbackιIso_inv_snd` | ~1316 | `theorem` — second leg; used in `isSeparatedToSpecZ` |
| `chartTransition_comp_chartIncl` | ~1331 | `theorem` — `t ≫ ι_J = Spec.map θ̃_{I,J}`; used in `isSeparatedToSpecZ` |
| `isSeparatedToSpecZ` | ~1357 | `theorem` — `IsSeparated (toSpecZ d r)`; the key intermediate from which `isSeparated` follows |

`isSeparatedToSpecZ` in particular is a substantial result (it is the actual separated-morphism proof, via `IsZariskiLocalAtTarget.of_openCover` and the per-patch closed-immersion argument). The blueprint's `lem:gr_separated` proof sketch does describe the strategy but does not give `isSeparatedToSpecZ` its own `\lean{...}` pin. The five other declarations are supporting helpers; they are acceptable as internal bridges but `isSeparatedToSpecZ` should be promoted to the blueprint.

Also note: the `private` helpers `rotMid`, `transitionInvImageMatrix`, and `transitionInvPair` (all within the `cocyclePhiId` proof section) have no blueprint blocks; these are fine as purely internal lemmas and need not be pinned.

---

## Blueprint adequacy for this file

- **Coverage**: 61/62 Lean declarations (counting non-private non-trivial ones) have a corresponding `\lean{...}` block. The 1 exception (`isProper`) is known-unformalized. Among the 6 non-blueprint-referenced non-private declarations, 1 (`isSeparatedToSpecZ`) should be promoted. Score: 56 public declarations well-covered; 6 helpers not pinned (acceptable for 5, warranted for `isSeparatedToSpecZ`).
- **Proof-sketch depth**: **adequate** for all formalized blocks. The blueprint for `lem:gr_cocycle` gives a precise matrix-algebra route (`(Y_K)⁻¹ Y` calculation); `lem:gr_cocycle_phi_id` describes the telescoping via `rotMid` + `cocycleCondition` + `transitionInvPair`; `lem:gr_separated` describes the Proj-template strategy. All were sufficient for the Lean proofs.
- **Hint precision**: **mostly precise**. The `private`-declaration hints are technically broken for external verification (see Red Flags); mathematically the hints name the correct objects.
- **Generality**: **matches need** — the blueprint constructs `awayPullbackIso` over a general base ring `A` and `isUnit_incl_transitionPreMap_cross` for a general `D` with `incl`, matching what the Lean proofs actually need.
- **Recommended chapter-side actions**:
  1. **Remove or update** the stale `% NOTE (iter-033)` comment in `lem:gr_separated` — the declaration `Grassmannian.isSeparated` now exists.
  2. **Add a blueprint block** for `isSeparatedToSpecZ` (and optionally `toSpecZ`) between `def:gr_pullbackιIso` and `lem:gr_separated`, with a `\lean{AlgebraicGeometry.Grassmannian.isSeparatedToSpecZ}` pin.
  3. **Resolve the `private` conflict** for the 9 affected declarations: either (a) remove `private` from `mul_submatrix_col`, `map_nonsing_inv`, `map_map_eq_of_comp`, `inv_mul_inv_mul_cancel`, `imageMatrix_map_eq`, `isUnit_algebraMap_away_left`, `isUnit_algebraMap_away_right`, `isUnit_incl_transitionPreMap_cross`, `cocycle_imageMatrix_eq` so their pinned names resolve, or (b) annotate their blueprint blocks as `lean_aux` helpers and drop or replace the `\lean{...}` pins.

---

## Severity summary

### must-fix-this-iter
_None._ No placeholder bodies, no sorry, no excuse-comments on active declarations, no unauthorized axioms, no weakened-wrong definitions, no missing formalizations that block downstream work on currently-active declarations.

### major
1. **9 `private` declarations pinned in blueprint `\lean{...}` blocks** (`mul_submatrix_col`, `map_nonsing_inv`, `map_map_eq_of_comp`, `inv_mul_inv_mul_cancel`, `imageMatrix_map_eq`, `isUnit_algebraMap_away_left`, `isUnit_algebraMap_away_right`, `isUnit_incl_transitionPreMap_cross`, `cocycle_imageMatrix_eq`): the blueprint-doctor's per-declaration lookup will fail for all 9; `lean_verify` cannot confirm them by name. Math content is correct; only name visibility is broken.
2. **Stale `% NOTE (iter-033)` in `lem:gr_separated`**: claims `Grassmannian.isSeparated` does not exist, but it does (landed iter-034). Actively misleading to future agents; the review agent should clear it.

### minor
1. `isSeparatedToSpecZ` is a substantial intermediate theorem (morphism-level separatedness) with no dedicated blueprint block; it should be promoted.
2. `toSpecZ`, `ι_toSpecZ`, `pullbackιIso_inv_fst`, `pullbackιIso_inv_snd`, `chartTransition_comp_chartIncl` are supporting helpers with no blueprint blocks; acceptable for now but worth tracking.
3. `isProper` is not yet formalized — expected state, no action this iter.

**Overall verdict**: The Lean file is mathematically faithful, sorry-free, and axiom-clean; all public blueprint-pinned declarations exist with correct signatures and genuine proofs. The two major issues are blueprint-tooling ones (9 `private`-declaration naming conflicts) and a stale NOTE annotation; both are fixable without touching the Lean proofs.
