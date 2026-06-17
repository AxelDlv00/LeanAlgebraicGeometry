# Refactor Directive

## Slug

trim-iter117

## Problem

The user's iter-117 directive overrides the project's prior strategy of
shipping a large surface with named-deferred Mathlib gaps. The new
strategy is **aggressive trim**: delete every inline `sorry` site that
is orphan to the protected chain (the 9 declarations in
`archon-protected.yaml`), leaving exactly one `sorry` site (the
single explicit foundational existence hypothesis
`nonempty_jacobianWitness`). After the trim, the project ships an
honest framework on top of one named existence assumption.

Verified dependency facts (the trim is safe — these are leaf files):

- `Cohomology/BasicOpenCech.lean` is only imported by the umbrella
  `AlgebraicJacobian.lean`.
- `Modules/Monoidal.lean` → `Picard/LineBundle.lean` →
  `Picard/Functor.lean` → `Picard/FunctorAb.lean` is a leaf chain;
  only the umbrella imports these.
- `Differentials.lean` is only imported by the umbrella.
- `Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean`, `Rigidity.lean`,
  the cohomology files `SheafCompose.lean` / `StructureSheafAb.lean` /
  `StructureSheafModuleK.lean` / `MayerVietorisCore.lean` /
  `MayerVietorisCover.lean` all stay. No protected declaration
  transitively consumes the to-be-deleted material.

## Mathematical Justification

- The 9 protected declarations all reduce to `nonempty_jacobianWitness`
  at `Jacobian.lean:179` via the witness pattern in `Jacobian.lean` and
  `AbelJacobi.lean`. None require the cotangent exact sequence, the
  sheaf condition for `relativeDifferentialsPresheaf`, the Picard arc,
  the basic-open Čech-acyclicity machinery, the monoidal structure on
  `(W X)`, or the Serre-duality genus identity.
- `Genus.lean` defines `genus C := Module.finrank k (Scheme.HModule k
  (Scheme.toModuleKSheaf C) 1)` using the *Mayer–Vietoris-based*
  `HModule` cohomology. It does not transit through `BasicOpenCech.lean`.
- The smoothness-iff lemma `smooth_iff_locally_free_omega` is the one
  piece of `Differentials.lean` worth keeping in the active project; it
  can be stated entirely against the **presheaf** form
  `relativeDifferentialsPresheaf` without needing the sheaf-bundled
  `relativeDifferentials`. The current statement transits through the
  sheafified `relativeDifferentials` via
  `(relativeDifferentials f).val.obj`; refactoring to
  `(relativeDifferentialsPresheaf f).presheaf.obj` is type-correct, and
  the iff is the same mathematical claim (free-of-rank-`n` is a
  pointwise property of the underlying module).
- `cotangent_at_section`, `cotangent_exact_sequence`, `serre_duality_genus`,
  and the cotangent-exact-sequence machinery (`cotangentExactSeq{Alpha,Beta,_structure}`,
  `cotangentExactSeqBeta_hη`, `cotangent_exact_sequence`) all transit
  through the sheaf-bundled `relativeDifferentials` AND/OR
  `Scheme.Modules.pullback`/`SheafOfModules.exact_iff_stalkwise`
  Mathlib gaps; their closure is project-external and they are removed
  from active scope.

## Changes Requested

### File deletions (5 files)

