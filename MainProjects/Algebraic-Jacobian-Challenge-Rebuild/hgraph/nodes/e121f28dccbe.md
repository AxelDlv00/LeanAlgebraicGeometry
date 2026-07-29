---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.appLE_whiskerLeft_injective
docstring: 'Pullback of sections along `cg` is injective over **arbitrary** opens,
  by sheaf

  separation from the affine case.'
file: AlgebraicJacobian/Picard/SectionsDescent.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.appLE_whiskerLeft_injective
type: lean
updated: '2026-07-29T15:26:35'
---
theorem appLE_whiskerLeft_injective (W : (XA).Opens) :
    Function.Injective ((cg).appLE W ((cg) ⁻¹ᵁ W) le_rfl).hom := by
  intro s t hst
  refine (XA).sheaf.eq_of_locally_eq'
    (fun V : {V : (XA).Opens // IsAffineOpen V ∧ V ≤ W} ↦ V.1) W
    (fun V ↦ homOfLE V.2.2) (fun w hw ↦ ?_) s t (fun V ↦ ?_)
  · obtain ⟨V, hVaff, hwV, hVW⟩ :=
      TopologicalSpace.Opens.isBasis_iff_nbhd.mp (XA).isBasis_affineOpens hw
    exact TopologicalSpace.Opens.mem_iSup.mpr ⟨⟨V, hVaff, hVW⟩, hwV⟩
  · have hres := congrArg ((XB).presheaf.map (homOfLE
      (show (cg) ⁻¹ᵁ V.1 ≤ (cg) ⁻¹ᵁ W from fun x hx ↦ V.2.2 hx)).op).hom hst
    rw [← CommRingCat.comp_apply, ← CommRingCat.comp_apply,
      Scheme.Hom.appLE_map] at hres
    have key : ((cg).appLE V.1 ((cg) ⁻¹ᵁ V.1) le_rfl).hom
          (((XA).presheaf.map (homOfLE V.2.2).op).hom s)
        = ((cg).appLE V.1 ((cg) ⁻¹ᵁ V.1) le_rfl).hom
          (((XA).presheaf.map (homOfLE V.2.2).op).hom t) := by
      rw [← CommRingCat.comp_apply, ← CommRingCat.comp_apply, Scheme.Hom.map_appLE]
      exact hres
    exact appLE_whiskerLeft_injective_of_isAffineOpen (C := C) V.2.1 key