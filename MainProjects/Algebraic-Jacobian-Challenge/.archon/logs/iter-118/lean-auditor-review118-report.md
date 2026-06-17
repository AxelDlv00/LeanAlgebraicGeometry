# Lean Audit Report

## Slug
review118

## Iteration
118

## Scope
- files audited: 10
- files skipped (per directive): 0

(All `.lean` files under `AlgebraicJacobian/` plus the top-level `AlgebraicJacobian.lean`
imports list. Snapshot files under `.archon/logs/**` and lane mirrors are excluded by
project convention — they are frozen historical artifacts, not live source.)

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure `import` list (10 imports). No declarations. Clean.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: 1 flagged (minor)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L14 module docstring header `## Status (iteration 073 — Phase E closes by reduction)`
    is dated (current iter 118). The body's *technical* description of the projection
    pattern (`((jacobianWitness C).isAlbaneseFor P).ofCurve` etc.) still matches the
    actual code below, so it is descriptive rather than actively misleading.
  - The three protected declarations (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`)
    all project uniformly from `jacobianWitness C` with honest `letI`-based instance
    plumbing and `exact ((jacobianWitness C).isAlbaneseFor P).…`. Signatures match
    `archon-protected.yaml`. No excuse-comments.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 known sorry (per directive, not flagged as must-fix)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L87–93 `smooth_locally_free_omega` post-refactor signature: forward-direction-only
    Jacobian criterion. The signature looks well-formed as Lean:
    - `{n : ℕ}` (implicit, per directive)
    - `[SmoothOfRelativeDimension n f]` (current non-deprecated name)
    - Conclusion existentially quantifies over an affine open `U` of `X` containing
      `x`, asserts `Module.Free` and `Module.rank … = n` for the section presheaf
      `R` of `O_X` and the section presheaf `M` of `relativeDifferentialsPresheaf f`.
    - The use of `Module.rank … = n` with `n : ℕ` against `Module.rank` returning
      `Cardinal` relies on the ℕ→Cardinal coercion. This is technically correct (it
      simultaneously asserts freeness and that the rank is the natural number `n`),
      but slightly unusual; `Module.finrank` would be the more idiomatic spelling
      under the same `Module.Free` hypothesis. Minor stylistic note, not a finding.
  - L80–86 docstring honestly discloses that the reverse direction is mathematically
    false without additional input (`H1Cotangent` vanishing), with a concrete
    counterexample. This is responsible disclosure, not an excuse-comment.
  - L93 `sorry` body: known scheduled iter-119 prover lane (directive § Known issues).
    Flagged here but not classified as must-fix.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: 1 flagged (minor)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (minor)
- **excuse-comments**: none
- **notes**:
  - L14–28 module docstring header `## Status (iteration 011 — \`genus\` closure
    scheduled)` is dated (current iter 118). The body still matches the description
    (`Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`), so the
    text is descriptive rather than misleading. Minor.
  - L39–61 a large commented-out historical sketch (`OXAsAddCommGrpSheaf`, `H1OC`)
    documenting an abandoned `AddCommGrpCat`-valued route. This is dead documentation
    and could be pruned to keep the file lean, but it does not affect correctness.
    Minor.
  - L65–68 `genus` definition is honest: `Module.finrank k (Scheme.HModule k
    (Scheme.toModuleKSheaf C) 1)` is the standard mathematical definition
    `dim_k H¹(C, O_C)`. Signature matches `archon-protected.yaml`.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 known sorry (per directive, not flagged as must-fix)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L57–63 `IsAlbanese` definition: standard Albanese universal-property predicate.
    Looks well-formed.
  - L67–84 `IsAlbanese.ofCurve / .comp_ofCurve / .exists_unique_ofCurve_comp`:
    honest `Classical.choose`/`.choose_spec` projections from the existential.
  - L88–114 `IsAlbanese.unique`: honest categorical-uniqueness argument using
    only the universal property. No excuse-comments.
  - L118–126 `geometricallyIrreducible_id_Spec`: small helper, honest body.
  - L143–160 `JacobianWitness` structure: bundles `J : Over (Spec (.of k))`, the
    four required instances, smoothness at `genus C`, and an `∀ P, IsAlbanese …`
    field. The choice to make `isAlbaneseFor` quantify over `P` (so the bundle is
    independent of marked point) is well-motivated by the downstream
    `AbelJacobi.ofCurve P` consumer — documented in the structure's docstring.
  - L176–179 `nonempty_jacobianWitness : Nonempty (JacobianWitness C) := sorry`.
    This is the project's single load-bearing foundational hypothesis, packaging
    Albanese existence + genus-0 rigidity into one deferred existence. Directive
    flags this as known and **not must-fix** (intended, not an excuse-comment).
  - L184–187 `jacobianWitness` uses `Classical.choice` on the above. Honest.
  - L199–221 `Jacobian` + four protected instances: all defined by projection
    from `jacobianWitness C`. Signatures match `archon-protected.yaml`. No
    suspect bodies.
  - L30–38 "Forbidden shortcut (sanity check)" doc block is a useful guard against
    a known wrong-turn (`Jacobian C := 𝟙_ _`); not an excuse-comment, it documents
    why the witness-based design is necessary.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (minor)
- **excuse-comments**: none
- **notes**:
  - L79–114 `GrpObj.eq_of_eqOnOpen` is honestly closed via Mathlib's
    `ext_of_isDominant_of_isSeparated'` plus four small `haveI` instances
    (separatedness, irreducibility, dominance, OverMorphism ext). Proof looks
    direct and well-targeted.
  - L62–67 the docstring's "Hypothesis correction (iter 003 prover)" block
    explicitly notes that `[GrpObj X]`, `[GrpObj Y]`, the two
    `SmoothOfRelativeDimension` typeclasses, `[IsProper X.hom]`, and
    `[GeometricallyIrreducible Y.hom]` are now **redundant** with the strengthened
    hypothesis but kept "to preserve the declaration's 'abelian-variety' intent
    and forward-compatibility with the informal Mumford-rigidity statement". This
    is a self-admitted set of dead typeclass hypotheses on a closed theorem. Not
    an excuse-comment in the wrong-code sense (the theorem is honest), but the
    practice of keeping known-unused typeclass arguments deserves a flag — call
    sites pay the synthesis cost, and the typeclass-search engine has more to
    chew on. Minor.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single instance `instHasSheafCompose_forget_CommRing_AddCommGrp`, honestly
    closed in five lines via `Limits.comp_preservesLimits` +
    `hasSheafCompose_of_preservesLimitsOfSize`. Clean.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three honest declarations: `instHasSheafify_Opens_AddCommGrp`,
    `instHasExt_Sheaf_Opens_AddCommGrp`, and `toAbSheaf`. No issues.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: 1 flagged (major — self-admitted dead scaffolding,
  see Must-fix block)
