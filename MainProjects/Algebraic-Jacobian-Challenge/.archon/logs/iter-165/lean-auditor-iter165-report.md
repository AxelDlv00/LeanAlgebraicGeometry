# Lean Audit Report

## Slug
iter165

## Iteration
165

## Scope
- files audited: 16
- files skipped (per directive): 0

Files (project tree, excluding `.archon/`, `.lake/`, `blueprint/` artifacts):
- `AlgebraicJacobian.lean`
- `AlgebraicJacobian/AbelJacobi.lean`
- `AlgebraicJacobian/AbelianVarietyRigidity.lean`
- `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean`
- `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean`
- `AlgebraicJacobian/Cohomology/SheafCompose.lean`
- `AlgebraicJacobian/Cohomology/StructureSheafAb.lean`
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
- `AlgebraicJacobian/Cotangent/GrpObj.lean`
- `AlgebraicJacobian/Differentials.lean`
- `AlgebraicJacobian/Genus.lean`
- `AlgebraicJacobian/Genus0BaseObjects.lean` *(iter-165 primary focus — NEW)*
- `AlgebraicJacobian/Jacobian.lean`
- `AlgebraicJacobian/Rigidity.lean`
- `AlgebraicJacobian/RigidityKbar.lean`

Build status (verified via `lean_diagnostic_messages`): all 16 files compile
error-free. The 9 declared `sorry`s in `Genus0BaseObjects.lean` exactly match
the directive's plan-allowed scaffold list (L175, L182, L199, L204, L209,
L264, L329, L366, L381). Carry-over `sorry`s elsewhere unchanged:
- `AbelianVarietyRigidity.lean:936, 960, 989` (scaffolds)
- `Jacobian.lean:265, 303`
- `RigidityKbar.lean:88`

Axiom-hygiene spot-checks (via `lean_verify`) of the new file:
- `projectiveLineBar_isProper` — AXIOM-CLEAN (kernel only).
- `projectiveLineBarGrading_gradedRing` — AXIOM-CLEAN.
- `ga_isAffineHom`, `ga_isReduced`, `ga_locallyOfFinitePresentation` —
  AXIOM-CLEAN.
- `gm_isAffine`, `gm_isReduced`, `gm_locallyOfFinitePresentation` —
  AXIOM-CLEAN.
- `ga_smooth`, `gm_smooth` — carry `sorryAx` (expected: consume the
  plan-allowed `ga_grpObj` / `gm_grpObj` scaffold sorries).
- `Gm.onePt` — carries `sorryAx` (expected: `η[Gm kbar]` depends on
  `gm_grpObj`).

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 15-line import aggregator; this iter added the
    `import AlgebraicJacobian.Genus0BaseObjects` line.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Unchanged from iter-164 baseline. Three short delegators projecting
    through `(jacobianWitness C).isAlbaneseFor P`. Header status block matches
    the code.

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: 1 minor (carry-over from iter-164)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 minor (carry-over from iter-164: dead instance
  hypotheses)
