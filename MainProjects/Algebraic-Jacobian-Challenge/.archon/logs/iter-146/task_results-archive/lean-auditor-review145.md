# Lean Audit Report

## Slug
review145

## Iteration
145

## Scope
- files audited: 14
- files skipped (per directive): 0

Enumerated via `find` under `AlgebraicJacobian.lean` and `AlgebraicJacobian/`,
excluding `.archon/`, `.lake/`, `blueprint/`, `references/`. All 14 source
files were read in full.

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Top-level aggregator importing every project module. No declarations.
    Clean.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All three protected declarations (`ofCurve`, `comp_ofCurve`,
    `exists_unique_ofCurve_comp`) reduce to projection from
    `(jacobianWitness C).isAlbaneseFor P`. The repeating `letI :=
    (jacobianWitness C).{grpObj,proper,smooth,geomIrred}` four-line preamble
    could be hoisted to a `variable` block, but this is cosmetic. No
    semantic concerns.
  - The iter-073 status banner accurately describes the current body shape.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 627-line file. All `noncomputable def` / `instance` / `lemma`
    declarations carry honest bodies (Mathlib pattern transports + the
    iter-016 → iter-026 abstract Mayer-Vietoris infrastructure). The
    `Abelian.Ext.chgUnivLinearEquiv` gap-fill is built from genuine
    additivity / `R`-linearity helpers.
  - Many `iter-NNN` markers forward-reference work that has since landed
    (e.g. L156 "iter-018 will add ... iter-019 ..." with iter-018/019 lemmas
    closed below in the same file). Not stale by audit's normal standard
    — these are historical commit-trail markers, accurate in context.
  - One `set_option backward.isDefEq.respectTransparency false` (L354)
    plus uses at L523, L539, L565. Each is justified inline; the
    pattern mirrors Mathlib `MayerVietorisSquare.lean` verbatim.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 712-line file. 2-affine cover MV bridges, cover-totality bridges,
    `IsCechAcyclicCover` consumers, `HasCechToHModuleIso` / `HasAffineCechAcyclicCover`
    `Prop`-classes, and the `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover`
    producer. All bodies are real proofs (no `sorry`).
  - `HasAffineCechAcyclicCover` (L675-682) is a `class` with
    `exists_cover : ∀ {U}, IsAffineOpen U → ∃ ι 𝒰, … ∧ IsCechAcyclicCover F 𝒰
    ∧ HasCechToHModuleIso F 𝒰`. The `HasCechToHModuleIso` predicate carries
    a `Nonempty (∀ n, …)` field (`Prop`-wrapped data). Together they
    package the open multi-iteration content (Koszul + Čech comparison)
    behind a class hypothesis the iter-054+ producer fires from. This is
    standard scaffolding — the existence is asserted as a class, not
    forged as a `Lemma`-style claim; the audit-relevant judgement is that
    `HasAffineCechAcyclicCover` is a class with no project-supplied
    instance for the structure sheaf yet, so downstream consumers
    necessarily carry it as a typeclass hypothesis. No `instance` for
    `HasAffineCechAcyclicCover (Scheme.toModuleKSheaf C)` is present in
    the file — clean.
  - `set_option backward.isDefEq.respectTransparency false` re-used at
    L354 (matched in `MayerVietorisCore.lean`).

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 49-line file. Single instance `instHasSheafCompose_forget_CommRing_AddCommGrp`
    closed by `comp_preservesLimits` + `hasSheafCompose_of_preservesLimitsOfSize`.
    Status header accurate.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 63-line file. Three closed declarations (`instHasSheafify`,
    `instHasExt`, `toAbSheaf`). Status header accurate.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: 0
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 877-line file. Long but disciplined: kernel-level `Functor.const_*`
    additivity/linearity instances, `Adjunction.{left,right}_adjoint_linear`
    + `homLinearEquiv` gap-fills, the structure-sheaf-as-k-modules chain
    (helpers (1)–(8)), `HModule` / `HModule'` carriers, iter-038–iter-046
    `Module.Finite` propagation, iter-040 / iter-043 `Prop`-class
    predicates (`IsAffineHModuleVanishing`, `IsHModuleHomFinite`),
    iter-046 producer instance for `IsHModuleHomFinite k C (toModuleKSheaf C)`
    on proper integral curves, Čech complex carrier + parameterised /
    structure-sheaf-specialised duo, iter-048 `IsCechAcyclicCover`
    class.
  - L37–48 "Historical note on the abandoned per-affine-open variant" is
    a methodologically honest comment that documents why the iter-041
    attempt was deleted (Γ(U, O_C) is not finite over k on a proper
    affine open of a non-trivial curve). Not stale.
  - The L40–48 dead-scaffolding admission is reproduced in the
    `IsHModuleHomFinite` docstring at L462–486. Consistent.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: none
