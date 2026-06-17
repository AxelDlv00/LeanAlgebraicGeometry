# Lean Audit Report

## Slug
iter159

## Iteration
159

## Scope
- files audited: 15 (all `.lean` under the project tree, excluding `.lake/` and `.archon/` snapshots)
- files skipped (per directive): 0

## Focus-area verdict (AbelianVarietyRigidity.lean)

The three focus questions from the directive all resolve **clean**:

1. **`rigidity_eqOn_saturated_open_to_affine` (L124–141, body `sorry`) — statement is honestly
   formed and non-vacuous; NOT a laundering stand-in.**
   - It is the genuine Mumford bridge-2 (slice-constancy): on a `p₂`-saturated open
     `U = p₂⁻¹(Vset)` where `f` lands in a single affine `U₀`, each proper integral slice
     `X_y` maps to `U₀` and is therefore constant `= f(x₀,y)`, so `f = retract ≫ f` on `U`.
     This is **true as stated** in arbitrary characteristic over an algebraically closed base.
   - Every hypothesis is load-bearing for the conclusion: `[IsProper X.hom]` (proper slice),
     `[IsAlgClosed kbar]` (κ(y)=k̄), `_hU₀ : IsAffineOpen U₀` and `_hfU` (image in affine ⇒
     constant), `_hUV` saturation (the whole fibre sits in `U`, and `(x₀,y) ∈ U`). Drop any
     and the conclusion fails. Correctly does **not** carry the collapse hyp `_hf` — bridge 2
     is true without it (the collapse hyp is only needed upstream for non-emptiness).
   - Non-vacuous: the caller `rigidity_eqOn_dense_open` discharges all hypotheses with genuine
     (non-trivial) proofs — `_hUV` by `rfl`, `_hfU` by an honest `by_contra` on the definition
     of `Gset` (L270–276). So the helper is applied with a satisfiable premise set, not an
     unsatisfiable obligation.

2. **`rigidity_eqOn_dense_open` (L170–276) — body is `sorry`-free and genuinely consumes `_hf`.**
   - LSP diagnostics report `sorry` warnings on **only** L124, L453, L477, L502 — i.e. NOT on
     L170. The tactic block (L186–276) contains no literal `sorry`; it delegates bridge 2 to
     the named helper.
   - `_hf` is load-bearing: used at L249 (`congrArg Over.Hom.left _hf`) inside `hy₀ : y₀pt ∉ Gset`
     to make Mumford's open `V = Y∖G` non-empty. The docstring's `f := fst` counterexample
     (false without `_hf`) is correct. This is exactly the iter-157 laundering failure mode and
     it is now **fixed** — `_hf` is threaded through `rigidity_core` (L348→L356) into this lemma.

3. **The three `[IsAlgClosed kbar]` instance arguments — legitimate antecedent strengthening,
   no hidden gap.** Adding an instance hypothesis only narrows applicability (weakens the
   theorem); it cannot launder a gap. In `rigidity_eqOn_dense_open` it is consumed by the helper;
   in `rigidity_core`/`rigidity_lemma` it is threaded downward. Honest.

Axiom check: `rigidity_snd_lift` and `snd_left_isClosedMap` are fully axiom-clean
(`propext, Classical.choice, Quot.sound`). `rigidity_eqOn_dense_open`, `rigidity_core`,
`rigidity_lemma` carry `sorryAx` **only** via the disclosed bridge-2 helper — no surprise custom
axioms anywhere in the file (grep + `lean_verify` confirm zero `axiom` declarations project-wide).

## Per-file checklist

### AlgebraicJacobian.lean
- outdated comments: none · suspect definitions: none · dead-end proofs: none · bad practices: none · excuse-comments: none
- notes: import aggregator only (14 imports). Fine.

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- outdated comments: none · suspect definitions: none · dead-end proofs: none · bad practices: none · excuse-comments: none
- notes:
  - 4 `sorry` bodies (L141 bridge-2 helper, L462/486/515 deferred scaffolds) — all KNOWN/disclosed.
  - All four are **honest deferred obligations, true-as-stated** (verified each statement against
    standard mathematics: bridge-2 slice-constancy; ℙ¹→AV constant; genus-0 curves ≅ ℙ¹; pointed
    genus-0 rigidity). None is false-as-stated or laundering.
  - Proven parts (`rigidity_snd_lift`, `snd_left_isClosedMap`, `rigidity_eqOn_dense_open`,
    `rigidity_core`, `rigidity_lemma`) compile clean; docstrings accurately track status.

