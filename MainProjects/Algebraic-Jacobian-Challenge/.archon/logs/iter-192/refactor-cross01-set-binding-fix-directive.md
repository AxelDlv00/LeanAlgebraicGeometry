# Directive: refactor — Cross01Substrate.lean `set S := ...` regression fix

## Target file

`AlgebraicJacobian/Genus0BaseObjects/Cross01Substrate.lean`

## Background

Per iter-191 task results (Lane B-consumers), the source compile of
`Cross01Substrate.lean` fails at Mathlib b80f227 due to a regression
in `IsLocalization.Away` instance synthesis inside `set S := TensorProduct ...`
bindings used in **Substrate 2** `gmRing_tensor_homogeneousAway_isDomain`.
Downstream consumers (e.g. `projGm_isReduced` in
`Genus0BaseObjects/GmScaling.lean`) still work because the cached
`.olean` exists from a prior Mathlib state, but **if a future Mathlib
bump invalidates the cache, multiple downstream consumers break
silently**.

## Required edit

In `Cross01Substrate.lean`, locate the Substrate 2 proof body where
`set S := TensorProduct ...` is used. Replace each `set S := ... with hS`
binding with one of:

- **Option A (preferred)**: explicit `let`-bound + `letI` for the
  instance: `let S : TYPE := TensorProduct ...` followed by
  `letI : Algebra (...) S := inferInstanceAs (Algebra (...) (TensorProduct ...))`
  for any instance synthesis points that previously relied on `set`'s
  rewrite behaviour.

- **Option B**: an explicit type-ascribed `have` chain:
  `have S_def : (S : TYPE) = TensorProduct ... := rfl` after a
  `let S : TYPE := ...` binding.

The semantic invariant is unchanged: the resulting
`gmRing_tensor_homogeneousAway_isDomain` statement and signature
must be byte-identical to the current (cached) one.

## Verification

After the refactor:

1. Run `lake env lean AlgebraicJacobian/Genus0BaseObjects/Cross01Substrate.lean`
   — must exit 0 with no errors (the existing `\leanok`-clean state
   must be preserved).

2. Run `lake build AlgebraicJacobian.Genus0BaseObjects.Cross01Substrate`
   — must succeed.

3. Run `lake build AlgebraicJacobian` — must succeed (no regression
   on downstream consumers).

4. Verify with `lean_verify AlgebraicGeometry.gmRing_tensor_homogeneousAway_isDomain`
   that axioms remain kernel-only:
   `{propext, Classical.choice, Quot.sound}`.

## Out of scope

- Do NOT touch the public signature of `gmRing_tensor_homogeneousAway_isDomain`.
- Do NOT touch Substrate 1 (`IsClosedImmersion.lift_iff_range_subset`).
- Do NOT modify other `.lean` files.

## Report

Write to `task_results/refactor-cross01-set-binding-fix.md` with:
- Lines changed.
- The replacement pattern used (Option A vs Option B).
- Confirmation of `lake build` GREEN + axiom check.
- If the refactor cannot be done in this iter (genuinely structural
  blocker), report the precise Mathlib API conflict and PROPOSE the
  next-iter approach. Do NOT introduce new sorries — the refactor's
  invariant is no new sorries.
