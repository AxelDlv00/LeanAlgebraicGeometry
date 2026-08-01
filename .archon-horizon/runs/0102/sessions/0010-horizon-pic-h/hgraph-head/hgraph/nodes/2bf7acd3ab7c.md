---
author: sync
content_type: theorem
created: '2026-07-31T19:20:47'
decl: TruncExpCech.cechCoboundaryUnits_map_le
docstring: '**Coboundaries push forward along an isomorphism of two-chart data.**


  If `β ∘ ρᵢ = ρᵢ'' ∘ αᵢ` for `i = 1, 2` (the two restriction squares commute), then
  the

  overlap-ring map `Units.map β` carries the coboundary subgroup of `(ρ₁, ρ₂)` into
  that of

  `(ρ₁'', ρ₂'')`.  Only the two square identities are used — `β` and the `αᵢ` need
  not be

  isomorphisms for this direction.'
file: AlgebraicJacobian/Tangent/TruncExpCechTransport.lean
generated: lean
lean_status: lean_ok
title: TruncExpCech.cechCoboundaryUnits_map_le
type: lean
updated: '2026-08-01T09:44:18'
---
theorem cechCoboundaryUnits_map_le
    (ρ₁ : A₁ →+* B) (ρ₂ : A₂ →+* B) (ρ₁' : A₁' →+* B') (ρ₂' : A₂' →+* B')
    (α₁ : A₁ →+* A₁') (α₂ : A₂ →+* A₂') (β : B →+* B')
    (h₁ : β.comp ρ₁ = ρ₁'.comp α₁) (h₂ : β.comp ρ₂ = ρ₂'.comp α₂) :
    (cechCoboundaryUnits ρ₁ ρ₂).map (Units.map β.toMonoidHom) ≤
      cechCoboundaryUnits ρ₁' ρ₂' := by
  rintro _ ⟨u, hu, rfl⟩
  obtain ⟨v₁, v₂, rfl⟩ := mem_cechCoboundaryUnits.mp hu
  rw [map_mul]
  refine mem_cechCoboundaryUnits.mpr
    ⟨Units.map α₁.toMonoidHom v₁, Units.map α₂.toMonoidHom v₂, ?_⟩
  congr 1
  · ext
    have := RingHom.congr_fun h₁ (v₁ : A₁)
    simpa [Units.coe_map] using this.symm
  · ext
    have := RingHom.congr_fun h₂ (v₂ : A₂)
    simpa [Units.coe_map] using this.symm