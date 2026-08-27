---
author: sync
content_type: theorem
created: '2026-08-28T00:07:20'
decl: StacksPart08.relativeMorphismProperty_property
docstring: The defining property of a represented pullback.
file: StacksPart08Lib/Representability.lean
generated: lean
lean_status: lean_ok
title: StacksPart08.relativeMorphismProperty_property
type: lean
updated: '2026-08-28T00:07:20'
---
theorem relativeMorphismProperty_property {C : Type u} [Category.{v} C]
    {D : Type u'} [Category.{v'} D] {F : C ⥤ D} {P : MorphismProperty C}
    {X Y : D} {f : X ⟶ Y} (hf : RelativeMorphismProperty F P f)
    {a b : C} (g : F.obj a ⟶ Y) (fst : F.obj b ⟶ X) (snd : b ⟶ a)
    (sq : IsPullback fst (F.map snd) f g) : P snd :=
  hf.property g fst snd sq