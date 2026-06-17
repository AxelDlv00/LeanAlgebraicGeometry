# Lean Audit Report

## Slug
iter174

## Iteration
174

## Scope
- files audited: 24
- files skipped (per directive): 0

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure re-export root listing every project module. No content to audit.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Each protected declaration is a direct projection from the witness's `isAlbaneseFor P`. Body shape and statements consistent with the docstring.

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 flagged (scaffold)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `iotaGm_isDominant` (L86–89): `private lemma … := sorry`. Docstring is honest — body gated on `gmScalingP1`'s chartwise definition. Listed as a Genus0BaseObjects-dependent bridge.
  - `genusZero_curve_iso_P1` (L290–296): `:= sorry`. Body needs the Riemann–Roch sub-build (`RR.3`/`RR.4`). Signature is substantive.
  - `morphism_P1_to_grpScheme_const_aux` body (L113–229) is structurally complete and self-contained (no sorries here); only propagates sorries through helpers `iotaGm_isDominant` and `gmScalingP1_collapse_at_zero`.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File compiles its full content (Mathlib gap-fills, MV LES core, sequence exactness) without any sorry. `Iso.refl _` uses in `HModule'_sequenceIso` (L576/579/582) are legitimate — they sit at the degree-0 positions of `ComposableArrows.isoMk₅` where the iso is genuinely an identity.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All 2-affine cover / cover-totality / `HasAffineCechAcyclicCover` declarations are honestly closed. `Classical.choice` extractor (L506–514) is honest given the `Nonempty` class field design and is documented in scope.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 minor
