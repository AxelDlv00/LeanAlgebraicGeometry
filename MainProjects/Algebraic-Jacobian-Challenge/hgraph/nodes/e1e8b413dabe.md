---
author: sync
content_type: theorem
created: '2026-08-01T04:12:00'
decl: AlgebraicGeometry.Scheme.Modules.annihilator_le_annihilator_tensorObj_left
docstring: 'The annihilator of the left tensor factor annihilates the canonical tensor

  product.  This transports the existing sheaf-tensor inclusion across the

  comparison isomorphism.'
file: AlgebraicJacobian/Picard/DivGrassmannianEmbedding.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.annihilator_le_annihilator_tensorObj_left
type: lean
updated: '2026-08-01T04:12:00'
---
theorem annihilator_le_annihilator_tensorObj_left
    {X : Scheme.{u}} (A B : X.Modules) :
    annihilator A ≤ annihilator (tensorObj A B) := by
  rw [annihilator_eq_of_iso (tensorObjIsoSheafTensorObj A B)]
  exact annihilator_le_annihilator_sheafTensorObj A B