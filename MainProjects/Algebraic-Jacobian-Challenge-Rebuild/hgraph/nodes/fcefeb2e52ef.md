---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.exists_unitsAppLE_eq
docstring: '**Faithfully flat descent of unit sections along the base change of the
  curve

  product**: the unit-group face of `existsUnique_appLE_eq`.'
file: AlgebraicJacobian/Picard/SectionsDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.exists_unitsAppLE_eq
type: lean
updated: '2026-07-29T15:31:48'
---
theorem exists_unitsAppLE_eq {U : (XA).Opens} (hU : IsAffineOpen U)
    (t : Γ(XB, (cg) ⁻¹ᵁ U)ˣ)
    (ht : (u₁).unitsAppLE ((cg) ⁻¹ᵁ U) ((cg₂) ⁻¹ᵁ U) (cg₂_preimage_eq_inl C U).le t
        = (u₂).unitsAppLE ((cg) ⁻¹ᵁ U) ((cg₂) ⁻¹ᵁ U) (cg₂_preimage_eq_inr C U).le t) :
    ∃ s : Γ(XA, U)ˣ, (cg).unitsAppLE U ((cg) ⁻¹ᵁ U) le_rfl s = t := by
  have htval := congrArg Units.val ht
  rw [Scheme.Hom.coe_unitsAppLE, Scheme.Hom.coe_unitsAppLE] at htval
  have ht2 : (u₁).unitsAppLE ((cg) ⁻¹ᵁ U) ((cg₂) ⁻¹ᵁ U)
        (cg₂_preimage_eq_inl C U).le t⁻¹
      = (u₂).unitsAppLE ((cg) ⁻¹ᵁ U) ((cg₂) ⁻¹ᵁ U)
        (cg₂_preimage_eq_inr C U).le t⁻¹ := by
    rw [map_inv, map_inv, ht]
  have htval' := congrArg Units.val ht2
  rw [Scheme.Hom.coe_unitsAppLE, Scheme.Hom.coe_unitsAppLE] at htval'
  obtain ⟨a, ha, -⟩ := existsUnique_appLE_eq (C := C) hU t.val htval
  obtain ⟨b, hb, -⟩ := existsUnique_appLE_eq (C := C) hU (t⁻¹).val htval'
  have hab : a * b = 1 := by
    refine appLE_whiskerLeft_injective_of_isAffineOpen (C := C) (B := B) hU ?_
    rw [map_mul, map_one, ha, hb]
    exact t.mul_inv
  have hba : b * a = 1 := by rw [mul_comm]; exact hab
  exact ⟨⟨a, b, hab, hba⟩, Units.ext ha⟩