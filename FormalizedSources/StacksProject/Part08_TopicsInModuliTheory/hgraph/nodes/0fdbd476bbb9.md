---
author: sync
content_type: definition
created: '2026-08-28T00:50:17'
decl: StacksPart08.schemeClosedFinitePresentation
docstring: A closed immersion equipped with the finite-presentation hypotheses.
file: StacksPart08Lib/MorphismProperties.lean
generated: lean
lean_status: lean_ok
title: StacksPart08.schemeClosedFinitePresentation
type: lean
updated: '2026-08-28T00:50:17'
---
def schemeClosedFinitePresentation : MorphismProperty Scheme :=
  @IsClosedImmersion ⊓ schemeFinitePresentation

@[simp]