- **excuse-comments**: none
- **notes**:
  - File unchanged this iter. Iter-164 findings persist:
    - L462–463 forward-looking comment about JacobsonSpace assembly being
      "left for the prover phase" while the assembly is *already* discharged
      in the immediately-following block. Carry-over.
    - L886 `[Smooth A.hom]` + `[GeometricallyIrreducible A.hom]` on the SOURCE
      A-side of `av_regularMap_isHom_of_zero` are not consumed by the body.
      Pre-existing dead-weight. Carry-over.
  - The three named scaffold sorries (`morphism_P1_to_grpScheme_const` L936,
    `genusZero_curve_iso_P1` L960, `rigidity_genus0_curve_to_grpScheme` L989)
    are untouched and remain explicit scaffolds with status lines.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Unchanged from iter-164 baseline. MV LES core + Mathlib gap-fill;
    no live `sorry`, build clean.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Unchanged. 2-affine cover MV + cover-totality bridges + acyclic-cover
    infrastructure; clean.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Unchanged. Single 8-line instance via `Limits.comp_preservesLimits`.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Unchanged. Three closed declarations.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Unchanged. 877-line file; no live `sorry` / `axiom`.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: 1 major (carry-over from iter-164)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File unchanged this iter. Iter-164 finding persists:
    - L36–79 header still frames the file as the "iter-144 chart-algebra
      pivot route for piece (ii) of the M2.body-pile ... committed";
      per memory and AVR header, that differential / chart-algebra route is
      now the off-path fallback (Route C committed iter-163). Each declaration
      itself is axiom-clean; only the route framing is stale.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 2 major (carry-over from iter-164)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File unchanged this iter. Iter-164 findings persist:
    - L297–327 section header "Piece (i.b) — shear-iso globalisation of the
      cotangent" announces the closure target `mulRight_globalises_cotangent`
      and a 3-step plan whose Step-2 helpers and main lemma were EXCISED
      iter-145. Reads as a live plan against deleted code.
    - L428–525 "Helper sub-lemmas and main lemma of piece (i.b)" + the
      "Piece (i.b) Step 2: base-change-along-`pr_2` iso (iter-138 PARTIAL
      skeleton)" docstring with "Three remaining concrete sub-goals (iter-139+
      targets)" both narrate work on `basechange_along_proj_two_inv*` and
      `mulRight_globalises_cotangent` excised iter-145.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Unchanged. 144 lines; clean.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Unchanged. Single noncomputable definition; clean.

### AlgebraicJacobian/Genus0BaseObjects.lean *(iter-165 primary focus, NEW)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none (1 minor stylistic note below)
- **excuse-comments**: 1 minor (borderline — "PARTIAL placeholder" framing,
  see below)
