# Refactor Directive

## Slug
rigidity-pivot-iter125

## Problem

The closed declaration `AlgebraicGeometry.GrpObj.eq_of_eqOnOpen` at
`AlgebraicJacobian/Rigidity.lean:79–114` carries 8 source-side
hypotheses that the proof body does not use, and a target-side
hypothesis `[IsProper Y.hom]` that is stronger than what the body
needs. The unused decorations block the M2.a (iter-126) application
site `X := ℙ¹_{k̄}`, `Y := A_{k̄}`, where `ℙ¹_{k̄}` is not a group
object (no `[GrpObj X]`) but otherwise satisfies the load-bearing
hypotheses cleanly.

The iter-124 `mathlib-analogist-rigidity-refactor-scoping-iter124`
consult (report:
`.archon/logs/iter-124/mathlib-analogist-rigidity-refactor-scoping-iter124-report.md`;
persistent rationale: `analogies/rigidity-refactor.md`) audited the
declaration line-by-line and identified exactly 3 load-bearing
hypotheses (`[GeometricallyIrreducible X.hom]`, `[IsReduced X.left]`,
and a separatedness witness on `Y.hom`). The refactor lands the
minimal-hypothesis form, mirroring Mathlib's
`ext_of_isDominant_of_isSeparated'` naming idiom
(`Mathlib.AlgebraicGeometry.Morphisms.Separated:319–322`).

## Mathematical Justification

The proof body at `Rigidity.lean:90–114` is a 4-step composition:

1. `IsSeparated.of_isProper` on `[IsProper Y.hom]` to derive
   `IsSeparated (Y.left ↘ Spec (CommRingCat.of k))`. The only use
   of `IsProper Y.hom` is its `IsSeparated`-projection, so the
   hypothesis can be weakened to `[IsSeparated Y.hom]` directly:
   any caller with `[IsProper Y.hom]` derives `[IsSeparated Y.hom]`
   for free via `IsProper.toIsSeparated`.
2. `GeometricallyIrreducible.irreducibleSpace_of_subsingleton X.hom`
   on `[GeometricallyIrreducible X.hom]` (plus the unique-point
   structure of `Spec k` over a field) to derive
   `IrreducibleSpace X.left`.
3. `Scheme.PartialMap.Opens.isDominant_ι (IsOpen.dense U.isOpen hU)`
   to derive `IsDominant U.ι` from the non-empty hypothesis on `U`.
4. `Over.OverMorphism.ext` + `ext_of_isDominant_of_isSeparated'`
   to land the conclusion `g₁ = g₂` from the scheme-level
   `U.ι ≫ g₁.left = U.ι ≫ g₂.left` hypothesis. This step uses
   `[IsReduced X.left]`.

The hypotheses dropped — `{n m : ℕ}`,
`[SmoothOfRelativeDimension n X.hom]`, `[IsProper X.hom]`,
`[GrpObj X]`, `[SmoothOfRelativeDimension m Y.hom]`,
`[GeometricallyIrreducible Y.hom]`, `[GrpObj Y]` — are unused by
each of the 4 steps (audit:
`analogies/rigidity-refactor.md:36–62`). The proof body needs no
edit beyond the rename: every tactic call is by name, not by
typeclass-search lookup, and the surviving hypotheses suffice
verbatim.

The Mathlib alignment audit (`analogies/rigidity-refactor.md:64–94`)
confirms that the refactored form mirrors Mathlib's idiom:
`ext_of_isDominant_of_isSeparated'` itself carries only its
load-bearing hypotheses (`[IsReduced X]`, `[IsSeparated (Y ↘ S)]`,
`[IsDominant ι]`), with caller-side specializations introducing
stronger hypotheses as needed. The project's `GrpObj.eq_of_eqOnOpen`
is an `Over (Spec (.of k))`-bundled specialization that should
mirror Mathlib's naming + minimal-hypothesis style; the bundle is
project-local.

## Changes Requested

### Change 1: rename + signature refactor in `AlgebraicJacobian/Rigidity.lean`

- **File**: `AlgebraicJacobian/Rigidity.lean`

