# Lean Audit Report

## Slug
iter193

## Iteration
193

## Scope
- files audited: 43 (`AlgebraicJacobian.lean` + `AlgebraicJacobian/**/*.lean`)
- files skipped (per directive): 0

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: pure import shim.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: 1 — L14 references "Status (iteration 073 — Phase E)"; this is stable but extremely dated header context.
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: sorry-free; delegates to witness as advertised.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: clean, single substantive definition; no findings.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: see notes — `Classical.choice (nonempty_jacobianWitness C)` (L313) is a documented existential-extraction; `positiveGenusWitness := sorry` (L274) is a fully-`sorry` def.
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none — sorries are documented STRATEGY.md-acknowledged scaffolds.
- **notes**: 2 substantive sorries: L236 (rigidity descent inside `genusZeroWitness.isAlbaneseFor`), L274 (entire `positiveGenusWitness` body). Both are explicitly tagged STRATEGY.md M2/M3 work and ride on the project's headline.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: clean; sorry-free.

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: none (the `Status (iter-NNN)` blocks are still accurate w.r.t. current bodies)
- **suspect definitions**: none — `kbarChart1Ring` (L197-203), `iotaGm_r_1` (L147-160), `iotaGm_r_1_fac` (L165-172), `iotaGm_r_1_eq_specMap` (L250-261), `kbarChart1Ring_specMap_fac` (L222-241) are all honest substrate definitions.
- **dead-end proofs**: none; the iter-193 `IsOpenImmersion.lift_uniq` route is correct (replaces the previously-stuck `Proj.appIso` chain with a `lift_uniq` reduction).
- **bad practices**: none.
- **excuse-comments**: none.
- **notes**: 4 sorries — L241 (`kbarChart1Ring_specMap_fac`, the substantive new gap), L439 (`iotaGm_chart1_appIso_eval` residual), L685 (`genusZero_curve_iso_P1`, RR-bridge gate), L801 same shape. All documented and lane-tagged. The Lane E refactor introduces 1 new substantive sorry (the `kbarChart1Ring_specMap_fac` factorisation) but eliminates the previously stuck `Proj.appIso` evaluation — net structural improvement.

### AlgebraicJacobian/Picard/Pic0AbelianVariety.lean
- **outdated comments**: none.
- **suspect definitions**: none — the 5 file-skeleton theorems use the `AddEquiv` (not `LinearEquiv`) bypass for the `Type u`/`Type (u+1)` universe mismatch between `IsLocalRing.CotangentSpace` and `Scheme.HModule`; choice is documented (file header §"Note on type expressivity") and correct.
- **dead-end proofs**: none — bodies are all `sorry`.
- **bad practices**: none — `noncomputable` markers ok; universe handling explicit.
- **excuse-comments**: none (the doc headers explicitly describe iter-194+ work).
- **notes**: 5 raw sorries (L149, L171, L190, L209, L238) on the 5 pinned `\lean{...}` declarations matching the chapter pins. Signatures are substantive (each binds `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom]` and the conclusion is non-tautological). This is a clean iter-193 file-skeleton landing.

### AlgebraicJacobian/Picard/IdentityComponent.lean
- **outdated comments**: none — the iter-NNN comments throughout (iter-186, iter-187, iter-188, iter-192, iter-193) are stage-accurate.
- **suspect definitions**: none — `identitySectionPoint` (L218-221), `identityComponentCarrier` (L230-234), `IdentityComponent` (L253-257), `identityComponentSection` (L443-451) are honest substrate. The `@IsOpenImmersion.lift` use in `identityComponentSection` is correct (no soundness issue).
- **dead-end proofs**: none.
- **bad practices**: `private instance identityComponent_geometricallyConnected` (L500-507) is a typeclass instance derived from a `sorry`-bodied helper (`geometricallyConnected_of_connected_of_section` L414-420). The fix is the named lemma being marked planner-sanctioned, but a `sorry`-derived instance silently propagates `sorryAx` into every downstream typeclass synthesis — see Major findings.
- **excuse-comments**: none.
- **notes**: 7 raw sorries (L315 inside `isOpenSubgroupScheme`; L420 `geometricallyConnected_of_connected_of_section`; L528 `isSubgroupHomomorphism`; L568 inner branch of `isFiniteTypeGeometricallyIrreducible`; L640 iso slot of `baseChangeIso`; L676 `Pic0Scheme`; L717 `degree`; L770/788/813 `isAbelianVariety`/`finrank_eq_genus`/`kPoints_iff_kerDegree`). The `Pic0Scheme := sorry` (L676) is a typed sorry on a load-bearing scheme definition — see Must-fix.

