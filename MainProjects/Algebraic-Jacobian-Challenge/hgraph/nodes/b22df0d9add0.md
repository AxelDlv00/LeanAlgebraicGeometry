---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.ZariskiDescent.repG_eq
docstring: The representation of the glued functor in restriction form.
file: AlgebraicJacobian/Picard/ZariskiDescentRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.ZariskiDescent.repG_eq
type: lean
updated: '2026-07-24T03:02:12'
---
lemma repG_eq {V : Scheme.{0}} (t : V ⟶ Ŷ) :
    RepG.homEquiv t = GluedPoint.res R t (RepG.homEquiv (𝟙 Ŷ)) := by
  conv_lhs => rw [← Category.comp_id t]
  exact RepG.homEquiv_comp t (𝟙 Ŷ)

set_option backward.isDefEq.respectTransparency false in