# Lean Audit Report

## Slug
iter205

## Iteration
205

## Scope
- files audited: 45
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure import aggregator. No declarations.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three declarations (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`) all reduce cleanly to `(jacobianWitness C).isAlbaneseFor P`. Bodies are sorry-free. No issues.

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Large file (~1067 LOC). Multiple named honest sorries (`kbarChart1Ring_specMap_fac` L438, `iotaGm_chart1_appIso_eval` L646), all clearly labelled with precise gap descriptions (Proj.appIso evaluation chain). Six project-local Mathlib supplement lemmas (`Proj.awayι_preimage_basicOpen_self`, `Proj.awayι_eq_specMap_fromSpec`, `Proj.basicOpenIsoSpec_inv_app_top`, `Proj.awayι_app_basicOpen`, `Proj.awayι_appIso_top_inv`) are axiom-clean. `iotaGm_isDominant` correctly deferred via named `iotaGm_range_isOpen`. File-level sorry count is controlled; no comment overstates closure. SCAFFOLD comments (`-- SCAFFOLD`) used appropriately. No issues.

### AlgebraicJacobian/Albanese/AlbaneseUP.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Pic0.bundle : Bundle C := sorry` is the single infrastructure placeholder; clearly labeled as gated on A.3. Projection defs (`jacobianScheme_grpObj` etc.) demoted from `instance` per lean-auditor iter-196 must-fix — correctly implemented. `albanese_universal_property` body is sorry-free assembly from `descentThroughBirationalSigma` + `albanese_eq_iff_symmetricPower_eq`. All sorry bodies carry precise gap descriptions; none overstate closure.

### AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Extensive content (~3434 LOC). `depth` has a genuine substantive body (sSup definition, not sorry). `depth_eq_smallest_ext_index` proof is largely closed with axiom-clean content; backward direction assembles to `le_sSup`. Large suite of axiom-clean substrate helpers: `depth_eq_of_linearEquiv`, `MvPolynomial.maximalIdeal_height_eq_natCard`, `ringKrullDim_localization_atMaximal_MvPolynomial`, `cotangent_iso_*`, `finrank_cotangentSpace_*`. Remaining sorries (`auslander_buchsbaum_formula`, `CohenMacaulay.of_regular`) are honest named typed sorries gated on the Jacobian-regular-sequence witness (iter-201+ Lane COE). No issues.

### AlgebraicJacobian/Albanese/CodimOneExtension.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Very large file with extensive axiom-clean substrate helpers for Stacks 00TT/02JK/00OE chain. `isReduced_of_smooth_over_field` correctly isolated as a named sorry for the Stacks 034V/02G4 Mathlib gap (previously an inline sorry; demoted per prior auditor must-fix). `av_codimOneFree_of_indeterminacy` sorry in branch 2 is correctly labeled as a project gap (codim-≥2 conclusion of Milne 3.1 not yet exposed as standalone lemma). No issues.

### AlgebraicJacobian/Albanese/CoheightBridge.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All four declarations (`coheight_eq_of_isOpenEmbedding`, `coheight_spec_eq_height_primeSpectrum`, `ringKrullDim_stalk_eq_coheight`, `ringKrullDimLE_of_coheight_eq_one`) are axiom-clean. Proofs are correct and close cleanly.

### AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `isReduced_of_smooth_over_field` properly named as a Mathlib gap sorry. `av_codimOneFree_of_indeterminacy` sorry documented precisely. `extend_to_av` body is sorry-free. No issues.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorries found. Content appears axiom-clean.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorries found. Content appears axiom-clean.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorries found.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorries found.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorries found.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorries found.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorries found.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/SheafProperty.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorries found.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorries found. Previously had `True := sorry` placeholders (iter-145); those are gone.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Has 3 named concrete sorries (per grep output: naturality and inverse-direction sorry, `IsIso` of inverse map). All labeled as narrowly-scoped concrete sorries; iter-137 noted a 1→3 sorry split (hollow → focused). No issues.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Has named sorries gated on the body of `genusZero_curve_iso_P1` (downstream). Properly documented.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Has named sorries gated on cohomology computations. Properly labeled.

### AlgebraicJacobian/Genus0BaseObjects.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Import aggregator for Genus0BaseObjects submodules. No declarations beyond imports.

### AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `ProjectiveLineBar.geomIrred_of_algClosed` at L220 is a typed sorry labeled "Project-side scaffold sorry" — honest.

### AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Has a sorry at L480. Context: typed-sorry instance scaffolding for `ProjectiveLineBar`. Honestly labeled.

### AlgebraicJacobian/Genus0BaseObjects/Cross01Substrate.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorries per grep.

### AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Sorries at L771 and L944 (and others); all three noted as named honest sorries in file header. The file header comment "three internal `sorry`s, each at a named declaration (no buried sorries)" is accurate and honest.

### AlgebraicJacobian/Genus0BaseObjects/Points.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorries per grep.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: 1 flagged (stale comment about `genusZeroWitness` body)
- **suspect definitions**: 1 flagged
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Jacobian C := (jacobianWitness C).J` and `nonempty_jacobianWitness` with sorry body. The file header notes "Two `sorry`-bodied declarations (the Phase-C scaffolding)". The comment "The terminal-object definition ... is mathematically wrong for any curve of genus ≥ 1" (line 49 area) accurately acknowledges the current wrong state, and explains it is the Phase-C sorry absorbing the full geometric content. No excuse-comments per se; the comment is honest about the wrongness. The prior `genusZeroWitness.key` body at L236 is sorry (labeled "iter-172 scaffold"). No new issues this iter.

### AlgebraicJacobian/Picard/FGAPicRepresentability.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Six pinned declarations all sorry-bodied; carrier defs isolated via `Classical.choose` from Prop-valued typeclasses (iter-196 carrier-soundness probe, Option A pattern). Properly structured.

### AlgebraicJacobian/Picard/FlatteningStratification.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Eight sorry-bodied declarations; all properly labeled as file-skeleton scaffold.

### AlgebraicJacobian/Picard/IdentityComponent.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Five sorry-bodied declarations; properly labeled as file-skeleton scaffold.

### AlgebraicJacobian/Picard/LineBundlePullback.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Five sorry-bodied declarations; properly labeled. `IsLocallyTrivial` iter-187 substrate correctly noted.

### AlgebraicJacobian/Picard/Pic0AbelianVariety.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Five sorry-bodied declarations; file-skeleton scaffold. Properly labeled.

### AlgebraicJacobian/Picard/QuotScheme.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Six sorry-bodied declarations; file-skeleton scaffold. Properly labeled.

### AlgebraicJacobian/Picard/RelPicFunctor.lean
- **outdated comments**: none
- **suspect definitions**: 2 flagged
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 2 flagged
- **notes**:
  - **[MUST-FIX, RE-CONFIRMED]** `PicSharp` at L327–330: defined as `(CategoryTheory.Functor.const _).obj (AddCommGrpCat.of (PUnit.{u+2}))`. This is a constant functor at the trivial group `PUnit`, NOT the intended `T ↦ Pic(C ×_k T)/π_T^* Pic(T)`. This is a weakened-wrong definition. The finding from prior audit is confirmed still live: the `PicSharp` definition is mathematically wrong for any non-trivial input.
  - **[MUST-FIX]** `PicSharp.functorial` at L372–377: returns `0` (the zero `AddMonoidHom`). This is a weakened-wrong definition. The correct functor morphism action is the descended `(id_C ×_k g)^*` pullback, but `0` is returned unconditionally.
  - **[EXCUSE-COMMENT]** Docstring for `PicSharp` (L311–326) says: "This is a sorry-free placeholder used while the file-local `addCommGroup` sorry in §1 is open" and "The trivial target is harmless: downstream consumers...work with the *group-valued* presheaf signature, not with the specific assignment on objects, so this placeholder unblocks the file-skeleton and lets the sheafification machinery elaborate axiom-cleanly." These are excuse-comments: they admit the definition is wrong while attempting to rationalize the wrongness away.
  - **[EXCUSE-COMMENT]** Docstring for `PicSharp.functorial` (L351–370): "iter-198 Lane RPF closure: the body is the zero AddMonoidHom. The math-correct construction...needs the AddCommGroup operations on the quotient to be concrete...This is gated on the same upstream Mathlib upgrade." Admitting a wrong body is in place, with rationalization.
  - LSP confirms only 1 sorry warning at L235 (`addCommGroup`). The `PicSharp` and `functorial` definitions elaborate without errors, precisely because the wrong values typecheck.

### AlgebraicJacobian/Picard/RelativeSpec.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `RelativeSpec` and `structureMorphism` bodies are the canonical Mathlib values (iter-179 Block A). Three downstream theorems have honest sorry bodies pending Block B rewrites. No issues.

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 2 flagged (minor)
- **excuse-comments**: none
- **notes**:
  - **[FOCUS FILE — NEW DECLARATIONS IN `MathlibSupplementMonoidalSheafification`]**

  **Assessment of `isMonoidal_W_of_whiskerLeft` (L417–428, `@[implicit_reducible]`):**
  This is honest infrastructure, NOT a disguised placeholder. The body implements `W.IsMonoidal` with:
  - `whiskerLeft F _ _ g hg := hwl hg F` — direct from the hypothesis (trivially correct)
  - `whiskerRight {F₁ F₂} f hf G := (... .arrow_mk_iso_iff (Arrow.isoMk (β_ F₁ G) (β_ F₂ G))).2 (hwl hf G)` — derives right-whiskering from left-whiskering via the symmetric braiding of `PresheafOfModules`, using `arrow_mk_iso_iff` (an existing Mathlib tool for converting morphism-property membership through isomorphisms). The argument is mathematically correct: `f ▷ G` is isomorphic to `G ◁ f` via the braiding, and `W` is stable under isos (it's the `inverseImage` of `J.W` which is a localising class closed under isos), so `W (G ◁ f)` ← `hwl` implies `W (f ▷ G)` via the iso. Verdict: genuine, sound.

  **Assessment of `monoidalCategoryOfIsMonoidalW` (L446–453, `@[implicit_reducible]`):**
  Body is `inferInstanceAs (MonoidalCategory (LocalizedMonoidal (L := sheafification α) (W := (J.W).inverseImage (toPresheaf _)) (Iso.refl _)))`. This correctly delegates to `Localization.Monoidal.instMonoidalCategoryLocalizedMonoidal` once `[W.IsMonoidal]` is available as an instance. Not a placeholder — it is the transport half of the monoidal infrastructure, axiom-clean once its typeclass assumption is supplied. Verdict: genuine, sound.

  **`@[implicit_reducible]` soundness:** This is a VALID Lean 4 core attribute. The Lean LSP itself emits the warning "Definition of class type must be marked with `@[reducible]` or `@[implicit_reducible]`" (verified: L323 warning for `addCommGroup_via_tensorObj`). Using `@[implicit_reducible]` on the two new class-type definitions is correct Lean practice.

  **No comment laundering on any of the four pre-existing sorry bodies:**
  - `monoidalCategory` (L150): "iter-202 Lane TS scaffold: body is a typed `sorry`; iter-203+ body discharges coherence axioms affine-locally" — accurate
  - `tensorObj_restrict_iso` (L264): "Left as a named typed `sorry` feeding `tensorObj_isLocallyTrivial`; see task result for the precise missing instance statement" — accurate, docstring even enumerates the exact Mathlib-absent ingredient
  - `exists_tensorObj_inverse` (L304): "iter-202 Lane TS scaffold: typed `sorry`; iter-203+ body builds the dual and contraction isomorphism" — accurate
  - `addCommGroup_via_tensorObj` (L342): "iter-202 Lane TS scaffold: typed `sorry`. This is the iter-204+ closure target for the residual `addCommGroup` sorry of `RelPicFunctor.lean` (L235)" — accurate, also correctly states dependency relationship

  **[MINOR — BAD PRACTICE]** Lines 113–191 use `CategoryTheory.Sheaf.val` which the LSP reports as deprecated ("Use `ObjectProperty.obj`"). Four occurrences in `tensorObj` (L114, L116), `tensorObj_functoriality` (L131), `tensorObjIsoOfIso` (L171, L173), and `tensorObj_unit_iso` (L188, L190). These are in the project's NEW definitions this iter. Not blocking but should be updated.

  **[MINOR — BAD PRACTICE]** `addCommGroup_via_tensorObj` (L339) is a class-type `noncomputable def` returning `AddCommGroup (...)` but lacks the `@[implicit_reducible]` or `@[reducible]` attribute that Lean recommends for class-type defs. LSP warns about this at L323. The new declarations `isMonoidal_W_of_whiskerLeft` and `monoidalCategoryOfIsMonoidalW` correctly have `@[implicit_reducible]`; `addCommGroup_via_tensorObj` does not.

### AlgebraicJacobian/RiemannRoch/H1Vanishing.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Sorries at L178 (`Hartshorne III Lemma 2.4 typed sorry`) and L618 (`extension-by-zero j_! typed sorry`). Both clearly labeled as Tier-3 honest typed sorries with gap descriptions. No issues.

### AlgebraicJacobian/RiemannRoch/OCofP.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Has typed sorries at L1154, L1219, L1548, and L1699 area. All labeled as honest typed sorries gated on specific Mathlib gaps (Hartogs gluing, Γ=k̄, χ-identity). Docstrings accurately describe the missing content. No issues.

### AlgebraicJacobian/RiemannRoch/OcOfD.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Sorries at L141, L195, L244; Tier-3 honest typed sorries per file header. Honestly labeled.

### AlgebraicJacobian/RiemannRoch/RRFormula.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Sorries at L335, plus others. Labeled as honest typed sorries gated on `sheafOf` and Hⁱ infrastructure. No issues.

### AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Sorries at L153 (`genusZero_curve_iso_P1`), L477, L919, L976, L1139, L1709. All clearly labeled as named honest typed sorries with precise Mathlib gap descriptions (fibre-dimension argument, `IsNormalScheme` gap, etc.). Notable: typed-sorry instances for `IsRegularInCodimensionOne` at L1324 are correctly demoted from `instance` (per auditor-196 feedback). No issues.

### AlgebraicJacobian/RiemannRoch/WeilDivisor.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Nine sorry-bodied declarations; all file-skeleton typed sorries. Properly labeled.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Sorry at L88 for a rational-map domain membership lemma. Labeled "Status: iter-126 scaffold — body is a single `sorry`". Properly documented.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorries found per grep. Body appears axiom-clean; consumes `RigidityLemma` chain.

### AlgebraicJacobian/RigidityLemma.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File header says the whole chain is `sorry`-free (iter-159 status). Grep confirms no sorry keywords in proof bodies. Axiom-clean.

---

## Must-fix-this-iter

- `AlgebraicJacobian/Picard/RelPicFunctor.lean:330` — `PicSharp` is defined as `(CategoryTheory.Functor.const _).obj (AddCommGrpCat.of (PUnit.{u+2}))`, a constant functor at the trivial group. The intended definition sends `T ↦ Pic(C ×_k T)/π_T^* Pic(T)`. **Why must-fix:** this is a weakened-wrong definition — mathematically the definition says the relative Picard functor has value `PUnit` for every test scheme `T`, which contradicts the entire point of the A.1.c chapter. Downstream consumers (`PicSharp.presheaf`, `PicSharp.etSheaf`) inherit this wrong value. The finding from prior audit is confirmed live and unaddressed.

- `AlgebraicJacobian/Picard/RelPicFunctor.lean:377` — `PicSharp.functorial` returns `0` (the zero `AddMonoidHom`) for every morphism `g : T' → T`. The correct morphism action is the descended `(id_C ×_k g)^*` pullback on the relative Picard quotient. **Why must-fix:** weakened-wrong definition — the morphism component of the relative Picard presheaf is being replaced by the zero map, which is only correct when the source group is trivial (which it isn't, by design). This makes `PicSharp.presheaf` a correctly-typed but mathematically trivial functor that says nothing about the Picard groups.

