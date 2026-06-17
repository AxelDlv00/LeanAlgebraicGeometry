# Lean Audit Report

## Slug

review135

## Iteration

135

## Scope

- files audited: 13
- files skipped (per directive): 0

Audited every `.lean` file under `AlgebraicJacobian/` plus the top-level
aggregator `AlgebraicJacobian.lean`. No `.lake/packages/**` files were
read.

## Per-file checklist

### `AlgebraicJacobian.lean`
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 13-line aggregator; imports the 12 project modules in
  dependency-respecting order. Clean.

### `AlgebraicJacobian/Genus.lean`
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `genus` is a closed one-liner; protected signature.
  `noncomputable` and `import Mathlib` are both intentional (iter-011
  authorisation note in docstring). Clean.

### `AlgebraicJacobian/AbelJacobi.lean`
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: All three protected declarations (`ofCurve`, `comp_ofCurve`,
  `exists_unique_ofCurve_comp`) are honest projections of the witness's
  `isAlbaneseFor P` field, body-closed. The `letI := …` chains threading
  the four typeclass fields are mechanically required by the witness's
  use of `@IsAlbanese k _ C P J grpObj proper smooth geomIrred` rather
  than ambient instance resolution; not a smell.

### `AlgebraicJacobian/Rigidity.lean`
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `Scheme.Over.ext_of_eqOnOpen` is honestly closed via
  `ext_of_isDominant_of_isSeparated'`. The hypothesis-history block
  (lines 43–79) documents one earlier wrong attempt and its mathematical
  failure mode — this is intentional design documentation, not a stale
  comment about live code.

### `AlgebraicJacobian/RigidityKbar.lean`
- **outdated comments**: none
- **suspect definitions**: 1 flagged
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L87 `rigidity_over_kbar := sorry` — load-bearing M2.a claim
    (genus-0 Albanese-witness keystone); body is a single `sorry`.
    Status block (L20–30) documents this as iter-126 scaffold gated on
    the shared cotangent-vanishing pile (iter-129+). Listed under
    must-fix below per the strict-severity rule, with the documented
    scaffold context preserved.

### `AlgebraicJacobian/Differentials.lean`
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Five declarations, all closed:
  `relativeDifferentialsPresheaf`, `relativeDifferentialsPresheaf_obj_kaehler`,
  `kaehler_localization_subsingleton`, `kaehler_quotient_localization_iso`,
  `smooth_locally_free_omega`. The chapter docstring explicitly notes
  the converse-direction of the Jacobian criterion is mathematically
  false without H₁-cotangent vanishing — honest disclosure, not a smell.

### `AlgebraicJacobian/Jacobian.lean`
- **outdated comments**: none
- **suspect definitions**: 2 flagged
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L197 `genusZeroWitness := sorry` — load-bearing data def
    (`JacobianWitness C` for `genus C = 0`). Docstring (L176–192)
    documents iter-127 scaffold, closure iter-138+, and the iter-135
    role as the genus-0 arm of `nonempty_jacobianWitness`. Listed under
    must-fix below.
  - L223 `positiveGenusWitness := sorry` — load-bearing data def
    (`JacobianWitness C` for `0 < genus C`). Docstring (L199–218)
    documents iter-134 scaffold, M3 off-critical-path, and the iter-135
    role as the positive-genus arm. Listed under must-fix below.
  - L249–254 `nonempty_jacobianWitness` — iter-135 refactor: body is a
    `by_cases h : genus C = 0` decomposition delegating to the two
    witnesses. The decomposition is mathematically transparent
    (`Nat.pos_of_ne_zero h` discharges `0 < genus C` from `h : ¬ … = 0`),
    no inline `sorry` here. The total sorry count under this declaration
    is unchanged: one inline sorry was replaced by delegation to two
    pre-existing sorry-bodied scaffolds. Architectural improvement, but
    does NOT close any new mathematical content.
  - L46–52 "Forbidden shortcut" block in the file header is design
    documentation explaining why `Jacobian C := 𝟙_ _` is rejected — not
    an excuse-comment about live code.

### `AlgebraicJacobian/Cotangent/GrpObj.lean`
- **outdated comments**: 4 flagged (per-directive minor cleanup, do not
  re-classify)
