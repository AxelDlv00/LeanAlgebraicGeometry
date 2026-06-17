# Refactor Report

## Slug
thread-affinecover

## Status
COMPLETE

## Directive

**Problem:** `CechToHigherDirectImage.lean` did not compile because `cech_computes_higherDirectImage_of_affineCover` called `cechTerm_pushforward_acyclic` with the wrong argument list — missing `[S.IsSeparated]` (now required by the producer) and the explicit `hres` hypothesis.

**Changes Requested:**
- Add `[S.IsSeparated]` and `hres` parameter to the theorem signature.
- Pass `(hres n)` at the producer call site.
- (Cosmetic) Update docstring to mention the new hypotheses.

## Changes Made

### File: `AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean`

- **What (Change 1):** Added `[S.IsSeparated]` to the instance binders and added explicit parameter
  ```
  (hres : ∀ (n : ℕ) (σ : Fin (n + 1) → 𝒰.I₀),
    HasInjectiveResolutions (Scheme.Opens.toScheme (coverInterOpen 𝒰 σ)).Modules)
  ```
  to `cech_computes_higherDirectImage_of_affineCover` (lines 198–204).
- **Why:** The producer `cechTerm_pushforward_acyclic` requires both.
- **Cascading:** None — no other file calls this theorem.

- **What (Change 2):** Updated the producer call at line 210 from
  `fun n => cechTerm_pushforward_acyclic f 𝒰 h𝒰 F hF n`
  to
  `fun n => cechTerm_pushforward_acyclic f 𝒰 h𝒰 F hF n (hres n)`.
- **Why:** Supplies the now-explicit `hres` argument at each degree `n`.
- **Cascading:** None.

- **What (Change 3, cosmetic):** Updated the docstring (lines 188–190) to mention `[S.IsSeparated]` and `hres`.
- **Why:** Docstring now matches the actual signature.

## New Sorries Introduced
None.

## Compilation Status
- `AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean`: **compiles** — LSP reports 0 errors, 0 sorries (only a style lint info about long lines).

## Notes for Plan Agent
- The `[S.IsSeparated]` and `[X.IsSeparated]` instances at the call site resolve by instance search from the theorem's hypotheses; no explicit forwarding needed.
- The `hres` binder type used in the consumer (`∀ (n : ℕ) (σ : Fin (n + 1) → 𝒰.I₀), ...`) matches the producer's binder modulo alpha-renaming (`p` → `n`), which Lean elaborates identically.
- No downstream callers of `cech_computes_higherDirectImage_of_affineCover` exist (confirmed by the directive); no cascading breakage.
- The protected declaration `cech_computes_higherDirectImage` in `CechHigherDirectImage.lean` was not touched.
