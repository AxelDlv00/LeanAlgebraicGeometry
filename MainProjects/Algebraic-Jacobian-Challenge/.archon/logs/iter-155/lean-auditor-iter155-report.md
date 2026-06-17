# Lean Audit Report

## Slug
iter155

## Iteration
155

## Scope
- files audited: 14 (all `.lean` under the project tree; `.archon/lanes/**/snapshots/**`
  historical archives excluded as non-source)
- files skipped (per directive): 0

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure import aggregator (13 imports). Nothing to audit.

### AlgebraicJacobian/Jacobian.lean  (FOCUS)
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none (2 known sorries, faithfully isolated)
- **bad practices**: 1 (long-line lint)
- **excuse-comments**: none
- **notes**:
  - `genusZeroWitness` (L209) — VERIFIED HONEST. LSP diagnostics show exactly one
    `sorry` warning for this decl and no errors. The six structural fields are all
    genuine: `grpObj := inferInstance`, `proper`/`smooth` via `inferInstance` on the
    identity, `geomIrred := geometricallyIrreducible_id_Spec k` (a real proof),
    `smoothGenus` via `rw [h]` + identity instance. The `isAlbaneseFor` field exhibits
    `toUnit C` and proves the pointed condition (`toUnit_unique`); the uniqueness clause
    is a genuine `cancel_epi` argument (`Flat.epi_of_flat_of_surjective` +
    `Over.epi_of_epi_left`), NOT a placeholder. The single residual `sorry` (L240) has
    goal `⊢ f = toUnit C ≫ η[A]` under `h : genus C = 0`, `_hf : P ≫ f = η[A]` — i.e.
    exactly the `rigidity_over_kbar` conclusion. The sorry is faithfully isolated, not
    laundered. The decl-level docstring (L176–208) is accurate against the code.
  - `positiveGenusWitness` (L274) — bare `sorry` (known issue, Route A off-critical-path);
    docstring honest.
  - `nonempty_jacobianWitness` (L304) — sorry-FREE: a `by_cases` delegating to the two
    witnesses. Its own docstring (L297–303) correctly describes this.
  - STALE FILE-HEADER DOCSTRING (L19–42): the file-level inventory still claims the two
    sorry-bodied declarations are `genusZeroWitness` **and `nonempty_jacobianWitness`**
    ("`nonempty_jacobianWitness` (Phase-C OFF-LIMITS sorry)", L27), and the bullet list
    L31–42 omits `positiveGenusWitness` entirely. Post iter-135/155 the actual two sorries
    are `genusZeroWitness` and `positiveGenusWitness`; `nonempty_jacobianWitness` is proven.
    The header misidentifies which declarations carry sorries. See Major.
  - L330 exceeds the 100-char line limit (style lint). Minor.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none (1 known sorry)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `rigidity_over_kbar` (L75–88) — single `sorry` body; known open obligation. Docstring
    + "Encoding choice" block are accurate and disclose the Option-A/Option-B decision
    honestly. Hypotheses `[IsAlgClosed kbar] [CharZero kbar]` match the genusZeroWitness
    consumer's documented gap. No laundering.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Scheme.Over.ext_of_eqOnOpen` fully closed. The "Hypothesis history" block honestly
    documents WHY the point-wise hypothesis was strengthened to scheme-level (the char-p
    Frobenius counterexample) — this is correct mathematical disclosure, not an excuse.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three declarations (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`) all
    honestly project from `(jacobianWitness C).isAlbaneseFor`. No sorries.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `genus := Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)` is the
    honest `dim_k H¹(C, O_C)` definition. (Note: its finiteness depends on downstream
    carrier classes never produced — see ChartAlgebra/cohomology observation below; this
    does not make `genus` ill-defined, since `finrank` is total.)

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `smooth_locally_free_omega` proves only the forward Jacobian-criterion direction; the
    docstring (L119–123) explicitly discloses the reverse direction is "mathematically
    false" without extra deformation input, with a counterexample. This is honest scoping,
    NOT an excuse-comment — the theorem statement only asserts the forward direction.
  - `kaehler_quotient_localization_iso`, `kaehler_localization_subsingleton` closed cleanly.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none / **suspect definitions**: none / **dead-end proofs**: none
- **bad practices**: none / **excuse-comments**: none
- **notes**: single instance honestly closed.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none / **suspect definitions**: none / **dead-end proofs**: none
- **bad practices**: none / **excuse-comments**: none
- **notes**: three declarations closed; `toAbSheaf` honest.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none / **suspect definitions**: none / **dead-end proofs**: none
- **bad practices**: none / **excuse-comments**: none
- **notes**:
  - 877 lines, all sorry-free. `Iso.refl _`/`rfl` bodies (`toModuleKSheaf_forgetCompare`,
    `cechCochain_OC_eq`, `cechCohomology_OC_eq`, `toModuleKPresheaf_obj`) are genuine
    definitional facts, not rfl-on-nontrivial laundering.
  - The "Historical note on the abandoned per-affine-open variant" (L471–481) honestly
    documents a removed dead-scaffolding class with the correct mathematical reason
    (Γ(U,O) infinite over k on proper affine opens). Good practice.
  - Carrier classes `IsAffineHModuleVanishing`, `IsHModuleHomFinite` are honest Prop
    classes; `instIsHModuleHomFinite_toModuleKSheaf` is a real producer instance.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none / **suspect definitions**: none / **dead-end proofs**: none
- **bad practices**: none / **excuse-comments**: none
- **notes**: 627 lines, sorry-free. MV-LES core + `chgUnivLinearEquiv` gap-fill all honest.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none / **suspect definitions**: none / **dead-end proofs**: none
- **bad practices**: none / **excuse-comments**: none
- **notes**:
  - 711 lines, sorry-free. `noncomputable cechToHModuleIso := Classical.choice ...` (L506)
    is authorized/documented (kernel axiom set only).
  - OBSERVATION (not a finding): carrier classes `HasCechToHModuleIso` (L490) and
    `HasAffineCechAcyclicCover` (L675) have NO producer instance anywhere in the project,
    and `HasAffineCechAcyclicCover.exists_cover` is explicitly "existence asserted, not
    constructed" (L658–673). The H¹-vanishing/finiteness ladder consumed by `genus` thus
    bottoms out at undischarged typeclass assumptions. This is by-design carrier-class
    scaffolding, honestly labeled — not a sorry/axiom — so it is not flagged, but a reader
    should understand `genus`-finiteness is conditional on these unprovided instances.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 2 blocks flagged
- **suspect definitions**: none
- **dead-end proofs**: none (file is sorry-free — LSP: 0 warnings)
- **bad practices**: 1 (possibly-orphaned private helper)
- **excuse-comments**: none
- **notes**:
  - `cotangentSpaceAtIdentity` (L162) fully constructed, no sorry; the `Classical.choose`
    chart-extraction is honestly documented incl. the "Caveat on canonicity" (L138–153).
    `cotangentSpaceAtIdentity_finrank_eq`, `cotangentSpaceAtIdentity_eq_extendScalars`,
    `shearMulRight`, `section_snd_eq_identity_struct`,
    `relativeDifferentialsPresheaf_restrict_along_identity_section` all closed.
  - STALE COMMENT BLOCK 1 (L428–451, `/-! ### Helper sub-lemmas and main lemma of piece
    (i.b)`): states "Step 2 PARTIAL iter-137 (body remains `sorry`...); Compose main lemma
    body `sorry` pending Step 2 closure (iter-138+ target)". Those declarations
    (`relativeDifferentialsPresheaf_basechange_along_proj_two`,
    `mulRight_globalises_cotangent`) were EXCISED iter-145 (excise notes at L552–560,
    L624–629). The file is now sorry-free, so the comment misdescribes the file's status.
  - STALE COMMENT BLOCK 2 (L465–525, `/-! ### Piece (i.b) Step 2 ... (iter-138 PARTIAL
    skeleton)`): a ~60-line block detailing "3 narrowly-scoped concrete sorries", "Three
    remaining concrete sub-goals (iter-139+ targets)", and a closure plan — all for the
    excised `basechange_along_proj_two_inv*` declarations. Describes code that no longer
    exists as if it were live sorry-bodied scaffolding. See Major.
  - `isIso_of_app_iso_module` (L544, `private`): was the helper for the excised
    `basechange_along_proj_two_inv_app_isIso`; now has no consumer in this file. Labeled
    "Upstream-PR candidate", so may be retained intentionally — flag as a possibly-orphaned
    private helper (Minor).

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: 1 minor
- **suspect definitions**: none
- **dead-end proofs**: none (file is sorry-free)
- **bad practices**: none (the 4 `local instance` warnings are the intended, documented
  `Algebra.TensorProduct.rightAlgebra` re-enablement — per directive Known Issues)
- **excuse-comments**: none
- **notes**:
  - `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` (KDM, L197) CLOSED iter-154;
    docstring honestly states the JOINT `[IsAlgClosed k]`+`[IsDomain B]` hypotheses are
    essential with concrete counterexamples for dropping either. `constants_integral_over_
    base_field`, `df_zero_factors_through_constant_on_chart`, `ext_of_diff_zero` all closed.
  - L20–34 import note + L25 reference to "iter-145 `: True := sorry` placeholders" is a
    historical note; those placeholders have since been replaced by the real signatures, so
    the note is mildly stale but harmless (it documents an import decision). Minor.

## Must-fix-this-iter

None.

The three declaration-level sorries (`genusZeroWitness.key`, `positiveGenusWitness`,
`rigidity_over_kbar`) are the project's pre-existing, authorized open obligations and are
faithfully isolated with accurate docstrings — re-flagging their existence is explicitly
out of scope per the directive. No excuse-comments, no weakened-wrong definitions, no
parallel-API copies, no suspect `:= True`/`:= rfl`-on-nontrivial bodies, and no `axiom`
declarations exist in any source file.

## Major

- `AlgebraicJacobian/Jacobian.lean:19-42` — STALE file-header docstring. The "TWO
  sorry-bodied declarations" inventory names `genusZeroWitness` and
  `nonempty_jacobianWitness`, but post-iter-135/155 the second sorry lives in
  `positiveGenusWitness` (which the header never mentions), while
  `nonempty_jacobianWitness` is sorry-free (proven by `by_cases`). The header misleads a
  reader about which declarations are open. (The per-decl docstrings are correct; only the
  file header is stale.)
- `AlgebraicJacobian/Cotangent/GrpObj.lean:428-525` — two STALE comment blocks describing
  piece-(i.b) Step-2 / Compose-main-lemma sorry-bodied skeletons ("body remains `sorry`",
  "3 narrowly-scoped concrete sorries", iter-139+ sub-goal plan) that were EXCISED iter-145.
  The file is verified sorry-free (0 LSP warnings); these blocks describe nonexistent code
  and falsely imply the file still carries piece-(i.b) sorries.

## Minor

- `AlgebraicJacobian/Jacobian.lean:330` — line exceeds 100-char style limit.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:544` — `private isIso_of_app_iso_module` appears
  orphaned (its only in-file consumer was excised iter-145); confirm it is still needed or
  remove. Labeled "Upstream-PR candidate" so possibly intentional.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:20-34` — import note references iter-145
  `: True := sorry` placeholders that no longer exist; mildly stale but documents an import
  rationale.
- `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean` (informational) — `genus`-finiteness
  is conditional on the never-produced carrier classes `HasCechToHModuleIso` /
  `HasAffineCechAcyclicCover`. Honest by-design scaffolding, not a defect; noted for
  situational awareness.

## Excuse-comments (always called out separately)

None found. No `-- TODO replace`, `-- placeholder`, `-- temporary`, `-- wrong but works`,
or `-- will fix later` comments attached to any live declaration. The "iter-145 `: True :=
sorry` placeholders" mention in ChartAlgebra.lean refers to historical code already
replaced by real signatures, not a current placeholder.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2 (both are stale comments that misrepresent which declarations carry sorries)
- **minor**: 4
- **excuse-comments**: 0

Overall verdict: The Lean is honest — the focus declaration `genusZeroWitness` is a faithful
skeleton with genuine structural fields and a single correctly-isolated rigidity `sorry`,
and no excuse-comments / wrong definitions / unauthorized axioms exist anywhere; the only
real issues are two stale comment blocks (Jacobian.lean file header, GrpObj.lean piece-(i.b)
sections) that misstate the current sorry inventory.