- **dead-end proofs**: 3 flagged (consumers of the dead class)
- **bad practices**: 1 flagged (Mathlib gap-fills in the file's `CategoryTheory`
  block — see notes)
- **excuse-comments**: 1 flagged (the iter-043 "dead scaffolding" comment — see
  excuse-comment block and Must-fix block)
- **notes**:
  - L47–101 `CategoryTheory` namespace block: five Mathlib gap-fills
    (`Functor.const_additive`, `Functor.const_linear`, `Adjunction.left_adjoint_linear`,
    `Adjunction.right_adjoint_linear`, `Adjunction.homLinearEquiv`). The
    declarations are honest but live in the wrong namespace as a long-term
    pattern — they are upstream-able to Mathlib. Not wrong, but worth tracking.
  - L109–125 `instHasSheafify_Opens_ModuleCatK` / `instHasExt_Sheaf_Opens_ModuleCatK`:
    honest one-liner instances mirroring the iter-004 `AddCommGrpCat` form.
  - L132–225 the structure-sheaf-as-`ModuleCat k`-sheaf construction
    (`kToSection`, `algebraSection`, `algebraMap_eq_kToSection`,
    `kToSection_naturality`, `algebraMap_naturality`, `toModuleKPresheaf`,
    `toModuleKPresheaf_obj`, `toModuleKPresheaf_isSheaf`, `toModuleKSheaf`) is
    honestly closed. Clean.
  - L233–273 cohomology carriers `HModule`, `HModule_zero_linearEquiv`, `HModule'`,
    `HModule'_zero_linearEquiv`: honest definitions and `linearEquiv₀`-based
    bridges. Clean.
  - L338–407 the iter-038 / iter-039 `Module.Finite` transport helpers
    (`module_finite_HModule_zero`, `module_finite_HModule'_zero`,
    `module_finite_HModule_zero_curve`, `module_finite_HModule'_zero_curve`)
    are honest one-line `Module.Finite.equiv` transports. Clean.
  - L418–446 iter-040 `IsAffineHModuleVanishing` class + consumer
    `module_finite_HModule'_of_isAffineHModuleVanishing`: well-formed; class
    has a per-affine vanishing field that *could* admit a producer downstream
    (and indeed has one queued via `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover`
    in `MayerVietorisCover.lean`, though the producer's own hypothesis still
    awaits an instance).
  - **L458–520 iter-041 `IsAffineHModuleHomFinite` chain — self-admitted dead
    scaffolding (see Must-fix block).** L530–543 docstring of iter-043's
    `IsHModuleHomFinite` *explicitly* states "The iter-041 class therefore
    admits no producer instance on a non-trivial proper curve — dead scaffolding."
    Yet `IsAffineHModuleHomFinite` (class, L458–466), its consumer
    `module_finite_HModule'_zero_of_isAffineHModuleHomFinite` (L476–487), and the
    combined consumer `module_finite_HModule'_of_affine` (L497–507) + curve
    variant `module_finite_HModule'_of_affine_curve` (L512–519) all remain in
    the file. Status: known-dead, retained.
  - L544–574 iter-043 `IsHModuleHomFinite` (wholespace) class + consumer
    `module_finite_HModule_zero_of_isHModuleHomFinite` + curve specialisation:
    the live replacement chain. Has a real producer at L765
    (`instIsHModuleHomFinite_toModuleKSheaf` from `[IsIntegral C.left]` +
    `[IsProper C.hom]`). Honest.
  - L605–641 iter-044 `module_finite_globalSections_of_isProper`: substantive
    Stein-finiteness theorem honestly closed via Mathlib's
    `finite_appTop_of_universallyClosed` + `Module.Finite.of_equiv_equiv` +
    explicit ring-iso calc. Clean.
  - L660–667 `SheafGammaObj_linearEquiv_top` and L685–696
    `module_finite_gammaObj_of_isProper`: honest LinearEquiv + transport. Clean.
  - L713–729 `constantSheafGammaHom_linearEquiv` is honestly closed via the
    iter-046 `homLinearEquiv` Mathlib gap-fill + five `haveI` typeclass
    plumbing lines. Clean.
  - L736–739 `homFromOne_linearEquiv`: honest one-liner via
    `ModuleCat.homLinearEquiv ∘ LinearMap.ringLmapEquivSelf`.
  - L765–777 `instIsHModuleHomFinite_toModuleKSheaf`: the live producer chain
    closure. Honest.
  - L795–812, L829–845 `cechCochain_OC`, `cechCohomology_OC`, `cechCochain`,
    `cechCohomology` are honest definitions via Mathlib's `cechComplexFunctor`.
    `cechCochain_OC_eq` and `cechCohomology_OC_eq` are honest `rfl`-bridges.
  - L879–933 `IsCechAcyclicCover` class +
    `subsingleton_HModule'_supr_of_isCechAcyclicCover` + curve variant: honest
    carrier+consumer pattern. The class has no producer yet — it awaits a Čech
    acyclicity construction; this is acknowledged scaffolding (not flagged as
    must-fix since the class is the right *predicate*, not a wrong definition).

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L33–110 Mathlib gap-fill `Abelian.Ext.chgUnivLinearEquiv` + private helpers
    `chgUniv_add`, `chgUniv_smul`. Honestly closed; the helpers use
    `letI := HasDerivedCategory.standard C` + extensionality to reduce to the
    Mathlib lemma `Ext.homEquiv_chgUniv`. Clean.
  - L128–154 `HModule'_cohomologyPresheafFunctor` + `HModule'_cohomologyPresheaf`:
    honest construction. The `noncomputable abbrev` choice on the latter is
    well-motivated for downstream `rfl`-reductions.
  - L171–205 `HModule'_toBiprod` / `HModule'_fromBiprod`: honest biproduct
    `lift`/`desc` constructions mirroring Mathlib's `MayerVietorisSquare` API.
  - L230–239 `HModule'_toBiprod_fromBiprod`: composition-is-zero lemma, honestly
    closed by a single `simp only` invoking the square's `fac`.
  - L250–252, L341–346 Two `ModuleCat`-functor Mathlib gap-fills
    (`ModuleCat_free_isLeftAdjoint`, `ModuleCat_free_preservesMonomorphisms`).
    Honest, upstream-able.
  - L270–280 `HModule'_isPushoutModuleCatFreeSheaf`: honest transfer via
    `Sheaf.composeAndSheafify`. Clean.
  - L302–323 `HModule'_shortComplex`: honest structure-literal mirror.
  - L355–365, L373–380, L388–395, L406–412 `Mono f`, `Epi g`, `Exact`,
    `ShortExact` predicates on the short complex: all honestly closed via
    standard Mathlib lemmas.
  - L440–449 `HModule'_δ` connecting hom: honest `Ext.precomp` of the
    `extClass`.
  - L465–475 `HModule'_sequence` abbrev: honest `ComposableArrows.mk₅`.
  - L479–587 four aux lemmas + main `HModule'_sequenceIso`: long but honest
    proof transferred directly from Mathlib's `AddCommGrpCat`-flavour. The
    repeated `set_option backward.isDefEq.respectTransparency false in` is a
    deliberate (and documented) workaround for transparency interaction with
    typeclass search.
  - L592–625 `HModule'_sequence_exact` + δ-zero simp companions: honestly
    closed via the comparison iso to `Ext.contravariantSequence`.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: 2 flagged (carrier classes wrapping `Nonempty`-of-data
  — see notes)
