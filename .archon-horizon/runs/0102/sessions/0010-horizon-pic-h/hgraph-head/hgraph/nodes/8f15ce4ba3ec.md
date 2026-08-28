---
author: sync
content_type: theorem
created: '2026-08-01T05:12:59'
decl: CategoryTheory.Functor.RepresentableBy.Over.mapCompPresheafCommon_comp
docstring: 'Common-base comparisons compose along a pair of arrows.  The proof uses

  naturality of `theta`; all remaining maps are equality transports.'
file: AlgebraicJacobian/Picard/RepresentableByTransport.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Functor.RepresentableBy.Over.mapCompPresheafCommon_comp
type: lean
updated: '2026-08-01T09:44:17'
---
theorem mapCompPresheafCommon_comp
    {W X Y Z : D} (q : W ⟶ X) (p : X ⟶ Y) (b : Y ⟶ Z)
    {FL : (CategoryTheory.Over Y)ᵒᵖ ⥤ Type v}
    {FK : (CategoryTheory.Over Z)ᵒᵖ ⥤ Type v}
    (theta : FL ≅ (CategoryTheory.Over.map b).op ⋙ FK) :
    mapCompPresheafCommon b theta (q ≫ p) =
      CategoryTheory.Functor.RepresentableBy.Over.mapCompPresheafOfEq
          (q ≫ p) q p rfl FL ≪≫
        Functor.isoWhiskerLeft (CategoryTheory.Over.map q).op
          (mapCompPresheafCommon b theta p) ≪≫
        (CategoryTheory.Functor.RepresentableBy.Over.mapCompPresheafOfEq
          ((q ≫ p) ≫ b) q (p ≫ b) (Category.assoc q p b) FK).symm := by
  rw [mapCompPresheafOfEq_eq_canonical,
    mapCompPresheafOfEq_eq_canonical]
  apply Iso.ext
  apply NatTrans.ext
  funext A
  apply ConcreteCategory.hom_ext
  intro x
  have htheta := congrArg (fun f => (ConcreteCategory.hom f) x)
    (theta.hom.naturality
      ((NatIso.op (eqToIso
        (CategoryTheory.Over.mapComp_eq q p))).inv.app A))
  simp only [mapCompPresheafCommon, mapCompPresheafCanonical,
    Iso.trans_hom, Iso.symm_hom, NatTrans.comp_app,
    Functor.isoWhiskerLeft_hom, Functor.isoWhiskerRight_hom,
    Functor.whiskerLeft_app, Functor.whiskerRight_app,
    eqToIso.hom, eqToHom_app,
    Functor.associator_inv_app, types_comp_apply]
  simp only [types_comp_apply] at htheta
  simp only [types_id_apply, eqToHom_refl]
  erw [htheta]
  simp only [NatIso.op_hom, eqToIso.hom, NatTrans.op_app, eqToHom_app,
    eqToHom_op, Iso.trans_inv, Functor.isoWhiskerRight_inv,
    Iso.symm_inv, eqToIso.inv, NatTrans.comp_app,
    Functor.whiskerRight_app, comp_apply, NatIso.op_inv, comp_map, op_map]
  apply eq_of_heq
  apply HEq.trans (map_eqToHom_apply_heq FK _ _)
  apply HEq.trans (id_apply_heq _ _)
  refine HEq.trans ?_ (eqToHom_apply_heq _ _).symm
  refine HEq.trans ?_ (map_eqToHom_apply_heq FK _ _).symm
  refine HEq.trans ?_ (map_eqToHom_apply_heq FK _ _).symm
  exact (op_map_eqToHom_apply_heq (CategoryTheory.Over.map b) FK _ _).symm