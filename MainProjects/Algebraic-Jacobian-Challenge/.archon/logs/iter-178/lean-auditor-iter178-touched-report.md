# Lean Audit Report

## Slug
iter178-touched

## Iteration
178

## Scope
- files audited: 38 (all `.lean` under the project tree)
- files skipped (per directive): 0

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure import root.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L14: "Status (iteration 073 — Phase E closes by reduction)" — stale (iter-073 vs current iter-178). Phase-E narrative still accurate but the iter tag is 105 iters old.

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: 4 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L86-120 `iotaGm_isDominant`: iter-178 partial — `by` block reduces to `DenseRange`, then `sorry`. Honest, gap is documented (chart-bridge consult `gmscaling-cover-bridge`).
  - L136 "Status (iter-167)" on `morphism_P1_to_grpScheme_const_aux`: stale (iter-167 vs 178). Body is the iter-167 work but the status block does not reflect 11 iters of intervening discharge work.
  - L276 "Status (iter-166)" on `morphism_P1_to_grpScheme_const`: stale.
  - L319-320 "Status (iter-166)" on `genusZero_curve_iso_P1`: stale.
  - L342-345 "Status (iter-166)" on `rigidity_genus0_curve_to_grpScheme`: stale.
  - Body of `rigidity_genus0_curve_to_grpScheme` (L358-383) is a real, substantive proof.

### AlgebraicJacobian/Albanese/AlbaneseUP.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: 1 flagged (CRITICAL)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 1 flagged
- **notes**:
  - L36 "Status (iter-177 Lane 7 file-skeleton)": one iter behind, acceptable.
  - L179-183: `Pic0.bundle : Bundle C := sorry` — load-bearing structure sorry. The docstring at L179-183 self-labels as "**placeholder carrier** ... a typed `sorry`". This single sorry propagates through 4 derived instances (`instGrpObj`, `instIsProper`, `instSmooth`, `instGeomIrred`) and through `jacobianScheme := (bundle C).scheme`. Marked CRITICAL because it weakens four typeclass instances simultaneously, all of which are downstream-consumer-facing.
  - L240-242 `abelJacobi`, L287-292 `SymmetricPower`, L322-327 `symmetricPowerAVMap`, L362-365 `symmetricPowerToJacobian`, L401-409 `descentThroughBirationalSigma`, L466-473 `albanese_universal_property`: all honest scaffold sorries with substantive types.

### AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean
- **outdated comments**: 2 flagged (MAJOR)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L130-132 `depth := sorry`, L210-219 `depth_eq_smallest_ext_index := sorry`, L250-268 `depth_of_short_exact := sorry`, L308-316 `auslander_buchsbaum_formula := sorry`, L378-381 `CohenMacaulay.of_regular := sorry`: all honest Mathlib-gap scaffold sorries with substantive types.
  - L168-170 `projectiveDimension`: iter-178 Lane 7 filled the body to `CategoryTheory.projectiveDimension (ModuleCat.of R _M)`. The body is non-tautological and matches the docstring intent.
  - **L165-167 STALE DOCSTRING** (MAJOR): the doc-block on `projectiveDimension` still says *"For the iter-175 file-skeleton the body is a typed `sorry` — the wrapper is genuinely a one-liner once the universe / abbreviation choices are settled, but we leave it as a typed `sorry` to keep the file-skeleton uniform."* The body is NOT `sorry` anymore. This is documentation drift that misleads a reader scanning the file.
  - L33-92 module-level status block claims "iter-175 Lane F file-skeleton" and lists the body as `sorry`. After iter-178's Lane 7 fill, item 3's status is stale.

