---
author: sync
content_type: theorem
created: '2026-07-30T10:26:46'
decl: Probe.specGal_inv_comp
file: probe_p4_action.lean
generated: lean
lean_status: lean_ok
stale: true
title: Probe.specGal_inv_comp
type: lean
updated: '2026-07-30T10:40:23'
---
theorem specGal_inv_comp (γ : k' ≃ₐ[k] k') :
    specGal (k := k) γ ≫ specGal (k := k) γ⁻¹ = 𝟙 _ := by
  rw [← specGal_mul, mul_inv_cancel, specGal_one]