# Blueprint Review Report

## Slug
iter272

## Iteration
272

---

## Top-level summaries

### Incomplete parts

- `Picard_TensorObjSubstrate.tex`: 123 lean-aux nodes across 5 covered sub-files lack blueprint entries (40 from `TensorObjSubstrate.lean`, 32 from `PresheafInternalHom.lean`, 24 from `StalkTensor.lean`, 14 from `DualInverse.lean`, 13 from `Vestigial.lean`). The main public API is covered but intermediate public lemmas in the PresheafInternalHom and StalkTensor clusters are not individually blueprinted.
- `Albanese_AuslanderBuchsbaum.tex`: 31 lean-aux nodes unmatched, including several non-private intermediate helpers from the Path B matrix-collapse chain (L1418–L1517 private helpers, but also the `hasProjectiveDimensionLT_*` public lemma family).
- `Albanese_CodimOneExtension.tex`: 30 lean-aux nodes unmatched; `thm:weil_divisor_obstruction` has `\lean{AlgebraicGeometry.TODO.weilDivisorObstruction}` (unformalised stub); and Route-C dependency violation (see below).
- `Picard_FGAPicRepresentability.tex`: 16 lean-aux nodes unmatched; 9 blueprint nodes have `\lean{AlgebraicGeometry.TODO.*}` stubs (`thm:generic_flatness_algebraic`, `lem:flat_locus_open`, `lem:nonflat_locus_proper`, `lem:noetherian_induction_strata`, `lem:smooth_proper_curve_projective`, `lem:quot_reduction_to_pi_star_W`, `lem:quot_boundedness`, `lem:quot_alpha_injective`, `lem:quot_valuative_criterion`).
- Genus0BaseObjects sub-files: 5 files (`BareScheme.lean`, `ChartIso.lean`, `Points.lean`, `GmScaling.lean`, root `Genus0BaseObjects.lean`) have no dedicated chapter. `AbelianVarietyRigidity.tex` partially covers them via `archon:covers` but 58 lean-aux nodes (25+14+11+8) lack blueprint entries.

### Proofs lacking detail

- `Albanese_Thm32RationalMapExtension.tex` / headline theorem: only 1 `\leanok` across 8 declaration blocks; the main composition (`Milne Theorem 3.2`) has proof sketch but all subsidiary lemma bodies remain sorryed. The sketch names the two inputs (CodimOneExtension + AuslanderBuchsbaum) but does not detail how they compose into the full rational-map extension — insufficient for a prover to close without additional guidance.
- `Picard_FGAPicRepresentability.tex`: the 9 `AlgebraicGeometry.TODO.*` stubs (representability engine, quot/valuative criteria) have prose stubs but no formalizable proof sketches — the prover has no blueprint path to close them.

### Lean difficulty quality

- `Picard_TensorObjSubstrate.tex` / `Picard_RelPicFunctor.tex`: 12 blueprint nodes in these chapters name Lean targets that do not exist at the current Lean tree:
  - `lem:pullback_compatible_with_tensorobj` → `AlgebraicGeometry.LineBundle.OnProduct.pullback_tensorObj_iso` (wrong namespace; should be verified against `TensorObjSubstrate.lean`)
  - `lem:pullback_tensor_iso` → `AlgebraicGeometry.Scheme.Modules.pullbackTensorIso` (does not exist)
  - `lem:pullback0_tensor_iso` → `AlgebraicGeometry.Scheme.Modules.pullback0TensorIso` (does not exist)
  - `lem:pullback_tensor_iso_loctriv` → `AlgebraicGeometry.Scheme.Modules.pullbackTensorIsoOfLocallyTrivial` (does not exist)
  - `lem:isinvertible_implies_locallytrivial` → `AlgebraicGeometry.Scheme.Modules.IsInvertible.isLocallyTrivial` (does not exist)
  - `lem:isinvertible_pullback` → `AlgebraicGeometry.Scheme.Modules.IsInvertible.pullback` (does not exist)
  - `thm:rel_pic_addcommgroup_via_tensorobj` → `AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj` (does not exist)
  - `lem:baseMap_pullbackComp_apply` / `lem:baseMap_pullback_comp_apply` / `lem:baseMap_pullbackCongr_apply` / `lem:baseMap_inv_step3_open_immersion` → 4 `AlgebraicGeometry.Scheme.Modules.*` names that do not exist in `Picard_QuotScheme.tex`
- `Cohomology_MayerVietoris.tex` / `lem:push_pull_functor` → `AlgebraicGeometry.pushPullMap_comp` (does not exist; name mismatch with the actual `pushPullMap_comp` path).
- `Albanese_AlbaneseUP.tex` / `thm:albanese_universal_property` → `AlgebraicGeometry.Scheme.Pic.albaneseUP` (does not exist at current Lean tree; name refers to Pic.albaneseUP but the declaration lives elsewhere).
- `Jacobian.tex` / `thm:finite_appTop_of_universallyClosed` → `AlgebraicGeometry.finite_appTop_of_universallyClosed` (does not exist).
- `Albanese_CodimOneExtension.tex` / `lem:smooth_algebra_krull_dim_formula` → `Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension` (does not exist — but `BareScheme.lean` defines `projectiveLineBar_smooth_chart_X` which uses a related argument, so the name is likely stale/renamed).

### Multi-route coverage

- **Route A (PRIMARY)**: PASS — chapters exist and are ACTIVE for all phases A.1.c through A.4 and the genus-0 arm.
- **Route C (Riemann–Roch, PAUSED)**: all `RiemannRoch_*` chapters exist with inline sorries, treated as frozen per directive. Not flagged as must-fix. BUT: see critical disjointness finding below — Route-A cone pulls Route-C declarations.

### Dependency & isolation findings