Delete the following files entirely:

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`
- `AlgebraicJacobian/Modules/Monoidal.lean`
- `AlgebraicJacobian/Picard/LineBundle.lean`
- `AlgebraicJacobian/Picard/Functor.lean`
- `AlgebraicJacobian/Picard/FunctorAb.lean`

(If `AlgebraicJacobian/Modules/` becomes empty, also delete the
`Modules/` directory. Same for `AlgebraicJacobian/Picard/`.)

### `AlgebraicJacobian.lean` (umbrella)

Replace the current import list with:

```lean
import AlgebraicJacobian.Cohomology.SheafCompose
import AlgebraicJacobian.Cohomology.StructureSheafAb
import AlgebraicJacobian.Cohomology.StructureSheafModuleK
import AlgebraicJacobian.Cohomology.MayerVietorisCore
import AlgebraicJacobian.Cohomology.MayerVietorisCover
import AlgebraicJacobian.Differentials
import AlgebraicJacobian.Rigidity
import AlgebraicJacobian.Genus
import AlgebraicJacobian.Jacobian
import AlgebraicJacobian.AbelJacobi
```

### `AlgebraicJacobian/Differentials.lean` (heavy trim)

Replace the entire file with a small version that contains ONLY:

1. The file header (copyright, module-doc, imports, options, universe,
   `open` clauses).
2. `namespace AlgebraicGeometry.Scheme`.
3. `noncomputable def relativeDifferentialsPresheaf` (current L59).
4. `theorem relativeDifferentialsPresheaf_obj_kaehler` (current L90).
5. `theorem smooth_iff_locally_free_omega` REFACTORED to use the
   presheaf form (see exact new signature below).
6. `end AlgebraicGeometry.Scheme`.

The refactored `smooth_iff_locally_free_omega` signature:

```lean
/-- Smoothness of a finite-presentation morphism is equivalent to
the relative differential presheaf being locally free of the given
rank on every affine open.

The forward direction is the Jacobian criterion via
`Algebra.IsStandardSmoothOfRelativeDimension.basis_kaehlerDifferential`
on affine charts; the converse follows from
`Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential`. -/
theorem smooth_iff_locally_free_omega (f : X ⟶ S)
    (hfp : AlgebraicGeometry.LocallyOfFinitePresentation f) (n : ℕ) :
    AlgebraicGeometry.IsSmoothOfRelativeDimension n f ↔
      ∀ (x : X), ∃ (U : X.Opens), x ∈ U.1 ∧ IsAffineOpen U ∧
        let R := X.ringCatSheaf.presheaf.obj (.op U)
        let M := (relativeDifferentialsPresheaf f).presheaf.obj (.op U)
        Module.Free (↑R) (↑M) ∧ Module.rank (↑R) (↑M) = n := by
  sorry
```

Remove the deprecation-suppression `set_option` blocks and the
heartbeat-budget-lifting blocks attached to declarations being
deleted.

The imports list at the top of `Differentials.lean` should be pruned
to only what `relativeDifferentialsPresheaf` and
`smooth_iff_locally_free_omega` actually need. Suggested minimal
imports:

```lean
import Mathlib.RingTheory.Kaehler.Basic
import Mathlib.AlgebraicGeometry.AffineScheme
import Mathlib.AlgebraicGeometry.Morphisms.FinitePresentation
import Mathlib.AlgebraicGeometry.Morphisms.Smooth
import Mathlib.Algebra.Category.ModuleCat.Differentials.Presheaf
import Mathlib.AlgebraicGeometry.Modules.Presheaf
```

(Drop `Mathlib.Algebra.Category.ModuleCat.Sheaf`,
`Mathlib.AlgebraicGeometry.Modules.Sheaf`,
`AlgebraicJacobian.Cohomology.StructureSheafModuleK` — none of these
are needed by the surviving declarations. If a compile error reveals
one IS needed, restore the specific minimal import.)

The replacement file should be around ~80-110 lines total (header +
3 declarations).

### Module docstring

Update the file's module docstring (the `/-! ... -/` block at the
top) to honestly describe what the trimmed file contains: the
presheaf of relative Kähler differentials and the smoothness-iff-
locally-free characterisation. Drop references to the cotangent
exact sequence, Serre duality, the sheaf condition, and the
`cotangent_at_section` corollary — those are no longer part of the
active project.

## Affected Files

After the changes, the following files MUST compile clean (verify
with `lean_diagnostic_messages` after each):

- `AlgebraicJacobian.lean` (with the trimmed imports).
- `AlgebraicJacobian/Differentials.lean` (the rewritten short version).
- `AlgebraicJacobian/Rigidity.lean` (untouched; should still compile).
- `AlgebraicJacobian/Genus.lean` (untouched; should still compile).
- `AlgebraicJacobian/Jacobian.lean` (untouched; should still compile
  with its 1 inline sorry on `nonempty_jacobianWitness`).
- `AlgebraicJacobian/AbelJacobi.lean` (untouched).
- `AlgebraicJacobian/Cohomology/SheafCompose.lean` (untouched).
- `AlgebraicJacobian/Cohomology/StructureSheafAb.lean` (untouched).
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` (untouched).
- `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean` (untouched).
- `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean` (untouched).

