# Lean Audit Report

## Slug
iter195

## Iteration
195

## Scope

- files audited: 43 (every `.lean` file under `AlgebraicJacobian/` plus the top-level `AlgebraicJacobian.lean`)
- files skipped: 0

Audit sweep included the focus files from the directive (`AuslanderBuchsbaum.lean`, `H1Vanishing.lean`, `QuotScheme.lean`, `OCofP.lean`, `RationalCurveIso.lean`, `WeilDivisor.lean`) and a whole-project pass over the remaining 37 files. Sorry counts and structural patterns confirmed with `grep`.

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Import aggregator only.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Light file, no sorries, no concerns.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 0 sorries.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 0 sorries.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 0 sorries.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L88 carries one residual `sorry`. Tactic body otherwise reasonable; mathematically a routine descent / scalar-extension argument. No concern beyond the open sorry count itself.

### AlgebraicJacobian/RigidityLemma.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 4 sorries spread across the file body; signatures coherent.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: none (the `Classical.choice` use at L313 is correctly noncomputable and motivated)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 12 sorries, including `smoothOfRelativeDimension_genus` (L340) and `instGeometricallyIrreducible` (L347) — large headline theorems with deferred bodies but kosher typed bodies.

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: 1
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Heavy historical narrative comments referencing iter-182…iter-194 attempts at `Proj.appIso` (e.g. L177–L268, L312, L329–L347, L400, L449–L483). Comments accurately catalogue STUCK history and are still consistent with the current proof body; they should eventually be summarised once Lane E closes but are not currently misleading.
  - L290 holds the public `genusZero_curve_iso_P1` typed-sorry pin referenced by RationalCurveIso.lean L144. Pin is intentional and documented.

### AlgebraicJacobian/Albanese/AlbaneseUP.lean
- **outdated comments**: none
- **suspect definitions**: 1 (`Pic0.bundle` at L183 — `:= sorry` returning a typed `Bundle`)
- **dead-end proofs**: none
- **bad practices**: none (the placeholder is explicit and the file docstring L62–L76 declares the convention)
- **excuse-comments**: none (the docstring is explicit but does not present itself as a "TODO" excuse — it documents the dependency on a not-yet-formalised chapter)
- **notes**:
  - `:= sorry` term-mode body at L183 on a non-`Prop`-typed declaration: this is the standard `:= sorry` carrier flagged by the directive. `bundle` projects four typeclass instances (`instGrpObj`, `instIsProper`, `instSmooth`, `instGeomIrred`) at L191–L201, so a `sorryAx` axiom *will* propagate through typeclass synthesis to every consumer of `jacobianScheme`. This is mathematically unavoidable until the A.3 chapter lands, but worth re-confirming the audit awareness — see "Excuse-comments / sorry carriers" block below.

### AlgebraicJacobian/Albanese/CodimOneExtension.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 8 sorries, including the central Milne 3.1 extension theorem body (L526) and indeterminacy-related helpers (L723, L798). Bodies have substantive content; the file docstring L93 calls out the `Classical.choice ⟨witness⟩` *non-use* (the file does not actually use such placeholders).

### AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean (focus file)
- **outdated comments**: 1
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1
- **excuse-comments**: none
- **notes**:
  - Iter-195 added private helper `auslander_buchsbaum_formula_succ_pd` at L1115–L1131 carving the inductive step into a single named typed `sorry`. Substrate-gap docstring at L1071–L1101 is precise and the iter-196+ plan is concrete (4 named Stacks-tag pieces, ~250–500 LOC). Body delegation `exact auslander_buchsbaum_formula_succ_pd k _hpd` at L1215 is a clean carve-out.
  - Bad-practice flag (minor): `ideal_smul_top_pi_const` at L863–L864 and four sibling lemmas carry `[Fintype ι] [DecidableEq ι]` typeclasses. The directive flagged these as raising unused-hypothesis linter warnings. They are not unused in the *body* (`Submodule.sum_mem`, `Pi.single`, etc.), but the lake warning likely fires because `[DecidableEq ι]` is provable from `[Fintype ι]` via `Classical.decEq` and the file does not consume `[DecidableEq ι]` as a named arg. Cosmetic — does not affect kernel-cleanness.
  - L1133–L1215: the docstring of the main `auslander_buchsbaum_formula` still narrates the iter-193 / iter-194 / iter-195 progression in detail. Now that the inductive step is carved into the helper, the docstring's reference to "the iter-194 Lane G HARD BAR closure" (L1203–L1207) inside the body comment is still accurate for the `n = 0` branch. Pre-iter-195 narrative content at L1159–L1167 (referring to "iter-193 Lane G: structural scaffold") is becoming aged — could be trimmed to a single iter-195 status sentence.
  - L1696–L1819: `regularLocal_quotient_isRegularLocal_of_notMemSq` is dense (axiom-clean); body is internally coherent. No suspect content.
  - L1895–L2063: `notMem_minimalPrimes_of_regularLocal_succ` body is now substantive (~170 LOC closed) modulo the underlying `regularLocal_quotient_isRegularLocal_of_notMemSq` substrate. No suspect content.
  - L2329–L2439: `regularLocal_inductive_step` body uses `LinearEquiv.isRegular_congr` cleanly. iter-186 closure comment at L2416–L2422 is accurate.
  - L2493–L2531: `instance of_regular` body assembles cleanly from helpers. The named `sSup` argument is fine.

### AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean
- **outdated comments**: none
- **suspect definitions**: 1 (`haveI : IsReduced A.left := sorry` at L194 — term-mode `:= sorry` on an instance)
- **dead-end proofs**: none
- **bad practices**: 1
- **excuse-comments**: none
- **notes**:
  - L194: `haveI : IsReduced A.left := sorry` is a `:= sorry` carrier on a typeclass instance inside `av_isIntegral_of_smooth_geomIrred`. Per the directive's red-flag list ("`:= sorry` carriers that propagate `sorryAx` silently through typeclass synthesis"), this is exactly the kind of in-proof instance sorry that should be flagged. Mitigation: the helper is a private lemma and its consumer is identified, but the `sorryAx` will propagate every time the lemma is invoked. The docstring at L190–L195 is honest about the Mathlib gap (Stacks 034V/02G4).
  - 11 total sorries.

### AlgebraicJacobian/Albanese/CoheightBridge.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 0 sorries.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 0 sorries.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 0 sorries.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 0 sorries. Tiny aggregator.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 0 sorries.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/SheafProperty.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 0 sorries.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 0 sorries.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 0 sorries.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 0 sorries; the `Classical.choice` use at L514 is for a `Nonempty` class field (sanctioned in the docstring L500–L506 with explicit axiom audit).

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 0 sorries in code (the 9 grep hits at L39/155/433-487/626 are all inside comments).

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 2 sorries.

### AlgebraicJacobian/Genus0BaseObjects.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 0 sorries; tiny aggregator.

### AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 4 sorries; the iter-195 review note about `projectiveLineBar_smoothOfRelDim` (gating WeilDivisor.lean L753 instance route) is honest project-side substrate.

### AlgebraicJacobian/Genus0BaseObjects/Points.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 1 sorry.

### AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 0 sorries.

### AlgebraicJacobian/Genus0BaseObjects/Cross01Substrate.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 0 sorries.

### AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 11 sorries — large file; bodies sketched.

### AlgebraicJacobian/Picard/FGAPicRepresentability.lean
- **outdated comments**: 1
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 2 (file-internal placeholder defs)
- **notes**:
  - File docstring L75 + L110–L137 calls out two **file-internal placeholders** `picSharp` and `divFunctor` paired with typed sorries. They are documented as "placeholders for sibling-chapter functors" pending iter-178+ refinement. The wording "placeholder" is a minor flag: the project is using bespoke names for not-yet-formalised sibling-file functors. Mathematical content is honestly described; not classified as "weakened-wrong" because the type signatures match the eventual import target.
  - 17 sorries total.

### AlgebraicJacobian/Picard/FlatteningStratification.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 1 (file docstring L111 — "stand-in for projective")
- **notes**:
  - L111: comment notes `IsProper π` is used as a "structural stand-in for projective". This is a documented design decision matching the convention used across the Picard sub-build; it does not promise *anything* untrue about the type — `[IsProper π]` is a strict subset of the real condition needed. Major rather than must-fix because the type *is* weaker, not wrong; downstream consumers (curves) are all in the "automatic projective" regime.
  - 9 sorries.