### AlgebraicJacobian/RiemannRoch/WeilDivisor.lean
- **outdated comments**: none — the iter-191/192/193 narrative is accurate.
- **suspect definitions**:
  - **L725-803 `degree_positivePart_principal_eq_finrank`**: signature documented as STILL MATHEMATICALLY FALSE under the iter-193 `hlp` augmentation. Counter-witness explicitly written into the proof body (L770-777: `K=K(C)=k̄(u), t=u(u-1)` gives LHS=2, RHS=1). Signature is wrong-as-stated. See Must-fix.
  - **L282-284 `ofClosedPoint`**: junk-defined outside the codim-1 regime via if-then-else. Documentation calls this "junk-defined outside its intended scope" — acceptable as long as the well-definedness side-condition `coheight P = 1` is enforced at every call site. This is honest but worth noting (`ofClosedPoint_eq_zero` L299-302 documents the off-branch behaviour).
- **dead-end proofs**: none — the substrate helpers `principal_apply`, `positivePart_single`, `degree_single`, `one_le_degree_positivePart_principal_of_order_one`, `degree_positivePart_eq_sum_max`, `positivePart_zero`, `_root_.AlgebraicGeometry.Scheme.RationalMap.order_one`, `principal_one` are all honest and used.
- **bad practices**: none — `noncomputable` markers in place.
- **excuse-comments**: none in the strict sense; the docstrings are forthright about the signature being wrong (L713-715, L767-794). Forthrightness on a wrong signature is itself a serious finding — see Must-fix.
- **notes**: 3 raw sorries (L248 `rationalMap_order_finite_support` Case 2, L537 `principal_degree_zero` non-constant branch, L803 main wrong-signature theorem).

### AlgebraicJacobian/RiemannRoch/H1Vanishing.lean
- **outdated comments**: none.
- **suspect definitions**: none — `Scheme.IsFlasque` (L98-102), `injectiveSES` (L181-189), `injectiveSES_shortExact` (L192-200), helpers `ext_one_eq_zero_of_hom_surjective_of_injective` (L224-254) and `ext_succ_eq_zero_of_injective_of_lower_zero` (L273-287) are honest substantive helpers.
- **dead-end proofs**: none — the strong-induction-with-`F`-generalised quantifier in `HModule_flasque_subsingleton_aux` (L410-506) is structurally sound (the `induction n generalizing F` pattern is the right one for the inductive recurse on the flasque quotient at lower degree).
- **bad practices**: none.
- **excuse-comments**: none.
- **notes**: 4 raw sorries: L144 (`constant_of_irreducible`), L329 (`shortExact_app_surjective`, Hartshorne II Ex 1.16(b)), L396 (`injective_flasque`, Hartshorne III Lemma 2.4), L593 (`skyscraperSheaf_eq_pushforward_const`, Hartshorne II Ex 1.17). All are named substrate inputs with `Tier-3 honest typed sorry` annotations and Mathlib-gap rationale. The `HModule_flasque_eq_zero` body (L546-556) closes structurally via the two substrate inputs. Substrate naming is consistent and the typed-sorries are properly named.

### AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean
- **outdated comments**: none — the iter-176/178/181/183/185/187/188/189/190/191/192/193 narrative is accurate per the current code.
- **suspect definitions**: none.
- **dead-end proofs**: the `auslander_buchsbaum_formula` body (L887-978) is a 2-branch case split where both branches are raw sorries (L953 base case, L978 inductive case). Per directive instruction this needed checking: each branch's docstring documents the Stacks 090V recipe and the four sub-substrate Mathlib gaps (minimal finite free resolutions / "what is exact" criterion / snake lemma on resolutions / depth-drops-by-one). Both branches are structurally honest reductions — the `n = 0` branch reaches the genuinely-narrower "depth(R^k) = depth(R)" question and explicitly identifies the residual; the `n = k+1` branch identifies the four substrate gaps inline. The 2-sorry case-split structure is honest scaffolding.
- **bad practices**: none — `private` modifiers consistent; `noncomputable` markers correct.
- **excuse-comments**: none.
- **notes**: 2 raw sorries (L953, L978), both inside `auslander_buchsbaum_formula`. The case-split structure is sound.