- **suspect definitions**: 5 flagged (`: True := sorry` placeholders)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 5 flagged
- **notes**:
  - The five `: True := sorry` declarations are isolated scaffolding
    with no current external consumers (`grep` confirms each name
    appears only in this file). The TODO iter-146 comments are explicit
    placeholders: "real signature; placeholder is `: True`."
  - Per the directive, this was authorised as iter-145 scaffolding; the
    cited cautionary tale is the iter-128 → iter-131 cotangent body-shape
    refactor. The audit verdict is nonetheless that the five placeholder
    signatures match the "weakened-wrong definition" + "excuse-comment" +
    "suspect body" patterns enumerated in the auditor's
    Must-fix-this-iter rules verbatim, and the audit is required by its
    own descriptor to classify higher rather than lower.
  - Concretely: a top-level `theorem foo : True := sorry` is a
    rhetorical no-op — there is no mathematical content the body could
    falsify because `True` is provable by `trivial`. The `sorry` is
    therefore not even substantive; the placeholder is purely a
    name-reservation, but the *name* asserts a nontrivial mathematical
    claim (e.g. "algebra_isPushout_of_affine_product"). The disconnect
    between the name's mathematical promise and the type's vacuous
    `True` is precisely the weakened-wrong-definition pattern: a
    consumer reading the file index sees five named theorems and a
    `True`-shape signature gives them no way to refute their
    correctness.
  - In the auditor's framework these are five separate
    must-fix-this-iter findings (see Must-fix-this-iter section). The
    file's intent (scaffolding, not load-bearing) is acknowledged; the
    classification still lands at must-fix because the auditor's stance
    is documented as strict and project-bias-blind.
  - The iter-145 NOTE comment at L10–16 documents the import-set
    deviation from the directive (`IsPushout` → `IsTensorProduct`,
    `CharP.Frobenius` omitted). Honest meta-comment; not flagged.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 631-line file (down from ~903 LOC per directive). Two substantive
    declarations remain load-bearing: `cotangentSpaceAtIdentity` (def,
    no sorry) and `cotangentSpaceAtIdentity_finrank_eq` (theorem, no
    sorry). Both closed via the iter-130–iter-132 affine-chart base-change
    route.
  - The companion `cotangentSpaceAtIdentity_eq_extendScalars` body-shape
    lemma is closed by a controlled `Classical.choose`-chain extraction
    + `refine` chain. No semantic concerns.
  - **STALE section header** at L398-406: `/-! ### Helpers / main lemma for piece (i.b)`.
    The prose says "The remaining declarations of this section state the
    helper sub-lemmas and main lemma of piece (i.b) at the
    presheaf-of-modules level" — but the iter-145 excise removed the
    main lemma (`mulRight_globalises_cotangent`) and the Step 2 chain
    (`basechange_along_proj_two_inv_*`, `…_basechange_along_proj_two`).
    Only Step 3 (`…_restrict_along_identity_section`) remains. The
    paragraph's plural ("sub-lemmaS and main lemma") is stale.
  - **STALE multi-paragraph status banner** at L428–525 (`/-! ### Helper
    sub-lemmas and main lemma of piece (i.b)`): describes the
    "Status: Step 3 closed iter-136 (no sorry); Step 2 PARTIAL iter-137
    ... Compose main lemma body `sorry` pending Step 2 closure (iter-138+
    target)" and the L465–525 sub-banner detailing the
    `basechange_along_proj_two_inv*` Route (b) skeleton + three concrete
    sorry-targets. None of the Step 2 / Compose declarations exist any
    more; the L465–525 prose actively describes excised work. The
    iter-145 EXCISE breadcrumb at L552–560 partially absolves these by
    explicitly naming the four excised declarations, but the L428–525
    narrative still misleads a reader who linearly arrives at it before
    L552.
  - **Orphan helpers** (per directive, confirmed by grep — each name
    appears only in this file):
    - `shearMulRight` (L350, `@[simps] def`).
    - `shearMulRight_hom_fst`, `shearMulRight_hom_snd` (L387, L392;
      both `@[reassoc (attr := simp)] lemma`).
    - `schemeHomRingCompatibility` (L424, `noncomputable def`).
    - `isIso_of_app_iso_module` (L544, `private theorem`).
    - `relativeDifferentialsPresheaf_restrict_along_identity_section`
      (L579, `noncomputable def`).
    - `section_snd_eq_identity_struct` (L458, `private lemma`) — used
      only inside `…restrict_along_identity_section`, which is itself
      orphan.
    The directive flags these as known orphans that iter-145 chose not
    to delete; the audit concurs they have no external consumer. Minor.
  - The iter-145 EXCISE breadcrumb at L552–560 is intentional per the
    directive. Not flagged.
  - The L297-area EXCISE-adjacent section header at L297–327 ("Piece
    (i.b) — shear-iso globalisation of the cotangent") describes the
    iter-134+ piece (i.b) build-out and names the three structural
    pieces `shearMulRight`, `…basechange_along_proj_two`,
    `…restrict_along_identity_section`. Two of the three are now either
    orphan or excised; the prose at L297–327 doesn't quite cross the
    audit's "actively misleads" threshold because the structural-piece
    list still corresponds to declarations that *did* exist in the
    project's history, but a reader looking up the second piece
    (`…basechange_along_proj_two`) will find no such declaration. Borderline
    stale; classified minor.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 144-line file. `relativeDifferentialsPresheaf`, the obj-Kähler
    identity lemma, `kaehler_localization_subsingleton`,
    `kaehler_quotient_localization_iso`, and the forward Jacobian
    criterion `smooth_locally_free_omega` all carry honest bodies
    (no `sorry`). The L118–123 disclosure about the false reverse
    direction is mathematically honest documentation.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 45-line file. `genus C := Module.finrank k (Scheme.HModule k
    (Scheme.toModuleKSheaf C) 1)` — honest one-line body. Status header
    accurate.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none (the two sorry-bodied scaffolds are
  signatured against the real shape, see notes)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 2 (`genusZeroWitness` body `sorry`,
  `positiveGenusWitness` body `sorry`)
- **notes**:
  - **STALE file-level status header at L20–30**. The header reads
    'This file currently contains TWO `sorry`-bodied declarations (the
    Phase-C scaffolding inventory):' and enumerates `genusZeroWitness`
    (item 1) and `nonempty_jacobianWitness` (item 2). But the actual
    file contents are:
    - `genusZeroWitness` (L193–197): body `sorry`.
    - `positiveGenusWitness` (L219–223): body `sorry`. *Not mentioned
      in the inventory.*
    - `nonempty_jacobianWitness` (L249–254): body is
      `by_cases h : genus C = 0 / exact ⟨genusZeroWitness C h⟩ / exact
      ⟨positiveGenusWitness C (Nat.pos_of_ne_zero h)⟩` — **no `sorry`
      in this body**.
    The header is stale on two counts: (a) the count is wrong (3 sorries
    in the file, distributed across 2 declarations after iter-135's
    restructure that delegated `nonempty_jacobianWitness` to scaffolds),
    and (b) the named-sorry-bearer `nonempty_jacobianWitness` is no
    longer a sorry-bearer.
    The expanded bullet list at L31–43 *does* mention `positiveGenusWitness`
    and *does* correctly note that `nonempty_jacobianWitness` "absorbs"
    the genus-0 and higher-genus content rather than carrying its own
    sorry — but the opening "TWO" enumeration at L20–30 contradicts the
    expanded list. Stale; classified major.
  - The two scaffolds `genusZeroWitness` and `positiveGenusWitness` are
    sorry-bodied. Both have honest type signatures aimed at the real
    object (a full `JacobianWitness C` with all six fields). The status
    docstrings on each (L186–192 and L209–218) are accurate and name
    the closure dependency precisely. These two are `sorry`-bodied
    declarations on substantive claims — must-fix per the auditor's
    rules. Both excuse-comments listed; their signatures are honest.
  - `nonempty_jacobianWitness`'s body is now an honest `by_cases`
    delegation; the iter-135 restructure removed an inline-sorry at the
    cost of two sorry-bearing scaffolds. Net sorry count is non-zero
    but the *shape* improvement is real and visible.
  - The "Forbidden shortcut (sanity check)" section at L44–53 is a
    useful self-check note (`Jacobian C := 𝟙_ _` would force `genus C
    = 0`). Honest.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 123-line file. `Scheme.Over.ext_of_eqOnOpen` is closed against
    Mathlib's `ext_of_isDominant_of_isSeparated'`. The hypothesis-history
    section (L41–79) is honest archaeology about why the original
    point-wise hypothesis was strengthened to scheme-level equality on
    `U` (Frobenius counterexample). The unused-hypothesis cleanup
    at iter-125 (L69–79) is consistent with the visible signature.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 1 (`rigidity_over_kbar` body `sorry`)
- **notes**:
  - 89-line file. Single declaration `rigidity_over_kbar` body `sorry`.
    Status banner (L20–46) accurate: iter-126 scaffold; M2.a closure
    gated on the shared cotangent-vanishing pile. Encoding choice
    (Option B abstract genus-0 curve, not literal ℙ¹) is explicitly
    documented and mathematically correct.
  - The `_hgenus`, `_hf` underscored hypothesis names are intentional
    (unused hypotheses kept in the signature pending body closure that
    will consume them). Not flagged.

## Must-fix-this-iter

Apply verbatim. The following land here automatically per the auditor's
own classification rules. Soft severity is how wrong code hardens into
the project.

- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:50` —
  `theorem algebra_isPushout_of_affine_product : True := sorry`.
  Why must-fix: `:= sorry` body + `:= True` type-shape + excuse-comment
  ("placeholder is `: True`") — triple-hit on the must-fix rule set.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:59` —
  `theorem df_zero_factors_through_constant_on_chart : True := sorry`.
  Why must-fix: same triple-hit pattern; the declaration name promises a
  Kähler-derivation factorisation statement, the signature delivers `True`.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:69` —
  `theorem KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero : True := sorry`.
  Why must-fix: same triple-hit pattern; the declaration is even
  `KaehlerDifferential`-namespaced (project-anchored gap-fill style),
  which raises the bar — a downstream consumer pattern-matching the
  namespace would be misled.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:77` —
  `theorem constants_integral_over_base_field : True := sorry`.
  Why must-fix: same triple-hit pattern. The promised statement
  (`Γ(X, O_X) = k` for smooth proper geometrically irreducible `X` over
  `k`) is mathematically known and substantive — a `: True` placeholder
  is wrong in proportion to how substantive the real statement is.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:89` —
  `theorem ext_of_diff_zero : True := sorry`.
  Why must-fix: same triple-hit pattern; the scheme-level lift docstring
  explicitly describes a `Scheme.Over.ext_of_eqOnOpen`-shape claim and
  the type is `True`.
