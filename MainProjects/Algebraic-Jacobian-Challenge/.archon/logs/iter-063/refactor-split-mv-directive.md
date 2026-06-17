# Refactor Directive

## Slug
split-mv

## Problem

`AlgebraicJacobian/Cohomology/MayerVietoris.lean` has grown to 1872 LOC across
three semantically distinct cohorts of declarations. The size impedes
parallelism (only one prover can edit the file per iteration) and inflates the
context needed to work on any one cohort. The cohorts are:

1. **MV LES core (iter-016 → iter-026)**: the abstract Mayer-Vietoris long
   exact sequence for `HModule'`, plus the Mathlib gap-fill
   `Abelian.Ext.chgUnivLinearEquiv` (iter-034) needed to formulate one of the
   universe bridges.
2. **2-affine cover Mayer-Vietoris + cover-totality bridges + Čech-acyclic
   cover infrastructure (iter-028 → iter-053)**: `AffineCoverMVSquare`,
   cover-totality `LinearEquiv`s, `finrank` / `Module.Finite` transports, the
   `IsCechAcyclicCover` consumers, the `HasCechToHModuleIso` typeclass, and
   the `HasAffineCechAcyclicCover` existence-bundled predicate + producer.
3. **Basic-open cover wrappers and the substantive Čech-acyclicity theorem
   (iter-054 → iter-062)**: the `basicOpenCover` family of definitions and
   identification lemmas, plus the
   `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` theorem currently
   carrying two labelled substep sorries.

The user requested splitting the file into smaller semantically consistent
modules. Splitting on the cohort boundaries above yields three files of
roughly 600 LOC each, mirroring the natural dependency tree (cohort 2 imports
cohort 1; cohort 3 imports cohort 2). After the split, three parallel prover
sessions can advance independently: one on the substantive Čech acyclicity
theorem (file 3), one on the comparison-iso `HasCechToHModuleIso` instance
(file 2), and one in a brand-new file for Phase B differentials.

## Mathematical Justification

The cohort boundaries align with the dependency tree of the existing
declarations. No declaration in cohort 1 refers to a cohort-2 declaration; no
declaration in cohort 2 refers to a cohort-3 declaration. The proof bodies in
each cohort use only declarations from the same or earlier cohorts, plus
declarations from `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`
and Mathlib. The signature of every declaration is preserved verbatim; only
the file each declaration lives in changes.

Specifically:

- The Mathlib gap-fill `Abelian.Ext.chgUnivLinearEquiv` and its two private
  helpers `chgUniv_add` / `chgUniv_smul` are used in cohort 2 (specifically
  in `HModule_top_linearEquiv` at iter-032). Keeping them in cohort 1 is
  natural: they live in the `Abelian.Ext` namespace and they are the
  build-out the iter-032 universe bridge depends on.
- Cohort 2 opens `section AffineCoverMVSquare` at L639 and `section
  CoverTotality` at L757, both inside `namespace AlgebraicGeometry.Scheme`.
  The `CoverTotality` section spans L757 → L1870, crossing the cohort-2 /
  cohort-3 boundary at L1314 / L1315. Drop the `section CoverTotality`
  wrapper entirely (it is not load-bearing — it groups declarations
  thematically but no `variable` / `open` decls live inside it that would
  break if removed). The `section AffineCoverMVSquare` wrapper is closed at
  L755, fully inside cohort 2, and may be kept verbatim.
- All declarations live inside `namespace AlgebraicGeometry.Scheme`; each
  split file therefore opens and closes this namespace.

The two existing sorries inside `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`
(currently at L1722 and L1865 of the pre-split file) must be preserved
verbatim, including their inline comments. The iter-061 mechanical `rw`
conversion (`rw [HomologicalComplex.exactAt_iff,
ShortComplex.ShortExact.moduleCat_exact_iff_function_exact]`) and the iter-062
`h_a_fun` scaffolding inside this theorem must be preserved verbatim.

## Changes Requested

### 1. Create new file `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean`

Contents:

- Copyright header + module docstring (adapt the existing MV header to
  describe the MV LES core scope: chgUnivLinearEquiv plus the iter-016
  through iter-026 declarations).
- The existing imports of `MayerVietoris.lean`:
  - `import AlgebraicJacobian.Cohomology.StructureSheafModuleK`
  - `import Mathlib.CategoryTheory.Limits.Preorder`
- `set_option autoImplicit false`
- `universe u v w w'`
- `open CategoryTheory Limits TopologicalSpace AlgebraicGeometry`
- Lines 41–122 of the original file verbatim (Mathlib gap-fill cohort:
  `Abelian.Ext.chgUniv_add`, `Abelian.Ext.chgUniv_smul`,
  `Abelian.Ext.chgUnivLinearEquiv`).
