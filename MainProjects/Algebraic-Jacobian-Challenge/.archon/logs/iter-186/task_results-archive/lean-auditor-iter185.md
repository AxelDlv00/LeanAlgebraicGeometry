# Lean Audit Report

## Slug
iter185

## Iteration
185

## Scope
- files audited: 41
- files skipped (per directive): 0

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure import shim (32 LOC). Clean.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `-`

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 (L396 inside `iotaGm_chart1_composition_isOpenImmersion`)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L396 — Lane E sub-task (f) helper terminates in a load-bearing `sorry` after the `change`-with-`_, _` placeholders privacy-bridge workaround (L358–367, L383–395). The `_, _` placeholder route for the two `pullback.congrHom` proof arguments leans on `Prop`-irrelevance to defeat private-name barriers; reasonable, openly documented, and consistent with the surrounding Mathlib idioms. Body continues to be honest Tier-3 typed sorry.
  - L716, L716 — `genusZero_curve_iso_P1` body remains `:= sorry` (RR bridge); signature substantive. Not a regression.

### AlgebraicJacobian/Albanese/AlbaneseUP.lean
- **outdated comments**: none
- **suspect definitions**: 1 (L183 `Bundle C` carrier — typed-sorry on a file-internal placeholder for `Pic⁰_{C/k̄}` until the A.3 chapter ships)
- **dead-end proofs**: 5 (L242, L292, L327, L365, L409, L450 — file-skeleton bodies)
- **bad practices**: none
- **excuse-comments**: none (docstring "placeholder" mentions are dispositive disclosures, not in-body excuse comments)
- **notes**:
  - The `Bundle` typed-sorry carrier shape is documented as the bridge to `IdentityComponent` (iter-185 NEW); rewire planned for iter-186+ via the `Pic0Scheme` declaration now living in `Picard/IdentityComponent.lean`.

### AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 (L982 `exists_isSMulRegular_quotient_isRegularLocal_succ`, L1094 inline inside `regularLocal_inductive_step`)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L982 — new typed-`sorry` helper that consolidates Stacks 00NQ + 00NU substrate gaps into a single narrowly-typed claim. Reasonable Lane G PIVOT shape.
  - L1094 — inline "technical bridge" sorry on the `IsRegular (QuotSMulTop x R) rs'_q` vs `IsRegular (R ⧸ Ideal.span {x}) rs'_q` mismatch. Body comment outlines the `Submodule.ideal_span_singleton_smul` rewrite path; non-substantive but real `sorry`. Should be a named helper rather than inline (~10–20 LOC the comment acknowledges) — bookkeeping debt. Currently lives in the `IsRegular.cons'` branch of L1068.
  - The `regularLocal_inductive_step`/`exists_isRegular_of_regularLocal` strong-induction restructure is structurally sound: induction on `n = spanFinrank`, IH applied at the quotient, cons via `IsRegular.cons'`. The Mathlib gap is honestly factored.

### AlgebraicJacobian/Albanese/CodimOneExtension.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 3 (L254 within `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`, L383 `extend_of_codimOneFree_of_smooth`, L426 `indeterminacy_pure_codim_one_into_grpScheme`)
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `-` (sorries are documented Stacks 00TT / Milne 3.1, 3.3 bodies)

### AlgebraicJacobian/Albanese/CoheightBridge.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Clean, axiom-clean closure.

### AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 (L194 inline `IsReduced A.left := sorry`; L283 inline second-branch sorry)
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `-`

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `-`

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L504–505 the word "axiom" appears inside a docstring noting that no new project axiom was introduced — per directive, ignored.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `-`

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `-`

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Re-export shim only.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `-`

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `-`

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/SheafProperty.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `-`

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: 1 (L20–34 historical iter-145 EXCISE notes referencing removed scaffolding)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 (L92 `attribute [local instance] Algebra.TensorProduct.rightAlgebra` — re-promoting a Mathlib local instance outside its home file; documented as deliberate, minor)
- **excuse-comments**: none
- **notes**: Closed file (no `sorry`).

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 1 (L465–525 §"piece (i.b) Step 2" docstrings still narrate `basechange_along_proj_two_*` declarations excised at L552–559 / L624–629; orphaned scaffolding-prose)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Substantive content closed; non-canonical witness via `Classical.choose` chain explicitly disclosed.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `-`

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Honest definition `genus := Module.finrank kbar (HModule kbar (toModuleKSheaf C) 1)`.