The deleted files are:

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`
- `AlgebraicJacobian/Modules/Monoidal.lean`
- `AlgebraicJacobian/Picard/LineBundle.lean`
- `AlgebraicJacobian/Picard/Functor.lean`
- `AlgebraicJacobian/Picard/FunctorAb.lean`

The `Modules/` and `Picard/` directories should be empty after these
deletions; delete the empty directories if your file system reflects
them as such.

## Stale-comment cleanup (after the deletions)

The two surviving Mayer–Vietoris files have docstrings that mention
the deleted `BasicOpenCech.lean`:

- `Cohomology/MayerVietorisCore.lean:23` —
  `* `BasicOpenCech.lean`: basic-open cover wrappers …`
- `Cohomology/MayerVietorisCover.lean:25` —
  `* `BasicOpenCech.lean`: basic-open cover wrappers …`

Delete these one-line cross-references from the file overview block
in each file (the lines that name `BasicOpenCech.lean`). Leave the
rest of the docstrings untouched. No other content change to these
two files.

`Jacobian.lean:173` has a long-form docstring on `nonempty_jacobianWitness`
mentioning that "Mathlib currently contains neither Pic-scheme
representability, nor symmetric powers / quotients of schemes by
finite group actions". Leave that docstring untouched; it is the
correct honest disclosure.

## Expected Outcome

After the trim:

- Total inline `sorry` count across the project: **2**.
  - `AlgebraicJacobian/Differentials.lean` — `smooth_iff_locally_free_omega`
    body (refactored, presheaf-form).
  - `AlgebraicJacobian/Jacobian.lean` — `nonempty_jacobianWitness`
    body (unchanged; the single explicit foundational hypothesis).
- All files compile with no errors. Pre-existing cosmetic warnings on
  `Differentials.lean` (2 `IsSmoothOfRelativeDimension` deprecations
  + 1 line-length linter) should DISAPPEAR after the trim because the
  affected lines are deleted.
- No axioms introduced.
- `archon-protected.yaml` is unchanged. All 9 protected declarations
  remain at their current file paths; none of them are modified.

If a downstream file (most likely `Genus.lean`, `Jacobian.lean`,
`AbelJacobi.lean`, or one of the cohomology files) fails to compile
after the trim, treat that as a directive error rather than fixing
it silently: pause, report the unexpected dependency in your "Notes
for Plan Agent" section, and only fix the breakage if the fix is
narrow and obvious (e.g. drop a stale `open` clause).

## Verification rubric for your report

In your "Compilation Status" section, list every `.lean` file under
`AlgebraicJacobian/` after the trim and its diagnostic status from
`lean_diagnostic_messages`. The post-trim project should have:

- 0 errors.
- 0 axiom declarations.
- 2 inline `sorry` sites (the two named above).
- 0 declarations from `BasicOpenCech.lean`, `Modules/Monoidal.lean`,
  `Picard/LineBundle.lean`, `Picard/Functor.lean`,
  `Picard/FunctorAb.lean` — these files no longer exist.

Do NOT update the blueprint chapters. The plan agent will dispatch
blueprint-writers to rewrite them in the same iteration.