- **dead-end proofs**: none
- **bad practices**: 1 flagged (`Prop`-class wrapping `Nonempty` of a LinearEquiv-
  valued function)
- **excuse-comments**: none
- **notes**:
  - L50–62 `AffineCoverMVSquare`: honest data bundle. Clean.
  - L71–151 `toMayerVietorisSquare`, the four `_toSquare_X{1,2,3,4}` simp lemmas,
    and `HModule'_sequence` / `_sequence_exact` / `_sequence_curve` /
    `_sequence_curve_exact` are honest projection/specialisation wrappers.
  - L173–192 `HModule'_top_sourceIso`: honest assembly via the three-step
    terminal-collapse iso. Clean.
  - L215–240, L264–288 `HModule_top_linearEquiv`, `HModule'_top_linearEquiv`:
    honest `LinearEquiv.ofLinear` constructions using the iter-031 iso's
    hom/inv. The universe annotations are documented.
  - L300–308 `HModule'_eq_HModule_linearEquiv`: honest one-liner composition
    of the iter-033 `HModule'_top_linearEquiv` with the iter-034
    `chgUnivLinearEquiv` gap-fill from `MayerVietorisCore.lean`.
  - L321–417 corner-bridge / finrank / `Module.Finite` transport specialisations
    (`HModule'_X₄_linearEquiv` / `_curve`, `finrank_HModule_eq_HModule'_X₄` /
    `_curve`, `module_finite_HModule_of_HModule'_X₄` / `_curve`). Honest
    `.symm`-orientation wrappers around the universal bridge.
  - L433–469 `subsingleton_HModule_of_isCechAcyclicCover_top` / `_curve`:
    honest universe-bridged subsingleton transport. Clean.
  - **L490–498 `HasCechToHModuleIso` class wraps `Nonempty (∀ n, LinearEquiv …)`.**
    This is a `Prop`-class wrapping data (a LinearEquiv-valued function) and
    extracted noncomputably via `Classical.choice` (L506–514 `cechToHModuleIso`).
    The pattern is honest and documented (L499–505 comment), but it is a
    suspect *category* of definition: the comparison iso is substantive
    mathematics queued for iter-051+, and wrapping it as `Nonempty` allows
    *any* downstream caller to use the (purportedly-canonical) iso while the
    underlying construction does not exist. There is no producer instance for
    `HasCechToHModuleIso (toModuleKSheaf C) 𝒰` anywhere in the project. Flag
    for major review (see Major block).
  - L530–605 the iter-050 / iter-051 consumers chaining through both classes:
    honest under the assumption that producers will eventually arrive.
  - **L675–682 `HasAffineCechAcyclicCover` class** asserts the existence of a
    Čech-acyclic cover for every affine open. The docstring (L657–674)
    explicitly states "Iter-053 is a thin scaffolding step — the existence is
    asserted, not constructed." There is no producer instance for
    `HasAffineCechAcyclicCover (Scheme.toModuleKSheaf C)` anywhere in the
    project. Same pattern as above — flag for major review.
  - L699–709 `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover`:
    consumer marked `instance`. This *will* fire automatically once a producer
    for `HasAffineCechAcyclicCover` lands — but currently it cannot fire
    (no producer), so it propagates the "unsatisfiable instance" gap to
    `IsAffineHModuleVanishing` and onward.

