# Refactor Report

## Slug
rigidity-pivot-iter125

## Status
COMPLETE — the closed declaration `AlgebraicGeometry.GrpObj.eq_of_eqOnOpen`
has been renamed to `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen` with
its 8 unused source-side hypotheses dropped and its target-side
`[IsProper Y.hom]` weakened to `[IsSeparated Y.hom]`. The proof body
required only the directive's `‹IsSeparated Y.hom›` substitution in
place of `IsProper.toIsSeparated`; everything else is verbatim.
`AlgebraicJacobian/Rigidity.lean` compiles cleanly with zero
diagnostics; axioms are the kernel set `propext, Classical.choice,
Quot.sound` only; no new sorries introduced.

## Directive

### Problem (from directive)

The closed declaration `AlgebraicGeometry.GrpObj.eq_of_eqOnOpen` at
`AlgebraicJacobian/Rigidity.lean:79–114` carried 8 source-side
hypotheses unused by the proof body, plus a target-side `[IsProper
Y.hom]` stronger than the body needs (the proof only consumes its
`IsSeparated`-projection). The unused decorations blocked the M2.a
(iter-126) application site where `X := ℙ¹_{k̄}` is not a `GrpObj`.

### Changes Requested (from directive)

1. Rename `GrpObj.eq_of_eqOnOpen` → `Scheme.Over.ext_of_eqOnOpen`
   inside the existing `namespace AlgebraicGeometry`. Drop the 8
   unused hypotheses; weaken `[IsProper Y.hom]` to `[IsSeparated
   Y.hom]`. Update the proof's first `haveI` to derive the
   bundled-form `IsSeparated (Y.left ↘ Spec (.of k))` from the
   anonymous-instance `‹IsSeparated Y.hom›` rather than from
   `IsProper.toIsSeparated`.
2. Rewrite the file-level docstring (L8–26) to reflect the
   scheme-level (no longer group-scheme-specific) framing while
   retaining the Mumford-§4 historical motivation.
3. Retitle the iter-003 hypothesis-correction comment block at
   L38–70: preserve the scheme-level hypothesis discussion (L38–60),
   replace the now-obsolete unused-hypothesis enumeration at L62–67
   with an iter-125 cleanup note.
4. No other Lean file references the symbol (`grep` verified 0
   consumers); blueprint updates are out-of-scope for refactor
   (handled by plan agent).

## Changes Made

### File: `AlgebraicJacobian/Rigidity.lean`

- **What:** Three coordinated edits delivered exactly as the
  directive specifies, no scope creep.

  1. **File-level docstring (L8–31)** — rewrote the header to lead
     with the scheme-level statement (matches the new signature):
     "Rigidity for morphisms of schemes (scheme-level form). … two
     morphisms `g₁, g₂ : X ⟶ Y` between schemes over `Spec k` whose
     restrictions to a non-empty open `U ⊆ X` agree as scheme
     morphisms — for `X` reduced and geometrically irreducible over
     `Spec k` and `Y` separated over `Spec k` — agree everywhere."
     The Mumford-§4 historical motivation is retained as a separate
     paragraph; the `Status` section now references the new
     declaration name and points to the renamed "Hypothesis history"
     block.

  2. **Hypothesis-history comment block (L43–79)** — retitled from
     "Hypothesis correction (iter 003 prover)" to "Hypothesis
     history". The iter-003 discussion (scheme-level hypothesis
     necessity via Frobenius example, `[IsReduced]` rationale) is
     preserved verbatim as the "Scheme-level hypothesis (iter 003)"
     subsection. The previously-obsolete unused-hypothesis
     enumeration (old L62–67) is replaced with a one-paragraph
     "Unused-hypothesis cleanup (iter 125)" subsection that lists
     the 8 dropped hypotheses + the `IsProper → IsSeparated`
     weakening + the rename, citing
     `analogies/rigidity-refactor.md` and Mathlib's
     `ext_of_isDominant_of_isSeparated'` for naming alignment.

  3. **Theorem signature + proof body (L81–121)** — renamed
     `GrpObj.eq_of_eqOnOpen` → `Scheme.Over.ext_of_eqOnOpen`
     (inside the existing `namespace AlgebraicGeometry`, so the
     fully-qualified name is
     `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen`). New
     signature carries only three typeclass hypotheses: `[IsSeparated
     Y.hom]`, `[GeometricallyIrreducible X.hom]`, `[IsReduced
     X.left]`. The 8 unused hypotheses (`{n m : ℕ}`,
     `[SmoothOfRelativeDimension n X.hom]`, `[IsProper X.hom]`,
     `[GrpObj X]`, `[SmoothOfRelativeDimension m Y.hom]`,
     `[GeometricallyIrreducible Y.hom]`, `[GrpObj Y]`) are dropped.
     Proof body identical to the iter-124 form except the first
     `haveI` now reads `(‹IsSeparated Y.hom› : IsSeparated Y.hom)`
     instead of `(IsProper.toIsSeparated : IsSeparated Y.hom)` —
     this is the only substantive proof-body change. The docstring
     above the theorem is rewritten to describe the
     minimal-hypothesis form while cross-referencing Mathlib's
     `ext_of_isDominant_of_isSeparated'`.

