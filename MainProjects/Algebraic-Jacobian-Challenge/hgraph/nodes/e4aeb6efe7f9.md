---
author: sync
content_type: instance
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.overEquivalence_functor_isContinuous_toScheme
docstring: 'Continuity of `overEquivalence.functor` phrased for the open-subscheme
  carrier (defeq to the

  plain subtype, but instance search needs the `toScheme` form to fire).'
file: AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.overEquivalence_functor_isContinuous_toScheme
type: lean
updated: '2026-07-16T21:14:26'
---
instance overEquivalence_functor_isContinuous_toScheme (g : R) :
    (Opens.overEquivalence (specBasicOpen g)).functor.IsContinuous
      ((Opens.grothendieckTopology ↥(Spec R)).over (specBasicOpen g))
      (Opens.grothendieckTopology ↥(specBasicOpen g).toScheme) :=
  Opens.overEquivalence_functor_isContinuous (specBasicOpen g)