### AlgebraicJacobian/Genus0BaseObjects.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Re-export only.

### AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 (L156 `projectiveLineBar_geomIrred`, L163 `projectiveLineBar_smoothOfRelDim`)
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `-` (substantive Mathlib gap, openly disclosed)

### AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `-`

### AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 4 (L508 `gmScalingP1_chart_agreement_cross01`, L640 `gmScalingP1_collapse_at_zero`, L718 `gm_geomIrred`, L750 `projGm_isReduced`)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L412–508 — the cocycle helper is now reduced via `cancel_epi gmScalingP1_cover_intersection_X_iso.inv` and a documented simp pass over the iso-spine; the residual sorry has shrunk to the ring-level identity `λ·u = (1/t)·λ` in `Localization.Away t ⊗ GmRing`, with a 30-line analysis of which Recipe-2 simp lemmas didn't fire and three concrete iter-186+ pickup paths (term-mode iso refactor / explicit projection lemmas / bypass via `chart_PLB_eq`). Diagnostic content is high-quality; no progress toward a closed body this iter.
  - L620–640 — `gmScalingP1_collapse_at_zero` now opens with `Over.OverMorphism.ext` + `Over.comp_left`/`Over.lift_left` structural simp, then sorries. Honest decrement-zero progress.

### AlgebraicJacobian/Genus0BaseObjects/Points.lean
- **outdated comments**: 1 (L480–482 docstring still describes "named substantive sorries" for round-trips + naturality, but the actual bodies of `gmHomEquiv_left_inv`, `gmHomEquiv_right_inv`, `homEquiv_comp` are closed)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Substantive content closed.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 (L236 inline within `genusZeroWitness.isAlbaneseFor`; L274 entire `positiveGenusWitness`)
- **bad practices**: none
- **excuse-comments**: none
- **notes**: The `genusZeroWitness.J := 𝟙_` choice is gated on `genus C = 0`; documented as honest math (not a weakened def). `positiveGenusWitness` is openly an off-critical-path stub.

### AlgebraicJacobian/Picard/FGAPicRepresentability.lean
- **outdated comments**: none
- **suspect definitions**: 2 (L132–135 `picSharp`, L147–150 `divFunctor` — typed-sorry **at the type level** for file-internal forward-reference placeholders)
- **dead-end proofs**: 5 (L189, L231, L291, L329, L368)
- **bad practices**: none (whole-file `import Mathlib` is project-wide; not flagged per-file)
- **excuse-comments**: none
- **notes**: Honest file-skeleton; carrier stand-ins are documented as bridges to the sibling-chapter functors.

### AlgebraicJacobian/Picard/FlatteningStratification.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 6 (L214, L258, L287, L319, L365, L407, L450)
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `-` (file-skeleton)

### AlgebraicJacobian/Picard/IdentityComponent.lean (NEW iter-185)
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 5 (L129 `GroupScheme.IdentityComponent`, L157 `IdentityComponent.isOpenSubgroupScheme`, L193 `Pic0Scheme`, L234 `PicScheme.degree`, L285 `Pic0Scheme.isAbelianVariety`)
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pure file-skeleton matching the chapter `\lean{...}` pins. Signatures are substantive; no weakened types. The five `sorry` bodies are honest typed sorries on a fresh chapter.

### AlgebraicJacobian/Picard/LineBundlePullback.lean
- **outdated comments**: none
- **suspect definitions**: 1 (L119–121 `LineBundle.OnProduct := sorry` at the **type level** — `Type (u+1)` carrier stand-in)
- **dead-end proofs**: 4 (L152, L214, L264, L312)
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Type-level typed-sorry pattern documented as gated on A.1.b carrier work; concerning shape but consistent with the FGA scaffolding throughout `Picard/`.

