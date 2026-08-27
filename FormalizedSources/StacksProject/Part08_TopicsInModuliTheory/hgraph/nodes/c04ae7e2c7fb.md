---
author: sync
content_type: instance
created: '2026-08-28T04:49:25'
decl: StacksPart08.schemeSeparatedFinitePresentation_containsIdentities
file: StacksPart08Lib/MorphismProperties.lean
generated: lean
lean_status: lean_ok
title: StacksPart08.schemeSeparatedFinitePresentation_containsIdentities
type: lean
updated: '2026-08-28T04:49:25'
---
instance schemeSeparatedFinitePresentation_containsIdentities :
    MorphismProperty.ContainsIdentities schemeSeparatedFinitePresentation where
  id_mem X := ⟨inferInstance, schemeFinitePresentation_id X⟩