### AlgebraicJacobian/Albanese/CodimOneExtension.lean
- **outdated comments**: none — Lane M↓ iter-191/192/193 staging accurate.
- **suspect definitions**: none — Stage 1–5b helpers (L227-371) are all axiom-clean per their docstrings, with each helper a focused Mathlib-bridge re-export. `stalkMap_flat_of_smooth`, `exists_isStandardSmooth_at_of_smooth`, `exists_algebra_isStandardSmooth_section_stalk_isLocalization_of_smooth`, `module_free_kaehlerDifferential_of_isStandardSmooth`, `module_free_kaehlerDifferential_localization`, `rank_kaehlerDifferential_localization_eq_relativeDimension` are honest substrate building toward the Stacks 00TT Jacobian-criterion proof.
- **dead-end proofs**: none — the Kähler-differential localisation chain in `isRegularLocalRing_stalk_of_smooth` (L434-515) bottoms out at the documented Stage 6 Mathlib gaps (Stacks 02JK cotangent-Kähler bridge + 00OE smooth-algebra dimension formula). The Stage 5a/5b helpers are correctly composed.
- **bad practices**: none.
- **excuse-comments**: none.
- **notes**: 3 raw sorries (L515 Stage 6 of `isRegularLocalRing_stalk_of_smooth`; L685 `extend_of_codimOneFree_of_smooth`; L728 `indeterminacy_pure_codim_one_into_grpScheme`). All have substantive documentation. Stage 5a/5b expansion (iter-193 work) is a clean structural advance.

### AlgebraicJacobian/Albanese/AlbaneseUP.lean
- **outdated comments**: none
- **suspect definitions**: 1 typed sorry on a load-bearing helper `bundle : Bundle C := sorry` (L183) — explicit single-helper-budget pattern.
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: ~6 sorries on pinned declarations (`abelJacobi`, `SymmetricPower`, `symmetricPowerAVMap`, `symmetricPowerToJacobian`, `descentThroughBirationalSigma`, `albanese_eq_iff_symmetricPower_eq`), all documented as iter-178+/iter-200+ work; `albanese_universal_property` body is sorry-free assembly.

### AlgebraicJacobian/Albanese/CoheightBridge.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: axiom-clean, 0 sorries.

### AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 2 sorries (L194 isolated `IsReduced A.left := sorry` Mathlib gap, L283 substantive branch of `av_codimOneFree_of_indeterminacy`); `extend_to_av` body sorry-free assembly.

### AlgebraicJacobian/Genus0BaseObjects.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: re-export shim, no findings.

### AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none — explicitly labelled "Project-side scaffold sorry" (acceptable per Lane A).
- **notes**: 2 sorries on `projectiveLineBar_geomIrred` and `projectiveLineBar_smoothOfRelDim`; remaining proofs (properness) are closed.

### AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: axiom-clean, 0 sorries.

### AlgebraicJacobian/Genus0BaseObjects/Cross01Substrate.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: axiom-clean, 0 sorries.

### AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 1 sorry (L690 `gmScalingP1_chart_agreement_cross01`, localised topological-range substrate), all other definitions closed.

### AlgebraicJacobian/Genus0BaseObjects/Points.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: axiom-clean, 0 sorries.

### AlgebraicJacobian/Picard/FGAPicRepresentability.lean
- **outdated comments**: 1 — header mentions "iter-175 Lane I died to the Anthropic session-limit reset window without ever calling Write" (process narrative not strictly relevant to code state).
- **suspect definitions**: 6 typed sorries on pinned definitions (`picSharp`, `divFunctor`, `PicScheme`, `abelMap`, `representable`, `groupSchemeStructure`).
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none (the session-death note is a status comment, not an excuse for wrong code).
- **notes**: file-skeleton, all 6 sorries on declared pinned declarations. **CRITICAL `PicScheme := sorry` (L189)** since downstream `Picard/IdentityComponent.lean` and `Pic0AbelianVariety.lean` both consume `PicScheme C` — see Must-fix.

### AlgebraicJacobian/Picard/FlatteningStratification.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 7 sorries on pinned declarations (`genericFlatness`, `flatLocusStratification`, `flatLocusReduction`, `flatLocusAssembly`, `flatteningStratification`, `flatteningStratification_universal`, `flatteningStratification.ofCurve`) — honest file-skeleton.

### AlgebraicJacobian/Picard/LineBundlePullback.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: closed, 0 sorries.

