---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.map_alternatingCofaceMapComplex_objD
docstring: '**An additive functor commutes with the alternating coface differential.**
  For an

  additive functor `F : C ⥤ D` and a cosimplicial object `Y`, applying `F` to the

  degree-`n` alternating coface differential `objD Y n = ∑ᵢ (-1)ⁱ • Yδᵢ` equals the

  alternating coface differential of the post-composed cosimplicial object `Y ⋙ F`.
  This is

  `F.map_sum` together with `Functor.map_zsmul` (both available since `F` is additive).

  Project-local.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.map_alternatingCofaceMapComplex_objD
type: lean
updated: '2026-07-16T21:14:26'
---
theorem map_alternatingCofaceMapComplex_objD (F : C ⥤ D) [F.Additive]
    (Y : CosimplicialObject C) (i : ℕ) :
    F.map (AlternatingCofaceMapComplex.objD Y i)
      = AlternatingCofaceMapComplex.objD
          (((CosimplicialObject.whiskering C D).obj F).obj Y) i := by
  rw [AlternatingCofaceMapComplex.objD, AlternatingCofaceMapComplex.objD, Functor.map_sum]
  apply Finset.sum_congr rfl
  intro k _
  rw [Functor.map_zsmul]
  rfl

/-- **Additive functors commute with `alternatingCofaceMapComplex`.** For an additive
functor `F : C ⥤ D` and a cosimplicial object `Y` in `C`, applying `F` degreewise to the
alternating coface map cochain complex of `Y` yields the alternating coface map cochain
complex of the post-composed cosimplicial object `F ∘ Y`:
`F.mapHomologicalComplex (alternatingCofaceMapComplex Y) ≅ alternatingCofaceMapComplex (F ∘ Y)`.
The degreewise components are identities (the degree-`n` terms are `F.obj (Y.obj [n])` on
both sides) and the differential compatibility is `map_alternatingCofaceMapComplex_objD`.
This is the cosimplicial-altitude brick (step (b)) used to push `g^*` into the relative
Čech complex `relativeCechComplexOfNerve`. Project-local Mathlib supplement. -/
-- (v4.31.0: `CechToHigherDirectImage` also defines a public `mapAlternatingCofaceMapComplexIso`
-- — that file never compiled before the migration so the name clash was latent; now that it
-- builds, both being public collides at the root import. This copy is used only inside this file,
-- so mark it `private` to resolve the clash without rebuilding the 4.3 h `CechToHigherDirectImage`.)