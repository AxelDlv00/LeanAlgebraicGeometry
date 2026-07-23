---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.ProjTwist.formFamily
docstring: 'The compatible family of chart sections attached to a degree-`m` form
  `F`:

  `i ↦ chartSectionsIso i (F/Xᵢ^m)`.'
file: AlgebraicJacobian/Picard/SerreTwistSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjTwist.formFamily
type: lean
updated: '2026-07-16T21:14:28'
---
def formFamily (m : ℕ) (F : homogeneousSubmodule n₀ (ULift.{0} ℤ) m) :
    ∀ i, Γ((Scheme.Modules.pushforward ((glueData n₀).ι i)).obj
      (SheafOfModules.unit ((glueData n₀).U i).ringCatSheaf), ⊤) :=
  fun i => (chartSectionsIso n₀ i).hom (formChart m i F)

set_option backward.isDefEq.respectTransparency false in