- `namespace AlgebraicGeometry.Scheme`
- Lines 126–637 of the original file verbatim (MV LES core: iter-016 through
  iter-026; ends after `HModule'_fromBiprod_δ`).
- `end AlgebraicGeometry.Scheme`

### 2. Create new file `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean`

Contents:

- Copyright header + module docstring (describe scope: 2-affine cover MV,
  cover-totality bridges, finrank / Module.Finite transports,
  IsCechAcyclicCover consumers, HasCechToHModuleIso, HasAffineCechAcyclicCover).
- Imports:
  - `import AlgebraicJacobian.Cohomology.MayerVietorisCore`
- `set_option autoImplicit false`
- `universe u v w w'`
- `open CategoryTheory Limits TopologicalSpace AlgebraicGeometry`
- `namespace AlgebraicGeometry.Scheme`
- Lines 639–755 of the original verbatim (section AffineCoverMVSquare ... end
  AffineCoverMVSquare).
- Lines 759–1313 of the original verbatim, but **omit** the `section
  CoverTotality` line at L757 — paste the declarations themselves
  starting with the iter-031 docstring at L759. The last declaration in this
  file is `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` (ending
  at L1313 of the original).
- `end AlgebraicGeometry.Scheme`

### 3. Create new file `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`

Contents:

- Copyright header + module docstring (describe scope: basic-open cover
  wrappers and the substantive Čech acyclicity theorem).
- Imports:
  - `import AlgebraicJacobian.Cohomology.MayerVietorisCover`
- `set_option autoImplicit false`
- `universe u v`
- `open CategoryTheory Limits TopologicalSpace AlgebraicGeometry`
- `namespace AlgebraicGeometry.Scheme`
- Lines 1315–1869 of the original verbatim (all `basicOpenCover` family
  declarations + `cechCohomology_subsingleton_of_cechCochain_exactAt` +
  `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`). The two sorries inside
  `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` and the iter-062 `h_a_fun`
  scaffolding must be preserved exactly. The `end CoverTotality` line at
  L1870 must be **omitted** (since the section was dropped).
- `end AlgebraicGeometry.Scheme`

### 4. Delete `AlgebraicJacobian/Cohomology/MayerVietoris.lean`

The original 1872-LOC file is fully redistributed by the three new files
above. Delete it.

### 5. Update `AlgebraicJacobian.lean`

Replace the line
```
import AlgebraicJacobian.Cohomology.MayerVietoris
```
with
```
import AlgebraicJacobian.Cohomology.MayerVietorisCore
import AlgebraicJacobian.Cohomology.MayerVietorisCover
import AlgebraicJacobian.Cohomology.BasicOpenCech
```

### 6. No other files require modification

`Jacobian.lean`, `AbelJacobi.lean`, `Genus.lean`, `Rigidity.lean`, the Picard
files, `SheafCompose.lean`, `StructureSheafAb.lean`, and
`StructureSheafModuleK.lean` do not import `MayerVietoris.lean` and are
unaffected.

The blueprint chapter `blueprint/src/chapters/Cohomology_MayerVietoris.tex`
is **not** modified by you. The plan agent will split the blueprint chapter
in a future iteration; for this refactor the single consolidated chapter
remains in place and the new Lean files all reference it via the file
docstrings.

## Affected Files

- **Created**: `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean`,
  `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean`,
  `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`.
- **Deleted**: `AlgebraicJacobian/Cohomology/MayerVietoris.lean`.
- **Modified**: `AlgebraicJacobian.lean` (import list).

No other Lean files import `MayerVietoris.lean` (confirmed via grep).

## Expected Outcome

- The three new files compile cleanly with the same warnings/errors as the
  original (i.e. one `declaration uses 'sorry'` warning per remaining sorry
  inside `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` in `BasicOpenCech.lean`).
- Project-wide sorry count remains at exactly **11**: 5 in `Jacobian.lean`, 3
  in `AbelJacobi.lean`, 1 in `Picard/Functor.lean`, 2 in the new
  `Cohomology/BasicOpenCech.lean` (both inside the substantive Čech
  acyclicity theorem at the iter-062 positions, preserved verbatim).
- `AlgebraicJacobian.lean` re-exports all three new files.
- No new axioms are introduced.
- No protected signature is touched.
- The deleted file is gone; the three new files together span the LOC of
  the original (~1872 LOC ± a few lines for headers).
