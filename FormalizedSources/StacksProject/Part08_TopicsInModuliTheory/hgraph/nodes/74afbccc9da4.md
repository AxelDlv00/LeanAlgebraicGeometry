---
author: sync
content_type: theorem
created: '2026-08-28T04:49:25'
decl: StacksPart08.schemeSeparatedFinitePresentation_id
file: StacksPart08Lib/MorphismProperties.lean
generated: lean
lean_status: lean_ok
title: StacksPart08.schemeSeparatedFinitePresentation_id
type: lean
updated: '2026-08-28T04:49:25'
---
theorem schemeSeparatedFinitePresentation_id (X : Scheme) :
    schemeSeparatedFinitePresentation (𝟙 X) :=
  MorphismProperty.ContainsIdentities.id_mem X