### AlgebraicJacobian/Albanese/CodimOneExtension.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: 1 flagged (CRITICAL — type/proof mismatch)
- **dead-end proofs**: none
- **bad practices**: 1 flagged
- **excuse-comments**: none
- **notes**:
  - L34 "Status (iter-177 Lane 6 file-skeleton)": one iter behind, acceptable.
  - L194-203 `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`: new private helper iter-178; substantive type (principal + nonzero maximal ideal); body `sorry`; docstring honestly admits "substantive Mathlib gap (commit `b80f227` only ships the definition `IsRegularLocalRing`, not the smooth-scheme bridge); we package the conclusion locally as a single helper sorry." Non-tautological, OK.
  - L219-248 `localRing_dvr_of_codim_one`: real body delegating to the helper above. Uses `LocallyOfFiniteType.isLocallyNoetherian`, `IsDiscreteValuationRing.TFAE`. Axiom-clean modulo helper.
  - **L391-406 `extend_iff_order_nonneg` (CRITICAL — weakened-wrong-by-shallowness)**: the body is a 2-line proof via `Scheme.RationalMap.mem_domain` + existential shuffle. The hypothesis `[Ring.KrullDimLE 1 (X.left.presheaf.stalk W.point)]` is bound but **unused** by the proof (compiler does not need it; it would discharge without it). The docstring (L359-389) claims the substantive Hartshorne II.6 "regular = no pole" valuative-criterion content connecting `f.domain` to `Scheme.RationalMap.order`. **The actual statement does not mention `order` anywhere**: it is essentially `mem_domain` reshuffled. Either the type is too shallow for the claimed content (the docstring is selling content the type doesn't bear), or the unused KrullDimLE binder is a red flag indicating an intended refinement was abandoned. Recommend revisiting the signature.
  - L300 `extend_of_codimOneFree_of_smooth := sorry`, L343 `indeterminacy_pure_codim_one_into_grpScheme := sorry`: honest scaffold sorries.

### AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L31 "Status (iter-175 Lane J file-skeleton)": 3 iters behind.
  - L162-173 `extend_to_av := by sorry`: honest scaffold, substantive type, no laundering.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Comprehensive iter-016 → iter-026 chain, all real proofs. No suspect findings.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All declarations have real bodies. `HasAffineCechAcyclicCover` is a `Prop` class — its consumer-instance `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` (L699-709) closes axiom-clean modulo the typeclass hypothesis (no producer in tree yet).

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single instance, 5-line body, real proof.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All three declarations honestly closed.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Re-export shim with import-only body.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Real proofs throughout. Iter-037 → iter-053 chain.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Real proofs (iter-046 Mathlib gap-fills for `Adjunction.left_adjoint_linear` / `right_adjoint_linear` / `homLinearEquiv`).

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/SheafProperty.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Real proofs.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All declarations have real bodies (`KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`, `constants_integral_over_base_field`, `algebra_isPushout_of_affine_product`, `df_zero_factors_through_constant_on_chart`, `ext_of_diff_zero`).

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 1 flagged (MINOR)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L433-435 (`Status: Step 3 closed iter-136 (no sorry); Step 2 PARTIAL iter-137 (body remains sorry...)`) — stale narrative; iter-145 EXCISE comments at L552-560 and L624-629 indicate the iter-138+ targets were *removed*. The "still sorry" framing of L433-435 / L483-488 is contradicted by the iter-145 excise. Documentation drift.
  - No actual `sorry` bodies in this file (grep confirms).

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Real proofs.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 1-line definition, real, well-documented.

### AlgebraicJacobian/Genus0BaseObjects.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure re-export shim.

### AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L156 `projectiveLineBar_geomIrred := sorry`, L163 `projectiveLineBar_smoothOfRelDim := sorry`: honest scaffold sorries with substantive types (Mathlib gap, "plan-marked acceptable for iter-165").
  - `projectiveLineBar_isProper` and `projectiveLineBarAffineCover` are real proofs.

### AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All declarations have real bodies. The iter-172 surjectivity helper `mvPolyToHomogeneousLocalizationAway_surjective` is a substantive ~140-LOC proof; round-trips closed via cancellation.

### AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean
- **outdated comments**: none
- **suspect definitions**: 2 flagged (CRITICAL — see Carry-over below)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 2 flagged (CRITICAL)
- **notes**:
  - **L212-219 `axiom gmScalingP1_chart_data_temp`** (CRITICAL — carry-over per directive):
    - Self-labeled "**TEMPORARY AXIOM (iter-177 HARD STOP corrective)**" with explicit `TODO (iter-178+): replace by chart-bridge body when ...`.
    - Load-bearing for `gmScalingP1_chart_PLB_eq` (L232) and `gmScalingP1_chart_agreement` (L246), both of which discharge their bodies via this axiom.
    - Carry-over from iter-177; directive instructs "track only — do NOT reopen". STRATEGY.md iter-181 RETIRE-OR-ESCALATE trigger live.
  - **L308-311 `axiom gmScalingP1_collapse_at_zero_temp`** (CRITICAL — carry-over):
    - Self-labeled "**TEMPORARY AXIOM (iter-177 HARD STOP corrective)**" with explicit `TODO (iter-178+): replace by chart-1 ring-map computation once the chart-bridge body lands`.
    - Discharges `gmScalingP1_collapse_at_zero` (L323), which is the load-bearing fixed-point input that powers `morphism_P1_to_grpScheme_const_aux` (the entire Route C base case).
  - L405 `gm_geomIrred := sorry`, L437 `projGm_isReduced := sorry`: honest scaffold sorries for Mathlib gaps.
  - Both TEMP axioms qualify under the must-fix-this-iter bar (axiom + excuse-comment + load-bearing), but per directive scope they are CARRY-OVER and tracked-only.

### AlgebraicJacobian/Genus0BaseObjects/Points.lean
- **outdated comments**: none
- **suspect definitions**: 1 flagged (CRITICAL — load-bearing instance sorry)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L251 `instance gm_grpObj := sorry`** (CRITICAL): load-bearing instance sorry. The docstring documents the intended `GrpObj.ofRepresentableBy`-via-units-functor construction but the body is bare `sorry`. This instance feeds `gm_smooth` (L255-258) which feeds Route C's whole `morphism_P1_to_grpScheme_const` chain. Per memory escalation watch was 3-iter deferred at iter-167; that's now ~11 iters stale.
  - All three k̄-point definitions (`zeroPt`, `onePt`, `inftyPt`) have real bodies via `pointOfVec`.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L193 "Status (iter-172)" on `genusZeroWitness`: stale.
  - L235-236 `key := by sorry`: honest scaffold for the k → k̄ descent gap.
  - L270-274 `positiveGenusWitness := sorry`: honest scaffold, M3 off-critical-path.
  - `nonempty_jacobianWitness` real proof.

### AlgebraicJacobian/Picard/FGAPicRepresentability.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: 2 flagged (file-internal placeholders)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File-skeleton with 8 honest scaffold sorries on substantive types.
  - L132-135 `picSharp := sorry`, L147-150 `divFunctor := sorry`: typed-sorry "file-internal placeholders" for forward references. Honest about the dependency on sibling chapters not yet landed.
  - "iter-176 file-skeleton" status block — 2 iters behind.

### AlgebraicJacobian/Picard/FlatteningStratification.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 8 honest scaffold sorries with substantive types.

### AlgebraicJacobian/Picard/LineBundlePullback.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: 1 flagged (typed `sorry` at the type level)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L119-121 `OnProduct := sorry`: **typed `sorry` at the TYPE level** (not just body). Returns `Type (u+1)` with body `sorry`. The docstring at L116-118 honestly admits "Mathlib `b80f227` ships no `IsInvertible` predicate on `Scheme.Modules`". This is the type-level placeholder pattern; downstream signatures referencing `OnProduct` (e.g. `pullbackAlongProjection`) inherit the unboundedness. NOTE: type-level sorries are a known weakening pattern — they make all downstream signatures trivially inhabitable.
  - 4 other honest scaffold sorries.
  - "iter-174 file-skeleton" status block — 4 iters behind.

### AlgebraicJacobian/Picard/QuotScheme.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - "iter-176 Lane H file-skeleton" status block — 2 iters behind.
  - L170-173 `hilbertPolynomial`, L208-212 `QuotFunctor`, L245-248 `Grassmannian`: honest scaffold typed sorries.
  - L272-275 `Grassmannian.representable := by sorry`, L326-330 `QuotScheme := by sorry`: honest, substantive types.
  - L447-469 **new helper `canonicalBaseChangeMap_app_app_isIso := by sorry`** (iter-178 Lane 6): substantive Stacks 02KH(ii) content, honest scaffold. Type is non-tautological.
  - L482-489 `canonicalBaseChangeMap_isIso` body now structural via `Hom.isIso_iff_isIso_app` delegating to the helper. Sound iter-178 refactor.
  - L491-502 `flatBaseChangeCohomology` body wraps `canonicalBaseChangeMap_isIso` via `asIso`. Sound.
  - The new helper retains the Mathlib-gap content honestly; not a placeholder.

### AlgebraicJacobian/Picard/RelPicFunctor.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 5 honest scaffold sorries with substantive types.
  - Status block "iter-176 file-skeleton" — 2 iters behind.

### AlgebraicJacobian/Picard/RelativeSpec.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: 2 flagged (CRITICAL — see Carry-over below)
- **dead-end proofs**: 3 flagged (CRITICAL — proofs trivialize because bodies are placeholders)
- **bad practices**: 1 flagged
- **excuse-comments**: none (the comments are explanatory, not TODO-style)
- **notes**:
  - **L172-173 `noncomputable def RelativeSpec _𝒜 := X`** (CRITICAL — carry-over): the relative spectrum of a quasi-coherent sheaf of algebras is set to **the base scheme itself**. This is a weakened-wrong definition by the most extreme measure — the docstring at L156-171 self-labels as "the simplest valid inhabitant `X` itself, matching the *placeholder-with-substantive-downstream-type* pattern".
  - **L192-194 `noncomputable def RelativeSpec.structureMorphism _𝒜 := 𝟙 X`** (CRITICAL — carry-over): paired placeholder; structure morphism `π : Spec_X(𝒜) → X` set to the identity.
  - **L227-237 `UniversalProperty := by ...; exact (inferInstance : IsAffineHom (𝟙 X))`** (dead-end-by-trivialization): the "proof" works precisely because the structure morphism is `𝟙 X`. Comment at L229-235 honestly admits this collapse.
  - **L259-267 `affine_base_iff := by change IsAffine (Spec R); infer_instance`** (dead-end-by-trivialization).
  - **L295-311 `base_change := by refine ⟨⟨T.sheaf, 𝟙 _⟩, ⟨?_⟩⟩; ...; exact asIso (pullback.fst g (𝟙 X))`** (dead-end-by-trivialization).
  - Per directive: track only — do NOT reopen. Flagged CRITICAL iter-176 by prior auditor.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Real, well-documented proof. The hypothesis history block (L43-78) is genuine documentation, not stale narrative.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: 1 flagged (off-path artifact with bare sorry)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L20-29 "Status (iter-126 scaffold) ... gated on ... iter-129+" — stale by ~50 iters. Memory notes that this file is now the route (a) fallback artifact after route (c) was committed iter-163.
  - L88 `rigidity_over_kbar := sorry`: bare sorry on a substantive type. Per memory it's the off-path fallback artifact and not on the critical path. Could be excised entirely or kept with a "DEMOTED: off critical path; route (c) is `rigidity_genus0_curve_to_grpScheme`" status correction.

### AlgebraicJacobian/RigidityLemma.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 9 axiom-clean, well-documented proofs (Rigidity Lemma chain + Milne Cor 1.5 + Cor 1.2). The "Status (iter-162): PROVEN axiom-clean" status markers are accurate.

### AlgebraicJacobian/RiemannRoch/OCofP.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L35-44 "iter-176 Lane K file-skeleton" status block — 2 iters behind.
  - L156-157 **new namespace variable binders** `[IsLocallyNoetherian C.left]` and `[Scheme.IsRegularInCodimensionOne C.left]` (iter-178 Lane 1 PRIMARY MUST-FIX): bind to `globalSections_iff` (L192), `h1_vanishing_genusZero` (L242), `dim_eq_two_of_genusZero` (L277), `exists_nonconstant_genusZero` (L326). All four genuinely consume the regular-in-codim-1 stalks-are-DVR property (via `Scheme.RationalMap.order`), so the binder is real-needed.
  - Verified: `lineBundleAtClosedPoint` itself is declared BEFORE `namespace lineBundleAtClosedPoint` (L140-148) and does NOT receive the new binders. No leak to unrelated declarations.
  - 5 honest scaffold sorries with substantive types.

### AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: 1 flagged (CRITICAL — type insufficient for body)
- **dead-end proofs**: none
- **bad practices**: 1 flagged
- **excuse-comments**: 1 flagged (CRITICAL)
- **notes**:
  - "iter-177 Lane 8 file-skeleton" status block — 1 iter behind.
  - L356-369 `iso_of_degree_one`: iter-178 Lane 5 Part A signature change from Type-iso to ring iso (`Nonempty (C'.left.functionField ≃+* C.left.functionField)`) — confirmed at L366-367. Real signature mutation, honest scaffold sorry.
  - **L198-243 `morphismToP1OfGlobalSections` (CRITICAL — type insufficient for body)**: body has the concrete `Over.homMk (Proj.fromOfGlobalSections (projectiveLineBarGrading kbar) f _hf) <| by ...` form per the directive (NOT `Iso.refl _` or bare `sorry`). The tactic body sets up `IsScalarTower`, applies `Proj.fromOfGlobalSections_toSpecZero`, then **`sorry` at L243**.
  - **L226-243 EXCUSE-COMMENT** (CRITICAL severity): the inline comment block at L226-243 explicitly says: *"The current signature does *not* encode this `kbar`-algebra hypothesis on `f`, so the section condition is not derivable. iter-179+ proper closure adds the missing `kbar`-algebra hypothesis to the signature ..."*. This is a confession that the declaration as typed is INSUFFICIENT to construct the claimed morphism — the body would silently succeed via `sorry` on inputs `f` that are NOT `kbar`-algebra maps. This is the textbook weakened-wrong-by-missing-hypothesis pattern. The "current signature does not encode" admission is exactly the kind of excuse comment the audit playbook flags as critical. The Part B task_result's "residual sorry mathematically undischargeable from current signature" claim matches what is on file.
  - L266-306 `morphism_degree_via_pole_divisor := sorry`, L356-369 `iso_of_degree_one := sorry`: honest scaffold sorries.

### AlgebraicJacobian/RiemannRoch/RRFormula.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 3 honest scaffold sorries: `sheafOf` (L168-171, typed sheaf placeholder), `eulerCharacteristic_eq_degree_plus_one_minus_genus` (L224-232), `l_eq_degree_plus_one_of_genus_zero` (L253-264).

### AlgebraicJacobian/RiemannRoch/WeilDivisor.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L26 "Status (iter-172 file-skeleton)" — 6 iters behind.
  - L205-210 `rationalMap_order_finite_support := by sorry`: honest Mathlib-gap scaffold (Hartshorne II.6.1 / Stacks 02RV).
  - L407-442 `principal_degree_zero` (iter-178 Lane 3): case-split on `(∀ Y, ord_Y f = 0)`. Constant branch fully discharged via `Finsupp.ext` + `degree`-unfold + `Finsupp.sum_zero_index` (axiom-clean). Non-constant branch L442 `sorry` honestly gated on Lane 5 + Mathlib II.6.9 multiplicativity-of-degree gap. Sound real partial.
  - Other declarations (`order`, `degree`, `degree_hom`, `degree_hom_apply`, `ofClosedPoint`, `ofClosedPoint_eq_single`, `ofClosedPoint_eq_zero`, `principal`, `principal_hom`, `LinearEquivalence`) all have real bodies.

## Must-fix-this-iter

Apply verbatim. Every one of the following lands here automatically.

- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:165-167` — Docstring of `projectiveDimension` still claims "For the iter-175 file-skeleton the body is a typed `sorry`" but the body is now the real `CategoryTheory.projectiveDimension (ModuleCat.of R _M)` from iter-178 Lane 7. Why must-fix: stale docstring that contradicts current code is the seed of "wrong workflow narrative hardens into project memory"; update the docstring to reflect the actual body.

- `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean:226-243` — `morphismToP1OfGlobalSections` body's inline comment block is an EXCUSE-COMMENT confessing the signature is mathematically insufficient ("current signature does *not* encode this `kbar`-algebra hypothesis on `f`, so the section condition is not derivable. iter-179+ proper closure adds the missing `kbar`-algebra hypothesis to the signature"). Why must-fix: this is the canonical weakened-wrong-by-missing-hypothesis pattern — the function ostensibly constructs a morphism for any `f` satisfying the typed precondition, but the section-condition obligation is undischargeable from those preconditions, so the `sorry` would silently accept inputs for which no such morphism exists. The signature must be tightened (add the `kbar`-algebra hypothesis) BEFORE the body is allowed to keep its `sorry`, otherwise any downstream consumer is consuming a fictitious morphism. Either add the missing hypothesis now or revert the body to a bare typed `sorry` with no fictitious construction.

- `AlgebraicJacobian/Albanese/CodimOneExtension.lean:391-406` — `extend_iff_order_nonneg` body is a 2-line reshuffle of `Scheme.RationalMap.mem_domain`; the `[Ring.KrullDimLE 1 (X.left.presheaf.stalk W.point)]` binder is UNUSED by the proof; the docstring claims substantive Weil-divisor obstruction content (`Scheme.RationalMap.order`, valuative criterion) that the *type* does not encode. Why must-fix: either the type is too shallow for the named content (the docstring is over-selling), or the unused KrullDimLE binder marks an intended-but-abandoned refinement. The lemma name `extend_iff_order_nonneg` cannot be honest without the `order` quantity appearing in the iff. Recommend either tightening the signature to include the order-`≥0` condition or renaming/relaxing to reflect what is actually proved.

## Major

Findings that are real issues but don't meet the must-fix bar.

- `AlgebraicJacobian/AbelianVarietyRigidity.lean:136`, `:276`, `:319`, `:342` — Multiple "Status (iter-166)" / "Status (iter-167)" markers on declarations whose bodies have evolved over 11+ subsequent iterations. Update or remove.
- `AlgebraicJacobian/AbelJacobi.lean:14` — "Status (iteration 073 — Phase E closes by reduction)" — 105 iters stale tag.
- `AlgebraicJacobian/RigidityKbar.lean:20-29` — "Status (iter-126 scaffold) ... gated on iter-129+" 50 iters stale; the file is now the off-path route-(a) fallback per memory; needs a status correction documenting the demotion.
- `AlgebraicJacobian/Jacobian.lean:193` — "Status (iter-172)" on `genusZeroWitness` is 6 iters stale.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:433-435`, `:483-488` — narrative about "Step 2 PARTIAL" / "3 narrowly-scoped concrete sorries" is contradicted by the iter-145 EXCISE comments at L552-560 / L624-629 which deleted those declarations. Documentation drift; the file has NO actual `sorry` bodies now.
- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:33-92` — module-level status block claims "iter-175 Lane F file-skeleton" status and reports declaration 3 as `sorry`; iter-178 Lane 7 changed that.
- `AlgebraicJacobian/Picard/QuotScheme.lean:25-29`, `:374-385` — "iter-176 Lane H file-skeleton" / "iter-177 (Lane QS-FLAT)" status text; with iter-178's `canonicalBaseChangeMap_app_app_isIso` addition the file's status block is stale.
- `AlgebraicJacobian/Picard/LineBundlePullback.lean:115-122` — `OnProduct` returns a `Type (u+1)` with `:= sorry` *at the type level*. Type-level sorries make every downstream signature trivially inhabitable; not flagged as critical because the file-skeleton honestly documents the Mathlib gap and there is no false-claim-of-construction, but it is the most fragile pattern in the file-skeleton family.

## Minor

Low-impact observations.

- `AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean:31` — "iter-175 Lane J" 3 iters stale.
- `AlgebraicJacobian/RiemannRoch/OCofP.lean:35-44` — "iter-176 Lane K" 2 iters stale.
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:26` — "iter-172 file-skeleton" 6 iters stale.
- `AlgebraicJacobian/Picard/RelPicFunctor.lean` — "iter-176 file-skeleton" 2 iters stale.
- `AlgebraicJacobian/Picard/FGAPicRepresentability.lean` — "iter-176 file-skeleton" 2 iters stale.
- Most file-skeleton chapters: numerous declarations carry "iter-NNN+ work" forward-references in their docstrings; these are intended cross-references not stale comments — left unflagged.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:25-31` (the L93 "(gated by iter-178 chart-bridge gap)" comment in `iotaGm_isDominant`) — this is an accurate-as-of-iter-178 comment but will become a stale dating tag once chart-bridge closes; preferable to write "(blocked on chart-bridge consult `gmscaling-cover-bridge`)" without an iter number that decays.

## Excuse-comments (always called out separately)

If any excuse-comments were flagged, list each one verbatim with its file:line. These deserve special visibility because they document the project lying to itself.

- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:196-211` (axiom docstring): "**TEMPORARY AXIOM (iter-177 HARD STOP corrective)** — chart-bridge data. ... TODO (iter-178+): replace by chart-bridge body when the `(cover).f i = Proj.awayι _ X_i _ Nat.one_pos` defeq + Fin normalization is resolved ...". Attached to `gmScalingP1_chart_data_temp`, which discharges 2 load-bearing helpers in the Route C chain. Severity: critical (CARRY-OVER per directive — track only).

- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:299-307` (axiom docstring): "**TEMPORARY AXIOM (iter-177 HARD STOP corrective)** — the load-bearing fixed-point property of `σ_×`. ... TODO (iter-178+): replace by chart-1 ring-map computation once the chart-bridge body lands.". Attached to `gmScalingP1_collapse_at_zero_temp`, which discharges the load-bearing `W`-axis-collapse hypothesis consumed by Cor 1.5. Severity: critical (CARRY-OVER per directive — track only).

- `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean:226-243` (inline comment in body): "The current signature does *not* encode this `kbar`-algebra hypothesis on `f`, so the section condition is not derivable. iter-179+ proper closure adds the missing `kbar`-algebra hypothesis to the signature (a one-line ... argument); under that hypothesis the chain mirrors the closed pointOfVec proof verbatim ...". Attached to `morphismToP1OfGlobalSections`, which is a load-bearing morphism-construction definition. Severity: critical (NEW iter-178; must-fix-this-iter).

## Severity summary

- **must-fix-this-iter**: 3 — these block downstream work in their files until addressed.
- **major**: 9
- **minor**: 6
- **excuse-comments**: 3 (also counted under must-fix-this-iter / carry-over above; called out separately because they document the project lying to itself).

Overall verdict: iter-178's seven touched files generally landed sound real-body work (Lanes 1, 2, 4, 6, 7 are kernel-clean or honest scaffolds), but **Lane 5 Part B is a critical weakened-wrong landing** — the prover knew the signature was insufficient yet committed the body anyway with an excuse-comment; this is the iter-175 chart-bridge-prover-bypass pattern recurring. Lane 4's `extend_iff_order_nonneg` is a softer but related concern (type too shallow for claimed content). The two TEMP project axioms in GmScaling.lean continue to power the Route C chain and remain on the iter-181 retire-or-escalate clock per STRATEGY.md. RelativeSpec.lean's two placeholder bodies (`:= X`, `:= 𝟙 X`) and AlbaneseUP.lean's `Pic0.bundle := sorry` remain CRITICAL load-bearing weakenings tracked as carry-overs.
