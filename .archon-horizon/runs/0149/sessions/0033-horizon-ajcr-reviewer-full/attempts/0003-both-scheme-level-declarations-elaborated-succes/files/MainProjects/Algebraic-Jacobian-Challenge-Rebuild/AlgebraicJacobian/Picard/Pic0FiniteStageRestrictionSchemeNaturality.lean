/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageRestrictionBaseChange

/-!
# Scheme naturality of finite-stage Picard restrictions

The affine base-change comparison and the final finite-stage ring comparison
combine to identify the pulled-back left restriction with the exact left
restriction in the separably closed Picard atlas.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TensorProduct
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

namespace Pic0FiniteStageGluePackage

variable (R K A B A' B' : Type u)
variable [CommRing R] [CommRing K] [CommRing A] [CommRing B]
  [CommRing A'] [CommRing B']
variable [Algebra R K] [Algebra R A] [Algebra R B]
  [Algebra K A'] [Algebra K B']

set_option maxHeartbeats 12800000 in
-- The proof expands tensor-product Spec maps and both comparison equivalences.
/-- A natural square of scalar-extended affine rings remains natural after the
pullback-Spec comparison and the two final ring identifications. -/
theorem affineBaseChangeIso_trans_naturality
    (phi : A →ₐ[R] B)
    (eA : K ⊗[R] A ≃ₐ[K] A')
    (eB : K ⊗[R] B ≃ₐ[K] B')
    (psi : A' →ₐ[K] B')
    (hnat :
      eB.toAlgHom.comp
          (AlgebraicJacobian.scalarExtensionMapOfAlgHom
            (R := R) (K := K) phi) =
        psi.comp eA.toAlgHom) :
    affineBaseChangeMap R K A B phi ≫
        (affineBaseChangeIso R K A ≪≫
          Scheme.Spec.mapIso eA.symm.toRingEquiv.toCommRingCatIso.op).hom =
      (affineBaseChangeIso R K B ≪≫
          Scheme.Spec.mapIso eB.symm.toRingEquiv.toCommRingCatIso.op).hom ≫
        Spec.map (CommRingCat.ofHom psi.toRingHom) := by
  let f := AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := R) (K := K) phi
  have hinv : f.comp eA.symm.toAlgHom = eB.symm.toAlgHom.comp psi := by
    ext x
    apply eB.injective
    have hx := DFunLike.congr_fun hnat (eA.symm x)
    simpa [f] using hx
  have hspec :
      Spec.map (CommRingCat.ofHom f.toRingHom) ≫
          (Scheme.Spec.mapIso eA.symm.toRingEquiv.toCommRingCatIso.op).hom =
        (Scheme.Spec.mapIso eB.symm.toRingEquiv.toCommRingCatIso.op).hom ≫
          Spec.map (CommRingCat.ofHom psi.toRingHom) := by
    change Spec.map (CommRingCat.ofHom f.toRingHom) ≫
        Spec.map eA.symm.toRingEquiv.toCommRingCatIso.hom =
      Spec.map eB.symm.toRingEquiv.toCommRingCatIso.hom ≫
        Spec.map (CommRingCat.ofHom psi.toRingHom)
    have hcat :
        eA.symm.toRingEquiv.toCommRingCatIso.hom ≫
            CommRingCat.ofHom f.toRingHom =
          CommRingCat.ofHom psi.toRingHom ≫
            eB.symm.toRingEquiv.toCommRingCatIso.hom := by
      ext x
      exact DFunLike.congr_fun hinv x
    calc
      _ = Spec.map (eA.symm.toRingEquiv.toCommRingCatIso.hom ≫
            CommRingCat.ofHom f.toRingHom) := (Spec.map_comp _ _).symm
      _ = Spec.map (CommRingCat.ofHom psi.toRingHom ≫
            eB.symm.toRingEquiv.toCommRingCatIso.hom) := congrArg Spec.map hcat
      _ = _ := Spec.map_comp _ _
  simp only [Iso.trans_hom]
  have haff := affineBaseChangeIso_naturality R K A B phi
  calc
    _ = (affineBaseChangeMap R K A B phi ≫
          (affineBaseChangeIso R K A).hom) ≫
        (Scheme.Spec.mapIso eA.symm.toRingEquiv.toCommRingCatIso.op).hom :=
      (Category.assoc _ _ _).symm
    _ = ((affineBaseChangeIso R K B).hom ≫
          Spec.map (CommRingCat.ofHom f.toRingHom)) ≫
        (Scheme.Spec.mapIso eA.symm.toRingEquiv.toCommRingCatIso.op).hom :=
      congrArg
        (fun h => h ≫
          (Scheme.Spec.mapIso eA.symm.toRingEquiv.toCommRingCatIso.op).hom)
        haff
    _ = (affineBaseChangeIso R K B).hom ≫
        (Spec.map (CommRingCat.ofHom f.toRingHom) ≫
          (Scheme.Spec.mapIso eA.symm.toRingEquiv.toCommRingCatIso.op).hom) :=
      Category.assoc _ _ _
    _ = (affineBaseChangeIso R K B).hom ≫
        ((Scheme.Spec.mapIso eB.symm.toRingEquiv.toCommRingCatIso.op).hom ≫
          Spec.map (CommRingCat.ofHom psi.toRingHom)) :=
      congrArg (fun h => (affineBaseChangeIso R K B).hom ≫ h) hspec
    _ = _ := (Category.assoc _ _ _).symm

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

set_option synthInstance.maxHeartbeats 3200000 in
-- Specialization unfolds the package's dependent finite-subextension towers.
set_option maxHeartbeats 12800000 in
/-- Under the final chart and overlap comparisons, the pulled-back left
restriction is the exact left restriction of the separably closed atlas. -/
theorem restrictionBaseChangeMap_naturality
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    restrictionBaseChangeMap C P U V ≫
        (chartRingBaseChangeIso C P U).hom =
      (overlapRingBaseChangeIso C P U V).hom ≫
        Spec.map (CommRingCat.ofHom
          (exactRestrictionAlgHom C U V).toRingHom) := by
  letI : Algebra.IsAlgebraic P.L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic P.M.1 k := by infer_instance
  apply affineBaseChangeIso_trans_naturality
    P.N.1 k
    (Pic0FiniteStageChartBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U)
    (Pic0FiniteStageOverlapBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U V)
    (Pic0FiniteStageRing C (Sum.inl U))
    (Pic0FiniteStageRing C (Sum.inr (U, V)))
    (restrictionBaseChangeAlgHom C P U V)
    (chartFinalBaseChangeEquiv C P U)
    (overlapFinalBaseChangeEquiv C P U V)
    (exactRestrictionAlgHom C U V)
  exact pic0FiniteStageFinalBaseChangeEquiv_naturality
    C P.L P.n P.m P.relation P.e P.M P.mapM P.hmapM P.N
      (Sum.inl (Sum.inl (U, V)))

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
