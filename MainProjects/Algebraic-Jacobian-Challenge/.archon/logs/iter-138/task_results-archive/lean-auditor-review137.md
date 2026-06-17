# Lean Audit Report

## Slug
review137

## Iteration
137

## Scope
- files audited: 12 (all `.lean` files under `AlgebraicJacobian/` plus the
  top-level `AlgebraicJacobian.lean` umbrella). Focus paid to
  `AlgebraicJacobian/Cotangent/GrpObj.lean` per directive.
- files skipped (per directive): 0

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: -

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L22 / L59 carry pre-100-character long lines (111, 101). Cosmetic only;
    not in a frozen-signature region (the three protected decls — `ofCurve`,
    `comp_ofCurve`, `exists_unique_ofCurve_comp` — start at L51, L62, L82 and
    those lines themselves are within length). Linter-style minor.
  - File-header "Status (iteration 073 — Phase E closes by reduction)" block
    is descriptive of the *current* file shape (project agents have decided
    to keep the iter-073 narrative as the file's status anchor since the
    proofs have been stable since then). Not stale.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: 1 flagged (minor)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none — `set_option backward.isDefEq.respectTransparency
  false in` used twice (L354, L523, L539, L565); each one is documented in
  the immediately-preceding comment as load-bearing for the typeclass-search
  step it gates.
