---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.HModule'_shortComplex
file: AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.HModule'_shortComplex
type: lean
updated: '2026-07-24T03:02:09'
---
noncomputable def HModule'_shortComplex
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    (S : J.MayerVietorisSquare) :
    ShortComplex (Sheaf J (ModuleCat.{u} k)) where
  X₁ := (presheafToSheaf J _).obj (yoneda.obj S.X₁ ⋙ ModuleCat.free k)
  X₂ := (presheafToSheaf J _).obj (yoneda.obj S.X₂ ⋙ ModuleCat.free k) ⊞
    (presheafToSheaf J _).obj (yoneda.obj S.X₃ ⋙ ModuleCat.free k)
  X₃ := (presheafToSheaf J _).obj (yoneda.obj S.X₄ ⋙ ModuleCat.free k)
  f :=
    biprod.lift
      ((presheafToSheaf J _).map (Functor.whiskerRight (yoneda.map S.f₁₂) _))
      (-(presheafToSheaf J _).map (Functor.whiskerRight (yoneda.map S.f₁₃) _))
  g :=
    biprod.desc
      ((presheafToSheaf J _).map (Functor.whiskerRight (yoneda.map S.f₂₄) _))
      ((presheafToSheaf J _).map (Functor.whiskerRight (yoneda.map S.f₃₄) _))
  zero :=
    (S.map (yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k) ⋙
        presheafToSheaf J _)).cokernelCofork.condition

/-- Phase A step 6 *Path 2* (iter-020 helper, Mathlib gap-fill): the free-module
functor `ModuleCat.free k : Type u ⥤ ModuleCat.{u} k` preserves monomorphisms.
Mathlib registers `AddCommGrpCat.instPreservesMonomorphismsFree :
AddCommGrpCat.free.PreservesMonomorphisms` in
`Mathlib/Algebra/Category/Grp/Adjunctions.lean` but does not register the
corresponding instance for `ModuleCat.free k` in
`Mathlib/Algebra/Category/ModuleCat/Adjunctions.lean`. This project-local