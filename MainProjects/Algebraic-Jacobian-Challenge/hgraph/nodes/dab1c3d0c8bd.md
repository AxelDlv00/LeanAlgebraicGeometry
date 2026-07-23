---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.coverCechNerveOverAug
docstring: 'The over-category Čech backbone as an **augmented** simplicial object
  in `Over X`:

  `coverCechNerveOver` augmented by the terminal object `Over.mk (𝟙 X)` of `Over X`.
  The

  augmentation map at each simplicial level is the unique morphism to the terminal
  object

  (its underlying scheme map is the level''s structure map to `X`), and the augmentation

  coherence condition holds automatically because the augmentation target is terminal.

  Project-local.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.coverCechNerveOverAug
type: lean
updated: '2026-07-24T03:02:09'
---
noncomputable def coverCechNerveOverAug (𝒰 : X.OpenCover) :
    SimplicialObject.Augmented (Over X) :=
  SimplicialObject.augment (coverCechNerveOver 𝒰) (Over.mk (𝟙 X))
    (Over.mkIdTerminal.from _)
    (fun _ _ _ => Over.mkIdTerminal.hom_ext _ _)