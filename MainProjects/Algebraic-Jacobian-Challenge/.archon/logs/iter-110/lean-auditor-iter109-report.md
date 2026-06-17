# Lean Audit Report

## Slug
iter109

## Iteration
109

## Scope
- files audited: 14 (every project `.lean` file under `AlgebraicJacobian/`,
  the umbrella `AlgebraicJacobian.lean`, and `references/challenge.lean`)
- files skipped (per directive): 0

Scope notes:
* `references/challenge.lean` is the upstream challenge spec (v0.1) — it carries
  bare `sorry` bodies on every claimed declaration. It is **read-only reference
  material**, not a build target; sorries there are NOT findings.
* The directive's known-issues block names four carry-over items from
  iter-108. They are NOT re-flagged verbatim; below I report **status updates**
  and **new** findings only.

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure umbrella file: 16-line `import` block, no declarations. Healthy.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All three protected declarations (`ofCurve`, `comp_ofCurve`,
    `exists_unique_ofCurve_comp`) project from `(jacobianWitness C).isAlbaneseFor P`
    via the iter-073 reduction. Bodies are honest; no sorries.
  - Status header L14-29 is current and consistent with the implementation.

### AlgebraicJacobian/Cohomology/BasicOpenCech.lean
- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none (sorries are off-limits this iter per directive)
- **bad practices**: 1 flagged (huge body)
- **excuse-comments**: none
- **notes**:
  - **L17 file-header docstring rot persists.** Carry-over from
    lean-auditor-iter108 (and earlier): the doc-comment claims the file
    "currently carries two labelled substep sorries plus the iter-062 h_a_fun
    scaffolding". Actual sorry sites in this file at iter-109: L1120, L1212,
    L1536, L1564, L1754, L1846 — six sorry bodies. The 2-vs-6 mismatch is
    significant rot, not a typo. This is the documented carry-over.
  - **L1846 DEFERRED block** still cites "Mathlib's `IsLocalizedModule.{Away,pi,
    prodMap}` + `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid`"
    instance names. The directive notes citation precision is being addressed in
    PROJECT_STATUS.md; treating as informational only.
  - L1815 has an apparent typo in the doc-comment block at L1814 ("h_V_affine
    (x : Fin (n + 1) → ↑s₀)") — the binder count `prev n + 1` is used
    elsewhere; minor.
  - L908: `set_option maxHeartbeats 1600000` (8x default) on `cechCofaceMap_pi_smul`
    is large but justified inline at L905-907 by the let-block reconstruction
    cost. Not a finding.
  - **L1700-1755 `g_R` block**: the L1754 `sorry` body of `g_R.map_smul'`
    sits inside an inline `let` that is then consumed by
    `exact_of_localized_span` at L1858. The honest closure depends on the
    upstream `h_diff_pi_smul_g` being restated with `Eq.mpr` casts (per the
    L1742-1754 inline rationale). No new excuse-comment, but the
    "deferred to the next iteration" framing in the inline comment (L1752) is
    starting to look like an excuse-comment as it has now persisted across
    multiple iterations. Flagging as **major** under outdated-comments.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Mathlib gap-fill block at top (`Abelian.Ext.chgUniv_add` /`_smul`/
    `_LinearEquiv`) is structurally clean: each lemma has a body, no sorries.
  - The `HModule'_*` MV LES infrastructure (L130-628) compiles end-to-end as
    closed mirror of Mathlib's `MayerVietorisSquare` API for the `ModuleCat k`
    flavour. Healthy.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All declarations are honestly closed: `AffineCoverMVSquare` structure +
    accessors, the iter-031–035 cover-totality bridges, the iter-036–037
    `Module.Finite` transports, the iter-049–052 subsingleton transports, the
    `HasCechToHModuleIso` carrier class, `HasAffineCechAcyclicCover` carrier,
    and the iter-053 producer instance.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - One `instHasSheafCompose_forget_CommRing_AddCommGrp` instance, fully
    closed via `Limits.comp_preservesLimits` + `hasSheafCompose_of_preservesLimitsOfSize`.
    Status header truthful.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three closed declarations (`instHasSheafify_Opens_AddCommGrp`,
    `instHasExt_Sheaf_Opens_AddCommGrp`, `Scheme.toAbSheaf`). Status header
    truthful.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 934 lines of closed scaffolding for the `ModuleCat k`-valued structure
    sheaf, the `HModule` / `HModule'` cohomology carriers, Čech cochain &
    cohomology infrastructure, and the iter-046 producer instance
    `instIsHModuleHomFinite_toModuleKSheaf`. All bodies closed; no sorries.
  - Universe annotations (L122 `HasExt.{u+1}`) are documented and load-bearing.
  - The Mathlib-gap-fill block at L43-101 (`Functor.const_additive`,
    `Functor.const_linear`, `Adjunction.left_adjoint_linear` / `right_adjoint_linear`,
    `Adjunction.homLinearEquiv`) is in `namespace CategoryTheory` /
    `namespace Adjunction`. Each is small (≤10 LOC) and well-justified.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: 1 flagged (status header)