**Route-A → Route-C disjointness violation (strategy-modifying):**
- `Albanese_CodimOneExtension.tex` / `lem:milne_codim1_indeterminacy` (line 1297): `\uses{..., def:codim1_cycles, def:order_at_point, ...}` — both `def:codim1_cycles` and `def:order_at_point` are defined in `RiemannRoch_WeilDivisor.tex` (Route-C, **PAUSED**). This places `lem:milne_codim1_indeterminacy` — a declared `\leanok` declaration feeding the Milne Thm 3.2 chain — transitively on the paused route. **wire-up** direction: the `\uses{}` edges should either (a) be moved to an active-route chapter that re-defines the order-at-a-point and codim-1-cycles vocabulary, or (b) the declarations should be split out of `RiemannRoch_WeilDivisor.tex` into a standalone chapter that both routes can use.
- `Albanese_CodimOneExtension.tex` / `thm:weil_divisor_obstruction` (line 1472): `\uses{..., def:order_at_point, ...}` — same violation. Additionally carries `\lean{AlgebraicGeometry.TODO.weilDivisorObstruction}` (unformalised stub).
- **Severity: STRATEGY-MODIFYING.** The active Route-A cone (`CodimOneExtension` is an A.4.a sub-row) has DAG edges into the permanently paused Route-C `WeilDivisor` chapter. A prover dispatched to `CodimOneExtension.lean` with objective `lem:milne_codim1_indeterminacy` will reach `def:order_at_point` and find it in a paused chapter with a sorry body. The loop cannot close A.4.a without resolving this boundary — either by moving the Weil-divisor vocabulary to a shared active-route chapter, or by designating it explicitly as a sub-dependency of both routes with its own prover assignment.

