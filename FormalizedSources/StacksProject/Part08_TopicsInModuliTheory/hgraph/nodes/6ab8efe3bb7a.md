---
author: sync
content_type: definition
created: '2026-08-28T04:49:25'
decl: StacksPart08.schemeSeparatedFinitePresentation
docstring: A separated morphism equipped with the finite-presentation hypotheses.
file: StacksPart08Lib/MorphismProperties.lean
generated: lean
lean_status: lean_ok
title: StacksPart08.schemeSeparatedFinitePresentation
type: lean
updated: '2026-08-28T04:49:25'
---
def schemeSeparatedFinitePresentation : MorphismProperty Scheme :=
  @IsSeparated ⊓ schemeFinitePresentation

@[simp]