- **suspect definitions**: none
- **dead-end proofs**: none (sorries are content, not artifacts)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L27-29 status header rot persists.** Carry-over from
    lean-auditor-iter107/iter108: the header still says "iteration 064 —
    scaffold" and "All main declarations have `sorry` bodies." This is no
    longer accurate at iter-109: `cotangentExactSeqAlpha`,
    `cotangentExactSeqBeta`, `cotangentExactSeqBeta_hη`, `universalDerivation`
    are honestly closed (L202+, L440+, L356+, L138+); the `h_zero` branch of
    `cotangentExactSeq_structure` is closed (L522+); `cotangent_exact_sequence`
    is fully closed by assembly (L693+). Remaining sorries: `relativeDifferentialsPresheaf_isSheaf`
    (L122), `cotangentExactSeq_structure.h_exact` (L636), `smooth_iff_locally_free_omega`
    (L718), `cotangent_at_section` (L735), `serre_duality_genus` (L877). The
    "All" claim and the "iteration 064" stamp are both wrong.
  - L185, L338, L424, L501 carry `set_option maxHeartbeats 16000000` (80x
    default) — each is justified by an inline comment near the declaration.
    The four substantial proofs (`cotangentExactSeqAlpha`, `cotangentExactSeqBeta_hη`,
    `cotangentExactSeqBeta`, `cotangentExactSeq_structure.h_zero`) genuinely
    do compute through several adjunction-coherence chains, so the high
    budgets are honest, but the file as a whole now sits at the upper end of
    plausible budget; recommend a profiler pass once the remaining sorries land.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single `genus` definition at L65-68, closed via
    `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)` — the
    honest mathematical definition. Header L14-28 is current.
  - L39-61 commented-out sketch is clearly marked as a "Sketch of the route
    once Phase A is available" and is now obsolete (Phase A IS available); it
    survives only as harmless documentation. Could be pruned, but not a
    finding (just dead text in a comment block, not affecting code).

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: 1 flagged (informational)
- **dead-end proofs**: 1 flagged (off-limits per directive)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L176-179 `nonempty_jacobianWitness` is `:= sorry` on a non-trivial
    existence claim (existence of an Albanese witness for every smooth proper
    geometrically irreducible curve). The doc-comment honestly classifies this
    as the "single remaining mathematical sorry" of the Phase-C scaffolding,
    deferred to a future iteration. Per the iter-108 known-issues block this
    is part of the JacobianWitness exit policy — off-limits this iter.
    Informational only; not re-flagged as must-fix.
  - The `JacobianWitness` structure itself (L143-160) is mathematically clean:
    bundles `J : Over (Spec (.of k))` with abelian-variety instance fields and
    a uniform Albanese predicate. The forbidden-shortcut sanity-check block
    (L31-39) is a strong piece of documentation and worth preserving.
  - The four protected instances (`instGrpObj`, `smoothOfRelativeDimension_genus`,
    `instIsProper`, `instGeometricallyIrreducible`) all project from
    `jacobianWitness C`, exactly mirroring `AbelJacobi.lean`'s pattern.

### AlgebraicJacobian/Modules/Monoidal.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged (off-limits per directive)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L166-173 `instIsMonoidal_W` body is `sorry`. Per iter-108 known-issues
    block, this is the named-deferred Mathlib gap (stalk-of-presheaf-tensor in
    varying-ring setting), and per L161-165 the sorry is documented as NOT
    blocking downstream consumers. Off-limits this iter.
  - The doc-comment for `instIsMonoidal_W` (L100-165) is unusually long but is
    a useful audit trail of investigated routes (iter-079, iter-080 stalks,
    `tensorHom_def`, `sheafificationCompToSheaf`, `MonoidalClosed`). I'd
    consider it borderline excessive but not a finding — it's a record of
    work, not an excuse.
  - All other declarations (`tensorObj`, `instMonoidalCategoryPresheaf`,
    `sheafificationFunctor`, `W`, `sheafificationIsLocalization`,
    `instMonoidalCategoryStruct`, `instMonoidalCategory`,
    `instBraidedCategoryPresheaf`, `instBraidedCategory`) are honestly
    closed.

### AlgebraicJacobian/Picard/Functor.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged (off-limits per directive)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L176-181 `PicardFunctor.representable` is `:= sorry` on a non-trivial
    representability claim. Per iter-108 known-issues block, this is the
    Phase C3 deferral via the JacobianWitness exit policy — off-limits this
    iter. The doc-comment (L165-175) is honest about the deferral.
  - All other declarations (`PicardFunctor.fiberMap`, `fiberMap_comp_snd`,
    `fiberMap_comp_fst`, `fiberMap_id`, `fiberMap_comp`, `quotMap`,
    `quotMap_mk`, `quotMap_id`, `quotMap_comp`, `PicardFunctor`) are
    honestly closed.