**Known-issues cross-check:**
- `lem:S3_sep_2_*`, `lem:S3_pi_2_*`, `lem:isiso_sheafification_map_of_W`: isolation-EXEMPT per reviewer certification. Additionally, `lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable` and `lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange` appear in the `unmatched_lean` list (their `\lean{}` targets don't exist in the Lean tree). These are already isolation-EXEMPT; no re-flag on isolation, but the `unmatched_lean` status means the Lean targets were never implemented. Consistent with descoped/superseded disposition.

**Unfaithful `\mathlibok` check:**
- `def:Abelian_Ext_chgUnivLinearEquiv` → `CategoryTheory.Abelian.Ext.chgUnivLinearEquiv`: this node has a `\lean{}` hint pointing at a Mathlib declaration that does not exist. If this block carries `\mathlibok`, that would be an unfaithful anchor. Recommend verifying whether this block is `\mathlibok` or just a stub target. **Soft flag until chapter is confirmed** (the chapter could not be determined from leandag due to `unknown` chapter field).

---

## Unstarted-phase blueprint proposals

### Proposed chapter: `blueprint/src/chapters/Genus0BaseObjects_BareScheme.tex`

**Covers**: `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean`
**Strategy phase**: genusZero + witness body (gated A.3)
**Why now**: `AbelianVarietyRigidity.tex` covers only the main named declarations from this file; 11 lean-aux nodes are unmatched and include the `mvPoly*` Mathlib-supplement block plus structural instances that feed the chart-ring iso (`ChartIso.lean`). A dedicated chapter makes the substrate debt auditable and separates it from the large AbelianVarietyRigidity chapter.

**Key declarations** (dependency order):
1. `\definition` `\label{def:projectiveLineBarGrading}` — The standard ℕ-grading `MvPolynomial.homogeneousSubmodule (Fin 2) kbar` on `k̄[X₀, X₁]`. `\lean{AlgebraicGeometry.projectiveLineBarGrading}` [expected]. Source: standard graded algebra, no external ref needed.
2. `\lemma` `\label{lem:projectiveLineBarGrading_gradedRing}` — `GradedRing` instance for the above. `\lean{AlgebraicGeometry.projectiveLineBarGrading_gradedRing}` [expected]. Source: Archon-original instance.
3. `\definition` `\label{def:algebraKbarAway}` — `Algebra kbar (HomogeneousLocalization.Away 𝒜 f)` instance bridging `kbar → 𝒜 0 → Away`. `\lean{AlgebraicGeometry.algebraKbarAway}` [expected]. Source: Archon-original.
4. `\definition` `\label{def:mvPolySubmersivePresentation}` — Canonical `SubmersivePresentation` of `MvPolynomial (Fin n) R` (Mathlib supplement). `\lean{AlgebraicGeometry.mvPolySubmersivePresentation}` [expected]. Source: Archon-original Mathlib gap fill.
5. `\lemma` `\label{lem:mvPolynomialFin_isStandardSmoothOfRelativeDimension}` — `MvPolynomial (Fin n) R` is standard smooth of relative dimension `n`. `\lean{AlgebraicGeometry.mvPolynomialFin_isStandardSmoothOfRelativeDimension}` [expected]. Source: Archon-original.
6. `\definition` `\label{def:ProjectiveLineBar}` — The projective line `ℙ¹_{k̄}` as a scheme and as an `Over (Spec k̄)` object. `\lean{AlgebraicGeometry.ProjectiveLineBarScheme}`, `\lean{AlgebraicGeometry.ProjectiveLineBar}` [expected]. Source: standard.
7. `\lemma` `\label{lem:projectiveLineBar_isProper}` — `ℙ¹_{k̄}` is proper over `Spec k̄`. `\lean{AlgebraicGeometry.projectiveLineBar_isProper}` [expected]. Source: Mathlib `Proj.instIsProperToSpecZero*`.
8. `\lemma` `\label{lem:projectiveLineBar_geomIrred}` — `ℙ¹_{k̄}` is geometrically irreducible (sorry scaffold). `\lean{AlgebraicGeometry.projectiveLineBar_geomIrred}` [expected]. Source: scaffold / sorry.
9. `\definition` `\label{def:projectiveLineBarAffineCover}` — The 2-chart affine open cover of `ℙ¹_{k̄}`. `\lean{AlgebraicGeometry.projectiveLineBarAffineCover}` [expected]. Source: `Proj.affineOpenCoverOfIrrelevantLESpan`.
10. `\lemma` `\label{lem:projectiveLineBarAffineCover_hm}` — Positive-degree witness for the cover indexing. `\lean{AlgebraicGeometry.projectiveLineBarAffineCover_hm}` [expected]. Source: Archon-original auxiliary.

**`\uses` skeleton**:
- `lem:projectiveLineBarGrading_gradedRing` uses `def:projectiveLineBarGrading`
- `def:algebraKbarAway` uses `def:projectiveLineBarGrading`
- `lem:mvPolynomialFin_isStandardSmoothOfRelativeDimension` uses `def:mvPolySubmersivePresentation`
- `def:ProjectiveLineBar` uses `def:projectiveLineBarGrading`, `lem:projectiveLineBarGrading_gradedRing`
- `lem:projectiveLineBar_isProper` uses `def:ProjectiveLineBar`
- `def:projectiveLineBarAffineCover` uses `def:ProjectiveLineBar`, `def:projectiveLineBarGrading`

**Main theorem proof strategy**: The `isProper` instance chains `Proj.toSpecZero` properness + `Spec.map` of the bijective `algebraMap kbar (𝒜 0)` as an iso, composed via properness-of-composition. The `projectiveLineBarAffineCover` applies `Proj.affineOpenCoverOfIrrelevantLESpan` to the family `![X 0, X 1]` with `m = ![1, 1]`, with the irrelevant-ideal containment proved by `MvPolynomial.X_dvd_monomial`. The `mvPolySubmersivePresentation` is the Mathlib-supplement block using `Algebra.Generators.ofSurjective` + zero-relations.

**References for writer**:
- No local reference file needed; the constructions are Mathlib/Archon-original. Cross-reference `\cref{chap:AbelianVarietyRigidity}` for the geometric context.

**Subphase choices exposed**:
- `projectiveLineBar_geomIrred` (currently a sorry): either (a) prove via `Proj` irreducibility for a polynomial ring (Mathlib gap), or (b) leave as named sorry scaffold. Recommendation: (b) keep sorry, flag as known gap.

---

### Proposed chapter: `blueprint/src/chapters/Genus0BaseObjects_ChartIso.tex`

**Covers**: `AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean`
**Strategy phase**: genusZero + witness body
**Why now**: 14 lean-aux nodes from `ChartIso.lean` lack blueprint entries; the chart-ring iso `homogeneousLocalizationAwayIso` is the load-bearing datum for the `GmScaling` chart maps and the smoothness instance. Without a chapter, the prover has no blueprint target for the intermediate surjectivity and round-trip proofs.

**Key declarations** (dependency order):
1. `\definition` `\label{def:otherFin}` — The "other" `Fin 2` index function. `\lean{AlgebraicGeometry.otherFin}` [expected]. Source: Archon-original.
2. `\definition` `\label{def:chartEvalRingHom}` (private) — The chart-`i` evaluation `MvPolynomial (Fin 2) k̄ →+* MvPolynomial Unit k̄`. `\lean{AlgebraicGeometry.chartEvalRingHom}` [expected]. Source: Archon-original.
3. `\definition` `\label{def:homogeneousLocalizationAwayToMvPoly}` — Forward direction of chart-ring iso. `\lean{AlgebraicGeometry.homogeneousLocalizationAwayToMvPoly}` [expected]. Source: `Localization.awayLift` universal property.
4. `\definition` `\label{def:mvPolyToHomogeneousLocalizationAway}` — Inverse direction. `\lean{AlgebraicGeometry.mvPolyToHomogeneousLocalizationAway}` [expected]. Source: `MvPolynomial.eval₂Hom` + `Away.isLocalizationElem`.
5. `\lemma` `\label{lem:mvPolyToHomogeneousLocalizationAway_surjective}` — The inverse is surjective (using `Away.adjoin_mk_prod_pow_eq_top`). `\lean{AlgebraicGeometry.mvPolyToHomogeneousLocalizationAway_surjective}` [expected]. Source: Mathlib `HomogeneousLocalization.Away.adjoin_mk_prod_pow_eq_top`.
6. `\definition` `\label{def:homogeneousLocalizationAwayIso}` — The chart-ring isomorphism `Away 𝒜 (X i) ≃+* k̄[u]`. `\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso}` [expected]. Source: `RingEquiv.ofRingHom` composition.
7. `\lemma` `\label{lem:homogeneousLocalizationAwayIso_algebraMap}` — The iso preserves `kbar`-algebra structure. `\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso_algebraMap}` [expected]. Source: Archon-original.
8. `\lemma` `\label{lem:projectiveLineBar_smoothOfRelDim}` — `ℙ¹_{k̄}` is smooth of relative dimension 1 over `Spec k̄`. `\lean{AlgebraicGeometry.projectiveLineBar_smoothOfRelDim}` [expected]. Source: `HasRingHomProperty.Spec_iff` + `of_algEquiv` with the chart-ring iso.

**`\uses` skeleton**:
- `lem:mvPolyToHomogeneousLocalizationAway_surjective` uses `def:mvPolyToHomogeneousLocalizationAway`, `def:homogeneousLocalizationAwayToMvPoly`
- `def:homogeneousLocalizationAwayIso` uses `def:homogeneousLocalizationAwayToMvPoly`, `def:mvPolyToHomogeneousLocalizationAway`, `lem:mvPolyToHomogeneousLocalizationAway_surjective`
- `lem:homogeneousLocalizationAwayIso_algebraMap` uses `def:homogeneousLocalizationAwayIso`, `def:mvPolyToHomogeneousLocalizationAway`
- `lem:projectiveLineBar_smoothOfRelDim` uses `def:homogeneousLocalizationAwayIso`, `lem:homogeneousLocalizationAwayIso_algebraMap`, `def:ProjectiveLineBar` [from BareScheme chapter]

**Main theorem proof strategy**: The surjectivity proof applies `Away.adjoin_mk_prod_pow_eq_top` at `d=1` with the 2-generator vector `![X 0, X 1]`, then does `Algebra.adjoin_induction` to show every generator is a power of `isLocalizationElem`. The smoothness proof rewrites the chart morphism via `awayι_toSpecZero` + `Spec.map_comp`, reduces to `RingHom.IsStandardSmoothOfRelativeDimension 1 (algebraMap kbar Away)`, and applies `Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv` with the chart iso composed with `MvPolynomial.renameEquiv finOneEquiv`.

**References for writer**:
- `references/kleiman-picard-src/kleiman-picard.tex` — structural background on the Picard scheme, but not directly needed for the chart-ring iso itself.
- The constructions are self-contained Archon-original proofs.

---

### Proposed chapter: `blueprint/src/chapters/Genus0BaseObjects_Points.tex`

**Covers**: `AlgebraicJacobian/Genus0BaseObjects/Points.lean`
**Strategy phase**: genusZero + witness body
**Why now**: 25 lean-aux nodes unmatched; among them are `GaScheme`, `GmScheme`, `GmRing`, `gm_grpObj`, `gm_smooth` — all public, mathematically substantive declarations for the genus-0 witness. `AbelianVarietyRigidity.tex` names `Gm.onePt` but not the full Gm construction chain.

**Key declarations** (dependency order):
1. `\definition` `\label{def:projectiveLineBar_points}` — The three standard `k̄`-points `zeroPt`, `onePt`, `inftyPt` of `ℙ¹_{k̄}` as sections `𝟙_ → ProjectiveLineBar kbar`. `\lean{AlgebraicGeometry.ProjectiveLineBar.zeroPt}`, `..onePt`, `..inftyPt` [expected]. Source: `Proj.fromOfGlobalSections` + evaluation.
2. `\definition` `\label{def:Ga}` — Additive group `𝔾_a = AffineSpace (Fin 1) (Spec k̄)` as an `Over (Spec k̄)` object. `\lean{AlgebraicGeometry.Ga}`, `\lean{AlgebraicGeometry.GaScheme}` [expected]. Source: Mathlib `AffineSpace`.
3. `\lemma` `\label{lem:Ga_instances}` — `𝔾_a` is affine, locally of finite presentation, reduced. `\lean{AlgebraicGeometry.ga_isAffineHom}`, `..ga_locallyOfFinitePresentation`, `..ga_isReduced` [expected]. Source: Mathlib instances.
4. `\definition` `\label{def:GmRing}` — The ring `k̄[t, t⁻¹] = Localization.Away (X () : MvPolynomial Unit k̄)`. `\lean{AlgebraicGeometry.GmRing}` [expected]. Source: standard localization.
5. `\definition` `\label{def:Gm}` — Multiplicative group `𝔾_m = Spec k̄[t, t⁻¹]` as an `Over (Spec k̄)` object. `\lean{AlgebraicGeometry.Gm}`, `\lean{AlgebraicGeometry.GmScheme}` [expected]. Source: Archon-original.
6. `\lemma` `\label{lem:Gm_instances}` — `𝔾_m` is affine, locally of finite presentation, reduced, irreducible (via `gmRing_isDomain`). `\lean{AlgebraicGeometry.gm_isAffine}`, `..gm_locallyOfFinitePresentation`, `..gm_isReduced`, `..gm_irreducibleSpace`, `..gmRing_isDomain` [expected]. Source: Mathlib `IsLocalization.isDomain_localization`.
7. `\theorem` `\label{thm:Gm_grpObj}` — `GrpObj` structure on `𝔾_m` via `GrpObj.ofRepresentableBy` with the units functor `T ↦ Γ(T.left, ⊤)ˣ`. `\lean{AlgebraicGeometry.gm_grpObj}` [expected]. Source: per-`T` bijection via `IsLocalization.Away` universal property.
8. `\lemma` `\label{lem:Gm_smooth}` — `𝔾_m` is smooth over `Spec k̄` (when `k̄` is algebraically closed). `\lean{AlgebraicGeometry.gm_smooth}` [expected]. Source: `smooth_of_grpObj_of_isAlgClosed`.
9. `\definition` `\label{def:Gm_onePt}` — The multiplicative identity `η[Gm kbar]` as a `k̄`-point. `\lean{AlgebraicGeometry.Gm.onePt}` [expected]. Source: group-object unit.

**`\uses` skeleton**:
- `def:Gm` uses `def:GmRing`
- `lem:Gm_instances` uses `def:Gm`, `def:GmRing`
- `thm:Gm_grpObj` uses `def:Gm`, `lem:Gm_instances`
- `lem:Gm_smooth` uses `thm:Gm_grpObj`, `lem:Gm_instances`
- `def:Gm_onePt` uses `thm:Gm_grpObj`
- `def:projectiveLineBar_points` uses `def:ProjectiveLineBar` [from BareScheme chapter], `def:homogeneousLocalizationAwayIso` [from ChartIso chapter]

**Main theorem proof strategy**: The `GrpObj` instance for `𝔾_m` uses `GrpObj.ofRepresentableBy` with the units functor `T ↦ GrpCat.of Γ(T.left, ⊤)ˣ`. The per-`T` bijection is: forward `f ↦ unit(f.left.appTop(algebraMap GmRing generator))`, inverse `u ↦ (IsLocalization.Away.lift)` sending `t ↦ u.val`, with round-trips proved via `IsLocalization.lift_unique` + `IsLocalization.Away.lift_eq`. Naturality reduces to `Scheme.Hom.comp_appTop`.

**References for writer**:
- No local reference file specifically needed. Mathlib `IsLocalization.Away` API is the key tool.
- `references/abelian-varieties.md` §I.2 (the additive/multiplicative group schemes) for context.

---

### Proposed chapter: `blueprint/src/chapters/Genus0BaseObjects_GmScaling.tex`

**Covers**: `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`
**Strategy phase**: genusZero + witness body
**Why now**: 8 lean-aux nodes unmatched; among them `gmScalingP1` (the bare scaling morphism) and `gmScalingP1_collapse_at_zero` (the load-bearing fixed-point lemma consumed by the rigidity shortcut in `AbelianVarietyRigidity.lean`). Without a dedicated chapter, the 1-to-1 debt is opaque.

**Key declarations** (dependency order):
1. `\lemma` `\label{lem:projectiveLineBar_isReduced}` — `ℙ¹_{k̄}` is reduced. `\lean{AlgebraicGeometry.projectiveLineBar_isReduced}` [expected]. Source: `IsReduced.of_openCover`; each chart is a domain via `HomogeneousLocalization.val_injective`.
2. `\definition` `\label{def:gmScalingP1_ringMaps}` — Per-chart ring maps `gmScalingP1_chart{0,1}_ringMap` for the scaling action (chart-1: `u ↦ u ⊗ λ`; chart-0: `t ↦ t ⊗ λ⁻¹`). `\lean{AlgebraicGeometry.gmScalingP1_chart1_ringMap}`, `..chart0_ringMap` [expected]. Source: `MvPolynomial.eval₂Hom` with tensor algebra map.
3. `\definition` `\label{def:gmScalingP1}` — The `𝔾_m`-scaling morphism `σ_× : ℙ¹ × 𝔾_m ⟶ ℙ¹` assembled from per-chart maps via `Scheme.Cover.glueMorphisms`. `\lean{AlgebraicGeometry.gmScalingP1}` [expected]. Source: `Scheme.Cover.glueMorphisms` applied to `gmScalingP1_chart` family.
4. `\lemma` `\label{lem:gmScalingP1_collapse_at_zero}` — **Load-bearing fixed-point**: `σ_×(0, λ) = 0` for all `λ ∈ 𝔾_m`. `\lean{AlgebraicGeometry.gmScalingP1_collapse_at_zero}` [expected]. Source: Archon-original; the hypothesis consumed by `hom_additive_decomp_of_rigidity` (Cor 1.5) in `AbelianVarietyRigidity.lean`.
5. `\lemma` `\label{lem:gmScalingP1_chart_agreement}` — Cocycle agreement on chart intersections. `\lean{AlgebraicGeometry.gmScalingP1_chart_agreement}` [expected]. Source: iter-188 (III.c) separated-locus structural setup.
6. `\lemma` `\label{lem:gmScalingP1_over_coherence}` — The glued map intertwines structure maps to `Spec k̄`. `\lean{AlgebraicGeometry.gmScalingP1_over_coherence}` [expected]. Source: `Scheme.Cover.hom_ext` + per-chart bridge.
7. `\lemma` `\label{lem:product_stability_instances}` — `ℙ¹ ⊗ 𝔾_m` has the required smoothness, geometric irreducibility, and product-stability instances for Lane B. `\lean{AlgebraicGeometry.gm_geomIrred}`, `\lean{AlgebraicGeometry.projGm_isReduced}` [expected, current sorrys]. Source: Archon-original scaffold.

**`\uses` skeleton**:
- `def:gmScalingP1` uses `def:gmScalingP1_ringMaps`, `lem:gmScalingP1_chart_agreement`, `lem:gmScalingP1_over_coherence`, `def:homogeneousLocalizationAwayIso` [from ChartIso chapter], `def:Gm` [from Points chapter]
- `lem:gmScalingP1_collapse_at_zero` uses `def:gmScalingP1`
- `lem:gmScalingP1_chart_agreement` uses `lem:projectiveLineBar_isReduced`, `def:gmScalingP1_ringMaps` and the Cross01Substrate lemmas

**Main theorem proof strategy**: The cocycle proof (`gmScalingP1_chart_agreement`) uses the iter-188 (III.c) separated-locus route: build the pair morphism `s_pair` via `pullback.lift` using the post-PLB agreement `hPLB_agree`; show `IsClosedImmersion(diagonal)` and topological range containment via Jacobson density + closed-point evaluation (substantive residual: the closed-point check); factor through the diagonal via `IsClosedImmersion.lift_iff_range_subset` from `Cross01Substrate.lean`; derive cocycle via `pullback.diagonal_fst/snd`. The fixed-point `gmScalingP1_collapse_at_zero` evaluates the chart-0 ring map at the affine origin.

**References for writer**:
- `references/abelian-varieties.md` §I.3 (Cor. 1.5 rigidity shortcut) — why the fixed-point is load-bearing.
- Cross-reference `\cref{chap:Genus0BaseObjects_Cross01Substrate}` for the `IsClosedImmersion.lift_iff_range_subset` and `gmRing_tensor_homogeneousAway_isDomain` substrates.

---

### Proposed chapter: `blueprint/src/chapters/Genus0BaseObjects.tex`

**Covers**: `AlgebraicJacobian/Genus0BaseObjects.lean` (the root re-export shim)
**Strategy phase**: genusZero + witness body
**Why now**: The root file is a pure re-export shim (3 imports, no declarations beyond them), so no blueprint entry exists and the leandag registers it as uncovered. A minimal pointer chapter satisfies the 1-to-1 requirement at zero cost.

**Key declarations** (in dependency order):
1. `\remark` `\label{rem:genus0_reexport}` — One-line pointer: the root file re-exports `BareScheme`, `ChartIso`, `Points`, `GmScaling` via Lean's import mechanism. No new declarations. `\lean{}` hint: none needed. Source: Archon-original file organization.

**`\uses` skeleton**:
- `rem:genus0_reexport` uses declarations from the four sibling sub-chapters.

**Main theorem proof strategy**: N/A — pointer chapter only.

**References for writer**: None. The file is a re-export shim; describe the import structure from the file header.

**Subphase choices exposed**: None.

---

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - Covers 7 files via `archon:covers`, but 58 lean-aux nodes across the four Genus0BaseObjects sub-files remain unmatched (25+14+11+8). Dedicated sub-chapters are proposed above.
  - `lem:hom_Ga_to_av_trivial` → `AlgebraicGeometry.hom_Ga_to_av_trivial`: Lean declaration does not exist (name mismatch / stale hint). **Lean difficulty quality: poor**.
  - `lem:hom_from_Ga_trivial` → `AlgebraicGeometry.morphism_Ga_to_av_const`: Lean declaration does not exist. **Lean difficulty quality: poor**.
  - `thm:finite_appTop_of_universallyClosed` → `AlgebraicGeometry.finite_appTop_of_universallyClosed`: Lean declaration does not exist. **Lean difficulty quality: poor**.
  - `lem:S3_sep_1_smooth_geometrically_reduced_Gamma` → `AlgebraicGeometry.isGeometricallyReduced_Gamma_of_smooth`: Lean declaration does not exist. Not in known-issues exemption list. **wire-up** — either this declaration has been renamed (in which case correct the `\lean{}` hint) or the target is missing from Lean.
  - `lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper` → `AlgebraicGeometry.Gamma_baseChange_iso_tensor_of_proper`: Lean declaration does not exist. Same disposition as above.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Explicitly a pointer chapter to `Cotangent/GrpObj.lean`; mathematical content is in `RigidityKbar.tex`. Only 1 label with no `\leanok`. This is by design — the chapter is a cross-file pointer.
  - The 8 `GrpObj_*` TODO stubs (`lem:GrpObj_cotangent_bridge` etc.) are in `RigidityKbar.tex`; this chapter is structurally thin by intent.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - `thm:albanese_universal_property` → `AlgebraicGeometry.Scheme.Pic.albaneseUP`: Lean declaration does not exist at this name. **Lean difficulty quality: poor** — the prover's target is wrong. Either the declaration has been renamed or the namespace is incorrect; the correct target name should be verified via `lean_local_search`.
  - 17 labels, 6 `\leanok`: the chapter covers the A.4.d sub-row adequately for current prover work except for the above name mismatch on the headline theorem.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 31 lean-aux nodes unmatched. Most are private helpers from the Path B matrix-collapse chain (4 private decls at L1418–L1517). The public declarations (`hasProjectiveDimensionLT_ker_of_surjection`, `hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker`, `depth_ker_ge_min_of_surjection_finite_localRing`) ARE individually blueprinted in the chapter. The private helpers are pure plumbing. Verdict: mathematically adequate for prover use.
  - Gate criterion 5 (1-to-1 completeness) fails due to private helpers — but these do not need individual blueprint entries.

### blueprint/src/chapters/Albanese_CoheightBridge.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 13 labels, 8 `\leanok`. The chapter is a project-bespoke substrate for coheight/Krull-dim bridging. The main declarations are blueprinted. Some lean-aux helpers not individually named.
  - `lem:stage6_regular_stalk_assembly` → `AlgebraicGeometry.TODO.stage6_regular_stalk_assembly` appears in a related active-route chapter (CodimOneExtension or CoheightBridge) as a TODO stub. If this node is in this chapter, it is a prover gap.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **CRITICAL**: `lem:milne_codim1_indeterminacy` uses `def:codim1_cycles` and `def:order_at_point` from `RiemannRoch_WeilDivisor.tex` (Route-C, PAUSED). This is a disjointness violation. See Strategy-modifying findings.
  - `thm:weil_divisor_obstruction` uses `def:order_at_point` (same violation) and has `\lean{AlgebraicGeometry.TODO.weilDivisorObstruction}` — an unformalised stub.
  - 30 lean-aux nodes unmatched. Many are private implementation helpers, but the Route-C dependency makes this chapter not safe for active prover dispatch without resolving the boundary.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - 8 labels, only 1 `\leanok`. The headline theorem (Milne Thm 3.2) has a proof sketch that names the two inputs (CodimOneExtension + AuslanderBuchsbaum) but the composition is not detailed enough for a prover to formalize. The chapter is gated on A.4.a (CodimOneExtension) which itself has the Route-C dependency issue.
  - `\uses{thm:codim_one_extension, lem:milne_codim1_indeterminacy}`: via the second `\uses`, this chapter transitively pulls Route-C labels.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - `lem:push_pull_functor` → `AlgebraicGeometry.pushPullMap_comp`: Lean declaration does not exist. **Lean difficulty quality: poor** for this node if it is on an active prover lane.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - `def:Abelian_Ext_chgUnivLinearEquiv` → `CategoryTheory.Abelian.Ext.chgUnivLinearEquiv`: Lean declaration does not exist. Verify whether this is a Mathlib declaration that was renamed/removed, or a project-side declaration that was planned but never written. If the former, this may need `\mathlibok` correction.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - `thm:finite_appTop_of_universallyClosed` → `AlgebraicGeometry.finite_appTop_of_universallyClosed`: Lean declaration does not exist. This is a critical ingredient for the Jacobian chapter; verify whether the declaration is in Lean under a different name. **Lean difficulty quality: poor**.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - 9 blueprint nodes carry `\lean{AlgebraicGeometry.TODO.*}` stubs: `thm:generic_flatness_algebraic`, `lem:flat_locus_open`, `lem:nonflat_locus_proper`, `lem:noetherian_induction_strata`, `lem:smooth_proper_curve_projective`, `lem:quot_reduction_to_pi_star_W`, `lem:quot_boundedness`, `lem:quot_alpha_injective`, `lem:quot_valuative_criterion`. These are the A.2.c-engine declarations (Quot/Cartier, FGA representability). All are known work-in-progress stubs, not errors; but a prover dispatched to `FGAPicRepresentability.lean` has no formalizable target for these 9 blocks.
  - 16 lean-aux nodes unmatched (pure plumbing helpers for the already-blueprinted declarations).
  - `lem:smooth_algebra_krull_dim_formula` → `Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension`: Lean declaration does not exist. **Lean difficulty quality: poor**.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundleCoherence.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - 4 lean-difficulty-quality findings: `lem:baseMap_pullbackComp_apply`, `lem:baseMap_pullback_comp_apply`, `lem:baseMap_pullbackCongr_apply`, `lem:baseMap_inv_step3_open_immersion` all name `AlgebraicGeometry.Scheme.Modules.*` declarations that do not exist in the Lean tree. These are active-route nodes in the A.2.c representability scaffolding. **Lean difficulty quality: poor** for all four.

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - `lem:pullback_compatible_with_tensorobj` → `AlgebraicGeometry.LineBundle.OnProduct.pullback_tensorObj_iso`: Lean declaration does not exist. **Lean difficulty quality: poor**.
  - `lem:isinvertible_implies_locallytrivial` → `AlgebraicGeometry.Scheme.Modules.IsInvertible.isLocallyTrivial`: Lean declaration does not exist. **Lean difficulty quality: poor**.
  - `lem:isinvertible_pullback` → `AlgebraicGeometry.Scheme.Modules.IsInvertible.pullback`: Lean declaration does not exist. **Lean difficulty quality: poor**.
  - `thm:rel_pic_addcommgroup_via_tensorobj` → `AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj`: Lean declaration does not exist. **Lean difficulty quality: poor**.
  - `thm:rel_pic_etale_sheaf_unit_canonical` → `AlgebraicGeometry.TODO.rel_pic_etale_sheaf_unit_canonical`: TODO stub (honest open gap marker, not a quality failure).

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_SheafOverEquivalence.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - The chapter has 123 declaration labels across 5 sub-files (via `archon:covers`). Coverage is excellent for main public declarations but 123 lean-aux nodes lack blueprint entries.
  - Sub-file breakdown of unmatched lean-aux: 40 from `TensorObjSubstrate.lean`, 32 from `PresheafInternalHom.lean`, 24 from `StalkTensor.lean`, 14 from `DualInverse.lean`, 13 from `Vestigial.lean`. The Vestigial cluster (13) consists of off-path route~(e) declarations that are explicitly noted as superseded — these need only one-line "proved directly, off critical path" entries or can be removed from the Lean file.
  - Lean-difficulty-quality findings (9 active-route name mismatches in this chapter, all `AlgebraicGeometry.Scheme.Modules.*` or `LineBundle.OnProduct.*` that don't exist): `lem:pullback_tensor_iso`, `lem:pullback0_tensor_iso`, `lem:pullback_tensor_iso_loctriv`, plus `lem:base_change_map_affine_local` (TODO), `lem:pushforward_base_change_mate_cancelBaseChange` (TODO), `lem:stalk_tensor_commutation_naturality_right` (TODO, honest open gap), `lem:jw_ismonoidal` (TODO, off-path route~(e)).
  - The `PresheafInternalHom.lean` section (§16 "Sheaf internal-hom…") covers the main `homModule`, `internalHomObjModule`, `internalHom` definitions but the 32 unmatched from that file suggest ~30 implementation helpers not individually named.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes. (Route-C, frozen — not flagging internal incompleteness per directive.)

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes. (Route-C, frozen.)

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes. (Route-C, frozen.)

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes. (Route-C, frozen.)

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes. (Route-C, frozen.)

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Route-C chapter, frozen per directive. Not flagging internal incompleteness. BUT: `def:codim1_cycles` and `def:order_at_point` defined here are consumed by `Albanese_CodimOneExtension.tex` (Route-A) — this is the source of the disjointness violation flagged under Strategy-modifying findings.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - The 8 `GrpObj_*` TODO stubs (`lem:GrpObj_cotangent_bridge`, `lem:GrpObj_mulRight_globalises`, `lem:GrpObj_omega_*`, `lem:GrpObj_basechange_along_proj_two_inv_app_isIso`) are explicitly marked in the chapter as descoped from the critical path (iter-145 excision note). **Lean difficulty quality: poor** only if a prover tries to close them — but the chapter disposition says they are not on any current prover lane.
  - `lem:KaehlerDifferential_constants_in_chart_of_proper_curve` → `AlgebraicGeometry.TODO.KaehlerDifferential_constants_in_chart_of_proper_curve`: TODO stub in the `RigidityKbar` or related chapter. Honest open gap.

---

## Strategy-modifying findings (if any)

- `Albanese_CodimOneExtension.tex` / `lem:milne_codim1_indeterminacy`: `\uses{..., def:codim1_cycles, def:order_at_point, ...}` where both labels are **defined in `RiemannRoch_WeilDivisor.tex`** (Route-C, PAUSED permanently). `lem:milne_codim1_indeterminacy` is marked `\leanok`, meaning the Lean body exists, but its blueprint dependencies include paused Route-C nodes. The Route-A active cone (`Albanese_CodimOneExtension → Albanese_Thm32RationalMapExtension → Albanese_AlbaneseUP → nonempty_jacobianWitness`) transitively depends on the PAUSED `RiemannRoch_WeilDivisor` chapter. STRATEGY.md designates Route-C as permanently paused and Route-A as the active critical path, but this dependency means that closing `lem:milne_codim1_indeterminacy` fully requires `def:order_at_point` and `def:codim1_cycles` to also be formalized — which lives in a paused chapter with inline sorries. **Required action**: the plan agent must decide whether (a) `def:order_at_point` and `def:codim1_cycles` should be extracted from `RiemannRoch_WeilDivisor.tex` into a shared active-route chapter accessible to both routes, (b) `lem:milne_codim1_indeterminacy` should be restructured to avoid these dependencies, or (c) these declarations should be promoted to an independent sub-chapter with their own prover assignment. This is a gating STRATEGY.md update need before A.4.a can be dispatched cleanly.

---

## Severity summary

### must-fix-this-iter

1. **Strategy-modifying finding**: `Albanese_CodimOneExtension.tex` / `lem:milne_codim1_indeterminacy` + `thm:weil_divisor_obstruction` — Route-A cone transitively uses paused Route-C `RiemannRoch_WeilDivisor` declarations (`def:codim1_cycles`, `def:order_at_point`). STRATEGY.md update required; prover cannot be safely dispatched to A.4.a without resolving this boundary. Also propagates to `Albanese_Thm32RationalMapExtension.tex` via `\uses`.

2. **Unstarted-phase proposal: `Genus0BaseObjects_BareScheme.tex`** — dispatch blueprint-writer for `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean` (11 unmatched lean-aux; enables 1-to-1 completeness for BareScheme) or record deferral.

3. **Unstarted-phase proposal: `Genus0BaseObjects_ChartIso.tex`** — dispatch blueprint-writer for `AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean` (14 unmatched lean-aux; enables 1-to-1 completeness for ChartIso) or record deferral.

4. **Unstarted-phase proposal: `Genus0BaseObjects_Points.tex`** — dispatch blueprint-writer for `AlgebraicJacobian/Genus0BaseObjects/Points.lean` (25 unmatched lean-aux including substantive public declarations for Ga, Gm, gm_grpObj) or record deferral.

5. **Unstarted-phase proposal: `Genus0BaseObjects_GmScaling.tex`** — dispatch blueprint-writer for `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` (8 unmatched lean-aux including the load-bearing `gmScalingP1_collapse_at_zero`) or record deferral.

6. **Unstarted-phase proposal: `Genus0BaseObjects.tex`** (root re-export pointer) — trivial chapter, dispatch or record deferral.

7. **Lean difficulty quality — active-route chapters with missing Lean targets** (must-fix since these are in active prover lanes A.1.c, A.2.c, A.4.d):
   - `Picard_RelPicFunctor.tex`: 4 nodes with non-existent Lean targets (pullback_tensor_iso family, IsInvertible family, addCommGroup_via_tensorObj).
   - `Picard_QuotScheme.tex`: 4 `baseMap_*` nodes with non-existent targets.
   - `AbelianVarietyRigidity.tex`: `lem:hom_Ga_to_av_trivial`, `lem:hom_from_Ga_trivial`, `thm:finite_appTop_of_universallyClosed` have non-existent Lean targets.
   - `Albanese_AlbaneseUP.tex`: `thm:albanese_universal_property` → non-existent `Scheme.Pic.albaneseUP`.
   - `Jacobian.tex`: `thm:finite_appTop_of_universallyClosed` non-existent.
   - `AbelianVarietyRigidity.tex`: `lem:S3_sep_1_*` and `lem:S3_pi_1_*` (NOT in the known-issues isolation-exempt list) have non-existent Lean targets.

8. **Broken `\uses{}` edges (`wire-up` dispositions)** — `AbelianVarietyRigidity.tex` / `lem:S3_sep_1_smooth_geometrically_reduced_Gamma` and `lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper`: these nodes appear in the `unmatched_lean` list (Lean targets don't exist), and they are NOT in the known-issues isolation-exempt list (only S3_sep_2_* and S3_pi_2_* are exempt). Disposition: **wire-up** — verify if these Lean declarations were renamed, and either correct the `\lean{}` hint or add `\mathlibok` if they are Mathlib results.

### soon

- `Picard_TensorObjSubstrate.tex`: 123 unmatched lean-aux nodes across 5 sub-files (private helpers and intermediate lemmas). Not blocking current prover work on the chapter's main public API, but contributes to gate criterion 5 failure. A writer pass adding one-line entries for substantive intermediates (especially in PresheafInternalHom and StalkTensor clusters) would clear this.
- `Albanese_AuslanderBuchsbaum.tex`: 31 unmatched lean-aux nodes (private Path B helpers). Same as above.
- `Cohomology_MayerVietoris.tex` / `lem:push_pull_functor`: non-existent Lean target — soon if not on active prover lane.
- `Cohomology_StructureSheafModuleK.tex` / `def:Abelian_Ext_chgUnivLinearEquiv`: non-existent Mathlib declaration — investigate and correct or add `\mathlibok`.
- `Picard_TensorObjSubstrate.tex` / Vestigial cluster (13 unmatched lean-aux): off-path route~(e) declarations. If the Lean file contains them, they need one-line "proved directly in Lean, off-path route~(e)" entries or should be removed from the Lean file.

### informational

- `RigidityKbar.tex` / 8 descoped `GrpObj_*` TODO stubs: correctly tagged as off-path; no prover action needed.
- `Picard_TensorObjSubstrate.tex` / `lem:jw_ismonoidal`: off-path route~(e), correctly tagged as superseded.
- `Picard_FGAPicRepresentability.tex` / 9 `AlgebraicGeometry.TODO.*` stubs: honest open-gap markers for the A.2.c-engine; not quality failures, just work not yet done.
- The `def:Abelian_Ext_chgUnivLinearEquiv` Mathlib gap claim (if unfounded) — verify whether this is a Mathlib declaration that never existed or was removed.

---

**Overall verdict**: The blueprint is NOT 1-to-1 complete (gate criterion 5 fails: 427 lean-aux nodes and 47 unmatched `\lean{}` hints). One strategy-modifying finding: the Route-A active cone (`Albanese_CodimOneExtension`) transitively depends on paused Route-C `RiemannRoch_WeilDivisor` declarations via `\uses{}` edges — a STRATEGY.md update and boundary resolution are required before A.4.a provers can be safely dispatched. 5 Genus0BaseObjects files have no dedicated chapter; proposals provided for immediate writer dispatch. 15 active-route blueprint nodes name Lean targets that do not exist (name mismatches / stale hints) — these must be corrected before prover dispatch for the affected chapters.
