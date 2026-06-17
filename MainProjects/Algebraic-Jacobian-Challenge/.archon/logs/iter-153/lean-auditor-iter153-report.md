# Lean Audit Report

## Slug
iter153

## Iteration
153

## Scope
- files audited: 5 (all named in directive)
- files skipped (per directive): 0

Tooling: per-file `lean_diagnostic_messages` (errors + sorry warnings),
`lean_verify` axiom check on the two iter-153-touched ChartAlgebra
declarations, project-wide grep for consumer/usage of every declaration
in scope. All 5 files compile error-free; the only `sorry` *warnings* are
the documented structured sorries.

## Per-file checklist

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged
- **bad practices**: 2 flagged
- **excuse-comments**: none
- **notes**:
  - `lean_diagnostic_messages`: single sorry warning at L270 (the KDM
    lemma `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`, body
    `sorry` at L427). Confirms directive's expectation: the *only*
    remaining open sorry in the file is the KDM lemma. ✔
  - `lean_verify constants_integral_over_base_field` (L508): axioms =
    `{propext, Classical.choice, Quot.sound}` — **no `sorryAx`**. The
    newly-closed proof is genuinely sound; it consumes no project sorry.
    ✔ The proof is a clean 3-step chain (irreducibleSpace → IsIntegral →
    field; properness → finite/integral; `IsAlgClosed.algebraMap_bijective
    _of_isIntegral` → surjective). Docstring claim "no ChartAlgebraS3
    (S3.*) lemma consumed" verified by grep. ✔
  - DEAD-END (major): the KDM lemma body (L276–L374) builds ~95 lines of
    `have`/`let`/`obtain` scaffolding (`_hRev`, `_hStdSm`, `_hFree`,
    `_basis`, `_hCoordVanish`, SubmersivePresentation `⟨ι,σ,…,P⟩`,
    `bTilde`/`hbTilde`, `_hFunct`) and then discharges the **entire**
    original goal with a raw `sorry` (L427) — none of the scaffolding
    constrains or feeds the sorry. The underscore-prefixed `have` names
    deliberately suppress the unused-variable linter, so the inert
    scaffolding compiles silently.
  - ROUTE CONFLICT (major): the body now carries two divergent closure
    narratives. The iter-150 block (L311–L351) describes a MvPolynomial
    free-case + `ker_map_of_surjective` transfer consuming the `_mvPoly_*`
    helpers; the iter-153 BRIGHT-LINE block (L398–L426) declares the path
    forward to be the field-theoretic FT.3 (`ker d_{Frac B/k}` = relative
    algebraic closure) which does **not** go through MvPolynomial. The
    claim at L393–L396 that the `_mvPoly_*` / `_hFunct` scaffolding
    "remains valid and reusable in its closure" is dubious — the stated
    iter-153 route does not consume it.
  - ORPHANED HELPER CHAIN (minor): `_finsupp_sub_single_eq_of_one_le`
    (L121), `_mvPoly_coeff_pderiv_at_shifted` (L137),
    `_mvPoly_mem_range_C_of_pderiv_eq_zero` (L179),
    `_mvPoly_mem_range_C_of_D_eq_zero` (L219) form a self-contained,
    sorry-free chain whose terminal lemma is referenced only in *comments*
    (L319, L336) — never called by any compiling proof. Currently dead
    code (investment for the sorried/possibly-abandoned transfer step).
  - SORRY-LAUNDER (major): `GrpObj.df_zero_factors_through_constant_on
    _chart` (L455) emits **no** sorry warning yet `lean_verify` shows it
    depends on `sorryAx` (it delegates to the L270 KDM sorry). Header L62
    says it "inherits its hypotheses"; neither header nor its docstring
    (L431–454, which describes a "full 5-step closure path") states it is
    **unproven pending KDM**. A reader scanning sorry-warnings will wrongly
    read it as closed.
  - MISLEADING COMMENT (minor): inline comment L522–523 says "smoothness
    gives `IsReduced X`", but `IsReduced X` is a *separate explicit*
    hypothesis (L512) and the lemma's own docstring (L504–507) states
    `Smooth ⇒ IsReduced` is absent from Mathlib b80f227 — that is *why*
    `[IsReduced X]` is taken explicitly. The inline comment contradicts
    the docstring.
  - UNUSED HYPOTHESIS (minor): `[Smooth (X ↘ Spec (.of k))]` (L511) is not
    used by the `constants_integral_over_base_field` proof (it uses only
    IsProper, GeometricallyIrreducible, IsReduced, IsAlgClosed). Harmless
    but worth confirming the signature is intended/protected.
  - File-header status block (L39–69) is accurate to the code: (α)/(β-aux)/
    (lift) closed, KDM residual sorry, (β-core) delegate. ✔

### AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean
- **outdated comments**: 4 flagged
- **suspect definitions**: none
- **dead-end proofs**: none new (4 documented structured sorries)
- **bad practices**: 1 flagged (orphaned file)
- **excuse-comments**: none
- **notes**:
  - Compiles error-free; 4 structured sorries at L199 (S3.sep.1), L276
    (S3.pi.1), L342 (S3.sep.2), L403 (S3.pi.2). All documented.
  - ORPHANED (major): grep confirms **none** of this file's declarations
    (`isGeometricallyReduced_Gamma_of_smooth`,
    `Gamma_baseChange_iso_tensor_of_proper`,
    `Algebra.IsSeparable.of_isGeometricallyReduced_of_finite`,
    `Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange`,
    `Algebra.IsSeparable.of_finite_of_perfectField`, `gammaAlgebra`,
    `gammaAlgebraMap`) is consumed by `ChartAlgebra.lean` or anywhere
    else. The file's stated purpose (support path (b) of
    `constants_integral_over_base_field`) was obviated when iter-153
    closed that lemma via the `[IsAlgClosed k]` shortcut. S3.pi.* are
    already self-labelled "HYBRID-DEFERRED indefinitely"; S3.sep.* and the
    helpers are now equally unconsumed.
  - STALE CONSUMER REFS (major): docstrings still describe a consumer
    integration that no longer exists post iter-153:
    * L71–79 / L96–98: claims `gammaAlgebra` "matches the local `algkΓ`
      definition used by the consumer … (`set α … letI algkΓ …`)". The
      iter-153 `constants_integral_over_base_field` proof contains no such
      `set α`/`algkΓ`; it uses a local `F.hom.toAlgebra` on `Γ(X,⊤)` and
      never references `gammaAlgebra`.
    * L156–160: "Consumer compatibility: `constants_integral_over_base
      _field` … invokes this lemma without `[CharZero k]` … breaks the
      consumer's `(b.1)` branch". There is no `(b.1)` branch in the
      current proof and it does not invoke this lemma.
    * L312–315: claims the consumer calls
      `Algebra.IsSeparable.of_isGeometricallyReduced_of_finite k _`. It
      does not.
  - STALE LINE NUMBERS (minor): references to `ChartAlgebra.lean:L367`
    (L61), `:L431` (L312-context L313 says L457), `:L457` (L312) — actual
    positions are KDM L270 / df_zero L455 / constants_ L508. Drifted.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: none material
- **suspect definitions**: none
- **dead-end proofs**: none (documented sorries are in WIP piece (i.b)
  declarations, consistent with their docstrings)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Compiles error-free. `cotangentSpaceAtIdentity` (L162) and its two
    companion lemmas (`_eq_extendScalars` L211, `_finrank_eq` L257) are
    `sorry`-free per their docstrings; the `Classical.choose`-chain
    construction is intentional and documented.
  - Piece (i.b) WIP: `relativeDifferentialsPresheaf_restrict_along
    _identity_section` (L579) closed (no sorry, matches L433 "Step 3
    closed iter-136"). `shearMulRight` + reassoc lemmas closed.
    `isIso_of_app_iso_module` (L544) closed.
  - The L465–525 docstring block ("Piece (i.b) Step 2 … 3 remaining
    concrete sub-goals") documents work for declarations that were
    **excised** at L552–560 (iter-145 EXCISE note) — i.e. it describes
    `basechange_along_proj_two_inv*` which no longer exist in the file.
    Minor staleness: the long Step-2 narrative (L465–525) is now orphaned
    prose (the EXCISE note at L552 supersedes it but the prose above was
    left in place).

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: 1 flagged (file-header inventory)
- **suspect definitions**: none
- **dead-end proofs**: none (3 documented scaffold sorries)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Compiles error-free. Sorries at L197 (`genusZeroWitness`), L223
    (`positiveGenusWitness`), both documented scaffolds.
    `nonempty_jacobianWitness` (L249) is closed via `by_cases`
    delegation to the two witnesses (no sorry).
  - STALE INVENTORY (major): the file-header "## Status" block (L18–40)
    says "TWO `sorry`-bodied declarations" naming `genusZeroWitness` and
    `nonempty_jacobianWitness` (L27 calls the latter "Phase-C OFF-LIMITS
    sorry"). Reality: `nonempty_jacobianWitness` is **closed** (delegates),
    and `positiveGenusWitness` (L219, a real sorry) is **absent** from the
    inventory. The header bullet list (L36–40) likewise omits
    `positiveGenusWitness`. The per-decl docstrings (L189, L214, L242)
    correctly describe the iter-135 restructure, so the header was simply
    not updated alongside them — internally inconsistent.
  - `geometricallyIrreducible_id_Spec` (L134) closed and sound.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 documented scaffold sorry
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Compiles error-free; single documented sorry at L88
    (`rigidity_over_kbar`, iter-126 scaffold). Hypotheses `[IsAlgClosed
    kbar] [CharZero kbar]` honest. The unused-binder underscores
    (`_hgenus`, `_hf`) are appropriate for a scaffold.
  - This is the headline downstream consumer the whole ChartAlgebra /
    ChartAlgebraS3 pile is meant to feed — and it is still a single
    `sorry`; grep confirms it consumes none of the ChartAlgebra(S3)
    declarations yet. Context for the orphaning findings above.

## Must-fix-this-iter

None. No excuse-comments, no weakened-wrong definitions, no parallel-API
copies, no unauthorized axioms, no `:= True`/fake-`rfl` bodies. Every
`sorry` is a documented structured open goal of the project's normal
proving workflow (the directive itself treats the KDM sorry as expected),
and `constants_integral_over_base_field` was verified `sorryAx`-free.

## Major

- `ChartAlgebra.lean:276-427` — KDM lemma body builds ~95 lines of
  inert `have`/`let`/`obtain` scaffolding then discharges the full goal
  with a bare `sorry`; underscore names suppress the unused linter. Dead-
  end proof body: nothing it computes constrains the remaining goal.
- `ChartAlgebra.lean:311-426` — two conflicting closure-route narratives
  in one body (iter-150 MvPolynomial-transfer vs iter-153 field-theory
  FT.3); the "remains valid and reusable" claim (L393-396) about the
  `_mvPoly_*`/`_hFunct` scaffolding is inconsistent with the iter-153
  stated path, which does not consume it.
- `ChartAlgebra.lean:455` — `df_zero_factors_through_constant_on_chart`
  transitively depends on `sorryAx` (verified) but emits no sorry
  warning; header/docstring do not state it is unproven pending KDM.
  Risk: read as closed.
- `ChartAlgebraS3.lean` (whole file) — all declarations orphaned: nothing
  consumes them after iter-153 closed `constants_integral_over_base_field`
  via the alg-closed shortcut. Plan agent should decide keep-as-deferred-
  standalone vs excise.
- `ChartAlgebraS3.lean:71-79, 96-98, 156-160, 312-315` — stale consumer-
  integration claims describing a `constants_integral_over_base_field`
  code shape (`set α`/`algkΓ`, `(b.1)` branch, direct invocation of the
  S3 lemmas) that the iter-153 rewrite removed. Actively misleading about
  the dependency graph.
- `Jacobian.lean:18-40` — stale file-header inventory: lists
  `nonempty_jacobianWitness` as a sorry (it is closed) and omits
  `positiveGenusWitness` (a real sorry).

## Minor

- `ChartAlgebra.lean:121-229` — `_mvPoly_*` helper chain is sorry-free but
  unconsumed (terminal lemma referenced only in comments).
- `ChartAlgebra.lean:522-523` — inline comment "smoothness gives
  IsReduced X" contradicts the docstring (IsReduced is an explicit
  hypothesis precisely because `Smooth ⇒ IsReduced` is absent upstream).
- `ChartAlgebra.lean:511` — `[Smooth …]` hypothesis unused by the proof.
- `ChartAlgebra.lean:6` — `import …ChartAlgebraS3` is likely now unused
  (constants_ consumes no S3 declaration); confirm before relying on it.
- `ChartAlgebraS3.lean:61,312,313` — stale `ChartAlgebra.lean:L367/L431/
  L457` line references (actual: KDM L270 / df_zero L455 / constants_ L508).
- `GrpObj.lean:465-525` — long "Piece (i.b) Step 2 / 3 remaining sub-goals"
  narrative is orphaned prose describing declarations excised at L552-560.

## Excuse-comments (always called out separately)

None. No `-- TODO replace`, `-- placeholder`, `-- temporary`, `-- wrong
but works`, or `-- will fix later` comments attached to any declaration.
The structured-sorry comments are documented open goals, not admissions
of wrong code.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 6
- **minor**: 6
- **excuse-comments**: 0

Overall verdict: The iter-153 closure of `constants_integral_over_base
_field` is genuinely sound (`sorryAx`-free, verified) and the only open
sorry in `ChartAlgebra.lean` is the KDM lemma as the directive expected;
the substantive concerns are stale post-pivot documentation (Jacobian
header inventory, ChartAlgebraS3 consumer claims), a now-orphaned
`ChartAlgebraS3.lean` and `_mvPoly_*` chain, and the KDM body's inert
scaffolding-around-a-`sorry` plus a `sorryAx`-laundered `df_zero` delegate.