- `AlgebraicJacobian/Jacobian.lean:193` —
  `noncomputable def genusZeroWitness ... : JacobianWitness C := sorry`.
  Why must-fix: load-bearing scaffold for the genus-0 arm of
  `nonempty_jacobianWitness`. Honest signature, but `:= sorry` body on
  a substantive existence claim.
- `AlgebraicJacobian/Jacobian.lean:219` —
  `noncomputable def positiveGenusWitness ... : JacobianWitness C := sorry`.
  Why must-fix: load-bearing scaffold for the positive-genus arm of
  `nonempty_jacobianWitness`. Honest signature, but `:= sorry` body on
  a substantive existence claim. (Note: this declaration is *not*
  mentioned in the file-level status header — see Major below.)
- `AlgebraicJacobian/RigidityKbar.lean:75` —
  `theorem rigidity_over_kbar ... := sorry`.
  Why must-fix: keystone classical input (Mumford §4) blocking the
  genus-0 Albanese argument; `:= sorry` on a substantive claim.
  Already widely documented as a gated sorry. Listed here for inventory
  completeness; no severity-classification softening.

## Major

- `AlgebraicJacobian/Jacobian.lean:20–30` — file-level status header
  declares "TWO `sorry`-bodied declarations" and enumerates
  `genusZeroWitness` + `nonempty_jacobianWitness`. Actual content has
  two distinct sorry-bearers (`genusZeroWitness`, `positiveGenusWitness`)
  and `nonempty_jacobianWitness` is *not* a sorry-bearer post the
  iter-135 by-cases restructure. The header opening contradicts the
  later bullet list (L31–43) within the same docstring. The status block
  is stale on both count and identity.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:398–406` — section header
  `/-! ### Helpers / main lemma for piece (i.b)` describes "the helper
  sub-lemmas and main lemma" plural, but only one of the three named
  pieces remains in-file (Step 3 `…_restrict_along_identity_section`);
  the others were excised in iter-145.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:428–525` — multi-paragraph
  status banner describes "Status: Step 3 closed iter-136 ... Step 2
  PARTIAL iter-137 ... Compose main lemma body `sorry`" + the L465–525
  Route (b) skeleton sub-banner with "three concrete sub-goals
  (iter-139+ targets)". The Step 2 and Compose declarations no longer
  exist (iter-145 excise); the iter-145 EXCISE breadcrumb at L552–560
  documents the removal but the L428–525 narrative still actively
  describes the removed work in prose terms. Reader landing on L465
  before reading the L552 breadcrumb would expect the Route (b) skeleton
  to be present in the file. Stale; misleading.

## Minor

- `AlgebraicJacobian/Cotangent/GrpObj.lean:350` — `shearMulRight` and its
  two `_hom_fst`/`_hom_snd` simp companions are orphan helpers
  (post-iter-145 excise). Confirmed by grep: each name appears only in
  this file. Per directive: intentional, deferred for iter-146 cosmetic
  pass.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:424` —
  `schemeHomRingCompatibility` is orphan. Defined for the `φ' =
  ((adj).homEquiv _ _).symm f.c` shape consumed by
  `relativeDifferentialsPresheaf` and intended for the excised Step 2
  chain. Only consumer in the file was the now-removed Step 2 body.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:544` —
  `isIso_of_app_iso_module` is orphan. Designed as Route (b'2) helper
  for the excised Step 2 chain.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:579` —
  `relativeDifferentialsPresheaf_restrict_along_identity_section`
  (Piece (i.b) Step 3, closed iter-136 with no `sorry`) is now orphan:
  its only consumer was the excised `mulRight_globalises_cotangent`
  Compose main lemma.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:458` —
  `section_snd_eq_identity_struct` is private to the file and used only
  inside the now-orphan `…_restrict_along_identity_section`. Deeper
  orphan (no longer pulls weight even within the file).
- `AlgebraicJacobian/Cotangent/GrpObj.lean:297–327` — section header
  "Piece (i.b) — shear-iso globalisation of the cotangent" enumerates
  three structural pieces (`shearMulRight`,
  `…basechange_along_proj_two`, `…restrict_along_identity_section`).
  One of three is excised, one is closed-but-orphan, one is orphan; the
  prose at L297–327 describes a build chain that no longer exists in the
  file. Borderline stale; reader can recover from the L552 EXCISE
  breadcrumb but the section narrative is misaligned with current
  content.
- `AlgebraicJacobian/AbelJacobi.lean:51–90` — the three protected
  declarations all repeat a four-line `letI := (jacobianWitness C).{grpObj,
  proper, smooth, geomIrred}` preamble. Could be a single `variable`
  block sharing the four `letI`s; cosmetic.
- `AlgebraicJacobian/Cohomology/SheafCompose.lean:6` — `import Mathlib`
  (not used elsewhere in the project; every other Cohomology file
  imports specific Mathlib submodules). Cosmetic.
- `AlgebraicJacobian/Genus.lean:6` — `import Mathlib` (wide import for
  a 45-line file).

## Excuse-comments (always called out separately)

Listed verbatim with file:line. Per the auditor's stance these document
the project lying to itself; for ChartAlgebra.lean the directive
explicitly authorises the pattern as iter-145 scaffolding, but the
audit is descriptor-bound to flag them.

- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:49` — `"TODO iter-146:
  real signature; placeholder is `: True`."` (attached to
  `algebra_isPushout_of_affine_product`). Severity: must-fix.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:58` — `"TODO iter-146:
  real signature; placeholder is `: True`."` (attached to
  `df_zero_factors_through_constant_on_chart`). Severity: must-fix.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:68` — `"TODO iter-146:
  real signature; placeholder is `: True`."` (attached to
  `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`). Severity:
  must-fix.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:76` — `"TODO iter-146:
  real signature; placeholder is `: True`."` (attached to
  `constants_integral_over_base_field`). Severity: must-fix.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:88` — `"TODO iter-146:
  real signature; placeholder is `: True`."` (attached to
  `ext_of_diff_zero`). Severity: must-fix.