## Must-fix-this-iter

- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean:530–543` — Excuse-comment
  *of admission*: the iter-043 docstring on `IsHModuleHomFinite` explicitly classifies
  the earlier `IsAffineHModuleHomFinite` (declared L458–466 of the same file) as
  **"dead scaffolding"** that "admits no producer instance on a non-trivial proper
  curve." This admission is correctly worded and helpful, **but the class itself
  and its three downstream consumers (`module_finite_HModule'_zero_of_isAffineHModuleHomFinite`
  L476–487, `module_finite_HModule'_of_affine` L497–507, and the curve specialisation
  `module_finite_HModule'_of_affine_curve` L512–519) remain in the file.**
  Why must-fix: the project openly documents this code as wrong/dead; per
  the lean-auditor directive's must-fix policy, admissions that code is wrong are
  treated as wrong. Either the class needs a real producer (the iter-043 comment
  argues this is impossible) or the dead class + its three consumers must be
  deleted. The pattern of "leave it in case it's useful later" hardens dead code
  in the project.

## Major

- `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean:490–514` — Suspect-category
  definition: `HasCechToHModuleIso` is a `Prop`-class wrapping
  `Nonempty (∀ n, cechCohomology C F 𝒰 n ≃ₗ[k] HModule' k F n (⨆ i, 𝒰 i))`, with
  the comparison iso extracted noncomputably via `cechToHModuleIso :=
  Classical.choice …`. No producer instance exists in the project. Combined with
  `HasAffineCechAcyclicCover` (next entry), this lets downstream code consume a
  Čech-vs-derived comparison theorem without ever constructing it. The pattern is
  internally consistent but defers all substantive content to instance hypotheses
  that may never be satisfied. Consider downgrading to an explicit-argument
  theorem (as in iter-049 `subsingleton_HModule_of_isCechAcyclicCover_top`)
  until a real producer is realistic.
