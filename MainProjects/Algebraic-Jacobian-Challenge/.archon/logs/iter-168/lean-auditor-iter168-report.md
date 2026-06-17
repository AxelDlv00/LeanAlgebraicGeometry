# Lean Audit Report

## Slug
iter168

## Iteration
168

## Scope
- files audited: 16
- files skipped (per directive): 0

Project files audited (full pass, root `AlgebraicJacobian.lean` plus 15 modules):

```
AlgebraicJacobian.lean
AlgebraicJacobian/AbelJacobi.lean
AlgebraicJacobian/AbelianVarietyRigidity.lean
AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
AlgebraicJacobian/Cohomology/SheafCompose.lean
AlgebraicJacobian/Cohomology/StructureSheafAb.lean
AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
AlgebraicJacobian/Cotangent/ChartAlgebra.lean
AlgebraicJacobian/Cotangent/GrpObj.lean
AlgebraicJacobian/Differentials.lean
AlgebraicJacobian/Genus.lean
AlgebraicJacobian/Genus0BaseObjects.lean      ← iter-168 edits
AlgebraicJacobian/Jacobian.lean
AlgebraicJacobian/Rigidity.lean
AlgebraicJacobian/RigidityKbar.lean
```

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure import aggregator. No content.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Closed file; three declarations all project from the Albanese witness and reduce cleanly. Docstring references "Phase E" / "iter-073" historical context but does not mislead.

### AlgebraicJacobian/AbelianVarietyRigidity.lean (iter-168 focus-adjacent)
- **outdated comments**: 1 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 2 flagged
- **notes**:
  - L915–922 header narrative claims all four product instances (`projGm_geomIrred`, `projGm_locallyOfFiniteType`, `projGm_isReduced`, `projectiveLineBar_isReduced`) "ship from Lane A … as the instances". This is accurate for `projGm_locallyOfFiniteType` and `projectiveLineBar_isReduced` (the latter newly closed iter-168), but `projGm_geomIrred` and `projGm_isReduced` are still **`sorry`-bodied** in `Genus0BaseObjects.lean` (L773/L791). The narrative talks past that.
  - L924–934 `iotaGm_isDominant : ... := sorry` — load-bearing project-local bridge; named, but body is bare `sorry`. The wording "Project-side bridge pending Lane A's concrete `gmScalingP1` body" is an excuse-comment for a load-bearing sorry.
  - L1135–1141 `genusZero_curve_iso_P1 := sorry` — load-bearing RR bridge; docstring openly admits "body remains `sorry` (RR bridge — iter-167+)".
  - The chain `rigidity_lemma → rigidity_core → rigidity_eqOn_dense_open → rigidity_eqOn_saturated_open_to_affine → rigidity_eqAt_closedPoint_of_proper_into_affine` is `sorry`-free and well-structured; large narrative volume but no semantic drift.
  - `morphism_P1_to_grpScheme_const_aux` (L958) and `morphism_P1_to_grpScheme_const` (L1093) consume the sorries in `Genus0BaseObjects.lean` and `iotaGm_isDominant`; their bodies are honest delegations.
  - Acknowledged-status excuse-comments (L1090–1092, L1156–1159) are workflow narrative; they document the propagation route honestly but still mark the declarations as `sorry`-tainted.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 0 flagged (one local pragma `set_option backward.isDefEq.respectTransparency false in` is used carefully, mirroring Mathlib precedent)
- **excuse-comments**: none
- **notes**:
  - Closed file; iter-016 → iter-026 MV-LES infrastructure for `ModuleCat k`. Several Mathlib gap-fills (`Abelian.Ext.chgUniv_add/_smul/_LinearEquiv`, `ModuleCat_free_isLeftAdjoint`, `ModuleCat_free_preservesMonomorphisms`) are honestly closed.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Closed file; iter-028 → iter-053 affine-cover MV + Čech-acyclic-cover carrier predicates. Notably `HasAffineCechAcyclicCover` (L675) is a `Prop`-class whose `exists_cover` field is the substantive unbuilt geometric content — but the class is openly framed as "existence is asserted, not constructed" (L666–669); no consumer in the project currently asks for an instance, so it sits as carrier infrastructure with no live obligation.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- All fields: none
- **notes**:
  - Closed file; one instance honestly closed.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- All fields: none
