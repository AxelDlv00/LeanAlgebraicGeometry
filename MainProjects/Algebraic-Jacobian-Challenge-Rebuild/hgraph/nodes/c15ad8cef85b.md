---
author: sync
content_type: lemma
created: '2026-07-17T16:57:12'
decl: AlgebraicGeometry.presheafCongr_resHom
docstring: Restriction into an open equal to the source cancels the open-equality
  transport.
file: AlgebraicJacobian/Cohomology/RelThetaTransportCore.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.presheafCongr_resHom
type: lean
updated: '2026-07-29T15:31:35'
---
lemma presheafCongr_resHom {X : Scheme.{u}} [X.Over (Spec (.of k))] {U U' V : X.Opens}
    (h : U = U') (h₁ : U ≤ V) (h₂ : U' ≤ V) (s : Γ(X, V)) :
    presheafCongr (k := k) h (X.resHom h₁ s) = X.resHom h₂ s := by
  rw [presheafCongr, LinearEquiv.ofLinear_apply]
  change X.resHom (le_of_eq h.symm) (X.resHom h₁ s) = X.resHom h₂ s
  rw [Scheme.resHom_resHom]