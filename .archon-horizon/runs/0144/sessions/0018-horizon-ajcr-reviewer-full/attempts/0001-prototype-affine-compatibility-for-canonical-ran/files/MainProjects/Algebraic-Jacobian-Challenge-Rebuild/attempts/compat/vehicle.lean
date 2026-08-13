import AlgebraicJacobian.Picard.Pic0CriticalPath

set_option autoImplicit false
set_option maxSynthPendingDepth 3
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory Limits TopologicalSpace Opposite MonoidalCategory
  CartesianMonoidalCategory

namespace AlgebraicGeometry

attribute [local instance] Over.sectionsAlgebra Scheme.overModule Scheme.overSectionsAlgebra
attribute [local instance 10000] relCurve.instOver

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

noncomputable section

local notation "pi0" => divRepAffP1Map C
local notation "hpi0" => divRepAffP1Map_comp C

variable
  (canon : ∀ {A : Type u} [CommRing A] [Algebra k A]
    {lam : picDegLayer C (genus C : ℤ) (overSpec k A)},
    lam ∈ (PicRankOneOpen pi0).obj (op (overSpec k A)) →
      DivFamZarAff C A (genus C))
  (canon_abel : ∀ {A : Type u} [CommRing A] [Algebra k A]
    {lam : picDegLayer C (genus C : ℤ) (overSpec k A)},
    (hlam : lam ∈ (PicRankOneOpen pi0).obj (op (overSpec k A))) →
    abelDivAffPlus C A (canon hlam) = picEtAffineEquiv C A lam.1)
  (canon_unique : ∀ {A : Type u} [CommRing A] [Algebra k A]
    {lam : picDegLayer C (genus C : ℤ) (overSpec k A)},
    (hlam : lam ∈ (PicRankOneOpen pi0).obj (op (overSpec k A)))
    (F : DivFamZarAff C A (genus C))
    (hF : abelDivAffPlus C A F = picEtAffineEquiv C A lam.1) :
    F = canon hlam)

def rankOneComponent (T : Over (Spec (.of k)))
    (lam : (PicRankOneOpen pi0).obj (op T))
    (U : T.left.affineOpens) : DivFamZarAff C (Γ(T.left, U.1)) (genus C) :=
  canon (picRankOneOpen_map_mem pi0 (Over.fromSpecAffine T U).op lam.2)

lemma rankOneComponent_compat (T : Over (Spec (.of k)))
    (lam : (PicRankOneOpen pi0).obj (op T))
    {U V : T.left.affineOpens} (hUV : U.1 ≤ V.1) :
    DivFamZarAff.mapAlgHom (Over.resAlgHom T hUV)
      (rankOneComponent canon T lam V) = rankOneComponent canon T lam U := by
  apply canon_unique (hlam := picRankOneOpen_map_mem pi0
    (Over.fromSpecAffine T U).op lam.2)
  rw [← abelDivAffPlus_mapAlgHom (Over.resAlgHom T hUV)
    (rankOneComponent canon T lam V), canon_abel]
  rw [picEtAffineEquiv_naturality]
  -- identify the two affine pullbacks of the input class
  have hcomp := Over.fromSpecAffine_resAlgHom (T := T) hUV
  rw [← picEtMap_comp C (Over.fromSpecAffine T V)
    (Over.overSpecMap (Over.resAlgHom T hUV)) lam.1]
  rw [hcomp]

def rankOneVehicle (T : Over (Spec (.of k)))
    (lam : (PicRankOneOpen pi0).obj (op T)) : divFamZarAff C (genus C) T :=
  ⟨fun U => rankOneComponent canon T lam U, by
    intro U V hUV
    exact rankOneComponent_compat canon canon_abel canon_unique T lam hUV⟩

end
end AlgebraicGeometry
