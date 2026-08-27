---
author: sync
content_type: theorem
created: '2026-08-28T00:07:20'
decl: StacksPart08.relativeMorphismProperty_baseChange
docstring: Relative morphism properties are stable under base change.
file: StacksPart08Lib/Representability.lean
generated: lean
lean_status: lean_ok
title: StacksPart08.relativeMorphismProperty_baseChange
type: lean
updated: '2026-08-28T00:07:20'
---
theorem relativeMorphismProperty_baseChange {C : Type u} [Category.{v} C]
    {D : Type u'} [Category.{v'} D] {F : C ⥤ D} {P : MorphismProperty C}
    {X Y Y' S : D} {f : X ⟶ S} {g : Y ⟶ S}
    {f' : Y' ⟶ Y} {g' : Y' ⟶ X}
    (sq : IsPullback f' g' g f)
    (hg : RelativeMorphismProperty F P g) :
    RelativeMorphismProperty F P g' := by
  exact (MorphismProperty.relative_isStableUnderBaseChange P).of_isPullback sq hg

/-! ### Comparison criteria -/