- **notes**:
  - Closed file; three declarations all closed.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Closed file. The `HasCechToHModuleIso` / `IsCechAcyclicCover` Mayer-Vietoris consumer chain is documented honestly; no live sorry. The `HasAffineCechAcyclicCover` instance landing for the structure sheaf is gated externally on iter-054+ infrastructure but the carrier class is correctly framed as not-yet-instantiated.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: 2 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - L20–34 long "iter-145 NOTE" / "iter-146 NOTE" plumbing block — workflow notes about historical import-list decisions; do not mislead about the code but are stale relative to the file's current state. Minor.
  - L552–560 and L624–629 "iter-145 EXCISE:" comment blocks describe previously-deleted declarations (`basechange_along_proj_two_inv*`, `relativeDifferentialsPresheaf_basechange_along_proj_two`, `mulRight_globalises_cotangent`). These are revision-history graveyard markers rather than excuse-comments; consider relocating to commit messages / journal rather than leaving in source. Minor.
  - All five substantive declarations (`algebra_isPushout_of_affine_product`, `_ratfunc_D_X_ne_zero`, `_algebraic_mem_range`, `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`, `df_zero_factors_through_constant_on_chart`, `constants_integral_over_base_field`, `Scheme.Over.ext_of_diff_zero`) are closed honestly with no inline sorries.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - L465–525 long block describing piece (i.b) Step 2 (`basechange_along_proj_two_inv*`) as "iter-138 PARTIAL with substantive Route (b) skeleton landed" — but the corresponding declarations have been **excised** (per the `iter-145 EXCISE` comment at L552 in `ChartAlgebra.lean`); this docstring narrative still describes them. Stale: minor (no live obligation).
  - `cotangentSpaceAtIdentity`, `cotangentSpaceAtIdentity_eq_extendScalars`, `cotangentSpaceAtIdentity_finrank_eq`, `shearMulRight` (+ two simp lemmas), `schemeHomRingCompatibility`, `section_snd_eq_identity_struct`, `isIso_of_app_iso_module`, `relativeDifferentialsPresheaf_restrict_along_identity_section` are all closed.

### AlgebraicJacobian/Differentials.lean
- All fields: none
- **notes**:
  - Closed file; clear converse-direction disclosure of `smooth_locally_free_omega` (L116–122) is good practice — flags a genuine mathematical asymmetry rather than papering over it.

### AlgebraicJacobian/Genus.lean
- All fields: none
- **notes**:
  - Closed file; one-liner `genus` definition is the honest probe-confirmed body.

