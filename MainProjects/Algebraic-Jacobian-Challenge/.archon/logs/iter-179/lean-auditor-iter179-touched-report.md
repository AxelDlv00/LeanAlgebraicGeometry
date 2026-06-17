# Lean Audit Report

## Slug
iter179-touched

## Iteration
179

## Scope
- files audited: 38
- files skipped (per directive): 0
- baseline: every `.lean` under `AlgebraicJacobian/` plus the top-level `AlgebraicJacobian.lean` re-export.

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure re-export aggregator (31 imports, no declarations).

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: 1
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 0–1 (long line at L22, style-linter only — per directive: skip)
- **excuse-comments**: none
- **notes**:
  - L14–28 status block names "iteration 073" / "Phase E" — sequencing has moved well past 073, but the projection structure described is still accurate. Stale-but-not-misleading.
  - All three declarations cleanly project from `(jacobianWitness C).isAlbaneseFor P`. Honest.

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 3 (`iotaGm_isDominant` L120, `genusZero_curve_iso_P1` L327, plus propagation through `gmScalingP1_collapse_at_zero` axiom)
- **bad practices**: none
- **excuse-comments**: none (all docstrings concrete about state)
- **notes**:
  - L120 `iotaGm_isDominant`: ends in bare `sorry` after `rw [Over.comp_left]; refine ⟨?_⟩`. Gated on Lane A `gmScalingP1` body; documented honestly.
  - L327 `genusZero_curve_iso_P1`: substantive type `Nonempty (C ≅ ProjectiveLineBar kbar)`, body `:= sorry`. Honest RR-bridge gap.
  - `morphism_P1_to_grpScheme_const_aux` (L144) consumes `gmScalingP1_collapse_at_zero`, which in `GmScaling.lean` is currently a wrapper around the TEMP axiom `gmScalingP1_collapse_at_zero_temp` — sorryAx/axiom taint propagates through this file's downstream theorems. Known per directive.

### AlgebraicJacobian/Albanese/AlbaneseUP.lean
- **outdated comments**: none
- **suspect definitions**: 1 (`bundle`)
- **dead-end proofs**: 5 (one per pinned `def`/`theorem`)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L183 `bundle : Bundle C := sorry`. This is a LOAD-BEARING typed sorry — every downstream declaration (`jacobianScheme`, `instGrpObj`, `instIsProper`, `instSmooth`, `instGeomIrred`) projects from it. The pattern is consistent with the project's "file-internal placeholder" convention and is documented (§0). It is a clean bottleneck — five pinned consumer pins use it — but it is still a `sorry` with non-trivial output type (a `Bundle` carrying four instances).
  - L240, L287, L322, L362, L401, L466: each pinned `def`/`theorem` ends in `sorry`. Type signatures match the blueprint pins.
  - L287 `SymmetricPower _ _g : Over (Spec (.of kbar)) := sorry` — typed `sorry` returning a scheme: substantive, but a building block all the others reference.

### AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean
- **outdated comments**: none
- **suspect definitions**: 1 (`Module.depth` at L146)
- **dead-end proofs**: 5
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L146 `def depth ... : ℕ∞ := sorry`. A typed `sorry` at the data level — the value is undefined. Every downstream lemma referencing `depth` is built on top. Documented; iter-180+ body work.
  - Iter-178 docstring (L28–31) correctly reflects `Module.projectiveDimension` closure at L183–185. No stale auditor-178C residue: docstring section ends consistently with the live body. **AUDITOR 178C ADDRESSED.**
  - L394 `instance of_regular ... where depth_eq_krullDim := by sorry` — honest scaffold.

### AlgebraicJacobian/Albanese/CodimOneExtension.lean
- **outdated comments**: none
- **suspect definitions**: 1 (internal helper `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` carries one named sorry `hreg_dim`)
- **dead-end proofs**: 3 (`extend_of_codimOneFree_of_smooth` L368, `indeterminacy_pure_codim_one_into_grpScheme` L411, internal `hreg_dim` at L243)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L477 `mem_domain_iff_exists_partialMap_through_point`: the rename per Path D2 happened (`extend_iff_order_nonneg` → renamed); the unused `KrullDimLE 1`/`IsLocallyNoetherian` binders were dropped. The body (L489-491) is genuinely honest — it discharges the substantive content via `Scheme.RationalMap.mem_domain` + a `⟨_, _⟩` swap of the conjuncts under the existential. **AUDITOR 178B ADDRESSED honestly.**
  - L242 `hreg_dim : ... := sorry`. Internal sorry inside `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`; documented as the Mathlib-gap (`Smooth ⟹ IsRegularLocalRing` at codim-1 + coheight-to-Krull-dim bridge). The rest of the helper (L244-271) is a real proof on top.
  - L368, L411 stay typed-sorry honest scaffolds; signatures unchanged.

### AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean
- **outdated comments**: none
- **suspect definitions**: 1 (`av_isIntegral_and_codimOneFree` returns a substantive conjunction; body `:= sorry`)
- **dead-end proofs**: 1 (the helper); the main `extend_to_av` body is honest.
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L198 helper `av_isIntegral_and_codimOneFree` has type `IsIntegral A.left ∧ CodimOneFree f`. Both conjuncts are substantive (not `True`, not laundering). Body `:= sorry` is honest. **Verified the helper type is substantive per directive.**
  - L249–257 `extend_to_av` proof: real tactic block — materialises three variety-package instances on `A.left`, obtains the helper, applies `extend_of_codimOneFree_of_smooth`. No inline sorry.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 0 (uses `set_option backward.isDefEq.respectTransparency false in` per Mathlib precedent at three sites)
- **excuse-comments**: none
- **notes**:
  - Mathlib gap-fills in `Abelian.Ext` namespace (`chgUniv_add`, `chgUniv_smul`, `chgUnivLinearEquiv`) all closed kernel-clean.
  - Long file (~630 LOC) but no sorry; all 16 declarations are honest.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All declarations close cleanly via the iter-029–053 infrastructure. Heavy typeclass plumbing but signatures match Mathlib idiom.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 50-LOC file; single instance closed.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 64-LOC file; three declarations all honestly closed.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 30-LOC re-export shim (three imports). Skeleton only.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All declarations closed honestly; classes `IsAffineHModuleVanishing` / `IsHModuleHomFinite` carry real content; the iter-046 producer instance is fully proven.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: All categorical gap-fills closed; honest.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/SheafProperty.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 60-LOC file; closes the sheaf condition via `convert`-trick to the underlying ring-sheaf — clean.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: 2 (iter-145, iter-146 historical NOTES at L20-34)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 (`open scoped IntermediateField TensorProduct` and use of `attribute [local instance]` re-enabling a Mathlib-local instance — flagged but consistent with the docstring's stated approach)
- **excuse-comments**: none
- **notes**:
  - L20-34 standalone NOTES blocks are historical (iter-145/146 retrospectives). They explain WHY current imports look how they do — value to future readers. Minor staleness; could be retired but not actively misleading.
  - `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` (L197): real long proof; axiom-clean. Honest delegation downstream.
  - `df_zero_factors_through_constant_on_chart` (L315): one-line delegate. Documented hypothesis inflation.
  - `constants_integral_over_base_field` (L369): real proof, three-step pivot. Closed.
  - `Scheme.Over.ext_of_diff_zero` (L443): thin renaming of `ext_of_eqOnOpen`; honest.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 1 (mid-file references to "iter-145 EXCISE" at L552 and L624 are historical — actual excisions happened and only the comment-markers remain; harmless)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `cotangentSpaceAtIdentity` (L162) is a noncomputable def using `Classical.choose`-extracted chart witnesses. Body is real (no `sorry`). Docstring transparent that the chart is non-canonical.
  - `cotangentSpaceAtIdentity_finrank_eq` (L257) — real proof using `Module.finrank_baseChange` + `Module.finrank_eq_of_rank_eq`. Closed.
  - `shearMulRight` (L350) — real iso construction.
  - `isIso_of_app_iso_module` (L545) — utility helper for `PresheafOfModules` iso reflection.
  - `relativeDifferentialsPresheaf_restrict_along_identity_section` (L579) — real proof using `pullbackComp` + `eqToIso`.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `kaehler_quotient_localization_iso` (L86) and `kaehler_localization_subsingleton` (L70) are honest project-local lemmas with real proofs.
  - `smooth_locally_free_omega` (L124) closes via `first | … | …` against the Mathlib `SmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension` API. Clean.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: One declaration `genus`; clean one-liner.

### AlgebraicJacobian/Genus0BaseObjects.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 28-LOC re-export shim of four sub-files. Skeleton only.

### AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 (`projectiveLineBar_geomIrred` L156, `projectiveLineBar_smoothOfRelDim` L163)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L156, L163 are the project-known scaffold instances; docstrings call out the Mathlib-gap. Per directive, NOT a new finding.
  - The substantive `projectiveLineBar_isProper` instance and the elaborate cover construction (L197-241) are real proofs. Clean.

### AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 380 LOC with the entire chart-ring iso built kernel-clean; the iter-172 surjectivity proof (`mvPolyToHomogeneousLocalizationAway_surjective`) is real, real, real (140 LOC body). No sorries.

### AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean
- **outdated comments**: none
- **suspect definitions**: 2 (`gmScalingP1_chart_data_temp` L193 TEMP axiom; `gmScalingP1_collapse_at_zero_temp` L336 TEMP axiom)
- **dead-end proofs**: 3 (`gmScalingP1_chart_PLB_eq` body L213→L250 ends in `sorry`; `gmScalingP1_chart_agreement` L266→L280 wraps the temp axiom's 2nd conjunct; `gmScalingP1_collapse_at_zero` L358→L364 wraps the temp axiom; `projGm_isReduced` L471; `gm_geomIrred` L442)
- **bad practices**: 1 (the LAUNDERING pattern — see flagged-issues block)
- **excuse-comments**: 2 (TEMP axiom docstrings)
- **notes**:
  - L177-200 axiom `gmScalingP1_chart_data_temp`: KNOWN per directive (iter-181 RETIRE-OR-ESCALATE deadline). The docstring is explicit ("**TEMPORARY AXIOM (iter-177 HARD STOP corrective)**"). Still requires must-fix listing per "Excuse-comments are red flags" rule.
  - L321-339 axiom `gmScalingP1_collapse_at_zero_temp`: same pattern.
  - **NEW iter-179 LAUNDERING SITE detected**: L213-250 `gmScalingP1_chart_PLB_eq` is a partial proof that introduces real rewrites (`change`/`rw [h, ...]`) then sorries the residual. This is HONEST partial work, not laundering. ✓
  - However L266-280 `gmScalingP1_chart_agreement` body is `exact (gmScalingP1_chart_data_temp kbar).2` — i.e. it consumes the 2nd conjunct of the TEMP axiom verbatim. This is LAUNDERING: the lemma's stated content is the cocycle agreement on `gmScalingP1_chart`, but the proof simply pulls it from a stand-in axiom. Same for L358-364 `gmScalingP1_collapse_at_zero`. **Both are documented as such in the file (no hidden laundering).**
  - L387-432 `projectiveLineBar_isReduced`: real heavy proof. Closed.

### AlgebraicJacobian/Genus0BaseObjects/Points.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 (`gm_grpObj` L251)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L251 `gm_grpObj : GrpObj (Gm kbar) := sorry`. LOAD-BEARING (consumed by the entire iter-166 `morphism_P1_to_grpScheme_const_aux`). Docstring documents this as a "scaffold body".
  - All k̄-point constructions (`zeroPt`, `onePt`, `inftyPt`) closed kernel-clean via `pointOfVec`.
  - Genuine `IsReduced`, `IsAffine`, `IsDomain`, `IrreducibleSpace` instances all real.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: 1 (`positiveGenusWitness` L270)
- **dead-end proofs**: 3 (inner `key` sorry L236, `positiveGenusWitness` L274, `genusZeroWitness` propagates upstream sorryAx)
- **bad practices**: 0
- **excuse-comments**: none
- **notes**:
  - L236 inner `key : f = toUnit C ≫ η[A] := by sorry` inside `genusZeroWitness`'s `isAlbaneseFor` field: the pullback-and-descent step from k̄ down to k. Documented honestly.
  - L274 `positiveGenusWitness ... := sorry` — top-level typed sorry returning a `JacobianWitness`. Documented as M3 work (off-critical-path per STRATEGY.md).
  - `nonempty_jacobianWitness` (L300) is now a real proof by case-split on genus, delegating to the two scaffolds. Real structural progress (no inline sorry).

### AlgebraicJacobian/Picard/FGAPicRepresentability.lean
- **outdated comments**: none
- **suspect definitions**: 3 (TYPE-LEVEL sorry on `picSharp` L132, TYPE-LEVEL sorry on `divFunctor` L147, body sorry on `PicScheme` L187)
- **dead-end proofs**: 5 (`PicScheme` L187, `abelMap` L226, `smoothProperQuotient` L278, `representable` L324, `groupSchemeStructure` L363)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L132-135 `picSharp ... : (Over (Spec (.of k)))ᵒᵖ ⥤ Type u := sorry` — **TYPE-LEVEL `sorry` for a forward-reference placeholder**. The docstring documents this as a "typed `sorry` carrier" intended to collapse to a one-line re-export once `RelPicFunctor.lean` lands. This is the project's "file-internal placeholder" pattern but it produces a `Functor` whose body is undefined. Honest acknowledgment, but downstream consumers (`abelMap`, `representable`) reference this as if it were a real functor.
  - Same pattern at L147 `divFunctor`.
  - All 5 pinned declarations are `sorry`-bodied. Honest scaffold.

### AlgebraicJacobian/Picard/FlatteningStratification.lean
- **outdated comments**: none
- **suspect definitions**: none (predicates and theorem signatures all substantive)
- **dead-end proofs**: 7 (`genericFlatness` L208, `flatLocusStratification` L252, `flatLocusReduction` L280, `flatLocusAssembly` L310, `flatteningStratification` L358, `flatteningStratification_universal` L399, `flatteningStratification.ofCurve` L438)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `CoherentSheafFlat` (L170) is a substantive `Prop`-quantifier, real content.
  - The 7 typed sorries all have substantive existential/conjunction types. No laundering.

### AlgebraicJacobian/Picard/LineBundlePullback.lean
- **outdated comments**: none
- **suspect definitions**: 2 (TYPE-LEVEL sorry on `OnProduct` L119; type-level body sorry on `preimage_subgroup` L261)
- **dead-end proofs**: 3 (`pullbackAlongProjection` L150, `pullback_pullback_eq` L204, `functorial` L309)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L119-121 `OnProduct ... : Type (u+1) := sorry` — **TYPE-LEVEL `sorry`**. The docstring at L93-101 acknowledges this is a typed-`sorry` carrier pending Mathlib `IsInvertible` on `Scheme.Modules`. **This taints ALL downstream `OnProduct`-using declarations in this file and in `RelPicFunctor.lean` `PicSharp`**. Honest acknowledgment but real type-level gap.
  - L261-264 `preimage_subgroup ... : Setoid (LineBundle.OnProduct πC πT) := sorry` — its target type `Setoid (typeWithSorryBody)` inherits the cascade.

### AlgebraicJacobian/Picard/QuotScheme.lean
- **outdated comments**: none
- **suspect definitions**: 3 (`hilbertPolynomial` L170, `QuotFunctor` L208, `Grassmannian` L245 — all typed-sorry data defs)
- **dead-end proofs**: 5 (the three above plus `Grassmannian.representable` L272, `QuotScheme` L326, `canonicalBaseChangeMap_app_app_isIso` L447)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `canonicalBaseChangeMap` (L409) is a real categorical construction via the `mateEquiv` machinery — closed cleanly.
  - `canonicalBaseChangeMap_isIso` (L482) and `flatBaseChangeCohomology` (L491) build on the `_app_app_isIso` helper (typed sorry).

### AlgebraicJacobian/Picard/RelPicFunctor.lean
- **outdated comments**: none
- **suspect definitions**: 2 (`PicSharp` L284, `presheaf` L370 — both `(Over (Spec (.of k)))ᵒᵖ ⥤ AddCommGrpCat := sorry`)
- **dead-end proofs**: 5 (`addCommGroup` L205, `PicSharp` L284, `functorial` L323, `presheaf` L370, `etSheaf` L429, `etSheafUnit` L478)
- **bad practices**: 1 (L235 uses `exact sorry` — semantically identical to `:= sorry` but inconsistent with the rest of the project's style)
- **excuse-comments**: none
- **notes**:
  - All bodies inherit the `OnProduct` type-level sorry from `LineBundlePullback.lean`.
  - L205 `addCommGroup` instance with very long inline `TODO (A.1.b gate)` block — documents the gate clearly. The instance body is `exact sorry` rather than the more idiomatic `:= sorry` form.

### AlgebraicJacobian/Picard/RelativeSpec.lean
- **outdated comments**: none (iter-179 Block A docstring update is accurate)
- **suspect definitions**: 1 (`QcohAlgebra.pullback`'s `coequifibered` field at L236 is `sorry`)
- **dead-end proofs**: 2 (`QcohAlgebra.pullback` coequifibered L236; `pullback_iso` L353; the `functor` def at L395-397 is real)
- **bad practices**: 1 (L322 dead-`have` — `have h : IsAffineHom (RelativeSpec.structureMorphism 𝒜) := UniversalProperty 𝒜` is bound but never explicitly used in the following `exact isAffine_of_isAffineHom (RelativeSpec.structureMorphism 𝒜)`; if `isAffine_of_isAffineHom` needs `[IsAffineHom]` as instance, `have` should be `haveI`. If build is green this is dead code; otherwise the proof is broken.)
- **excuse-comments**: none
- **notes**:
  - **MAJOR PROGRESS**: `RelativeSpec` (L192) and `RelativeSpec.structureMorphism` (L208) are now real Mathlib-backed values, NOT typed sorries. The auditor-177 "weakened-wrong placeholder" finding is RESOLVED.
  - `UniversalProperty` (L269): real multi-step proof (`apply isAffineHom_of_forall_exists_isAffineOpen` + open extraction + the `key` rewrite). Substantive.
  - `affine_base_iff` (L316): if it builds (see bad-practices note above), then it's real.
  - L229-236 helper `QcohAlgebra.pullback`: the `sheaf` and `unit` fields are concrete (push-forward + sheaf-c map); only `coequifibered := sorry` remains. Substantive Mathlib-pending claim. **Verified the helper type is substantive.**
  - L353-357 `pullback_iso : Nonempty (... ≅ ...) := sorry`. Substantive existential.
  - L367-371 `base_change`: closed via the helpers — no inline sorry. Real one-liner. ✓

### AlgebraicJacobian/RiemannRoch/OCofP.lean
- **outdated comments**: none
- **suspect definitions**: 1 (`lineBundleAtClosedPoint` L140 returns a `Sheaf` of `ModuleCat k̄`, body `:= sorry`)
- **dead-end proofs**: 5 (`lineBundleAtClosedPoint`, `globalSections_iff` L192, `h1_vanishing_genusZero` L242, `dim_eq_two_of_genusZero` L277, `exists_nonconstant_genusZero` L326)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All declarations honest skeletons; types are substantive (e.g. `(0 : ℤ) ≤ Scheme.RationalMap.order ⟨P, hPcoh⟩ f ∧ Scheme.WeilDivisor.principal (X := C.left) f hf ≠ 0`).

### AlgebraicJacobian/RiemannRoch/RRFormula.lean
- **outdated comments**: none
- **suspect definitions**: 1 (`WeilDivisor.sheafOf` L168 — placeholder for RR.3)
- **dead-end proofs**: 3 (`sheafOf` L168, `eulerCharacteristic_eq_degree_plus_one_minus_genus` L224, `l_eq_degree_plus_one_of_genus_zero` L253)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Scheme.eulerCharacteristic` (L124) is a real concrete one-liner. Good.
  - `WeilDivisor.l` (L192) is concrete; relies on the `sheafOf` typed sorry.

### AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 (`morphism_degree_via_pole_divisor` L296, `iso_of_degree_one` L356)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L204-243 `morphismToP1OfGlobalSections`: BODY CLOSED iter-179. New `_halg` hypothesis at L208-210 is a substantive `kbar`-algebra compatibility witness; it is **consumed at L236-239** via the `hcc` step (`rw [← MvPolynomial.algebraMap_eq, _halg, ...]`). **`_halg` is non-trivial: the body would not close without it.** ✓
  - L296, L356 typed sorries on substantive existentials. Honest. **AUDITOR 178A (section-condition gap) ADDRESSED.**

### AlgebraicJacobian/RiemannRoch/WeilDivisor.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 (`rationalMap_order_finite_support` L205, `principal_degree_zero` L407 — but iter-178 partial body landed at L420-441; only the non-constant branch sorries)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Scheme.PrimeDivisor` structure (L92), `Scheme.WeilDivisor` def (L105) and `AddCommGroup` instance: all clean.
  - `Scheme.RationalMap.order` (L152) closed via `WithZero.log ∘ Ring.ordFrac`. Clean.
  - `Scheme.IsRegularInCodimensionOne` class + bridge instance: real.
  - `principal_degree_zero` (L407): real `by_cases` split; constant branch closed, non-constant branch sorry (documented). Honest partial progress.
  - `principal_hom` (L345): real `MonoidHom` construction. Clean.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Scheme.Over.ext_of_eqOnOpen` (L91) is fully closed. Real lemma.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 (`rigidity_over_kbar` L75)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L75 `rigidity_over_kbar`: typed sorry. Docstring labels this as the route-(a) "fallback artifact" since the project committed to route (c) in iter-163. **NOT on the critical path** per project state.

### AlgebraicJacobian/RigidityLemma.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 900-LOC file with the entire Rigidity Lemma chain (`rigidity_lemma`, `rigidity_core`, `rigidity_eqOn_dense_open`, `rigidity_eqOn_saturated_open_to_affine`, `rigidity_eqAt_closedPoint_of_proper_into_affine`, `eq_comp_of_isAffine_of_properIntegral`, `isIntegral_of_retract`, `morphism_eq_of_eqAt_closedPoints`, `snd_left_isClosedMap`, `rigidity_snd_lift`) and the two Milne corollaries (`hom_additive_decomp_of_rigidity`, `av_regularMap_isHom_of_zero`) — all PROVEN axiom-clean iter-162.

## Must-fix-this-iter

Apply verbatim. Every one of the following lands here automatically.

- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:193` — `axiom gmScalingP1_chart_data_temp ... : (∀ i, ...) ∧ (∀ x y, ...)`. Why must-fix: an **explicitly-named axiom** is being introduced to discharge a substantive geometric obligation (chart cocycle + over-coherence). Per the project's `archon-protected.yaml` invariants this is acceptable only as a TEMPORARY workaround; the iter-181 RETIRE-OR-ESCALATE deadline is upcoming per the directive. **KNOWN per directive** — flagging for visibility, not as a new finding.
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:336` — `axiom gmScalingP1_collapse_at_zero_temp ...`. Why must-fix: same pattern as above (the load-bearing `σ_×(0, λ) = 0` collapse, consumed by `AbelianVarietyRigidity.lean`'s `hcollapse` step). **KNOWN per directive.**
- `AlgebraicJacobian/Picard/LineBundlePullback.lean:119-121` — `noncomputable def OnProduct ... : Type (u+1) := sorry`. Why must-fix: a **TYPE-LEVEL `sorry`** on the central carrier of the line-bundle pullback chapter. Every downstream pin in this file AND in `RelPicFunctor.lean` (`addCommGroup`, `PicSharp`, `functorial`, `presheaf`, `etSheaf`) is built against a type whose definition is sorry — the types are not well-defined in the kernel sense. Docstring acknowledges this; nonetheless it is the project's most significant type-level laundering site at present.
- `AlgebraicJacobian/Picard/FGAPicRepresentability.lean:132-150` — TWO type-level `sorry`s on `picSharp` and `divFunctor` (both forward-reference placeholders). Why must-fix: same kind of type-level laundering as `OnProduct` — these are functors whose object-level data is `sorry`, but they appear in the signatures of `abelMap`, `representable` as if they were real.

(All four entries above are KNOWN/documented in the source. The directive declared the two `*_temp` axioms as "already known"; I list them per the auditor's standing rule that excuse-comments / TEMP axioms are flagged at must-fix severity regardless. The two `Picard/*` type-level sorries are the project's longest-standing structural debt and warrant the same severity bar.)

## Major

- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:280` — `gmScalingP1_chart_agreement` body is `exact (gmScalingP1_chart_data_temp kbar).2`. Laundering pattern: the lemma's stated content is the cocycle agreement, but the proof simply pulls the conjunct from a stand-in axiom. Same applies to L364 `gmScalingP1_collapse_at_zero` (wraps `gmScalingP1_collapse_at_zero_temp`). Documented openly in source; flagged so reviewers can track the laundering chain.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:322` — `have h : IsAffineHom (RelativeSpec.structureMorphism 𝒜) := UniversalProperty 𝒜` is bound but not explicitly re-used in the next line `exact isAffine_of_isAffineHom (RelativeSpec.structureMorphism 𝒜)`. If `isAffine_of_isAffineHom` needs `[IsAffineHom]` as instance, this needs `haveI`; if it takes the term explicitly, then `h` should be passed. **Possibly dead `have`** — either the build is green by some routing I don't see, or the proof is silently broken. Requires verification via `lake build` (not run during this audit).
- `AlgebraicJacobian/Picard/RelPicFunctor.lean:235` — `exact sorry` (rather than `:= sorry`). Minor stylistic inconsistency with rest of project; works semantically but `:= sorry` is the project convention.

## Minor

- `AlgebraicJacobian/AbelJacobi.lean:14-28` — status block referencing "iteration 073 — Phase E" is stale (project is on iter-179, route C). Content of the projection scheme is still accurate.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:20-34` — iter-145/146 historical NOTE blocks. Could be retired now that the underlying imports are stable.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:552-560,624-629` — "iter-145 EXCISE" comments document removed declarations. Standard cleanup hygiene; not actively misleading.
- `AlgebraicJacobian/AbelJacobi.lean:22` — long-line style warning (per directive: skip).

## Excuse-comments (always called out separately)

The following two `axiom` declarations are project-known TEMP axioms with explicit "**TEMPORARY AXIOM**" / "TODO" markers in their docstrings. They are documented in the project memory (`MEMORY.md` notes iter-181 RETIRE-OR-ESCALATE deadline) and are listed here per the auditor's standing rule that excuse-language is a red flag regardless of project context:

- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:177-200`: "**TEMPORARY AXIOM (iter-177 HARD STOP corrective)** — chart-bridge data. ... TODO (iter-178+): replace by chart-bridge body when ...". Attached to `gmScalingP1_chart_data_temp`, load-bearing for `gmScalingP1` construction. Severity: critical.
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:327-339`: "**TEMPORARY AXIOM (iter-177 HARD STOP corrective)** — the load-bearing fixed-point property of `σ_×`. ... TODO (iter-178+): replace by chart-1 ring-map computation once the chart-bridge body lands.". Attached to `gmScalingP1_collapse_at_zero_temp`, load-bearing for `morphism_P1_to_grpScheme_const_aux`. Severity: critical.

Plus the project-wide pattern of "iter-NNN+ work" markers throughout file-skeleton chapters (`Picard/*`, `RiemannRoch/*`, `Albanese/*`, `OCofP.lean`) — these are scheduled-future markers attached to typed-`sorry` skeletons rather than excuse comments per se, and the project's file-skeleton workflow legitimates them. Not separately listed.

## Severity summary

- **must-fix-this-iter**: 4 — two TEMP axioms (KNOWN per directive; iter-181 deadline) + two type-level `sorry` cascades on `LineBundlePullback.OnProduct` and `FGAPicRepresentability.{picSharp,divFunctor}`.
- **major**: 3 — laundering pattern in `GmScaling.lean` (KNOWN; same axiom chain), possible dead `have h` in `RelativeSpec.lean:322` (verify-via-build), and `exact sorry` style hit.
- **minor**: 4 — stale `Phase E` block in AbelJacobi, stale iter-145/146 notes in ChartAlgebra/GrpObj, long-line warning.
- **excuse-comments**: 2 (counted under must-fix-this-iter above; called out separately because they document the project lying to itself).

Overall verdict: iter-179 is a strong iteration of substantive structural progress — `RelativeSpec.{UniversalProperty,affine_base_iff,structureMorphism}` upgraded from typed-sorry placeholders to real Mathlib-backed values, `morphismToP1OfGlobalSections` body landed with substantive `_halg` hypothesis, `extend_to_av` body assembled honestly, Path D2 honest fallback for `mem_domain_iff_exists_partialMap_through_point` applied as auditor-178B requested, AuslanderBuchsbaum docstring drift cleared — but the file-skeleton type-level sorries in `Picard/{LineBundlePullback,FGAPicRepresentability}` and the still-live TEMP axioms in `GmScaling.lean` remain the project's most significant structural debt and should NOT extend past their stated retirement deadlines.
