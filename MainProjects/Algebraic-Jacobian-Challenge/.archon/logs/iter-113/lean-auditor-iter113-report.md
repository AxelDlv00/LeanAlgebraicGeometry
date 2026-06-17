# Lean Audit Report

## Slug
iter113

## Iteration
113

## Scope
- files audited: 17
- files skipped (per directive): 0
- focus: `AlgebraicJacobian/Differentials.lean` (per directive — iter-113 modified helper #1 body at L209 and inserted new top-level helper at L168; signature-touching refactor at L818 / L835 / L976–982). The rest of the project audited thoroughly.
- directive-acknowledged exemptions honoured: (i) the two
  `IsSmoothOfRelativeDimension` deprecation warnings at
  `Differentials.lean:818,835`; (ii) the 5 named-deferred sorries in
  `Differentials.lean` (now L175 / L798 / L880 / L897 / L1039 — see
  note); (iii) the 6 named-deferred sorries in
  `Cohomology/BasicOpenCech.lean` (now L1120 / L1212 / L1536 / L1564 /
  L1754 / L1846); (iv) the protected-signature freeze on the 9 declarations
  in `archon-protected.yaml`.

Note on directive sorry line numbers: the directive lists Differentials
sorries at L175 / L622 / L823 / L840 / L982; the current file (after
iter-113 insertions) has them at L175 / L798 / L880 / L897 / L1039.
Count is the same (5) and the sites are the same six declarations
(`relativeDifferentialsPresheaf_isSheafUniqueGluing_type` + `h_exact`
of `cotangentExactSeq_structure` + `smooth_iff_locally_free_omega` +
`cotangent_at_section` + `serre_duality_genus`). Treating as the same
named-deferred set.

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure import roll-up (15 lines). All 15 modules under `AlgebraicJacobian/` re-exported. Fine.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All three protected declarations (`ofCurve`, `comp_ofCurve`,
    `exists_unique_ofCurve_comp`) are honest one-line projections from
    `(jacobianWitness C).isAlbaneseFor P`. Signatures match protected
    YAML.
  - File-header "Status (iteration 073…)" docstring still accurate
    (witness-based refactor is current).

### AlgebraicJacobian/Genus.lean
- **outdated comments**: 1 flagged (minor)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L39–L61 carries a ~22-line commented-out "Sketch of the route once
    Phase A is available" describing an earlier abandoned Path A
    `OXAsAddCommGrpSheaf` route. Phase A is long since available and
    `genus` is closed via `Module.finrank k (HModule k …)`. The
    commented sketch is historical noise — informative as context but
    not an active road. **Minor**, recommended to delete or move to
    `analogies/`.
  - `genus` itself (L65–L68) is fully closed with the honest body
    `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none (1 named-deferred sorry, see notes)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single sorry at L179: `nonempty_jacobianWitness`. This is the
    "Forbidden shortcut (sanity check)" sorry; the file's docstring
    (L13–38) and the lemma's own docstring (L162–175) document it
    precisely as the single Phase-C scaffolding sorry absorbing both
    higher-genus Albanese existence and genus-0 rigidity. The four
    protected instances on `Jacobian C` all project cleanly from the
    witness — definition not weakened to a wrong stand-in.
  - The "Forbidden shortcut" warning at L30–38 is a *positive* doc
    feature, not an excuse-comment: it explicitly names the wrong
    shortcut (terminal-object definition) and explains why the project
    *does not* take it. Keep.
  - `geometricallyIrreducible_id_Spec` (L120–126) honest small helper.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `GrpObj.eq_of_eqOnOpen` (L79–L114) honestly closed via dominance
    of dense opens + `ext_of_isDominant_of_isSeparated'`. The iter-003
    "Hypothesis correction" comment block (L38–69) documents the
    char-`p` Frobenius counter-example justifying the
    scheme-level-equality hypothesis strengthening. Substantive,
    valuable, keep.
  - The kept "unused" typeclass arguments (`GrpObj X`, `GrpObj Y`,
    `SmoothOfRelativeDimension n/m`, `IsProper X.hom`,
    `GeometricallyIrreducible Y.hom`) — file docstring (L62–67)
    flags them as forward-compat scaffolding. Not bad practice but
    *if* they remain redundant through Phase F closure they should be
    dropped. **Minor watch-item, not a flag.**

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 49 lines, single instance, fully closed via
    `Limits.comp_preservesLimits` +
    `hasSheafCompose_of_preservesLimitsOfSize`. Clean.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 63 lines, three declarations all fully closed. `instHasSheafify_*`
    via `inferInstance`; `instHasExt_*` via `HasExt.standard`;
    `toAbSheaf` via `sheafCompose.obj`. Clean.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (minor)
- **excuse-comments**: none
- **notes**:
  - Large file (934 lines), no sorries, no excuse-comments. Heavy iter-NNN
    annotation noise but each annotation pegs a substantive design
    choice (universe `u` vs `u+1`, `noncomputable abbrev` vs `def`
    for instance-synthesis transparency, `_curve` dot-notation
    wrappers). Keep.
  - L43–L101 (and the `_root_.Functor.const_additive`,
    `_root_.Functor.const_linear`, `_root_.Adjunction.left_adjoint_linear`,
    `_root_.Adjunction.right_adjoint_linear`,
    `_root_.Adjunction.homLinearEquiv`) live in `namespace CategoryTheory`
    and are *typeclass-firing* instances (`instance Functor.const_additive`
    etc.). They are tagged "iter-046 (Mathlib gap-fill)". Two are
    `instance` declarations that register globally for any Mathlib user
    importing this file. **Minor practice flag**: these belong upstream
    in Mathlib; they should be PR'd at some point so they don't
    multi-fire across projects. Tracked as Mathlib-gap-fill in the
    docstrings already — no action needed this iter.
  - Iter-040, iter-041 vs iter-043 carrier-class trichotomy
    (`IsAffineHModuleHomFinite` vs `IsHModuleHomFinite`) thoroughly
    documented at L530–L543: iter-041's affine-Hom-finite class is
    "dead scaffolding" admitting no producer on non-trivial proper
    curves; iter-043's wholespace version is the correct one. Both
    classes still in the file. **Minor**: iter-041's
    `IsAffineHModuleHomFinite` could be pruned now that its
    obsolescence is documented in iter-043's docstring; downstream
    consumers `module_finite_HModule'_of_affine` (L497) and
    `module_finite_HModule'_of_affine_curve` (L512) still reference
    it, so a deletion would cascade. Not blocking. Documented as a
    consumer pair so the substitution is auditable — keep for now.
  - iter-038 → iter-046 chain (`module_finite_HModule_zero` →
    `module_finite_globalSections_of_isProper` →
    `SheafGammaObj_linearEquiv_top` →
    `module_finite_gammaObj_of_isProper` →
    `constantSheafGammaHom_linearEquiv` →
    `instIsHModuleHomFinite_toModuleKSheaf`) reads as an honest
    multi-step closure of the Stein-finiteness side, no shortcuts.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 629 lines, no sorries. iter-034 Mathlib gap-fill
    `Abelian.Ext.chgUnivLinearEquiv` is the only `_root_`-namespace
    helper and is properly tagged as a gap-fill. The Mayer-Vietoris
    LES core (`HModule'_sequence`, `HModule'_sequenceIso`,
    `HModule'_sequence_exact`, `HModule'_δ_toBiprod`,
    `HModule'_fromBiprod_δ`) all closed.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 713 lines, no sorries. `AffineCoverMVSquare` carrier structure
    plus iter-028 → iter-053 wrapper chain
    (`toMayerVietorisSquare`, `HModule'_sequence_curve`,
    `HModule'_X₄_linearEquiv`, `finrank_HModule_eq_HModule'_X₄`,
    `module_finite_HModule_of_HModule'_X₄`, `HasCechToHModuleIso`,
    `HasAffineCechAcyclicCover`,
    `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover`).
    Heavy iter-annotation but documents real geometric content.
  - L51 `cover : U₁ ⊔ U₂ = ⊤` field is a structural totality
    constraint that gets consumed at L101–103
    (`toMayerVietorisSquare_toSquare_X₄ = ⊤` via `S.cover`). Sound.

### AlgebraicJacobian/Cohomology/BasicOpenCech.lean
- **outdated comments**: none (subject to directive exemption)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (major)
- **excuse-comments**: none
- **notes**:
  - 1865 lines. 6 sorry sites (L1120, L1212, L1536, L1564, L1754,
    L1846) all on the named-deferred list per directive. Each sorry
    has a substantive multi-paragraph docstring or in-place comment
    naming the missing infrastructure and the iter-NNN attempt log.
    Not flagged as "missing proof".
  - **Major code-smell**: the
    `cechCofaceMap_pi_smul` declaration (L928–L1120) duplicates the
    iter-080 `letI perI₁/h_mod_pi₁/perI₂/h_mod_pi₂` block verbatim
    twice (once at L944–L963 inside the statement's `let`-prelude
    and again at L972–L991 inside the body's `letI` prelude). The
    comment at L968–971 acknowledges the duplication ("Reconstruct
    the letI block inside the body so subsequent tactics that
    reference perI₁/h_mod_pi₁/perI₂/h_mod_pi₂ by name find them in
    scope. The values are definitionally equal…"). Same pattern
    repeats in `cechCofaceMap_summand_family_R_linear`
    (L502–L603, L547–L566), `cechCofaceMap_summand_family'_R_linear`
    (L642–L734, L689–L708), and the `letI`-block at L1630–L1659 +
    L1672–L1694 inside `h_K₀_exact`. The duplication is a
    consequence of `letI`-in-statement-type binding propagation
    friction (per the comments). It's not "wrong code", but each
    duplicate is a maintenance hazard if the geometric setup ever
    changes (e.g., a different affine-restriction algebra). Tracking
    via extracted module/algebra helpers should be queued post
    iter-113. **Major** (not must-fix this iter, but a structural
    debt).
  - The verbose iter-099/iter-101/iter-103/iter-107 inline-comment
    blocks (L1082–L1108) document a working "exhausted route" log
    that supplied the recipe for the named-deferred sorry at
    L1120. Comments are accurate to current state. Keep until the
    sorry closes; prune after.
  - `splitEpi_pi_lift_of_injective` (L362–L391) uses `classical`
    + `by_cases h : ∃ b, f b = a` + `h.choose_spec ▸ ...` to assemble
    a `SplitEpi` of a product projection. Honest, no shortcuts.
  - `presheafMap_restrict_collapse` (L425–L434), iter-087 extract;
    correct one-line `congr 1`-after-`map_comp` argument.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: 1 flagged (minor)
- **suspect definitions**: none
- **dead-end proofs**: none (5 named-deferred sorries per directive)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Focus area (iter-113):** the new top-level helper at L168–175
    `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` is
    well-stated. Its body is `sorry` and the docstring (L127–167)
    spells out a concrete 3-step closure recipe (compatibility ⇒
    gluing on structure-sheaf; universal property of
    `KaehlerDifferential`; uniqueness via
    `span_range_derivation`). This is the *correct factoring* — the
    sub-helper isolates the load-bearing math into a single
    existential. Approve.
  - **Focus area:** helper #1 body at L209–L234 now properly
    delegates to the unique-gluing sub-helper via the chain
    `IsSheafUniqueGluing → IsSheaf → IsSheafOpensLeCover`
    (`isSheaf_of_isSheafUniqueGluing_types` +
    `IsSheaf.isSheafOpensLeCover`). The two intermediate arrows are
    framework Mathlib equivalences with no math content, so iter-113's
    refactor genuinely reduces the file's mathematical surface to a
    single existential on `IsSheafUniqueGluing`. Sound and clean.
  - **Stale comment (minor):** the file's header "Status (iteration
    064 — scaffold). All main declarations have `sorry` bodies"
    (L27–L30) is no longer accurate — most of the substantive
    Phase B step 1 work has landed by iter-113 (the `α/β` cotangent
    maps, the `h_zero` and `h_epi` branches of
    `cotangentExactSeq_structure`, all four `Bar B` helpers, and the
    iter-112+ refactor wiring). Only 5 sorries remain. Suggest
    refreshing this paragraph to reflect current state.
  - The iter-079/iter-081/iter-083 named gap-fills
    (`_root_.SheafOfModules.epi_of_epi_presheaf` at L634,
    `_root_.PresheafOfModules.Derivation.postcomp_comp` at L651,
    `cotangentExactSeqBeta_hη` at L518) are properly factored as
    top-level lemmas with full docstrings explaining the Mathlib
    gap.
  - `serre_duality_genus` (L1033–L1039) at file end: signature uses
    `(hsmooth : Smooth C.hom)` as an *explicit* hypothesis rather
    than as an instance. Everywhere else in the project the smooth
    hypothesis is recorded as `[SmoothOfRelativeDimension 1 C.hom]`
    (an instance). The explicit-hypothesis form here is a small
    inconsistency. **Minor** signature-style observation; flagged
    rather than blocked since the body is `sorry` and the signature
    can still drift before closure.
  - The directive-acknowledged `IsSmoothOfRelativeDimension`
    deprecation warnings at L818 and L835 are honoured (not
    re-reported).

### AlgebraicJacobian/Modules/Monoidal.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none (1 named-deferred sorry, see notes)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single sorry at L173: `instIsMonoidal_W`. Docstring (L100–L165)
    is exemplary: states the math (sheafification preserves
    presheaf-tensor whisker-isos), names the routes investigated
    (`tensorHom_def` decomposition, `sheafificationCompToSheaf`,
    `MonoidalClosed`), rules each out with a concrete reason
    (`tensorHom_def` circular, `sheafificationCompToSheaf` doesn't
    transfer across the $\mathbb{Z}$-vs-$R_0(U)$-balanced tensor
    mismatch, `MonoidalClosed` not provided by Mathlib for varying
    rings), and points to the Mathlib upstream gap (stalk of
    presheaf-tensor in the varying-ring setting). Closes with "this
    sorry does NOT block downstream consumers". This is a
    well-documented named-deferred sorry, not an excuse-comment.
  - However, it *is* an `instance` that
    `instMonoidalCategoryStruct` (L183) and `instMonoidalCategory`
    (L190) plus `instBraidedCategory` (L209) consume transitively
    via `LocalizedMonoidal`. So `LineBundle X`'s `CommGroup`
    structure transitively rides on this sorry. The docstring at
    L161–L165 acknowledges this. Recorded as "named-deferred per
    user policy 2026-05-11" — accept.

### AlgebraicJacobian/Picard/LineBundle.lean
- **outdated comments**: none
- **suspect definitions**: 2 flagged (major)
- **dead-end proofs**: none (2 sorries, see notes)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Two sorry-bodied `noncomputable def`s** at L82–L86
    (`SheafOfModules.pullback_tensorObj`) and L96–L98
    (`SheafOfModules.pullback_oneIso`). These return data
    (categorical isos) — the bodies `sorry` mean every downstream
    consumer of `Pic.pullback` (which uses both at L116, L125)
    inherits an unrealised promise. Docstrings name them as
    "named-deferred per analogist option (c)" pointing to a Mathlib
    refresh that would land `(SheafOfModules.pullback _).Monoidal`.
    Mathematically sound per the analogist routing, but **major**
    in audit terms because the project explicitly uses sorry-bodied
    `def`s to manufacture data downstream theorems rely on.
    Per the directive these are part of the named-deferred Mathlib
    gap chain and should not be classified as must-fix; recording
    as major for visibility.
  - `Pic.pullback` (L108–L127) honestly builds the monoid hom via
    `Units.map { … }` using `mapSkeleton.obj` +
    `congr_toSkeleton_of_iso` + the two named-deferred isos. Once
    Mathlib lands the monoidality, the body collapses cleanly. Good
    factoring.
  - `Pic.pullback_id` (L131–L142) and `Pic.pullback_comp`
    (L147–L162) both closed honestly. Sound functoriality.

### AlgebraicJacobian/Picard/Functor.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none (1 named-deferred sorry, see notes)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single sorry at L181 (`PicardFunctor.representable`) explicitly
    flagged as the FGA-level result "intentionally deferred. This
    is FGA-level and not honestly closeable within this project's
    iteration scope". Accept.
  - `PicardFunctor` itself (L149–L165), `quotMap` (L99–L115), and
    `fiberMap` (L58–L62) all honestly built, including a quotient
    descent verifying the pullback-range hypothesis. Good.

### AlgebraicJacobian/Picard/FunctorAb.lean
- **outdated comments**: 1 flagged (minor)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File docstring at L31–L41 says "`PicardFunctorAb.etaleSheafified`
    is **scaffolded** … The closure body is a one-liner against
    `CategoryTheory.presheafToSheaf`; the prover round will install
    it." But the closure has *already happened* — the body at
    L107–L111 is the one-liner `(CategoryTheory.presheafToSheaf _ _).obj
    (PicardFunctorAb C)`. **Minor**: refresh the docstring or drop
    the "scaffolded" label; it's accurate that the universe-bump
    handling at L104–L106 ("the universe-lift wrapper used pre-C1
    is no longer needed") is correct, so the file is in fact
    closed, just labeled stale.

### references/challenge.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - This is the original AI-challenge reference spec (Kevin Buzzard
    /Christian Merten setup); it has 9 sorries (L54, L60, L69, L74,
    L78, L82, L89, L95, L107) corresponding to the challenge's
    unfilled declarations. These are by design — the project's
    `AlgebraicJacobian/Jacobian.lean` + `AbelJacobi.lean` +
    `Genus.lean` are the *filled* versions of this reference spec.
    Do not flag.

## Must-fix-this-iter

**None.**

All declarations with `sorry` bodies in the project are either:
(a) On the directive's named-deferred list (5 in `Differentials.lean`
+ 6 in `Cohomology/BasicOpenCech.lean`); or
(b) Explicitly named-deferred at single-instance scale with full
docstrings: `nonempty_jacobianWitness`,
`Modules.instIsMonoidal_W`, `LineBundle.SheafOfModules.pullback_tensorObj`
and `…_oneIso`, `PicardFunctor.representable`.

None of the sorries fits the "excuse-comment" pattern (no
`-- TODO replace`, no `-- placeholder`, no `-- wrong but works`, no
`-- will fix later`). Each is a substantive, multi-paragraph,
mathematically-motivated deferral with a closure plan.

No "weakened-wrong" stand-in definitions detected: the iter-073
`Jacobian C := (jacobianWitness C).J` refactor explicitly *rejected*
the forbidden terminal-object shortcut (see `Jacobian.lean` L30–L38).
`LineBundle X := (Skeleton X.Modules)ˣ` is the mathematically-correct
invertible-object definition (post-C1 refactor; mirrors
`CommRing.Pic` upstream).

No parallel-API-of-existing-Mathlib detected: project-local helpers
in the `_root_.` namespace
(`SheafOfModules.epi_of_epi_presheaf`,
`PresheafOfModules.Derivation.postcomp_comp`,
`Abelian.Ext.chgUnivLinearEquiv`, the iter-046 `Functor.const_additive`
/ `Functor.const_linear` / `Adjunction.{left,right}_adjoint_linear` /
`Adjunction.homLinearEquiv`) are all tagged in docstrings as Mathlib
gap-fills with the upstream candidate already named.

No suspect-`:= rfl`, no `:= True`, no unauthorised `Classical.choice _`
on substantive claims.

## Major

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:944–991 (and
  parallel sites at L502+L547, L642+L689, L1630+L1672)` —
  `letI perI₁/h_mod_pi₁/perI₂/h_mod_pi₂` block duplicated
  statement-side ↔ body-side. Acknowledged in inline comments at
  L968–L971 as a binder-propagation workaround. Each duplicate is a
  maintenance hazard; queue an extraction of the per-i algebra
  instance into a named definition once the iter-104→iter-113 chain
  on `cechCofaceMap_pi_smul` closes.
- `AlgebraicJacobian/Picard/LineBundle.lean:82,96` —
  `SheafOfModules.pullback_tensorObj` and `…_oneIso` are
  sorry-bodied `noncomputable def`s producing data (categorical
  isos) consumed by `Pic.pullback`. Named-deferred per analogist
  option (c) pending Mathlib's
  `(SheafOfModules.pullback _).Monoidal`. Recorded for visibility
  given the downstream cascade through `Pic`, `PicardFunctor`, and
  the Phase C → Phase D arc.

## Minor

- `AlgebraicJacobian/Genus.lean:39–61` — 22-line commented-out
  "Sketch of the route once Phase A is available" describing an
  obsolete Path A `OXAsAddCommGrpSheaf` route. Phase A is closed;
  the commented sketch is historical noise. Suggest deleting (or
  moving to `analogies/`) post-iter-113.
- `AlgebraicJacobian/Differentials.lean:27–30` — header "Status
  (iteration 064 — scaffold). All main declarations have `sorry`
  bodies" is stale. By iter-113 most of the Phase B step 1 work has
  landed; only 5 sorries remain. Refresh the paragraph.
- `AlgebraicJacobian/Differentials.lean:1033` —
  `serre_duality_genus` uses `(hsmooth : Smooth C.hom)` as an
  *explicit* hypothesis instead of the project-standard
  `[SmoothOfRelativeDimension 1 C.hom]` instance. Signature-style
  inconsistency; the body is currently `sorry` so the signature can
  still drift, but watch for drift on closure.
- `AlgebraicJacobian/Picard/FunctorAb.lean:31–41` — header says
  `etaleSheafified` is "scaffolded… one-liner against
  `presheafToSheaf` — the prover round will install it". The
  closure has happened (L107–L111). Drop the "scaffolded" label /
  refresh the iter-008 status block.
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean:530–543`
  — `IsAffineHModuleHomFinite` (iter-041) is marked in iter-043's
  docstring as "dead scaffolding" admitting no producer on
  non-trivial proper curves. Its consumer `module_finite_HModule'_of_affine`
  (L497) and the `_curve` wrapper still reference it. Once
  iter-043's wholespace replacement is fully wired, the iter-041
  class and its consumers can be pruned. Tracked, not blocking.
- `AlgebraicJacobian/Rigidity.lean:62–67` — the
  redundant-but-kept `[GrpObj X]`, `[GrpObj Y]`,
  `[SmoothOfRelativeDimension n X.hom]`,
  `[SmoothOfRelativeDimension m Y.hom]`, `[IsProper X.hom]`,
  `[GeometricallyIrreducible Y.hom]` typeclass hypotheses on
  `GrpObj.eq_of_eqOnOpen` are kept for forward-compatibility with
  the Mumford-rigidity statement. If they remain unused through
  Phase F, drop them — typeclass-search cost compounds.

## Excuse-comments (always called out separately)

**None.**

A grep for `-- TODO`, `-- placeholder`, `-- temporary`, `-- wrong`,
`-- will fix`, `-- standin`, `-- hack`, `-- FIXME` across all 16
project-source `.lean` files yields zero hits. Every `sorry` site
has a substantive multi-paragraph docstring or in-place comment
explaining the deferral. The project documents what it has not
proved, rather than lying about it.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2 — both structural debt / known Mathlib-gap deferrals,
  flagged for visibility, not blocking iter-113.
- **minor**: 5 — stale-status docstring refreshes (Genus,
  Differentials, FunctorAb), one signature-style drift watch
  (Differentials `serre_duality_genus`), and two prune-after-closure
  candidates (StructureSheafModuleK iter-041 class, Rigidity
  redundant typeclasses).
- **excuse-comments**: 0.

Overall verdict: clean iteration. The iter-113 Bar B factoring in
`Differentials.lean` (new sub-helper `relativeDifferentialsPresheaf_isSheafUniqueGluing_type`
+ delegation through `IsSheafUniqueGluing → IsSheaf → IsSheafOpensLeCover`)
is a structurally sound reduction of helper #1's content to a single
substantive existential; the rest of the project is in good standing
with all sorries named-deferred, well-documented, and free of
excuse-comments. Recommended action: queue the doc-string refreshes
(Genus L39–L61 deletion; Differentials L27–L30 update; FunctorAb
L31–L41 status update) as cosmetic cleanup whenever a prover/refactor
pass next touches those files.
