# Refactor Directive

## Slug
docstring-fix-iter123

## Problem

The docstring of `AlgebraicGeometry.Scheme.smooth_locally_free_omega`
at `AlgebraicJacobian/Differentials.lean:430-454` is stale. It claims
the bridge between the algebra-Kähler form and the presheaf form "is
a Mathlib gap" requiring "presheaf-level cofinality machinery (~200–400
LOC) that is **out of autonomous-loop scope**."

This was true entering iter-121 but is now false:
- Iter-122 introduced
  `AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_equiv_kaehler_appLE`
  (in the same file, at `Differentials.lean:369`) which IS the bridge,
  formalized as a `LinearEquiv`.
- The body is closed *modulo* `appLE_isLocalization` (M1.b), which has
  Step 0 closed (iter-122) and Steps 1-4 actively being worked iter-123.
- The iter-121 user pivot directive explicitly invites Mathlib-
  contribution work; the bridge is on the active roadmap (milestone M1
  per STRATEGY.md), not "out of autonomous-loop scope."

Future readers of the file (including the next iter's prover) would be
misled by the stale "out of scope" claim.

## Mathematical justification

Pure docstring hygiene. No type-level changes; no proof body touched;
no protected signature touched. The theorem statement and proof body
are unchanged; only the docstring prose is rewritten.

## Changes requested

In `AlgebraicJacobian/Differentials.lean`, the docstring block at
lines 430-454 (the comment block for `smooth_locally_free_omega`)
currently reads (verbatim):

```
/-- Forward direction of the Jacobian criterion (algebra-Kähler form).
If `f : X → S` is smooth of relative dimension `n`, then for every
point `x ∈ X` there exist affine opens `U ⊆ S` and `V ⊆ X` with
`f V ⊆ U` and `x ∈ V`, on which the Kähler differential module
`Ω[Γ(X, V) ⁄ Γ(S, U)]` (over the appLE algebra structure) is a free
module of rank `n` over `Γ(X, V)`.

The bridge from this algebra-Kähler form to the project's presheaf
form `(relativeDifferentialsPresheaf f).presheaf.obj (.op V)` is a
Mathlib gap: the section module of the presheaf identifies with the
Kähler module over the inverse-image-presheaf colimit ring
`colim_{f V ⊆ W ⊆ S} Γ(S, W)`, which is a localization of `Γ(S, U)`
and hence yields an iso `Ω[Γ(X, V) ⁄ Γ(S, U)] ≃ Ω[Γ(X, V) ⁄ A_colim]`
via `KaehlerDifferential.isLocalizedModule_map`; constructing the iso
requires presheaf-level cofinality machinery (~200–400 LOC) that is
out of autonomous-loop scope. See `blueprint/src/chapters/Differentials.tex`
§ "Bridge to the relative cotangent presheaf — out of autonomous-loop
scope" for the mathematical content.

The reverse direction (locally free Ω of rank `n` implies smooth of
relative dimension `n`) is **mathematically false** as stated without
additional deformation-theoretic input (vanishing of
`Algebra.H1Cotangent A B` on each chart); see the chapter
`Differentials.tex` for the counterexample (`Spec k → Spec k[t]`,
`t ↦ 0`) and the converse-direction disclosure. -/
```

Replace the entire block with:

```
/-- Forward direction of the Jacobian criterion (algebra-Kähler form).
If `f : X → S` is smooth of relative dimension `n`, then for every
point `x ∈ X` there exist affine opens `U ⊆ S` and `V ⊆ X` with
`f V ⊆ U` and `x ∈ V`, on which the Kähler differential module
`Ω[Γ(X, V) ⁄ Γ(S, U)]` (over the appLE algebra structure) is a free
module of rank `n` over `Γ(X, V)`.

The bridge from this algebra-Kähler form to the project's presheaf
form `(relativeDifferentialsPresheaf f).presheaf.obj (.op V)` is
formalized as `relativeDifferentialsPresheaf_equiv_kaehler_appLE`
(later in this file), a canonical `Γ(X, V)`-linear equivalence between
the presheaf section module and the appLE-algebra Kähler module. Its
construction is milestone M1 of the project roadmap (see
`STRATEGY.md` and `blueprint/src/chapters/Differentials.tex § sec:bridge`):
the section module identifies with the Kähler module over the inverse-
image-presheaf colimit ring `A_colim = colim_{f V ⊆ W ⊆ S} Γ(S, W)`,
which is a localization of `Γ(S, U)` at the submonoid
`appLE_unitSubmonoid` (Lemma `appLE_isLocalization`, M1.b — the
remaining open work item); the equivalence then follows from
`KaehlerDifferential` tower cancellation (Lemma
`kaehler_quotient_localization_iso`, M1.d, fully proved).

The reverse direction (locally free Ω of rank `n` implies smooth of
relative dimension `n`) is **mathematically false** as stated without
additional deformation-theoretic input (vanishing of
`Algebra.H1Cotangent A B` on each chart); see the chapter
`Differentials.tex` for the counterexample (`Spec k → Spec k[t]`,
`t ↦ 0`) and the converse-direction disclosure. -/
```

## Affected files

`AlgebraicJacobian/Differentials.lean` only. No cascading changes
(this is a pure docstring edit; no Lean term, signature, or import
changes).

## Expected outcome

- `lake env lean AlgebraicJacobian/Differentials.lean` returns the same
  warnings/errors as before (only the documented `sorry` at L304).
- Sorry count unchanged (1 sorry at L304).
- No protected signature touched.

## Out of scope

- Do NOT touch the theorem signature or proof body of
  `smooth_locally_free_omega`.
- Do NOT touch any other declaration in the file.
- Do NOT touch the blueprint chapter.