### AlgebraicJacobian/Picard/RelPicFunctor.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1
- **excuse-comments**: 2
- **notes**:
  - L231: `-- TODO (A.1.b gate): close once \`LineBundle.OnProduct\` is upgraded from a` — a literal `TODO` comment inline. Lightly excuse-shaped but does point at a concrete blocker.
  - L422: `will fix \`J\` to the étale topology and unfold via` — colloquial "will fix" language inside a docstring. Major because it telegraphs an intended future modification (étale-sheafification refactor); does not make the current declaration false.
  - 20 sorries.

### AlgebraicJacobian/Picard/RelativeSpec.lean (focus file)
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 1
- **notes**:
  - L22 / L38: docstring history notes "the silently-discarding placeholder `RelativeSpec _𝒜 := X`, `structureMorphism _ := 𝟙 X`; the lean-auditor iter-177 flagged both CRITICAL `weakened-wrong`. iter-179 Block A lands … honest `sorry` bodies pending iter-179+ Block B rewrites". This describes a *historical* fix already in place — `RelativeSpec` and `structureMorphism` now have substantive bodies. Comment is accurate; flagging as a docstring excuse-marker only because the word "placeholder" still appears in surrounding documentation.
  - 7 sorries (5 in code, 2 in docstrings).

### AlgebraicJacobian/Picard/LineBundlePullback.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 1
- **notes**:
  - L106: "project-side stand-in for the missing Mathlib `IsInvertible` predicate on" — documented stand-in for absent Mathlib API. The project-side predicate matches Hartshorne's definition; not "weakened-wrong" in the same sense as a fake def, but worth keeping in mind.
  - 6 sorries.

### AlgebraicJacobian/Picard/QuotScheme.lean (focus file)
- **outdated comments**: none
- **suspect definitions**: 5
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 1
- **notes**:
  - L113: docstring stand-in note (same as FlatteningStratification — `IsProper π` for "projective π"); paired honestly.
  - Five core defs/theorems carry typed `sorry` bodies: `hilbertPolynomial` (L173), `QuotFunctor` (L212), `Grassmannian` (L248), `Grassmannian.representable` (L275), `QuotScheme` (L330). All are file-skeleton placeholders explicitly admitted by the docstring; the signatures are substantive (return types are functors / scheme existence, not `True` / `Unit`). Not classified as must-fix because (a) the signatures are non-tautological and (b) the file is a multi-iter substrate gap accepted by the strategy.
  - Iter-195 advance: `pullback_app_isoTensor_baseMap_sectionLinearEquiv` (L867) body now lands Stage 1 of the 6-stage Beck-Chevalley intertwining via `_step2_apply` (L1054); Stages 2-6 remain as a single `exact sorry` at L1065 with substrate gaps (N1)-(N4) documented in the docstring at L1023-L1032. Σ-pair refactor of `tildeIso_of_isQuasicoherent_isAffineOpen` (L641) and `pullback_tildeIso` (L562) provides characterizing identities so future provers can chain through the iso. Clean structural advance.
  - 39 sorries.

### AlgebraicJacobian/Picard/IdentityComponent.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1
- **bad practices**: 1
- **excuse-comments**: 1
- **notes**:
  - L391: "typed `sorry` to enable downstream consumers (sanctioned temporary sorry-count increase)" — an explicit excuse-comment marker. Documents that a sorry was added *because* downstream needs the symbol, not because the math is closed. The audit principle treats "sanctioned temporary sorry" with caution.
  - L546–L549: docstring honesty about a prior **instance**-style declaration silently propagating `sorryAx` through typeclass synthesis. Iter-194 demoted that to a `private theorem` per a prior lean-auditor must-fix. Useful historical record; the *fix is already in place*.
  - 24 sorries total — file is `Picard/IdentityComponent.lean`, deepest substrate gap is L479 `geometricallyConnected_of_connected_of_section` (Stacks 037Q / 04KV).

### AlgebraicJacobian/Picard/Pic0AbelianVariety.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 7 sorries; all on substantial pinned signatures, none on suspect bodies.

