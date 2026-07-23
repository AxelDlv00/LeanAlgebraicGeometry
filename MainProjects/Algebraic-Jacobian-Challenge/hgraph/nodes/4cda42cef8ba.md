---
author: sync
content_type: instance
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.HModule'_shortComplex_g_epi
docstring: 'Phase A step 6 *Path 2* (iter-020): `(HModule''_shortComplex k S).g` is
  an

  epimorphism in `Sheaf J (ModuleCat k)`. Direct mirror of Mathlib''s

  `MayerVietorisSquare.lean` L259–261 with `AddCommGrpCat.free → ModuleCat.free k`.

  The proof is a one-line term-mode body using

  `ShortComplex.exact_and_epi_g_iff_g_is_cokernel` and the iter-019 lemma

  `HModule''_isPushoutModuleCatFreeSheaf`''s `isColimitCokernelCofork` accessor.'
file: AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.HModule'_shortComplex_g_epi
type: lean
updated: '2026-07-16T21:14:26'
---
instance HModule'_shortComplex_g_epi
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    (S : J.MayerVietorisSquare) :
    Epi (HModule'_shortComplex k S).g :=
  ((HModule'_shortComplex k S).exact_and_epi_g_iff_g_is_cokernel.2
    ⟨(HModule'_isPushoutModuleCatFreeSheaf k S).isColimitCokernelCofork⟩).2