- **excuse-comments**: none
- **notes**:
  - L6: `import Mathlib` (broad import). Minor code smell — slows build, hides dependency surface. Project pattern shared with a few scaffold files; non-blocking.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Phase A steps 2–4 honestly closed; comments accurate.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure re-export of the three sub-files; the iter-174 file split is reflected accurately in the docstring.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 667 LOC closing the H>0 / H⁰ carriers, Stein-finite input, producer instance, and Čech-side carriers — no sorries. The honest narrative ("abandoned attempt to package per-affine-open Hom-finiteness; deleted as dead scaffolding") in L25–32 is a clean architectural disclosure, not an excuse-comment about live code.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All five per-open ring-map helpers + the presheaf builder are honest closures. Mathlib gap-fills on `Functor.const`/`Adjunction.homLinearEquiv` carry tight, accurate docstrings.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/SheafProperty.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `toModuleKSheaf_forgetCompare` body `Iso.refl _` (L57) is justified — the two presheaves agree on the nose at the underlying-presheaf level (the iso is genuinely the identity after forgetting).

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No real `sorry`s in code (the single grep hit is a sentence "sorry-free closure" inside a docstring).
  - Status docstring (L43–77) accurately reflects the closed state of the KDM and chart-algebra pieces.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 1 minor
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File body is fully proven (no real `sorry`). The grep matches for "sorry" all occur inside docstrings (e.g. L433 "Status: Step 3 closed iter-136 (no sorry); …", L486–487 references to a since-excised scaffold).
  - L428–525: large `/-! ### Helper sub-lemmas …` block whose narrative refers extensively to iter-137/138 "PARTIAL" / "three remaining concrete sub-goals" / Route (b'2) state that was then EXCISED in iter-145 (L552–560). The surviving declarations are now only `relativeDifferentialsPresheaf_restrict_along_identity_section` (Step 3, fully closed) and `shearMulRight` / `schemeHomRingCompatibility` / `isIso_of_app_iso_module`. The L428–525 block reads as outdated commentary for code that no longer lives in this file — minor severity, doc-only confusion.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three theorems and one defn, all honestly closed. The disclosure about the false reverse direction of the Jacobian criterion (L117–123) is exemplary — not an excuse but a mathematical caveat.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 minor
- **excuse-comments**: none
- **notes**:
  - Single `noncomputable def genus`, body is the probe-confirmed one-liner. `import Mathlib` (L6) is a minor code smell as elsewhere.

### AlgebraicJacobian/Genus0BaseObjects.lean
- **outdated comments**: none
- **suspect definitions**: 1 (load-bearing)
- **dead-end proofs**: 10 (8 substantive + 2 directive-known cross-case deferrals)
- **bad practices**: 1 minor
- **excuse-comments**: none
- **notes**:
  - L188 `projectiveLineBar_geomIrred` body `sorry` — Mathlib gap (no `GeometricallyIrreducible` for `Proj`). Substantive type, scaffold disclosure honest.
  - L195 `projectiveLineBar_smoothOfRelDim` body `sorry` — Mathlib gap on `SmoothOfRelativeDimension 1 (Proj …)`. Scaffold disclosure honest.
  - L808 **`instance gm_grpObj … := sorry`** — load-bearing typeclass instance with `sorry` body driving the entire `𝔾ₘ`-scaling shortcut (it is the LIVE consumer of `morphism_P1_to_grpScheme_const`). Docstring labels it "Scaffold body — same discipline as `ga_grpObj`"; the analogous `ga_grpObj` is not present in this file (search returns no such declaration), so the "same discipline as" comparison is suspicious. (See must-fix block below.)
  - L1092, L1103 `gmScalingP1_chart_PLB_eq` Step C branches for `i=0`/`i=1` — directive-known deferrals; signature and surrounding `simp only` infrastructure look reasonable; not flagged per directive.
  - L1139, L1141 `gmScalingP1_chart_agreement` cross cases `(0,1)`/`(1,0)` — directive-known; signature substantive; not flagged per directive.
  - L1206 `gmScalingP1_collapse_at_zero` body `sorry` — the load-bearing fixed-point property that `morphism_P1_to_grpScheme_const_aux` consumes. Substantive type, but a deferred-iter risk.
  - L1284 `gm_geomIrred` body `sorry` — Mathlib-gap-flagged in docstring.
  - L1316 `projGm_isReduced` body `sorry` — Mathlib-gap-flagged in docstring.
  - L6: `import Mathlib` (minor).
  - `set_option linter.style.setOption false` (L59) — silences a style lint; not visible elsewhere in the project. Could be revisited if a tighter `set_option` becomes available.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 (deferred per status block)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L236 `genusZeroWitness.key` body `sorry` (inside the `isAlbaneseFor` field). Docstring states the residual sub-build (`k → k̄` pullback / descent of morphism equality) is "real but not gated on any out-of-file plan-level decision". Acceptable as a scoped scaffold sorry.
  - L274 `positiveGenusWitness := sorry` — labelled M3 off-critical-path per STRATEGY.md. Acceptable disclosure.

### AlgebraicJacobian/Picard/LineBundlePullback.lean
- **outdated comments**: none
- **suspect definitions**: 1 (TYPE-LEVEL sorry on carrier)
- **dead-end proofs**: 4 (scaffold, depend on carrier)
- **bad practices**: 1 minor
- **excuse-comments**: none
- **notes**:
  - L119–121 `noncomputable def OnProduct … : Type (u+1) := sorry` — **type-level `sorry`**: the carrier type itself is `sorry`-defined. The file docstring is open about this ("we encode `OnProduct` by a typed `sorry` at the type level"), and the directive lists this as iter-174 scaffold landing. Per the lean-auditor strict rule "Suspect bodies on substantive claims … `:= sorry` on a load-bearing claim", this is the most fragile pattern in the project — every downstream pin in this file references it. (See must-fix block; classification rationale included there.)
  - L150–152 `pullbackAlongProjection`, L204–214 `pullback_pullback_eq`, L261–264 `preimage_subgroup`, L309–312 `functorial` — all `sorry`-bodied with substantive types; each consumes `OnProduct`.
  - L6: `import Mathlib` (minor).

### AlgebraicJacobian/Picard/RelativeSpec.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 5 (scaffold, all directive-flagged)
- **bad practices**: 1 minor
- **excuse-comments**: none
- **notes**:
  - L131–136 `structure QcohAlgebra` — substantive structure with `sheaf` + `unit` fields (Encoding I per docstring). Replaces the iter-173 type-level sorry; this is a proper iter-174 Lane G landing.
  - L160–161, L171–173, L206–208, L230–232, L260–264 — five remaining `sorry` bodies on `RelativeSpec`, `structureMorphism`, `UniversalProperty`, `affine_base_iff`, `base_change`. Each carries a substantive type referencing the now-concrete `QcohAlgebra`. The `UniversalProperty` is encoded by its structural consequence (`IsAffineHom` of the structure morphism) — non-tautological; docstring concedes this is a stepping-stone before the full Yoneda-bijection refinement.
  - L6: `import Mathlib` (minor).

### AlgebraicJacobian/RiemannRoch/RRFormula.lean
- **outdated comments**: none
- **suspect definitions**: 1 (typed-sorry placeholder, directive-known)
- **dead-end proofs**: 3 (all directive-known scaffold)
- **bad practices**: 1 minor
- **excuse-comments**: borderline ×1
- **notes**:
  - L168–171 `noncomputable def sheafOf … := sorry` — the directive explicitly tracks this ("3 sorries + 1 helper `sheafOf` typed-`sorry`"). The L134 docstring header literally reads "**The invertible sheaf `𝒪_C(D)` of a Weil divisor (placeholder)**" with body `sorry`. "Placeholder" language in a load-bearing data-defining `def` is on the **borderline of an excuse-comment**, but the file's prose names a concrete RR.3 chapter where it will be replaced and the consumers (`l`, `eulerCharacteristic_eq_degree_plus_one_minus_genus`, `l_eq_degree_plus_one_of_genus_zero`) only touch it through cohomology — the type signatures of those three downstream pins remain substantive arithmetic identities. Classifying as major (not must-fix) and listing the borderline excuse-comment instances for visibility.
  - L224–232, L253–264 — two RR identities each `:= sorry` with substantive arithmetic-on-finrank-of-cohomology signatures.
  - L100–132 `Scheme.eulerCharacteristic` is closed honestly (one-line subtraction). Good landing.
  - L6: `import Mathlib` (minor).

### AlgebraicJacobian/RiemannRoch/WeilDivisor.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 4 (scaffold)
- **bad practices**: 1 minor
- **excuse-comments**: none
- **notes**:
  - `ofClosedPoint` (L178–180) — body closed iter-174 with the junk-defined off-regime branch (`if h : Order.coheight P = 1 then Finsupp.single ⟨P, h⟩ 1 else 0`). The companion lemmas `ofClosedPoint_eq_single` and `ofClosedPoint_eq_zero` (L186–198) document the two regimes cleanly. This is the standard "junk value" pattern, well-handled.
  - L140–142 `order`, L258–260 `principal`, L273–275 `principal_hom`, L294–299 `principal_degree_zero` — all `sorry`-bodied with substantive signatures. Iter-173+ scaffolds per docstring.
  - L6: `import Mathlib` (minor).

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Scheme.Over.ext_of_eqOnOpen` fully proven. The "Hypothesis history" block (L43–79) is excellent — it documents the iter-003 false-as-stated point-wise variant and the iter-125 unused-hypothesis cleanup transparently.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: 1 stale
- **suspect definitions**: none
- **dead-end proofs**: 1 (legacy fallback)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L75–88 `rigidity_over_kbar` is `:= sorry` with `[CharZero kbar]`. The MEMORY note records this file as the "fallback route (a)" superseded by route (c) via `AbelianVarietyRigidity.lean`'s `rigidity_genus0_curve_to_grpScheme` (which is char-free). The status block (L20–29) still reads "iter-126 scaffold ... gated on the shared cotangent-vanishing Mathlib pile" — that gating narrative is stale (the chart-algebra/cotangent pivot was descoped iter-163+). Minor: refresh the status block to acknowledge this file is now the route-(a) fallback artefact, not the live build.

### AlgebraicJacobian/RigidityLemma.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 902 LOC. Whole Rigidity-Lemma chain plus Milne §I.1 corollaries (`hom_additive_decomp_of_rigidity`, `av_regularMap_isHom_of_zero`) fully proven, no real `sorry`. Excellent. All `sorry` grep hits are inside descriptive docstrings.

## Must-fix-this-iter

- `AlgebraicJacobian/Genus0BaseObjects.lean:808` — `instance gm_grpObj (kbar : Type u) [Field kbar] : GrpObj (Gm kbar) := sorry`. **Why must-fix:** load-bearing typeclass instance (drives `Gm`'s group structure, which the entire 𝔾ₘ-scaling shortcut in `AbelianVarietyRigidity.morphism_P1_to_grpScheme_const_aux` depends on) with a bare `sorry` body. Per the auditor's strict severity rule, `:= sorry` on a load-bearing claim is must-fix even if the project has authorised a multi-iter deferral. The docstring's "same discipline as `ga_grpObj`" comparison is stale: no `ga_grpObj` instance appears in the file (only the `Ga` *scheme* exists; the group-object instance was never landed). Either land `gm_grpObj` honestly (via `GrpObj.ofRepresentableBy` + the units functor) or split the dependency so that the genus-0 chain is gated on a single explicit existence axiom rather than an opaque `:= sorry` instance.
- `AlgebraicJacobian/Picard/LineBundlePullback.lean:119–121` — `noncomputable def OnProduct {S C T : Scheme.{u}} (_πC : C ⟶ S) (_πT : T ⟶ S) : Type (u+1) := sorry`. **Why must-fix:** this is a **type-level** `sorry` defining the carrier on which the rest of the file's 4 pinned declarations depend. The auditor's strict rule on `:= sorry` for load-bearing claims applies even more sharply at the type level — every value of `OnProduct πC πT` is a `sorry` artefact, and the four downstream pins consequently are claims about a `sorry`-defined type. The file's litmus-test framing ("Never weaken the type to dodge the proof — but encode by a typed sorry at the type level …") rationalises away a pattern that the rule was written to forbid. **Mitigation if iter-175+ closure is committed:** explicitly authorise the type-level `sorry` in `archon-protected.yaml` (or escalate via a project axiom) and convert the body to an `axiom OnProduct …` declaration with an audited statement; either path makes the project's reliance on this carrier *visible* to axiom-clean checks. Leaving it as `:= sorry` lets the dependency hide.

## Major

- `AlgebraicJacobian/Genus0BaseObjects.lean:188`, `:195`, `:1206`, `:1284`, `:1316` — five additional scaffold `sorry`s on substantive claims (`projectiveLineBar_geomIrred`, `projectiveLineBar_smoothOfRelDim`, `gmScalingP1_collapse_at_zero`, `gm_geomIrred`, `projGm_isReduced`). Each is acknowledged as a Mathlib-gap scaffold in its docstring; signatures are substantive. Collectively they make the genus-0 chain a multi-stop deferral surface.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:89`, `:296` — `iotaGm_isDominant` and `genusZero_curve_iso_P1` bodies `:= sorry`. Both are gated on downstream sub-builds (Genus0BaseObjects chartwise body / RR.3 + RR.4). Substantive signatures.
- `AlgebraicJacobian/Picard/LineBundlePullback.lean:152`, `:214`, `:264`, `:312` — four scaffold `sorry` bodies on declarations consuming the L121 type-level `OnProduct := sorry`.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:161`, `:173`, `:208`, `:232`, `:264` — five scaffold `sorry` bodies. The `QcohAlgebra` carrier is now concrete (iter-174 Lane G landing); these depend on it and have substantive types.
- `AlgebraicJacobian/RiemannRoch/RRFormula.lean:171` — `sheafOf` body `sorry` with docstring naming it "placeholder". Borderline excuse-comment language (see Excuse-comments section); classified major because the file docstring grants iter-175+ the explicit replacement chapter (`RR.3`).
- `AlgebraicJacobian/RiemannRoch/RRFormula.lean:232`, `:264` — two RR identity scaffolds.
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:142`, `:260`, `:275`, `:299` — four scaffold sorries on `order`, `principal`, `principal_hom`, `principal_degree_zero` with substantive signatures.
- `AlgebraicJacobian/Jacobian.lean:236` — `genusZeroWitness.key` body `sorry` (the `k → k̄` descent step).
- `AlgebraicJacobian/Jacobian.lean:274` — `positiveGenusWitness := sorry` (M3 off-critical-path).
- `AlgebraicJacobian/RigidityKbar.lean:88` — `rigidity_over_kbar := sorry` (the route-(a) fallback). Status block in the file's docstring still presents this as the live route gated on cotangent-vanishing, which is stale (the live route is now `AbelianVarietyRigidity.rigidity_genus0_curve_to_grpScheme`). Refresh the status block to reflect the route-(a) fallback role.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:428–525` — large `/-! ### Helper sub-lemmas …` narrative documenting the iter-137/138 PARTIAL state and "three remaining concrete sub-goals" of Step 2 / Route (b'2) for `relativeDifferentialsPresheaf_basechange_along_proj_two`, which was **excised** iter-145 (acknowledged at L552–560 / L624–629). The surviving content is `shearMulRight`, `schemeHomRingCompatibility`, `isIso_of_app_iso_module`, and the Step-3 `relativeDifferentialsPresheaf_restrict_along_identity_section`. The L428–525 narrative misdescribes the file's current state; trim or rewrite to match.

