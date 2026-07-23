---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.pullbackCongr_inv_app_eqToHom
docstring: '`pullbackCongr` evaluated at an object, inverse side: the `eqToHom` of
  the

  object-level equality. Generic `subst` companion of `pullbackCongr_hom_app_eqToHom`.

  Project-local.'
file: AlgebraicJacobian/Picard/GlueDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.pullbackCongr_inv_app_eqToHom
type: lean
updated: '2026-07-16T21:14:27'
---
lemma pullbackCongr_inv_app_eqToHom {T' T : Scheme.{u}} {φ ψ : T' ⟶ T} (h : φ = ψ)
    (N : T.Modules) :
    (Scheme.Modules.pullbackCongr h).inv.app N
      = eqToHom (congrArg (fun α => (Scheme.Modules.pullback α).obj N) h.symm) := by
  subst h
  simp [Scheme.Modules.pullbackCongr]