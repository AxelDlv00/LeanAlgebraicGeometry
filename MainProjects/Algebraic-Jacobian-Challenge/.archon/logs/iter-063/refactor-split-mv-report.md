# Refactor Report

## Slug
split-mv

## Status
COMPLETE

## Directive

### Problem
`AlgebraicJacobian/Cohomology/MayerVietoris.lean` (1872 LOC) contained three
semantically distinct cohorts of declarations: (1) the abstract
Mayer-Vietoris LES core for `HModule'` plus the Mathlib gap-fill
`Abelian.Ext.chgUnivLinearEquiv`; (2) the 2-affine cover MV +
cover-totality bridges + `IsCechAcyclicCover` infrastructure +
`HasAffineCechAcyclicCover` carrier; (3) the basic-open cover wrappers and
the substantive Čech acyclicity theorem
`basicOpenCover_isCechAcyclicCover_toModuleKSheaf`. The size impeded
parallel work and inflated context for any per-cohort iteration.

### Changes
Split the file along the cohort boundaries into three files, mirroring the
natural dependency tree:

- `MayerVietorisCore.lean` ← cohort 1 (lines 41–637 of the original).
- `MayerVietorisCover.lean` ← cohort 2 (lines 639–1313, dropping the
  non-load-bearing `section CoverTotality` wrapper at L757).
- `BasicOpenCech.lean` ← cohort 3 (lines 1315–1869, also outside the
  dropped `CoverTotality` section, with the `end CoverTotality` at L1870
  omitted).

Then delete `MayerVietoris.lean` and update `AlgebraicJacobian.lean` to
import the three new files instead.

## Changes Made

### File: AlgebraicJacobian/Cohomology/MayerVietorisCore.lean (created)
- **What:** New file containing the Mathlib gap-fill cohort
  (`Abelian.Ext.chgUniv_add`, `Abelian.Ext.chgUniv_smul`,
  `Abelian.Ext.chgUnivLinearEquiv`) outside any namespace, then
  `namespace AlgebraicGeometry.Scheme` opening, then the iter-016 →
  iter-026 MV LES core declarations
  (`HModule'_cohomologyPresheafFunctor`, `HModule'_cohomologyPresheaf`,
  `HModule'_toBiprod`, `HModule'_fromBiprod`, `HModule'_toBiprod_fromBiprod`,
  the iter-019 helpers, the iter-020 mono/epi/exact/short-exact lemmas,
  `HModule'_δ`, `HModule'_sequence`, `HModule'_sequence_exact`, and the
  `δ`-zero simp companions `HModule'_δ_toBiprod` /
  `HModule'_fromBiprod_δ`), then `end AlgebraicGeometry.Scheme`.
  Module docstring describes the cohort scope and the three-file split.
  Imports: `AlgebraicJacobian.Cohomology.StructureSheafModuleK`,
  `Mathlib.CategoryTheory.Limits.Preorder`. Universe declaration:
  `universe u v w w'` (the gap-fill cohort uses `w` and `w'`).
- **Why:** Cohort 1 of the directive's three-way split. The Mathlib
  gap-fill is grouped with the MV LES core because the iter-032 universe
  bridge (in cohort 2) consumes `chgUnivLinearEquiv` — keeping it in
  cohort 1 makes the dependency direction one-way (cohort 2 → cohort 1).
- **Cascading:** None within this file. All proof bodies preserved
  verbatim; no signature changes.

### File: AlgebraicJacobian/Cohomology/MayerVietorisCover.lean (created)
- **What:** New file containing the 2-affine cover MV (the
  `section AffineCoverMVSquare ... end AffineCoverMVSquare` block, lines
  639–755 of the original verbatim) followed by the cover-totality
  declarations (lines 759–1313 of the original verbatim, with the
  `section CoverTotality` wrapper at L757 dropped per directive). This
  cohort includes: iter-031 source-object identification,
  `HModule_top_linearEquiv` (iter-032 universe bridge using
  `chgUnivLinearEquiv` from cohort 1), `finrank` / `Module.Finite`
  transports, the `IsCechAcyclicCover` consumers
  (`subsingleton_HModule'_of_isCechAcyclic`,
  `HasCechToHModuleIso`,
  `subsingleton_HModule'_of_hasCechToHModuleIso`),
  `IsAffineHModuleVanishing`, `HasAffineCechAcyclicCover`, and the
  producer `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover`
  (iter-053). Module docstring describes the cohort scope. Imports:
  `AlgebraicJacobian.Cohomology.MayerVietorisCore`. Universe declaration:
  `universe u v w w'` (the cover-totality declarations use `w` for the
  `chgUnivLinearEquiv` invocation).
- **Why:** Cohort 2 of the directive's split. Depends on cohort 1's
  `chgUnivLinearEquiv` and MV LES core. Drop `section CoverTotality`
  because it is not load-bearing — no `variable` or `open` declarations
  live inside it that would break.
- **Cascading:** None within this file. All proof bodies, dot-notation
  resolutions, and `_root_.AlgebraicGeometry.Scheme.HModule'_sequence`
  qualified references preserved verbatim.

