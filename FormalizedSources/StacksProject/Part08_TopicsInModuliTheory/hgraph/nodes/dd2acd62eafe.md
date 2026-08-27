---
author: sync
content_type: theorem
created: '2026-08-28T00:50:17'
decl: StacksPart08.schemeAffineFinitePresentation_baseChange
file: StacksPart08Lib/MorphismProperties.lean
generated: lean
lean_status: lean_ok
title: StacksPart08.schemeAffineFinitePresentation_baseChange
type: lean
updated: '2026-08-28T00:50:17'
---
theorem schemeAffineFinitePresentation_baseChange {X Y S : Scheme}
    (f : X ⟶ S) (g : Y ⟶ S) [IsAffineHom f]
    [LocallyOfFinitePresentation f] [QuasiCompact f] :
    schemeAffineFinitePresentation (pullback.snd f g) := by
  exact MorphismProperty.pullback_snd (P := schemeAffineFinitePresentation) f g
    ⟨inferInstance, ⟨inferInstance, inferInstance⟩⟩