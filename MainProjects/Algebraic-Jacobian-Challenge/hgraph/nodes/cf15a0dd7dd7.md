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

  `F.map_sum` together with `Functor.map_zsmul` (both available since `F` is additive).'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.map_alternatingCofaceMapComplex_objD
type: lean
updated: '2026-07-27T01:33:11'
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