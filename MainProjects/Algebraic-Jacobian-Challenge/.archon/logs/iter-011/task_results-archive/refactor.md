# Refactor Report

## Status
COMPLETE

## Directive

### Problem
The protected `def genus` in `AlgebraicJacobian/Genus.lean` cannot host its
honest body `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`
without (a) the `noncomputable` modifier (the body uses `Module.finrank`,
`Abelian.Ext.instModule`, and `toModuleKSheaf` — all noncomputable) and
(b) an import that makes `Scheme.HModule` and `Scheme.toModuleKSheaf` visible.
The user authorised the modifier on `2026-05-07` (recorded in
`.archon/USER_HINTS.md`); plan-agent `lean_run_code` probes confirmed the body
typechecks at universe `u` and at `Type 0`.

### Changes (per directive)
1. Add `import AlgebraicJacobian.Cohomology.StructureSheafModuleK` after the
   existing `import Mathlib` line in `AlgebraicJacobian/Genus.lean`.
2. Add the `noncomputable` modifier on `def genus` (preserving argument types,
   names, order, and return type — only the modifier is added).
3. Update the file docstring to reflect the iter-011 closure plan.
4. Update the in-line comment block on the body of `genus`.
5. **Do NOT** touch the `sorry` body, any other file, or
   `archon-protected.yaml`.

## Changes Made

### File: `AlgebraicJacobian/Genus.lean`

#### (a) Import line added
- **What:** Inserted a new import line immediately after the existing
  `import Mathlib`.
- **Where:** After insertion, `AlgebraicJacobian/Genus.lean` line 7 reads:

  ```lean
  import AlgebraicJacobian.Cohomology.StructureSheafModuleK
  ```

- **Why:** Per directive — makes `AlgebraicGeometry.Scheme.HModule` and
  `AlgebraicGeometry.Scheme.toModuleKSheaf` visible so the prover round can
  fill the body with `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`.
- **Cascading:** None.

#### (b) `noncomputable` modifier added on `def genus`
- **What:** Replaced `def genus` with `noncomputable def genus`. Argument
  types, names, order, return type are unchanged. The body remains `sorry`.
  The in-line comment block was updated from the iter-001 commentary to the
  iter-011 closure scaffold commentary (per directive).
- **Diff (only the touched block):**

  ```diff
  --- before
  +++ after
   -- data
   /-- The genus of a smooth proper curve. -/
  -def genus {k : Type u} [Field k] (C : Over (Spec (.of k)))
  +noncomputable def genus {k : Type u} [Field k] (C : Over (Spec (.of k)))
       [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
       [GeometricallyIrreducible C.hom] : ℕ :=
  -  -- Honest definition is `Module.finrank k (H¹(C, O_C))`, where the latter is
  -  -- a `k`-vector space via `C.hom : C.left ⟶ Spec (.of k)`. The current Mathlib
  -  -- API (b80f227) does not assemble these pieces; see the docstring above and
  -  -- `.archon/task_results/Genus.md` for the precise gap and helper-lemma
  -  -- proposals. Discovery iteration 001 leaves the sorry intentionally per
  -  -- `.archon/PROGRESS.md` (no constant placeholder, no axiom).
  +  -- Iter-011 closure scaffold: the body is filled by the prover round with
  +  -- `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`. The
  +  -- `noncomputable` modifier is authorised by the user (recorded
  +  -- `2026-05-07` in `.archon/USER_HINTS.md`) because the honest body uses
  +  -- `Module.finrank`, `Abelian.Ext.instModule`, and `toModuleKSheaf` — all
  +  -- noncomputable Mathlib API. Argument types, names, and order remain
  +  -- verbatim per `archon-protected.yaml`.
     sorry
  ```

- **Why:** Per directive — `Module.finrank`, `Abelian.Ext.instModule`, and
  `toModuleKSheaf` are all noncomputable, so the eventual body cannot be a
  `def` without the modifier. The user authorised this modifier-addition on
  `2026-05-07`. Argument types, names, order, return type are frozen per
  `archon-protected.yaml` and are not touched.
- **Cascading:** None. The `sorry` body is preserved; no consumer file
  observes a behavioural change. (`Jacobian.lean` and `AbelJacobi.lean`
  reference `genus` only in a way that is opaque to the modifier.)

#### (c) File docstring updated
- **What:** Replaced the entire `/-! ... -/` docstring at the top of the file
  (the iter-001 status block plus the building-blocks/missing-pieces sketch)
  with the iter-011 closure-scaffold docstring per directive.
