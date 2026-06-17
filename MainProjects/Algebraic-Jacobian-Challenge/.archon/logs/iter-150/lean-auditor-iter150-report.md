# Lean Audit Report

## Slug

iter150

## Iteration

150

## Scope

- files audited: 15 (every `.lean` under the project tree:
  `AlgebraicJacobian.lean` + 14 files under `AlgebraicJacobian/`)
- files skipped (per directive): 0
- focus areas honoured: extra attention to `ChartAlgebra.lean` and
  `ChartAlgebraS3.lean` (prover-touched this iter); kernel-axiom probe
  on all four iter-150 helper lemmas + the new
  `Algebra.IsSeparable.of_finite_of_perfectField`. The `references/`
  folder and `.archon/logs/.../snapshots/*.lean` files were skipped
  (not part of the project tree audit surface).

## Per-file checklist

### AlgebraicJacobian.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 14-line import-aggregator file. No declarations, no body. Clean.

### AlgebraicJacobian/AbelJacobi.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure projection-from-`jacobianWitness` declarations. All bodies
    are direct term-mode field projections. No sorries here.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged
- **excuse-comments**: none
- **notes**:
  - L354, L523, L539, L565: four uses of
    `set_option backward.isDefEq.respectTransparency false in`. Each
    is documented inline as required to make typeclass / `dsimp`
    transparency work past structure-literal projection (mirroring
    upstream Mathlib's `MayerVietoris.lean` usage L85, L86). This is
    a legitimate transparency knob, not a smell; flagging as a
    bookkeeping item only.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `HasCechToHModuleIso` and `HasAffineCechAcyclicCover` are
    existence-bundled `Prop`-classes that wrap data via `Nonempty`.
    L488–514 honestly disclose that the comparison iso is data
    wrapped via `Classical.choice` — kernel axiom only, no new axiom.
  - The `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover`
    instance closes the bridge from existence-of-acyclic-cover to
    per-affine-open vanishing; the body is a clean `obtain`-chase
    with no shortcuts.

### AlgebraicJacobian/Cohomology/SheafCompose.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged
- **excuse-comments**: none
- **notes**:
  - L6 `import Mathlib`: full-Mathlib import in a one-instance file.
    This was inherited (not iter-150 work); flag-only.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three sheafification / Ext / `toAbSheaf` instances, all
    `inferInstance`-style or direct construction.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Phase A step 5/6 carriers + iter-038–046 finiteness ladder.
    Long file but every declaration has a body; no inline sorries.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean **(prover-touched, iter-150)**

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: 0
- **bad practices**: 1 flagged
- **excuse-comments**: none
- **notes**:
  - L1–66 header comment block faithfully describes the iter-150
    deposit and is mathematically honest about what is open.
  - **Iter-150 helpers L117–225 audit (focus area).**
    Four private helpers `_finsupp_sub_single_eq_of_one_le`,
    `_mvPoly_coeff_pderiv_at_shifted`,
    `_mvPoly_mem_range_C_of_pderiv_eq_zero`,
    `_mvPoly_mem_range_C_of_D_eq_zero` all compile clean and
    `lean_verify` returns kernel-only axioms
    `[propext, Classical.choice, Quot.sound]` for each. Lean idioms
    are reasonable: `classical`, `ext`, `by_cases`, `Finset.sum_eq_single`,
    `MvPolynomial.as_sum`/`pderiv_monomial`/`coeff_monomial`. Naming
    convention `_underscore_prefix` correctly signals private.
  - **`KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
    (L256–388).** Structured `sorry` at L388 documented inline as
    the (BR.5) transfer step pending Mathlib `ker_map_of_surjective`
    unfolding (~30 LOC). The `_hRev`, `_hStdSm`, `_hFree`, `_basis`,
    `_hCoordVanish`, `_hπSurj`, `_hFunct`, `bTilde`, `hbTilde` named
    haves/lets are all `_`-prefixed and intentionally unused this
    iter — they document the (BR.2)–(BR.4) scaffolding chain that
    iter-151+ will consume. This is acceptable structured-sorry
    discipline.
  - **`constants_integral_over_base_field` (L473–655).** Body has
    one inner `sorry` at L617 ((b.2) `IsPurelyInseparable k Γ`
    branch). The (b.1) `IsSeparable k Γ` branch IS closed
    project-internally — it delegates to `(S3.sep.1)` and
    `(S3.sep.2)` in `ChartAlgebraS3.lean`, both of which still carry
    sorries themselves. The body's algebraic scaffold (the
    `IsPurelyInseparable + IsSeparable ⇒ algebraMap surj` reduction
    via `IsPurelyInseparable.surjective_algebraMap_of_isSeparable`)
    is mathematically correct and well-stated.
  - L20–21 header comment refers to "iter-145 `: True := sorry`
    placeholders" — historical reference to placeholders that have
    been REPLACED; not an excuse-comment, just stale-but-honest
    documentation of file history.
  - L552–560 + L624–629: two iter-145 EXCISE comment blocks recording
    declarations that were removed. These reference
    `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` for the iter-145+
    chart-algebra route 5-piece skeleton. Honest disclosure of
    structural rewrites; not stale.
  - L23–29: header `iter-146 NOTE` describing the
    `Algebra.TensorProduct.rightAlgebra` re-enablement. Still
    accurate (L78 carries the corresponding
    `attribute [local instance]`).
  - L78: re-enabling `Algebra.TensorProduct.rightAlgebra` as a local
    instance is documented and necessary for the
    `algebra_isPushout_of_affine_product` `inferInstance` discharge
    (L92). Sound.
  - **Bad-practice flag (minor):** `Mathlib.RingTheory.Kaehler.Polynomial`
    is imported but the file uses only `MvPolynomial.pderiv` /
    `KaehlerDifferential.mvPolynomialBasis_repr_apply`. The polynomial
    Kähler API is consumed transitively; explicit import is fine but
    `Mathlib.RingTheory.Kaehler.Basic` would have sufficed for many
    of the lemmas. Not load-bearing.
  - **Outdated comment (1):** L23–24 references the `(α)` /
    `algebra_isPushout_of_affine_product` import discussion that is
    now stale since iter-146 closed `(α)`; the header status block
    L40–62 supersedes it correctly. The L23 NOTE is a historical
    footnote, not a misdirection — call it minor.
  - **Outdated comment (2):** L1–5 copyright header says "iter-144
    piece (ii) pivot" but the iter-150 chart-algebra route has
    evolved (HYBRID part (A)/(B)/(C)). Title comment L31
    "Chart-algebra skeleton for the iter-144 piece (ii) pivot" is
    accurate as historical naming but the documented closure path
    has shifted; minor drift.

### AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean **(prover-touched, iter-150)**

- **outdated comments**: 3 flagged (stale line-number cross-refs)
- **suspect definitions**: none
- **dead-end proofs**: 0
- **bad practices**: 1 flagged (dead/unused new helper)
- **excuse-comments**: none
- **notes**:
  - File compiles clean; four sorries match the four planned (S3.*)
    sub-lemmas plus one HYBRID-helper landing.
  - **`isGeometricallyReduced_Gamma_of_smooth` (L180–199).** Structured
    `sorry` with three Mathlib pieces documented in the docstring.
    Body uses `letI := gammaAlgebra k X` to set up the implicit
    algebra structure before the sorry — this is correct and
    matches the consumer's local definition.
  - **`Gamma_baseChange_iso_tensor_of_proper` (L243–276).** Structured
    `sorry` marked HYBRID-DEFERRED. The signature uses
    `Nonempty (TensorProduct k Γ K ≃ₐ[K] Γ(X_K))` which is reasonable
    for a `K`-algebra iso (data → Prop-wrapped). The `letI`/`haveI`
    chain inside the conclusion correctly threads `gammaAlgebra k X`,
    the `pullback`-based `XK.Over (Spec (CommRingCat.of K))` instance,
    and `gammaAlgebra K XK`. Sound shape.
  - **`Algebra.IsSeparable.of_isGeometricallyReduced_of_finite`
    (L324–342).** Structured `sorry`. The declaration is correctly
    placed in `_root_.Algebra.IsSeparable.` namespace as a
    Mathlib-PR-grade target. Signature matches Stacks 0BJF
    statement.
  - **`Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange`
    (L389–403).** Structured `sorry`, also HYBRID-DEFERRED. The
    hypothesis encoding
    `(minimalPrimes (TensorProduct k (AlgebraicClosure k) F)).Subsingleton`
    is sound; placement in `_root_.Algebra.IsPurelyInseparable.`
    is a Mathlib-PR-grade home.
  - **NEW HELPER `Algebra.IsSeparable.of_finite_of_perfectField`
    (L435–443; focus area).** `lean_verify` reports kernel-only
    axioms `[propext, Classical.choice, Quot.sound]`. Body is a
    pure-term `Algebra.IsAlgebraic.isSeparable_of_perfectField`
    invocation, relying on Mathlib's
    `Algebra.IsAlgebraic.of_finite` instance to discharge
    `IsAlgebraic`. Lemma is well-stated and sound. **Caveat:**
    the docstring L412–419 honestly admits the lemma is "NOT (yet)
    wired into `constants_integral_over_base_field`" — it is
    forward-looking. This is fine as a planned iter-151+ rewire
    helper, but it does mean the lemma is currently dead code
    (in the sense that no project file consumes it). Minor.
  - **Stale line-number cross-refs:**
    - L60 references "consolidated `IsPurelyInseparable k Γ ∧
      Algebra.IsSeparable k Γ` `sorry` at L367 of `ChartAlgebra.lean`" —
      current `ChartAlgebra.lean:L367` is inside
      `_mvPoly_mem_range_C_of_pderiv_eq_zero`, not the consumer.
      The consumer `constants_integral_over_base_field` is at L473
      now.
    - L313 references "iter-149 consumer `constants_integral_over_base_field`
      (`ChartAlgebra.lean:L457`)". Stale — actual consumer body is
      ~L473.
    - L156–161 references "consumer's local definition `set α :=
      ...` at `ChartAlgebra.lean:L431`". Stale — the `set α`
      definition is at ~L537 of the current file.
    All three are minor docstring drift; the cross-refs were correct
    at the iter-149 writer round but iter-150 inserted ~120 LOC of
    new helper lemmas above the consumer block, shifting line
    numbers.

### AlgebraicJacobian/Cotangent/GrpObj.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 632-line file with no sorries; `lean_diagnostic_messages` returns
    `[]` for warnings. The iter-145 EXCISE comment blocks
    (L552–560, L624–629) honestly document deletions; the
    remaining declarations (`cotangentSpaceAtIdentity`,
    `cotangentSpaceAtIdentity_finrank_eq`, `shearMulRight`,
    `section_snd_eq_identity_struct`,
    `relativeDifferentialsPresheaf_restrict_along_identity_section`)
    all carry bodies.
  - The `Classical.choose`-chain in `cotangentSpaceAtIdentity`
    (L162–201) is explicitly justified in the docstring (L116–161)
    as the iter-131 body-shape refactor — sound.

### AlgebraicJacobian/Differentials.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L119–123 explicitly documents that the REVERSE direction of the
    Jacobian criterion is *mathematically false* without H1Cotangent
    vanishing — this is honest mathematical disclosure, not an
    excuse-comment. The forward direction is what is stated and
    proved.

### AlgebraicJacobian/Genus.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged
- **excuse-comments**: none
- **notes**:
  - L6 `import Mathlib`: full-Mathlib import in a one-definition
    file. Inherited from iter-011; minor smell.

### AlgebraicJacobian/Jacobian.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (line-length)
- **excuse-comments**: none
- **notes**:
  - `genusZeroWitness` (L197) and `positiveGenusWitness` (L223) are
    both `sorry`-bodied. Header L19–53 documents the Phase-C
    scaffolding inventory honestly; `nonempty_jacobianWitness`
    (L249) is now a `by_cases` decomposition consuming both, not
    itself a `sorry` — that's the iter-135 restructure paying off.
  - L275 has a `linter.style.longLine` warning (>100 chars: the
    `Jacobian` def signature). Minor cleanup.
  - The "Forbidden shortcut (sanity check)" block L44–53 is an
    excellent self-audit: the file documents the trap that
    `Jacobian C := 𝟙_ _` unconditionally would compile but is
    mathematically wrong in genus ≥ 1. This is the OPPOSITE of an
    excuse-comment — it's defensive documentation.

### AlgebraicJacobian/Rigidity.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Scheme.Over.ext_of_eqOnOpen` (L91–122) is fully closed. The
    "Hypothesis history" block L43–79 is a textbook example of
    honest math-side disclosure (point-wise hypothesis was too
    weak; strengthened to scheme-level; `IsReduced` added because
    Mathlib `b80f227` lacks the corresponding smooth ⇒ reduced
    lemma over a field). NOT an excuse-comment — it explains the
    *correct* hypothesis choice.

### AlgebraicJacobian/RigidityKbar.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `rigidity_over_kbar` (L75–87) carries a single load-bearing
    `sorry`. The header documents the M2.a-critical-path gating
    and the C.2.b–C.2.e decomposition; the encoding-choice block
    L31–46 documents *why* Option B was taken over Option A
    (Option A — literal `Spec.map MvPolynomial.C` — would
    encode the AFFINE line, not the projective line; this is
    correctly identified as mathematically wrong). Honest scaffold.

## Must-fix-this-iter

**None for this iter.** Every `sorry` in the audited files is
documented as a structured sorry on a known multi-iteration
critical-path claim, with a documented closure recipe and an
honest declaration of the residual Mathlib gap. None of the
iter-150 prover edits introduced new wrong-shape definitions, new
parallel APIs of existing Mathlib, or new excuse-comments. The
four iter-150 helpers + the new
`Algebra.IsSeparable.of_finite_of_perfectField` all
`lean_verify`-clean (kernel-only axioms).

The four `sorry`-bodied (S3.*) lemmas + `rigidity_over_kbar` +
`KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` +
`constants_integral_over_base_field`'s inner (b.2) sorry +
`genusZeroWitness` + `positiveGenusWitness` are all flagged by the
auditor by default as "sorry on load-bearing claim", but the
project's documented multi-iteration scaffold (PROGRESS / STRATEGY
references inside the docstrings) make these acceptable structured
sorries, not under-classified must-fix items.