---

## Major

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:113–191` — Four occurrences of `CategoryTheory.Sheaf.val` (deprecated; should be `ObjectProperty.obj`) in the new `tensorObj`, `tensorObj_functoriality`, `tensorObjIsoOfIso`, and `tensorObj_unit_iso` definitions. The Lean LSP emits deprecation warnings at L114, L131, L171, L175, L188, L190. These were introduced in this iter by the new definitions; should be updated before the deprecated API is removed.

---

## Minor

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:339` — `addCommGroup_via_tensorObj` is a class-type `noncomputable def` returning `AddCommGroup (...)` but lacks `@[implicit_reducible]` or `@[reducible]`. The Lean LSP warns about this at L323 ("Definition of class type must be marked with `@[reducible]` or `@[implicit_reducible]`"). The two new declarations in the same file (`isMonoidal_W_of_whiskerLeft`, `monoidalCategoryOfIsMonoidalW`) correctly carry `@[implicit_reducible]`; `addCommGroup_via_tensorObj` should too once it is filled.

---

## Excuse-comments (always called out separately)

- `AlgebraicJacobian/Picard/RelPicFunctor.lean:~315` (docstring for `PicSharp`): "This is a sorry-free placeholder used while the file-local `addCommGroup` sorry in §1 is open" and "The trivial target is harmless: downstream consumers...work with the *group-valued* presheaf signature, not with the specific assignment on objects, so this placeholder unblocks the file-skeleton and lets the sheafification machinery elaborate axiom-cleanly." Severity: **critical** — attached to a load-bearing definition (`PicSharp`) that is the object-level assignment of the entire relative Picard presheaf chapter.

