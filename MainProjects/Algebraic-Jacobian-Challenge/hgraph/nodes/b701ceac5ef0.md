---
author: sync
content_type: lemma
created: '2026-07-25T08:02:26'
decl: AlgebraicGeometry.cechSectionAugComplex_d_zero_one
docstring: The bottom differential of the augmented section Cech complex is its augmentation
  map.
file: AlgebraicJacobian/Cohomology/CechSectionContractibilityOne.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechSectionAugComplex_d_zero_one
type: lean
updated: '2026-07-25T08:32:26'
---
lemma cechSectionAugComplex_d_zero_one :
    (cechSectionAugComplex 𝒰 F V).d 0 1 = sectionCechAugV 𝒰 F V :=
  rfl