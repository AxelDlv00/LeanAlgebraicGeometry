import AlgebraicJacobian.Picard.Pic0ThetaAssembly
import AlgebraicJacobian.Picard.Pic0Pullback

set_option autoImplicit false
universe u
open CategoryTheory

namespace AlgebraicGeometry

section Identity

variable (k : Type u) [Field k]
variable (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]

noncomputable def eCurveId : pic0Functor ((baseChange k k).obj C) ≅ pic0Functor C where
  hom := pic0PullbackNat ((baseChange.idIso k).app C).inv
  inv := pic0PullbackNat ((baseChange.idIso k).app C).hom
  hom_inv_id := by rw [← pic0PullbackNat_comp, Iso.hom_inv_id, pic0PullbackNat_id]
  inv_hom_id := by rw [← pic0PullbackNat_comp, Iso.inv_hom_id, pic0PullbackNat_id]

noncomputable def mIdσ :
    Over.map (Spec.map (CommRingCat.ofHom (algebraMap k k))) ≅ 𝟭 (Over (Spec (.of k))) :=
  eqToIso (by rw [show Spec.map (CommRingCat.ofHom (algebraMap k k)) = 𝟙 _ by
    rw [Algebra.algebraMap_self, CommRingCat.ofHom_id, Spec.map_id]]) ≪≫ Over.mapId _

noncomputable def σkkCollapse :
    (Over.map (Spec.map (CommRingCat.ofHom (algebraMap k k)))).op ⋙ pic0Functor C
      ≅ pic0Functor C :=
  Functor.isoWhiskerRight (NatIso.op (mIdσ k)).symm (pic0Functor C)
    ≪≫ Functor.leftUnitor (pic0Functor C)

noncomputable def cocycleIdRHS :
    pic0Functor ((baseChange k k).obj C)
      ≅ (Over.map (Spec.map (CommRingCat.ofHom (algebraMap k k)))).op ⋙ pic0Functor C :=
  eCurveId k C ≪≫ (σkkCollapse k C).symm

-- CLAIM UNDER TEST (worksheet :114 / :375): does the K-1a headline even STATE?
#check (pic0Theta k k C = cocycleIdRHS k C : Prop)

-- And: does the file's Leg-1..3 `change` step really typecheck?
example : pic0Theta k k C = cocycleIdRHS k C := by
  apply Iso.ext
  ext T lam
  refine Subtype.ext ?_
  change picEtCrossBaseInv k k C (Opposite.unop T) lam.1
    = picEtMap C ((mIdσ k).hom.app (Opposite.unop T))
        (picEtPullback ((baseChange.idIso k).app C).inv (Opposite.unop T) lam.1)
  sorry

end Identity

end AlgebraicGeometry