- `AlgebraicJacobian/Picard/RelPicFunctor.lean:~358` (docstring for `PicSharp.functorial`): "iter-198 Lane RPF closure: the body is the zero AddMonoidHom. The `AddMonoidHom.zero` instance is provided whenever the codomain has an `AddCommGroup`...The math-correct construction — wrapping `RelPicPresheaf.functorial` with `map_zero` and `map_add` proofs...is gated on the same upstream Mathlib upgrade." Severity: **major** — admits wrong body, rationalizes it as gated.

---

## Severity summary

- **must-fix-this-iter**: 2 — these block downstream work in their files until addressed (see plan.md's per-file gate).
- **major**: 1 (deprecated API usage in new TensorObjSubstrate code)
- **minor**: 1 (missing `@[implicit_reducible]` on `addCommGroup_via_tensorObj`)
- **excuse-comments**: 2 (also counted under must-fix-this-iter above; called out separately because they document the project lying to itself). Critical: 1. Major: 1.

Overall verdict: The two new `noncomputable def`s in `TensorObjSubstrate.lean` are **honest infrastructure** — the `@[implicit_reducible]` attribute is valid Lean 4, neither declaration is a disguised placeholder, and no pre-existing sorry body carries misleading closure claims. The pre-existing must-fix in `RelPicFunctor.lean` (weakened-wrong `PicSharp := const PUnit` with excuse-comment) remains **unaddressed** and is confirmed live; a second must-fix (`PicSharp.functorial := 0`) is co-located and equally blocking.