### AlgebraicJacobian/Picard/QuotScheme.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 7 (L173 `hilbertPolynomial`, L212 `QuotFunctor`, L248 `Grassmannian`, L275 `Grassmannian.representable`, L330 `QuotScheme`, L537 `pullback_app_isoTensor_isBaseChange`, L620 `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase`, L670 `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen`, L720 `canonicalBaseChangeMap_app_app_isIso_of_affineCover`)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L476–480 — new private `pullback_app_isoTensor_unitAtV` is axiom-clean (built from `adjunction.unit.app N`); good structural extraction.
  - L501–537 — new named substantive typed-`sorry` `pullback_app_isoTensor_isBaseChange`. Body is `by ... exact sorry` after `letI` algebra setup and four-step TODO commentary (Steps 1–4: unitAtV → Γ(X,V)-linearity → Tilde-isoTop identification → IsBaseChange.equiv.symm). The body comment is a roadmap, not an excuse.
  - L546–562 — `Scheme.Modules.pullback_app_isoTensor` consumes the helper via `.some`. Bridging shape clean.
  - L620 — `_of_isAffineBase` still ends in `sorry` (Beck–Chevalley compatibility); the iter-183 plan claimed this closes via `Module.Flat.isBaseChange` + `IsBaseChange.equiv` but the residual remains. Compatible with the iter-185 directive note that this is partial Lane F substance.

### AlgebraicJacobian/Picard/RelPicFunctor.lean
- **outdated comments**: 1 (L231 `-- TODO (A.1.b gate): close once …` — narrow named gate, but qualifies as an in-body TODO)
- **suspect definitions**: none
- **dead-end proofs**: 6 (L235, L287, L328, L373, L433, L482)
- **bad practices**: none
- **excuse-comments**: 1 (L231 above)
- **notes**: The single TODO is precisely scoped to the A.1.b carrier; not a "will-fix-later" laundering.

### AlgebraicJacobian/Picard/RelativeSpec.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Lane D HARD-BAR SUCCESS verified.** Both `pullback_cocone_desc_comp_fst` (L506–533) and `pullback_iso_desc_isIso` (L546–632) carry substantive, axiom-clean closures. `pullback_iso_construction` (L643–659) cleanly assembles via `asIso desc |>.symm`. `base_change` (L679–683) is a one-liner consumer.
  - Header (L17–42) accurately describes the Block A/B status; comments are current.

### AlgebraicJacobian/RiemannRoch/OCofP.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 7 (L233, L254, L316, L362, L460, L497, L555)
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `-` (file-skeleton; substantive types)

### AlgebraicJacobian/RiemannRoch/OcOfD.lean
- **outdated comments**: none
- **suspect definitions**: 1 (L137–141 `sheafOf` — partial def `if D = 0 then toModuleKSheaf C else sorry`)
- **dead-end proofs**: 2 (L193 `sheafOf_singlePoint`, L242 `sheafOf_ses_single_add`)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L137–141 — value-pinning, MAJOR (see Major section).** The `D = 0` branch is hard-coded to `Scheme.toModuleKSheaf C`; the `else` branch is `sorry`. This lets `sheafOf_zero` (L167–170) discharge by `unfold sheafOf; exact if_pos rfl` — i.e. *by definitional equality of the def*, not by mathematically identifying the Hartshorne subsheaf-of-`K_C` at `D=0` with the structure sheaf. The lemma is currently true *given the definition*; the iter-186+ honest Hartshorne construction must (i) match `toModuleKSheaf C` on the nose at `D=0` or (ii) drop the value-pinning. The task author's framing ("genuine Hartshorne identification `ℒ(0)=𝒪_C`") is mathematically correct in the canonical sense, but the **Lean proof is doing zero mathematical work** at L168–170 — the equality is by construction, not by argument. Flag this as a forecasting bet on the iter-186+ Hartshorne body landing definitionally equal at `D=0`.
  - L137 — the def uses `open Classical in` for the `D = 0` decision; consistent with `noncomputable`.
  - Per directive: `declaration uses 'sorry'` propagation through `sheafOf_zero` is propagation, not laundering. Confirmed.

