# Refactor Report

## Slug
differentials-signatures-iter113

## Status
COMPLETE

## Directive

### Problem
`AlgebraicJacobian/Differentials.lean` carried three pre-existing signature
mismatches between Lean and the blueprint (`blueprint/src/chapters/Differentials.tex`),
surfaced iter-112 by `lean-vs-blueprint-checker-differentials-iter112` and
annotated in the chapter with three `% NOTE:` comments.

The mismatches:

1. `smooth_iff_locally_free_omega` (L816): LHS predicate `Smooth f` is
   dimension-free while the RHS rank condition mentions a free standalone
   parameter `(n : ℕ)`. The biconditional is structurally unsatisfiable.
2. `cotangent_at_section` (L832): same mismatch shape — hypothesis
   `(hsmooth : Smooth f)` is dimension-free while the conclusion talks about
   rank `n` for a free standalone `(n : ℕ)`.
3. `serre_duality_genus` (L976): both sides at cohomological index `0`, which
   reduces the claim to `dim H^0(O_C) = dim H^0(Ω_{C/k})`, a false statement
   for curves of genus > 1. The local docstring already agrees with the
   blueprint (`H^0(Ω_{C/k}) = H^1(O_C)`).

### Changes Requested (verbatim)
- Replace LHS of `smooth_iff_locally_free_omega` with
  `AlgebraicGeometry.IsSmoothOfRelativeDimension n f`.
- Replace `(hsmooth : Smooth f)` in `cotangent_at_section` with
  `(hsmooth : AlgebraicGeometry.IsSmoothOfRelativeDimension n f)`.
- Swap LHS/RHS of `serre_duality_genus` so LHS is the differentials side, and
  change the RHS index from `0` to `1`.

Explicitly out of scope: no `IsGeometricallyIntegral` typeclass (not in
Mathlib b80f227), no dimension-1 hypothesis on `serre_duality_genus`, no edits
to the blueprint chapter.

## Changes Made

### File: `AlgebraicJacobian/Differentials.lean`

- **What:** Three signature edits, exactly as the directive prescribed.
  - L818 (`smooth_iff_locally_free_omega`): replaced `Smooth f` on the LHS of
    the iff with `AlgebraicGeometry.IsSmoothOfRelativeDimension n f`.
  - L835 (`cotangent_at_section`): replaced hypothesis `(hsmooth : Smooth f)`
    with `(hsmooth : AlgebraicGeometry.IsSmoothOfRelativeDimension n f)`.
  - L976–982 (`serre_duality_genus`): swapped LHS↔RHS so the differentials
    sheaf appears on the LHS, and changed the RHS cohomological index from
    `0` to `1`. Final form:
    ```
    Module.rank k
        (HModule k (moduleKSheafOfModules C (relativeDifferentials C.hom)) 0) =
      Module.rank k (HModule k (toModuleKSheaf C) 1)
    ```
- **Why:** Operationalize the three blueprint-vs-Lean signature mismatches
  documented in the iter-112 review.
- **Cascading:** None. The three theorems have no other call sites in the
  project (verified by grep; only the declaration lines and the blueprint
  `\lean{...}` hints reference them).

## New Sorries Introduced
None. The three theorems were already `sorry`-bodied; only their statements
above the `sorry` changed.

- `AlgebraicJacobian/Differentials.lean:823` — `smooth_iff_locally_free_omega`
  (pre-existing, signature now corrected).
- `AlgebraicJacobian/Differentials.lean:840` — `cotangent_at_section`
  (pre-existing, signature now corrected).
- `AlgebraicJacobian/Differentials.lean:982` — `serre_duality_genus`
  (pre-existing, signature now corrected).

## Compilation Status

- `AlgebraicJacobian/Differentials.lean`: compiles. `lean_diagnostic_messages`
  with `severity=error` returns `[]`.
- File-level warnings now present at lines 818 and 835: deprecation warning
  for `AlgebraicGeometry.IsSmoothOfRelativeDimension`. See Notes below.
- No other files were touched; no downstream rebuild was triggered.

## Verification Steps Executed

1. `lean_diagnostic_messages` (errors) on `AlgebraicJacobian/Differentials.lean`
   → `[]`. ✅
2. Sorry count in `AlgebraicJacobian/Differentials.lean`: 5 actual proof-body
   sorries at lines 177, 741, 823, 840, 982 (matches directive expectation). ✅
3. Project-wide sorry count across `AlgebraicJacobian/**/*.lean`: 16 actual
   proof-body sorries (matches directive expectation):
   - `Picard/Functor.lean`: 1 (L181)
   - `Picard/LineBundle.lean`: 2 (L86, L98)
   - `Differentials.lean`: 5 (L177, L741, L823, L840, L982)
   - `Cohomology/BasicOpenCech.lean`: 6 (L1120, L1212, L1536, L1564, L1754, L1846)
   - `Modules/Monoidal.lean`: 1 (L173)
   - `Jacobian.lean`: 1 (L179)
4. `grep` for the three theorem names across `AlgebraicJacobian/`: only the
   three declaration lines (816, 832, 976) match. Blueprint references at
   `blueprint/src/chapters/Differentials.tex` are `\lean{...}` hints in the
   `% NOTE:`-tagged blocks (still load-bearing for the plan agent's next
   blueprint-cleanup round; intentionally not touched by this refactor). ✅

Note: `.claude/tools/sorry_analyzer.py` does not exist in this checkout, so I
used `Grep` with the pattern `^\s*sorry\s*$` to count proof-body sorries
deterministically.

## Notes for Plan Agent

1. **Deprecation warning.** `AlgebraicGeometry.IsSmoothOfRelativeDimension` is
   `@[deprecated]` in the pinned Mathlib (b80f227-era): the replacement is
   `AlgebraicGeometry.SmoothOfRelativeDimension` (same signature
   `ℕ → {X Y : Scheme} → (X ⟶ Y) → Prop`). The directive explicitly
   instructed `IsSmoothOfRelativeDimension`, so I used that exact name and
   accepted two new deprecation warnings on lines 818 and 835. If you want
   warning-clean output, please dispatch a one-line follow-up refactor to
   swap `IsSmoothOfRelativeDimension` → `SmoothOfRelativeDimension` (purely
   mechanical, two sites, both already in `Differentials.lean`).

2. **Blueprint `% NOTE:` annotations untouched.** Per the directive, the
   three `% NOTE:` blocks in `blueprint/src/chapters/Differentials.tex` are
   not edited here. They now describe a resolved issue; cleanup is the plan
   agent's blueprint-writer task next iteration.

3. **`IsGeometricallyIntegral` / dimension-1 hypothesis.** Both intentionally
   omitted per the directive's mathematical-justification section. Future
   work (when Mathlib infrastructure or a concrete proof attempt motivates
   it) can tighten the `serre_duality_genus` hypotheses, but neither is
   needed for the signature-correctness goal of this refactor.

4. **No downstream consumers.** The three corrected theorems are still
   sorry-bodied and have no in-project call sites, so no cascading fixes
   were needed and no new sorries were introduced.

5. **Mathematical justification quality.** The directive's mathematical
   reasoning was sufficient and unambiguous for executing the three edits
   without further investigation. The verification of
   `AlgebraicGeometry.IsSmoothOfRelativeDimension` via the live LSP is the
   only follow-up I did, which surfaced the deprecation noted in (1).
