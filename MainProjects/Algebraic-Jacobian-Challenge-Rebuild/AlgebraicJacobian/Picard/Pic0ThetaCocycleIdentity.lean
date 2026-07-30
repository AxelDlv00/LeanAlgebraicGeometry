/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ThetaProjectionCoherence

/-!
# Identity coherence for the degree-zero Picard base-change comparison

This file proves that `pic0Theta` over the identity field extension agrees with the
canonical collapse of the base-changed curve and pushed test object.
-/

set_option autoImplicit false

universe u

open CategoryTheory

namespace AlgebraicGeometry

attribute [local instance] Over.sectionsAlgebra

section Identity

variable (k : Type u) [Field k]
variable (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]

/-- The iso-grade curve transport at the identity base change. -/
noncomputable def eCurveId : pic0Functor ((baseChange k k).obj C) ≅ pic0Functor C where
  hom := pic0PullbackNat ((baseChange.idIso k).app C).inv
  inv := pic0PullbackNat ((baseChange.idIso k).app C).hom
  hom_inv_id := by rw [← pic0PullbackNat_comp, Iso.hom_inv_id, pic0PullbackNat_id]
  inv_hom_id := by rw [← pic0PullbackNat_comp, Iso.inv_hom_id, pic0PullbackNat_id]

/-- Pushing a test object along the identity field map leaves its carrier unchanged. -/
noncomputable def mIdσ :
    Over.map (Spec.map (CommRingCat.ofHom (algebraMap k k))) ≅ 𝟭 (Over (Spec (.of k))) :=
  let σ := Spec.map (CommRingCat.ofHom (algebraMap k k))
  have hσ : σ = 𝟙 (Spec (.of k)) := by
    dsimp [σ]
    simp
  NatIso.ofComponents (fun T => Over.isoMk (Iso.refl T.left) (by
    exact (Category.id_comp T.hom).trans
      ((congrArg (fun q => T.hom ≫ q) hσ).trans (Category.comp_id T.hom)).symm)) (fun f => by
      apply Over.OverMorphism.ext
      simp)

@[simp]
theorem mIdσ_hom_app_left (T : Over (Spec (.of k))) :
    ((mIdσ k).hom.app T).left = 𝟙 T.left := by
  simp [mIdσ]

private theorem algebra_eq_of_self_tower {B : Type u} [CommRing B]
    (iT iD : Algebra k B)
    (tw : @IsScalarTower k k B (Algebra.id k).toSMul iT.toSMul iD.toSMul) :
    iD = iT := by
  refine Algebra.algebra_ext _ _ fun r => ?_
  rw [@IsScalarTower.algebraMap_eq k k B _ _ _ (Algebra.id k) iT iD tw]
  rfl

/-- At the identity extension, the section algebra of a pushed test is the original
section algebra. -/
theorem sectionsAlgebra_mapSelf_eq (T : Over (Spec (.of k))) (U : T.left.Opens) :
    Over.sectionsAlgebra
        ((Over.map (Spec.map (CommRingCat.ofHom (algebraMap k k)))).obj T) U =
      Over.sectionsAlgebra T U := by
  exact algebra_eq_of_self_tower k
    (Over.sectionsAlgebra T U)
    (Over.sectionsAlgebra
      ((Over.map (Spec.map (CommRingCat.ofHom (algebraMap k k)))).obj T) U)
    (Over.isScalarTower_sections_map k k T U)

/-- The collapse of the pushed-test functor at the identity field extension. -/
noncomputable def σkkCollapse :
    (Over.map (Spec.map (CommRingCat.ofHom (algebraMap k k)))).op ⋙ pic0Functor C
      ≅ pic0Functor C :=
  Functor.isoWhiskerRight (NatIso.op (mIdσ k)).symm (pic0Functor C)
    ≪≫ Functor.leftUnitor (pic0Functor C)

/-- The canonical right-hand side of the theta identity coherence. -/
noncomputable def cocycleIdRHS :
    pic0Functor ((baseChange k k).obj C)
      ≅ (Over.map (Spec.map (CommRingCat.ofHom (algebraMap k k)))).op ⋙ pic0Functor C :=
  eCurveId k C ≪≫ (σkkCollapse k C).symm

set_option maxHeartbeats 1000000 in
-- Eliminating the dependent section-algebra instance equality exceeds the default budget.
/-- The theta comparison over `k -> k` is the canonical identity comparison. -/
theorem pic0Theta_id : pic0Theta k k C = cocycleIdRHS k C := by
  apply Iso.ext
  ext T lam
  refine Subtype.ext ?_
  change picEtCrossBaseInv k k C (Opposite.unop T) lam.1
    = picEtMap C ((mIdσ k).hom.app (Opposite.unop T))
        (picEtPullback ((baseChange.idIso k).app C).inv (Opposite.unop T) lam.1)
  refine picEt.ext fun W => ?_
  rw [picEtCrossBaseInv_val, picEtMap_val]
  have hW : W.1 ≤ ((mIdσ k).hom.app (Opposite.unop T)).left ⁻¹ᵁ W.1 := by
    rw [mIdσ_hom_app_left]
    exact le_rfl
  calc
    (sectionShuffle k k C (Opposite.unop T) W.1).symm
        (lam.1.1 ⟨W.1, W.2⟩) =
      PicEtAff.mapAlg C
        (Over.appLEAlgHom ((mIdσ k).hom.app (Opposite.unop T)) W.1 W.1 hW)
        ((picEtPullback ((baseChange.idIso k).app C).inv
          (Opposite.unop T) lam.1).1 W) := by
      have hA := sectionsAlgebra_mapSelf_eq k (Opposite.unop T) W.1
      cases hA
      have happ :
          Over.appLEAlgHom ((mIdσ k).hom.app (Opposite.unop T)) W.1 W.1 hW =
            AlgHom.id k Γ((Opposite.unop T).left, W.1) := by
        apply AlgHom.ext
        intro s
        change ((mIdσ k).hom.app (Opposite.unop T)).left.appLE W.1 W.1 hW s = s
        rw [Scheme.Hom.appLE_congr_hom
          (mIdσ_hom_app_left k (Opposite.unop T)) W.1 W.1 hW le_rfl]
        simp [Scheme.Hom.appLE]
      rw [picEtPullback_val, happ, PicEtAff.mapAlg_id]
      change (crossBaseTransportFamilyInv k k C).picEtAffHom _ _ =
        (curveTransportFamily ((baseChange.idIso k).app C).inv).picEtAffHom _ _
      exact RelPicTransportFamily.picEtAffHom_congr _ _ (fun B _ _ _ _ _ _ => by
        rw [crossBaseTransportFamilyInv_hom, curveTransportFamily_hom,
          crossBaseAffineIso_inv_eq_whiskerRight]) _ _
    _ = picEtMapVal C ((mIdσ k).hom.app (Opposite.unop T))
        (picEtPullback ((baseChange.idIso k).app C).inv (Opposite.unop T) lam.1) W :=
      (picEtMapVal_eq_mapAlg C _ _ (V := W) hW).symm

end Identity

end AlgebraicGeometry