### AlgebraicJacobian/Genus0BaseObjects.lean   (iter-168 edits, the focus file)
- **outdated comments**: 2 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 1 flagged
- **excuse-comments**: 7 flagged
- **notes**:
  - L172–177 `projectiveLineBar_geomIrred := sorry` with docstring "Project-side scaffold sorry (Mathlib does not ship `GeometricallyIrreducible` for `Proj` of a polynomial ring; plan-marked acceptable for iter-165)". Excuse-comment on a load-bearing instance — `projGm_geomIrred` (L773) consumes it.
  - L179–184 `projectiveLineBar_smoothOfRelDim := sorry` — "Project-side scaffold sorry (Mathlib does not ship `SmoothOfRelativeDimension 1` for `Proj`; plan-marked acceptable for iter-165)". Excuse-comment + load-bearing on a `[SmoothOfRelativeDimension 1 (ProjectiveLineBar kbar).hom]` instance that `rigidity_genus0_curve_to_grpScheme` (downstream consumer) implicitly relies on through `genusZero_curve_iso_P1`.
  - L226 `push Not at h` — non-canonical tactic spelling. The canonical Mathlib idiom is `push_neg at h`. The LSP reports no diagnostics on this line so it compiles in the current toolchain, but the spelling is unusual and should be normalised in golf. Bad practice (minor).
  - L350–372 `homogeneousLocalizationAwayIso_aux_left := by sorry`. **The docstring (L350–367) is misleading**: it claims "**iter-168 partial**: structural setup via `ext`, `Away.mk_surjective`, `val_injective` gets us to the underlying `Localization.Away (X i)` comparison; the residual identity reduces to a monomial-by-monomial check using `Localization.mk_eq_mk_iff` with the cancellation …" — but the body is **literally just `sorry`** with zero structural setup. The directive flagged exactly this: the framing pretends partial progress was landed when none was. This is load-bearing — it is the second proof obligation of the chart-ring iso `homogeneousLocalizationAwayIso` (L378–386), and the iso is exported (non-private). Must-fix-this-iter: either land the claimed partial scaffold honestly, or rewrite the docstring to "TODO — no progress this iter; full body deferred".
  - L378–386 `homogeneousLocalizationAwayIso` — a load-bearing **non-private** `def` whose body depends on the above `sorry` via `RingEquiv.ofRingHom`. The iso is sorry-tainted but the symptom is L368 above; no separate flag here.
  - L537 `ga_grpObj : GrpObj (Ga kbar) := sorry`. Docstring (L526–536): "Scaffold body for iter-166+; off-path for the genus-0 closure …". Excuse-comment + load-bearing on an `instance`. The "off-path" claim is partially true (the live consumer uses `gm_grpObj`, not `ga_grpObj`), but it is still a live exported instance that downstream code may pick up; a sorried instance for an unused declaration should be deleted, not kept "for the demoted route".
  - L622 `gm_grpObj : GrpObj (Gm kbar) := sorry`. Docstring (L611–621) admits this is "the LIVE consumer of the iter-166 `morphism_P1_to_grpScheme_const` proof body". Excuse-comment + must-fix-load-bearing — this is the headline gap and the entire genus-0 closure is sorry-tainted through this instance.
  - L653–661 `gmScalingP1 := sorry` — the headline scaling morphism, load-bearing for `morphism_P1_to_grpScheme_const_aux`. Docstring "Scaffold body — iter-165 lands the *type signature*; the chartwise glue body is iter-166's lane (or an even later sub-build if `Scheme.Cover.glueMorphisms` requires further infrastructure)". Excuse-comment + must-fix-load-bearing.
  - L663–678 `gmScalingP1_collapse_at_zero := by sorry` — load-bearing companion to the above (consumed by `morphism_P1_to_grpScheme_const_aux` directly). Docstring "Scaffold body — iter-165 lands the *statement*; the proof body is iter-166's lane …". Excuse-comment + must-fix-load-bearing.
  - L708–718 `projectiveLineBar_isReduced` docstring is **STALE relative to the iter-168 body**. The docstring says "Project-side scaffold sorry (Mathlib does not ship `IsReduced (Proj 𝒜)` for a domain graded ring; would close via `IsReduced.of_openCover` over `Proj.affineOpenCover` once `HomogeneousLocalization.Away` is bridged to `IsDomain` …)" — but the body L720–753 actually **closes the lemma** via exactly that strategy (the bridge to `IsDomain` is built inline via `HomogeneousLocalization.val_injective` + `Function.Injective.isDomain`, then `IsReduced.of_openCover` finishes). The directive explicitly flagged this: the prover discovered the bridge was **not** missing, yet the docstring still asserts it is. Major outdated-narrative finding.
  - L755–763 `gm_geomIrred := by sorry`. Docstring (L755–760): "Scaffold (Mathlib gap: the direct `GeometricallyIrreducible` consequence of `IrreducibleSpace + Spec(domain over alg closed)` is not bridged; the analogist's recipe would require base-change reduction via `IsAlgClosed`-fixed bridges that are absent at scheme level)". Excuse-comment with a "Mathlib gap" framing that — given the iter-168 lesson on `projectiveLineBar_isReduced` — should be re-audited for whether the gap is actually missing. Must-fix-this-iter (load-bearing instance feeding `projGm_geomIrred`).
  - L779–795 `projGm_isReduced := by sorry`. Docstring (L779–795): "Project-side scaffold sorry (Mathlib gap: the `Smooth → GeometricallyReduced` bridge is missing at scheme level …)". Excuse-comment + load-bearing instance for `morphism_P1_to_grpScheme_const_aux`. The chart-local alternative is described in the docstring but not attempted; in light of the `projectiveLineBar_isReduced` precedent the "gap" claim should also be re-audited.
  - L33 file header bullet ("plan-marked acceptable for iter-165+", "left as scaffold `sorry`s for iter-166+") is stale relative to the iter-168 state where two of those scaffolds (`projectiveLineBar_isReduced`, the four "Lane A export" instances) have landed and only `projectiveLineBar_geomIrred`/`projectiveLineBar_smoothOfRelDim` remain on the "iter-166+ scaffold" list. Stale narrative — minor.
  - L34 references "iter-166" five times in the docstring as the target of scaffold closures, but we are in iter-168 with most of those still un-landed. Stale schedule references — minor.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 2 flagged