- `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean:675–682` — Same pattern:
  `HasAffineCechAcyclicCover` asserts cover existence per affine open without a
  producer; the project comment (L657–674) self-classifies it as "a thin
  scaffolding step — the existence is asserted, not constructed." The downstream
  instance `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` (L699–709)
  inherits the unsatisfiable-instance gap. Same recommendation as above.
- `AlgebraicJacobian/Rigidity.lean:62–67` — Self-admitted redundant typeclass
  hypotheses (`[GrpObj X]`, `[GrpObj Y]`, two `[SmoothOfRelativeDimension …]`,
  `[IsProper X.hom]`, `[GeometricallyIrreducible Y.hom]`) on `GrpObj.eq_of_eqOnOpen`
  "kept to preserve the declaration's 'abelian-variety' intent". This is unused
  hypothesis bloat — every call site pays the typeclass-synthesis cost. If they
  are dead, delete them; the doc-comment can still mention the *intended*
  application.

## Minor

- `AlgebraicJacobian/AbelJacobi.lean:14` — Status header references iteration 073
  (current 118). Text remains descriptively accurate but is stale-dated.
- `AlgebraicJacobian/Genus.lean:14` — Status header references iteration 011
  (current 118). Same pattern as above.
- `AlgebraicJacobian/Genus.lean:39–61` — Large commented-out historical sketch
  (`OXAsAddCommGrpSheaf`, `H1OC`) preserving an abandoned approach. Could be
  pruned now that the live route through `Scheme.HModule` is closed.