### AlgebraicJacobian/RiemannRoch/WeilDivisor.lean (focus file)
- **outdated comments**: none
- **suspect definitions**: 1
- **dead-end proofs**: 1
- **bad practices**: 1
- **excuse-comments**: none
- **notes**:
  - L746–L772: `instance instIsRegularInCodimOneProjectiveLineBar` carries a `sorry` body. This is the **classic `:= sorry` carrier propagating `sorryAx` silently through typeclass synthesis** that the directive flagged. Every consumer of `[Scheme.IsRegularInCodimensionOne (ProjectiveLineBar kbar).left]` (including the iter-195 `instIsRegularInCodimOneProjectiveLineBar`-using theorem `degree_positivePart_principal_eq_finrank` at L809) will silently pick up the axiom. The iter-195 advance ("refine ⟨fun Y => ?_⟩" at L762) exposes the per-prime-divisor obligation but does not close it. **must-fix** caveat below.
  - Iter-195 new helper `Finsupp.sum_max_zero_eq_sum_filter_pos` at L697–L709 is generic Finsupp arithmetic (kernel-clean), correctly placed in `_root_.Finsupp.` namespace. Useful clean substrate.
  - L809–L913 `degree_positivePart_principal_eq_finrank` body now closes 3 substantive sub-steps before residual `sorry` at L913: destructure `Y₀`, push through `degree_positivePart_eq_sum_max` + `Finsupp.sum_max_zero_eq_sum_filter_pos`, then rewrite via `principal_apply`. Comments at L862–L912 narrate the iter-195 progress accurately. Clean structural advance.
  - L538 in `principal_degree_zero`: residual `sorry` on Hartshorne II.6.10 non-constant branch.
  - 11 sorries total.

### AlgebraicJacobian/RiemannRoch/H1Vanishing.lean (focus file)
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Iter-195 advance: new `instance sheafCompose_preservesFiniteLimits` at L356–L376 (kernel-clean, via `Functor.preservesFiniteLimits_of_reflects_of_preserves` + the `sheafToPresheaf J B` reflection). Closes the `SAb.Exact` gap inside `Scheme.IsFlasque.shortExact_app_surjective` (L443–L517) via `Functor.preservesFiniteLimits_iff_forall_exact_map_and_mono`. Clean structural advance.
  - Sorries remaining at L144 (`constant_of_irreducible`), L584 (`injective_flasque`, Hartshorne III.2.4, requires `j_!`), L781 (`skyscraperSheaf_eq_pushforward_const`). All carry honest Tier-3 docstring annotations and are gated on Mathlib infrastructure.
  - The directive's deprecation note about `CategoryTheory.Sheaf.val` is observable: L102 `F.val.map`, L411–L425 / L533–L536 / L638–L648 all use `.val` against `Sheaf` objects. Mathlib at the project's pinned commit reportedly deprecates this in favor of `ObjectProperty.obj`. This produces compiler warnings, not errors. Cosmetic / migration debt; classified **minor**.
  - 12 sorries total.

### AlgebraicJacobian/RiemannRoch/RRFormula.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 1
- **notes**:
  - File docstring L76–L80 references the iter-175+ "typed-`sorry` placeholder" body for `WeilDivisor.sheafOf` (the typed-sorry pin in `OcOfD.lean`). Honest tracking.
  - 19 sorries (most narrative; ~5 substantive bodies).
  - L953: `F.val` deprecation occurrence (same Mathlib API deprecation as H1Vanishing).

### AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean (focus file)
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Iter-195 advance: new file-private helper `localParameterAtInfty_uniformiser_witness` at L463–L476 with 3-step closure-path docstring (L425–L460). Consumer `Hom.poleDivisor_degree_eq_finrank` body at L592–L643 now delegates via `exact localParameterAtInfty_uniformiser_witness kbar`. Net sorry count unchanged 1:1 from iter-194 (the inline `?hLPUnif` sorry was lifted into the helper). Honest carving.
  - The four Mathlib-gap helpers `phi_left_locallyQuasiFinite_of_finrank_one` (L870, body residual sorry at L895), `phi_left_toNormalization_isIso_of_isIntegralHom` (L909, axiom-clean via `inferInstance`), `phi_left_fromNormalization_isIso_of_smoothProper_finrank_one` (L938, sorry at L952), and `iso_of_degree_one` (L1008, body assembles from helpers cleanly) are well-decomposed.
  - 27 sorries (many in docstrings tracking iter narrative).