- **notes**:
  - L209–277 `genusZeroWitness`: structure body is mostly built honestly (six of seven fields close); the `isAlbaneseFor.key` clause at L264–265 is `:= by sorry` with a **massive embedded narrative L237–263** explaining the "3 gates" (import cycle / char-`p` logical gap / base-change functor missing). This block is the worst excuse-comment in the project — 26 lines of "until (1)+(2)+(3) clear, no honest in-file term closes this", which is workflow-rationale prose around a load-bearing `sorry`. Subsequent iters (iter-156 → iter-162) have **resolved gate (1)** (the rigidity stack has been relocated upstream as `rigidity_genus0_curve_to_grpScheme` in `AbelianVarietyRigidity.lean`, which is now importable from here without cycle) and partially resolved (2) (the char-free `rigidity_genus0_curve_to_grpScheme` no longer needs `[CharZero kbar]`). The narrative is therefore now stale: the in-file lemma is **dispatchable** modulo the live sorries in `AbelianVarietyRigidity` and `Genus0BaseObjects`. The narrative should be replaced with a one-line citation of `rigidity_genus0_curve_to_grpScheme` and a routing through it (plus the base-change-to-`k̄` step, which remains a substantive gap but is much narrower than gate (3) claims).
  - L299–303 `positiveGenusWitness := sorry` — bare `sorry` with workflow-disclosure docstring ("iter-134 scaffold — body is `sorry` … OFF-CRITICAL-PATH until M2 closes"). Excuse-comment + load-bearing on `nonempty_jacobianWitness` (the positive-genus arm).

### AlgebraicJacobian/Rigidity.lean
- All fields: none
- **notes**:
  - Closed file; one declaration honestly closed with a clean hypothesis-history note. Good example.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 1 flagged
- **notes**:
  - L75–88 `rigidity_over_kbar := sorry`. Docstring (L70–74): "iter-126 scaffold — body is a single `sorry`. The closure (C.2.b reduction via `Scheme.Over.ext_of_eqOnOpen` + C.2.c image-dimension dichotomy + C.2.d cotangent-vanishing keystone) is gated on the shared cotangent-vanishing Mathlib pile (iter-129+)". This is **stale narrative**: per `AbelianVarietyRigidity.lean` L19–21 the file "remains in tree as the fallback route (a) artifact" — the project committed to a different route (Mumford rigidity + 𝔾ₘ-scaling). The "iter-129+ pile" plan is no longer the live closure plan; the docstring should either be updated to mark this declaration as a superseded fallback artifact, or the declaration should be deleted.
  - Excuse-comment: the iter-126 scaffold framing.

## Must-fix-this-iter

These findings meet the must-fix bar in the audit rubric (load-bearing sorries with excuse-comments, stale narrative actively misleading the reader, or both). The plan agent's gate should treat each as blocking until addressed; soft severity is how wrong code hardens.