- **New docstring (lines 9–29):**

  ```lean
  /-!
  # Genus of a smooth proper curve

  The genus of a smooth, proper, geometrically irreducible curve over a field.

  ## Status (iteration 011 — `genus` closure scheduled)

  The iter-011 refactor adds the `noncomputable` modifier (user-authorised
  `2026-05-07`) and an import of `AlgebraicJacobian.Cohomology.StructureSheafModuleK`
  so the body can use the project's `ModuleCat k`-flavoured cohomology
  `Scheme.HModule` (iter-009) of the structure sheaf
  `Scheme.toModuleKSheaf` (iter-006). The body itself is filled by the
  iter-011 prover round with the probe-confirmed one-liner

      Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)

  which is the honest mathematical definition `dim_k H^1(C, O_C)`.

  See `blueprint/src/chapters/Genus.tex` for the informal proof sketch and
  `.archon/STRATEGY.md` for the multi-phase build-out plan.
  -/
  ```

- **Why:** Per directive — the iter-001 commentary was stale (it described
  the gap as if it were unfilled, but iter-006/iter-009/iter-011 have closed
  the prerequisite chain). The new docstring records the iter-011 status.
- **Cascading:** None. The commented-out `OXAsAddCommGrpSheaf` / `H1OC`
  sketch (lines 39–61) is left in place; the directive did not request its
  removal, and excising it would be out of scope.

## New Sorries Introduced
None. The only `sorry` in `Genus.lean` is the pre-existing body of `genus`,
preserved per directive (the iter-011 prover round will fill it).

## Compilation Status
- `AlgebraicJacobian/Genus.lean`: compiles. `lean_diagnostic_messages` returns

  ```json
  {"result":{"success":true,
   "items":[{"severity":"warning","message":"declaration uses `sorry`",
             "line":65,"column":19}],
   "failed_dependencies":[]}}
  ```

  Exactly one warning (the expected `declaration uses 'sorry'` at the body of
  `genus`, line 65 column 19), zero errors.
- Probe of the prover's intended body (per directive sanity check):

  ```lean
  import AlgebraicJacobian.Cohomology.StructureSheafModuleK
  open CategoryTheory Limits TopologicalSpace AlgebraicGeometry
  noncomputable example {k : Type} [Field k] (C : Over (Spec (CommRingCat.of k)))
      [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
      [GeometricallyIrreducible C.hom] : ℕ :=
    Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)
  ```

  Returns `{"success":true,"diagnostics":[]}`. The closure body remains
  drop-in for the prover round.

## Sorry Count
- **Before refactor (iter-010 baseline):** 10 total — 5 `Jacobian.lean`,
  3 `AbelJacobi.lean`, 1 `Genus.lean`, 1 `Picard/Functor.lean`.
- **After refactor:** 10 total — same distribution. Verified with
  `${LEAN4_PYTHON_BIN:-python3} "$LEAN4_SCRIPTS/sorry_analyzer.py"
  /home/archon/Lean_tests/AlgebraicJacobian/AlgebraicJacobian/
  --format=summary`:

  ```
  Sorry Summary: 10 total across 4 file(s)
  --------------------------------------------------
    .../Jacobian.lean: 5 sorries
    .../AbelJacobi.lean: 3 sorries
    .../Genus.lean: 1 sorries
    .../Picard/Functor.lean: 1 sorries
  ```

  Matches the directive's expected post-refactor count exactly.

## `archon-protected.yaml` Confirmation
Unchanged. `git status` reports `archon-protected.yaml` only as `Untracked`
(a project-level state from before this branch); `git diff` on the file
returns empty. No protected declaration was renamed, re-typed, reordered, or
moved between files; only the `noncomputable` modifier was added to
`AlgebraicGeometry.genus`, which the directive explicitly identifies as a
non-signature change authorised by the user.

## Notes for Plan Agent

- The directive was executed exactly as specified. No deviation, no
  out-of-scope edits.
- The commented-out `OXAsAddCommGrpSheaf` / `H1OC` sketch (lines 39–61 of the
  current file) is preserved as it was outside the directive's scope. If you
  want it removed in a future iteration to tidy up the file, that would be a
  one-line refactor directive.
- The probe `lean_run_code` for the prover's intended body (universe `Type 0`)
  succeeded post-refactor, confirming the prover-round target is drop-in
  ready.
- The refactor introduced no new `axiom` declarations and no new `sorry`s;
  the `sorry` count is preserved at 10. The iter-011 prover round can now
  proceed against the single remaining `sorry` in `Genus.lean` (line 75) with
  the directive-specified one-liner.
- No cascading changes were necessary. `Jacobian.lean` and `AbelJacobi.lean`
  reference `genus` only via type signatures (in
  `Jacobian.smoothOfRelativeDimension_genus` for instance); the modifier
  addition is invisible at the type level, so no downstream signature
  required adjustment.
- The mathematical justification in the directive was sufficient to guide
  the (minimal) refactor; no additional content beyond the directive was
  needed.