### File: AlgebraicJacobian/Cohomology/BasicOpenCech.lean (created)
- **What:** New file containing the basic-open cover wrappers
  (iter-054: `basicOpenCover`, `basicOpenCover_supr_of_span_eq_top`,
  `basicOpenCover_isAffineOpen`), the iter-055 producer
  `hasAffineCechAcyclicCover_of_basicOpen`, the helper lemma
  `cechCohomology_subsingleton_of_cechCochain_exactAt`, and the
  substantive theorem
  `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (iter-056 →
  iter-062). The two labelled substep sorries inside the substantive
  theorem (substep (a) and substep (b)+(c) assembly) and the iter-062
  `h_a_fun` scaffolding are preserved verbatim, along with all inline
  comments. The `end CoverTotality` line at L1870 of the original is
  omitted (since the section was dropped). Module docstring describes
  the cohort scope. Imports:
  `AlgebraicJacobian.Cohomology.MayerVietorisCover`. Universe
  declaration: `universe u v` (no `w` / `w'` needed in this cohort).
- **Why:** Cohort 3 of the directive's split. Depends on cohort 2's
  `HasAffineCechAcyclicCover` and `IsCechAcyclicCover` /
  `HasCechToHModuleIso` infrastructure.
- **Cascading:** None within this file. All proof bodies, the iter-061
  mechanical `rw` conversion
  (`rw [HomologicalComplex.exactAt_iff,
       ShortComplex.ShortExact.moduleCat_exact_iff_function_exact]`), and
  the iter-062 `h_a_fun` scaffolding preserved verbatim.

### File: AlgebraicJacobian/Cohomology/MayerVietoris.lean (deleted)
- **What:** Deleted; its 1872 LOC fully redistributed across the three
  new files above.
- **Why:** Per directive — single-file 1872-LOC blob impeded parallel
  prover work and inflated per-iteration context. The three new files
  span the same content (~1935 LOC including new headers; ~1872 LOC of
  semantic content preserved).
- **Cascading:** Only `AlgebraicJacobian.lean` imported `MayerVietoris`
  (confirmed via `Grep` over `*.lean` files); updated to the three new
  imports.

### File: AlgebraicJacobian.lean (modified)
- **What:** Replaced the single line
  `import AlgebraicJacobian.Cohomology.MayerVietoris` with three lines
  importing the three new modules
  (`MayerVietorisCore`, `MayerVietorisCover`, `BasicOpenCech`).
- **Why:** Re-export all three new files in place of the deleted one.
- **Cascading:** None — no other Lean file imported MayerVietoris.

### File: archon-protected.yaml (untouched)
- **What:** No changes. None of the protected declarations (those in
  `Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean`) live inside the
  `MayerVietoris.lean` file or the new split files; no path updates
  required.

## New Sorries Introduced

None. The two pre-existing sorries inside
`basicOpenCover_isCechAcyclicCover_toModuleKSheaf` were carried over
verbatim — they now appear at:

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:444` — substep (a)
  infrastructure: augmented Čech simplicial object (originally at
  `MayerVietoris.lean:1722`).
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:582` — substep
  (b)+(c) assembly: cochain-level localisation iso + ring-base bridge
  (originally at `MayerVietoris.lean:1860`).

Project-wide sorry count after refactor: **11** (matches expected outcome
in directive).

| File | Sorries |
| --- | --- |
| `AlgebraicJacobian/Jacobian.lean` | 5 (lines 68, 85, 92, 100, 107) |
| `AlgebraicJacobian/AbelJacobi.lean` | 3 (lines 34, 39, 49) |
| `AlgebraicJacobian/Picard/Functor.lean` | 1 (line 185) |
| `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` | 2 (lines 444, 582) |

## Compilation Status

All checks pass via `lean_build` (whole project, 8331 jobs, success: true,
errors: empty) and `lean_diagnostic_messages` (severity=error, no items
returned for any of the touched files):

- `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean`: compiles cleanly,
  no errors / no warnings.
- `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean`: compiles cleanly,
  no errors / no warnings.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`: compiles with the
  expected single `declaration uses 'sorry'` warning at line 402 (the
  `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` declaration carrying
  the two preserved sorries).
- `AlgebraicJacobian.lean`: compiles cleanly, no errors / no warnings.

No new axioms introduced. No protected signature touched.

## Notes for Plan Agent

- The directive's line range "41–122" for the gap-fill cohort lightly
  overlaps with the `set_option / universe / open` lines (39, 41, 43);
  to avoid duplication I started the verbatim copy at the
  `/-! ## Iter-034 Mathlib gap-fill ...` docstring (original L45). The
  three structural lines are preserved at the top of each new file in
  the order the directive listed.
- The `CoverTotality` section, dropped per directive, was confirmed to
  contain no `variable`, `open`, or `local` declarations that would
  affect downstream resolution. The decls inside it parsed cleanly
  outside the section.
- File line counts (post-split): MayerVietorisCore = 629 LOC,
  MayerVietorisCover = 713 LOC, BasicOpenCech = 593 LOC. Total ≈ 1935
  LOC vs. the original 1872 LOC — the difference (≈63 LOC) is from the
  three new module docstrings + per-file `set_option / universe / open /
  namespace` boilerplate (~21 LOC × 3 files); no semantic content was
  duplicated.
- Three parallel prover sessions can now advance independently as the
  directive anticipated: substantive Čech acyclicity in
  `BasicOpenCech.lean`, comparison-iso `HasCechToHModuleIso` instance
  in `MayerVietorisCover.lean`, and a brand-new file for Phase B
  differentials with no overlap to any of the three new files.
- The blueprint chapter `blueprint/src/chapters/Cohomology_MayerVietoris.tex`
  was not modified per directive — the plan agent will split it later.
  All three new file docstrings reference the existing single chapter.
- No follow-up refactors needed for this iteration.
