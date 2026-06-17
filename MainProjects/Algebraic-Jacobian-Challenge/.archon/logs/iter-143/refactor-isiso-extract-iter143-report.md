# Refactor Report

## Slug
isiso-extract-iter143

## Status
COMPLETE

## Directive

### Problem
`AlgebraicJacobian/Cotangent/GrpObj.lean:701–721` defined
`relativeDifferentialsPresheaf_basechange_along_proj_two` whose body
constructed the named iso via a `letI : IsIso (basechange_along_proj_two_inv G) :=
isIso_of_app_iso_module (basechange_along_proj_two_inv G) (fun _ => sorry)`
form. The inner `(fun _ => sorry)` argument produced a sorry-tainted
`IsIso` instance that was consumed by `(asIso _).symm`, silently
propagating the residual through downstream `simp`-rewrites and `apply`
chains. `lean-auditor-review142` flagged this as MAJOR and
`progress-critic-iter143` named extracting the residual into a named
sorry-bodied theorem as the primary CHURNING corrective.

### Changes
1. Insert new named theorem `basechange_along_proj_two_inv_app_isIso`
   between `basechange_along_proj_two_inv` and
   `relativeDifferentialsPresheaf_basechange_along_proj_two`,
   carrying the per-open IsIso obligation as a sorry-bodied theorem
   (audit-visible).
2. Modify the body of `relativeDifferentialsPresheaf_basechange_along_proj_two`
   to call the new named theorem in place of `(fun _ => sorry)`.

## Changes Made

### File: `AlgebraicJacobian/Cotangent/GrpObj.lean`

- **What (Change 1)**: Inserted new theorem
  `basechange_along_proj_two_inv_app_isIso` at lines 700–725, with the
  docstring specified in the directive. Mathematical signature:
  `(G : Over (Spec (.of k))) [CategoryTheory.GrpObj G] {n : ℕ}
   [SmoothOfRelativeDimension n G.hom] [IsProper G.hom]
   [GeometricallyIrreducible G.hom] (X : (G ⊗ G).left.Opensᵒᵖ) :
   IsIso ((basechange_along_proj_two_inv G).app X)`. Body: `sorry`.
- **What (Change 2)**: Rewrote the body of
  `relativeDifferentialsPresheaf_basechange_along_proj_two` (now lines
  727–748) to replace the `(fun _ => sorry)` argument with a call to
  `basechange_along_proj_two_inv_app_isIso (n := n) G` and updated the
  surrounding comment block per the directive's iter-143 corrective
  wording.
- **Why**: Audit transparency — the IsIso residual becomes a visible
  named declaration sorry that `sorry_analyzer` + `lean_verify` both
  surface, narrowing the iter-143 prover lane to the d_app sub-sorry
  inside `basechange_along_proj_two_inv_derivation`. The IsIso
  obligation becomes an independently-scoped iter-144+ prover target on
  a clearly named obligation.
- **Cascading**: None. The new theorem is referenced only by the
  immediately-following consumer in the same file. A repo-wide grep
  confirms no other file references `basechange_along_proj_two_inv` or
  `relativeDifferentialsPresheaf_basechange_along_proj_two`.

## Divergences from the directive

Two minor signature corrections were required for the new theorem to
type-check; both preserve the directive's mathematical intent.

1. **Type of `X` corrected**. The directive specified
   `(X : G.left.Opensᵒᵖ)` for the new theorem's parameter, but
   `basechange_along_proj_two_inv G` has codomain
   `Scheme.relativeDifferentialsPresheaf (fst G G).left` (a presheaf
   over the opens of `(G ⊗ G).left`, *not* `G.left`). The Lean compiler
   correctly reported:
   `X has type G.left.Opensᵒᵖ but is expected to have type
    (Opens ↥(G ⊗ G).left)ᵒᵖ`.
   I changed the parameter type to `(X : (G ⊗ G).left.Opensᵒᵖ)`. This
   is the correct domain of `(basechange_along_proj_two_inv G).app`,
   and the directive's prose justification ("per-open shape ... bridge
   that de-bundles `IsIso f` into `∀ X, IsIso (f.app X)`") is
   structurally satisfied — the `∀ X` quantifier ranges over the
   correct opens.
2. **Implicit `n` passed explicitly at the call site**. With the new
   theorem's implicit `{n : ℕ}` taking part in
   `[SmoothOfRelativeDimension n G.hom]`, the bare call
   `basechange_along_proj_two_inv_app_isIso G` inside
   `relativeDifferentialsPresheaf_basechange_along_proj_two` left `n`
   as a metavariable for instance search (the typeclass-stuck error
   `SmoothOfRelativeDimension ?m G.hom`). The fix is a one-token
   `(n := n)` pass-through using the outer scope's `{n : ℕ}` binder.
   The directive's intended call shape is otherwise preserved.

