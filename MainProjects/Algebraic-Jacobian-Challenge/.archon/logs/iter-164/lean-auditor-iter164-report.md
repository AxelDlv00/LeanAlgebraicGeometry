# Lean Audit Report

## Slug
iter164

## Iteration
164

## Scope
- files audited: 15
- files skipped (per directive): 0

Files (project tree, excluding `.archon/`, `.lake/`, `blueprint/` artifacts):
- `AlgebraicJacobian.lean`
- `AlgebraicJacobian/AbelJacobi.lean`
- `AlgebraicJacobian/AbelianVarietyRigidity.lean` *(iter-164 hygiene focus)*
- `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean`
- `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean`
- `AlgebraicJacobian/Cohomology/SheafCompose.lean`
- `AlgebraicJacobian/Cohomology/StructureSheafAb.lean`
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
- `AlgebraicJacobian/Cotangent/GrpObj.lean`
- `AlgebraicJacobian/Differentials.lean`
- `AlgebraicJacobian/Genus.lean`
- `AlgebraicJacobian/Jacobian.lean`
- `AlgebraicJacobian/Rigidity.lean`
- `AlgebraicJacobian/RigidityKbar.lean`

Build status (verified per-file via `lean_diagnostic_messages`): all 5 focus
files compile error-free. Only declared `sorry`s are the three already
documented in the directive and prior memory:
- `AbelianVarietyRigidity.lean:936` (`morphism_P1_to_grpScheme_const`)
- `AbelianVarietyRigidity.lean:960` (`genusZero_curve_iso_P1`)
- `AbelianVarietyRigidity.lean:989` (`rigidity_genus0_curve_to_grpScheme`)
- `Jacobian.lean:265` (`genusZeroWitness.key`)
- `Jacobian.lean:303` (`positiveGenusWitness`)
- `RigidityKbar.lean:88` (`rigidity_over_kbar`)

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 14-line `import` aggregator; nothing to audit.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three short delegators projecting through `(jacobianWitness C).isAlbaneseFor P`. Status block (L14–28) matches the code.

