# Refactor Report

## Slug
isalgclosed-signatures

## Status
COMPLETE

## Directive
**Problem.** `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` (in
`AlgebraicJacobian/Cotangent/ChartAlgebra.lean`) was mathematically FALSE as
stated: `[Field k] [CharZero k] [Algebra.FiniteType k B]
[Algebra.IsStandardSmoothOfRelativeDimension n k B]` + `D b = 0` does NOT imply
`b ∈ (algebraMap k B).range` (counterexamples `B = k×k`, `B = ℚ(√2)/ℚ`). The fix
is to add `[IsAlgClosed k]` + `[IsDomain B]` and propagate the alg-closed setting
to siblings and the over-`k̄` rigidity statement.

**Changes requested.** Signature surgery only (no proof filling): add binders to
the KDM lemma, its delegate `df_zero_factors_through_constant_on_chart`, and
`constants_integral_over_base_field`; reduce the latter's body to a single clean
`sorry` (alg-closed re-route); add `[IsAlgClosed kbar]`+`[CharZero kbar]` to
`rigidity_over_kbar`. Keep all `sorry` bodies; preserve the (C.a)–(C.c) scaffold.

## Changes Made

### File: `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`

- **Decl `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`**
  - **What:** Added `[IsAlgClosed k]` (after `[Field k]`) and `[IsDomain B]`
    (after `[CommRing B]`). Replaced the ~60-line "iter-151 FINDING: THE LEMMA IS
    FALSE AS STATED" comment block with a concise comment: the lemma is now TRUE
    under the two new instances; the residual `sorry` is the genuine
    constants-of-derivation transfer step (`ker d_{Frac B/k} = k`). The comment
    still cites both counterexamples (CE1 = `k×k` excluded by `[IsDomain B]`;
    CE2 = `ℚ(√2)/ℚ` excluded by `[IsAlgClosed k]`) so the geometric content is
    preserved. The (C.a)–(C.c) scaffold (`_mvPoly_*` helpers, `_hFunct`
    functoriality reduction, SubmersivePresentation lift) is kept verbatim;
    final `sorry` retained.
  - **Why:** The bare B-only statement is false; the two instances make it true.
  - **Cascading:** None — its only consumer is the delegate below (same file).

- **Decl `GrpObj.df_zero_factors_through_constant_on_chart`**
  - **What:** Added `[IsAlgClosed k]` and `[IsDomain B]` in the same positions.
    Scheme-level hypotheses on `C` unchanged. Body still the one-line delegate to
    the corrected KDM lemma. It now compiles SORRY-FREE (no longer launders a
    false statement).
  - **Why:** Propagate the corrected hypotheses to the consumer.
  - **Cascading:** None — no external caller (grep confirms only ChartAlgebra
    references it; ChartAlgebraS3's mentions are comments).

- **Decl `constants_integral_over_base_field`**
  - **What:** Added `[IsAlgClosed k]` (after `[Field k]`). Replaced the entire
    proof body (the substep (1)–(2) preamble + the `⟨hPI, hSep⟩`
    `IsPurelyInseparable`/`IsSeparable` split that consumed the four (S3.*)
    lemmas + the final `surjective_algebraMap_of_isSeparable`) with a single
    clean `sorry` and a concise comment describing the alg-closed re-route via
    `IsAlgClosed.algebraMap_bijective_of_isIntegral`. I reduced the WHOLE body to
    `sorry` (the directive's permitted fallback) rather than keeping the
    (1)–(2) preamble, because the preamble's `letI`/`set α`/`suffices` machinery
    entangled with the removed split; a single clean `sorry` is cleaner.
  - **Why:** Under `[IsAlgClosed k]` the proof collapses and no longer needs the
    (S3.*) lemmas.
  - **Cascading:** This removes the only consumption of `ChartAlgebraS3.lean`'s
    (S3.*) lemmas. Per directive, the `import AlgebraicJacobian.Cotangent.ChartAlgebraS3`
    was LEFT in place (off-path scaffolding; removing it is unnecessary churn).

### File: `AlgebraicJacobian/RigidityKbar.lean`

- **Decl `rigidity_over_kbar`**
  - **What:** Added `[IsAlgClosed kbar] [CharZero kbar]` as explicit instance
    binders directly on the theorem (not on the file `variable` line), keeping
    the hypotheses localized to this single declaration. Body stays `sorry`.
  - **Why:** The over-`k̄` rigidity statement requires the alg-closed base.
  - **Cascading:** None. `IsAlgClosed`/`CharZero` resolve via the existing
    `import AlgebraicJacobian.Rigidity` chain — no new import needed.

### File: `AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean`
- **No changes** (per directive). Confirmed it still compiles with its four
  (S3.*) `sorry`s unchanged.

## New Sorries Introduced
No NET change. The sorry landscape on touched files:
- `ChartAlgebra.lean:256` — `mem_range_algebraMap_of_D_eq_zero` (now TRUE;
  residual transfer `sorry`). [was a sorry before — same site]
- `ChartAlgebra.lean:468` — `constants_integral_over_base_field` (single clean
  `sorry`, alg-closed re-route target). [was 1 sorry before — same count]
- `RigidityKbar.lean:75` — `rigidity_over_kbar` (`sorry`, now with
  `[IsAlgClosed kbar]`+`[CharZero kbar]`). [unchanged]
- `ChartAlgebraS3.lean:180,243,324,389` — four (S3.*) `sorry`s (off-path,
  unchanged).
- `df_zero_factors_through_constant_on_chart` is SORRY-FREE (delegate compiles).

## Compilation Status
- Full `lake build` (`mcp__archon-lean-lsp__lean_build`): **succeeds**, 8332 jobs,
  no errors. Only `sorry` warnings (listed above) plus two pre-existing
  `longLine` style warnings in `Jacobian.lean:275` and `AbelJacobi.lean:22`
  (NOT from this refactor).
- `ChartAlgebra.lean`: compiles (2 sorry warnings).
- `RigidityKbar.lean`: compiles (1 sorry warning).
- `ChartAlgebraS3.lean`: compiles (4 sorry warnings, unchanged).
- `AlgebraicJacobian.lean` (umbrella importer): compiles.
- No new axioms (build clean; `sorry` is the only placeholder).

## Notes for Plan Agent
- `Jacobian.lean`'s `genusZeroWitness` body is `sorry` and does NOT call
  `rigidity_over_kbar` (verified by grep + reading lines 193–254). Adding
  `[IsAlgClosed kbar]`+`[CharZero kbar]` to `rigidity_over_kbar` therefore broke
  nothing downstream — no `sorry` insertion needed at any call site.
- No protected declaration was touched: none of the four edited decls appears in
  `archon-protected.yaml` (verified).
- The mathematical justification was sufficient for the surgery; no cascading
  type mismatches arose (the only consumer of the corrected KDM lemma is its
  same-file delegate, which now compiles sorry-free).
- For the next prover iter: `mem_range_algebraMap_of_D_eq_zero` and
  `constants_integral_over_base_field` are the two genuine to-prove goals.
  `constants_integral_over_base_field`'s comment names the intended closure:
  finite integral field extension of alg-closed `k` ⟹
  `IsAlgClosed.algebraMap_bijective_of_isIntegral` (in
  `Mathlib.FieldTheory.IsAlgClosed.Basic`). The (S3.*) lemmas in
  ChartAlgebraS3.lean are now genuinely unused (off-path); a future iter may
  delete that file + its import if the planner confirms no other use.