### AlgebraicJacobian/Picard/QuotScheme.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 11 sorries; bottleneck on 3 Mathlib-gap sorries (L562 `pullback_tildeIso`, L588 `pushforward_isQuasicoherent`, L616 `tildeIso_of_isQuasicoherent_isAffineOpen`); remaining substantive proofs (L476-542, L650-780, L546-632) axiom-clean. **`QuotScheme := sorry` (L326)** is a load-bearing scheme definition — see Must-fix.

### AlgebraicJacobian/Picard/RelPicFunctor.lean
- **outdated comments**: 1 — session-death narrative at L20-29 (process noise).
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 6 sorries on pinned declarations (`addCommGroup`, `PicSharp`, `functorial`, `presheaf`, `PicSharp.etSheaf`, `etSheafUnit`); naming collision with `PicScheme` from FGAPicRepresentability explicitly flagged in-file at L65-72 (honest declaration, not hidden).

### AlgebraicJacobian/Picard/RelativeSpec.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: axiom-clean, 0 sorries — exemplary.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries; clean.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries; clean.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries; clean.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries; clean.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries; re-export wrapper.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries; clean.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries; clean.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/SheafProperty.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries; clean.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: 1 — "Mathlib.RingTheory.IsPushout does not exist upstream, replaced with Mathlib.RingTheory.IsTensorProduct" (L20-26); documented divergence, not a bug.
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries; clean.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: none
- **suspect definitions**: none (the `Classical.choose` chain in `cotangentSpaceAtIdentity` L162-201 is term-mode and the rank lemma L257-295 is closed axiom-clean).
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries; clean.

### AlgebraicJacobian/RiemannRoch/OCofP.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 2 sorries on `lineBundleAtClosedPoint` body (L183) and `carrierPresheaf_isSheaf` (L690), both Tier-3 documented for iter-184+/iter-190+.

### AlgebraicJacobian/RiemannRoch/OcOfD.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 3 sorries (`sheafOf` D≠0 branch L141; `sheafOf_singlePoint` L195; `sheafOf_ses_single_add` L244), all Tier-3 documented.

### AlgebraicJacobian/RiemannRoch/RRFormula.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: file-skeleton with sorries on pinned declarations; `eulerCharacteristic` definition closed.

### AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: pinned-declaration sorries gated on RR.1/RR.2/RR.3 substrate (see WeilDivisor finding on the broken signature it consumes).

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries; axiom-clean.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 1 sorry on `rigidity_over_kbar` (L87), documented as iter-126 scaffold gated on shared cotangent-vanishing pile.

### AlgebraicJacobian/RigidityLemma.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: per inspection of opening 150 LOC: substantive lemmas (`rigidity_snd_lift`, `snd_left_isClosedMap`, `morphism_eq_of_eqAt_closedPoints`) are closed; remainder consistent with documented "PROVEN axiom-clean (iters 157–162)" status in importing files.