- **suspect definitions**: 3 flagged
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L476 `relativeDifferentialsPresheaf_basechange_along_proj_two
    := sorry` — load-bearing data def producing the
    `Ω_{(G ⊗ G)/G} ≅ pr_2^* Ω_{G/k}` sheaf-level iso (piece (i.b)
    Step 2). Iter-135 honest scaffold per docstring (L462–467); closure
    target chains `KaehlerDifferential.tensorKaehlerEquiv` with
    `PresheafOfModules.pullback` (~150–300 LOC). Listed under must-fix.
  - L512 `relativeDifferentialsPresheaf_restrict_along_identity_section
    := sorry` — load-bearing data def (piece (i.b) Step 3). Iter-135
    honest scaffold per docstring (L493–495); closure target is
    `PresheafOfModules.pullbackComp + pullbackId` on
    `pr_2 ∘ s = η_G ∘ π_G` (~30–80 LOC). Listed under must-fix.
  - L571 `mulRight_globalises_cotangent := sorry` — load-bearing data
    def (piece (i.b) main lemma). Iter-135 honest scaffold per
    docstring (L557–559); composes Steps 2+3 (the two `def`s above).
    Listed under must-fix.
  - **Honest-scaffold note on the iter-135 refactor.** These three were
    previously typed `Nonempty (X ≅ X) := ⟨Iso.refl _⟩` — a structurally
    wrong shape (LHS and RHS are not definitionally equal as sheaves of
    modules) hidden under a trivial reflexivity witness. The iter-135
    refactor swapped them to `noncomputable def : <LHS> ≅ <real-RHS> :=
    sorry`, exposing the load-bearing iso target and removing the
    type-level lie. This is a clear honesty improvement; the residual
    `sorry`s are flagged below for completeness, not to disparage the
    refactor.
  - Docstring "line N below" references at L106, 146, 155, 159 inside
    the `cotangentSpaceAtIdentity` docstring — per directive these are
    documentation-rot and classified as **minor**, not must-fix.
  - The three docstring occurrences of the word "opaque" (L50, 53, 204)
    are source-text matches inside narrative docstrings discussing the
    iter-131 body refactor, NOT actual `opaque` declarations.
    Skipped per directive.
  - `shearMulRight` (L349) and its two `_hom_*` companions (L386, 391)
    are honestly closed. The `@[simps]` plus the explicit `lift_lift_assoc`
    rewrite chain are conventional CartesianMonoidalCategory shear-iso
    plumbing.
  - `schemeHomRingCompatibility` (L423) and `cotangentSpaceAtIdentity`
    + its two companions (L161, 210, 256) are all body-closed; the
    `Classical.choose`-chain `let`-binding pattern is documented in the
    cotangentSpaceAtIdentity docstring as the iter-131 design.

### `AlgebraicJacobian/Cohomology/SheafCompose.lean`
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: One instance, honestly closed; iter-003 closure as noted.

### `AlgebraicJacobian/Cohomology/StructureSheafAb.lean`
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Two `inferInstance`-or-`HasExt.standard` instances and one
  `toAbSheaf` `noncomputable def`, all closed.

### `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 minor noted
- **excuse-comments**: none
- **notes**: Long file (~877 lines) covering iter-005 through iter-053
  scaffolding for `ModuleCat k`-valued sheaf cohomology of the structure
  sheaf, all closed. Five `CategoryTheory`-namespaced Mathlib gap-fills
  (`Functor.const_additive/linear`, `Adjunction.left/right_adjoint_linear`,
  `Adjunction.homLinearEquiv`) are flagged in their docstrings as
  Mathlib gap-fills — legitimate downstream consumption pattern.
  - The `_curve` specialisation pattern at iter-039, iter-043, iter-048,
    iter-049, iter-050, iter-051, iter-052 (dot-notation wrappers
    parameterising `F := Scheme.toModuleKSheaf C`) is verbose but
    documented as intentional design. Not a smell, but a possible
    refactor target if the file ever needs to shrink — flagged as
    **minor**, not blocking.
  - Classes `IsAffineHModuleVanishing`, `IsHModuleHomFinite`,
    `IsCechAcyclicCover`, `HasCechToHModuleIso`,
    `HasAffineCechAcyclicCover` are all `Prop`-valued carrier classes
    with clearly named single fields; each comes with an explicit
    producer (or a flagged-as-pending iter-054+ producer) and explicit
    consumers. Standard carrier-class design.
  - `instIsHModuleHomFinite_toModuleKSheaf` (L708) is a non-trivial
    producer instance; body chains iter-044/045/046 inputs honestly.

