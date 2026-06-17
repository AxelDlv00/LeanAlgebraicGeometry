# Refactor Report

## Slug
differentials-iter118

## Status
COMPLETE

## Directive

### Problem
`AlgebraicGeometry.Scheme.smooth_iff_locally_free_omega` in
`AlgebraicJacobian/Differentials.lean` L74–81 stated a biconditional
that is mathematically false in its converse direction. Local
freeness of `Ω_{X/S}` of rank `n` does not imply
`SmoothOfRelativeDimension n f` without additional
deformation-theoretic input (vanishing of
`Algebra.H1Cotangent A B` on each affine chart). Counterexample:
`f : Spec k → Spec k[t]` induced by `k[t] ↠ k`, `t ↦ 0` has
`Ω_{k/k[t]} = 0` (free of rank 0) but is not flat, hence not smooth.

### Changes Requested
- Replace the iff theorem with a forward implication, renamed
  `smooth_locally_free_omega` (no `_iff_` infix).
- Drop the `LocallyOfFinitePresentation` hypothesis (subsumed by
  smoothness in the forward direction).
- Use `SmoothOfRelativeDimension` (current Mathlib class) as a
  typeclass-binder `[SmoothOfRelativeDimension n f]`, dropping the
  deprecated `IsSmoothOfRelativeDimension` alias.
- Make `n` implicit (brace-bound), inferred from the typeclass.
- Body remains `sorry` for prover lane to fill.

## Changes Made

### File: `AlgebraicJacobian/Differentials.lean`
- **What:** Replaced the false-as-stated biconditional theorem
  `smooth_iff_locally_free_omega` (L74–81) with the
  forward-only implication `smooth_locally_free_omega`. New
  signature uses the typeclass binder
  `[SmoothOfRelativeDimension n f]` with implicit `{n : ℕ}`. The
  `LocallyOfFinitePresentation` hypothesis was dropped (subsumed
  by smoothness in the forward direction). The docstring was
  rewritten to document the proof route
  (`smoothOfRelativeDimension_iff` →
  `IsStandardSmoothOfRelativeDimension.isStandardSmooth` →
  `IsStandardSmooth.free_kaehlerDifferential` +
  `IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
  → `relativeDifferentialsPresheaf_obj_kaehler`) and to call out
  the converse-direction disclosure pointing to
  `blueprint/src/chapters/Differentials.tex`. Body remains `sorry`.
- **Why:** The biconditional was mathematically false (see
  Problem section). The Mathlib converse lemma
  `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential`
  requires `Subsingleton (Algebra.H1Cotangent A B)` plus
  `FinitePresentation` plus a basis-from-derivations hypothesis;
  none of these follow from local freeness of `Ω` alone.
- **Cascading:** None — `grep -rn smooth_iff_locally_free_omega
  --include="*.lean"` finds no consumers in the active source
  tree (matches in `.archon/logs/iter-081/snapshots/` are
  historical artefacts that the compiler does not consult). The
  umbrella `AlgebraicJacobian.lean` only re-imports the module
  and needs no edits. The blueprint chapter
  `blueprint/src/chapters/Differentials.tex` already references
  the new name `smooth_locally_free_omega` (L50), so no blueprint
  edit was needed (and would be out of scope for the refactor
  agent anyway).

### File: `archon-protected.yaml`
No edits. The renamed declaration was never listed there.

## New Sorries Introduced
- `AlgebraicJacobian/Differentials.lean:93` — `sorry` body of
  `smooth_locally_free_omega`. This is the same `sorry` that
  previously closed `smooth_iff_locally_free_omega:81`; it has
  simply moved with the renamed declaration. Net project sorry
  count is unchanged (2 total: Differentials.lean and
  Jacobian.lean).

## Compilation Status
- `AlgebraicJacobian/Differentials.lean`: compiles. Only
  diagnostic is the expected `declaration uses sorry` warning
  on L87 (the `theorem` keyword line; the `sorry` body itself is
  on L93).
- `lake build AlgebraicJacobian.Differentials`: success, 2820
  jobs replayed, one warning (the sorry).

## Notes for Plan Agent

- The directive was unambiguous and self-contained; no
  improvisation was needed. The mathematical justification was
  sufficient and the proof route specified in the new docstring
  matches what the prover lane will need.
- The new sorry on `smooth_locally_free_omega` is now
  mathematically tractable from Mathlib's standard-smooth /
  Kähler differential infrastructure
  (`Mathlib.RingTheory.Smooth.StandardSmoothCotangent`) plus the
  project-local `relativeDifferentialsPresheaf_obj_kaehler`.
  Recommend a prover lane in iter-119 to close it.
- The deprecated-alias warning on
  `IsSmoothOfRelativeDimension` is no longer emitted: Mathlib's
  `@[deprecated (since := "2026-02-09")] alias
  IsSmoothOfRelativeDimension := SmoothOfRelativeDimension`
  (Mathlib.AlgebraicGeometry.Morphisms.Smooth L140) confirms the
  alias is current-deprecated, and the new signature uses the
  un-aliased class directly.
- Blueprint chapter `Differentials.tex` is already aligned with
  the new name and forward-only shape (L48–57 + Section
  `\sec{Converse direction — out of autonomous-loop scope}`).
  No blueprint cleanup required as part of this refactor.
