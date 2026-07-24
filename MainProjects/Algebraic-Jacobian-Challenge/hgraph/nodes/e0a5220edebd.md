---
author: sync
content_type: lemma
created: '2026-07-24T17:02:57'
decl: AlgebraicGeometry.Scheme.Modules.pushforward₀IsRightAdjoint
docstring: '`pushforward₀ F R` is a right adjoint: it is definitionally `pushforward
  (𝟙 (F.op ⋙ R))`

  (since `restrictScalars (𝟙) = 𝟭` on the nose). Project-local; carries the existence
  of the

  topological inverse image `pullback₀`.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.pushforward₀IsRightAdjoint
type: lean
updated: '2026-07-24T17:02:57'
---
private lemma pushforward₀IsRightAdjoint (F : C ⥤ D) (R : Dᵒᵖ ⥤ RingCat.{u}) :
    (PresheafOfModules.pushforward₀.{u} F R).IsRightAdjoint :=
  inferInstanceAs (PresheafOfModules.pushforward.{u} (𝟙 (F.op ⋙ R))).IsRightAdjoint