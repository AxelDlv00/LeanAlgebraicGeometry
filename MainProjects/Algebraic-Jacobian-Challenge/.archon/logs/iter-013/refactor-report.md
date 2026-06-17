# Refactor Report

## Status
COMPLETE

## Directive

**Iteration 013** — Mayer-Vietoris prerequisite. Scaffold the
`ModuleCat k`-flavored cohomology of an open `X : C` with values in a sheaf
`F : Sheaf J (ModuleCat.{u} k)` as `AlgebraicGeometry.Scheme.HModule'`,
mirroring Mathlib's `Sheaf.H' F n X` for `AddCommGrpCat`-valued sheaves.

Single-file change to
`AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`: insert one new
declaration `HModule'` (body `:= sorry`) between `HModule_zero_linearEquiv`
(L203–L210) and `end AlgebraicGeometry.Scheme` (L212).

The chosen signature shape (verbatim from the directive):

```lean
noncomputable abbrev HModule' (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (F : Sheaf J (ModuleCat.{u} k)) (n : ℕ) (X : C) : Type u := sorry
```

## Changes Made

### File: `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`
- **What:** Inserted a new declaration `HModule'` (body `:= sorry`) at the end
  of `namespace AlgebraicGeometry.Scheme`, between the iter-010
  `HModule_zero_linearEquiv` and the `end AlgebraicGeometry.Scheme` line. The
  doc-comment is the long-form one supplied by the directive (Mayer-Vietoris
  motivation, `noncomputable abbrev` rationale, queued iter-014/015+ work).
- **Why:** Mathlib's Mayer-Vietoris LES is stated entirely in terms of
  `Sheaf.H'` (`AddCommGrpCat`-valued sheaves only), and there is no
  `ModuleCat k`-flavored mirror in Mathlib or in the project. iter-013 lands
  the mirror so iter-014+ can state the LES on a `MayerVietorisSquare`.
- **Cascading:** None. The change is purely additive — no existing
  declaration was renamed, retyped, or moved, and no downstream consumer
  references `HModule'`.

## New Sorries Introduced
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean:232` — the body
  of `HModule'` is `:= sorry`. The iter-013 prover round closes it with
  the probe-confirmed one-liner
  `Ext ((presheafToSheaf _ _).obj ((yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k)).obj X)) F n`.

## Compilation Status
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`:
  `lean_diagnostic_messages` returns
  `{success: true, items: [{severity: "warning", message: "declaration uses 'sorry'", line: 232, column: 22}], failed_dependencies: []}`.
  Exactly one warning at the new declaration; zero errors; zero failed
  dependencies. Matches the directive's expectation.
- `AlgebraicJacobian/Genus.lean`: compiles via
  `lean_run_code (import AlgebraicJacobian.Genus; example : True := trivial)`
  → `{success: true, diagnostics: []}`. The iter-011 closure remains intact.
- `AlgebraicJacobian/AbelJacobi.lean`, `Jacobian.lean`, `Picard/Functor.lean`,
  `Picard/FunctorAb.lean`, `Picard/LineBundle.lean`, `Rigidity.lean`,
  `Cohomology/StructureSheafAb.lean`, `Cohomology/SheafCompose.lean`: bundle
  import via `lean_run_code` → `{success: true, diagnostics: []}`. No
  cascading breakage.
- Sorry count: `${LEAN4_PYTHON_BIN:-python3} "$LEAN4_SCRIPTS/sorry_analyzer.py" AlgebraicJacobian/ --format=summary`
  reports `10 total across 4 file(s)`:
  - `AlgebraicJacobian/Jacobian.lean`: 5 sorries
  - `AlgebraicJacobian/AbelJacobi.lean`: 3 sorries
  - `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`: 1 sorry
  - `AlgebraicJacobian/Picard/Functor.lean`: 1 sorry

  Matches the directive's expectation (9 → 10).
- `archon-protected.yaml`: `git diff archon-protected.yaml` returns empty.
  Unchanged.

## §3.3 Sanity-Check Probe

The directive's pre-report sanity-check probe was run via `lean_run_code`
against the post-refactor file. The probe substitutes the prover's intended
one-liner closure body in place of the `sorry`:

```lean
import AlgebraicJacobian.Cohomology.StructureSheafModuleK
open CategoryTheory Limits TopologicalSpace AlgebraicGeometry CategoryTheory.Abelian

universe u v

namespace AlgebraicGeometry.Scheme

noncomputable abbrev HModule'_test (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (F : Sheaf J (ModuleCat.{u} k)) (n : ℕ) (X : C) : Type u :=
  Ext ((presheafToSheaf _ _).obj
    ((yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k)).obj X)) F n

end AlgebraicGeometry.Scheme
```

Result: `{success: true, diagnostics: []}`. The prover-round closure body is
drop-in.

## Notes for Plan Agent

- The directive's two "two-line shape adjustments allowed" escape hatches
  (explicit-universe `HasExt.{u}` form; alternative spelling
  `(((Functor.whiskeringRight _ _ _).obj (ModuleCat.free k)).obj (yoneda.obj X))`)
  were **not needed**. The unqualified `HasExt (Sheaf J (ModuleCat.{u} k))`
  signature elaborated cleanly (matching the iter-009 `HModule` style), and
  the prover-round closure body's
  `(yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k)).obj X`
  spelling probe-validated as written.
- The mathematical justification in the directive was complete and
  sufficient. No improvisations were needed.
- The directive's expected outcome — "One new `:= sorry` declaration appended
  at the end of `namespace AlgebraicGeometry.Scheme` block (between L210 and
  L212 in the current file). Sorry count: 9 → 10. File compiles with one
  `declaration uses 'sorry'` warning, no errors." — is achieved exactly.
- Next iteration: iter-013 prover round to close the `HModule'` body with
  the probe-confirmed one-liner. iter-014+ Mayer-Vietoris LES depends on
  this declaration's signature; the signature should not be altered after
  the prover closes the body.
- A companion `HModule'_zero_linearEquiv` (mirror of iter-010's
  `HModule_zero_linearEquiv`) is not part of the iter-013 directive but is a
  natural follow-up; the directive flags it for iter-014+ at one-line
  `Abelian.Ext.linearEquiv₀`.
