# Lean Audit Report

## Slug
iter154

## Iteration
154

## Scope
- files audited: 5 (the five named in the directive)
- files skipped (per directive): 0

Verification method: `lean_diagnostic_messages` (whole-file, then severity=warning)
and `lean_verify` (axiom check) on each load-bearing declaration; `Grep` for
dangling references and consumer/import checks; `archon-protected.yaml` cross-check.

---

## Per-file checklist

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean  (this iter's edit target)
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 2 (both minor; both honestly documented)
- **excuse-comments**: none
- **notes**:
  - **The iter-154 rewrite is GENUINE.** `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
    (L197) compiles with **no diagnostics** and is **axiom-clean**: axioms =
    `{propext, Classical.choice, Quot.sound}` only — no `sorryAx`, no custom
    axiom. No `sorry` anywhere in the file. The iter-153 "Mathlib gap / bright-line
    STOP / residual sorry" verdict is genuinely overturned by a real proof.
  - **Not vacuous.** The hypotheses `[IsAlgClosed k] [CharZero k] [IsDomain B]
    [FiniteType k B] [IsStandardSmoothOfRelativeDimension n k B]` are jointly
    satisfiable (e.g. `k = ℂ`, `B = ℂ[X]`), and the proof is constructive (FT.1
    push to `K = Frac B`; FT.2 transcendence-⇒-`H1Cotangent`-vanishing contradiction;
    FT.3 base case `_ratfunc_D_X_ne_zero` + closer `_algebraic_mem_range`). The
    docstring's FT.1/FT.2/FT.3 narration matches the actual tactic blocks line-for-line.
  - Helpers `_ratfunc_D_X_ne_zero` (L118) and `_algebraic_mem_range` (L145) are
    clean: the axiom check on their sole caller is `sorryAx`-free, and the
    whole-file diagnostic is empty, so neither helper hides a `sorry`.
  - `_mvPoly_*` removal verified clean: the only surviving mention (L68) is correct
    past-tense history ("were removed iter-154 (dead under this route)"); no dangling
    `_mvPoly` declaration or reference remains anywhere in the project.
  - **(minor / bad practice)** L207 `have _hRev : ∀ a, D … (algebraMap k B a) = 0`
    is computed and then never used by the proof. It is honestly labelled
    "recorded for downstream symmetry" in the docstring (L194–196) and underscore-
    named, so it is *not* misleading (it is explicitly not passed off as load-
    bearing) — but it is genuinely dead local scaffolding.
  - **(minor / bad practice)** The `{n}` + `[IsStandardSmoothOfRelativeDimension n k B]`
    binders (L200) are genuinely unused by the proof; the docstring discloses this
    honestly (L188–192). The docstring calls them "frozen", but the declaration is
    **not** in `archon-protected.yaml` (only `genus`, `Jacobian`, its 4 instances,
    and 3 `AbelJacobi` decls are) — "frozen" is loose wording, not a frozen signature.
  - **(see ChartAlgebraS3 block)** L6 `import AlgebraicJacobian.Cotangent.ChartAlgebraS3`
    is a **dead import**: the file consumes zero S3 declarations (its own L59/L362
    comments state "No `ChartAlgebraS3` (S3.*) lemma consumed").
  - `constants_integral_over_base_field` (L368) and
    `GrpObj.df_zero_factors_through_constant_on_chart` (L315): both axiom-clean
    `{propext, Classical.choice, Quot.sound}`, no `sorry`. Comments match proofs.

### AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean
- **outdated comments**: yes — top module docstring + several lemma docstrings
- **suspect definitions**: 4 `sorry`-bodied theorems (now orphaned)
- **dead-end proofs**: 4 (lines 180, 243, 324, 389)
- **bad practices**: whole file is orphaned dead weight
- **excuse-comments**: none (structured sorries with documented closure plans, not `TODO`/`temporary`)
- **notes**:
  - **Entire file orphaned.** It is imported only by `ChartAlgebra.lean`, which (by
    its own admission) consumes **none** of these declarations. Confirmed by `Grep`:
    every cross-file mention of `gammaAlgebra`, `isGeometricallyReduced_Gamma_of_smooth`,
    `Gamma_baseChange_iso_tensor_of_proper`, `…of_isGeometricallyReduced_of_finite`,
    `…of_unique_minPrime_baseChange`, `…of_finite_of_perfectField` is inside this file
    or in a ChartAlgebra comment saying it is *not* used.
  - 4 live `sorry`s (diagnostic-confirmed): `isGeometricallyReduced_Gamma_of_smooth`
    (L180/199), `Gamma_baseChange_iso_tensor_of_proper` (L243/276),
    `Algebra.IsSeparable.of_isGeometricallyReduced_of_finite` (L324/342),
    `Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange` (L389/403).
  - Orphaned non-sorry decls: `gammaAlgebraMap` (L91), `gammaAlgebra` (L100),
    `Algebra.IsSeparable.of_finite_of_perfectField` (L435, proven, unused).
  - **Stale top docstring (L59–63):** "The four lemmas are consumed by Lane 2 …
    the consolidated `IsPurelyInseparable k Γ ∧ Algebra.IsSeparable k Γ` `sorry`
    at L367 of `ChartAlgebra.lean` is rewritten to feed (S3.sep.1 → S3.sep.2) …".
    That consumer `sorry` no longer exists; nothing feeds these lemmas.
  - **Recommendation:** delete this file and drop the L6 import from `ChartAlgebra.lean`.
    If kept as an upstream-PR staging area, the docstrings must stop asserting live
    consumption. Carrying 4 `sorry`s with no consumer is dead scaffolding.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: yes — multiple stale piece-(i.b) headers
- **suspect definitions**: none
- **dead-end proofs**: none (file is `sorry`-free; diagnostic warnings empty)
- **bad practices**: misleading `NEEDS_MATHLIB_GAP_FILL` tag on a closed lemma
- **excuse-comments**: none
- **notes**:
  - File compiles clean, no `sorry`.
  - **(major / misleading)** `shearMulRight` (L350) docstring (L345–348) is tagged
    `NEEDS_MATHLIB_GAP_FILL`, but the lemma is **fully proven** (complete `hom_inv_id`/
    `inv_hom_id`, `@[simps]`, no `sorry`). The tag falsely advertises an open gap.
  - **(major / stale)** The piece-(i.b) program headers (L297–327 and L428–451)
    describe `relativeDifferentialsPresheaf_basechange_along_proj_two` (Step 2,
    "body remains `sorry`", "NEEDS_MATHLIB_GAP_FILL ~150–300 LOC") and
    `mulRight_globalises_cotangent` (the "main lemma", "body `sorry` pending Step 2")
    as live, pending, sorry-bodied goals. Both were **excised in iter-145** (the
    EXCISE notes at L552–560 and L624–629 confirm removal). The surrounding prose
    still narrates them as the active closure target — directly contradicted by the
    same file's excise comments.
  - **(minor / possible dead code)** With the piece-(i.b) main lemma excised, the
    surviving support decls `schemeHomRingCompatibility` (L424),
    `section_snd_eq_identity_struct` (L458), `isIso_of_app_iso_module` (L544),
    and `relativeDifferentialsPresheaf_restrict_along_identity_section` (L579) may
    now be orphaned (they existed to feed the excised iso). Worth a consumer check
    next iter; not asserted as dead without confirmation.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none significant
- **suspect definitions**: 2 `sorry`-bodied (load-bearing scaffolding)
- **dead-end proofs**: 2 (lines 193/197, 219/223)
- **bad practices**: 1 style (long line)
- **excuse-comments**: none
- **notes**:
  - `genusZeroWitness` (L193, `:= sorry` at L197) and `positiveGenusWitness`
    (L219, `:= sorry` at L223) are load-bearing: they feed
    `nonempty_jacobianWitness` → `jacobianWitness` → the protected `Jacobian` and
    its four protected instances. These are **pre-existing, documented Phase-C
    scaffolding sorries** with explicit closure gates (M2/M3), untouched this iter,
    and are not excuse-comments. Recorded here for completeness, not as an iter-154
    regression.
  - **(minor / style)** L275 exceeds the 100-char line limit (linter warning).
  - The "Forbidden shortcut (sanity check)" block (L44–53) is a legitimate
    design-rationale note, not an excuse-comment.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: 1 `sorry`-bodied (load-bearing keystone scaffold)
- **dead-end proofs**: 1 (line 75/88)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `rigidity_over_kbar` (L75, `:= sorry` at L88) is the M2.a keystone; documented
    scaffold gated on the cotangent-vanishing pile. Pre-existing, untouched this
    iter, fully documented. Recorded for completeness.

---

## Must-fix-this-iter

None.

The single declaration edited this iter (`mem_range_algebraMap_of_D_eq_zero` and its
two private helpers in `ChartAlgebra.lean`) is genuine, `sorry`-free, and axiom-clean.
No excuse-comments, no weakened-wrong definitions, no parallel-Mathlib APIs, no
unauthorized axioms, and no *load-bearing* `sorry` was introduced this iter. The
existing load-bearing `sorry`s (Jacobian/RigidityKbar scaffolding) are long-standing,
project-authorized, and documented — not iter-154 regressions — so they are reported
under Major rather than fabricated into a this-iter gate.

## Major

- `Cotangent/ChartAlgebraS3.lean` (whole file) — **orphaned dead scaffolding**: imported
  only by `ChartAlgebra.lean`, which consumes none of it, yet it carries 4 live
  `sorry`s (L180, L243, L324, L389) plus stale docstrings asserting live consumption
  (L59–63). Recommend deletion + dropping the dead import at `ChartAlgebra.lean:6`.
- `Cotangent/GrpObj.lean:345-348` — `shearMulRight` is labelled `NEEDS_MATHLIB_GAP_FILL`
  but is fully proven; the tag misadvertises a closed lemma as an open gap.
- `Cotangent/GrpObj.lean:297-327, 428-451` — piece-(i.b) headers narrate Step 2
  (`relativeDifferentialsPresheaf_basechange_along_proj_two`) and the main lemma
  (`mulRight_globalises_cotangent`) as live pending sorries; both were excised iter-145
  (per the same file's L552-560 / L624-629 excise notes). Stale and self-contradictory.
- `Jacobian.lean:197, 223` — `genusZeroWitness` / `positiveGenusWitness` `:= sorry`
  (load-bearing for the protected `Jacobian`); pre-existing authorized Phase-C scaffold.
- `RigidityKbar.lean:88` — `rigidity_over_kbar := sorry` (M2.a keystone); pre-existing
  authorized scaffold.

## Minor

- `ChartAlgebra.lean:207` — `_hRev` computed but never used (honestly documented as a
  symmetry record; not misleading, just dead local).
- `ChartAlgebra.lean:200` — unused `{n}` / `[IsStandardSmoothOfRelativeDimension n k B]`
  binders, honestly disclosed; docstring calls them "frozen" but the decl is not in
  `archon-protected.yaml` (loose wording).
- `Jacobian.lean:275` — line exceeds 100-char limit (style linter).
- `GrpObj.lean` (L424, L458, L544, L579) — support decls possibly orphaned after the
  iter-145 main-lemma excision; warrants a consumer check.

## Excuse-comments (always called out separately)

None. No `TODO replace`, `placeholder`, `temporary`, `wrong but works`, or `will fix
later` comments were found on any declaration. The `sorry`s present are structured
scaffolding with documented closure plans, and the `ChartAlgebra.lean` history notes
are accurate past-tense ("verdict was OVERTURNED"), not self-deception.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 5 (1 orphaned-file w/ 4 sorries; 2 GrpObj stale/misleading comment clusters; 2 pre-existing load-bearing scaffold sorries)
- **minor**: 4
- **excuse-comments**: 0

Overall verdict: the iter-154 KDM rewrite is the real thing — compiles, axiom-clean,
no `sorry`, not vacuous, comments match the proof — but it left `ChartAlgebraS3.lean`
fully orphaned (4 dead sorries + a dead import) and several iter-145-excised
piece-(i.b) comments in `GrpObj.lean` are now stale/self-contradictory.