## Minor

- `AlgebraicJacobian/Genus.lean:6`, `AlgebraicJacobian/Genus0BaseObjects.lean:6`, `AlgebraicJacobian/Cohomology/SheafCompose.lean:6`, `AlgebraicJacobian/Picard/LineBundlePullback.lean:6`, `AlgebraicJacobian/Picard/RelativeSpec.lean:6`, `AlgebraicJacobian/RiemannRoch/RRFormula.lean:6`, `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:6` — broad `import Mathlib`. Slows builds and obscures dependency surface. Several of these are recent scaffold landings where targeted imports could be derived once the bodies land.
- `AlgebraicJacobian/Genus0BaseObjects.lean:59` — `set_option linter.style.setOption false`. The only invocation of this disabler in the project. Worth a short comment justifying which warning is being silenced (or removing it if the cause is no longer present).
- `AlgebraicJacobian/Cotangent/GrpObj.lean` L444–451 prose mentions `analogies/phi-compatibility-morphisms.md`, `analogies/kaehler-tensorequiv-presheafpullback.md`, etc., for code that was excised. References can stay (analogies are read-mostly), but trim them when refreshing L428–525.

## Excuse-comments (always called out separately)

Two borderline cases worth visibility. Neither matches the canonical "wrong but works", "temporary", "will fix later" patterns verbatim, but both lean on the "placeholder" register on load-bearing declarations:

