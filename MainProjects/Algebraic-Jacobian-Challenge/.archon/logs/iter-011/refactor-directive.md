<!-- Archived from REFACTOR_DIRECTIVE.md at 2026-05-07T09:20:17Z -->
<!-- This is the directive the plan agent wrote for the refactor agent in this iteration. -->

# Refactor Directive — Iter 011

## Summary

Single small change to one file (`AlgebraicJacobian/Genus.lean`). The user has authorised agents to add the `noncomputable` modifier to the protected `def genus` declaration; the iter-011 plan agent has probe-confirmed (`lean_run_code`) that the body `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)` typechecks against current Mathlib + project state with kernel-only axioms. This refactor adds the `noncomputable` modifier and the import that makes the body's identifiers visible; the iter-011 prover round will then fill the body in the next phase.

This directive is **deliberately conservative**: it changes only what is strictly required to allow the prover round to land the closure, and leaves the body as `sorry` (no proof writing — that is the prover's job).

## Mathematical justification

`genus C` is the dimension of $H^1(C, \mathcal O_C)$ as a $k$-vector space. The project has built the necessary infrastructure:
- `AlgebraicGeometry.Scheme.toModuleKSheaf` (iter-006): the structure sheaf $\mathcal O_C$ viewed as a sheaf of $k$-modules, using the structure morphism $C.\mathrm{hom}$ to install the $k$-algebra structure on each $\Gamma(C, U)$.
- `AlgebraicGeometry.Scheme.HModule` (iter-009): the parallel $\Sheaf.\mathtt{H}$ for $\ModuleCat k$-valued sheaves, defined as $\Ext_{\Sheaf(J, \ModuleCat k)}((\mathtt{constantSheaf}\,J\,(\ModuleCat\,k)).\mathrm{obj}\,(\ModuleCat.\mathrm{of}\,k\,k), F, n)$. This carries a canonical $\Module k$-structure via `Abelian.Ext.instModule` against the auto-inferable `Linear k`-enrichment of $\Sheaf(J, \ModuleCat k)$.
- `Module.finrank k _` returns the dimension when finite-dimensional and 0 otherwise — a well-defined `ℕ`.

Composing, `noncomputable def genus … := Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)` is the honest definition of the genus, type-checks end-to-end, and matches the definitional content of `def:genus` in `blueprint/src/chapters/Genus.tex`. The `noncomputable` modifier is required because `Module.finrank`, `Abelian.Ext.instModule`, and `toModuleKSheaf` are all noncomputable. The user (`2026-05-07`, recorded in `USER_HINTS.md`) authorised agents to add this modifier to the protected declaration.

This change closes the **first** of the 9 protected sorries — a major project milestone.

## Probe evidence

Iter-011 plan-agent `lean_run_code` (this pass), against the current Mathlib snapshot:

```lean
import AlgebraicJacobian.Cohomology.StructureSheafModuleK

universe u

open CategoryTheory Limits TopologicalSpace AlgebraicGeometry

noncomputable def genus_test {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] : ℕ :=
  Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)
```

Result: `{success: true, diagnostics: []}`. No name resolution adjustment needed. Universe `u` works.

Sanity probe at `Type 0`:

```lean
import AlgebraicJacobian.Cohomology.StructureSheafModuleK
open CategoryTheory Limits TopologicalSpace AlgebraicGeometry

noncomputable example {k : Type} [Field k] (C : Over (Spec (CommRingCat.of k)))
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] : ℕ :=
  Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)
```

Result: `{success: true, diagnostics: []}`.

## File edits to perform

### `AlgebraicJacobian/Genus.lean`

Make exactly two changes; nothing else in this file.

1. **Add an import** after the existing `import Mathlib` line (currently line 6). The new import must follow the existing one (Lean is sensitive to ordering in some edge cases; safe placement is immediately after).

   **Before** (line 6):

   ```lean
   import Mathlib
   ```

   **After**:

   ```lean
   import Mathlib
   import AlgebraicJacobian.Cohomology.StructureSheafModuleK
   ```

2. **Add the `noncomputable` modifier** on the protected `def genus` declaration. In the current file the declaration begins at line 87:

   **Before**:

   ```lean
   -- data
   /-- The genus of a smooth proper curve. -/
   def genus {k : Type u} [Field k] (C : Over (Spec (.of k)))
       [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
       [GeometricallyIrreducible C.hom] : ℕ :=
     -- Honest definition is `Module.finrank k (H¹(C, O_C))`, where the latter is
     -- a `k`-vector space via `C.hom : C.left ⟶ Spec (.of k)`. The current Mathlib
     -- API (b80f227) does not assemble these pieces; see the docstring above and
     -- `.archon/task_results/Genus.md` for the precise gap and helper-lemma
     -- proposals. Discovery iteration 001 leaves the sorry intentionally per
     -- `.archon/PROGRESS.md` (no constant placeholder, no axiom).
     sorry
   ```

   **After** (only the modifier and the in-line comment block are touched; argument types, names, order, and return type are preserved verbatim):

   ```lean
   -- data
   /-- The genus of a smooth proper curve. -/
   noncomputable def genus {k : Type u} [Field k] (C : Over (Spec (.of k)))
       [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
       [GeometricallyIrreducible C.hom] : ℕ :=
     -- Iter-011 closure scaffold: the body is filled by the prover round with
     -- `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`. The
     -- `noncomputable` modifier is authorised by the user (recorded
     -- `2026-05-07` in `.archon/USER_HINTS.md`) because the honest body uses
     -- `Module.finrank`, `Abelian.Ext.instModule`, and `toModuleKSheaf` — all
     -- noncomputable Mathlib API. Argument types, names, and order remain
     -- verbatim per `archon-protected.yaml`.
     sorry
   ```

   The comment block is updated to describe the iter-011 plan (the original iter-001 commentary is now stale and replaced; the historical commentary is preserved in `task_done.md` once the closure lands).

3. **Update the file docstring** (the comment block at lines 7–51) to reflect the iter-011 status. Replace the existing iter-001 status block with:

   **Before** (lines 7–51, the docstring describing iter-001 status):

   The current docstring has a status block "## Status (iteration 001 — discovery)" describing the Mathlib gap as if it were unfilled, plus a long sketch comment "Sketch of the route once Phase A is available". Both are now stale.

   **After**: replace the docstring with:

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

   No other content from the original docstring is preserved (the discovery sketch and the Mathlib gap commentary are now superseded by the closure landing this iteration; the up-to-date account lives in the blueprint chapter).

## What NOT to do

- **Do NOT change the body of `genus`.** Leave it as `sorry`. The prover round in the next phase fills it. (If the refactor agent is tempted to inline the one-liner, resist: the rules forbid the refactor agent from filling proofs/bodies. Even though this body is a one-line term, it is a "body" and only the prover may fill it.)
- **Do NOT touch the protected signature beyond adding the `noncomputable` modifier.** Argument types, names, order, return type are frozen.
- **Do NOT touch any file other than `Genus.lean`.** No edits to `Cohomology/StructureSheafModuleK.lean`, `Jacobian.lean`, `AbelJacobi.lean`, `archon-protected.yaml`, the blueprint chapters (the plan agent has already updated `chapters/Genus.tex`), or `task_pending.md` / `task_done.md` (those are the plan agent's territory).
- **Do NOT introduce new axioms.** Forbidden by plan-agent rules.
- **Do NOT add `instance` declarations or helper lemmas.** None are needed; the body is a single-application closure.
- **Do NOT delete the `sorry` body during this refactor.** The prover round expects to find the sorry at the body of `genus` and replace it.

## Sanity check

Before reporting completion, the refactor agent should:

1. Run `lean_diagnostic_messages` on `AlgebraicJacobian/Genus.lean`. Expected output: exactly one item — `{severity: warning, message: "declaration uses sorry", line: <body line>}` — and zero errors.
2. Run a `lean_run_code` probe of the prover's intended closure body to confirm it remains drop-in:

   ```lean
   import AlgebraicJacobian.Cohomology.StructureSheafModuleK
   open CategoryTheory Limits TopologicalSpace AlgebraicGeometry
   noncomputable example {k : Type} [Field k] (C : Over (Spec (CommRingCat.of k)))
       [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
       [GeometricallyIrreducible C.hom] : ℕ :=
     Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)
   ```

   Expected: `{success: true, diagnostics: []}`. If this probe fails, do **not** complete the refactor — return a status report and let the plan agent re-strategise.
3. Run `${LEAN4_PYTHON_BIN:-python3} "$LEAN4_SCRIPTS/sorry_analyzer.py" /home/archon/Lean_tests/AlgebraicJacobian/AlgebraicJacobian/ --format=summary`. Expected: 10 sorries total — 1 in `Genus.lean` (the still-unfilled `genus` body), 5 in `Jacobian.lean`, 3 in `AbelJacobi.lean`, 1 in `Picard/Functor.lean`. (The count should NOT change from the iter-010 baseline — this refactor preserves the existing `sorry` rather than adding a new one.)
4. Confirm `archon-protected.yaml` is unchanged (no file moves; only a modifier+body change to a declaration whose path is unchanged).

## Expected post-refactor sorry count

`10 → 10` (same; only the modifier and import are added, the body's `sorry` is preserved).

## Expected post-prover sorry count (next phase)

`10 → 9` (the `genus` body is replaced with the probe-confirmed one-liner). 8 protected sorries remain: 5 in `Jacobian.lean`, 3 in `AbelJacobi.lean`. Plus 1 deferred `Picard/Functor.lean` `representable`. **First protected closure of the project.**

## Output protocol

The refactor agent writes `task_results/refactor.md` listing:
- (a) The exact import line added (and its line number after insertion).
- (b) The exact diff applied to the `def genus` declaration (modifier addition; in-line comment block update).
- (c) The new docstring for the file.
- (d) `lean_diagnostic_messages` output post-edit.
- (e) `lean_run_code` probe output for the prover's intended closure body.
- (f) Sorry count post-refactor.
- (g) Confirmation that `archon-protected.yaml` is unchanged.
