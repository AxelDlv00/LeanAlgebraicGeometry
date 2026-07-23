---
author: sync
content_type: instance
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.smoothOfRelativeDimension_one_hom_baseChangeField
docstring: 'Smoothness of relative dimension `1` is stable under the field base change

  (`smoothOfRelativeDimension_isStableUnderBaseChange`, extraction of the inline

  recipe at `RiemannRoch/Adelic/NonconstantToP1.lean:986-989`).'
file: AlgebraicJacobian/RiemannRoch/CurveBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.smoothOfRelativeDimension_one_hom_baseChangeField
type: lean
updated: '2026-07-16T21:14:28'
---
instance smoothOfRelativeDimension_one_hom_baseChangeField
    [SmoothOfRelativeDimension 1 C.hom] :
    SmoothOfRelativeDimension 1 (baseChangeField C κ).hom :=
  haveI : MorphismProperty.IsStableUnderBaseChange (@SmoothOfRelativeDimension 1) :=
    smoothOfRelativeDimension_isStableUnderBaseChange 1
  MorphismProperty.pullback_snd _ _ ‹SmoothOfRelativeDimension 1 C.hom›