### AlgebraicJacobian/RiemannRoch/OCofP.lean (focus file)
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Iter-195 advance: inside `exists_nonconstant_rational_from_dim_eq_two` (L1323), six axiom-clean substeps land at L1364–L1416: `htF_zero` (L1364–L1368), `htF_smul` (L1369–L1377), `htF_add` (L1378–L1387), `hs₁_ne` (L1389–L1392), finite `Module` instance (L1394–L1396), `hN` finrank-of-span-singleton (L1399–L1402), extraction of `s` via `Submodule.exists_of_finrank_lt` (L1407–L1416). Residual `sorry` at L1441 covers (a) injectivity of `toFunctionField`, (b) order-condition extraction, (c) `principal f hf ≠ 0` via Stacks 02P0. Substrate-gap surface is well-documented at L1421–L1440.
  - 15 sorries total.

### AlgebraicJacobian/RiemannRoch/OcOfD.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1
- **excuse-comments**: 0
- **notes**:
  - L141: `if D = 0 then Scheme.toModuleKSheaf C else sorry` — branching where the `else`-branch is a typed `sorry`. Mathematically this is the "Cartier-divisor sheaf-of-rational-functions construction" that needs RR.3 + RR.1 to land; the `if-then-else` packaging is unusual but not weakened-wrong (the `D = 0` case really *is* trivial). Worth a structural cleanup once dependencies arrive, but not a soundness concern.
  - 13 sorries total.

## Must-fix-this-iter

