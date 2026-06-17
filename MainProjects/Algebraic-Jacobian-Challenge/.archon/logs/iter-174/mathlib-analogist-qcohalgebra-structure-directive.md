# Mathlib Analogist Directive

## Slug
qcohalgebra-structure

## Mode
api-alignment

## Iteration
174

## Project context

`AlgebraicJacobian/Picard/RelativeSpec.lean` (NEW iter-173) carries a TYPE-level placeholder

```
noncomputable def Scheme.QcohAlgebra (X : Scheme.{u}) : Type (u+1) := sorry
```

at L98 (the lean-auditor `iter173` flagged this as a must-fix-this-iter critical placeholder). All six pinned declarations in the file (`RelativeSpec`, `UniversalProperty`, `affine_base_iff`, `base_change`, `functor`, plus the helper `structureMorphism`) quantify over `X.QcohAlgebra` — the entire file's substantive content rests on this carrier type.

The blueprint (`Picard_RelativeSpec.tex`) describes `QcohAlgebra X` informally as "a quasi-coherent `O_X`-algebra: an `O_X`-module of finite presentation, equipped with a commutative-monoid-object structure in the monoidal category of `O_X`-modules". This is the Stacks 01LE / Stacks 01M9 notion.

## Specific question

I'm about to commit a Lean structure of the form

```
structure Scheme.QcohAlgebra (X : Scheme.{u}) where
  modules : ??? -- SheafOfModules X.ringCatSheaf?
  qcoh : ??? -- QuasiCoherent modules?
  monClass : Mon_Class ??? -- monoid-object structure
  comm : ??? -- commutativity witness
```

**My question**: what is the **right** Mathlib-aligned structure shape for `QcohAlgebra X`?

Concretely:

1. **Does Mathlib (at the project's pinned commit `b80f227`) provide a sheaf-of-algebras notion under any name?** Check:
   - `Mathlib.AlgebraicGeometry.Sheaf.Mon_Class`
   - `Mathlib.CategoryTheory.Sheaf.AlgebraCat`
   - `Mathlib.AlgebraicGeometry.AffineCover.Algebra`
   - `Mathlib.CategoryTheory.Monoidal.Comon_` / `Mathlib.CategoryTheory.Monoidal.Internal.Modules`
   - `Mathlib.AlgebraicGeometry.SheafOfModules`

2. **If absent**, propose the structure shape. Three candidates:
   - (A) `SheafOfModules X.ringCatSheaf` + `QuasiCoherent` predicate + `Mon_Class` monoid + commutativity.
   - (B) The functorial form: `(X.openSets)^op ⥤ CommAlgCat (Γ(X,O_X))` plus a "qcoh on every restriction" predicate.
   - (C) An entirely typeclass-based form: `[QcohAlgebraStr X (𝒜 : ???)]`.

3. **For the Yoneda universal property of `RelativeSpec`**: which structure shape lets Mathlib's `Mathlib.CategoryTheory.Yoneda` machinery cleanly express `Hom_{O_X-alg}(𝒜, g_* O_T)`? Verify whether `CommAlgCat` or `Mon_Class.Hom` is the right Hom-set source.

4. **Cross-domain analogue**: how does Mathlib handle "sheaf of rings" (`Mathlib.AlgebraicGeometry.Spec`) and how does that translate to sheaf-of-algebras? Pull the precedent.

## Failed approaches

- iter-173 file-skeleton landed `QcohAlgebra := sorry` at the type level deliberately, with iter-174+ refinement plan in the docstring (cf. `Picard/RelativeSpec.lean:74-97`). The plan calls for a 3-component structure but doesn't commit to which 3 components — the choice depends on what Mathlib offers.

## Search radius
narrow (`Mathlib.AlgebraicGeometry`, `Mathlib.CategoryTheory.Monoidal`, `Mathlib.CategoryTheory.Sheaf`).

## What I need

1. Verification of which (if any) Mathlib types implement "sheaf of `O_X`-algebras" at the pinned commit.
2. A concrete proposed structure body for `Scheme.QcohAlgebra X` with named Mathlib types for each field.
3. Recipe for the Yoneda Hom-set required by `UniversalProperty`.
4. Estimated LOC for the body lane (iter-175+ work).

## Output

Persist as `analogies/qcohalgebra-structure.md`. Report under `task_results/mathlib-analogist-qcohalgebra-structure.md`.