### AlgebraicJacobian/Picard/FunctorAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All four declarations (`PicardFunctorAb`, `PicardFunctorAb.forgetCompare`,
    `PicardFunctorAb_forget_obj`, `PicardFunctorAb.etaleSheafified`) are
    honestly closed. Status headers at L19-31 and L32-41 are current.

### AlgebraicJacobian/Picard/LineBundle.lean
- **outdated comments**: none
- **suspect definitions**: 2 flagged (named-deferred Mathlib gaps)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L52 `LineBundle` definition is now mathematically correct** (per
    iter-108 known-issue resolution). The new body
    `def LineBundle (X : Scheme.{u}) : Type _ := (Skeleton X.Modules)ˣ`
    is the units of the skeleton of the symmetric monoidal category
    `X.Modules`, which is the correct categorical formulation of "isomorphism
    classes of invertible quasi-coherent O_X-modules under tensor product".
    The mirror to `CommRing.Pic R := Shrink (Skeleton (SemimoduleCat R))ˣ`
    is faithful (modulo the `Shrink` wrapper, which the file does not need).
    The C1 promotion is sound.
  - L52 `Pic` (line 69) is now `abbrev Pic (X) := LineBundle X`, so the
    Picard group inherits the `CommGroup` instance from `instCommGroupLineBundle`
    (L64) automatically.
  - **L82-86 `SheafOfModules.pullback_tensorObj`** body is `sorry`. The
    doc-comment honestly classifies this as a named-deferred Mathlib gap
    (per `analogies/c1-route.md`, option (c)), and notes that a future Mathlib
    refresh that lands `(SheafOfModules.pullback _).Monoidal` will collapse
    this to `MonoidalCategoryStruct.tensorObj_iso`. This is honest deferral,
    not an excuse — the gap is structural, not project-local. Informational.
  - **L96-98 `SheafOfModules.pullback_oneIso` (NEW iter-109)** body is
    `sorry`. The doc-comment is well-formed, references the existing
    `pullback_tensorObj` as its sibling, classifies itself as part of the
    same Mathlib gap, and notes that a future Mathlib refresh collapses it
    to `Monoidal.εIso`. Signature is sound (the unit-preservation iso
    `(pullback f).obj (𝟙_ Y.Modules) ≅ 𝟙_ X.Modules`). Honest deferral.
  - **L108-127 `Pic.pullback`** body is now closed using both helpers above
    plus `Functor.mapSkeleton`. The `map_one'` and `map_mul'` proof bodies
    type-check, route through `Functor.mapSkeleton_obj_toSkeleton` and
    `congr_toSkeleton_of_iso`, and assemble a `Units.map` term. The proof
    skeleton is mathematically correct.
  - **L131-142 `Pic.pullback_id`** body is closed via `Scheme.Modules.pullbackId`
    + `congr_toSkeleton_of_iso` + `Quotient.out_eq`. Honest 8-line proof.
  - **L147-162 `Pic.pullback_comp`** body is closed via
    `Scheme.Modules.pullbackComp` + `congr_toSkeleton_of_iso` +
    `(Scheme.Modules.pullback f).mapIso (fromSkeletonToSkeletonIso _).symm`.
    Honest 12-line proof.
  - **File-header docstring (L9-38) is consistent with the new state.** It
    correctly names L96 `pullback_oneIso` as a sibling of L82
    `pullback_tensorObj`, both as named-deferred Mathlib gaps under analogist
    option (c). The "load-bearing transitive dependency" warning at L22-29
    correctly identifies `instIsMonoidal_W` (`Modules/Monoidal.lean:166`,
    not L173 as the docstring says) as the post-C1 bedrock sorry.
    **Minor:** the docstring cites `:166` for `instIsMonoidal_W`, but the
    declaration site (the `noncomputable instance` keyword) is at L166 and
    the `sorry` body is at L173. Either is defensible; flagging as a minor
    line-number inconsistency.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single theorem `GrpObj.eq_of_eqOnOpen` (L79-114), honestly closed via
    `ext_of_isDominant_of_isSeparated'`. The hypothesis-correction block
    (L38-69) explaining the iter-003 strengthening from point-wise to
    scheme-level equality is an exemplary piece of audit documentation —
    correct, justified, and load-bearing.

