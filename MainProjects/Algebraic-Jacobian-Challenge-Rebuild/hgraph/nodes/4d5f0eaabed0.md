---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.divisorSectionsEquivH0
docstring: 'The degree-zero cohomology of the divisor sheaf is its module of global
  sections,

  `K`-linearly: the specialization of `Sheaf.HModule.linearEquiv₀` to `𝒪(A)`.'
file: AlgebraicJacobian/RiemannRoch/SectionSpaces.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divisorSectionsEquivH0
type: lean
updated: '2026-07-31T20:15:29'
---
noncomputable def divisorSectionsEquivH0 (A : X.CurveDivisor) :
    Sheaf.HModule (X.divisorSheaf K A) 0 ≃ₗ[K] ↥(divisorSections K A ⊤) :=
  Sheaf.HModule.linearEquiv₀ (Opens.grothendieckTopology (X : TopCat))
    (isTerminalTop : IsTerminal (⊤ : X.Opens)) (X.divisorSheaf K A)