---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: PresheafOfModules.stalkTensorIso
docstring: '**The d.2 stalk--tensor commutation isomorphism** (blueprint `lem:stalk_tensor_commutation`).

  The `R.stalk x`-linear comparison map `stalkTensorLinearMap` is an isomorphism

  `(A ⊗ᵖ B).stalk x ≃ A_x ⊗_{R_x} B_x`, with inverse the descended reverse map `stalkTensorRev`.

  Mutual inversion is checked on germ generators (`stalkTensorLinearMap_germ_tmul`,

  `stalkTensorRev_germ_tmul`) and extended by `TensorProduct.induction_on` and the
  joint

  epimorphism of the germ maps (`TopCat.Presheaf.stalk_hom_ext`). This is the single

  genuinely Mathlib-absent ingredient (d.2) underlying the unconditional associator
  of the

  relative-Picard tensor substrate.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean
generated: lean
lean_status: lean_ok
title: PresheafOfModules.stalkTensorIso
type: lean
updated: '2026-07-24T03:02:12'
---
noncomputable def stalkTensorIso :
    (↑(TopCat.Presheaf.stalk (Monoidal.tensorObj A B).presheaf x) : Type u)
      ≃ₗ[↑(R.stalk x)] Tgt where
  toFun := stalkTensorLinearMap A B x
  map_add' := map_add _
  map_smul' := (stalkTensorLinearMap A B x).map_smul'
  invFun := stalkTensorRev A B x
  left_inv := by
    intro s
    obtain ⟨U, hxU, w, rfl⟩ :=
      TopCat.Presheaf.exists_germ_eq (Monoidal.tensorObj A B).presheaf s
    induction w using TensorProduct.induction_on with
    | zero =>
        erw [map_zero, map_zero, map_zero]
    | tmul a b =>
        erw [stalkTensorLinearMap_germ_tmul, stalkTensorRev_germ_tmul]
        exact germ_tensorObj_map_tmul A B x U (U ⊓ U) ⟨hxU, hxU⟩ hxU (homOfLE inf_le_left) a b
    | add p q hp hq =>
        erw [map_add, map_add, map_add, hp, hq]
  right_inv := by
    intro t
    induction t using TensorProduct.induction_on with
    | zero =>
        simp only [map_zero]
    | tmul ξ η =>
        obtain ⟨U, hxU, a, rfl⟩ := TopCat.Presheaf.exists_germ_eq A.presheaf ξ
        obtain ⟨V, hxV, b, rfl⟩ := TopCat.Presheaf.exists_germ_eq B.presheaf η
        rw [stalkTensorRev_germ_tmul]
        erw [stalkTensorLinearMap_germ_tmul,
            TopCat.Presheaf.germ_res_apply A.presheaf
              (homOfLE inf_le_left : U ⊓ V ⟶ U) x ⟨hxU, hxV⟩,
            TopCat.Presheaf.germ_res_apply B.presheaf
              (homOfLE inf_le_right : U ⊓ V ⟶ V) x ⟨hxU, hxV⟩]
    | add p q hp hq =>
        simp only [map_add]
        rw [hp, hq]