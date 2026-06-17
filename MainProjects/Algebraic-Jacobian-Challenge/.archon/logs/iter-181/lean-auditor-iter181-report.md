# Lean Audit Report

## Slug
iter181

## Iteration
181

## Scope

- files audited: 37 (entire `AlgebraicJacobian/` tree)
- files skipped (per directive): 0
- deep audit (per focus list): 9
- light coverage (rest of tree): 28

## Methodology

- Read each focus file in full; verified key axiom-cleanness claims with `lean_verify`.
- Cross-tree checks: grep for excuse-comments (`TODO`/`FIXME`/`placeholder`/`temporary`/`will fix`/`stand-in`/`HACK`/`XXX`), `:= sorry` defs, raw `axiom` declarations.
- For each new helper landed this iter, judged whether it captures a substantive Mathlib gap or "renames the original sorry".

## Per-file checklist

### AlgebraicJacobian/AbelianVarietyRigidity.lean (focus file)

- **outdated comments**: 14 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 1
- **excuse-comments**: 0
- **notes**:
  - L88-97, L114-117, L294, L335, L358: heavy iter-{166,167,180,181} status-block embeddings in docstrings. These are status logs that belong in git history / iter sidecars, not in source comments. The project clearly uses this as a workflow signal, but it is a maintenance liability and now numbers ~14 references in a single 400-LOC file.
  - L98-106 (`iotaGm_range_isOpen`): new helper. Signature substantively claims `IsOpen` of the set-theoretic range of a concrete morphism. NOT laundering — captures the genuine chart-1 open-immersion fact. Body `sorry`. Acceptable.
  - L119-136 (`iotaGm_isDominant`): `#print axioms` reports `[propext, sorryAx, Classical.choice, Quot.sound]`. Docstring claims "kernel-clean (this body) MODULO upstream `iotaGm_range_isOpen`" — disclosure tier matches actual axiom set.
  - L160-276 (`morphism_P1_to_grpScheme_const_aux`): `#print axioms` confirms `sorryAx` present. Docstring at L292-294 acknowledges "carries propagated `sorryAx`" — tier claim correct.
  - L295-322 (`morphism_P1_to_grpScheme_const`): `sorryAx` propagated (verified). Disclosure correct.
  - L337-343 (`genusZero_curve_iso_P1`): body `:= sorry`. Substantive RR claim, blueprint-pinned. Acceptable.
  - L362-398 (`rigidity_genus0_curve_to_grpScheme`): `sorryAx` propagated (verified). Disclosure correct.
  - **bad practice (minor):** L243 uses `haveI hιDom : IsDominant iotaGm.left := iotaGm_isDominant` — the named bridge resolution is OK, but the `_hf` parameter in the headline at L373 is consumed only at L383 in a single step. The previous lean-auditor (iter-157/158) flagged this pattern as laundering; here the new use IS sound — `_hf` is fed into `hpoint` which forces `a₀ = η[A]`. Good.

### AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean (focus file)

- **outdated comments**: 7 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - L28-67, L142-148, L185, L286, L322-325, L376-387, L406-434, L455-464: dense iter-{175..181} status-block embedding in docstrings. Same pattern as AVR.
  - L388-404 (`length_le_ringKrullDim_of_isRegular`): `lean_verify` ⇒ `[propext, Classical.choice, Quot.sound]`. Tier-1 kernel-clean confirmed. Body is a real ~13-LOC calc-style proof; NOT laundering.
  - L435-441 (`exists_isRegular_of_regularLocal`): new helper for iter-181 Lane G. Body `sorry`. Signature captures the genuine "system-of-parameters as regular sequence" lower-bound claim (Stacks 00OD). NOT laundering — substantive existence of a list `rs` with three substantive properties. Acceptable.
  - L186-189 (`Module.projectiveDimension`): `lean_verify` confirms tier-1 kernel-clean. One-line re-export of `CategoryTheory.projectiveDimension`. Sound.
  - L465-503 (`CohenMacaulay.of_regular`): `lean_verify` ⇒ `sorryAx` present (via `exists_isRegular_of_regularLocal`). Disclosure at L457-464 says "the only residual sorry in this `instance` body is the named helper" — tier matches.
  - L228-237 (`depth_eq_smallest_ext_index`): `:= by sorry`. Substantive type (`n ≤ depth ↔ ∀ i < n, Ext^i = 0`). Both sides bind hypothesis vars. Acceptable.
  - L268-286 (`depth_of_short_exact`): `:= by sorry`. Substantive triple-inequality. Acceptable.
  - L326-334 (`auslander_buchsbaum_formula`): `:= by sorry`. Substantive arithmetic equation. Acceptable.

### AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean (focus file)

- **outdated comments**: 16 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 1
- **excuse-comments**: 0
- **notes**:
  - L14-26, L116-122, L150-155, L177-190, L259-294, L310-322, L358-370, L383-410, L429-443, L495-504, L520-536: many iter-{167..181} status-block embeds.
  - L54-64 (`awayι_comp_PLB_hom`): `lean_verify` ⇒ tier-1 kernel-clean. Concrete `rfl`-closing rewrite chain. Sound.
  - L191-256 (`gmScalingP1_chart_PLB_eq`): `lean_verify` ⇒ tier-1 kernel-clean. Multi-stage `change` + `simp only` recipe; ~65 LOC. iter-180 axiom retirement landed. **bad practice (minor):** uses `set_option backward.isDefEq.respectTransparency false in` (L177) to avoid heartbeat sinks — recipe is documented in `analogies/pullbackspeciso-bypass.md`. Acceptable as documented workaround.
  - L295-308 (`gmScalingP1_chart_agreement_cross01`): NEW Lane B helper. Substantive ring-level identity on `Localization.Away t ⊗[kbar] GmRing`. NOT laundering — it isolates the one nontrivial cocycle leg. Body `sorry`.
  - L323-356 (`gmScalingP1_chart_agreement`): `lean_verify` ⇒ `sorryAx` (via `cross01`). Diagonal `(0,0)`/`(1,1)` closed via `fst_eq_snd_of_mono_eq`; `(1,0)` derived from `(0,1)` axiom-clean via `pullbackSymmetry`. Disclosure correct.
  - L371-380 (`gmScalingP1_over_coherence`): glue cocycle to over-coherence via `Cover.hom_ext`. Sound when `chart_PLB_eq` is clean (it is).
  - L395-401 (`gmScalingP1`): `noncomputable def`, body uses `Over.homMk ((cover).glueMorphisms ... ...) (over_coherence)`. Concrete.
  - L420-426 (`gmScalingP1_collapse_at_zero`): `:= by sorry`. Load-bearing fixed-point property. Substantive lemma, body is the iter-181 escalation target. NOT laundering.
  - L449-453 (`projGm_locallyOfFiniteType`): `inferInstance` after `change`. Sound.
  - L460-494 (`projectiveLineBar_isReduced`): substantive ~35-LOC body that constructs `IsReduced` from chart-level domain instances via `IsReduced.of_openCover`. Sound concrete proof.
  - L502-504 (`gm_geomIrred`): `:= by sorry`. Substantive instance gap (`Mathlib gap: Smooth → GeometricallyReduced` not shipped). Acceptable.
  - L514-518 (`projGm_geomIrred`): consumes `gm_geomIrred` via `GeometricallyIrreducible.comp`. Sound when its premise lands.
  - L532-536 (`projGm_isReduced`): `:= by sorry`. Scaffold-sorry with Mathlib-gap rationale. Acceptable.

### AlgebraicJacobian/Genus0BaseObjects/Points.lean (focus file)