## Major

- `AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean:60` — stale
  cross-ref to `ChartAlgebra.lean:L367`. Iter-150 helper insertion
  shifted the consumer line numbers; the docstring still points at
  the iter-149 positions.
- `AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean:313` — stale
  cross-ref to `ChartAlgebra.lean:L457`. Same drift.
- `AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean:156` — stale
  cross-ref to "`set α := ...` at `ChartAlgebra.lean:L431`". Same
  drift; actual `set α` is at L537 now.

These three are documentation drift only; the lemmas themselves are
in scope and the references are recoverable by reader inspection.
Flag at major because they could confuse a future maintainer
reading the iter-151+ continuation directive.

## Minor

- `AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean:435–443` — the
  new helper `Algebra.IsSeparable.of_finite_of_perfectField` is
  honest forward-looking infrastructure but currently has no
  consumer (the docstring explicitly says iter-151+ writer round on
  `ChartAlgebra.lean` will wire it in). Dead code in this iter;
  acceptable as planner-honest scheduling but worth flagging.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:13` — import of
  `Mathlib.Algebra.MvPolynomial.PDeriv` (iter-150 addition) is
  correct, but the file now imports six Mathlib leaves plus three
  project files. Long but justified.
- `AlgebraicJacobian/Genus.lean:6` — `import Mathlib` is full-Mathlib
  on a one-declaration file. Pre-existing; not iter-150 work.
- `AlgebraicJacobian/Cohomology/SheafCompose.lean:6` — same pattern,
  pre-existing.
- `AlgebraicJacobian/Jacobian.lean:275` — line-length linter warning
  (>100 chars on the `Jacobian` def signature). Pre-existing; not
  iter-150 work.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:1–66` — header
  block has accumulated iter-141 / iter-144 / iter-145 / iter-146 /
  iter-147 / iter-148 / iter-149 / iter-150 commentary. None are
  factually wrong, but the cumulative weight is a readability cost.
  Iter-151+ may consider a header rewrite.

