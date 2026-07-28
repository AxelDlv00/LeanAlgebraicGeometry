---
author: sync
content_type: definition
created: '2026-07-28T18:12:20'
decl: CategoryTheory.Sheaf.constModuleSheafGen
docstring: 'The distinguished global section of the constant sheaf of `R`-modules:
  the image of

  `1 : R` (equivalently, the section classifying the identity).'
file: AlgebraicJacobian/RiemannRoch/Ledger/OverOpen.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Sheaf.constModuleSheafGen
type: lean
updated: '2026-07-28T18:12:20'
---
noncomputable def constModuleSheafGen : (constModuleSheaf J R).obj.obj (op T) :=
  constModuleSheafHomEquiv J hT (constModuleSheaf J R) (𝟙 _)