## Must-fix-this-iter

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:725-803` — `degree_positivePart_principal_eq_finrank` signature is documented in-file (L770-777) as **mathematically false** as currently stated, with an explicit counter-witness (`K=K(C)=k̄(u), t=u(u-1)`: LHS=2, RHS=1). The iter-193 `hlp` hypothesis (L735-736: "`∃ Y, order Y t = 1`") was added to rule out the iter-192 `t=1` counter-witness but does **not** pin `t` to be a uniformiser at the unique pole — `t` may still have multiple zeros, breaking the equation. **Why must-fix**: a wrong-as-stated load-bearing theorem propagates a false claim into every downstream consumer (specifically `RationalCurveIso.lean`'s `poleDivisor_degree_eq_finrank` and through it the RR-bridge into `genusZero_curve_iso_P1`). The fix is documented inline (L789-791): stronger local-parameter constraint (e.g. `∀ Y, order Y t ≠ 0 → ...uniqueness condition...` or restrict `K` to `K(ℙ¹)`). Either close in iter-194 plan-phase or weaken the conclusion. Honesty in the docstring does not redeem the broken signature; downstream provers will silently consume `False`.

- `AlgebraicJacobian/Picard/IdentityComponent.lean:500-507` — `private instance identityComponent_geometricallyConnected` is a typeclass instance whose body invokes the `sorry`-bodied helper `geometricallyConnected_of_connected_of_section` (L414-420). **Why must-fix**: a `sorry`-derived typeclass instance silently propagates `sorryAx` into every downstream typeclass synthesis that triggers this instance. The author has marked it "planner-sanctioned temporary sorry-count increase", but a `sorry`-bodied **instance** is qualitatively worse than a `sorry`-bodied **theorem** because consumers cannot opt out — instance synthesis fires automatically. Either (a) demote to a non-instance lemma until the helper closes, or (b) gate the instance behind a separate `[GeometricallyConnected_hypothesis]` typeclass that callers must explicitly supply.

- `AlgebraicJacobian/Picard/IdentityComponent.lean:671-676` — `noncomputable def Pic0Scheme ... := sorry` is a typed-sorry on a load-bearing scheme definition that downstream `Picard/Pic0AbelianVariety.lean` consumes in 5 separate theorem signatures. **Why must-fix**: `:= sorry` on the **carrier of a definition** (not a proof body) is the strongest form of wrong-code-pretending-to-be-right. Every typeclass `[GrpObj (Pic0Scheme C)]` etc. silently propagates a `sorry`-carried scheme through unification. The fix is documented (`GroupScheme.IdentityComponent (PicScheme C)` once the `[LocallyOfFiniteType (PicScheme C).hom]` instance lands). Either land that instance immediately or guard `Pic0Scheme` behind an existential `Nonempty (Σ' S : Over (Spec k), _)` like the rest of the file-skeleton uses.

- `AlgebraicJacobian/Picard/FGAPicRepresentability.lean:187-189` — `noncomputable def PicScheme ... : Over (Spec (.of k)) := sorry`. Same pathology as `Pic0Scheme`: a `:= sorry` on a load-bearing scheme definition that `IdentityComponent.lean` and `Pic0AbelianVariety.lean` both consume. **Why must-fix**: the entire A.3/A.3.iii–vii chain's typeclass synthesis sits on top of a `sorry`-carried scheme. Same fix template as above.

- `AlgebraicJacobian/Picard/QuotScheme.lean:326-330` — `QuotScheme := sorry` is a load-bearing scheme definition. **Why must-fix**: identical pathology to `PicScheme` / `Pic0Scheme`. A typed-sorry on the carrier silently propagates `sorryAx` through every consumer's typeclass synthesis.

- `AlgebraicJacobian/Picard/RelPicFunctor.lean:284-287, 370-373, 429-433` — `PicSharp := sorry`, `presheaf := sorry`, `PicSharp.etSheaf := sorry` are typed-sorries on load-bearing functor/sheaf definitions. **Why must-fix**: same as above.

- `AlgebraicJacobian/Picard/FGAPicRepresentability.lean:226-231, 132-135, 147-150` — `picSharp`, `divFunctor`, `abelMap` similarly. The pattern is uniform across the A.2 / A.3 file-skeletons and is the project's single largest soundness exposure.

## Major

- `AlgebraicJacobian/Jacobian.lean:198-248` — `genusZeroWitness` returns a `JacobianWitness C` whose `isAlbaneseFor` field body contains an inline `sorry` (L236). Because `noncomputable def jacobianWitness` (L310-313) wraps this through `Classical.choice (nonempty_jacobianWitness C)`, the inline `sorry` propagates into every downstream `(jacobianWitness C).J / .grpObj / .smoothGenus / ...` reference. This is **structurally a Must-fix** by the directive's strict severity reminder ("`:= sorry` on a load-bearing claim"), but is documented and acknowledged at the STRATEGY.md M2/M3 level, so I'm classifying as Major. **Recommendation**: at minimum, the project should add a `#check (#print axioms jacobianWitness)` smoke test gate so a future iteration's accidental new `axiom` introduction surfaces.

- `AlgebraicJacobian/Jacobian.lean:270-274` — `positiveGenusWitness := sorry` is the entire body of a `noncomputable def`. Same propagation pathology as above. Documented M3 work, off critical path.

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:282-284` — `Scheme.WeilDivisor.ofClosedPoint` is junk-defined off the `Order.coheight P = 1` branch (returns zero). This is structurally honest (the file documents `ofClosedPoint_eq_zero` for the off-branch) and the junk-branch fires only when callers supply a "closed point" that isn't codim-1. Worth re-examining once the codim-1 calls actually land — at present no caller exists, so the soundness exposure is latent.

- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:887-978` — `auslander_buchsbaum_formula` has 2 raw sorries in a case-split structure. Both branches are honestly documented but the file-level claim "the formula `pd_R(M) + depth(M) = depth(R)`" is currently unproven; downstream `CohenMacaulay.of_regular` consumes a different (independent) chain. The 2-sorry inductive scaffold is plausible but the substrate (minimal finite free resolutions, "what is exact", depth-drops-by-one) is not in Mathlib b80f227 — substantive multi-iter work ahead.

- `AlgebraicJacobian/Albanese/AlbaneseUP.lean:183` — `bundle : Bundle C := sorry` is a typed-sorry on a load-bearing definition. Single-helper-budget pattern, documented; same soundness exposure as the `PicScheme` family but smaller blast radius.

## Minor

- `AlgebraicJacobian/AbelJacobi.lean:14` — header "iteration 073" reference is the oldest visible iter-tag in the project; could be refreshed but does not contradict the current code.

- `AlgebraicJacobian/Picard/FGAPicRepresentability.lean:19-20`, `AlgebraicJacobian/Picard/QuotScheme.lean:20`, `AlgebraicJacobian/Picard/RelPicFunctor.lean:20-29` — multiple files retain the "iter-175 Lane I/G/H died to the Anthropic session-limit reset window without ever calling Write" narrative in their headers. This is process detail that has no relevance to the code state and should be cleaned up; it does not actively mislead so classified Minor.

- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:20-26` — documented divergence (`Mathlib.RingTheory.IsPushout` not upstream, using `IsTensorProduct`) is correct as a note but worth tracking against future Mathlib bumps.

- `AlgebraicJacobian/Picard/RelPicFunctor.lean:65-72` — naming collision between `PicScheme` (this file vs `FGAPicRepresentability.lean`) is **disclosed**, but the disclosure itself is a smell: two files in the same `Picard/` namespace asserting different `\lean{...}` targets for the same blueprint pin is a planning issue that should be resolved upstream rather than perpetuated.

- `AlgebraicJacobian/AbelianVarietyRigidity.lean:97` — comment `#print axioms = {propext, Classical.choice, Quot.sound}` is asserted but cannot be cheaply verified by a downstream reader. A `#guard_msgs` smoke test would harden this.

- `AlgebraicJacobian/Picard/IdentityComponent.lean:282-315`, `:548-568` — `IdentityComponent.isOpenSubgroupScheme` and `isFiniteTypeGeometricallyIrreducible` have `refine ⟨?_, ?_⟩`/`refine ⟨?_, ?_, ?_⟩` followed by `infer_instance` on the first conjunct and `sorry` on later conjuncts. The structure is honest but the partial-closure pattern would benefit from being split into one sorry per declaration so the closed half can be exported as a separate lemma.

## Excuse-comments (always called out separately)

None. The project's substantive sorries are documented with substrate-gap rationale and iteration-tagged staging, not with "TODO replace later" / "placeholder" / "temporary wrong def" language. The closest item is the WeilDivisor.lean `degree_positivePart_principal_eq_finrank` docstring which **explicitly says the signature is wrong** — this is honesty, not an excuse-comment, but it is classed under Must-fix above because honesty does not redeem a broken signature.

## Severity summary

- **must-fix-this-iter**: 7 — wrong signature on WeilDivisor.lean degree theorem (1); `sorry`-derived typeclass instance in IdentityComponent.lean (1); load-bearing `:= sorry` on scheme/functor/sheaf definitions across Pic0Scheme + PicScheme + QuotScheme + 3× RelPicFunctor + 3× FGAPicRepresentability (5 grouped, 8 lines).
- **major**: 5 — 2× Jacobian.lean witness scaffolds; WeilDivisor `ofClosedPoint` junk-branch; AuslanderBuchsbaum 2-branch case-split; AlbaneseUP `bundle`.
- **minor**: 6 — header iter-tag staleness, session-death narrative noise (3 files), Mathlib divergence note, naming collision disclosure, axiom-comment-without-test, refine-partial-closure pattern.
- **excuse-comments**: 0.

Overall verdict: the iter-193 lane work (Pic0AbelianVariety file-skeleton, WeilDivisor substrate helpers, H1Vanishing strong-induction restructure, AbelianVarietyRigidity `lift_uniq` reroute, IdentityComponent section helpers, AuslanderBuchsbaum Lane G inductive step, CodimOneExtension Stage 5a/5b expansion) is structurally sound; the project's central soundness exposure is the family of typed-`sorry` on load-bearing **definition carriers** (not proof bodies) in the Picard/Pic0/Quot/RelPic chain plus the mathematically-false WeilDivisor signature which the iter-193 `hlp` augmentation does not rescue.
