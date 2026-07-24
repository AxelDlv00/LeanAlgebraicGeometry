---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.isIso_unit_schematicSupport
docstring: '**The schematic-support descent: the unit `F ⟶ i_* i^* F` is an

  isomorphism** at the annihilator ideal sheaf (the geometric half of the brick

  `F ≅ i_* N` of `lem:gamma_fiber_baseChange_field`): for a quasi-coherent `F`

  on `Y` with schematic-support immersion

  `i = schematicSupportι F : V(Ann F) ↪ Y`, the adjunction unit is invertible.

  Instantiation of `isIso_unit_subschemeι_of_le_annihilator` via the

  always-available `ofIdeals` direction `annihilator_ideal_le`.'
file: AlgebraicJacobian/Picard/SchematicSupport.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.Modules.isIso_unit_schematicSupport
type: lean
updated: '2026-07-24T17:02:59'
---
theorem isIso_unit_schematicSupportι
    {Y : Scheme.{u}} (F : Y.Modules) [F.IsQuasicoherent] :
    IsIso ((Scheme.Modules.pullbackPushforwardAdjunction
      (Scheme.Modules.schematicSupportι F)).unit.app F) :=
  isIso_unit_subschemeι_of_le_annihilator (Scheme.Modules.annihilator F) F
    (fun U => Scheme.Modules.annihilator_ideal_le F U)