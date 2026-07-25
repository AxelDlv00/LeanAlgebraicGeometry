---
author: sync
content_type: definition
created: '2026-07-25T08:32:26'
decl: AlgebraicGeometry.cechSectionZeroCoord
docstring: 'The degree-zero product coordinate, kept opaque so composition can be
  transported without

  unfolding the full dependent product equivalence.'
file: AlgebraicJacobian/Cohomology/CechSectionContractibilityOne.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechSectionZeroCoord
type: lean
updated: '2026-07-25T22:02:35'
---
noncomputable def cechSectionZeroCoord (σ : Fin 1 → 𝒰.I₀)
    (t : ToType ((cechSectionAugComplex 𝒰 F V).X 1)) : cechSectionCoeff 𝒰 F V 1 σ :=
  sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
    ((SheafOfModules.forget X.ringCatSheaf).obj F) 0 t σ