---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.pullback0
docstring: '**The topological inverse image `pullback₀ := (pushforward₀ F R).leftAdjoint`**,
  the

  left adjoint of the fixed-ring pushforward. On underlying presheaves it is the left
  Kan

  extension along `F.op`. Project-local (no `PresheafOfModules` inverse-image functor
  at the

  pin); the carrier of D3.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.pullback0
type: lean
updated: '2026-07-16T21:14:28'
---
noncomputable def pullback0 (F : C ⥤ D) (R : Dᵒᵖ ⥤ RingCat.{u}) :
    _root_.PresheafOfModules.{u} (F.op ⋙ R) ⥤ _root_.PresheafOfModules.{u} R :=
  haveI := pushforward₀IsRightAdjoint F R
  (PresheafOfModules.pushforward₀ F R).leftAdjoint