### AlgebraicJacobian/AbelianVarietyRigidity.lean *(iter-164 focus)*
- **outdated comments**: 1 minor
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 minor (dead instance hypotheses)
- **excuse-comments**: none
- **notes**:
  - **Sound-generalisation check (directive item 1)** — VERIFIED.
    - `hom_additive_decomp_of_rigidity` (L813) carries `[GrpObj A] [IsProper A.hom]` on
      the A-side; body uses `A`'s group structure (`μ`, `η`, `Hom.group`),
      `IsSeparated A.hom` (auto from `[IsProper A.hom]`), and feeds these to
      `rigidity_lemma`. Nothing in the body refers to `[Smooth A.hom]` or
      `[GeometricallyIrreducible A.hom]`. The drop is sound and the build is green.
    - `av_regularMap_isHom_of_zero` (L883) B-side carries `[GrpObj B] [IsProper B.hom]`;
      body uses only `μ[A] ≫ α` typing (group on B not consumed beyond the `IsMonHom`
      structure delivery) plus the call to `hom_additive_decomp_of_rigidity` with
      target `B`, which is satisfied by `[GrpObj B] [IsProper B.hom]`. Drop is sound;
      build is green.
    - No external callers exist outside this file (grep confirms only the blueprint
      `\lean{...}` index references the names).
  - **Docstring-vs-reality check (directive item 2)** — VERIFIED for all refreshed
    blocks. The file-header status (L20–53) accurately describes the chain as fully
    proven through `rigidity_lemma` and identifies the three scaffold-`sorry`
    declarations downstream. The status lines on `rigidity_eqAt_closedPoint_of_proper_into_affine`
    (L257), `rigidity_eqOn_saturated_open_to_affine` (L411), `rigidity_eqOn_dense_open`
    (L482, L490), `rigidity_core` (L615, L673, L677), and `rigidity_lemma` (L758, L763)
    all correctly claim PROVEN axiom-clean — verified against the absence of `sorry`
    in their bodies. The `morphism_P1_to_grpScheme_const` docstring (L909–926)
    correctly describes the 𝔾ₘ-scaling shortcut as the new route and marks the body
    as `sorry`-scaffold; no leftover cube/Thm-3.2 narrative.
  - **No new bad practices, no axiom introductions, no protected-signature touches**
    (directive item 3): confirmed. The 3 scaffold sorries at L927/951/976 are
    untouched.
  - **Minor (stale comment) L462–463**: "This `sorry` is therefore the assembly of
    those three Mathlib facts, left for the prover phase — it is no longer an
    as-typed-unprovability." But the assembly is *already* discharged in the
    immediately-following `haveI : JacobsonSpace` block at L464–470. The comment
    reads as forward-looking, one revision behind the code below it.
  - **Minor (dead instance hypotheses) L886**: `[Smooth A.hom]` and
    `[GeometricallyIrreducible A.hom]` (singletons on the SOURCE `A` of `α : A ⟶ B`)
    on `av_regularMap_isHom_of_zero` are not consumed anywhere in the body. The
    body only feeds `[GrpObj A]`, `[IsProper A.hom]`, the three product-side
    instances `[GeometricallyIrreducible (A ⊗ A).hom]`, `[LocallyOfFiniteType (A ⊗ A).hom]`,
    `[IsReduced (A ⊗ A).left]`, and the B-side `[GrpObj B] [IsProper B.hom]` into
    `hom_additive_decomp_of_rigidity`. The iter-164 hygiene edit dropped these from
    the *target* B-side and from `hom_additive_decomp_of_rigidity`'s A-side; the
    parallel cleanup on the *source* A-side here is a natural follow-up
    (not introduced this iter — pre-existing dead-weight surfaced by the audit).

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Header documents file split (iter-063), no live `sorry`.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L504–505: comment "no new axiom introduced" is informational, not an
    introduction; the file is axiom-clean.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single 8-line instance via `Limits.comp_preservesLimits`; clean.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three closed declarations; clean.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 877-line file; grep finds no live `sorry` or `axiom`; header describes
    iter-006 / 040 / 043 / 046 closures with no abandoned narrative.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: 1 major (route framing)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Major (stale narrative) L36–79**: file header "Chart-algebra skeleton for the
    iter-144 piece (ii) pivot ... five sub-pieces of the iter-144 chart-algebra pivot
    route for piece (ii) of the M2.body-pile (per STRATEGY.md § Iter-144 chart-algebra
    pivot — COMMITTED + RigidityKbar.tex § Iter-144 chart-algebra envelope for piece
    (ii))." Per memory and the AVR file header, the differential / chart-algebra route
    has been demoted to off-path fallback (iter-156+) and the project committed to
    Route C (Milne §I.3 via the rigidity lemma + 𝔾ₘ-scaling) iter-163. The closure
    chain documented here ("piece (ii) of the M2.body-pile") is no longer the live
    plan. Each declaration *itself* is closed and axiom-clean (per its individual
    docstring); only the framing as "live committed route" is stale.
  - L20–34 iter-145/146 NOTEs on imports are accurate and useful (record real Mathlib
    paths chosen).

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 2 major (stale section narratives)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Major (stale section narrative) L297–327**: section header "## Piece (i.b) —
    shear-iso globalisation of the cotangent" still announces the closure target
    `mulRight_globalises_cotangent` and describes the 3-step proof chain whose
    Step-2 helpers and the main lemma were EXCISED iter-145 (see the in-place excise
    notes at L552–560 and L624–629). Only the `shearMulRight` iso (Step 1),
    `schemeHomRingCompatibility`, and the Step-3
    `relativeDifferentialsPresheaf_restrict_along_identity_section` remain. The
    section docstring continues to read as a live work plan against code that no
    longer exists in the file.
  - **Major (stale section narrative) L428–525**: "### Helper sub-lemmas and main
    lemma of piece (i.b) ... Status: Step 3 closed iter-136 (no sorry); Step 2
    PARTIAL iter-137 (body remains `sorry`...); Compose main lemma body `sorry`
    pending Step 2 closure (iter-138+ target)" — and the L465–525 docstring
    "Piece (i.b) Step 2: base-change-along-`pr_2` iso (iter-138 PARTIAL skeleton)"
    with the "Three remaining concrete sub-goals (iter-139+ targets)" enumeration.
    Both narrate work on `basechange_along_proj_two_inv*` helpers and
    `relativeDifferentialsPresheaf_basechange_along_proj_two` /
    `mulRight_globalises_cotangent` that were excised iter-145. The actual code
    immediately below these blocks is the iso-reflection bridge and the Step-3
    iso only; none of the "Step 2" helpers exist any longer. Reads as
    misleading future work.
  - L26–28 / L149 frame the file as "piece (i.a) of the shared cotangent-vanishing
    pile" / live consumer is `rigidity_over_kbar` — both reference the abandoned
    differential route. The code itself (`cotangentSpaceAtIdentity`,
    `_finrank_eq`, `shearMulRight`) is sound; the framing is stale.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 144 lines; `relativeDifferentialsPresheaf`, the localization helpers, and the
    forward Jacobian criterion `smooth_locally_free_omega` all sorry-free and clean.
    Counter-example narrative at L117–123 is appropriate (documents the converse
    direction's failure).

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single noncomputable definition; clean.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: 1 major (stale gate-analysis narrative)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Major (stale narrative) L237–263** *inside* `genusZeroWitness.key`'s `sorry`:
    the 3-gate analysis ("(1) IMPORT CYCLE", "(2) CHAR-`p` LOGICAL GAP", "(3)
    BASE-CHANGE FUNCTOR MISSING") was written in iter-156 and is now partially
    outdated:
    - Gate (1) is RESOLVED at the file-graph level: `AbelianVarietyRigidity.lean`
      (the new char-free replacement file) imports only `Genus`, sitting upstream
      of `Jacobian.lean`, so the import cycle no longer exists. The new keystone
      `AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme` is reachable. (The
      *current* blocker is different: the new keystone is itself a `sorry`-scaffold
      at AVR L976.)
    - Gate (2) is RESOLVED at the route level: Route C / Milne §I.3 is char-general
      per memory and AVR header L17–19 ("char-free replacement (no `[CharZero kbar]`)
      for `rigidity_over_kbar`").
    - Gate (3) (base-change functor) still applies if `k → k̄` descent is wanted.
    The comment still presents (1) and (2) as live blockers; that framing has been
    superseded. Note that the body remains correctly `sorry` (since the consumed
    `rigidity_genus0_curve_to_grpScheme` is itself unproved), so no logic issue — only
    the explanatory narrative is stale.
  - L29 references `rigidity_over_kbar` (M2.a; `AlgebraicJacobian.RigidityKbar`) as
    "the substantive mathematical content"; per memory this has been superseded by
    `rigidity_genus0_curve_to_grpScheme` in AVR.
  - L185–207 status block claims the iter-155 skeleton with `key` as the single
    remaining mathematical gap; that part is accurate (matches the file body).

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 123-line scheme-level rigidity packaging. Header history L43–78 documents real
    decisions (iter-003 hypothesis strengthening, iter-125 cleanup). All claims
    match the body.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: 1 major (status block does not reflect "fallback artifact")
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Major (stale narrative) L20–29, L70–74**: the file's status block still
    describes `rigidity_over_kbar` as "the keystone classical input for the M2.a
    sub-step of the genus-0 Albanese-witness argument", with closure "gated on the
    shared cotangent-vanishing Mathlib pile (`analogies/cotangent-vanishing-pile.md`,
    iter-129+) per STRATEGY.md § M2.a + § M2.d-alt." Per memory + `AbelianVarietyRigidity.lean`
    header L17–19, this declaration is now the **fallback route (a) artifact**,
    superseded by the upstream char-free `rigidity_genus0_curve_to_grpScheme`. The
    file is retained in tree, but the status block should reflect "fallback / not
    the live route" rather than presenting the cotangent-vanishing pile as the
    live closure plan. The signature itself (`[CharZero kbar]` retained) is correct
    for an artifact of the abandoned char-zero differential route.

## Must-fix-this-iter

None. All findings are stale-narrative / dead-weight hygiene issues, not weakened
definitions / excuse-comments / suspect bodies. The three scheduled `sorry`s
(AVR L927/951/976) are explicit scaffolds with status lines and are off-limits
per directive.

## Major

- `AlgebraicJacobian/Cotangent/GrpObj.lean:297–327` — section header
  "Piece (i.b) — shear-iso globalisation of the cotangent" announces the closure
  target `mulRight_globalises_cotangent` and a 3-step plan whose Step-2 helpers
  and main lemma were excised iter-145. Reads as a live plan against deleted code.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:428–525` — "Helper sub-lemmas and main
  lemma of piece (i.b)" + "Piece (i.b) Step 2: base-change-along-`pr_2` iso (iter-138
  PARTIAL skeleton)" describe `basechange_along_proj_two_inv*`,
  `relativeDifferentialsPresheaf_basechange_along_proj_two`, and
  `mulRight_globalises_cotangent` as live `sorry` work; all four were excised
  iter-145. Recommended fix: collapse both narratives to a one-paragraph
  "iter-145 excise note + what remains".
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:36–79` — header still frames the
  file as the "iter-144 chart-algebra pivot route for piece (ii) of the M2.body-pile",
  i.e. as the live committed route; per memory this differential / chart route is
  the off-path fallback (Route C committed iter-163). Each declaration itself is
  axiom-clean; only the route framing is stale.
- `AlgebraicJacobian/RigidityKbar.lean:20–29, 70–74` — status block still presents
  `rigidity_over_kbar` as "the keystone classical input for M2.a" with closure
  "gated on the shared cotangent-vanishing Mathlib pile (iter-129+)"; per memory +
  AVR header L17–19 it is now the fallback route (a) artifact superseded by
  upstream `rigidity_genus0_curve_to_grpScheme`. The `[CharZero kbar]` instance is
  correctly retained for the artifact.
- `AlgebraicJacobian/Jacobian.lean:237–263` — the 3-gate "IMPORT CYCLE / CHAR-`p`
  GAP / BASE-CHANGE" analysis inside `genusZeroWitness.key`'s `sorry` is partially
  superseded. Gates (1) and (2) have been resolved by the iter-156+ creation of
  `AbelianVarietyRigidity.lean` (upstream of `Jacobian.lean`, char-general). The
  remaining true blocker is "the consumed `rigidity_genus0_curve_to_grpScheme` is
  itself an unproved scaffold". `sorry` body retention is correct; only the
  narrative needs updating.

## Minor

- `AlgebraicJacobian/AbelianVarietyRigidity.lean:462–463` — the comment "This `sorry`
  is therefore the assembly of those three Mathlib facts, left for the prover phase
  — it is no longer an as-typed-unprovability" is one revision behind: the assembly
  is *already* discharged in the `haveI : JacobsonSpace` block at L464–470.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:886` — `[Smooth A.hom]` and
  `[GeometricallyIrreducible A.hom]` on the SOURCE `A`-side of
  `av_regularMap_isHom_of_zero` are not consumed anywhere in the body. The iter-164
  hygiene edit pruned them from the *target* B-side and from
  `hom_additive_decomp_of_rigidity`; the parallel cleanup on the source A-side
  is a natural follow-up. (Pre-existing dead-weight, not introduced this iter.)
- `AlgebraicJacobian/Jacobian.lean:29` — references `rigidity_over_kbar` (M2.a) as
  "the substantive mathematical content"; the substantive content has migrated to
  `rigidity_genus0_curve_to_grpScheme` in `AbelianVarietyRigidity.lean`. Same
  family as the major Jacobian finding above; calling out separately for the
  header-block specifically.

## Excuse-comments (always called out separately)

None. No `-- TODO replace`, `-- placeholder`, `-- temporary`, `-- wrong but works`,
`-- will fix later`, or analogous excuse-comments were found. The three live
`sorry`s are accompanied by explicit `**Status**: scaffold` markers with named
follow-up iters and rationale — these are scheduled-work markers, not
excuse-comments.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 5 (4 stale section/header narratives across `Cotangent/GrpObj.lean`,
  `Cotangent/ChartAlgebra.lean`, `RigidityKbar.lean`, `Jacobian.lean` referencing
  the abandoned differential route or the now-resolved import-cycle / char-`p`
  blockers; 1 of those is the `GrpObj.lean` file split into 2 region findings).
- **minor**: 3 (1 stale "this `sorry`" comment in AVR, 1 dead-instance hygiene
  follow-up in AVR, 1 stale header reference in `Jacobian.lean`).
- **excuse-comments**: 0.

Overall verdict: iter-164's two-spot signature hygiene drop in
`AbelianVarietyRigidity.lean` is **sound** and the file is clean; the broader
project tree carries an accumulated stale-narrative debt in `Cotangent/`, in
`RigidityKbar.lean`, and inside `Jacobian.lean`'s `genusZeroWitness.key` `sorry`
docstring, all stemming from the iter-156+ route pivot from differential / cotangent
(route a) to Milne §I.3 / Route C — the code on the fallback route is itself
axiom-clean; only the framing needs a narrative refresh.