- `AlgebraicJacobian/RiemannRoch/RRFormula.lean:74`: docstring text "we expose a **typed-`sorry` placeholder** `AlgebraicGeometry.Scheme.WeilDivisor.sheafOf` …". Severity: borderline major (already listed under Major). The framing names the replacement chapter (`RR.3`) so it is not fully an excuse, but the word "placeholder" attached to a load-bearing data-defining `def` is the pattern the project should be careful with.
- `AlgebraicJacobian/RiemannRoch/RRFormula.lean:155`: docstring header literally reads "**The invertible sheaf `𝒪_C(D)` of a Weil divisor `D` on a smooth proper curve `C / k̄`** (placeholder for `RR.3`)." Same case as above.

`AlgebraicJacobian/Picard/LineBundlePullback.lean` and `AlgebraicJacobian/Picard/RelativeSpec.lean` use "scaffold" and "iter-175+ will instantiate" framing repeatedly but consistently disclose the sub-build chapter; this stays inside the project's normal scaffold-disclosure vocabulary rather than crossing into excuse-comment territory. (The `OnProduct := sorry` type-level pattern is structurally more severe, listed under must-fix.)

## Severity summary

- **must-fix-this-iter**: 2 — both involve `:= sorry` on load-bearing declarations (one instance, one type-level carrier).
- **major**: ~28 grouped findings (mostly scaffold `sorry` bodies on substantive types in Genus0BaseObjects, AbelianVarietyRigidity, the two Picard files, RRFormula, WeilDivisor, Jacobian, RigidityKbar; plus the stale `GrpObj.lean` L428–525 narrative).
- **minor**: 8 — broad `import Mathlib` in seven files; one `linter.style.setOption false` invocation without a localised justification.
- **excuse-comments**: 2 borderline (both `placeholder` language on `sheafOf` in `RRFormula.lean`; double-counted under Major).

Overall verdict: the proven core (Rigidity-Lemma chain, Mayer-Vietoris LES, structure-sheaf carriers, cotangent helpers) is in excellent shape, but the iter-174 file-skeleton lanes have introduced a cluster of `:= sorry`-bodied carriers — two of them (the `gm_grpObj` instance and the `OnProduct` type-level carrier) cross the strict "load-bearing `:= sorry`" threshold and should be flagged as must-fix even though both are part of acknowledged multi-iter scaffolds.
