---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.restrict
docstring: '**The `Γ(X,U)`-linear section restriction map of a sheaf of modules.**
  For `M : X.Modules` and

  an inclusion of opens `i : V ⟶ U`, the presheaf restriction `Γ(M, U) → Γ(M, V)`
  is `Γ(X, U)`-linear

  when `Γ(M, V)` carries the `Γ(X, U)`-module structure restricted along `X.presheaf.map
  i.op`

  (`Module.compHom`). Linearity is `Scheme.Modules.map_smul`. Project-local: the linear-map
  packaging

  of the section restriction needed to state `IsLocalizedModule` for a general scheme
  (Mathlib''s

  presheaf-of-modules restriction is semilinear, not bundled this way).'
file: AlgebraicJacobian/Picard/QuotScheme.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.restrict
type: lean
updated: '2026-07-24T03:02:11'
---
noncomputable def restrictₗ {X : Scheme.{u}} (M : X.Modules) {U V : X.Opens} (i : V ⟶ U) :
    letI : Module Γ(X, U) Γ(M, V) := Module.compHom _ (X.presheaf.map i.op).hom
    Γ(M, U) →ₗ[Γ(X, U)] Γ(M, V) :=
  letI : Module Γ(X, U) Γ(M, V) := Module.compHom _ (X.presheaf.map i.op).hom
  { toFun := fun x => M.presheaf.map i.op x
    map_add' := map_add _
    map_smul' := fun r x => Scheme.Modules.map_smul M i r x }