---
author: sync
content_type: theorem
created: '2026-07-29T12:10:02'
decl: probe_t1_of_orbit
docstring: '**The orbit hypothesis forces T1.** If some point `z₀` is closed and every
  point of `X` is

  the image of `z₀` under a homeomorphism of `X`, then every singleton is closed.'
file: scratch-orbit-probe.lean
generated: lean
lean_status: lean_ok
title: probe_t1_of_orbit
type: lean
updated: '2026-07-29T12:10:02'
---
theorem probe_t1_of_orbit (z₀ : X) (hz₀ : IsClosed ({z₀} : Set X))
    (horb : ∀ z : X, ∃ e : X ≃ₜ X, e z₀ = z) : T1Space X := by
  refine ⟨fun z => ?_⟩
  obtain ⟨e, he⟩ := horb z
  rw [← he]
  exact probe_isClosed_image e hz₀