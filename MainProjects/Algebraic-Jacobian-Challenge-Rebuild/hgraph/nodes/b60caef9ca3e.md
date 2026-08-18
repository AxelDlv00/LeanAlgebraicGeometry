---
author: sync
content_type: theorem
created: '2026-08-02T04:08:38'
decl: AlgebraicGeometry.specMap_comp_divRepClassifyZarAff
docstring: Naturality of the underlying scheme morphism of the widened affine classifier.
file: AlgebraicJacobian/Picard/DivRepClassifyZarAffNaturality.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.specMap_comp_divRepClassifyZarAff
type: lean
updated: '2026-08-18T20:50:56'
---
theorem specMap_comp_divRepClassifyZarAff
    {A B : Type u} [CommRing A] [Algebra k A] [CommRing B] [Algebra k B]
    (phi : A →ₐ[k] B) (F : DivFamZarAff C A g) :
    Spec.map (CommRingCat.ofHom phi.toRingHom) ≫
        (divRepClassifyZarAff hpi g hO hchi r₁ r₂ b₁ b₂ A F).left
      = (divRepClassifyZarAff hpi g hO hchi r₁ r₂ b₁ b₂ B
          (DivFamZarAff.mapAlgHom phi F)).left := by
  letI : Algebra A B := phi.toRingHom.toAlgebra
  haveI : IsScalarTower k A B :=
    IsScalarTower.of_algebraMap_eq fun a => (phi.commutes a).symm
  refine isDivRepClassifyAff_unique hpi g hO hchi r₁ r₂ b₁ b₂
    (DivFamZarAff.mapAlgHom phi F) ?_
    (divRepClassifyZarAff_isDivRepClassifyAff hpi g hO hchi r₁ r₂ b₁ b₂
      (DivFamZarAff.mapAlgHom phi F))
  intro T _ _ _ _ G hG i j w hw
  let psi : B →ₐ[k] T := IsScalarTower.toAlgHom k B T
  letI : Algebra A T := (psi.comp phi).toRingHom.toAlgebra
  haveI : IsScalarTower k A T :=
    IsScalarTower.of_algebraMap_eq fun a => ((psi.comp phi).commutes a).symm
  haveI : IsScalarTower A B T := IsScalarTower.of_algebraMap_eq fun _ => rfl
  have hmap : DivFamZarAff.mapAlg T g (DivFamZarAff.mapAlgHom phi F)
      = DivFamZarAff.mapAlg T g F := by
    calc
      _ = DivFamZarAff.mapAlgHom psi (DivFamZarAff.mapAlgHom phi F) :=
        (DivFamZarAff.mapAlgHom_eq_mapAlg psi (fun _ => rfl) _).symm
      _ = DivFamZarAff.mapAlgHom (psi.comp phi) F :=
        (DivFamZarAff.mapAlgHom_comp phi psi F).symm
      _ = DivFamZarAff.mapAlg T g F :=
        DivFamZarAff.mapAlgHom_eq_mapAlg (psi.comp phi) (fun _ => rfl) F
  have hbase := divRepClassifyZarAff_isDivRepClassifyAff hpi g hO hchi
    r₁ r₂ b₁ b₂ F T G (hG.trans hmap) i j w hw
  have hstep : Spec.map (CommRingCat.ofHom (algebraMap B T)) ≫
        (Spec.map (CommRingCat.ofHom phi.toRingHom) ≫
          (divRepClassifyZarAff hpi g hO hchi r₁ r₂ b₁ b₂ A F).left)
      = Spec.map (CommRingCat.ofHom (algebraMap A T)) ≫
          (divRepClassifyZarAff hpi g hO hchi r₁ r₂ b₁ b₂ A F).left := by
    rw [← Category.assoc, ← Spec.map_comp]
    rfl
  rw [← Category.assoc, hstep, Category.assoc]
  exact hbase

set_option maxHeartbeats 800000 in
-- `Over` extensionality exposes exactly the scheme-level naturality above.
include hO hchi in