### references/challenge.lean
- **outdated comments**: none
- **suspect definitions**: 7 flagged (every load-bearing claim is `:= sorry`)
- **dead-end proofs**: 0 (these are challenge prompts, not proofs)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **READ-ONLY UPSTREAM CHALLENGE FILE.** Carries `:= sorry` on every
    declaration (`genus`, `Jacobian`, four `Jacobian` instances, `ofCurve`,
    `comp_ofCurve`, `exists_unique_ofCurve_comp`). This is the v0.1 challenge
    spec from the upstream organisers; it is the *target* the project is
    formalising into honest proofs in `AlgebraicJacobian/`. **Sorries here
    are NOT findings** — they are the input contract of the project.

## Must-fix-this-iter

(none)

The four critical/major carry-over findings from lean-auditor-iter108 named
in the directive's known-issues block (LineBundle weakened-wrong def, the two
off-limits sorries, the Differentials.lean status header) are tracked but
NOT re-reported here. The LineBundle one is now resolved (verified above);
the two off-limits sorries are explicitly off-limits this iter; the
Differentials.lean cosmetic header is a major, not a must-fix.

## Major

- `AlgebraicJacobian/Differentials.lean:27` — Status-header rot. The header
  reads "iteration 064 — scaffold / All main declarations have `sorry` bodies"
  but at iter-109 several main declarations (`cotangentExactSeqAlpha`,
  `cotangentExactSeqBeta`, `universalDerivation`, `cotangent_exact_sequence`)
  are honestly closed and the in-flight `cotangentExactSeq_structure` has
  `h_zero` and `h_epi` closed (only `h_exact` remains). Carry-over from
  lean-auditor-iter107 / iter108. **Cosmetic but increasingly misleading**;
  recommend a one-shot rewrite of the Status block by the next plan agent
  pass.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:17` — File-header docstring
  rot (carry-over from lean-auditor-iter108). The docstring says the file
  carries "two labelled substep sorries plus the iter-062 h_a_fun
  scaffolding". Actual sorry sites at iter-109: L1120, L1212, L1536, L1564,
  L1754, L1846 — six sorries. Carry-over.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:1742` — In-flight comment
  inside `g_R.map_smul'` body says the proof is "Deferred to the next
  iteration." This phrasing has now sat across multiple iterations without
  being acted upon; while the underlying technical reason (h_diff_pi_smul_g
  needs Eq.mpr casts) is legitimate, the "next iteration" framing is
  starting to harden into an excuse pattern. Recommend either acting on it
  or rewriting the comment to honestly say "deferred behind the
  cechCofaceMap_pi_smul closure" so it doesn't read like a perpetual
  punt.

## Minor

- `AlgebraicJacobian/Picard/LineBundle.lean:26` — File-header docstring cites
  `instIsMonoidal_W` location as `Modules/Monoidal.lean:166`. The
  `noncomputable instance instIsMonoidal_W` keyword is at L166 but its `sorry`
  body is at L173. Either line is defensible; flagging only because we now
  have a project-wide push for citation precision.
- `AlgebraicJacobian/Genus.lean:39-61` — Block of commented-out historical
  sketch ("Sketch of the route once Phase A is available") is now obsolete
  (Phase A is available, and the iter-011 closure replaces it). Could be
  pruned to ~5 lines or deleted entirely. Not a correctness issue.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:923` — `cechCofaceMap_pi_smul`
  doc-comment says "The body is `sorry`; the iter-088+ prover closes it."
  but the body still has its terminal `sorry` at L1120 (iter-107+). Update
  the doc-comment to reflect that closure has been in flight across multiple
  iterations.

## Excuse-comments (always called out separately)

(none flagged at must-fix level this iter)

The L1742 "Deferred to the next iteration" comment in
`BasicOpenCech.lean` (flagged Major above) is borderline excuse-comment
material: it's not an outright "TODO replace with real def" admission, but
the cross-iteration repetition is starting to look like one. The directive's
must-fix bar is "the code is wrong" — this comment is honestly tracking
work-in-progress, so I'm leaving it at Major rather than escalating.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3 (BasicOpenCech.lean:17 header rot · Differentials.lean:27
  header rot · BasicOpenCech.lean:1742 cross-iter "next iteration" framing)
- **minor**: 3 (LineBundle.lean:26 line-number citation drift ·
  Genus.lean:39-61 obsolete commented sketch · BasicOpenCech.lean:923
  doc-comment rot)
- **excuse-comments**: 0 (must-fix level)

Overall verdict: **Healthy.** The C1 promotion of `LineBundle` to
`(Skeleton X.Modules)ˣ` is mathematically correct; the new
`SheafOfModules.pullback_oneIso` helper is a sound named-deferred Mathlib
gap; downstream `Pic.pullback` / `pullback_id` / `pullback_comp` are
honestly closed; the four remaining off-limits sorries are documented in
the iter-108 known-issues policy. The repeated header-docstring rot
(Differentials.lean:27, BasicOpenCech.lean:17, both unaddressed across
≥3 iterations) is the single recurring quality-of-life finding worth a
plan-agent cleanup pass next iter.
