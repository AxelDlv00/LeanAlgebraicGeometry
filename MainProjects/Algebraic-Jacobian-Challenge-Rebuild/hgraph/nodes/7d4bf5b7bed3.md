---
author: sync
content_type: definition
created: '2026-07-31T22:54:04'
decl: CategoryTheory.Functor.RepresentableBy.Over.mapCompPresheafOfEq
docstring: The presheaf-level composite comparison with an explicit equality of base
  maps.
file: AlgebraicJacobian/Picard/RepresentableByCocycle.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Functor.RepresentableBy.Over.mapCompPresheafOfEq
type: lean
updated: '2026-07-31T22:54:04'
---
noncomputable def Over.mapCompPresheafOfEq
    {D : Type u} [Category.{v, u} D]
    {X Y Z : D} (r : X ⟶ Z) (f : X ⟶ Y) (g : Y ⟶ Z)
    (h : r = f ≫ g) (F : (Over Z)ᵒᵖ ⥤ Type v) :
    (Over.map r).op ⋙ F ≅
      (Over.map f).op ⋙ ((Over.map g).op ⋙ F) :=
  eqToIso (congrArg (fun m => (Over.map m).op ⋙ F) h) ≪≫
    Functor.isoWhiskerRight (NatIso.op (Over.mapComp f g)).symm F