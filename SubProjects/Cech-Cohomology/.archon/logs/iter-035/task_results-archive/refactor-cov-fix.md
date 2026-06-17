# Refactor Report

## Slug
cov-fix

## Status
COMPLETE

## Directive

### Problem
`affineCoverSystem.Cov` was the set of ALL finite basic-open families WITHOUT the covering condition
`⨆ᵢ D(gᵢ) = D(f)`. This made `HasVanishingHigherCech (affineCoverSystem R) F` demand Čech vanishing
over non-covering families, which is FALSE for quasi-coherent sheaves. The downstream seed
`affine_cech_vanishing_qcoh` was therefore unprovable.

### Changes Requested
File: `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean`

**Edit 1** — Re-sign `affine_surj_of_vanishing.hvanish` to quantify only over covering families
  (add `f' : R` parameter and covering-witness premise).

**Edit 2** — Fix the call site inside the proof body of `affine_surj_of_vanishing` to supply the
  covering witness.

**Edit 3** — Tighten `affineCoverSystem.Cov` to include the covering condition `D(f) = ⨆ D(gᵢ)`,
  and update `rintro` patterns in the three field proofs accordingly.

## Changes Made

### File: `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean`

**Edit 1 — `affine_surj_of_vanishing` signature (line 228)**
- Changed `hvanish` from `∀ (n : ℕ) (g : Fin n → R) (q : ℕ), 0 < q → IsZero …`
  to `∀ (n : ℕ) (g : Fin n → R) (f' : R), D(f') = ⨆ i, D(gᵢ) → ∀ (q : ℕ), 0 < q → IsZero …`
- Applied verbatim per directive.

**Edit 2 — call site inside `affine_surj_of_vanishing` proof (line 320–323)**
- Added `hcovf` derivation. Instead of the directive's `rw [← hV₀, ← hUsup]` approach
  (which left a `simp only [hU]` residual `a = a` that `simp only` didn't close automatically),
  used the mirror of how `hUsup` is proved internally:
  ```lean
  have hcovf : (PrimeSpectrum.basicOpen f : (Spec R).Opens)
      = ⨆ i : ULift.{u} (Fin n), PrimeSpectrum.basicOpen (g i.down) := by
    rw [hVeq]
    exact (Equiv.ulift.{u}.iSup_comp (g := fun i => PrimeSpectrum.basicOpen (g i))).symm
  ```
  This uses `hVeq : PrimeSpectrum.basicOpen f = ⨆ i, PrimeSpectrum.basicOpen (g i)` (already in
  scope) and `Equiv.ulift.iSup_comp` (the same lemma used to prove `hUsup`).
- Updated the call: `hvanish n g f hcovf 1 one_pos`.

**Edit 3 — `affineCoverSystem.Cov` and field `rintro` patterns (lines 369–386)**
- Changed `Cov` set comprehension to include `∧ D(f) = ⨆ i, D(gᵢ)` conjunct.
- Updated all three field destructuring patterns from `⟨n, g, rfl⟩` to `⟨n, g, f, rfl, hcov⟩`.
- Updated `surj_of_vanishing` lambda and membership witness to thread `f'` and `hcov` through.

## New Sorries Introduced
None.

## Compilation Status
- `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean`: EXIT 0, diagnostics empty.
- `#print axioms AlgebraicGeometry.affineCoverSystem`: `{propext, Classical.choice, Quot.sound}`
- `#print axioms AlgebraicGeometry.affine_surj_of_vanishing`: `{propext, Classical.choice, Quot.sound}`

## Notes for Plan Agent

### Divergence from directive (minor, Edit 2 plumbing)
The directive suggested `rw [← hV₀, ← hUsup]` (and `rw [hU]` / `simp only [hU]` to patch a
possible mismatch). In practice, `simp only [← hV₀, ← hUsup, hU]` reduced the goal to
`a = a` but `simp only` did not close it, and `rw [← hV₀, ← hUsup, hU]; rfl` was not tested.
Instead, an equivalent but cleaner proof was used that exactly mirrors the existing `hUsup` proof
using `Equiv.ulift.iSup_comp`. The mathematical content is identical.

### Downstream status
No other files import `AffineSerreVanishing.lean`'s `affineCoverSystem` definition directly with
a `Cov`-pattern match; the only consumers are the three field proof bodies within the same
`where` block, all of which have been updated. No cascading breakage.

### What this unblocks
`affineCoverSystem.Cov` now only contains genuinely covering families, so
`HasVanishingHigherCech (affineCoverSystem R) F` is a correct statement. The qcoh seed
`affine_cech_vanishing_qcoh` (pending Lane 2 `qcoh_iso_tilde_sections`) can now be stated and
proved correctly once 01I8 closes.
