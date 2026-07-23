---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.pullbackCongr_hom_app
docstring: 'Component form of `Scheme.Modules.pullbackCongr`: it is an `eqToHom`.'
file: AlgebraicJacobian/Picard/QuotFunctorDef.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.pullbackCongr_hom_app
type: lean
updated: '2026-07-24T03:02:11'
---
lemma pullbackCongr_hom_app {Y X : Scheme.{u}} {f g : Y ⟶ X} (h : f = g)
    (M : X.Modules) :
    (Scheme.Modules.pullbackCongr h).hom.app M = eqToHom (by rw [h]) := by
  subst h
  simp [Scheme.Modules.pullbackCongr]