- **Why:** Aligns the declaration with Mathlib's
  minimal-hypothesis `ext_of_*` idiom and unblocks the iter-126
  M2.a application site `X = ℙ¹_{k̄}` (not a `GrpObj`). See
  `analogies/rigidity-refactor.md` for the full justification and
  the iter-124 mathlib-analogist consult.

- **Cascading:** None. The grep
  `Grep eq_of_eqOnOpen AlgebraicJacobian/*.lean` returns only
  occurrences inside `Rigidity.lean` itself (the declaration plus
  one cross-reference in its own docstring), confirming zero Lean
  consumers. The umbrella `AlgebraicJacobian.lean` imports
  `Rigidity` by module, not by symbol, so no edit is needed there.
  Blueprint references in `Rigidity.tex` and `Jacobian.tex` are
  the plan agent's domain per the directive (the refactor agent
  must not edit blueprint chapters per
  `.archon/subagents/refactor.md` "What you MUST NOT do").

## New Sorries Introduced

- **None.** The proof body remained closed across the refactor.
  Total project sorry count remains **2** (unchanged):
  - `AlgebraicJacobian/Differentials.lean:398` — pre-existing
    iter-124 residual (`Function.Bijective` claim inside the
    `AlgEquiv.ofBijective forwardAlg sorry`).
  - `AlgebraicJacobian/Jacobian.lean:179` — pre-existing iter-124
    residual (`nonempty_jacobianWitness` Phase-C scaffolding).

## Compilation Status

- `AlgebraicJacobian/Rigidity.lean` — **compiles cleanly**.
  `lean_diagnostic_messages` returns `{"items":[]}` (no errors,
  warnings, or info diagnostics). Direct `lake env lean
  AlgebraicJacobian/Rigidity.lean` invocation returns silently with
  exit status 0.
- `AlgebraicJacobian/Differentials.lean`,
  `AlgebraicJacobian/Jacobian.lean` — unchanged; their pre-existing
  sorries are untouched.
- `AlgebraicJacobian.lean` (umbrella) — imports `Rigidity` by
  module path, no symbol reference, unchanged.
- Axiom check: `lean_verify
  AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen` reports axioms
  `["propext", "Classical.choice", "Quot.sound"]` only — exactly
  the kernel set, matching the directive's expected outcome.

## Notes for Plan Agent

1. **Blueprint references requiring plan-agent follow-up.** The
   following blueprint references to the old symbol name remain
   and are out-of-scope for the refactor agent per the directive:
   - `blueprint/src/chapters/Rigidity.tex:12` — `\label{thm:GrpObj_eq_of_eqOnOpen}`
     and the `\lean{AlgebraicGeometry.GrpObj.eq_of_eqOnOpen}`
     reference (typically near L13).
   - `blueprint/src/chapters/Jacobian.tex:248` —
     `\uses{def:IsAlbanese, def:genus, thm:GrpObj_eq_of_eqOnOpen}`.
   - `blueprint/src/chapters/Jacobian.tex:328` (C.2.b sub-step) —
     the "however, the group-object structure on $X$ is used in
     the proof of Theorem~\ref{thm:GrpObj_eq_of_eqOnOpen} only to
     form a difference morphism …" note is now obsolete; the
     refactored declaration applies directly without the
     group-object detour.
   - `blueprint/src/chapters/Jacobian.tex:358, 367` — additional
     `eq_of_eqOnOpen` cross-references found by grep.
   - `blueprint/web/chap-*.html` files — these are generated
     artifacts from a previous `leanblueprint` build; they will
     regenerate on the next blueprint build, no manual edit
     needed.

2. **`archon-protected.yaml`.** Inspected and confirmed: neither
   `GrpObj.eq_of_eqOnOpen` nor `Scheme.Over.ext_of_eqOnOpen`
   appears in the protected list, so no YAML edit is required (per
   the directive's "Expected Outcome" note). The protected
   declarations remain unchanged.

3. **Sufficiency of the mathematical justification.** The directive
   was extremely specific (full new-signature listing, full
   proof-body listing, exact comment-block retitle suggestion),
   leaving no judgement calls to the refactor agent. The
   `analogies/rigidity-refactor.md` audit was load-bearing for
   confirming the 8 hypotheses are genuinely unused and the
   `IsProper → IsSeparated` weakening is free at the M2.a caller.

4. **No additional changes recommended.** The refactor as specified
   is minimal and exact; no scope creep was tempting and none was
   undertaken. The next iter-126 M2.a prover can apply the new
   `Scheme.Over.ext_of_eqOnOpen` directly with `X := ℙ¹_{k̄}` once
   it has the source-side `[IsSeparated A_{k̄}.hom]`,
   `[GeometricallyIrreducible ℙ¹_{k̄}.hom]`, and `[IsReduced
   ℙ¹_{k̄}.left]` instances in context.

5. **Suggested follow-up (deferred, optional).** The
   `analogies/rigidity-refactor.md:221–246` "Mathlib contribution
   candidate" section sketches a `Scheme`-level corollary
   `AlgebraicGeometry.ext_of_eqOnNonemptyOpen` (~5 LOC, in
   `Mathlib.AlgebraicGeometry.Morphisms.Separated`) that
   generalizes away the `Over (Spec S)`-bundle. This is not a
   refactor-agent task; flagging it here so the plan agent can
   decide whether to pursue a Mathlib upstream PR in a later
   iteration.
