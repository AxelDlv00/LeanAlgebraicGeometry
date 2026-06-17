# Refactor Report

## Slug
quot-split

## Status
COMPLETE

## Directive
**Problem:** `AlgebraicJacobian/Picard/QuotScheme.lean` (1696 lines) combines two
semantically-distinct layers (Quot/Grassmannian defs and graded-Hilbert–Serre rationality)
that block parallelism and carry recurring M1 hygiene debt from 11 `private` declarations
that are blueprint-pinned.

**Changes requested:**
- Split `QuotScheme.lean` → `QuotScheme.lean` (keeps) + `GradedHilbertSerre.lean` (new)
- Remove `private` from 11 moved declarations
- Remove 10-line stale comment block inside `subquotient_base_eventuallyZero`
- Wire new module into build graph via `AlgebraicJacobian.lean`

## Changes Made

### File: `AlgebraicJacobian/Picard/GradedHilbertSerre.lean` (NEW)
- **What:** Created with a copyright header, `import Mathlib`, module docstring,
  `set_option autoImplicit false`, then the moved content from QuotScheme.lean lines
  425–1696 (the `/-! ## Project-local … graded Hilbert–Serre rationality -/` comment
  through `end AlgebraicGeometry`). Final file: 1287 lines.
- **Why:** Split per directive to allow parallel proving on the two layers.
- **De-privatized (11 declarations):**
  - `coeff_invOneSubPow_one_mul` — `private lemma` → `lemma`
  - `rationalHilbert_antidiff` — `private lemma` → `lemma`
  - `IsRatHilb` — `private def` → `def`
  - `IsRatHilb.ofEventuallyZero` — `private lemma` → `lemma`
  - `IsRatHilb.bump` — `private lemma` → `lemma`
  - `IsRatHilb.sub` — `private lemma` → `lemma`
  - `IsRatHilb.shiftRight` — `private lemma` → `lemma`
  - `IsRatHilb.antidiff` — `private lemma` → `lemma`
  - `IsRatHilb.ofDiffEq` — `private lemma` → `lemma`
  - `GradedModule.finrank_comap_subtype` — `private lemma` → `lemma`
  - `GradedModule.iSupIndep_map_of_mem_ker_sup` — `private lemma` → `lemma`
- **Stale comment removed:** The 10-line block at QuotScheme.lean lines 1510–1519
  ("(RESIDUAL LEAF — the only `sorry` in the QUOT keystone chain)" / "OBSTRUCTION:
  building the κ-linear `Φ`…") inside `subquotient_base_eventuallyZero` was deleted.
  The proof below it is complete and sorry-free; the comment was factually wrong.
- **Cascading:** None — the moved content has no back-references to QuotScheme.lean's
  remaining declarations.

### File: `AlgebraicJacobian/Picard/QuotScheme.lean` (TRIMMED)
- **What:** Removed lines 424–1696 (blank + the entire graded-Hilbert–Serre
  `namespace AlgebraicGeometry` block). File now ends at line 423: `end Module`.
- **Why:** Content moved to GradedHilbertSerre.lean. Remaining declarations
  (4 protected stubs + SheafOfModules + Scheme.Modules + Module.annihilator_…) are
  fully independent of the moved content.
- **Import:** No import of GradedHilbertSerre added (no remaining decl references moved content).

### File: `AlgebraicJacobian.lean` (UPDATED)
- **What:** Added `import AlgebraicJacobian.Picard.GradedHilbertSerre` between the
  QuotScheme and GrassmannianCells imports.
- **Why:** Wires the new module into the build graph so `lake build AlgebraicJacobian`
  covers it.

### File: `archon-protected.yaml` (UNCHANGED)
- The four protected stubs remain in QuotScheme.lean with the same paths. No YAML
  edit required.

## New Sorries Introduced
None. The split is a pure structural move; no proofs were touched.

## Compilation Status

### `lake build AlgebraicJacobian.Picard.GradedHilbertSerre`
**Success** — only pre-existing `unusedVariables` linter warnings (pre-existing in
the original QuotScheme.lean; no new warnings introduced by the split).

### `lake build AlgebraicJacobian.Picard.QuotScheme`
**Success** — exactly 4 `declaration uses 'sorry'` warnings:
- Line 123: `AlgebraicGeometry.Scheme.hilbertPolynomial` (protected stub)
- Line 161: `AlgebraicGeometry.Scheme.QuotFunctor` (protected stub)
- Line 198: `AlgebraicGeometry.Scheme.Grassmannian` (protected stub)
- Line 225: `AlgebraicGeometry.Scheme.Grassmannian.representable` (protected stub)

### `lake build AlgebraicJacobian` (full project)
**Success** — 8325 jobs, no errors.

## Axiom check: `gradedModule_hilbertSeries_rational`
```
axioms: [propext, Classical.choice, Quot.sound]
```
Standard Lean/Mathlib foundations only. No `sorry` axioms. Keystone chain is axiom-clean post-move.

## Sorry inventory (final)

| File | Sorries | Description |
|------|---------|-------------|
| `QuotScheme.lean` | 4 | The 4 blueprint-protected stubs (unchanged) |
| `GradedHilbertSerre.lean` | 0 | All proofs complete, sorry-free |

## Declarations deleted / renamed
No declarations deleted or renamed. All moved declarations retain their exact names and
signatures; only the `private` modifier was removed from 11 of them. The qualified names
(`AlgebraicGeometry.IsRatHilb`, `AlgebraicGeometry.GradedModule.finrank_comap_subtype`,
`AlgebraicGeometry.GradedModule.iSupIndep_map_of_mem_ker_sup`, etc.) are unchanged and
will resolve for `sync_leanok`.

## Notes for Plan Agent
- The 11 de-privatizations are complete; `sync_leanok` can now resolve all blueprint
  `\lean{...}` pins for the IsRatHilb toolkit and the two GradedModule helpers.
- The `unusedVariables` warnings in GradedHilbertSerre.lean (lines 819, 820, 821, 822,
  823, 1010, 1011, 1013, 1030, 1031, 1032) are pre-existing from the original
  QuotScheme.lean and are not introduced by this refactor. They can be cleaned up
  independently if desired.
- No blueprint chapter edits are needed on the plan-agent side for the split: the
  blueprint chapter for GradedHilbertSerre.lean (`Picard_GradedHilbertSerre.tex`) is
  already present as an untracked file per the git status; the plan agent should wire
  it into `blueprint/src/content.tex` if not already done.
