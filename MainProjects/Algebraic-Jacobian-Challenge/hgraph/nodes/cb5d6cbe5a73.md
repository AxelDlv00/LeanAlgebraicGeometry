---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.ProjTwist.appTop_comp_apply
docstring: Element-level composite of the `⊤`-section maps of two composable morphisms.
file: AlgebraicJacobian/Picard/SerreTwistSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjTwist.appTop_comp_apply
type: lean
updated: '2026-07-24T03:02:12'
---
lemma appTop_comp_apply {X Y Z : Scheme.{0}} (f : X ⟶ Y) (g : Y ⟶ Z) (y : Γ(Z, ⊤)) :
    Scheme.Hom.appTop f (Scheme.Hom.appTop g y) = Scheme.Hom.appTop (f ≫ g) y := by
  rw [Scheme.Hom.comp_appTop]; rfl

set_option backward.isDefEq.respectTransparency false in