- **outdated comments**: 3 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - L13-25, L240-251, L477-503: iter-{175..179} status embeds.
  - L51-54 (`evalIntoGlobal`): concrete one-liner ring composition. Sound.
  - L59-79 (`irrelevant_map_eq_top`): substantive `Ideal.eq_top_iff_one`-driven body. Sound.
  - L86-116 (`pointOfVec`): substantive `Proj.fromOfGlobalSections` + section-condition body. Concrete + axiom-clean. **The three closed points `zeroPt`/`onePt`/`inftyPt` were previously claimed iter-166 kernel-clean** — verified `zeroPt` ⇒ `[propext, Classical.choice, Quot.sound]`. Disclosure matches.
  - L255-277 (`gmHomFunctor`): substantive concrete functor. Sound.
  - L287-293 (`gmHomEquiv_toFun`): substantive forward equivalence. Concrete.
  - L298-352 (`gmHomEquiv_invFun_isOver`): `lean_verify` ⇒ tier-1 kernel-clean. ~50-LOC over-coherence chase. Sound.
  - L361-377 (`gmHomEquiv_invFun`): substantive backward via `IsLocalization.Away.lift`. Sound.
  - L382-435 (`gmHomEquiv_left_inv`): `lean_verify` ⇒ tier-1 kernel-clean. ~50-LOC `IsLocalization.lift_unique` chase. Sound.
  - L440-463 (`gmHomEquiv_right_inv`): `lean_verify` ⇒ tier-1 kernel-clean. Sound.
  - L468-475 (`gmHomEquiv_homEquiv_comp`): tier-1 kernel-clean. Naturality closed via `simp` + `rfl`.
  - L502-503 (`gm_grpObj`): **`lean_verify` confirms tier-1 kernel-clean** — `[propext, Classical.choice, Quot.sound]`. This retires the 11-iter `gm_grpObj` deferral cleanly. Strong result.
  - L507-510 (`gm_smooth`): `smooth_of_grpObj_of_isAlgClosed` consumption. Sound.
  - L514-516 (`Gm.onePt`): one-line `η[Gm kbar]` alias. Sound.

### AlgebraicJacobian/Picard/QuotScheme.lean (focus file)

