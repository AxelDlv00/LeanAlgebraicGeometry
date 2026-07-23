---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: PresheafOfModules.InternalHom.restrictionMap_add
docstring: '**`restrictionMap` is additive.** Part of the additivity assertion of
  blueprint

  `lem:presheaf_internal_hom_restriction`.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate/PresheafInternalHom.lean
generated: lean
lean_status: lean_ok
title: PresheafOfModules.InternalHom.restrictionMap_add
type: lean
updated: '2026-07-24T03:02:12'
---
lemma restrictionMap_add {U V : C} (g : V ⟶ U)
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ CommRingCat RingCat)}
    (φ ψ : restr U M ⟶ restr U N) :
    restrictionMap g (φ + ψ) = restrictionMap g φ + restrictionMap g ψ := by
  ext1 X; rfl