- **Old declaration** (lines 79–114):

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
      g₁ = g₂ := by
    haveI : IsSeparated (Y.left ↘ Spec (CommRingCat.of k)) :=
      (IsProper.toIsSeparated : IsSeparated Y.hom)
    haveI : IrreducibleSpace X.left :=
      GeometricallyIrreducible.irreducibleSpace_of_subsingleton X.hom
    haveI : IsDominant (U.ι : (U : X.left.Opens).toScheme ⟶ X.left) :=
      Scheme.PartialMap.Opens.isDominant_ι (IsOpen.dense U.isOpen hU)
    refine Over.OverMorphism.ext ?_
    exact ext_of_isDominant_of_isSeparated' (S := Spec (.of k))
      (X := X.left) (Y := Y.left) (f := g₁.left) (g := g₂.left) U.ι h
  ```

- **New declaration**:

  ```lean
  theorem Scheme.Over.ext_of_eqOnOpen
      {X Y : Over (Spec (.of k))}
      [IsSeparated Y.hom]
      [GeometricallyIrreducible X.hom]
      [IsReduced X.left]
      (g₁ g₂ : X ⟶ Y) (U : X.left.Opens) (hU : (U : Set X.left).Nonempty)
      (h : (U.ι : (U : X.left.Opens).toScheme ⟶ X.left) ≫ g₁.left =
        (U.ι : (U : X.left.Opens).toScheme ⟶ X.left) ≫ g₂.left) :
      g₁ = g₂ := by
    haveI : IsSeparated (Y.left ↘ Spec (CommRingCat.of k)) :=
      (‹IsSeparated Y.hom› : IsSeparated Y.hom)
    haveI : IrreducibleSpace X.left :=
      GeometricallyIrreducible.irreducibleSpace_of_subsingleton X.hom
    haveI : IsDominant (U.ι : (U : X.left.Opens).toScheme ⟶ X.left) :=
      Scheme.PartialMap.Opens.isDominant_ι (IsOpen.dense U.isOpen hU)
    refine Over.OverMorphism.ext ?_
    exact ext_of_isDominant_of_isSeparated' (S := Spec (.of k))
      (X := X.left) (Y := Y.left) (f := g₁.left) (g := g₂.left) U.ι h
  ```

- Also update the docstring at lines 72–78: replace the existing
  docstring with a minimal-hypothesis version describing the
  refactored signature. Keep the cross-reference to Mathlib's
  `ext_of_isDominant_of_isSeparated'`.

- Also remove the "Hypothesis correction (iter 003 prover)" comment
  block at lines 38–70 OR retitle it to past-tense + drop the
  enumeration of "unused" hypotheses at L62–67 (those hypotheses
  are now actually gone from the signature). The iter-003
  hypothesis-correction discussion at L38–60 (about why the
  scheme-level `h` is needed rather than the point-wise one) remains
  load-bearing and should be preserved, but the L62–67 enumeration
  of unused hypotheses is obsolete and should be removed.

  Suggested retitling: "## Hypothesis history" with subsections
  "Scheme-level hypothesis (iter 003)" preserving L38–60 and
  "Unused-hypothesis cleanup (iter 125)" replacing L62–67 with a
  one-line note that the 8 unused hypotheses listed there were
  dropped iter-125 per `analogies/rigidity-refactor.md`.

- Also update the file's top-level docstring at lines 8–26: the
  "Rigidity for morphisms of group schemes (Mumford §4)" framing
  should be tightened to match the refactored declaration (the
  rigidity result is no longer specifically about group schemes —
  the source-side `[GrpObj X]` and target-side `[GrpObj Y]` are
  gone). Suggested header: "Rigidity for morphisms of schemes
  (scheme-level form)". The Mumford-§4 reference remains accurate
  as the historical motivation but is no longer the formalized
  statement.

### Change 2 — does NOT apply

No other Lean file references `GrpObj.eq_of_eqOnOpen`. The grep
confirms 0 Lean consumers (verified iter-125 plan-phase: `grep -rn
eq_of_eqOnOpen AlgebraicJacobian/*.lean` returns only the two lines
of `Rigidity.lean` itself).

## Affected Files

- `AlgebraicJacobian/Rigidity.lean` — primary refactor target.
- No other `.lean` file is affected.

The blueprint files `Rigidity.tex` and `Jacobian.tex` will be
updated by the plan agent inline this iter (they are not the
refactor agent's domain).

## Expected Outcome

- `AlgebraicJacobian/Rigidity.lean` compiles cleanly via
  `lake build AlgebraicJacobian.Rigidity` (or `lake env lean
  AlgebraicJacobian/Rigidity.lean`) with **zero new sorries** and
  the new declaration name `Scheme.Over.ext_of_eqOnOpen` visible
  via `lean_local_search`.
- Total project sorry count remains **2** (unchanged): the
  iter-124 residuals at `Differentials.lean:398` and
  `Jacobian.lean:179`.
- `archon-protected.yaml` is **NOT** modified (the declaration
  `GrpObj.eq_of_eqOnOpen` is NOT in the protected list; the rename
  does not need a YAML edit).
- No new axioms introduced (`lean_verify
  AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen` should report only
  the kernel axioms `propext, Classical.choice, Quot.sound`).

## Notes for the refactor agent

- The proof body needs only the `‹IsSeparated Y.hom›` anonymous-
  instance reference in place of the `IsProper.toIsSeparated`
  projection. The rest of the body is verbatim from the iter-124
  state.
- The namespace `Scheme.Over` is novel for the project; place the
  declaration inside the existing `namespace AlgebraicGeometry`
  scope so the full name is
  `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen`.
- After the rename + signature change, also clean up the comment
  block at L38–70 per the directive (retitle + prune the
  now-obsolete unused-hypothesis enumeration).
- The file header docstring (L8–26) should reflect the
  scheme-level (not group-scheme-level) framing.
- This refactor is small (~25 LOC including the docstring cleanup)
  and entirely confined to `AlgebraicJacobian/Rigidity.lean`. No
  child subagent dispatch is needed.