- **`AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:746-772`** — `instance instIsRegularInCodimOneProjectiveLineBar` body is `sorry`. *Why must-fix:* per the directive's red-flag list, an `instance` declaration whose body is `sorry` propagates `sorryAx` silently through typeclass synthesis to every consumer of `[Scheme.IsRegularInCodimensionOne (ProjectiveLineBar kbar).left]`. Iter-195's `degree_positivePart_principal_eq_finrank` at L809 immediately consumes this instance (it's in the binder list at L817). This is the precise soundness-exposure pattern the iter-193 lean-auditor verdict identified for `Picard/IdentityComponent.lean` (L546–L549 docstring), and the fix there was demoting the instance to a `private theorem`. The same demotion is recommended here: replace `instance instIsRegularInCodimOneProjectiveLineBar` with `theorem isRegularInCodimOneProjectiveLineBar`, then thread it explicitly via `haveI := ...` at consumer sites until the body closes.

- **`AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean:194`** — `haveI : IsReduced A.left := sorry` inside `av_isIntegral_of_smooth_geomIrred`. *Why must-fix:* same `:= sorry` on typeclass pattern. The `IsReduced` instance flows out via `exact isIntegral_of_irreducibleSpace_of_isReduced A.left` at L195, making the conclusion `IsIntegral A.left` a sorry-derived statement that downstream consumers (which call this private lemma) inherit silently. Per the directive's red-flag list, this is the in-proof analogue of `:= sorry` carriers. Recommended fix: change `haveI` to a named `have` of the inhabitation Prop, then explicitly note the gap (Stacks 034V) at the call site. The body of the helper at L168–L195 is otherwise axiom-clean.

- **`AlgebraicJacobian/Albanese/AlbaneseUP.lean:183`** — `noncomputable def bundle : Bundle C := sorry` and the four typeclass instances at L191–L201 projecting from it. *Why must-fix:* the `instGrpObj`, `instIsProper`, `instSmooth`, `instGeomIrred` instances at L191–L201 derive from a `:= sorry` carrier and become silently propagated typeclass-synthesis axioms — every consumer of `jacobianScheme C` inherits a `sorryAx`. The docstring at L62–L80 is honest about the dependency on the A.3 chapter, so this is a known temporary state, but per the directive ("`:= sorry` carriers that propagate `sorryAx` silently through typeclass synthesis"), it lands at must-fix. Recommended mitigation: convert the four instances to named lemmas (e.g. `def jacobianScheme_grpObj : GrpObj (jacobianScheme C) := ...`), require consumers to thread them explicitly via `haveI := jacobianScheme_grpObj C`, and let the global `:= sorry` warning remain visible at the carrier rather than silently flowing into instance synthesis.

## Major

- **`AlgebraicJacobian/Picard/IdentityComponent.lean:391`** — Excuse-style comment: *"typed `sorry` to enable downstream consumers (sanctioned temporary sorry-count increase)."* The wording "sanctioned temporary" is project-policy language, but the practice — adding a `sorry` to unblock downstream — should be auditable. The fact that the same file at L546–L549 documents a prior incident where this exact pattern silently propagated `sorryAx` through typeclass synthesis (and required an iter-194 demotion) makes future such "sanctions" worth scrutinising.
- **`AlgebraicJacobian/Picard/RelPicFunctor.lean:231`** — `-- TODO (A.1.b gate): close once \`LineBundle.OnProduct\` is upgraded …`. Literal `TODO` comment. Concrete blocker named, but the inline TODO is the standard excuse-marker pattern.
- **`AlgebraicJacobian/Picard/RelPicFunctor.lean:422`** — `will fix \`J\` to the étale topology and unfold via …`. "Will fix" inside a docstring; indicates a planned signature/code change to a definition currently in the file, not a deferred Mathlib gap. Migration debt.
- **`AlgebraicJacobian/Picard/QuotScheme.lean:113`** and **`AlgebraicJacobian/Picard/FlatteningStratification.lean:111`** — "structural stand-in for projective" comments. Documented design decision (use `IsProper π` as a strict but logically-weaker substitute for "projective π"). Not "weakened-wrong" because the *signature* simply takes a weaker hypothesis than the eventual one; downstream curve consumers are all in the regime where the two coincide.
- **`AlgebraicJacobian/Picard/RelativeSpec.lean:22-38`** — file docstring still describes the "silently-discarding placeholder" body of `RelativeSpec` as a *prior-iter* state and the iter-179 Block A fix. Body in the current file is substantive; the docstring excerpt is historical but its lead lines could mislead a fresh reader that the placeholder is still present. Minor wording cleanup.
- **`AlgebraicJacobian/Picard/LineBundlePullback.lean:106`** — `project-side stand-in for the missing Mathlib \`IsInvertible\` predicate`. Documented stand-in; signature is honest (the project-side predicate is the bookkeeping name for the same mathematical condition Hartshorne uses).
- **`AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:1159-1167`** — narrative comments inside `auslander_buchsbaum_formula` body still describe the iter-193 structural scaffold split. With iter-195's carving of the inductive step into `auslander_buchsbaum_formula_succ_pd`, the narrative could be trimmed to a one-line iter-195 status. Cosmetic.

## Minor

- **`AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:864/895/919/936`** — `[Fintype ι] [DecidableEq ι]` on the pi-const helpers. The directive mentioned lake warns about `[DecidableEq ι]` being unused; `[DecidableEq ι]` is needed for `Pi.single` matter but lake may warn because `Classical.decEq` would solve it from `[Fintype ι]`. Cosmetic linter cleanup, not a soundness concern.
- **`AlgebraicJacobian/RiemannRoch/H1Vanishing.lean:102/411-425/533-536/638-648`** and **`AlgebraicJacobian/RiemannRoch/OCofP.lean:953`** — `.val.map` / `.val.obj` against `Sheaf` objects. Mathlib at the project's pinned commit reportedly deprecates `CategoryTheory.Sheaf.val` in favor of `ObjectProperty.obj`. Migration debt; the compiler emits a deprecation warning but accepts the code.
- **Long history comments** (iter-180…iter-194 narrative paragraphs) inside `AbelianVarietyRigidity.lean` L177–L483, `RationalCurveIso.lean` L780–L953, `Albanese/AuslanderBuchsbaum.lean` L1606–L1894, `RiemannRoch/WeilDivisor.lean` L833–L913. These are not currently misleading but accumulate audit-noise; once a lane closes, a compact "current status" paragraph would replace ~50 LOC of historical narration.
- **`AlgebraicJacobian/RiemannRoch/OcOfD.lean:141`** — `if D = 0 then Scheme.toModuleKSheaf C else sorry`. Unusual but not unsound packaging.

## Excuse-comments (called out separately)

The following comments are red-flag language admitting wrongness / deferred fixes, listed with file:line and the declaration they attach to. Per the directive, these are listed verbatim:

- **`AlgebraicJacobian/Picard/IdentityComponent.lean:391`**: *"typed `sorry` to enable downstream consumers (sanctioned temporary sorry-count increase)"*. Attached to `geometricallyConnected_of_connected_of_section`. Severity: **major** (the docstring at L546 documents the consequence of a prior such sanction propagating `sorryAx`).
- **`AlgebraicJacobian/Picard/RelPicFunctor.lean:231`**: `-- TODO (A.1.b gate): close once \`LineBundle.OnProduct\` is upgraded`. Severity: **major**.
- **`AlgebraicJacobian/Picard/RelPicFunctor.lean:422`**: `will fix \`J\` to the étale topology and unfold via`. Severity: **major**.
- **`AlgebraicJacobian/Picard/RelativeSpec.lean:22/38`**: "silently-discarding placeholder `RelativeSpec _𝒜 := X`, `structureMorphism _ := 𝟙 X`; the lean-auditor iter-177 flagged both CRITICAL". Severity: **minor** (historical record of a fix already in place; cosmetic cleanup needed).
- **`AlgebraicJacobian/Picard/LineBundlePullback.lean:106`**: "project-side stand-in for the missing Mathlib `IsInvertible` predicate". Severity: **major** (documented stand-in; signature is honest but the term "stand-in" is project-jargon flag).
- **`AlgebraicJacobian/Picard/QuotScheme.lean:113`** + **`AlgebraicJacobian/Picard/FlatteningStratification.lean:111`**: "structural stand-in for projective". Severity: **major** (documented design decision; not weakened-wrong but a stand-in pattern).
- **`AlgebraicJacobian/Picard/FGAPicRepresentability.lean:75/110-137`**: "File-internal placeholder" defs `picSharp` + `divFunctor`. Severity: **major** (documented sibling-chapter placeholders).

The placeholder-style language in `OCofP.lean:1421-1440` and `AuslanderBuchsbaum.lean:1071-1101` inside docstrings is the *iter-196+ work plan*, not an excuse — it concretely names the substrate gaps. Not flagged.

The `Pic0.bundle` and the `Bundle`-pattern in `Albanese/AlbaneseUP.lean:152-201` is **classified above under must-fix**, not duplicated here.

## Severity summary

- **must-fix-this-iter**: 3 — `WeilDivisor.lean:746` (instance with `sorry` body propagating `sorryAx`), `Thm32RationalMapExtension.lean:194` (in-proof `haveI := sorry`), `Albanese/AlbaneseUP.lean:183` (`:= sorry` def propagating to four typeclass instances).
- **major**: 7 — Three documented project-jargon "stand-in" patterns (`QuotScheme.lean:113`, `FlatteningStratification.lean:111`, `LineBundlePullback.lean:106`), two excuse-style inline comments (`RelPicFunctor.lean:231` TODO, `RelPicFunctor.lean:422` "will fix"), one "sanctioned temporary sorry" excuse-comment (`IdentityComponent.lean:391`), one file-internal-placeholder pattern (`FGAPicRepresentability.lean:110-137`).
- **minor**: ~6 — `.val` deprecation warnings on `Sheaf` access (`H1Vanishing.lean` + `OCofP.lean` + `RRFormula.lean`); unused-class-arg linter warnings in `AuslanderBuchsbaum.lean` pi-const helpers; cumulative iter-history narrative in long docstrings; `OcOfD.lean:141` ad-hoc `if-then-else` with sorry-else.
- **excuse-comments**: 7 (also counted under must-fix-this-iter / major above; called out separately because they document the project lying to itself).

**Overall verdict**: The iter-195 advances are *clean and well-carved* (carvings in `AuslanderBuchsbaum`, `RationalCurveIso`, structural advances in `H1Vanishing`/`OCofP`/`WeilDivisor`/`QuotScheme`), but the *cumulative pre-iter-195 substrate state* has three `:= sorry`/sorry-instance carriers (`WeilDivisor.lean:746`, `Thm32RationalMapExtension.lean:194`, `AlbaneseUP.lean:183`) that propagate `sorryAx` silently through typeclass synthesis — exactly the soundness pattern the directive's red-flag list specifically calls out and that the project has historically corrected by demoting `instance` to `private theorem` (see `IdentityComponent.lean:546-549` for the precedent). These three must-fix items are the highest-leverage cleanup for iter-196.