- `AlgebraicJacobian/Jacobian.lean:193` —
  `genusZeroWitness ... := sorry` carries the iter-127-scaffold
  docstring "**Status**: iter-127 scaffold — body is `sorry`. The body
  closure is iter-138+ work, after pieces (i)+(ii)+(iii) of the shared
  cotangent-vanishing pile land." Severity: must-fix.
- `AlgebraicJacobian/Jacobian.lean:219` —
  `positiveGenusWitness ... := sorry` carries the iter-134-scaffold
  docstring "**Status**: iter-134 scaffold — body is `sorry`. The body
  closure is M3 work, currently OFF-CRITICAL-PATH..." Severity:
  must-fix.
- `AlgebraicJacobian/RigidityKbar.lean:75` — `rigidity_over_kbar ... :=
  sorry` carries the iter-126-scaffold docstring "**Status**: iter-126
  scaffold — body is a single `sorry`." Severity: must-fix.

## Severity summary

- **must-fix-this-iter**: 8 — five `: True := sorry` placeholders in
  `Cotangent/ChartAlgebra.lean` (per the auditor's literal rule set),
  two scaffold `JacobianWitness`-sorries in `Jacobian.lean`
  (`genusZeroWitness`, `positiveGenusWitness`), and one keystone-sorry
  in `RigidityKbar.lean` (`rigidity_over_kbar`). The plan-agent and
  user retain the authority to keep them gated per the project's
  multi-iteration strategy; the audit's role is to keep the alarm
  audible.
- **major**: 3 — (1) `Jacobian.lean` file-level status header
  understates the sorry inventory; (2)/(3) `Cotangent/GrpObj.lean`
  L398-406 and L428-525 section narratives describe excised
  declarations.
- **minor**: 8 — six orphan-helper / orphan-section observations in
  `Cotangent/GrpObj.lean` (per directive: known and intentional, no
  evidence of pollution; flagged for completeness), one repeating
  letI preamble in `AbelJacobi.lean`, two wide `import Mathlib` lines
  in small files.
- **excuse-comments**: 8 (also counted under must-fix-this-iter above).

Overall verdict: the project is in honest mid-build shape with one
small but real region of audit-relevance — the five `: True := sorry`
placeholders in `Cotangent/ChartAlgebra.lean` and the stale
`Jacobian.lean` / `Cotangent/GrpObj.lean` section narratives that
describe excised iter-145 work; the load-bearing cohomology +
differentials + abel-jacobi infrastructure is closed honestly.
