---
author: sync
content_type: theorem
created: '2026-07-29T13:43:19'
decl: chk_t1Space_of_orbit_of_isClosed
file: scratch-core-check.lean
generated: lean
lean_status: lean_ok
title: chk_t1Space_of_orbit_of_isClosed
type: lean
updated: '2026-07-29T13:43:19'
---
theorem chk_t1Space_of_orbit_of_isClosed {X : Type*} [TopologicalSpace X] (z₀ : X)
    (hz₀ : IsClosed ({z₀} : Set X)) (horb : ∀ z : X, ∃ e : X ≃ₜ X, e z₀ = z) :
    T1Space X := by
  refine ⟨fun z => ?_⟩
  obtain ⟨e, he⟩ := horb z
  rw [← he]
  exact chk_isClosed_singleton_homeomorph e hz₀