- **notes**:
  - **9 scaffold sorries — plan-allowed, NOT findings.** L175
    (`projectiveLineBar_geomIrred`), L182 (`projectiveLineBar_smoothOfRelDim`),
    L199/204/209 (`ProjectiveLineBar.{zeroPt,onePt,inftyPt}`),
    L264 (`ga_grpObj`), L329 (`gm_grpObj`), L366 (`gmScalingP1`),
    L381 (`gmScalingP1_collapse_at_zero`). All are top-level named
    declarations as the directive prescribes; each carries an explicit
    docstring naming the deferred sub-build and the closing iter. No buried
    `letI`/`have :=` sorries inside otherwise-closed proofs.
  - **`projectiveLineBar_isProper` (L127–170) — AUDITED, sound.** Axiom-clean
    (`lean_verify` confirms: `propext`, `Classical.choice`, `Quot.sound` only —
    no `sorryAx`). The proof:
    * `change` (L130–132) rewrites the goal to expose
      `Proj.toSpecZero ≫ Spec.map …` (defeq via `Scheme.asOver = Over.mk` and
      the explicit `hom` field of `projectiveLineBarScheme_canOver` at
      L100–103). Routine.
    * `haveI : IsScalarTower kbar ↥(𝒜 0) (MvPolynomial _ kbar)` (L134) is
      built via `IsScalarTower.of_algebraMap_eq fun _ => rfl` — honest
      defeq check, no hidden content.
    * `haveI : Algebra.FiniteType ↥(𝒜 0) (MvPolynomial _ kbar)` (L139) is
      derived from `Algebra.FiniteType.of_restrictScalars_finiteType` over
      `kbar` — relies on the auto-inferred ambient
      `Algebra.FiniteType kbar (MvPolynomial _ kbar)` (Mathlib instance,
      sound).
    * `hbij` (L149–163) gives bijectivity of `algebraMap kbar ↥(𝒜 0)`:
      injectivity via `MvPolynomial.C_injective` + `congrArg Subtype.val`;
      surjectivity via `MvPolynomial.homogeneousComponent_of_mem` +
      `homogeneousComponent_zero`. Both legs are explicit, no `sorry` shadows.
    * `haveI : IsIso (Spec.map …)` (L166) closes via `isIso_SpecMap_iff`
      applied to `hbij`. Routine.
    * Final `infer_instance` (L170) resolves
      `IsProper (Proj.toSpecZero ≫ Spec.map …)` via Mathlib's
      `Proj.instIsProperToSpecZero…` (consuming the iter-built
      `Algebra.FiniteType ↥(𝒜 0) (MvPolynomial …)`) composed with the
      `IsIso` of `Spec.map …` — both in scope as `haveI`. The
      composition-with-iso instance is provided by Mathlib's
      `IsProper`-respects-composition / `IsIso.comp_isProper`-style
      typeclass resolution. The chain is honest.
  - **`ga_smooth` / `gm_smooth` chains (L269–272, L333–336) — AUDITED, sound
    modulo upstream sorries.** Both bodies are
    `have : GrpObj (Over.mk _.hom) := <_grpObj kbar>;
     smooth_of_grpObj_of_isAlgClosed _.hom`.
    `Ga kbar` is `abbrev`-defeq to `Over.mk (Ga kbar).hom` (via
    `Scheme.asOver = Over.mk (X ↘ S)` and `(Over.mk _).hom` projection), so
    the `have :` coercion is type-correct without laundering. `lean_verify`
    confirms `sorryAx` is propagated honestly (not laundered). The chains
    are logically valid modulo the `_grpObj` scaffold sorries.
  - **Other non-sorry instances (`ga_isAffineHom`,
    `ga_locallyOfFinitePresentation`, `ga_isReduced`, `gm_isAffine`,
    `gm_isReduced`, `gm_locallyOfFinitePresentation`, the OverClass instances,
    `projectiveLineBarGrading_gradedRing`)** — all axiom-clean per
    `lean_verify` or routine `inferInstanceAs` bridges; reviewed and
    consistent with their docstrings.
  - **L261 borderline language**: the docstring on `ga_grpObj` (L253–263)
    reads "**PARTIAL placeholder**: the type signature is correct and the
    projects' downstream consumer (`hom_additive_decomp_of_rigidity` with
    `W = Gm`, NOT `W = Ga` — `Ga` is on the demoted route only) does not
    exercise this." The word "placeholder" combined with "does not exercise
    this" is *technically* the kind of excuse-language the audit rules flag,
    but here it is documenting (a) that this is a scheduled scaffold and
    (b) that the off-path `Ga` `GrpObj` is not load-bearing for the live
    closure. Logged as minor (borderline) per the directive's plan-allowance,
    not promoted to major / must-fix. Recommend the prover phase reword
    "PARTIAL placeholder ... does not exercise this" to "scaffold body for
    iter-166; off-path for the genus-0 closure (rigidity consumer uses
    `Gm`, not `Ga`)" to avoid the excuse-comment pattern.
  - **No protected-signature edits, no new axioms, no `:= True`, no
    `:= rfl` on substantive claims, no `:= Classical.choice _` shortcuts.**
  - **Encoding choices.** The `Ga` underlying scheme is
    `AffineSpace.{0, u} (Fin 1) (Spec (.of kbar))` (matches the directive
    description). `Gm` is `Spec (Localization.Away (X : MvPolynomial Unit
    kbar))` (the affine encoding, NOT the basic-open route — per the
    iter-164 mathlib-analogist D2.b verdict). Both encodings are documented
    in the file header L36–46.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: 1 major + 1 minor (carry-over from iter-164)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File unchanged this iter. Iter-164 findings persist:
    - L237–263 (inside `genusZeroWitness.key`'s `sorry`) — the 3-gate
      analysis ("IMPORT CYCLE / CHAR-`p` GAP / BASE-CHANGE FUNCTOR") is
      partially superseded. Gate (1) is resolved (the new
      `AbelianVarietyRigidity.lean` sits upstream of `Jacobian.lean`);
      Gate (2) is resolved (Route C / Milne §I.3 is char-general per the
      AVR header). The remaining true blocker is that
      `rigidity_genus0_curve_to_grpScheme` is itself an unproved scaffold.
      `sorry` body retention is correct; only the narrative is stale.
    - L29 references `rigidity_over_kbar` (M2.a) as "the substantive
      mathematical content"; the substantive content has migrated to
      `rigidity_genus0_curve_to_grpScheme` in
      `AbelianVarietyRigidity.lean`. Minor.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Unchanged. 123-line scheme-level rigidity packaging; clean. Hypothesis
    history at L43–78 documents real decisions (iter-003 + iter-125).

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: 1 major (carry-over from iter-164)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File unchanged this iter. Iter-164 finding persists:
    - L20–29, L70–74 status block still describes `rigidity_over_kbar` as
      "the keystone classical input for the M2.a sub-step ... gated on the
      shared cotangent-vanishing Mathlib pile (iter-129+)"; per memory + AVR
      header L17–19 this declaration is the fallback route (a) artifact
      superseded by the upstream char-free `rigidity_genus0_curve_to_grpScheme`.
      The signature itself (`[CharZero kbar]` retained) is correct for an
      artifact of the abandoned char-zero differential route.

## Must-fix-this-iter

None. Per directive, the 9 named scaffold `sorry`s in `Genus0BaseObjects.lean`
are plan-allowed and not findings. The non-sorry proofs that did land
(`projectiveLineBar_isProper`, the 5 affine-side hom-property instances, the
two OverClass instances) are sound: axiom-hygiene checks pass, no laundering,
no `:= True` / `:= rfl`-on-substantive-claims. The `ga_smooth` / `gm_smooth`
chains are logically correct modulo the (plan-allowed) `ga_grpObj` /
`gm_grpObj` sorries — `sorryAx` propagates honestly.

## Major

All 5 are unchanged carry-overs from iter-164. The files were not edited this
iter; flagging as carry-over not new.

- `AlgebraicJacobian/Cotangent/GrpObj.lean:297–327` — section header
  "Piece (i.b) — shear-iso globalisation of the cotangent" announces the
  closure target `mulRight_globalises_cotangent` and a 3-step plan whose
  Step-2 helpers and main lemma were excised iter-145. Reads as a live plan
  against deleted code.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:428–525` — "Helper sub-lemmas and
  main lemma of piece (i.b)" + "Piece (i.b) Step 2: base-change-along-`pr_2`
  iso (iter-138 PARTIAL skeleton)" describe `basechange_along_proj_two_inv*`,
  `relativeDifferentialsPresheaf_basechange_along_proj_two`, and
  `mulRight_globalises_cotangent` as live `sorry` work; all four were
  excised iter-145.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:36–79` — header frames the
  file as the "iter-144 chart-algebra pivot route for piece (ii) of the
  M2.body-pile", i.e. as the live committed route; per memory this
  differential / chart route is the off-path fallback (Route C committed
  iter-163). Each declaration itself is axiom-clean; only the route framing
  is stale.
- `AlgebraicJacobian/RigidityKbar.lean:20–29, 70–74` — status block still
  presents `rigidity_over_kbar` as "the keystone classical input for M2.a"
  with closure "gated on the shared cotangent-vanishing Mathlib pile";
  per memory + AVR header L17–19 it is now the fallback route (a) artifact
  superseded by upstream `rigidity_genus0_curve_to_grpScheme`.
- `AlgebraicJacobian/Jacobian.lean:237–263` — the 3-gate "IMPORT CYCLE /
  CHAR-`p` GAP / BASE-CHANGE" analysis inside `genusZeroWitness.key`'s
  `sorry` is partially superseded. Gates (1) and (2) have been resolved by
  the iter-156+ creation of `AbelianVarietyRigidity.lean` (upstream of
  `Jacobian.lean`, char-general). The remaining true blocker is "the
  consumed `rigidity_genus0_curve_to_grpScheme` is itself an unproved
  scaffold". `sorry` body retention is correct; only the narrative needs
  updating.

## Minor

All 3 are unchanged carry-overs from iter-164 plus 1 new note on the new
file.

- `AlgebraicJacobian/AbelianVarietyRigidity.lean:462–463` — the comment
  "This `sorry` is therefore the assembly of those three Mathlib facts, left
  for the prover phase — it is no longer an as-typed-unprovability" is one
  revision behind: the assembly is *already* discharged in the
  `haveI : JacobsonSpace` block at L464–470. Carry-over from iter-164.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:886` — `[Smooth A.hom]` and
  `[GeometricallyIrreducible A.hom]` on the SOURCE A-side of
  `av_regularMap_isHom_of_zero` are not consumed by the body (only the
  product-side `(A ⊗ A)` instances and the target-side `[GrpObj B]
  [IsProper B.hom]` are consumed). Pre-existing dead-weight surfaced by
  iter-164's audit; not introduced this iter. Carry-over.
- `AlgebraicJacobian/Jacobian.lean:29` — references `rigidity_over_kbar`
  (M2.a) as "the substantive mathematical content"; the substantive
  content has migrated to `rigidity_genus0_curve_to_grpScheme` in
  `AbelianVarietyRigidity.lean`. Carry-over from iter-164.
- `AlgebraicJacobian/Genus0BaseObjects.lean:253–263` — *new this iter.*
  The `ga_grpObj` docstring uses "**PARTIAL placeholder**: ... does not
  exercise this". The "placeholder" / "does not exercise this" language is
  borderline excuse-comment territory under the strict audit rules, but in
  context describes a plan-allowed scaffold whose body the live closure
  path doesn't traverse (Route C uses `Gm`, not `Ga`). Recommend rewording
  to "scaffold body for iter-166; off-path for the genus-0 closure"
  to avoid the excuse-comment pattern.

## Excuse-comments (always called out separately)

None promoted to critical. One borderline case noted under Minor:

- `AlgebraicJacobian/Genus0BaseObjects.lean:253–263` (docstring on
  `ga_grpObj`): "**PARTIAL placeholder**: the type signature is correct and
  the projects' downstream consumer ... does not exercise this." This *is*
  the "placeholder" word pattern the audit rules flag, but the attached
  declaration is a plan-allowed scaffold (per directive) and the docstring
  also documents why it is off-path (the live consumer is `Gm`, not `Ga`).
  Severity: minor (borderline). Recommend rewording, but not blocking.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 5 (all carry-overs from iter-164 — files unchanged this iter)
- **minor**: 4 (3 carry-overs + 1 new borderline excuse-language note on
  `ga_grpObj` docstring)
- **excuse-comments**: 1 borderline, demoted to minor

Overall verdict: the new `Genus0BaseObjects.lean` is structurally sound — the
9 scaffold `sorry`s are top-level / plan-allowed as the directive specifies,
the delivered `projectiveLineBar_isProper` proof is axiom-clean and honest
(no laundering, no buried sorries, the `change`-to-`Proj.toSpecZero ≫
Spec.map` chain holds by defeq, the bijectivity-of-algebra-map computation
is explicit and correct), and the `ga_smooth` / `gm_smooth` chains propagate
`sorryAx` honestly from their upstream `_grpObj` scaffolds without laundering.
The iter-164 stale-narrative carry-overs (5 major across `Cotangent/`,
`Jacobian.lean`, and `RigidityKbar.lean`) persist unchanged this iter — none
of those files were edited — and remain candidates for a narrative-refresh
sweep separate from the iter-166 prover lane.
