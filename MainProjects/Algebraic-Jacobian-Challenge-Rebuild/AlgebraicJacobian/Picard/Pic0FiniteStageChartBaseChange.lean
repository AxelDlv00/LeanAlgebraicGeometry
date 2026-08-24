/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageFinalBaseChange

/-!
# Base change of the finite-stage Picard charts

Each chart inclusion in the finite-stage glue lies over its affine structure map.
After extending from the final finite subextension to the separably closed field,
the affine pullback formula and the final ring comparison identify that chart with
the corresponding chart in the exact Picard atlas.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TensorProduct
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

/-- The spectrum of an algebra homomorphism lies over the base spectrum. -/
theorem specMap_algHom_comp_algebraMap
    {R A B : Type u} [CommRing R] [CommRing A] [CommRing B]
    [Algebra R A] [Algebra R B] (r : A →ₐ[R] B) :
    Spec.map (CommRingCat.ofHom r.toRingHom) ≫
        Spec.map (CommRingCat.ofHom (algebraMap R A)) =
      Spec.map (CommRingCat.ofHom (algebraMap R B)) := by
  rw [← Spec.map_comp]
  rw [← CommRingCat.ofHom_comp]
  congr 1
  ext x
  exact r.commutes x

namespace Pic0FiniteStageGluePackage

private theorem affineOpen_fromSpec_comp_structureMap
    {R : Type u} [CommRing R] (X : Over (Spec (.of R)))
    (U : X.left.affineOpens) :
    U.2.fromSpec ≫ X.hom =
      Spec.map (CommRingCat.ofHom (X.left.overAlgebraMap R U.1)) := by
  rw [← IsAffineOpen.SpecMap_appLE_fromSpec X.hom
    (isAffineOpen_top (Spec (.of R))) U.2 le_top]
  rw [Scheme.overAlgebraMap]
  simp only [Scheme.Hom.appLE, CommRingCat.hom_comp, Spec.map_comp]
  rw [IsAffineOpen.fromSpec_top]
  simp

private theorem pullbackChartIso_hom_comp_structureMap
    {R S B : Type u} [CommRing R] [CommRing S] [CommRing B]
    [Algebra R S] [Algebra R B]
    (X : Over (Spec (.of S))) (U : X.left.affineOpens)
    (e : S ⊗[R] B ≃+* Γ(X.left, U.1))
    (he : e.symm.toRingHom.comp (X.left.overAlgebraMap S U.1) =
      algebraMap S (S ⊗[R] B)) :
    (pullbackSymmetry
          (Spec.map (CommRingCat.ofHom (algebraMap R B)))
          (Spec.map (CommRingCat.ofHom (algebraMap R S))) ≪≫
        pullbackSpecIso R S B ≪≫
        Scheme.Spec.mapIso e.symm.toCommRingCatIso.op ≪≫
        U.2.isoSpec.symm).hom ≫
        U.1.ι ≫ X.hom =
      pullback.snd
        (Spec.map (CommRingCat.ofHom (algebraMap R B)))
        (Spec.map (CommRingCat.ofHom (algebraMap R S))) := by
  letI : Algebra S Γ(X.left, U.1) :=
    (X.left.overAlgebraMap S U.1).toAlgebra
  let eAlg : Γ(X.left, U.1) →ₐ[S] S ⊗[R] B :=
    { e.symm.toRingHom with
      commutes' := fun x => DFunLike.congr_fun he x }
  have hmapIso :
      Scheme.Spec.map e.symm.toCommRingCatIso.op.hom =
        Spec.map (CommRingCat.ofHom eAlg.toRingHom) := rfl
  calc
    _ = (pullbackSymmetry
            (Spec.map (CommRingCat.ofHom (algebraMap R B)))
            (Spec.map (CommRingCat.ofHom (algebraMap R S)))).hom ≫
          (pullbackSpecIso R S B).hom ≫
          Spec.map (CommRingCat.ofHom eAlg.toRingHom) ≫
          U.2.fromSpec ≫ X.hom := by
        simp only [Iso.trans_hom, Iso.symm_hom, Functor.mapIso_hom]
        rw [hmapIso]
        rfl
    _ = (pullbackSymmetry
            (Spec.map (CommRingCat.ofHom (algebraMap R B)))
            (Spec.map (CommRingCat.ofHom (algebraMap R S)))).hom ≫
          (pullbackSpecIso R S B).hom ≫
          Spec.map (CommRingCat.ofHom eAlg.toRingHom) ≫
          Spec.map (CommRingCat.ofHom (algebraMap S Γ(X.left, U.1))) := by
        rw [affineOpen_fromSpec_comp_structureMap X U]
    _ = (pullbackSymmetry
            (Spec.map (CommRingCat.ofHom (algebraMap R B)))
            (Spec.map (CommRingCat.ofHom (algebraMap R S)))).hom ≫
          (pullbackSpecIso R S B).hom ≫
          Spec.map (CommRingCat.ofHom
            (algebraMap S (S ⊗[R] B))) := by
        rw [specMap_algHom_comp_algebraMap eAlg]
    _ = (pullbackSymmetry
            (Spec.map (CommRingCat.ofHom (algebraMap R B)))
            (Spec.map (CommRingCat.ofHom (algebraMap R S)))).hom ≫
          pullback.fst
            (Spec.map (CommRingCat.ofHom (algebraMap R S)))
            (Spec.map (CommRingCat.ofHom (algebraMap R B))) := by
        rw [pullbackSpecIso_hom_fst]
    _ = _ := pullbackSymmetry_hom_comp_fst _ _

set_option synthInstance.maxHeartbeats 3200000 in
-- Projecting the package retains the nested finite-subextension scalar towers.
set_option maxHeartbeats 12800000 in
/-- Every finite-stage chart inclusion lies over the chart's affine structure map. -/
@[reassoc]
theorem glueData_ι_gluedMap
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U : Pic0FiniteStageChartIndex C) :
    P.glueData.ι U ≫ P.gluedMap =
      Spec.map (CommRingCat.ofHom
        (algebraMap P.N.1
          (Pic0FiniteStageChartBaseChangeRing
            C P.L P.n P.m P.relation P.M P.N U))) := by
  unfold gluedMap
  exact Multicoequalizer.π_desc _ _ _ _ _