### AlgebraicJacobian/Jacobian.lean
- outdated comments: none · suspect definitions: none · dead-end proofs: none · bad practices: none · excuse-comments: none
- notes:
  - 2 `sorry` bodies (L265 `genusZeroWitness.key`, L303 `positiveGenusWitness`) — KNOWN.
  - `key : f = toUnit C ≫ η[A]` is the genuine genus-0 rigidity content (true-as-stated). The
    surrounding uniqueness clause is fully proven (epi-cancellation, L266–277). Honest deferral.
  - `genusZeroWitness` six structural fields all close; `nonempty_jacobianWitness` honestly
    delegates by `by_cases` to the two arms. No laundering.

### AlgebraicJacobian/RigidityKbar.lean
- outdated comments: none · suspect definitions: none · dead-end proofs: none · bad practices: none · excuse-comments: none
- notes: 1 `sorry` (L88 `rigidity_over_kbar`) — KNOWN, honest scaffold. Carries `[CharZero]`;
  documented as the fallback route-(a) artifact. Statement is true-as-stated.

### AlgebraicJacobian/Rigidity.lean
- outdated comments: none · suspect definitions: none · dead-end proofs: none · bad practices: none · excuse-comments: none
- notes: `Scheme.Over.ext_of_eqOnOpen` fully closed. Exemplary hygiene — "Hypothesis history"
  block documents *why* the point-wise hypothesis is mathematically too weak (char-p Frobenius
  counterexample) and was strengthened. Not an excuse-comment; a correctness rationale.

### AlgebraicJacobian/Differentials.lean
- outdated comments: none · suspect definitions: none · dead-end proofs: none · bad practices: none · excuse-comments: none
- notes: all proven. `smooth_locally_free_omega` docstring honestly discloses that the *converse*
  Jacobian-criterion direction is mathematically false (with counterexample) — good hygiene, not
  a stand-in.

### AlgebraicJacobian/Genus.lean
- outdated comments: none · suspect definitions: none · dead-end proofs: none · bad practices: none · excuse-comments: none
- notes: `genus := finrank k (HModule k (toModuleKSheaf C) 1)` — honest `dim_k H¹(C,𝒪)`. Closed.

### AlgebraicJacobian/AbelJacobi.lean
- outdated comments: none · suspect definitions: none · dead-end proofs: none · bad practices: none · excuse-comments: none
- notes: clean delegation of all three protected declarations to the witness's `isAlbaneseFor`.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- outdated comments: 1 (minor) · suspect definitions: none · dead-end proofs: none · bad practices: none · excuse-comments: none
- notes:
  - No live `sorry` (all `sorry`-word hits are in docstrings/historical notes).
  - L20–26: header NOTE references "the iter-145 `: True := sorry` placeholders" which no longer
    exist (the real signatures landed). Stale but non-misleading historical note — **minor**.
  - `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` has a counterexample-aware signature
    (`[IsAlgClosed]`+`[IsDomain]` documented as essential); honest closed proof.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- outdated comments: 2 (major) · suspect definitions: none · dead-end proofs: none · bad practices: none · excuse-comments: none
