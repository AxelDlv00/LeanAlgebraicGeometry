---
author: sync
content_type: theorem
created: '2026-08-01T05:12:59'
decl: CategoryTheory.Functor.RepresentableBy.Over.mapCompPresheafOfEq_eq_canonical
docstring: 'The existing comparison and the canonical equality-transport comparison

  are definitionally the same up to `mapComp_eqToIso`.'
file: AlgebraicJacobian/Picard/RepresentableByTransport.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Functor.RepresentableBy.Over.mapCompPresheafOfEq_eq_canonical
type: lean
updated: '2026-08-01T09:44:17'
---
theorem mapCompPresheafOfEq_eq_canonical
    {X Y Z : D} (r : X ⟶ Z) (f : X ⟶ Y) (g : Y ⟶ Z)
    (h : r = f ≫ g) (F : (CategoryTheory.Over Z)ᵒᵖ ⥤ Type v) :
    CategoryTheory.Functor.RepresentableBy.Over.mapCompPresheafOfEq
        r f g h F = mapCompPresheafCanonical r f g h F := by
  simp [CategoryTheory.Functor.RepresentableBy.Over.mapCompPresheafOfEq,
    mapCompPresheafCanonical, mapComp_eqToIso]