- `AlgebraicJacobian/Genus0BaseObjects.lean:350-372` — `homogeneousLocalizationAwayIso_aux_left` is a load-bearing `sorry` whose 18-line docstring **misrepresents the body as partially built ("iter-168 partial: structural setup via `ext`, `Away.mk_surjective`, `val_injective` gets us to the underlying `Localization.Away (X i)` comparison; the residual identity reduces to a monomial-by-monomial check …")** while the body is `sorry` with zero such structural setup. Why must-fix: the docstring lies about what landed; downstream readers (and future provers) will skip-past believing partial progress is on disk when it is not. Either land the claimed scaffold or rewrite the docstring to "TODO — no body landed".
- `AlgebraicJacobian/Genus0BaseObjects.lean:622` — `gm_grpObj : GrpObj (Gm kbar) := sorry`. Why must-fix: openly named "the LIVE consumer" of the iter-166 closure (L619–621); the entire genus-0 chain is sorry-propagated through this instance.
- `AlgebraicJacobian/Genus0BaseObjects.lean:659-661` — `gmScalingP1 := sorry`. Why must-fix: load-bearing on `morphism_P1_to_grpScheme_const_aux`; excuse-comment "Scaffold body — iter-165 lands the *type signature*" attached.
- `AlgebraicJacobian/Genus0BaseObjects.lean:663-678` — `gmScalingP1_collapse_at_zero` body is `sorry`. Why must-fix: companion of the above, directly consumed inside `morphism_P1_to_grpScheme_const_aux` (the W-axis-collapse hypothesis to Cor 1.5).
- `AlgebraicJacobian/Genus0BaseObjects.lean:172-177` — `projectiveLineBar_geomIrred := sorry`. Why must-fix: load-bearing instance ("plan-marked acceptable for iter-165") — `projGm_geomIrred` consumes it via `GeometricallyIrreducible.comp`.
- `AlgebraicJacobian/Genus0BaseObjects.lean:179-184` — `projectiveLineBar_smoothOfRelDim := sorry`. Why must-fix: load-bearing instance feeding the headline `rigidity_genus0_curve_to_grpScheme` chain; excuse-comment "Mathlib does not ship `SmoothOfRelativeDimension 1` for `Proj`".
- `AlgebraicJacobian/Genus0BaseObjects.lean:755-763` — `gm_geomIrred := by sorry`. Why must-fix: load-bearing scaffold sorry with a "Mathlib gap" framing that — in light of the iter-168 `projectiveLineBar_isReduced` lesson — must be re-audited for actual gap status rather than presumed.
- `AlgebraicJacobian/Genus0BaseObjects.lean:791-795` — `projGm_isReduced := by sorry`. Why must-fix: same "Mathlib gap" pattern as `gm_geomIrred`; load-bearing.
- `AlgebraicJacobian/Genus0BaseObjects.lean:708-718` — `projectiveLineBar_isReduced` docstring claims "Mathlib does not ship `IsReduced (Proj 𝒜)` … would close … once `HomogeneousLocalization.Away` is bridged to `IsDomain`" but the body L720–753 actually closes the lemma by building exactly that bridge inline. Why must-fix: a stale "Mathlib gap" docstring on a closed lemma is the strongest possible signal that **other "Mathlib gap" docstrings in this file may be just as wrong** (`gm_geomIrred`, `projGm_isReduced`, `projectiveLineBar_geomIrred`, `projectiveLineBar_smoothOfRelDim`); leaving the stale claim in place protects those other claims from being re-audited.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:924-934` — `iotaGm_isDominant := sorry`. Why must-fix: load-bearing for `morphism_P1_to_grpScheme_const_aux`; the docstring "Project-side bridge pending Lane A's concrete `gmScalingP1` body" stacks excuses one level deep.
- `AlgebraicJacobian/Jacobian.lean:237-265` — `genusZeroWitness.isAlbaneseFor.key := by sorry` with a 26-line "3 gates" narrative excuse-comment whose gate (1) (import cycle) is no longer live (`rigidity_genus0_curve_to_grpScheme` is importable here). Why must-fix: the narrative is now stale on the dominant gate and should be replaced with a one-line citation routing to `rigidity_genus0_curve_to_grpScheme`; leaving the stale 26-line excuse blocks the simple re-route that iter-156/162 made possible.

## Major

- `AlgebraicJacobian/Genus0BaseObjects.lean:537` — `ga_grpObj := sorry`. Excuse-comment "off-path for the genus-0 closure". `Ga` is not used by any live consumer in `AbelianVarietyRigidity.lean`; a sorried instance kept for a "demoted route" should be deleted rather than left publicly exported.
- `AlgebraicJacobian/Genus0BaseObjects.lean:33-34` — file-header docstring lists "scaffold `sorry`s for iter-166+" and tags `projectiveLineBar_isReduced` as a "Mathlib gap"; the iter-168 state has closed several of these. Stale schedule narrative.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:915-922` — "Iter-167 dominance bridge" header narrative claims the four product/Proj instances "all ship from Lane A as instances"; in fact two of the four (`projGm_geomIrred`, `projGm_isReduced`) are still `sorry` in Lane A. The narrative talks past the live sorries.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:1135-1141` — `genusZero_curve_iso_P1 := sorry` (RR bridge). Honest disclosure but still a load-bearing scaffold sorry on the headline chain; not classified as must-fix only because no recipe for its closure is on-tree in iter-168.
- `AlgebraicJacobian/Jacobian.lean:299-303` — `positiveGenusWitness := sorry`. Honest off-critical-path disclosure but a bare-`sorry` load-bearing definition.
- `AlgebraicJacobian/RigidityKbar.lean:70-88` — `rigidity_over_kbar := sorry` with the iter-126 closure plan ("iter-129+ cotangent-vanishing pile"). The plan is superseded by route (c) per `AbelianVarietyRigidity.lean`; the declaration is now a fallback artifact whose docstring still describes the abandoned route.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:465-525` — long "iter-138 PARTIAL" narrative block describing declarations (`basechange_along_proj_two_inv*`) that have been excised per `iter-145 EXCISE` markers in `ChartAlgebra.lean`. Stale narrative pointing at deleted code.

