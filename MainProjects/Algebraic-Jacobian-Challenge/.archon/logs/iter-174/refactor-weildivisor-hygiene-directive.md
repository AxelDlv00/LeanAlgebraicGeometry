# Refactor Directive

## Slug
weildivisor-hygiene

## Problem

Three hygiene findings from `lean-auditor iter173` (must-fix-this-iter category):

1. **`AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:70-77`** — section docstring references the **old** field name `isCodim1AndIntegral` and predicts a refinement that has already landed (`coheight`, different content). Outdated comment, actively misleads readers.

2. **`AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:207`** — `noncomputable def degree_hom : X.WeilDivisor →+ ℤ := ...` carries a redundant `noncomputable` modifier. The body `Finsupp.liftAddHom (fun _ ↦ AddMonoidHom.id ℤ)` is computable.

3. **`AlgebraicJacobian/Genus0BaseObjects.lean:237`** — uncommon spelling `push Not at h` instead of `push_neg at h`.

## Mathematical Justification

All three are surface-level hygiene only. No mathematical content changes. Item 1 corrects misleading prose; item 2 removes a misleading kernel-marker; item 3 normalises a tactic spelling.

The refactor must NOT touch:
- The `Scheme.PrimeDivisor` structure body (already corrected iter-173).
- The `degree_hom` body (`Finsupp.liftAddHom (fun _ ↦ AddMonoidHom.id ℤ)`).
- Any `\lean{...}`-pinned declaration's signature.
- Any other declaration in either file.

## Changes Requested

### Change 1: WeilDivisor.lean docstring repair

- **File**: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- **Lines**: 70-77 (the chapter-section comment block above `Scheme.PrimeDivisor`)
- **Action**: rewrite the comment to:
  - DROP any reference to "isCodim1AndIntegral" / `True := trivial` placeholder / iter-173 refinement plan.
  - ADD a clean description of `Scheme.PrimeDivisor` as it now exists: two fields, `point : X` (data) and `coheight : Order.coheight point = 1` (predicate).
  - Cite Hartshorne II.6 and the blueprint pin `def:prime_divisor`.
  - Keep the comment short (≤ 8 lines).

### Change 2: WeilDivisor.lean `noncomputable` removal

- **File**: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- **Line**: 207
- **Action**: drop the `noncomputable` keyword on `def degree_hom`.

Verify after edit that `lake build AlgebraicJacobian.RiemannRoch.WeilDivisor` still succeeds.

### Change 3: Genus0BaseObjects.lean tactic-spelling normalisation

- **File**: `AlgebraicJacobian/Genus0BaseObjects.lean`
- **Line**: 237
- **Action**: change `push Not at h` to `push_neg at h`.

Verify after edit that `lake build AlgebraicJacobian.Genus0BaseObjects` still succeeds.

## Affected Files

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (changes 1 + 2)
- `AlgebraicJacobian/Genus0BaseObjects.lean` (change 3)

No other files should need changes.

## Expected Outcome

- Sorry count UNCHANGED: 5 on WeilDivisor.lean, 8 on Genus0BaseObjects.lean.
- `lake build AlgebraicJacobian` exits 0.
- iter-172/173 lean-auditor must-fix items (outdated docstring + redundant `noncomputable` + uncommon tactic spelling) are all resolved.
- No new declarations, no signature changes, no body changes beyond the three named edits.
