---
author: sync
content_type: theorem
created: '2026-08-01T04:12:00'
decl: AlgebraicGeometry.Scheme.Modules.annihilator_le_annihilator_tensorObj_right
docstring: 'The annihilator of the right tensor factor also annihilates the canonical

  tensor product, by symmetry.'
file: AlgebraicJacobian/Picard/DivGrassmannianEmbedding.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.annihilator_le_annihilator_tensorObj_right
type: lean
updated: '2026-08-01T04:12:00'
---
theorem annihilator_le_annihilator_tensorObj_right
    {X : Scheme.{u}} (A B : X.Modules) :
    annihilator B ≤ annihilator (tensorObj A B) := by
  calc
    annihilator B ≤ annihilator (tensorObj B A) :=
      annihilator_le_annihilator_tensorObj_left B A
    _ = annihilator (tensorObj A B) :=
      annihilator_eq_of_iso (tensorObj_braiding B A)