### `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean`
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 628 lines, all closed. The iter-034 Mathlib gap-fill
  `Abelian.Ext.chgUnivLinearEquiv` and the iter-016 → iter-026 MV-LES
  cohort are correctly mirrored from Mathlib. The
  `set_option backward.isDefEq.respectTransparency false in` annotations
  at L354, 523, 539, 565 are not anti-patterns — they are required when
  typeclass search hits structure-literal projection through
  `HModule'_shortComplex.f`-form goals (per docstring at L353).

### `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean`
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 minor noted
- **excuse-comments**: none
- **notes**: 711 lines, all closed. Implements the 2-affine cover MV
  specialisation (`AffineCoverMVSquare`) and the universe-bridge chain
  (iter-031 → iter-049) carrying `HModule' k F n X₄` to
  `HModule k F n` via `Preorder.isTerminalTop` on `⊤`.
  - The `_curve` specialisation pattern continues from
    `StructureSheafModuleK.lean` (iter-029/030/035/036/037/049/050/051/052
    each ship two wrappers, abstract + `_curve`). As above: verbose but
    intentional. Flagged as **minor**.
  - `HasAffineCechAcyclicCover` (L675) is an existence-bundled `Prop`
    carrier and the producer instance
    `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` (L699)
    chains through it honestly to fire `IsAffineHModuleVanishing`. The
    upstream substantive content (closing
    `HasAffineCechAcyclicCover (toModuleKSheaf C)` for a curve via Koszul
    + Čech-derived comparison) is the queued iter-054+ work — flagged
    in-line in the docstring, not via a `sorry`.

## Must-fix-this-iter

The directive specifies that "**Suspect bodies on substantive claims**:
`:= sorry` on a load-bearing claim" lands here automatically. All six
load-bearing `:= sorry` bodies are listed below. Each one is a
docstring-documented architectural scaffold with a named closure target
and an iter-aligned closure plan; this is plan-agent context, not an
auditor's licence to under-classify.

- `AlgebraicJacobian/RigidityKbar.lean:87` —
  `rigidity_over_kbar := sorry`. Why must-fix: load-bearing theorem (M2.a
  keystone for the genus-0 Albanese-witness chain). Documented scaffold
  per docstring L20–30; closure gated on the shared cotangent-vanishing
  Mathlib pile (iter-129+).
- `AlgebraicJacobian/Jacobian.lean:197` —
  `genusZeroWitness := sorry`. Why must-fix: load-bearing data
  definition (`JacobianWitness C` for `genus C = 0`); consumed by
  `nonempty_jacobianWitness` iter-135 body restructure. Documented
  scaffold per docstring L176–192; closure iter-138+ after pieces
  (i)+(ii)+(iii) of the cotangent-vanishing pile land.
- `AlgebraicJacobian/Jacobian.lean:223` —
  `positiveGenusWitness := sorry`. Why must-fix: load-bearing data
  definition (`JacobianWitness C` for `0 < genus C`); positive-genus arm
  of `nonempty_jacobianWitness`. Documented scaffold per docstring
  L199–218; closure is M3 work, off-critical-path
  (user-escalation-pending per `analogies/m3-route-audit.md`).
