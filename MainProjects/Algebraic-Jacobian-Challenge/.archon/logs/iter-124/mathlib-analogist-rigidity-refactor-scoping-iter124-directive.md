# Mathlib Analogist Directive

## Slug
rigidity-refactor-scoping-iter124

## Context

The project's `AlgebraicJacobian/Rigidity.lean` contains the closed
theorem `GrpObj.eq_of_eqOnOpen` (Mumford-rigidity for morphisms of
group schemes, in scheme-level form). The current signature is:

```lean
theorem GrpObj.eq_of_eqOnOpen
    {n m : ℕ}
    {X Y : Over (Spec (.of k))}
    [SmoothOfRelativeDimension n X.hom] [IsProper X.hom]
    [GeometricallyIrreducible X.hom] [GrpObj X]
    [SmoothOfRelativeDimension m Y.hom] [IsProper Y.hom]
    [GeometricallyIrreducible Y.hom] [GrpObj Y]
    [IsReduced X.left]
    (g₁ g₂ : X ⟶ Y) (U : X.left.Opens) (hU : (U : Set X.left).Nonempty)
    (h : (U.ι : (U : X.left.Opens).toScheme ⟶ X.left) ≫ g₁.left =
      (U.ι : (U : X.left.Opens).toScheme ⟶ X.left) ≫ g₂.left) :
    g₁ = g₂
```

The file's own comments (L62–68) acknowledge that the
`[GrpObj X]`, `[SmoothOfRelativeDimension n X.hom]`,
`[IsProper X.hom]`, `[GeometricallyIrreducible X.hom]` hypotheses
on the source `X` are unused in the actual proof (the body uses
only `IsReduced X.left`, `GeometricallyIrreducible X.hom` for
`IrreducibleSpace`, and the symmetric-form prereqs on the target).
They are kept "for forward-compatibility with the informal Mumford
statement".

## The refactor target

For STRATEGY.md milestone **M2.a** ("Rigidity for `ℙ¹_{k̄} → A_{k̄}`:
any morphism from `ℙ¹_{k̄}` to a smooth proper geometrically
irreducible group scheme `A_{k̄}` over `k̄` that hits the identity
at a `k̄`-rational point is constant"), the SOURCE will be
`ℙ¹_{k̄}` which is smooth, proper, geometrically irreducible, but
NOT a group object.

The current signature blocks this application via the `[GrpObj X]`
hypothesis. Even though the proof body does not use it, the
typeclass cannot be synthesised for `X = ℙ¹_{k̄}`.

The refactor is therefore: **drop the unused source-side hypotheses
(`[GrpObj X]`, and possibly the smoothness / properness / geometric
irreducibility hypotheses too if they are also unused) so that the
declaration applies to a non-group source.**

The mathematician's protected-declarations file
(`archon-protected.yaml`) does NOT list `GrpObj.eq_of_eqOnOpen`, so
the signature is editable.

## Your task

You are the mathlib-analogist. Scope the refactor:

1. **Confirm which hypotheses are TRULY unused** by re-reading the
   proof body (Rigidity.lean:90–114) and locating every typeclass
   instance call. List each hypothesis as "USED via X" or "UNUSED".
2. **Identify Mathlib's canonical form** for an "ext_of_isDominant_of_isSeparated"
   theorem (or analogous). The current proof uses
   `ext_of_isDominant_of_isSeparated'` — is this the canonical
   Mathlib form, or should the refactor instead delegate to a more
   general Mathlib lemma?
3. **Recommend the minimal refactored signature**. Specifically:
   which hypotheses to drop, which to keep, whether the namespace
   should change (`GrpObj.eq_of_eqOnOpen` → `Scheme.eq_of_eqOnOpen`
   or `Scheme.Over.eq_of_eqOnOpen` or similar), and what the
   downstream impact at the M2.a application site looks like.
4. **Identify Mathlib downstream impact**. If the refactor lands a
   more general form, is the more-general form itself a Mathlib
   contribution candidate? List Mathlib name candidates in the
   `Mathlib.AlgebraicGeometry.*` namespace.
5. **Estimate the refactor's LOC + iter cost**:
   - Signature change in `Rigidity.lean`.
   - Re-prove (or trivially adapt) any project consumers of the
     theorem. Use `lean_local_search` /
     `lean_references` if needed to locate consumers.
   - Note: the current iter-124 sorry inventory has 2 sorries
     (`Differentials.lean:362`, `Jacobian.lean:179`); the refactor
     should not introduce new sorries.

## Background reading

- `AlgebraicJacobian/Rigidity.lean` (the file under review,
  117 lines).
- `blueprint/src/chapters/Rigidity.tex` (the corresponding
  blueprint chapter — read for the math context).
- `blueprint/src/chapters/Jacobian.tex` § C.2.a–g (where M2.a is
  described — read to confirm the application shape).
- `STRATEGY.md` § M2.a (the strategy-level description, ~2–3
  lines).

## Output

Write your report to `.archon/task_results/mathlib-analogist-rigidity-refactor-scoping-iter124.md`.

Format per the mathlib-analogist descriptor's standard:

- Verdict per cluster: **ALIGN_WITH_MATHLIB** /
  **PROCEED_WITH_WORKAROUND** / **NEEDS_MATHLIB_GAP_FILL** /
  **PROCEED** (with justification).
- The recommended refactored signature (precise Lean
  syntax).
- Mathlib downstream-contribution candidate name(s).
- LOC + iter cost estimate for the iter-125 refactor execution.
- Persistent file: append findings to
  `analogies/rigidity-refactor.md` (create if absent) for future
  iter reference.

## Out of scope

- Do NOT execute the refactor — that is iter-125's work
  (separate refactor subagent dispatch).
- Do NOT touch `Differentials.lean` (iter-124 prover lane active
  there).
- Do NOT propose any axiom or new project-level definition outside
  the Rigidity-refactor scope; the rigidity declaration is a
  single-lemma refactor.