- **outdated comments**: 9 flagged
- **suspect definitions**: 3
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - L20-30, L113-119, L350-356, L373-385, L501-515, L552-567, L600-617: iter-{175..181} status embeds.
  - L170-173 (`hilbertPolynomial`): `noncomputable def ... := sorry` returning `Polynomial ℚ`. **Suspect**: any consumer comparing two `hilbertPolynomial` values gets vacuous comparisons (the sorry value is opaque-but-unique). The file's docstring (L70-89) explicitly discloses this as the blueprint-pinned scaffold pattern. Acceptable per project disclosure but is a *known* propagating placeholder.
  - L208-212 (`QuotFunctor`): same pattern, returns a functor `:= sorry`. Same disclosure.
  - L245-248 (`Grassmannian`): same pattern.
  - L272-275, L326-330, L468-499, L527-549, L568-599: substantive theorems with `:= by sorry`. Each docstring is honest about the substantive content remaining; signatures are non-tautological.
  - L409-420 (`canonicalBaseChangeMap`): concrete `noncomputable def` body via `mateEquiv`. Sound.
  - L430-434 (`pushforward_pullback_section_eq_pullback_section`): `:= rfl`. Trivial sound bridge.
  - L468-499 (`canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase`): NEW helper. Substantive Stacks 02KE algebraic content. NOT laundering — the docstring locates the precise Mathlib gap (section-vs-tensor-product identification of `Scheme.Modules.pullback`'s sections at affine opens). Acceptable.
  - L618-628 (`canonicalBaseChangeMap_app_app_isIso`): composes the two named helpers cleanly. Concrete (not sorry).
  - L641-648 (`canonicalBaseChangeMap_isIso`): closes via `Hom.isIso_iff_isIso_app`. Concrete.
  - L650-661 (`flatBaseChangeCohomology`): wraps the isomorphism in `Nonempty`. Sound when premise helpers land.

### AlgebraicJacobian/Picard/RelativeSpec.lean (focus file)

- **outdated comments**: 14 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - L17-43, L64-77, L212-231, L322-326, L411-416, L491-530: iter-{173..181} status embeds — particularly dense because the file went through several pivots (iter-176 placeholder rejection, iter-178 mathlib-analogist consult, iter-179 Block A landing, iter-181 Lane D split).
  - L143-158 (`QcohAlgebra`): substantive 3-field structure (sheaf + unit + coequifibered). Non-trivial; previous iter-177 "weakened-wrong" flag is fully addressed.
  - L192-193 (`RelativeSpec`): one-line concrete body `(relativeGluingData _).glued`. Sound.
  - L208-210 (`structureMorphism`): one-line concrete body `.toBase`. Sound.
  - L264-289 (`UniversalProperty`): **`lean_verify` ⇒ tier-1 kernel-clean.** Substantive ~25-LOC proof via `isAffineHom_of_forall_exists_isAffineOpen` + `toBase_preimage_eq_opensRange_ι`. Strong result.
  - L311-318 (`affine_base_iff`): **`lean_verify` ⇒ tier-1 kernel-clean.** Two-line proof from `UniversalProperty`. Sound.
  - L335-341 (`QcohAlgebra.pullback_fst_isAffineHom`): **`lean_verify` ⇒ tier-1 kernel-clean.** Sound 3-line proof.
  - L358-377 (`QcohAlgebra.pullback_coequifibered`): **`lean_verify` ⇒ tier-1 kernel-clean.** Concrete via `coequifibered_iff_forall_isLocalizationAway`. Sound.
  - L390-397 (`QcohAlgebra.pullback`): concrete `noncomputable def` consuming the two helpers. Sound.
  - L432-440 (`pullback_iso_affine_piece`): NEW iter-181 Lane D Helper 1. **`lean_verify` ⇒ tier-1 kernel-clean.** Honestly axiom-clean; body is `(U.2.preimage q).isoSpec`. NOT laundering — captures the per-affine-piece concrete iso. Sound.
  - L484-530 (`pullback_iso_construction`): `lean_verify` ⇒ `sorryAx`. Disclosure at L521-529 is honest about the substantive content remaining and explains why a single substantive sorry (vs 4 internal sorries) is the right choice this iter (typeclass synthesizer fails through `let`-bound `d`). Documentation excellent; tier claim accurate.
  - L536-540 (`pullback_iso`): one-line wrap `⟨pullback_iso_construction g 𝒜⟩`. Sound.
  - L550-554 (`base_change`): one-line existence via the two helpers. Sound.
  - L578-580 (`functor`): concrete `Over.mk`-based body. Sound.

### AlgebraicJacobian/RiemannRoch/OCofP.lean (focus file)

- **outdated comments**: 8 flagged
- **suspect definitions**: 2
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - L36-45, L195-205, L239-247, L259-265: iter-{176..181} status embeds.
  - L140-148 (`lineBundleAtClosedPoint`): `noncomputable def ... := sorry` returning a `Sheaf`. **Suspect (same pattern as `WeilDivisor.sheafOf` and `hilbertPolynomial`):** body sorry on a non-Prop-returning def means downstream signatures referring to this carrier are semantically tied to an opaque "the" value. Acceptable per blueprint scaffold pattern with explicit disclosure (L37-49).
  - L154-162 (`toFunctionField`): same pattern. **The composition `∃ s, toFunctionField P hP s = f` becomes vacuous** until `toFunctionField`'s body lands (since `toFunctionField _ _ s` is the same opaque element regardless of `s`). This is acknowledged in iter-181 Lane A disclosure (L195-205, L239-247); the *fix* is queued for iter-182+. Acceptable as honest disclosure.
  - L206-222 (`globalSections_iff_mp`): NEW helper, directional forward split of the iff. Substantive type. Body `sorry` ("Mathlib gap — body gated on upstream"). NOT laundering — it captures one direction independently of the other so iter-182+ can attack each in parallel.
  - L249-266 (`globalSections_iff_mpr`): NEW helper, directional backward. Same justification.
  - L305-318 (`globalSections_iff`): the assembled iff. Signature reviewed against the iter-180 RHS-without-bound-variable bug. **Both sides DO reference the bound hypotheses**: LHS uses `P`, `hPcoh`, `f`; RHS uses `P`, `hP`, `f`. ✓ Fix applied correctly.
  - L355-360 (`h1_vanishing_genusZero`): `:= by sorry`. Substantive type. Acceptable.
  - L390-395 (`dim_eq_two_of_genusZero`): `:= by sorry`. Substantive type. Acceptable.
  - L442-453 (`exists_nonconstant_genusZero`): `:= by sorry`. Substantive existence with 4 bullets. Acceptable.

### AlgebraicJacobian/RiemannRoch/RRFormula.lean (focus file)

- **outdated comments**: 5 flagged
- **suspect definitions**: 1
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - L33-43, L65-81, L141-145, L209-231, L297-303: iter-{174..181} status embeds.
  - L124-132 (`Scheme.eulerCharacteristic`): concrete `(finrank H⁰) - (finrank H¹)` body. Sound.
  - L168-171 (`Scheme.WeilDivisor.sheafOf`): `noncomputable def ... := sorry`. Same suspect-but-disclosed scaffold pattern. The χ-identity downstream depends on this body, so the consumer chains carry `sorryAx`. Acceptable per disclosure.
  - L192-193 (`Scheme.WeilDivisor.l`): concrete one-liner `Module.finrank kbar (Scheme.HModule kbar (sheafOf D) 0)`. Sound (modulo `sheafOf`).
  - L236-251 (`Scheme.eulerCharacteristic_sheafOf_zero`): NEW iter-181 Lane H helper #1. Base case χ-identity. Body `:= by sorry`. Substantive claim (`χ(sheafOf 0) = 1 - g`). NOT laundering — captures the Hartshorne I.3.4 input. Acceptable.
  - L261-280 (`Scheme.eulerCharacteristic_sheafOf_single_add`): NEW Lane H helper #2. Inductive step `χ(sheafOf (single Y n + D)) = χ(sheafOf D) + n`. Body `:= by sorry`. Substantive claim (Hartshorne IV.1.3 SES additivity, iterated). NOT laundering — captures the inductive content.
  - L304-333 (`Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus`): `lean_verify` ⇒ `sorryAx` (transitively from the two helpers). The body is honest 25-LOC `Finsupp.induction` consuming the two helpers + `linarith`. Tier disclosure at L298-303 matches.
  - L354-368 (`Scheme.WeilDivisor.l_eq_degree_plus_one_of_genus_zero`): substantive RR formula, body specialises the χ-identity with hypotheses `_hg`, `_hH1`. Concrete + correct.

### AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean (focus file)

- **outdated comments**: 4 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - L35-50, L86-94, L322-344, L334-344: iter-{177,181} status embeds.
  - L218-257 (`morphismToP1OfGlobalSections`): substantive concrete body via `Proj.fromOfGlobalSections` + section-condition chase. ~40 LOC. Sound construction.
  - L310-320 (`morphism_degree_via_pole_divisor`): substantive existence type. Body `:= sorry`. Acceptable.
  - L400-414 (`iso_of_degree_one`): **iter-181 Lane I signature refinement landed correctly.** The hypothesis is now `[Algebra C'.functionField C.functionField]` + `Module.finrank C'.functionField C.functionField = 1`. The iter-178 lean-auditor finding 178A (excuse-comment "abstract iso wrapper is strictly weaker") is *fully addressed*: the new docstring (L335-344) discusses the past refinement as a past decision; the NEW signature does NOT contain any "TODO/wrong/will fix" excuse-comment language. Verified clean.

### AlgebraicJacobian/AbelJacobi.lean

- **outdated comments**: 0 — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: -

### AlgebraicJacobian/Differentials.lean

- **outdated comments**: minor — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: -

### AlgebraicJacobian/Genus.lean

- **outdated comments**: 0 — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: -

### AlgebraicJacobian/Genus0BaseObjects.lean

- **outdated comments**: 0 — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: Thin re-export wrapper.

### AlgebraicJacobian/Jacobian.lean

- **outdated comments**: 5 — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: Many iter references in docstrings; uses sorry-bodies for outline declarations (12 sorries). Same blueprint-skeleton pattern.

### AlgebraicJacobian/Rigidity.lean

- **outdated comments**: 5 (iter-1XX status embeds) — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: -

### AlgebraicJacobian/RigidityKbar.lean

- **outdated comments**: 5 — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: 3 sorries, all in blueprint-pinned declarations.

### AlgebraicJacobian/RigidityLemma.lean

- **outdated comments**: 15 — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: Heavy iter-{157..162} embeds in docstrings; the proof chain is the iter-162 "axiom-clean" landing. Most lemmas verifiably kernel-clean per project memory.

### AlgebraicJacobian/Albanese/AlbaneseUP.lean

- **outdated comments**: 21 — **suspect definitions**: 1 (`Pic0.jacobianScheme` file-internal placeholder, L152+, explicitly disclosed) — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: File-internal placeholder for A.3 (`Pic⁰_{C/k̄}`). Disclosed and bounded.

### AlgebraicJacobian/Albanese/CodimOneExtension.lean

- **outdated comments**: 4 — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: 8 sorries; blueprint-skeleton pattern.

### AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean

- **outdated comments**: 12 — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: Two private helpers (`av_isIntegral_of_smooth_geomIrred`, `av_codimOneFree_of_indeterminacy`) added iter-180 Lane G splitting `av_isIntegral_and_codimOneFree`'s sorry. Each helper captures a substantive sub-claim. NOT laundering — the splits localise the missing math to Mathlib gaps (Smooth → IsReduced and codim-≥2 of Milne 3.1 not exposed).

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean

- **outdated comments**: minor — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: -

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean

- **outdated comments**: minor — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: Comment at L504 mentions "axiom set" — informational, not a real `axiom` declaration.

### AlgebraicJacobian/Cohomology/SheafCompose.lean

- **outdated comments**: 0 — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: -

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean

- **outdated comments**: 0 — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: -

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean

- **outdated comments**: 0 — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: Re-export wrapper.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean

- **outdated comments**: minor — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: -

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean

- **outdated comments**: minor — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: -

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/SheafProperty.lean

- **outdated comments**: minor — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: -

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean

- **outdated comments**: 32 — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 1 (L25 "iter-145 `: True := sorry` placeholders ... intentionally omitted" — historical note, not active)
- **notes**: Heavy iter status embeds (the file is 459 LOC); these belong in git history. Comment at L25 references a *removed* anti-pattern (`: True := sorry`) — it's a historical note clarifying why something is absent, not an active excuse-comment. Borderline acceptable. L331 "standing premise for a future char-p reactivation" is a documentation note, not an excuse.

### AlgebraicJacobian/Cotangent/GrpObj.lean

- **outdated comments**: 48 (!) — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: 9 sorries; very dense iter status embed.

### AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean

- **outdated comments**: 4 — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: 4 sorries (e.g. `ProjectiveLineBar.isProper`, `projectiveLineBar_geomIrred`), all blueprint-pinned scaffold.

### AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean

- **outdated comments**: 3 — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: -

### AlgebraicJacobian/Picard/FGAPicRepresentability.lean

- **outdated comments**: 15 — **suspect definitions**: 2 (file-internal placeholders `picSharp`, `divFunctor` at L123, L137 — disclosed; their job is to supply types until sibling chapters land) — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: 17 sorries; blueprint scaffold pattern. The placeholders are *file-internal* by docstring, not consumed externally.

### AlgebraicJacobian/Picard/FlatteningStratification.lean

- **outdated comments**: 17 — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: 9 sorries; blueprint scaffold.

### AlgebraicJacobian/Picard/LineBundlePullback.lean

- **outdated comments**: 20 — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: 16 sorries; blueprint scaffold.

### AlgebraicJacobian/Picard/RelPicFunctor.lean

- **outdated comments**: 23 — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 1 (L231 — only real TODO in the tree: `-- TODO (A.1.b gate): close once \`LineBundle.OnProduct\` is upgraded`)
- **notes**: 20 sorries; the L231 TODO is gated on a sibling chapter, so it's a real dependency note, not an excuse-comment about wrongness. Borderline minor.

### AlgebraicJacobian/RiemannRoch/WeilDivisor.lean

- **outdated comments**: 12 — **suspect definitions**: 0 — **dead-end proofs**: 0 — **bad practices**: 0 — **excuse-comments**: 0
- **notes**: 4 sorries; blueprint scaffold.

## Must-fix-this-iter

None. The new helpers added this iter all encapsulate substantive Mathlib gaps with documented strategies; they are NOT renames of the original sorry. The `lean_verify` axiom checks confirm every kernel-cleanness claim made in the iter-181 task results matches the actual axiom set on the verified declarations. No new project `axiom` declarations were introduced.

## Major

- **Pervasive iter-status-block embedding in docstrings (all focus files; ~417 cumulative `iter-1XX` references across 27 files).** Each modified declaration carries a `Status (iter-NNN ...)` paragraph in its docstring. This is the project's chosen workflow, but at this scale it has turned a substantial fraction of source comments into a paper trail belonging in git history / iter sidecars (`iter/iter-NNN/`). Recommend either (i) demoting these to a single bottom-of-file block, or (ii) periodically pruning closed-iter notes (e.g. drop iter-1XX status once 3 iters out). Not blocking, but degrades readability.

- **`noncomputable def ... := sorry`-on-non-`Prop` carriers create silently-vacuous downstream relations.** Six load-bearing carriers in this category:
  - `OCofP.lean:140` `lineBundleAtClosedPoint`
  - `OCofP.lean:154` `lineBundleAtClosedPoint.toFunctionField` — **the most acute case**: `globalSections_iff_mp/mpr` both depend on `toFunctionField P hP s = f`. Until `toFunctionField` has a real body, this equation is comparing two opaque-but-uniform "the" values, so the iff is mathematically vacuous, not merely sorry-propagating.
  - `RRFormula.lean:168` `WeilDivisor.sheafOf`
  - `QuotScheme.lean:170` `hilbertPolynomial`
  - `QuotScheme.lean:208` `QuotFunctor`
  - `QuotScheme.lean:245` `Grassmannian`

  All six are honestly disclosed in their file docstrings as the blueprint-pinned scaffold pattern. NOT must-fix because the project has consciously adopted this pattern, but downstream consumers should be flagged once any of these bodies lands — every `sorryAx`-modulo-this lemma needs re-audit at that point.

- **`AVR.lean:373` `_hf` hypothesis on `rigidity_genus0_curve_to_grpScheme` is consumed correctly** (via L383 `hpoint`) — this is not a finding, just a positive note. The prior iter-157/158 "_hf-laundering" concern is addressed and stayed addressed.

- **`Thm32RationalMapExtension.lean:194` inline `sorry` for `IsReduced A.left`.** This is the substantive Mathlib gap `Smooth → IsReduced` over a field. Documented; not a rename. Acceptable.

## Minor

- `AbelianVarietyRigidity.lean:30` docstring says "Still a scaffold `sorry`" — this references `gmScalingP1` which is now concrete. The "scaffold `sorry`" wording is stale.
- `AbelianVarietyRigidity.lean:50` "The signatures of declarations 1–3 are **provisional** (`SCAFFOLD` comments mark them)" — no `SCAFFOLD` comments appear in this file's source. Stale.
- `RelPicFunctor.lean:231` `-- TODO (A.1.b gate): close once \`LineBundle.OnProduct\` is upgraded from a typed-sorry to a substantive line-bundle structure.` This is the only real-style TODO in the tree. It's a dependency note (gated on a sibling file), not an excuse-comment about local wrongness. Acceptable as minor; could be moved to a project TODO list.
- `Cotangent/ChartAlgebra.lean:25` "iter-145 `: True := sorry` placeholders and is intentionally omitted" — historical breadcrumb about a removed anti-pattern. Not actively misleading but worth pruning.
- `GmScaling.lean:177` uses `set_option backward.isDefEq.respectTransparency false in` — documented workaround for the `pullbackSpecIso_hom_base` heartbeat sink, recipe from `analogies/pullbackspeciso-bypass.md`. Acceptable workaround but worth flagging because the option's necessity is a Mathlib upstream issue worth tracking.
- Single-letter set-option suppressions: `set_option linter.style.setOption false` in `GmScaling.lean:31`, `Points.lean:28` — these silence the lint that flags `set_option ... in` usage. The lint is what notices the `respectTransparency` workaround; silencing it loses signal. Consider scoping the suppression more narrowly.

## Excuse-comments (always called out separately)

None this iter. The iter-178 finding 178A (`RatCurveIso` excuse-comment on Pin 3 signature) has been fully retired by the iter-181 Lane I signature refactor; the new docstring (L335-344, L370-371) discusses the refactor as a past decision without residual "TODO/wrong/will fix" wording. The L231 TODO in `RelPicFunctor.lean` and the L25 historical note in `ChartAlgebra.lean` are dependency / archival notes, not excuse-comments about active wrongness.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 4
- **minor**: 6
- **excuse-comments**: 0 (the prior iter's 178A finding is now retired)

Overall verdict: **Solid iter — all advertised kernel-cleanness claims verify against `lean_verify`, no new project axioms, no laundering helpers, and the prior excuse-comment in `RationalCurveIso` is fully retired by the Lane I signature refactor.**