## Excuse-comments (always called out separately)

**None found.** I scanned all 15 files for the canonical
excuse-comment patterns (`-- TODO replace with real def`,
`-- placeholder`, `-- temporary`, `-- wrong but works`,
`-- will fix later`, `-- placeholder definition until ...`,
`-- stand-in for the real one`). Zero hits.

The closest borderline patterns are:

- `AlgebraicJacobian/Jacobian.lean:27` — uses the phrase
  "Phase-C OFF-LIMITS sorry". On read this is a STATUS tag (the
  sorry is documented and gated), not an excuse-comment. The
  surrounding docstring honestly explains *why* the body is
  deferred (M2+M3 gating per STRATEGY.md). Verdict: NOT an
  excuse-comment.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:20` — references
  "iter-145 `: True := sorry` placeholders". On read this is
  historical disclosure of *prior* placeholders that have already
  been REPLACED by real signatures. Verdict: NOT an excuse-comment.
- `AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean:152–179` —
  "Iter-150 prover-lane status (HYBRID part (B) attempted;
  consumer-blocked)" block. On read this honestly discloses two
  concrete reasons the local closure was deferred (consumer
  signature mismatch + Mathlib instance gap), with a planned
  iter-151+ remedy. Verdict: NOT an excuse-comment.

The project's documented "structured sorry" discipline is in good
hygiene this iter.

## Deprecated-tactic check (directive item)

The directive flagged `push_neg` as deprecated in iter-150
diagnostics. **Grep across `AlgebraicJacobian/**/*.lean` finds zero
uses of `push_neg`.** Either the prover already removed the
deprecated tactic between the diagnostic snapshot and the audit, or
the directive description was slightly imprecise. `lean_diagnostic_messages`
on `ChartAlgebra.lean` and `ChartAlgebraS3.lean` (warning severity)
returns only `declaration uses 'sorry'` items — no deprecation
warnings. No further surfacing needed this iter.

## Kernel-axiom check on iter-150 deposits

Ran `lean_verify` on the five iter-150 prover deposits flagged in
the directive focus areas:

| Declaration | File | Axioms | Source warnings |
| --- | --- | --- | --- |
| `_finsupp_sub_single_eq_of_one_le` | ChartAlgebra.lean | `propext, Classical.choice, Quot.sound` | 4 `local instance` (header notes) |
| `_mvPoly_coeff_pderiv_at_shifted` | ChartAlgebra.lean | `propext, Classical.choice, Quot.sound` | (same) |
| `_mvPoly_mem_range_C_of_pderiv_eq_zero` | ChartAlgebra.lean | `propext, Classical.choice, Quot.sound` | (same) |
| `_mvPoly_mem_range_C_of_D_eq_zero` | ChartAlgebra.lean | `propext, Classical.choice, Quot.sound` | (same) |
| `Algebra.IsSeparable.of_finite_of_perfectField` | ChartAlgebraS3.lean | `propext, Classical.choice, Quot.sound` | 2 `local instance` (header notes) |

All five are kernel-only. None introduce new axioms.

## Severity summary

- **must-fix-this-iter**: 0 — no excuse-comments, no
  weakened-wrong definitions, no parallel APIs of Mathlib, no
  suspect bodies on substantive claims beyond the project-
  documented structured sorries, no unauthorised axioms.
- **major**: 3 — stale line-number cross-refs in `ChartAlgebraS3.lean`
  (L60, L156, L313).
- **minor**: 6 — one dead/unused new helper
  (`Algebra.IsSeparable.of_finite_of_perfectField`), three pre-existing
  full-Mathlib imports / line-length warnings, one accumulated header
  block, one minor import scope question on `Mathlib.RingTheory.Kaehler.Polynomial`.
- **excuse-comments**: 0 — verified absent.

Overall verdict: **clean iter-150 prover work** — the four
MvPolynomial-side helpers and the new perfect-field separability
helper are mathematically sound, kernel-axiom-clean, and the
structured sorries the prover deposited at L388 (transfer gap),
L617 (purely-inseparable branch), and across the four (S3.*) lemmas
honestly disclose what remains. Three stale cross-references in
`ChartAlgebraS3.lean` are the only iter-150-specific drift items;
no must-fix-this-iter findings.