## Minor

- `AlgebraicJacobian/Genus0BaseObjects.lean:226` — `push Not at h` is non-canonical Mathlib spelling (canonical: `push_neg at h`). LSP shows no diagnostic, so it compiles in the current toolchain, but it is a minor style departure; the golf pass should normalise.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:20-34, 552-560, 624-629` — three blocks of revision-history graveyard comments ("iter-145 NOTE", "iter-145 EXCISE"). They are accurate but belong in commit messages / proof-journal, not source.
- `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean:675-682` — `HasAffineCechAcyclicCover` `Prop` class whose `exists_cover` field is unbuilt for any concrete `F`. The class is honestly framed as "existence is asserted, not constructed" but the project ships an instance producer (L699–709) that fires only if such an instance arrives. No current consumer asks; minor.

## Excuse-comments (always called out separately)

Each excuse-comment below is verbatim or near-verbatim from the source, with file:line and the declaration it attaches to. Per the audit rubric these are red flags; the load-bearing ones land at must-fix-this-iter.

- `AlgebraicJacobian/Genus0BaseObjects.lean:172-177`: "Project-side scaffold sorry (Mathlib does not ship `GeometricallyIrreducible` for `Proj` of a polynomial ring; plan-marked acceptable for iter-165)" — attached to `projectiveLineBar_geomIrred`. Severity: **must-fix-this-iter** (load-bearing).
- `AlgebraicJacobian/Genus0BaseObjects.lean:179-184`: "Project-side scaffold sorry (Mathlib does not ship `SmoothOfRelativeDimension 1` for `Proj`; plan-marked acceptable for iter-165)" — attached to `projectiveLineBar_smoothOfRelDim`. Severity: **must-fix-this-iter** (load-bearing).
- `AlgebraicJacobian/Genus0BaseObjects.lean:350-367`: "**iter-168 partial**: structural setup via `ext`, `Away.mk_surjective`, `val_injective` gets us to the underlying `Localization.Away (X i)` comparison; the residual identity reduces to a monomial-by-monomial check …" — attached to `homogeneousLocalizationAwayIso_aux_left`, whose body is bare `sorry`. Severity: **must-fix-this-iter / critical** (load-bearing AND actively misrepresents what landed).
- `AlgebraicJacobian/Genus0BaseObjects.lean:526-536`: "Scaffold body for iter-166+; off-path for the genus-0 closure …" — attached to `ga_grpObj`. Severity: **major** (excuse on a sorried publicly-exported instance for a demoted route).
- `AlgebraicJacobian/Genus0BaseObjects.lean:611-621`: "Scaffold body — same discipline as `ga_grpObj`. This `GrpObj Gm` is the LIVE consumer of the iter-166 `morphism_P1_to_grpScheme_const` proof body" — attached to `gm_grpObj`. Severity: **must-fix-this-iter** (load-bearing AND self-admittedly LIVE).
- `AlgebraicJacobian/Genus0BaseObjects.lean:653-658`: "Scaffold body — iter-165 lands the *type signature* (the concrete object the iter-166 proof refactor of `morphism_P1_to_grpScheme_const` consumes); the chartwise glue body is iter-166's lane (or an even later sub-build if `Scheme.Cover.glueMorphisms` requires further infrastructure)" — attached to `gmScalingP1`. Severity: **must-fix-this-iter** (load-bearing).
- `AlgebraicJacobian/Genus0BaseObjects.lean:671-673`: "Scaffold body — iter-165 lands the *statement* (matching the rigidity consumer's `_hf` shape); the proof body is iter-166's lane (it reduces to a chart-level computation: on `𝔸¹ × 𝔾_m`, `(0, λ) ↦ λ·0 = 0` is a defequal ring-map check)" — attached to `gmScalingP1_collapse_at_zero`. Severity: **must-fix-this-iter** (load-bearing).
- `AlgebraicJacobian/Genus0BaseObjects.lean:755-760`: "Scaffold (Mathlib gap: the direct `GeometricallyIrreducible` consequence of `IrreducibleSpace + Spec(domain over alg closed)` is not bridged; the analogist's recipe would require base-change reduction via `IsAlgClosed`-fixed bridges that are absent at scheme level)" — attached to `gm_geomIrred`. Severity: **must-fix-this-iter** (load-bearing; "Mathlib gap" claim should be re-audited).
- `AlgebraicJacobian/Genus0BaseObjects.lean:779-789`: "Project-side scaffold sorry (Mathlib gap: the `Smooth → GeometricallyReduced` bridge is missing at scheme level …)" — attached to `projGm_isReduced`. Severity: **must-fix-this-iter** (load-bearing; "Mathlib gap" claim should be re-audited).
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:924-930`: "Project-side bridge pending Lane A's concrete `gmScalingP1` body" — attached to `iotaGm_isDominant`. Severity: **must-fix-this-iter** (load-bearing).
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:1090-1092`: "**Status (iter-166):** body landed. Carries propagated `sorryAx` via the helper's residuals (three product-instance Mathlib bridges + dominance of the canonical `Gm → ℙ¹` map). Lifts to axiom-clean once those are discharged" — attached to `morphism_P1_to_grpScheme_const`. Severity: **major** (honest propagation note, but documents an unfixed obligation).
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:1156-1159`: "**Status (iter-166):** body landed. Carries propagated `sorryAx` via `genusZero_curve_iso_P1` (RR bridge, iter-167+) and `morphism_P1_to_grpScheme_const`'s helper residuals. Once the RR bridge closes and the helper's product-instance + dominance sorries discharge, lifts to axiom-clean" — attached to `rigidity_genus0_curve_to_grpScheme`. Severity: **major**.
- `AlgebraicJacobian/Jacobian.lean:237-263`: "NAMED GAP. … three independent gates, all out-of-file / plan-level: (1) IMPORT CYCLE … (2) CHAR-`p` LOGICAL GAP … (3) BASE-CHANGE FUNCTOR MISSING …" (26 lines) — attached to `genusZeroWitness.isAlbaneseFor.key`. Severity: **must-fix-this-iter** (gate (1) is no longer live; the narrative is stale and blocks the now-available re-route).
- `AlgebraicJacobian/Jacobian.lean:298-302`: "**Status**: iter-134 scaffold — body is `sorry`. The body closure is M3 work, currently OFF-CRITICAL-PATH until M2 closes …" — attached to `positiveGenusWitness`. Severity: **major**.
- `AlgebraicJacobian/RigidityKbar.lean:70-74`: "**Status**: iter-126 scaffold — body is a single `sorry`. The closure … is gated on the shared cotangent-vanishing Mathlib pile (iter-129+) per STRATEGY.md § M2.a + § M2.d-alt" — attached to `rigidity_over_kbar`. Severity: **major** (closure plan is superseded; declaration should be marked superseded or deleted).

## Severity summary

- **must-fix-this-iter**: 11 — these block downstream work in their files until addressed (see plan.md's per-file gate). Eight of them sit in `Genus0BaseObjects.lean` (the iter-168 focus file); the remainder cite the file from `AbelianVarietyRigidity.lean` (1) and `Jacobian.lean` (1) and the misleading-docstring-on-closed-lemma `projectiveLineBar_isReduced` (1).
- **major**: 7
- **minor**: 3
- **excuse-comments**: 15 (those at must-fix severity are also counted under must-fix-this-iter above; called out separately because they document the project lying to itself — most acute is `homogeneousLocalizationAwayIso_aux_left` which describes a structural-setup partial scaffold that does not exist).

Overall verdict: **major churn this iter on `Genus0BaseObjects.lean` (the iter-168 focus) added ~370 lines of new infrastructure with one genuinely closed lemma (`projectiveLineBar_isReduced`, axiom-clean) but eight new or carried-over load-bearing scaffold sorries with excuse-comments — most concerning is the `homogeneousLocalizationAwayIso_aux_left` "iter-168 partial" docstring that pretends partial setup landed when the body is bare `sorry`**.