- notes:
  - No live `sorry` (all `sorry`-word hits are docstrings describing past/excised state).
  - **STALE section docstrings (major).** L297–327 ("The next three declarations support … main
    lemma `mulRight_globalises_cotangent`") and L428–451 ("The three declarations below … Step 2
    PARTIAL iter-137 (body remains `sorry`); Compose main lemma body `sorry`") describe
    declarations that were **excised iter-145** (`relativeDifferentialsPresheaf_basechange_along_proj_two`,
    `mulRight_globalises_cotangent`; see the EXCISE comments L552–560, L624–629). Only one of the
    "three declarations" (`..._restrict_along_identity_section`, Step 3, closed) actually remains.
    A reader scanning these blocks would conclude the file still has live `sorry`s; it has none.
  - `cotangentSpaceAtIdentity` "Caveat on canonicity" is an honest mathematical disclosure of
    `Classical.choose` chart non-canonicity, not a defect.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- outdated comments: none · suspect definitions: none · dead-end proofs: none · bad practices: none · excuse-comments: none
- notes: single instance, honestly closed.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- outdated comments: none · suspect definitions: none · dead-end proofs: none · bad practices: none · excuse-comments: none
- notes: three declarations, all closed.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- outdated comments: none · suspect definitions: none · dead-end proofs: none · bad practices: none · excuse-comments: none
- notes:
  - All declarations closed. Historical notes about deleted dead scaffolding
    (`IsAffineHModuleHomFinite`) are honest disclosures with the mathematical reason (Γ(U,𝒪) not
    finite over k on a proper affine open).
  - `IsAffineHModuleVanishing` / `IsHModuleHomFinite` are deferred-obligation Prop carrier
    classes; `instIsHModuleHomFinite_toModuleKSheaf` is a genuine producer (Stein). Honest.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- outdated comments: none · suspect definitions: none · dead-end proofs: none · bad practices: none · excuse-comments: none
- notes: full MV-LES core for the `ModuleCat k` flavour, all closed; faithful Mathlib mirror.
  `set_option backward.isDefEq.respectTransparency false` usages match Mathlib's own MV proofs
  (legitimate, not a smell).

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- outdated comments: none · suspect definitions: none · dead-end proofs: none · bad practices: 1 (minor) · excuse-comments: none
- notes:
  - All declarations closed, no `sorry`.
  - Carrier classes `IsCechAcyclicCover`, `HasCechToHModuleIso`, `HasAffineCechAcyclicCover`
    encode deferred mathematical obligations as Prop hypotheses. **No false producer instance is
    asserted** — `HasAffineCechAcyclicCover` has no in-tree producer, so nothing is laundered;
    the genus-finiteness ladder honestly depends on a not-yet-supplied instance (disclosed in
    docstrings). Flagged minor only for visibility, not a defect.

## Must-fix-this-iter

None.

The directive's iter-157 failure mode (a false-as-stated / laundering `sorry`) is specifically
**absent**: `rigidity_eqOn_saturated_open_to_affine` is true-as-stated with all hypotheses
load-bearing and is applied non-vacuously; `rigidity_eqOn_dense_open` is `sorry`-free and genuinely
consumes `_hf`; the `[IsAlgClosed]` additions are honest antecedent strengthenings. All 7 disclosed
`sorry`s are honest deferred obligations, each true-as-stated.

## Major

- `AlgebraicJacobian/Cotangent/GrpObj.lean:428-451` — stale section docstring: claims "three
  declarations below" with `sorry` bodies (Step 2 base-change PARTIAL `sorry`, Compose main lemma
  `sorry`), but those declarations were excised iter-145; only the closed Step-3 declaration
  remains and the file has zero live `sorry`s. Misleads a reader about file status.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:297-327` — stale section docstring: describes a
  three-step chain culminating in `mulRight_globalises_cotangent`, which was excised iter-145
  (EXCISE note L624-629). The advertised "main lemma" no longer exists.

## Minor

- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:20-26` — header NOTE references the long-removed
  iter-145 `: True := sorry` placeholders; harmless historical residue.
- `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean:675-682` — `HasAffineCechAcyclicCover` is
  an unbacked deferred-obligation Prop class on the critical path of the genus-finiteness ladder;
  no in-tree producer (honest deferral, disclosed). Noted for visibility only.

## Excuse-comments (always called out separately)

None. No `-- TODO replace`, `-- placeholder`, `-- temporary`, `-- wrong but works`, or
`-- will fix later` comments on any live declaration. Where the project documents incompleteness
(e.g. `Differentials.smooth_locally_free_omega`'s false-converse note, `Rigidity`'s Frobenius
hypothesis-history) it is as a *correctness rationale*, not an admission that landed code is wrong.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2 (both stale docstrings in `Cotangent/GrpObj.lean` referencing iter-145-excised declarations)
- **minor**: 2
- **excuse-comments**: 0

Overall verdict: The iter-159 prover work on `AbelianVarietyRigidity.lean` is sound and honest —
the new bridge-2 helper is true-as-stated with load-bearing hypotheses, `rigidity_eqOn_dense_open`
is genuinely `sorry`-free and consumes `_hf`, the iter-157 laundering is fixed, and no file
contains a false-as-stated sorry, excuse-comment, or unauthorized axiom; the only real findings are
two stale docstrings in `Cotangent/GrpObj.lean`.