## New Sorries Introduced

- `AlgebraicJacobian/Cotangent/GrpObj.lean:725` — body of new theorem
  `basechange_along_proj_two_inv_app_isIso` (the extracted IsIso
  residual; closure path = Route (b'2) items 2–4 per
  `analogies/isiso-basechange-along-proj-two-inv.md`, ~195–365 LOC).

## Sorries that moved (not new)

- The previously-embedded `(fun _ => sorry)` argument inside
  `relativeDifferentialsPresheaf_basechange_along_proj_two`'s `letI`
  body was removed; its mathematical content is now carried by the new
  named theorem's body sorry above.

## Compilation Status

- `AlgebraicJacobian/Cotangent/GrpObj.lean`: **compiles**.
  `lean_diagnostic_messages` reports `success: true` with 3
  `declaration uses sorry` warnings:
    - Line 573 (`basechange_along_proj_two_inv_derivation`, d_app sub-sorry — pre-existing, iter-143 prover lane target).
    - Line 719 (`basechange_along_proj_two_inv_app_isIso`, NEW — iter-144+ prover target).
    - Line 864 (`mulRight_globalises_cotangent`, Main body — pre-existing).

- `sorry_analyzer` on `AlgebraicJacobian/Cotangent/GrpObj.lean`: **3
  inline sorries** (same count as before refactor; the inline
  `(fun _ => sorry)` was migrated to the new named theorem's body):
    - Line 637 (in `basechange_along_proj_two_inv_derivation`, d_app).
    - Line 725 (in new `basechange_along_proj_two_inv_app_isIso`).
    - Line 875 (in `mulRight_globalises_cotangent`).

- Downstream compilation: no other `.lean` file references the
  modified declarations (repo-wide grep confirms
  `AlgebraicJacobian/Cotangent/GrpObj.lean` is the only file mentioning
  `basechange_along_proj_two_inv*` or
  `relativeDifferentialsPresheaf_basechange_along_proj_two`).

## Sorry-count accounting vs the directive

The directive's "Expected Outcome" anticipated **4 sorry-bodied
declarations** after refactor (was 3, +1 from the new theorem).
**Actual: 3 sorry-bodied declarations** after refactor (was 3, net 0).

The discrepancy: before the refactor, the consumer
`relativeDifferentialsPresheaf_basechange_along_proj_two` itself
contained a literal `sorry` token (inside the `letI`-embedded
`(fun _ => sorry)` argument), so Lean issued a `declaration uses
sorry` warning for it. After the refactor, that consumer no longer
contains a literal `sorry` token — it only *calls* a sorry-bodied
theorem — so the consumer's `declaration uses sorry` warning
disappears, offsetting the +1 from the new theorem.

This is the *better* outcome the refactor was after: the consumer is
now sorry-clean (modulo transitive dependence on the named theorem),
while the audit-visible residual lives in exactly one named place.
Inline-sorry count (the `sorry_analyzer` metric) is exactly preserved
at 3, matching the directive's primary count claim.

## Notes for Plan Agent

- The directive's `X : G.left.Opensᵒᵖ` parameter type was incorrect;
  the actual type required by `(basechange_along_proj_two_inv G).app`
  is `(G ⊗ G).left.Opensᵒᵖ`. The mathematical intent (per-open IsIso
  bridge via `isIso_of_app_iso_module`) is structurally unchanged,
  but the iter-144+ prover assignment for
  `basechange_along_proj_two_inv_app_isIso` should reference the
  *correct* opens shape — the `(G ⊗ G).left` opposite category, not
  `G.left`'s. The Route (b'2) decomposition recipe in
  `analogies/isiso-basechange-along-proj-two-inv.md` should be
  cross-checked for the same potential typo before assigning a prover.
- The directive's sorry-count prediction (4 sorry-bodied
  declarations after refactor) was off by one because it didn't
  account for the consumer becoming sorry-clean once the inline
  `(fun _ => sorry)` is removed. The actual outcome (3
  sorry-bodied declarations; 3 inline sorries; consumer
  sorry-clean) is strictly better than the directive's expectation
  and matches the refactor's audit-transparency goal.
- No protected-declaration signatures were touched. The new theorem
  is *not* listed in `archon-protected.yaml`; if the plan agent wants
  it protected (its signature is now a stable iter-144+ obligation
  boundary), that's a user-side update.
