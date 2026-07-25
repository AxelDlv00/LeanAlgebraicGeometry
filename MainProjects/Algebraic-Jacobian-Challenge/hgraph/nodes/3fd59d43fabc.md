---
author: sync
content_type: lemma
created: '2026-07-25T09:02:27'
decl: AlgebraicGeometry.cechSectionHomotopyZeroAug_eq
docstring: The opaque bottom composite is the bottom homotopy followed by the augmentation.
file: AlgebraicJacobian/Cohomology/CechSectionContractibilityOne.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechSectionHomotopyZeroAug_eq
type: lean
updated: '2026-07-26T00:02:54'
---
lemma cechSectionHomotopyZeroAug_eq :
    cechSectionHomotopyZeroAug 𝒰 F V i_fix hiV =
      cechSectionHomotopyZero 𝒰 F V i_fix hiV ≫ sectionCechAugV 𝒰 F V :=
  rfl