set_option synthInstance.maxHeartbeats 3200000 in
-- The composite infers the same nested tensor-product instances as the ring comparison.
set_option maxHeartbeats 12800000 in
/-- Base change of a finite-stage affine chart recovers the corresponding chart in the
exact separably closed Picard atlas. -/
noncomputable def chartBaseChangeIso
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U : Pic0FiniteStageChartIndex C) :
    pullback
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageChartBaseChangeRing
              C P.L P.n P.m P.relation P.M P.N U))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≅
      (pic0SepClosedAtlasOpenCover C).X U :=
  pullbackSymmetry _ _ ≪≫
    pullbackSpecIso P.N.1 k
      (Pic0FiniteStageChartBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U) ≪≫
    Scheme.Spec.mapIso
      (pic0FiniteStageFinalBaseChangeEquiv
        C P.L P.n P.m P.relation P.e P.M P.N
          (Sum.inl U)).symm.toRingEquiv.toCommRingCatIso.op ≪≫
    U.1.2.isoSpec.symm

set_option synthInstance.maxHeartbeats 3200000 in
set_option maxHeartbeats 12800000 in
/-- The chart comparison preserves the structure morphism to the separably closed field. -/
@[reassoc]
theorem chartBaseChangeIso_hom_structureMap
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U : Pic0FiniteStageChartIndex C) :
    (chartBaseChangeIso C P U).hom ≫ U.1.1.ι ≫
        (pic0_sepClosed_representableBy (C := C)).1.hom =
      pullback.snd
        (Spec.map (CommRingCat.ofHom
          (algebraMap P.N.1
            (Pic0FiniteStageChartBaseChangeRing
              C P.L P.n P.m P.relation P.M P.N U))))
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) := by
  let J := (pic0_sepClosed_representableBy (C := C)).1
  let e := pic0FiniteStageFinalBaseChangeEquiv
    C P.L P.n P.m P.relation P.e P.M P.N (Sum.inl U)
  have he :
      e.symm.toRingHom.comp (J.left.overAlgebraMap k U.1.1) =
        algebraMap k
          (k ⊗[P.N.1]
            Pic0FiniteStageChartBaseChangeRing
              C P.L P.n P.m P.relation P.M P.N U) := by
    ext x
    change e.symm (algebraMap k (Pic0FiniteStageChartRing C U) x) =
      algebraMap k
        (k ⊗[P.N.1]
          Pic0FiniteStageChartBaseChangeRing
            C P.L P.n P.m P.relation P.M P.N U) x
    exact e.symm.commutes x
  exact pullbackChartIso_hom_comp_structureMap J U.1 e.toRingEquiv he

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
