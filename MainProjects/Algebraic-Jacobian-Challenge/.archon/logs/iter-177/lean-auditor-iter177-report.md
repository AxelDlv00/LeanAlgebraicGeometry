# Lean Audit Report

## Slug
iter177

## Iteration
177

## Scope
- files audited: 38 (every `.lean` file under the project tree outside `.archon/`, `.lake/`, `.git/`)
- files skipped (per directive): 0

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure import shim (30 LOC).

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All three protected declarations (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`) project cleanly from `(jacobianWitness C).isAlbaneseFor P`; sorries live upstream in `Jacobian.lean`'s witness.

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 named sorries
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `iotaGm_isDominant` L86–89: `:= sorry`. Top-level bridge gated on `gmScalingP1` body landing — named, isolated.
  - `genusZero_curve_iso_P1` L290–296: `:= sorry`. Honest RR-bridge sorry.
  - Both sorries documented as load-bearing; the surrounding proofs are real, no laundering.

### AlgebraicJacobian/Albanese/AlbaneseUP.lean (NEW, focus file)
- **outdated comments**: none
- **suspect definitions**: 1 (a `Bundle`-carrier sorry; see notes)
- **dead-end proofs**: 6 typed sorries on substantive pinned declarations
- **bad practices**: file imports `Mathlib` whole-cloth
- **excuse-comments**: many "iter-178+ body" / "iter-177 file-skeleton" / "TODO" patterns inside docstrings — admissions
- **notes**:
  - L139–183 introduces a `Bundle` placeholder structure plus `bundle C := sorry` carrier for `Pic⁰_{C/k̄}`. The four typeclass instances (L191-201) all derive from `(bundle C).field`, so the sorry propagates to every consumer. This is an honest file-internal placeholder ("Helper budget = 1") but it is a load-bearing typed sorry that gates the entire chapter.
  - `abelJacobi` L240–242, `SymmetricPower` L287–292, `symmetricPowerAVMap` L322–327, `symmetricPowerToJacobian` L362–365, `descentThroughBirationalSigma` L401–409, `albanese_universal_property` L466–473 — six sorries on substantive `def`/`theorem` declarations. Each has a docstring "iter-178+ body" admission.
  - Types ARE non-tautological (concrete morphisms / `∃!` existential structures); the file-skeleton discipline is preserved at the signature level.
  - `SymmetricPower` L287–292 takes `(_g : ℕ)` and discards it (the `_g` underscore-prefix), making the resulting "symmetric power" independent of `g`. Implementation defect at the signature level — even the typed sorry's *target type* is too coarse to distinguish `Sym^g C` from `Sym^h C`.

### AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean
- **outdated comments**: none
- **suspect definitions**: 2 sorry-bodied defs (`Module.depth`, `Module.projectiveDimension`)
- **dead-end proofs**: 5 sorry-bodied theorems
- **bad practices**: `projectiveDimension` body explicitly declines a known one-line proof ("we leave it as a typed `sorry` to keep the file-skeleton uniform" — uniformity over correctness)
- **excuse-comments**: many "iter-176+: body is" patterns
- **notes**:
  - `depth` L130–132, `projectiveDimension` L168–170: both typed sorries on `ℕ∞` / `WithBot ℕ∞`. `projectiveDimension` could be one-liner.
  - `depth_eq_smallest_ext_index` L210–219, `depth_of_short_exact` L250–268, `auslander_buchsbaum_formula` L308–316, `CohenMacaulay.depth_eq_krullDim` field L342–343, `CohenMacaulay.of_regular` L378–381: load-bearing sorries.

### AlgebraicJacobian/Albanese/CodimOneExtension.lean (NEW, focus file)
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 4 sorry-bodied theorems
- **bad practices**: file imports `Mathlib` whole-cloth
- **excuse-comments**: "iter-178+ body" patterns inside docstrings
- **notes**:
  - `indeterminacyLocus` L134–135 and `CodimOneFree` L168–169 are real defs (non-sorry).
  - `isClosed_indeterminacyLocus` L139–142 is a real proof.
  - 4 substantive theorems sorry: `localRing_dvr_of_codim_one` L195–203, `extend_of_codimOneFree_of_smooth` L243–255, `indeterminacy_pure_codim_one_into_grpScheme` L284–298, `extend_iff_order_nonneg` L346–360.
  - Types are substantive (DVR instance, `∃!`-existence, disjunction, iff).

### AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 sorry-bodied theorem
- **bad practices**: none
- **excuse-comments**: "iter-176+ proof skeleton" / "iter-176+:" in docstring
- **notes**:
  - `extend_to_av` L162–173 `:= by sorry`. Single pinned theorem, gated on its two sibling lemmas in `CodimOneExtension.lean`.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 627 LOC, sorry-free.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 711 LOC, sorry-free. L504–505 mentions "axiom set" only as commentary about `propext`/`Classical.choice`/`Quot.sound`; no `axiom` declarations introduced.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 49 LOC, sorry-free.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 63 LOC, sorry-free.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 30 LOC import shim, sorry-free.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Sorry-free.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Sorry-free.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/SheafProperty.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Sorry-free.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 1 historical mention of removed `: True := sorry` placeholders (L25, narrative)
- **notes**:
  - 459 LOC of substantive proofs (KDM theorem, constants-integral-over-base, scheme-level lift). Sorry-free.
  - Multiple "deferred to iter-148+" / "currently a deferred sub-piece" mentions in docstrings refer to *signature refinements*, not body sorries — distinguish from excuse-comments on declared but unfilled work.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 631 LOC, sorry-free. Real proofs in `cotangentSpaceAtIdentity`, `cotangentSpaceAtIdentity_eq_extendScalars`, `cotangentSpaceAtIdentity_finrank_eq`, `shearMulRight`, etc.
  - L552–560 and L624–629 are "iter-145 EXCISE" comment blocks documenting deleted declarations — not dead code, just historical breadcrumbs. Mild noise; consider trimming in a future cleanup pass.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 144 LOC, sorry-free. `smooth_locally_free_omega` has an honest disclosure about the reverse direction being false without H¹-vanishing input.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 45 LOC, sorry-free, single concrete `genus` definition.

### AlgebraicJacobian/Genus0BaseObjects.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 27 LOC import shim, sorry-free.

### AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 sorry-bodied instances
- **bad practices**: none
- **excuse-comments**: 2 instances of "Project-side scaffold sorry; ... plan-marked acceptable for iter-165"
- **notes**:
  - `projectiveLineBar_geomIrred` L154–156, `projectiveLineBar_smoothOfRelDim` L161–163: both honest scaffold sorries on instances. Plan-acknowledged.

### AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 380 LOC of substantive ring-iso construction. Sorry-free.

### AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean (focus file)
- **outdated comments**: 2 stale (`gmScalingP1_over_coherence` docstring; `gmScalingP1` docstring — claims sorry-content that no longer holds after the axiom refactor)
- **suspect definitions**: 2 NAMED AXIOMS on load-bearing chart-bridge content
- **dead-end proofs**: 2 sorry-bodied instances (`gm_geomIrred`, `projGm_isReduced`)
- **bad practices**: introducing TEMPORARY axioms in place of sorry without a published authorization in `archon-protected.yaml` or strategy
- **excuse-comments**: explicit `**TEMPORARY AXIOM (iter-177 HARD STOP corrective)**` and `TODO (iter-178+): replace by ...` on both axioms — admissions
- **notes**:
  - **L196–219 `axiom gmScalingP1_chart_data_temp`** — TEMPORARY axiom standing in for both the chart over-coherence identity AND the chart cocycle agreement. Docstring openly states "The mathematical content is correct... currently blocked by Mathlib API question." The `_temp` suffix and the TODO are explicit confessions. This axiom is consumed by `gmScalingP1_chart_PLB_eq` (L232–235) and `gmScalingP1_chart_agreement` (L246–252) which were previously sorry-bodied.
  - **L308–311 `axiom gmScalingP1_collapse_at_zero_temp`** — TEMPORARY axiom standing in for the load-bearing fixed-point property `σ_×(0, λ) = 0`. Same `_temp` + TODO pattern. Consumed by `gmScalingP1_collapse_at_zero` (L323–327).
  - These two axioms are the **same severity as load-bearing sorries** — they assert mathematical facts the body cannot prove yet, and they unblock downstream propagation (`gmScalingP1_collapse_at_zero` is the W-axis collapse that `morphism_P1_to_grpScheme_const_aux` consumes via Cor 1.5 in `AbelianVarietyRigidity.lean`). Replacing `sorry` with `axiom` does NOT improve correctness — it converts a known-incomplete proof into an asserted-true fact. Strategically, this is *worse* than the sorry it replaces, because Lean's axiom check (`#print axioms`) will continue to flag every downstream theorem.
  - **L260–266 `gmScalingP1_over_coherence` docstring is STALE**: claims "the helper itself is partially proven (Steps A + B closed axiom-clean; Step C bridge-chasing has a residual `sorry`...)". After iter-177, the helper `gmScalingP1_chart_PLB_eq` is no longer "partially proven via Step A/B/C" — it is discharged via the axiom. The docstring's description of the proof state is no longer accurate.
  - **L278–290 `gmScalingP1` docstring is STALE**: claims "body skeleton with three internal `sorry`s, each at a named declaration (no buried sorries)". After iter-177 those internal sorries have been replaced by *axiom calls*. The docstring still describes the sorry shape.
  - `gm_geomIrred` L403–405 `:= by sorry`, `projGm_isReduced` L433–437 `:= by sorry` — honest instance scaffolds.
  - `projGm_geomIrred` L415–419 calls `GeometricallyIrreducible.comp _ _` with two implicit holes; relies on instance synthesis to plug `gm_geomIrred` + `projectiveLineBar_geomIrred`. Works only because those instances are in scope; the bare `_ _` shape obscures the assumed inputs.

### AlgebraicJacobian/Genus0BaseObjects/Points.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 sorry-bodied instance (`gm_grpObj`)
- **bad practices**: none
- **excuse-comments**: "Scaffold body — same discipline as `ga_grpObj`" (where `ga_grpObj` is not in the file)
- **notes**:
  - `gm_grpObj` L251 `:= sorry`. Consumed by `gm_smooth` L255–258. Per the memory log this has been deferred ≥4 iters (iter-167 watch fires).
  - L246–251 docstring references `ga_grpObj` as a discipline analogue but no `ga_grpObj` exists in this file (search confirms it does not exist in the project either). Stale reference.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 named sorries (`genusZeroWitness.key`, `positiveGenusWitness`)
- **bad practices**: none
- **excuse-comments**: explicit "M3 work, currently OFF-CRITICAL-PATH" / "user-escalation-pending"; honestly framed
- **notes**:
  - `genusZeroWitness` L198–248: inline `key : f = toUnit C ≫ η[A] := by sorry` at L235–236. The surrounding scaffold (terminal-object witness fields, uniqueness via `Flat.epi_of_flat_of_surjective`) is real proof.
  - `positiveGenusWitness` L270–274: `:= sorry`. Honest M3 placeholder.
  - The "Forbidden shortcut (sanity check)" comment at L44–52 explicitly documents a known pitfall — exemplary documentation of a *non*-applied wrong definition.

### AlgebraicJacobian/Picard/FGAPicRepresentability.lean
- **outdated comments**: none
- **suspect definitions**: 2 file-internal **placeholder defs** (`picSharp`, `divFunctor`); plus 3 more pinned `def`/`theorem` sorries; 1 sorry-bodied `instance`
- **dead-end proofs**: 5 typed sorries on substantive pinned declarations + 2 placeholder-def sorries
- **bad practices**: file imports `Mathlib`; explicitly admits forward-referencing placeholders to dodge import order
- **excuse-comments**: multiple "File-internal placeholder" / "Once the sibling files land" / "iter-177+: the body" patterns
- **notes**:
  - L132–135 `picSharp := sorry` and L147–150 `divFunctor := sorry`: typed-sorry forward-reference shims for declarations that already exist (or will exist) elsewhere. Once `RelPicFunctor.lean`'s `PicSharp` and `QuotScheme.lean`'s `divFunctor` land, these collapse to re-exports. Until then, every theorem in this file consuming them is technically vacuous (sorry-typed inputs).
  - `PicScheme` L187–189, `abelMap` L226–231, `smoothProperQuotient` L278–291, `representable` L324–329, `groupSchemeStructure` L363–368: 5 substantive sorries.

### AlgebraicJacobian/Picard/FlatteningStratification.lean
- **outdated comments**: none
- **suspect definitions**: none (the `CoherentSheafFlat` def is real)
- **dead-end proofs**: 6 sorry-bodied theorems
- **bad practices**: file imports `Mathlib`; uses `IsProper π` as structural stand-in for `IsProjective` (acknowledged in docstring)
- **excuse-comments**: many "iter-177+: the body follows..." patterns; "stand-in" terminology at L111 (acknowledged but flagged)
- **notes**:
  - `CoherentSheafFlat` L170–174 is a real `def`.
  - 6 substantive sorry theorems: `genericFlatness` L208, `flatLocusStratification` L252, `flatLocusReduction` L280, `flatLocusAssembly` L310, `flatteningStratification` L358, `flatteningStratification_universal` L399, `flatteningStratification.ofCurve` L438.
  - Type signatures are substantive existentials over indexed families with disjointness/covering/flatness conjuncts.

### AlgebraicJacobian/Picard/LineBundlePullback.lean
- **outdated comments**: none
- **suspect definitions**: 1 **type-level sorry** (`OnProduct : Type (u+1) := sorry`)
- **dead-end proofs**: 4 sorry-bodied theorems/defs
- **bad practices**: type-level sorry propagates to every downstream consumer in the file (and to `RelPicFunctor.lean` via `RelPicPresheaf.preimage_subgroup`)
- **excuse-comments**: many "iter-175+: instantiate as..." / "For the iter-174 file-skeleton" patterns
- **notes**:
  - L119–121 `OnProduct ... : Type (u+1) := sorry` — typed sorry **at the type level**. Every term-level sorry below is constructing values in this opaque type. The file's "Note on type expressivity" docstring explicitly defends this choice ("encode `OnProduct` by a typed `sorry` at the type level") but it is the strongest possible weakening: not only is the proof missing, the *carrier* is missing.
  - `pullbackAlongProjection` L150–152, `pullback_pullback_eq` L204–214, `preimage_subgroup` L261–264, `functorial` L309–312: all bodies sorry. The first three depend on the `OnProduct` type-level sorry.

### AlgebraicJacobian/Picard/QuotScheme.lean (focus file)
- **outdated comments**: none
- **suspect definitions**: none on real defs; `hilbertPolynomial` / `QuotFunctor` / `Grassmannian` are sorry-bodied
- **dead-end proofs**: 6 sorry-bodied declarations (incl. `canonicalBaseChangeMap_isIso`)
- **bad practices**: imports `Mathlib`; `IsProper π` as stand-in for `IsProjective π` (acknowledged)
- **excuse-comments**: many "iter-177+: the body" / "For the iter-176 file-skeleton" patterns
- **notes**:
  - `hilbertPolynomial` L170–173, `QuotFunctor` L208–212, `Grassmannian` L245–248: typed sorries on definitions returning `Polynomial ℚ` / `(Over S)ᵒᵖ ⥤ Type u`. Not laundering — substantive sorries on substantive target types.
  - `Grassmannian.representable` L272–275, `QuotScheme` L326–330: sorry-bodied existence theorems.
  - **`canonicalBaseChangeMap` L409–420 IS A REAL DEFINITION** — built via `CategoryTheory.mateEquiv`. Not a sorry. The directive's "helper-with-sorry pattern" concern resolves here: the structural construction is honest, the deep math is isolated.
  - **`canonicalBaseChangeMap_isIso` L437–457 `:= by sorry`** — this is the substantive Stacks 02KH content, factored cleanly into one named sorry. Pattern is **NOT laundering**: the factoring is honest — the named helper isolates the math gap while `canonicalBaseChangeMap` and `flatBaseChangeCohomology` are real terms.
  - `flatBaseChangeCohomology` L459–470 is a real proof via `⟨@asIso _ _ _ _ _ (canonicalBaseChangeMap_isIso sq F)⟩` — consumes the `IsIso` witness honestly.
  - Verdict on the directive's question: the encoding is clean. The one substantive sorry sits at the named load-bearing helper, exactly where it should.

### AlgebraicJacobian/Picard/RelPicFunctor.lean (focus file)
- **outdated comments**: none
- **suspect definitions**: 6 sorry-bodied declarations
- **dead-end proofs**: 6 sorries (1 `instance`, 4 `def`, 1 `theorem`)
- **bad practices**: imports `Mathlib`; declares 2 functorial defs (`PicSharp` and `PicSharp.presheaf`) with identical signatures and the docstring openly says `presheaf` "re-exports `PicSharp`" — **probable duplicate API**
- **excuse-comments**: explicit "TODO (A.1.b gate): close once `LineBundle.OnProduct` is upgraded..." L231–234; many "iter-177+: the body" patterns
- **notes**:
  - `PicSharp.addCommGroup` L205–235: `exact sorry` body inside a `by` block. Docstring explicitly enumerates a TODO gate.
  - `PicSharp` L284–287 and `PicSharp.presheaf` L370–373: both return `(Over (Spec (.of k)))ᵒᵖ ⥤ AddCommGrpCat.{u+1}`, both sorry, and the second's docstring says it "either re-exports `PicSharp` (if the `AddCommGrpCat`-valued functor is built directly in §2) or constructs the functor". One of these will end up redundant — a parallel-API smell.
  - `PicSharp.functorial` L323–328, `PicSharp.etSheaf` L429–433, `PicSharp.etSheafUnit` L478–482: more sorries.
  - L65–73 docstring documents a **blueprint-vs-Lean name collision** (`AlgebraicGeometry.Scheme.PicScheme` collision with `FGAPicRepresentability.lean`); flagged for plan/review to fix in blueprint. Acknowledged but not yet acted on.

### AlgebraicJacobian/Picard/RelativeSpec.lean
- **outdated comments**: none
- **suspect definitions**: **`RelativeSpec` body is the identity-on-`X` — a weakened-wrong definition** standing in for the relative-spectrum scheme; **`RelativeSpec.structureMorphism` body is `𝟙 X`** — also weakened-wrong
- **dead-end proofs**: 0 *sorry*-bodied proofs in the file, but downstream theorems (`UniversalProperty`, `affine_base_iff`, `base_change`) all "compile" only because the underlying definitions are degenerate
- **bad practices**: this is the canonical pattern the auditor charter calls out: "weakened-wrong definitions" + downstream proofs that exploit the degeneracy
- **excuse-comments**: "the body therefore commits to the simplest valid inhabitant `X` itself, matching the *placeholder-with-substantive-downstream-type* pattern" (L161–162); "iter-175+: the eventual body builds..." — multiple admissions
- **notes**:
  - L172–173 `noncomputable def RelativeSpec {X : Scheme.{u}} (_𝒜 : X.QcohAlgebra) : Scheme.{u} := X`. The relative-spectrum carrier is defined as the trivial re-export of `X`, **independent of `𝒜`**.
  - L192–194 `noncomputable def RelativeSpec.structureMorphism (_𝒜 : X.QcohAlgebra) : X.RelativeSpec _𝒜 ⟶ X := 𝟙 X`. The structure morphism is identity.
  - L227–237 `UniversalProperty` "proves" `IsAffineHom (𝟙 X)` because the definition makes it the identity.
  - L259–267 `affine_base_iff` "proves" `IsAffine (Spec R)` after `change IsAffine (Spec R)` — exploiting the wrong def.
  - L295–311 `base_change` exhibits a fake pullback iso via `pullback.fst g (𝟙 X) : pullback g (𝟙 X) ≅ T`.
  - Pattern: an entire chapter that "compiles green" because the carrier is degenerate. Every downstream theorem looks closed but proves nothing about the actual relative spectrum. The exceptional `_𝒜 : X.QcohAlgebra` argument is silently discarded.
  - This is exactly the must-fix profile under "Weakened-wrong definitions". The file has no `sorry` but is *less honest* than one with sorries — at least `sorry` flags the gap to `#print axioms`. Wrong-but-compiles is worse.

### AlgebraicJacobian/RiemannRoch/OCofP.lean (focus file, KNOWN BROKEN BUILD)
- **outdated comments**: none
- **suspect definitions**: 1 (`lineBundleAtClosedPoint := sorry`)
- **dead-end proofs**: 5 sorry-bodied declarations
- **bad practices**: imports `Mathlib`; file does NOT compile (per directive)
- **excuse-comments**: many "iter-177+ body:" patterns
- **notes**:
  - `lineBundleAtClosedPoint` L140–148, `globalSections_iff` L191–204, `h1_vanishing_genusZero` L241–246, `dim_eq_two_of_genusZero` L276–281, `exists_nonconstant_genusZero` L325–336: 5 substantive sorries.
  - L335 references `Scheme.WeilDivisor.principal` which fails to synthesize `Scheme.IsRegularInCodimensionOne C.left` — this is the known build break per the directive. Per directive instruction, NOT re-flagged here.
  - **STRUCTURAL SMELL related to the build break**: the file's `exists_nonconstant_genusZero` directly threads `Scheme.WeilDivisor.principal` in its conclusion, requiring `[Scheme.IsRegularInCodimensionOne C.left]`. The file does not declare this typeclass as a hypothesis on the lemma. Either (a) the typeclass needs to be added to the lemma signature, or (b) the conclusion needs to be reformulated to avoid `principal`. The blueprint-style docstring at L315–319 introduces `Scheme.WeilDivisor.principal` only at the very end ("The principal-divisor-non-zero formulation `Scheme.WeilDivisor.principal f hf ≠ 0` follows from non-constancy..."), suggesting it may have been bolted on after the signature was fixed.

### AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean (NEW, focus file)
- **outdated comments**: none
- **suspect definitions**: 1 (`iso_of_degree_one` hypothesis uses `≅` between Type-level fields where ring iso is intended)
- **dead-end proofs**: 3 sorry-bodied declarations
- **bad practices**: imports `Mathlib`
- **excuse-comments**: many "iter-178+ body:" patterns inside docstrings
- **notes**:
  - `morphismToP1OfGlobalSections` L198–206, `morphism_degree_via_pole_divisor` L259–269, `iso_of_degree_one` L319–332: 3 substantive sorries.
  - **L329–330 TYPE WEAKENING in `iso_of_degree_one`**: the hypothesis `_hφ_ff : Nonempty (C'.left.functionField ≅ C.left.functionField)`. `functionField : Type u` (a `Field`-typed term, not a `CommRingCat` object), so `≅` is `CategoryTheory.Iso` in the `Type u` category — i.e., an `Equiv`/set-bijection. The docstring at L294 promises a "ring isomorphism `φ^# : K(C') → K(C)` ... bijective". A set-bijection between two infinite fields is automatic from cardinality — substantively weaker than the ring iso the proof needs. **The signature should use `≃+*`** (or `Iso` in `CommRingCat`) to capture the ring structure preservation.

### AlgebraicJacobian/RiemannRoch/RRFormula.lean
- **outdated comments**: none
- **suspect definitions**: 1 typed sorry on a sheaf-valued helper (`sheafOf`)
- **dead-end proofs**: 2 sorry-bodied theorems
- **bad practices**: imports `Mathlib`; `sheafOf` is a project-internal "placeholder for `RR.3`" whose body is `sorry` — feeds the entire chapter's downstream signature
- **excuse-comments**: explicit "typed-`sorry` placeholder" at L74; "placeholder for `RR.3`" L155
- **notes**:
  - `eulerCharacteristic` L124–132 is a real concrete `def`.
  - `sheafOf` L168–171: typed sorry on `Sheaf (...) (ModuleCat.{u} kbar)`. Consumed by `l`, `eulerCharacteristic_eq_degree_plus_one_minus_genus`, and `l_eq_degree_plus_one_of_genus_zero`. Once a sorry-typed sheaf, every cohomology computation derived from it is implicitly nondetermined.
  - `l` L192–193 is a real `def` consuming the sorry-typed sheaf.
  - `eulerCharacteristic_eq_degree_plus_one_minus_genus` L224–232, `l_eq_degree_plus_one_of_genus_zero` L253–264: substantive sorries.

### AlgebraicJacobian/RiemannRoch/WeilDivisor.lean (focus file)
- **outdated comments**: none
- **suspect definitions**: 1 typeclass with a misleading name
- **dead-end proofs**: 2 substantive sorries (`rationalMap_order_finite_support`, `principal_degree_zero`)
- **bad practices**: imports `Mathlib`; `Scheme.IsRegularInCodimensionOne` exports the weaker `KrullDimLE 1`, not "regular in codim 1"
- **excuse-comments**: "Mathlib-upstream-pending gap" comments around `rationalMap_order_finite_support`
- **notes**:
  - **L173–186 typeclass `Scheme.IsRegularInCodimensionOne`** — the name promises "regular in codim 1" (every codim-1 stalk is regular, i.e., a DVR), but the `out` field only requires `Ring.KrullDimLE 1 (stalk Y.point)` for every prime divisor `Y`. The docstring acknowledges: "For a regular-in-codim-1 scheme the stalk is in fact a DVR; we only export the weaker Krull-dim bound here". **The name is misleading** — it asserts more than the typeclass actually carries. Risk: downstream consumers (like `OCofP.lean`'s broken `exists_nonconstant_genusZero`) will be tempted to draw DVR conclusions that the bound alone does not justify. Recommend renaming to `Scheme.HasKrullDimLEOne` (or similar) OR strengthening the `out` field to require DVR. Bridge-class smell, not parallel-API smell — but the naming gap is a future-bug.
  - `Scheme.PrimeDivisor` L92–97 (structure), `Scheme.WeilDivisor` L105 (def): real declarations.
  - `Scheme.RationalMap.order` L152–156: real concrete def via `WithZero.log ∘ Ring.ordFrac`.
  - `rationalMap_order_finite_support` L205–210 `:= by sorry`. Load-bearing — Hartshorne II.6.1 finiteness, openly a "Mathlib-pending gap".
  - `Scheme.WeilDivisor.ofClosedPoint` L244–246: real concrete def with junk-on-off-branch convention. The L233 docstring explicitly says "junk-defined outside its intended scope" — that's an acknowledged design choice, not laundering.
  - `principal` L326–331 is a real concrete def consuming the sorry-bodied finite-support witness.
  - `principal_hom` L345–388: real proof with `map_one'`/`map_mul'` bodies threaded through `WithZero.log_one`/`WithZero.log_mul`. Sorry-free at this level.
  - `principal_degree_zero` L407–414 `:= sorry`. Hartshorne Cor 6.10 / Stacks 0BE3.
  - `LinearEquivalence` L433–435: real concrete def.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 123 LOC, sorry-free. The "Hypothesis history" block (L43–79) is an exemplary record of why the original point-wise hypothesis was strengthened to scheme-level equality (Frobenius counterexample) — good documentation discipline.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: 1 sorry-bodied theorem
- **dead-end proofs**: 1
- **bad practices**: none
- **excuse-comments**: "iter-126 scaffold — body is a single `sorry`. ... gated on the shared cotangent-vanishing Mathlib pile" — honest framing
- **notes**:
  - `rigidity_over_kbar` L75–88 `:= sorry`. Acknowledged fallback artifact superseded by `AbelianVarietyRigidity.lean` per the memory log; left in tree intentionally.

### AlgebraicJacobian/RigidityLemma.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 902 LOC. **Sorry-free in active proofs.** The 4 occurrences of the substring "sorry" (L455, 475, 666, 756) are all documentary comments explaining historical proof state — no actual `sorry` term in the file.

## Must-fix-this-iter

Apply verbatim; every one of these meets a must-fix criterion in the auditor charter.

- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:212` — `axiom gmScalingP1_chart_data_temp` standing in for the chart-bridge over-coherence + cocycle agreement. Why must-fix: a project-introduced axiom on substantive mathematical content not authorized in `archon-protected.yaml`; `_temp` suffix + "TEMPORARY AXIOM (iter-177 HARD STOP corrective)" docstring + "TODO (iter-178+): replace by chart-bridge body" — explicit confessions. Strictly worse than the sorry it replaces (downstream theorems consuming it no longer flag in `#print axioms` triage if anyone forgets the `_temp` keyword).
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:308` — `axiom gmScalingP1_collapse_at_zero_temp` standing in for the load-bearing fixed-point property `σ_×(0, λ) = 0`. Why must-fix: same as above; this axiom is the W-axis collapse consumed by Cor 1.5 in `AbelianVarietyRigidity.lean` via `morphism_P1_to_grpScheme_const_aux`, so it propagates through the entire genus-0 rigidity chain.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:172` — `def RelativeSpec (_𝒜 : X.QcohAlgebra) : Scheme := X`. Why must-fix: weakened-wrong definition. The relative-spectrum carrier is defined as the trivial re-export of `X`, independent of `𝒜`. The `_𝒜` argument is silently discarded. Every downstream "theorem" in the file (`UniversalProperty`, `affine_base_iff`, `base_change`) compiles only because of this degeneracy.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:192` — `def RelativeSpec.structureMorphism (_𝒜 : X.QcohAlgebra) : ... ⟶ X := 𝟙 X`. Why must-fix: weakened-wrong definition; structure morphism is identity, again `_𝒜`-independent. Together with L172 this enables the file to "compile green" while proving nothing about the actual relative spectrum.
- `AlgebraicJacobian/Picard/LineBundlePullback.lean:119` — `def OnProduct (...) : Type (u+1) := sorry`. Why must-fix: type-level sorry. The carrier type itself is undefined. Every term-level construction `(... : OnProduct ...)` and every theorem with `OnProduct` in its signature is built on an opaque axiom-tainted Type. Stronger than a body sorry — the *type signature* is not honest about what it returns.
- `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean:330` — `_hφ_ff : Nonempty (C'.left.functionField ≅ C.left.functionField)`. Why must-fix: type weakening. `functionField` is `Type u`, so `≅` is set-iso (`Equiv`), not ring iso. Two infinite fields are always set-isomorphic by cardinality, so the hypothesis as written is *substantively trivial* — the lemma claims that a non-constant morphism between smooth proper curves with set-isomorphic function fields is a scheme iso, which is mathematically false (function fields of different transcendence degree can be set-isomorphic). Use `≃+*` or `Iso` in `CommRingCat`.

## Major

- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:260-266` — stale docstring on `gmScalingP1_over_coherence` claims the helper has "Step C bridge-chasing has a residual `sorry`"; the helper has since been routed through the iter-177 axiom and no Step A/B/C state remains. Refresh.
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:278-290` — stale docstring on `gmScalingP1` claims "body skeleton with three internal `sorry`s, each at a named declaration"; iter-177 replaced two of those sorries with axiom calls. The "three internal sorries" claim is no longer accurate.
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:173-186` — `Scheme.IsRegularInCodimensionOne` class name claims more than the `out` field carries. Rename to `HasKrullDimLEOneAtPrimeDivisors` (or strengthen the `out` to encode DVR-ness). Downstream consumers will be tempted to draw DVR conclusions from a name suggesting they have them.
- `AlgebraicJacobian/Picard/RelPicFunctor.lean:284, 370` — `PicSharp` and `PicSharp.presheaf` have identical signatures and the docstring on the second openly says it "re-exports `PicSharp`". One of them is destined to be redundant; pick now to avoid parallel APIs.
- `AlgebraicJacobian/Albanese/AlbaneseUP.lean:287-292` — `SymmetricPower C (_g : ℕ) := sorry` discards the parameter `_g`. Even at the file-skeleton stage the *type* of `SymmetricPower` should depend on `g` (e.g. via a dependent return that records the degree), otherwise the carrier cannot distinguish `Sym^2 C` from `Sym^3 C`.
- `AlgebraicJacobian/Genus0BaseObjects/Points.lean:246-251` — docstring on `gm_grpObj` references `ga_grpObj` as a discipline analogue; no `ga_grpObj` exists in the project. Stale comment.
- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:165-167` — docstring on `projectiveDimension` explicitly says the body is left as a typed sorry "to keep the file-skeleton uniform", despite the body being a one-line re-export. Prefer the one-liner over uniformity-as-excuse.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:552-560, 624-629` — historical "iter-145 EXCISE" comment blocks describe removed declarations. Trim in a future cleanup pass; they add no value to the current state.

## Minor

- All 8 file-skeleton files (`Albanese/AlbaneseUP.lean`, `Albanese/CodimOneExtension.lean`, `Albanese/AuslanderBuchsbaum.lean`, `Albanese/Thm32RationalMapExtension.lean`, `Picard/FGAPicRepresentability.lean`, `Picard/FlatteningStratification.lean`, `Picard/LineBundlePullback.lean`, `Picard/QuotScheme.lean`, `Picard/RelPicFunctor.lean`, `Picard/RelativeSpec.lean`, `RiemannRoch/OCofP.lean`, `RiemannRoch/RationalCurveIso.lean`, `RiemannRoch/RRFormula.lean`, `RiemannRoch/WeilDivisor.lean`) import `Mathlib` whole-cloth. Build cost compounds across the bundle; consider per-import directives once bodies start landing.
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:415-419` — `projGm_geomIrred` is `GeometricallyIrreducible.comp _ _`. The bare `_ _` shape works via instance resolution but obscures the dependency on `gm_geomIrred` (itself a sorry) and `projectiveLineBar_geomIrred` (also a sorry). Spelling the two arguments out would make the propagation path explicit at the call site.
- `AlgebraicJacobian/Picard/FGAPicRepresentability.lean:65-73` — known naming collision between `RelPicFunctor.PicSharp.etSheaf` and `FGAPicRepresentability.PicScheme` documented as a `Note on naming` in the chapter for plan/review to resolve. Track until resolved.

## Excuse-comments (always called out separately)

These document the project lying to itself. Each lands at must-fix or major above; called out separately for visibility.

- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:196`: "**TEMPORARY AXIOM (iter-177 HARD STOP corrective)** — chart-bridge data. ... TODO (iter-178+): replace by chart-bridge body when the ... defeq + Fin normalization is resolved." Severity: **critical** (on `gmScalingP1_chart_data_temp`, load-bearing axiom).
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:299`: "**TEMPORARY AXIOM (iter-177 HARD STOP corrective)** — the load-bearing fixed-point property of `σ_×`. ... TODO (iter-178+): replace by chart-1 ring-map computation once the chart-bridge body lands." Severity: **critical** (on `gmScalingP1_collapse_at_zero_temp`, load-bearing axiom).
- `AlgebraicJacobian/Picard/RelativeSpec.lean:159-167`: "the body therefore commits to the simplest valid inhabitant `X` itself, matching the *placeholder-with-substantive-downstream-type* pattern" — admission that the carrier is degenerate. Severity: **critical** (on the load-bearing `RelativeSpec` definition).
- `AlgebraicJacobian/Picard/RelPicFunctor.lean:231-234`: "TODO (A.1.b gate): close once `LineBundle.OnProduct` is upgraded from a typed `sorry` to a concrete structure..." Severity: major (on `PicSharp.addCommGroup`).
- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:165-167`: "we leave it as a typed `sorry` to keep the file-skeleton uniform" on `Module.projectiveDimension`. Severity: major.
- `AlgebraicJacobian/Picard/LineBundlePullback.lean:118-121`: "For the iter-174 file-skeleton this is a typed `sorry` at the type level because Mathlib `b80f227` ships no `IsInvertible` predicate on `Scheme.Modules`." Severity: critical (type-level sorry on `OnProduct`).
- `AlgebraicJacobian/Picard/FGAPicRepresentability.lean:117-121, 137-150`: two "File-internal placeholder ... once the sibling files land" patterns on `picSharp` and `divFunctor`. Severity: major.
- Multiple "iter-178+ body" / "iter-177+ body" / "For the iter-176 file-skeleton" patterns sprinkled across `Albanese/AlbaneseUP.lean`, `Albanese/CodimOneExtension.lean`, `Albanese/AuslanderBuchsbaum.lean`, `Albanese/Thm32RationalMapExtension.lean`, `Picard/FlatteningStratification.lean`, `Picard/QuotScheme.lean`, `Picard/RelPicFunctor.lean`, `Picard/LineBundlePullback.lean`, `RiemannRoch/OCofP.lean`, `RiemannRoch/RRFormula.lean`, `RiemannRoch/RationalCurveIso.lean`, `RiemannRoch/WeilDivisor.lean`. Severity: major individually; cumulatively a project-wide "scheduled-for-later" debt pattern.

## Severity summary

- **must-fix-this-iter**: 6 — these block downstream work in their files until addressed.
- **major**: 8
- **minor**: 3
- **excuse-comments**: 7+ distinct sites (also counted under must-fix-this-iter or major above).

**Overall verdict**: The iter-177 prover phase introduced two **TEMPORARY axioms** on load-bearing genus-0 content, which is a hard regression versus the sorries they replaced — `axiom` does not flag in `#print axioms` cleanly because the project does not have a published "named-temp-axiom" review process. The pre-existing `Picard/RelativeSpec.lean` weakened-wrong definitions (`RelativeSpec := X`, `structureMorphism := 𝟙 X`) and the `OnProduct := sorry` type-level sorry in `Picard/LineBundlePullback.lean` are the worst-of-class chapter-level smells in the project and must be paid down before any of A.1.b, A.1.c, A.2.b, A.2.c, A.2.a can be trusted. The new `RationalCurveIso.lean` ships a type-weakening (`functionField ≅ functionField` as `Type`-iso, not `≃+*`) that should be tightened before any body lands on `iso_of_degree_one`. Outside these specific must-fix sites, the proven chapters (`Cotangent/*`, `Cohomology/*`, `Rigidity.lean`, `RigidityLemma.lean`, `Genus0BaseObjects/ChartIso.lean`, `AbelianVarietyRigidity.lean`, `Jacobian.lean`) are in good shape: real proofs, honest sorries where present, no laundering.
