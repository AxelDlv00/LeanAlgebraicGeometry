---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.ideal_annihilator_le_annihilator_sheafTensorObj
docstring: '**Annihilator sections kill the sheaf tensor product (affine heart)**:
  on an

  affine open `U`, the annihilator ideal sheaf of `A` is contained in the

  annihilator of the sections of `sheafTensorObj A B`.  Local surjectivity of the

  sheafification unit reduces this to the presheaf-tensor statement

  `annihilator_le_annihilator_tensorProduct` on an affine basis, and sheaf

  separatedness globalizes the vanishing back to `U`.'
file: AlgebraicJacobian/Picard/SchematicSupport.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ideal_annihilator_le_annihilator_sheafTensorObj
type: lean
updated: '2026-07-24T03:02:11'
---
theorem ideal_annihilator_le_annihilator_sheafTensorObj
    {X : Scheme.{u}} (A B : X.Modules) (U : X.affineOpens) :
    (Scheme.Modules.annihilator A).ideal U
      ≤ Module.annihilator Γ(X, U.1) Γ(Scheme.Modules.sheafTensorObj A B, U.1) := by
  classical
  intro r hr
  rw [Module.mem_annihilator]
  intro x
  -- the sheafification unit of the presheaf tensor is locally surjective
  have hsurj : CategoryTheory.Presheaf.IsLocallySurjective
      (Opens.grothendieckTopology X)
      ((PresheafOfModules.toPresheaf _).map
        ((PresheafOfModules.sheafificationAdjunction
          (𝟙 X.ringCatSheaf.obj)).unit.app (Scheme.Modules.tensorPresheaf A B))) := by
    rw [PresheafOfModules.toPresheaf_map_sheafificationAdjunction_unit_app]
    exact ((Opens.grothendieckTopology ↥X).W_toSheafify _).isLocallySurjective
  -- for every point of `U` there is an affine `W ∋ p`, `W ≤ U`, with
  -- `(r • x)|_W = 0`
  have key : ∀ p : U.1, ∃ W : X.Opens, ∃ _ : p.1 ∈ W, ∃ hWU : W ≤ U.1,
      ((Scheme.Modules.sheafTensorObj A B).val.map (homOfLE hWU).op).hom (r • x) = 0 := by
    intro p
    obtain ⟨V, g, ⟨t, ht⟩, hpV⟩ := hsurj.imageSieve_mem (U := U.1) x p.1 p.2
    -- refine to an affine basis member `W ∋ p` inside `V`
    obtain ⟨W, hWaff, hpW, hWV⟩ :=
      Opens.isBasis_iff_nbhd.mp X.isBasis_affineOpens hpV
    have hWU : W ≤ U.1 := hWV.trans g.le
    refine ⟨W, hpW, hWU, ?_⟩
    -- the restricted scalar `r|_W` annihilates the presheaf tensor over `W`
    have hrW : (X.presheaf.map (homOfLE hWU).op).hom r
        ∈ (Scheme.Modules.annihilator A).ideal ⟨W, hWaff⟩ :=
      Scheme.IdealSheafData.ideal_le_comap_ideal (Scheme.Modules.annihilator A)
        (U := ⟨W, hWaff⟩) (V := U) hWU hr
    have hkill : (X.presheaf.map (homOfLE hWU).op).hom r
        ∈ Module.annihilator Γ(X, W) (TensorProduct Γ(X, W) Γ(A, W) Γ(B, W)) :=
      annihilator_le_annihilator_tensorProduct
        (Scheme.Modules.annihilator_ideal_le A ⟨W, hWaff⟩ hrW)
    -- restrict the local presheaf-tensor preimage `t` of `x|_V` to `W`
    have hnat := Scheme.Modules.tensorSectionHom_naturality_apply A B
      (V := W) (W := V) (homOfLE hWV).op t
    -- `(r • x)|_W = r|_W • x|_W` (semilinearity of restriction)
    have hres : ((Scheme.Modules.sheafTensorObj A B).val.map (homOfLE hWU).op).hom (r • x)
        = (X.presheaf.map (homOfLE hWU).op).hom r
            • ((Scheme.Modules.sheafTensorObj A B).val.map (homOfLE hWU).op).hom x :=
      PresheafOfModules.map_smul _ _ _ _
    rw [hres]
    -- `x|_W` is the image of the restricted presheaf tensor `t|_W`:
    -- restrict in two steps `U ⊇ V ⊇ W` (`congr_map_apply` + `map_comp_apply`),
    -- recognize `x|_V` as the unit image of `t` (`ht`), and pull the last
    -- restriction through the unit (`tensorSectionHom` naturality)
    have e1 : (Scheme.Modules.sheafTensorObj A B).val.map (homOfLE hWU).op x
        = (Scheme.Modules.sheafTensorObj A B).val.map (homOfLE hWV).op
            ((Scheme.Modules.sheafTensorObj A B).val.map g.op x) :=
      (PresheafOfModules.congr_map_apply (Scheme.Modules.sheafTensorObj A B).val
        (show (homOfLE hWU).op = g.op ≫ (homOfLE hWV).op by
          rw [show (homOfLE hWU : W ⟶ U.1) = (homOfLE hWV : W ⟶ V) ≫ g from
            Subsingleton.elim _ _, op_comp]) x).trans
        (PresheafOfModules.map_comp_apply _ g.op (homOfLE hWV).op x)
    have e2 : (Scheme.Modules.sheafTensorObj A B).val.map g.op x
        = Scheme.Modules.tensorSectionHom A B V t := ht.symm
    have e3 : (Scheme.Modules.sheafTensorObj A B).val.map (homOfLE hWV).op
          (Scheme.Modules.tensorSectionHom A B V t)
        = Scheme.Modules.tensorSectionHom A B W
            ((Scheme.Modules.tensorPresheaf A B).map (homOfLE hWV).op t) := hnat.symm
    have hxW : (Scheme.Modules.sheafTensorObj A B).val.map (homOfLE hWU).op x
        = Scheme.Modules.tensorSectionHom A B W
            ((Scheme.Modules.tensorPresheaf A B).map (homOfLE hWV).op t) := by
      rw [e1, e2, e3]
    rw [hxW]
    -- pull the scalar through the (Γ(X, W)-linear) unit and kill it in the
    -- presheaf tensor
    have hlin : (X.presheaf.map (homOfLE hWU).op).hom r
          • Scheme.Modules.tensorSectionHom A B W
              ((Scheme.Modules.tensorPresheaf A B).map (homOfLE hWV).op t)
        = Scheme.Modules.tensorSectionHom A B W
            ((X.presheaf.map (homOfLE hWU).op).hom r
              • (Scheme.Modules.tensorPresheaf A B).map (homOfLE hWV).op t) :=
      (map_smul (Scheme.Modules.tensorSectionHom A B W).hom _ _).symm
    rw [hlin, Module.mem_annihilator.mp hkill _, map_zero]
  choose W hpW hWU hzero using key
  -- separatedness of the sheaf over the pointwise affine cover of `U`
  have hcov : U.1 ≤ iSup W := fun q hq =>
    Opens.mem_iSup.mpr ⟨⟨q, hq⟩, hpW ⟨q, hq⟩⟩
  refine TopCat.Sheaf.eq_of_locally_eq'
    (⟨(Scheme.Modules.sheafTensorObj A B).presheaf,
      (Scheme.Modules.sheafTensorObj A B).isSheaf⟩ : TopCat.Sheaf Ab X)
    W U.1 (fun p => homOfLE (hWU p)) hcov (r • x) 0 (fun p => ?_)
  rw [map_zero]
  exact hzero p