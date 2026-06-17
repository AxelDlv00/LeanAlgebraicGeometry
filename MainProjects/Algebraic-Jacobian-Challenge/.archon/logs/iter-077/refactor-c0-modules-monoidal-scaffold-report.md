# Refactor Report

## Slug
c0-modules-monoidal-scaffold

## Status
COMPLETE

## Directive

### Problem

Phase C step C0 requires the symmetric monoidal structure on `X.Modules` (i.e.
`SheafOfModules X.ringCatSheaf`) for a scheme `X`. Mathlib provides the
presheaf-side structure (`PresheafOfModules.monoidalCategory`) but not the
sheaf-side analogue, blocking Phase C step C1 (refining `LineBundle` from the
global-sections proxy `CommRing.Pic Γ(X, ⊤)` to the invertible-object
definition).

### Changes Requested

1. Create `AlgebraicJacobian/Modules/Monoidal.lean` carrying three `sorry`-bodied
   declarations:
   - `tensorObj : (M N : X.Modules) → X.Modules`
   - `instance instMonoidalCategoryStruct : MonoidalCategoryStruct X.Modules`
   - `instance instMonoidalCategory      : MonoidalCategory X.Modules`
   All in namespace `AlgebraicGeometry.Scheme.Modules`, universe `u`,
   variable `(X : Scheme.{u})`.
2. Add `import AlgebraicJacobian.Modules.Monoidal` to `AlgebraicJacobian.lean`.
3. Do not attempt to fill the sorries.

## Changes Made

### File: `AlgebraicJacobian/Modules/Monoidal.lean` (NEW)
- **What:** Created the scaffold file with the three signature stubs
  `tensorObj`, `instMonoidalCategoryStruct`, `instMonoidalCategory` in
  namespace `AlgebraicGeometry.Scheme.Modules`. Each body is `sorry`.
  The file imports `Mathlib`, opens `CategoryTheory` and `MonoidalCategory`,
  uses `universe u` with `variable (X : Scheme.{u})`. Followed the
  directive's source verbatim (including the file-level docstring,
  copyright header, and `set_option autoImplicit false`); only adjustment
  was a one-line reflow inside the docstring so no line exceeds the
  100-char limit imposed by `linter.style.longLine`.
- **Why:** Scaffold Phase C step C0 for prover rounds iter-078+ to fill,
  unblocking Phase C step C1.
- **Cascading:** None.

### File: `AlgebraicJacobian.lean`
- **What:** Added `import AlgebraicJacobian.Modules.Monoidal` between
  `import AlgebraicJacobian.Differentials` and
  `import AlgebraicJacobian.Picard.LineBundle`.
- **Why:** Make the new file part of the package's import closure.
- **Cascading:** None.

## New Sorries Introduced
- `AlgebraicJacobian/Modules/Monoidal.lean:55` — `tensorObj` body: sheafify the
  presheaf-tensor of the underlying presheaves of modules.
- `AlgebraicJacobian/Modules/Monoidal.lean:61` — `instMonoidalCategoryStruct`:
  assemble tensor/unit/associator/unitors/braiding by sheafifying their
  presheaf-side counterparts.
- `AlgebraicJacobian/Modules/Monoidal.lean:66` — `instMonoidalCategory`:
  pentagon, triangle, hexagon axioms transferred via the sheafification
  adjunction.

(Project sorry count: 16 → 19, as predicted by the directive.)

## Compilation Status

- `AlgebraicJacobian/Modules/Monoidal.lean`: **compiles**. Three warnings,
  one per `sorry`. No errors.
- `AlgebraicJacobian.lean`: **compiles**. The `lake build` log explicitly
  shows `✔ [8332/8333] Ran AlgebraicJacobian` and `✔ [8333/8333] Ran
  AlgebraicJacobian/AlgebraicJacobian:default`, confirming the root file
  and its new import build cleanly.
- `AlgebraicJacobian/Jacobian.lean`: **pre-existing build errors**
  (e.g. line 59 `unexpected token 'ι'`, lines 67/71 stuck typeclass
  problems, lines 90/91/121/207 various). `git diff` confirms these
  modifications pre-date this refactor session — they are inherited from
  prior iterations and are NOT caused by this refactor. The refactor
  agent did not touch `Jacobian.lean`.

Verified via `lean_diagnostic_messages` on the new file: only the three
expected `sorry` warnings. Verified via `lean_build` that the root file's
package target compiles.

## Notes for Plan Agent

- The Mathlib identifier `AlgebraicGeometry.Scheme.Modules` exists and has
  type `Scheme → Type (u_1 + 1)`. Confirmed by `lean_run_code` before
  scaffolding (`#check @AlgebraicGeometry.Scheme.Modules` returned
  `Scheme.Modules : Scheme → Type (u_1 + 1)`). So `X.Modules` is the correct
  spelling, matching the directive verbatim.
- The directive's source was used essentially verbatim; the only mechanical
  change was reflowing one docstring line (the LaTeX line for the tensor
  product equation) to satisfy `linter.style.longLine`. No semantic change.
- No protected declarations are affected (the three new stubs are not in
  `archon-protected.yaml`); no `archon-protected.yaml` modification was
  needed or made.
- No axioms introduced.
- The pre-existing `AlgebraicJacobian/Jacobian.lean` build failures are
  outside the scope of this directive and were not addressed. They were
  present in the working tree before this iteration started and would
  benefit from a separate refactor or prover round.
- The directive predicted sorry count 16 → 19. I did not perform an
  end-to-end sorry count (running `sorry_analyzer` on the broken
  Jacobian.lean is non-trivial), but I introduced exactly 3 new sorries
  in the new file and 0 elsewhere — so the +3 delta holds.
- The mathematical justification was sufficient. No improvisation was
  required.