### AlgebraicJacobian/RiemannRoch/RRFormula.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 (L344 `Scheme.eulerCharacteristic_of_shortExact_skyscraper`)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L231–293 — `finrank_H0_toModuleKSheaf_eq_one` closure landed.** ~60 LOC chain via `HModule_zero_linearEquiv` → `constantSheafGammaHom_linearEquiv` → `homFromOne_linearEquiv` → `SheafGammaObj_linearEquiv_top`, then `Module.finrank_of_bijective_algebraMap` on the `IsAlgClosed`-integrality bridge. Axiom-clean structure; consumes upstream cohomology bridge lemmas with no inlined `sorry`. Genuine progress.
  - **L329–344 — `eulerCharacteristic_of_shortExact_skyscraper`** is a new substantive typed-`sorry` helper bundling three Hartshorne IV.1.3 inputs into one well-typed claim. Shape is correct; signature is non-tautological and forces the iter-186+ closure to provide (a) χ-additivity on `ShortExact` (via LES + Grothendieck vanishing on a curve), (b) iso-invariance of χ, (c) `χ(skyscraperSheaf P.point) = 1`. Honest extraction.
  - `Scheme.eulerCharacteristic_sheafOf_succ`, `Scheme.eulerCharacteristic_sheafOf_zero`, `Scheme.eulerCharacteristic_sheafOf_single_add` (L346–481) are sorry-free assemblies on top of the named helpers, well-structured by `Int.induction_on` for the inductive step.

### AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 3 (L296 `Hom.poleDivisor`, L334 `Hom.poleDivisor_degree_eq_finrank`, L496 `iso_of_degree_one`)
- **bad practices**: none
- **excuse-comments**: none
- **notes**: File-skeleton + one closed pin (`morphismToP1OfGlobalSections`, L218–257). Docstring L367–379 documents the iter-177→iter-182 strengthening that previously was flagged "weakened-wrong"; the historical record is informative provenance.

### AlgebraicJacobian/RiemannRoch/WeilDivisor.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 (L210 `rationalMap_order_finite_support`, L442 second branch of `principal_degree_zero`)
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Substantive content largely closed; junk-on-off-branch encoding for `ofClosedPoint` is documented (`ofClosedPoint_eq_zero` exposes the junk regime).

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `-`

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 (L88 `rigidity_over_kbar`)
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `_hgenus`, `_hf` are underscored placeholders — appropriate for a scaffold body, but flagged: a real proof must consume both. Not an audit-must-fix.

### AlgebraicJacobian/RigidityLemma.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Large file (902 LOC); no `sorry`. (A prior agent sweep raised concern about `push Not` at L226; verified by grep — no such tactic call exists. False alarm.)

## Must-fix-this-iter

None.

The iter-185 directive's strict criteria are met by every load-bearing addition: typed sorries are well-named, types are substantive (not weakened), no `:= rfl` / `:= True` / `Classical.choice _`-laundering on substantive claims, no project axioms. The largest *engineering* concern — `OcOfD.lean:137–141` `sheafOf` value-pinning — is below the must-fix bar because (i) the def is documented as Tier-3 in-progress, (ii) `sheafOf_zero`'s body is mathematically vacuous-on-purpose given the pinning (not "laundering" a wrong proof — there is no proof obligation when the equality is by construction), and (iii) the directive's known-issues note explicitly forecasts that downstream Hartshorne work will either match or drop the pin. Surface as **Major** with the explicit risk that the iter-186+ closure may need to retroactively retract the pinning.

## Major