- `AlgebraicJacobian/Differentials.lean:92` — `Module.rank (↑R) (↑M) = n` with
  `n : ℕ` uses the ℕ→Cardinal coercion implicitly. `Module.finrank … = n` would
  read more naturally given the simultaneous `Module.Free` claim. Stylistic; not
  a defect.
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean:47–101` — Five
  Mathlib gap-fill declarations (`Functor.const_additive`, `Functor.const_linear`,
  `Adjunction.left_adjoint_linear`, `Adjunction.right_adjoint_linear`,
  `Adjunction.homLinearEquiv`) live in `namespace CategoryTheory` at the top of
  the file. They are general-purpose and upstreamable; staying here long-term
  bloats this file's surface area.
- `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean:250–252,341–346` — Two
  more Mathlib gap-fills (`ModuleCat_free_isLeftAdjoint`,
  `ModuleCat_free_preservesMonomorphisms`). Also upstreamable.

## Excuse-comments (always called out separately)

- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean:530–543`:
  *"The iter-041 class therefore admits no producer instance on a non-trivial
  proper curve — dead scaffolding."* (attached to `IsHModuleHomFinite`'s
  docstring, classifying `IsAffineHModuleHomFinite` L458–466 of the same file
  as dead). Severity: **major / must-fix**. The class and its three consumers
  remain in the file despite this admission. The dead chain is **load-bearing
  for nothing in the current project** — `Genus.lean`'s `genus` uses `HModule`
  (wholespace), not `HModule'` (per-open), and no `HModule'_of_affine` call
  appears outside this file. Recommended action: delete the four dead
  declarations (`IsAffineHModuleHomFinite`,
  `module_finite_HModule'_zero_of_isAffineHModuleHomFinite`,
  `module_finite_HModule'_of_affine`, `module_finite_HModule'_of_affine_curve`).

(The two `sorry` declarations called out by the directive — `Jacobian.lean`
`nonempty_jacobianWitness` and `Differentials.lean` `smooth_locally_free_omega`
— are *not* excuse-comments. The first is the project's authorised single
foundational hypothesis; the second is the scheduled iter-119 prover lane with
an honest docstring that even discloses the false-as-stated converse direction.
Both are flagged in the per-file checklists for visibility but neither is
classified as must-fix per the directive.)

## Severity summary

- **must-fix-this-iter**: 1 — the iter-043-admitted dead `IsAffineHModuleHomFinite`
  chain in `StructureSheafModuleK.lean` (one excuse-comment of admission + four
  dead declarations).
- **major**: 3 — `HasCechToHModuleIso` and `HasAffineCechAcyclicCover` scaffolding
  classes without producer instances in `MayerVietorisCover.lean`; the redundant
  typeclass arguments on `Rigidity.lean`'s `eq_of_eqOnOpen`.
- **minor**: 6 — stale status headers (AbelJacobi, Genus); commented-out historical
  sketch (Genus); rank-vs-finrank stylistic note (Differentials); two clusters of
  Mathlib gap-fills awaiting upstream (StructureSheafModuleK, MayerVietorisCore).
- **excuse-comments**: 1 (counted under must-fix-this-iter above; called out
  separately because the project openly documents `IsAffineHModuleHomFinite` as
  dead and the dead code remains in the file).

Overall verdict: The two foundational `sorry`s are honestly disclosed and intended;
the bulk of the cohomology infrastructure is technically clean, but the project
has accumulated self-admitted dead scaffolding (the iter-041 chain) and several
unsatisfied-instance carrier classes (`HasCechToHModuleIso`, `HasAffineCechAcyclicCover`)
that defer substantive mathematics to instance hypotheses with no producers in
sight; cleanup should happen before more code accretes around them.
