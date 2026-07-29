---
author: sync
content_type: theorem
created: '2026-07-25T23:28:01'
decl: AlgebraicGeometry.Scheme.LocalEquations.DivEq.unitLocus_eq
docstring: '**The unit locus only depends on the divisor.**  Two `DivEq` systems have
  equations that

  agree up to a unit on a common refinement, and the unit locus is a germ-invertibility
  locus, so

  it cannot see the unit.'
file: AlgebraicJacobian/Picard/DivSchemeCertZarConfine.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.LocalEquations.DivEq.unitLocus_eq
type: lean
updated: '2026-07-29T15:26:11'
---
theorem DivEq.unitLocus_eq {d₁ d₂ : X.LocalEquations} (h : DivEq d₁ d₂) :
    (d₁.unitLocus : Set X) = (d₂.unitLocus : Set X) := by
  obtain ⟨𝒲, h₁, h₂, H⟩ := h
  ext y
  have hyW : y ∈ 𝒲.opens y := 𝒲.mem_opens y
  have hy₁ : y ∈ d₁.cover.opens y := h₁ y hyW
  have hy₂ : y ∈ d₂.cover.opens y := h₂ y hyW
  obtain ⟨u, hu⟩ := H y
  have key := congrArg (X.presheaf.germ (𝒲.opens y) y hyW).hom hu
  rw [map_mul] at key
  rw [show (X.presheaf.germ (𝒲.opens y) y hyW).hom
      ((X.presheaf.map (homOfLE (h₁ y)).op).hom (d₁.eqn y))
      = (X.presheaf.germ (d₁.cover.opens y) y hy₁).hom (d₁.eqn y) from
    TopCat.Presheaf.germ_res_apply _ _ _ _ _] at key
  rw [show (X.presheaf.germ (𝒲.opens y) y hyW).hom
      ((X.presheaf.map (homOfLE (h₂ y)).op).hom (d₂.eqn y))
      = (X.presheaf.germ (d₂.cover.opens y) y hy₂).hom (d₂.eqn y) from
    TopCat.Presheaf.germ_res_apply _ _ _ _ _] at key
  simp only [SetLike.mem_coe]
  rw [d₁.mem_unitLocus_iff_isUnit_germ hy₁, d₂.mem_unitLocus_iff_isUnit_germ hy₂, key,
    IsUnit.mul_iff]
  exact and_iff_right (u.isUnit.map _)