- **excuse-comments**: none
- **notes**:
  - L438 is 117 characters. Linter-style minor.
  - L168 docstring asserts "iter-018 will add the composition-is-zero
    lemma and the connecting hom `δ`, iter-019 the LES sequence and
    exactness theorem"; those iterations have all landed (the
    composition-is-zero lemma is `HModule'_toBiprod_fromBiprod` at L230,
    sequence at L465, exactness at L592). Forward-reference now stale.
    Minor.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none — the three `:= rfl` declarations at L81 / L87 /
  L93 are honest corner-projection simp lemmas (the underlying
  `Opens.mayerVietorisSquare` defines those corners definitionally; `rfl` is
  the correct proof, not a placeholder).
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - The `class HasCechToHModuleIso` (L490) wraps a data field
    (`∀ n, …≃ₗ[k]…`) in `Nonempty` to fit a `Prop`-valued class; the
    extractor `cechToHModuleIso` (L506) is `noncomputable` via
    `Classical.choice`. Both choices are documented and standard for the
    Prop-class / `Classical.choice` extraction pattern; flagged here as
    informational, not as a finding.
  - L437–438 / L461–462 / L584 / L631 repeat the same
    `[HasExt.{u}] [HasExt.{u+1}] (Sheaf (Opens.grothendieckTopology …) …)`
    quad of typeclass arguments many times; large boilerplate but no smell.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: -

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: -

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: 1 flagged (minor)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Multiple docstrings (e.g. L737 "queued for iter-013+", L749–750 "iter-013+
    comparison theorem will identify it with…", L781 "iter-048+ Čech-vs-derived
    comparison theorem will build on") forward-reference iterations that have
    long since closed. The comparison-iso typeclass `HasCechToHModuleIso` is
    in `MayerVietorisCover.lean` L490; the consumer
    `subsingleton_HModule_of_isCechAcyclicCover_top` is at L433 there. The
    forward-references in this file are now stale narrative. Minor (does not
    mislead about local code, only about *when* downstream consumers landed).

### AlgebraicJacobian/Cotangent/GrpObj.lean  (focus file)
- **outdated comments**: 5 flagged (all in the known-issues block of the
  directive — file-header "line 198/244 below" references at L61, L107, L146,
  L155, L160; NOT re-reported under findings per directive)
- **suspect definitions**: none — the two `:= sorry` bodies at L508
  (`relativeDifferentialsPresheaf_basechange_along_proj_two`) and L635
  (`mulRight_globalises_cotangent`) are iter-135/137 honest scaffolds with
  intended-type signatures; explicitly enumerated in the directive's "Known
  issues" block.
- **dead-end proofs**: none — `cotangentSpaceAtIdentity` (L161) and its
  rank/shape companions are fully closed; `_restrict_along_identity_section`
  (L528) is closed via `PresheafOfModules.pullbackComp` chained against the
  iter-136 categorical identity helper `section_snd_eq_identity_struct`.
- **bad practices**: none — the iter-131 `Classical.choose`-chain in the body
  of `cotangentSpaceAtIdentity` is explicitly documented as load-bearing for
  body-shape transparency (the iter-130 alternative was rejected because
  outer `Classical.choice` was opaque to `unfold`/`whnf`).
- **excuse-comments**: none — the new iter-137 docstring prose on
  `_basechange_along_proj_two` (L479–499) describes the analysis of what an
  iter-138+ closure path looks like ("via the `pullbackPushforwardAdjunction`
  transpose, a morphism `RHS → LHS` corresponds bijectively to…"). It is
  proof-design analysis attached to an admittedly-`sorry` body, not a "will
  fix later"-style admission that conceals the body state. The body state
  is clearly named ("body is `sorry`", "Step 2 PARTIAL iter-137").
- **notes**:
  - L274 / L285 are 111 / 104 characters. Linter-style minor.
  - The two `NEEDS_MATHLIB_GAP_FILL` tags at L318 (in a docstring) and L345
    (on `shearMulRight` — which is itself a fully-closed declaration) are
    project-design markers describing the *Mathlib gap* the declaration
    fills, not admissions that the local body is wrong. `shearMulRight`
    has an honest pair of `hom_inv_id` / `inv_hom_id` proofs against a
    real binary-product shear-iso construction.
  - The new iter-137 docstrings (per directive: L427–450, L479–499,
    L525–527, L616–623) accurately describe the body state of each
    declaration:
      - `_restrict_along_identity_section` (L525–527) describes a *closed*
        body (no sorry); the docstring matches reality.
      - `_basechange_along_proj_two` (L479–499) and
        `mulRight_globalises_cotangent` (L616–623) describe *`sorry`*
        bodies; the docstrings explicitly say "body is `sorry`" and label
        the iter-137 outcome as "PARTIAL" / "honest scaffold". They do
        not paint the body as closed.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L118–123 explicitly discloses that the converse direction of the
    Jacobian criterion ("locally free Ω of rank `n` ⇒ smooth of relative
    dimension `n`") is *mathematically false* as stated without
    `Algebra.H1Cotangent` vanishing, and points to the blueprint
    counterexample. This is a good, honest disclosure (a positive — it
    protects future readers from re-deriving the broken converse) and not
    an excuse-comment about local code.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none — `genus` is the honest `Module.finrank k
  (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`, the standard
  `dim_k H¹(C, O_C)` formulation.
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: -

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: 2 honest-scaffold `sorry` bodies at L197
  (`genusZeroWitness`) and L223 (`positiveGenusWitness`). Both enumerated
  in directive's "Known issues" block; both carry intended-type signatures
  matching what `nonempty_jacobianWitness` consumes.
- **dead-end proofs**: none — the `nonempty_jacobianWitness` body at L249
  is an honest `by_cases h : genus C = 0` decomposition delegating to the
  two scaffolds. Once the two scaffold bodies close, this proof closes
  with them.
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L46–53 "Forbidden shortcut (sanity check)" explicitly warns against
    the `Jacobian C := 𝟙_ (Over (Spec (.of k)))` shortcut which would
    compile but force `genus C = 0`. This is good defensive prose — the
    project is documenting *why* the witness-based definition is necessary
    even when an obviously-simpler `:= terminal` definition would type-check.
    Positive.
  - L110 / L119 / L275 are 107 / 107 / 105 characters; per directive, L275
    is a protected signature (`Jacobian` is in `archon-protected.yaml`) and
    must not be reformatted. Minor cosmetic for L110 / L119.
  - The deferred-construction comments (e.g. L237–241 in
    `nonempty_jacobianWitness` docstring: "classically via symmetric powers
    Sym^g(C) and the Abel–Jacobi map…, or equivalently as the identity
    component of the Picard scheme. Both routes require infrastructure not
    yet available in Mathlib") give a faithful mathematical justification
    for the deferred body, with a pointer to the strategy decision in
    STRATEGY.md. Not an excuse-comment — it states the substantive
    mathematical reason for the gap.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - The "Hypothesis history" block (L44–79) records two genuine
    course-corrections: (1) the iter-003 strengthening from pointwise to
    scheme-level equality on `U` to fix a Frobenius-counterexample
    soundness bug; (2) the iter-125 unused-hypothesis cleanup with
    rename. Useful project history, not stale narrative.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: 1 honest-scaffold `sorry` at L87
  (`rigidity_over_kbar`). Enumerated in directive's "Known issues" block;
  signature matches the proof-decomposition target in `RigidityKbar.tex`.
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - The "Encoding choice" block (L33–46) records that the literal
    `Spec(MvPolynomial …)` encoding of `ℙ¹` would be mathematically wrong
    (`Spec(MvPolynomial)` is the affine line, not the projective line) and
    that the abstract-curve encoding via `genus C = 0` is what the proof
    decomposition actually consumes. Good defensive prose; not an
    excuse-comment.

## Must-fix-this-iter

None. The five known `sorry` bodies (`Jacobian.lean:197`, `Jacobian.lean:223`,
`Cotangent/GrpObj.lean:508`, `Cotangent/GrpObj.lean:635`,
`RigidityKbar.lean:87`) are honest scaffolds with intended-type signatures,
all enumerated in the directive's "Known issues" block. No excuse-comments,
no weakened-wrong definitions, no parallel APIs, no suspect bodies, no
unauthorized axioms.

## Major

None.

## Minor

- `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean:168` — docstring
  forward-references "iter-018 will add the composition-is-zero lemma and
  the connecting hom δ, iter-019 the LES sequence and exactness theorem";
  those iterations have all closed in this file (composition-is-zero at
  L230, δ at L440, sequence at L465, exactness at L592). Forward-reference
  now stale, no longer accurate about *what's queued*.
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` (multiple
  sites: e.g. L737, L749–750, L781, L803) — docstrings forward-reference
  iterations that have long since closed downstream (`iter-013+`,
  `iter-048+` comparison theorems). The work has landed in
  `MayerVietorisCover.lean`. Minor staleness only — does not mislead about
  the local declaration's correctness.
- `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean:438` — line length
  117. Linter-style cosmetic.
- `AlgebraicJacobian/AbelJacobi.lean:22`, `:59` — line length 111, 101.
  Linter-style cosmetic.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:274`, `:285` — line length 111,
  104. Linter-style cosmetic.
- `AlgebraicJacobian/Jacobian.lean:110`, `:119` — line length 107.
  Linter-style cosmetic (L275 is protected per directive, do not touch).

## Excuse-comments (always called out separately)

**None flagged.** The most candidate-looking sites — the docstrings updated
this iter on `_basechange_along_proj_two` (L479–499) and
`mulRight_globalises_cotangent` (L616–623) of `Cotangent/GrpObj.lean` — were
audited carefully against the excuse-comment red-flag list. They describe
**iter-138+ closure plans** for a body that is honestly marked `sorry` in the
docstring itself, citing decomposition into Steps 1–3 and naming the exact
piece (Step 2) that remains blocked. There is no language of the form
"temporary", "stand-in", "wrong but works", "will fix later" or "placeholder
until we figure it out". The body state ("body is `sorry`", "PARTIAL
iter-137", "Step 3 closed iter-136", "Step 2 returned PARTIAL iter-137") is
named verbatim, not concealed.

The `NEEDS_MATHLIB_GAP_FILL` tags at `Cotangent/GrpObj.lean:318` (in a
docstring) and `:345` (on the *fully-closed* `shearMulRight` declaration) are
project-design markers about the **Mathlib gap** each declaration fills, not
admissions of broken local content.

The four docstring sites named in the directive (L427–450, L479–499,
L525–527, L616–623) collectively satisfy: (a) no excuse-comment language;
(b) accurate description of body state (L525–527 describes a closed body and
matches; L479–499 and L616–623 describe `sorry` bodies and label them as
such; L427–450 is a section header that gives an honest "Status:" summary
of all three downstream declarations); (c) iter-138+ analysis is presented
as forward-looking proof design, not lies about the current body.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 6 (4 cosmetic line-length warnings on non-protected lines, 2
  stale forward-reference docstrings in cohomology files)
- **excuse-comments**: 0

Overall verdict: clean iteration — the four iter-137 docstring edits on
`Cotangent/GrpObj.lean` describe the partial body state accurately without
crossing into excuse-comment territory, no new red flags introduced, and
the five tracked honest-scaffold sorries remain the only outstanding
`sorry` sites in the project.