- `AlgebraicJacobian/RiemannRoch/OcOfD.lean:137` — `sheafOf` value-pinning trick. The def `if D = 0 then toModuleKSheaf C else sorry` makes `sheafOf_zero` discharge by `if_pos rfl`. This is mathematically defensible (`𝒪_C(0) = 𝒪_C`) but constitutes **zero proof work** at the lemma site — the equality is by definition, not by argument. *Forecasting bet*: iter-186+ Hartshorne subsheaf-of-`K_C` body must produce a sheaf that is **definitionally equal** to `toModuleKSheaf C` at `D = 0`, or the value-pinning must be removed (and `sheafOf_zero` re-proved by a genuine identification). Flag and track explicitly so the iter-186 prover does not silently break the bet.
- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:1094` — inline `sorry` inside `regularLocal_inductive_step` for the `IsRegular (QuotSMulTop x R)` vs `IsRegular (R ⧸ Ideal.span {x})` M-mismatch. Comment outlines a 10–20 LOC `Submodule.ideal_span_singleton_smul` bridge; should be extracted into a named helper, not left inline.

## Minor

- `AlgebraicJacobian/Cotangent/GrpObj.lean:465–525` — orphaned scaffolding-prose narrating `basechange_along_proj_two_*` declarations that were excised at L552–559 / L624–629. Documentation rot; prune in a cleanup pass.
- `AlgebraicJacobian/Genus0BaseObjects/Points.lean:480–482` — docstring describes "named substantive sorries" for round-trips + naturality that no longer exist (bodies are closed). Mildly misleading; trim the iter-N narrative.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:20–34` — historical iter-145 EXCISE notes referencing removed scaffolding; safe to remove now.
- `AlgebraicJacobian/Picard/RelPicFunctor.lean:231` — `-- TODO (A.1.b gate): …`. Narrowly scoped TODO with a named gate; technically an excuse-comment by the strict letter of the auditor rules, but the named gate immunises it from being laundering. Below the major threshold.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:411` (typing of `_root_.mul_one`) — uses `_root_.mul_one` to disambiguate. Reasonable but a sign of namespace pressure; not flagged.
- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:1027` — `_root_.sup_le_iff` style namespace disambiguation pressure throughout the file; minor.
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:467–502` — ~35-line diagnostic block inside a proof body. Diagnostic comments are valuable but oversized; consider moving the analysis to `analogies/gmscaling-projection-idiom.md` once the closure path lands.

## Excuse-comments (always called out separately)

- `AlgebraicJacobian/Picard/RelPicFunctor.lean:231`: `-- TODO (A.1.b gate): close once \`LineBundle.OnProduct\` is upgraded from a typed sorry to the actual carrier` (attached to a `sorry`-bodied `instAddCommGroupOfLineBundleOnProduct`-style declaration). Severity: **minor** (named-gate excuse, not load-bearing for a verdict claim — the file is a documented A.1.b file-skeleton).

No other in-body excuse-comments found. Docstring mentions of "placeholder" throughout (e.g. in `OcOfD.lean:36`, `RRFormula.lean:75`, `FGAPicRepresentability.lean:75`, `AlbaneseUP.lean:179`) describe the *iter-185 file-skeleton status* (typed-sorry bodies waiting on siblings) rather than admitting current code is "wrong" — they pass the litmus because each names a substantive type, a downstream consumer, and a numbered iter target for closure.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2 (OcOfD value-pinning, AuslanderBuchsbaum inline technical-bridge sorry)
- **minor**: 7 (3 stale docstring-prose, 1 named-gate TODO, plus 3 cosmetic notes)
- **excuse-comments**: 1 (RelPicFunctor L231; also counted under minor)

Overall verdict: **SOUND with one structural watch-item.** Iter-185's load-bearing additions are honest — Lane D landed both Tier-3 helpers axiom-clean (verified body-by-body in `RelativeSpec.lean`), Lane H landed `finrank_H0_toModuleKSheaf_eq_one` substantively, and Lane G's PIVOT to `exists_isRegular_of_regularLocal` factors the Mathlib gap cleanly. The single structural watch-item is the `OcOfD.sheafOf` value-pinning bet: track explicitly in iter-186+ planning so the Hartshorne closure does not silently break the `if_pos rfl` discharge of `sheafOf_zero`.
