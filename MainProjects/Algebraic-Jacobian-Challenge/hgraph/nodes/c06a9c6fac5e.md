---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.freeYonedaAug_app_comp
docstring: 'Evaluated naturality of the augmentation: `(eval V)` applied to the free-presheaf
  restriction

  `freeYoneda.map (homOfLE h₁)` followed by the augmentation over the larger open
  equals the

  augmentation over the smaller open. The `.app`-level form of `freeYoneda_map_comp_aug`.'
file: AlgebraicJacobian/Cohomology/FreePresheafComplex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.freeYonedaAug_app_comp
type: lean
updated: '2026-07-16T21:14:26'
---
private lemma freeYonedaAug_app_comp {A B V : TopologicalSpace.Opens ↥X} (h₁ : A ≤ B) :
    (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).map
        (freeYoneda.map (homOfLE h₁)) ≫ (freeYonedaAug B).app (Opposite.op V)
      = (freeYonedaAug A).app (Opposite.op V) := by
  rw [PresheafOfModules.evaluation_map, ← freeYoneda_map_comp_aug h₁, PresheafOfModules.comp_app]
  rfl