- `AlgebraicJacobian/Cotangent/GrpObj.lean:476` —
  `relativeDifferentialsPresheaf_basechange_along_proj_two := sorry`.
  Why must-fix: load-bearing data definition producing the sheaf-level
  base-change iso `Ω_{(G ⊗ G)/G} ≅ pr_2^* Ω_{G/k}` (piece (i.b)
  Step 2). Iter-135 honest scaffold per docstring L462–467; closure
  ~150–300 LOC chaining `KaehlerDifferential.tensorKaehlerEquiv` with
  `PresheafOfModules.pullback`.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:512` —
  `relativeDifferentialsPresheaf_restrict_along_identity_section := sorry`.
  Why must-fix: load-bearing data definition (piece (i.b) Step 3).
  Iter-135 honest scaffold per docstring L493–495; closure ~30–80 LOC
  via `PresheafOfModules.pullbackComp + pullbackId` on
  `pr_2 ∘ s = η_G ∘ π_G`.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:571` —
  `mulRight_globalises_cotangent := sorry`. Why must-fix: load-bearing
  data definition (piece (i.b) main lemma). Iter-135 honest scaffold
  per docstring L557–559; composes the two scaffolds above plus the
  closed `shearMulRight` Step 1.

**Auditor note on the iter-135 refactor (no separate finding).** The
three `Cotangent/GrpObj.lean` sorries above are *not* a regression —
they replace prior `Nonempty (X ≅ X) := ⟨Iso.refl _⟩` stubs whose
type-level shape was a structural lie (LHS and RHS are not
definitionally equal sheaves of modules). The iter-135 refactor swapped
the trivial-reflexivity shape for an honest sheaf-level iso target with
a `sorry` body. This is the correct direction: the new declarations
expose what must be proved, instead of hiding behind a typecheck-only
witness. The plan agent should treat these as load-bearing scaffolds
inherited from the prior iter, not as new technical debt introduced
this iter.

## Major

(none)

## Minor

- `AlgebraicJacobian/Cotangent/GrpObj.lean:106,146,155,159` — "(at line
  244 below)" / "(line 244 below)" / "(line 198 below)" / "(line 244
  below)" inside the `cotangentSpaceAtIdentity` docstring. The iter-135
  file-header docstring was de-pinned per directive, but these in-body
  docstring references to absolute line numbers remain. They will rot
  on the next non-trivial edit to this file (any insertion above one of
  the cited lines shifts the actual location). Per directive: minor
  cleanup, not must-fix. A one-shot pass could replace the absolute
  refs with relative phrasing ("the rank lemma below" / "the structural
  acceptance lemma below").
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` — entire
  file is ~877 lines and the iter-039+ `_curve` dot-notation wrapper
  pattern (iter-039/043/048/049/050/051/052 each ship an abstract +
  `_curve` form) is dense. Functionally correct but a candidate for a
  later refactor pass if the file becomes a navigation burden. Not
  blocking.
- `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean` — same dot-
  notation wrapper-doubling pattern (iter-029/030/035/036/037/049/050/
  051/052 ship two forms each). Same minor classification.

## Excuse-comments (always called out separately)

None found. The audit specifically searched for the directive's listed
patterns (`-- TODO replace`, `-- placeholder`, `-- temporary`,
`-- wrong but works`, `-- will fix later`) and several variants
(`-- FIXME`, `-- hack`, `-- HACK`, `-- XXX`, `-- kludge`,
`-- stand-in`) — no matches in any project `.lean` file. The
multi-paragraph docstrings on the six `:= sorry`-bodied declarations
*document scaffold status with closure plans*, which is the correct
discipline opposite of excuse-comments.

## Severity summary

- **must-fix-this-iter**: 6 — all six are load-bearing `:= sorry`
  bodies; each one is documented as a scaffold with a planned closure
  iter and a named Mathlib closure-chain target. Three are iter-135
  honest-scaffold improvements (replacing prior trivially-typed
  Nonempty(X ≅ X) := ⟨Iso.refl _⟩ stubs); three are pre-iter-135
  inheritances (iter-126 / iter-127 / iter-134).
- **major**: 0
- **minor**: 3 — documentation-rot (line-N references in one docstring)
  and verbose `_curve` wrapper-doubling pattern across two cohomology
  files.
- **excuse-comments**: 0.

Overall verdict: the project's `.lean` source is internally consistent
and the iter-135 refactor is a legitimate honesty improvement (3 typed
lies replaced by 3 honest scaffolds, 1 inline `sorry` decomposed into
2 delegations); the 6 outstanding load-bearing `:= sorry` bodies are
the project's known mathematical-content scaffolds, all openly
documented with iter-aligned closure plans rather than hidden behind
excuse-comments.
