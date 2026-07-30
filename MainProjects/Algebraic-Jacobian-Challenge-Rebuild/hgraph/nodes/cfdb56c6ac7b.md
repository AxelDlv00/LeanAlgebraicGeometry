---
author: sync
content_type: theorem
created: '2026-07-30T11:09:50'
decl: ProbeP1RoundTrip.map_baseChange_symm_map_baseChange
docstring: 'The round trip: mapping a submodule along `baseChange e` then `baseChange
  e.symm`

  is the identity.'
file: ScratchP1/probe_roundtrip.lean
generated: lean
lean_status: lean_ok
title: ProbeP1RoundTrip.map_baseChange_symm_map_baseChange
type: lean
updated: '2026-07-30T15:46:08'
---
theorem map_baseChange_symm_map_baseChange (e : H ≃ₗ[k] H')
    (N : Submodule T (TensorProduct k T H)) :
    Submodule.map (LinearMap.baseChange T e.symm.toLinearMap)
        (Submodule.map (LinearMap.baseChange T e.toLinearMap) N) = N := by
  rw [← Submodule.map_comp, ← LinearMap.baseChange_comp, LinearEquiv.comp_coe,
    LinearEquiv.self_trans_symm, LinearEquiv.refl_toLinearMap, LinearMap.baseChange_id,
    Submodule.map_id]