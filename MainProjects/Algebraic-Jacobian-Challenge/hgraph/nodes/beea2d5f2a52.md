---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.ZariskiDescent.restrictHom
docstring: 'Restriction of the classifying source along `b : V ⟶ T`, as a morphism
  in

  `Over (U i)`.'
file: AlgebraicJacobian/Picard/ZariskiDescentRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.ZariskiDescent.restrictHom
type: lean
updated: '2026-07-24T03:02:12'
---
noncomputable def restrictHom {V T : Scheme.{0}} (b : V ⟶ T) (a : T ⟶ S) (i : ι) :
    Over.mk (preRes U (b ≫ a) i) ⟶ Over.mk (preRes U a i) :=
  Over.homMk (b.resLE (pre U a i) (pre U (b ≫ a) i) le_rfl)
    (by simp only [Over.mk_hom]
        exact Scheme.Hom.resLE_comp_resLE _ _ _ _)

variable (U) in