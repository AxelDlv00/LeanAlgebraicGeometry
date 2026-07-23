---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: PresheafOfModules.revInner
docstring: '**Inner descent of the reverse map** (fixed `A`-section `a` over `U`):
  the additive

  map `B.stalk x → (A ⊗ᵖ B).stalk x` descending `revInnerLeg` through the `B`-stalk
  colimit.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean
generated: lean
lean_status: lean_ok
title: PresheafOfModules.revInner
type: lean
updated: '2026-07-24T03:02:12'
---
private noncomputable def revInner (U : Opens X) (hxU : x ∈ U) (a : ↑(A.obj (op U))) :
    TopCat.Presheaf.stalk B.presheaf x ⟶
      TopCat.Presheaf.stalk (Monoidal.tensorObj A B).presheaf x :=
  colimit.desc ((OpenNhds.inclusion x).op ⋙ B.presheaf)
    ⟨TopCat.Presheaf.stalk (Monoidal.tensorObj A B).presheaf x,
      fun W => revInnerLeg A B x U hxU a (unop W).1 (unop W).2,
      by
        intro W W' f
        apply AddCommGrpCat.hom_ext
        ext b
        simp only [CategoryTheory.comp_apply, Functor.const_obj_map]
        erw [CategoryTheory.ConcreteCategory.id_apply, revInnerLeg_apply]
        conv_rhs => erw [revInnerLeg_apply]
        have hVle : (unop W').1 ≤ (unop W).1 := leOfHom ((OpenNhds.inclusion x).map f.unop)
        have j : U ⊓ (unop W').1 ⟶ U ⊓ (unop W).1 := homOfLE (inf_le_inf_left U hVle)
        rw [← TopCat.Presheaf.germ_res_apply (Monoidal.tensorObj A B).presheaf j x
          ⟨hxU, (unop W').2⟩]
        congr 1
        erw [presheaf_map_apply_coe, PresheafOfModules.Monoidal.tensorObj_map_tmul]
        congr 1
        · rw [← presheaf_map_apply_coe, ← presheaf_map_apply_coe]
          erw [← CategoryTheory.ConcreteCategory.comp_apply, ← Functor.map_comp]
          congr 1
        · rw [← presheaf_map_apply_coe, Functor.comp_map]
          erw [← CategoryTheory.ConcreteCategory.comp_apply,
            ← CategoryTheory.ConcreteCategory.comp_apply, ← Functor.map_comp, ← Functor.map_comp]
          congr 1⟩