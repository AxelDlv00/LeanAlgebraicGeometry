---
author: sync
content_type: theorem
created: '2026-08-02T04:08:38'
decl: AlgebraicGeometry.divRepPullAtAff_mapAlgHom_eq_of_chartFactor
docstring: Pulls of chart-range witnesses agree over any common carrier.
file: AlgebraicJacobian/Picard/DivRepChartRangeAff.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divRepPullAtAff_mapAlgHom_eq_of_chartFactor
type: lean
updated: '2026-08-07T05:01:47'
---
theorem divRepPullAtAff_mapAlgHom_eq_of_chartFactor
    (U : ∀ (i : (glueData k g r1).J) (j : (glueData k g r2).J),
      DivFamZarAff C (ChartRing i j) g)
    (hU : ∀ i j,
      (divRepClassifyZarAff hpi g hO hchi r1 r2 b1 b2
        (ChartRing i j) (U i j)).left = ChartMap i j)
    {S : Type u} [CommRing S] [Algebra k S] (v : overSpec k S ⟶ DivOver)
    {A A' B : Type u}
    [CommRing A] [Algebra k A] [Algebra S A] [IsScalarTower k S A]
    [CommRing A'] [Algebra k A'] [Algebra S A'] [IsScalarTower k S A']
    [CommRing B] [Algebra k B] [Algebra S B] [IsScalarTower k S B]
    [Algebra A B] [IsScalarTower k A B] [IsScalarTower S A B]
    [Algebra A' B] [IsScalarTower k A' B] [IsScalarTower S A' B]
    {i : (glueData k g r1).J} {j : (glueData k g r2).J}
    {i' : (glueData k g r1).J} {j' : (glueData k g r2).J}
    (omega : ChartRing i j →ₐ[k] A) (omega' : ChartRing i' j' →ₐ[k] A')
    (homega : Spec.map (CommRingCat.ofHom omega.toRingHom) ≫ ChartMap i j =
      Spec.map (CommRingCat.ofHom (algebraMap S A)) ≫ v.left)
    (homega' : Spec.map (CommRingCat.ofHom omega'.toRingHom) ≫ ChartMap i' j' =
      Spec.map (CommRingCat.ofHom (algebraMap S A')) ≫ v.left) :
    DivFamZarAff.mapAlgHom (IsScalarTower.toAlgHom k A B)
        (divRepPullAtAff hpi g r1 r2 b1 b2 U i j omega) =
      DivFamZarAff.mapAlgHom (IsScalarTower.toAlgHom k A' B)
        (divRepPullAtAff hpi g r1 r2 b1 b2 U i' j' omega') := by
  apply divRepClassifyZarAff_injective hpi g hO hchi r1 r2 b1 b2
  apply Over.OverMorphism.ext
  let phi : A →ₐ[k] B := IsScalarTower.toAlgHom k A B
  let phi' : A' →ₐ[k] B := IsScalarTower.toAlgHom k A' B
  let FA := divRepPullAtAff hpi g r1 r2 b1 b2 U i j omega
  let FA' := divRepPullAtAff hpi g r1 r2 b1 b2 U i' j' omega'
  calc
    (divRepClassifyZarAff hpi g hO hchi r1 r2 b1 b2 B
        (DivFamZarAff.mapAlgHom phi FA)).left =
        Spec.map (CommRingCat.ofHom phi.toRingHom) ≫
          (divRepClassifyZarAff hpi g hO hchi r1 r2 b1 b2 A FA).left :=
      (specMap_comp_divRepClassifyZarAff hpi g hO hchi r1 r2 b1 b2 phi FA).symm
    _ = Spec.map (CommRingCat.ofHom phi.toRingHom) ≫
        (Spec.map (CommRingCat.ofHom omega.toRingHom) ≫
          (divRepClassifyZarAff hpi g hO hchi r1 r2 b1 b2
            (ChartRing i j) (U i j)).left) := by
      apply congrArg (fun z => Spec.map (CommRingCat.ofHom phi.toRingHom) ≫ z)
      exact (specMap_comp_divRepClassifyZarAff hpi g hO hchi
        r1 r2 b1 b2 omega (U i j)).symm
    _ = Spec.map (CommRingCat.ofHom (algebraMap A B)) ≫
        (Spec.map (CommRingCat.ofHom omega.toRingHom) ≫ ChartMap i j) := by
      rw [hU i j]
      rfl
    _ = Spec.map (CommRingCat.ofHom (algebraMap S B)) ≫ v.left :=
      specMap_chartMap_pushforward hpi g r1 r2 b1 b2 v omega homega
    _ = Spec.map (CommRingCat.ofHom (algebraMap A' B)) ≫
        (Spec.map (CommRingCat.ofHom omega'.toRingHom) ≫ ChartMap i' j') :=
      (specMap_chartMap_pushforward hpi g r1 r2 b1 b2 v omega' homega').symm
    _ = Spec.map (CommRingCat.ofHom phi'.toRingHom) ≫
        (Spec.map (CommRingCat.ofHom omega'.toRingHom) ≫
          (divRepClassifyZarAff hpi g hO hchi r1 r2 b1 b2
            (ChartRing i' j') (U i' j')).left) := by
      rw [hU i' j']
      rfl
    _ = Spec.map (CommRingCat.ofHom phi'.toRingHom) ≫
        (divRepClassifyZarAff hpi g hO hchi r1 r2 b1 b2 A' FA').left := by
      apply congrArg (fun z => Spec.map (CommRingCat.ofHom phi'.toRingHom) ≫ z)
      exact specMap_comp_divRepClassifyZarAff hpi g hO hchi
        r1 r2 b1 b2 omega' (U i' j')
    _ = (divRepClassifyZarAff hpi g hO hchi r1 r2 b1 b2 B
        (DivFamZarAff.mapAlgHom phi' FA')).left :=
      specMap_comp_divRepClassifyZarAff hpi g hO hchi r1 r2 b1 b2 phi' FA'

set_option maxHeartbeats 1600000 in
-- The canonical overlap installs the two localization algebra structures at once.