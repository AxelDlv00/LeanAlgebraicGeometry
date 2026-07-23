---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.restrictScalarsIsRightAdjoint
docstring: '`restrictScalars φ` is a right adjoint: it is definitionally `pushforward
  (F := 𝟭) φ`.

  Project-local; carries the existence of the extension of scalars `extendScalars`.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.restrictScalarsIsRightAdjoint
type: lean
updated: '2026-07-16T21:14:28'
---
private lemma restrictScalarsIsRightAdjoint (φ : S ⟶ F.op ⋙ R) :
    (PresheafOfModules.restrictScalars.{u} φ).IsRightAdjoint :=
  inferInstanceAs
    (PresheafOfModules.pushforward.{u} (F := 𝟭 C) (R := F.op ⋙ R) φ).IsRightAdjoint