import AlgebraicJacobian.Picard.Pic0RankOneAbelInverse
import AlgebraicJacobian.Picard.DivRepAffFaithfullyFlatDescent
set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3
universe u
open CategoryTheory Limits Opposite
namespace AlgebraicGeometry
attribute [local instance] Over.sectionsAlgebra Scheme.overModule Scheme.overSectionsAlgebra
variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
-- use existing declarations from global scratch by recreate minimal axioms and section
variable (pi : C.left ⟶ P1 k) [IsFinite pi]
noncomputable section
axiom canon (hpi : pi ≫ P1.structureMap k = C.hom)
    {A : Type u} [CommRing A] [Algebra k A]
    {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}
    (hlam : lam ∈ (PicRankOneOpen pi).obj (op (overSpec k A))) : DivFamZarAff C A (genus C)
axiom canon_abel (hpi : pi ≫ P1.structureMap k = C.hom)
    {A : Type u} [CommRing A] [Algebra k A]
    {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}
    (hlam : lam ∈ (PicRankOneOpen pi).obj (op (overSpec k A))) :
    abelDivAffPlus C A (canon pi hpi hlam) = picEtAffineEquiv C A lam.1
axiom canon_unique (hpi : pi ≫ P1.structureMap k = C.hom)
    {A : Type u} [CommRing A] [Algebra k A]
    {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}
    (hlam : lam ∈ (PicRankOneOpen pi).obj (op (overSpec k A)))
    (F : DivFamZarAff C A (genus C))
    (hF : abelDivAffPlus C A F = picEtAffineEquiv C A lam.1) : F = canon pi hpi hlam

-- Paste earlier definitions through canonicalSectionTrans from global scratch.
-- We import it textually only for experiments by making a dummy declared trans.
axiom canonicalSectionTrans :
    (PicRankOneOpen (divRepAffP1Map C)).toFunctor ⟶
      (divRankOnePresentationPreimageAff (divRepAffP1Map C)).toFunctor

noncomputable def testApp (T : (Over (Spec (.of k)))ᵒᵖ)
    (lam : (PicRankOneOpen (divRepAffP1Map C)).toFunctor.obj T) :
    (divRankOnePresentationPreimageRepresenter (divRepAffP1Map C)).toFunctor.obj T := by
  let q := (canonicalSectionTrans (C := C)).app T lam
  let z := (divFunctorAff_genus_representableBy C).toIso.inv.app T q.1
  have hq : q.1 ∈ (divRankOnePresentationPreimageAff (divRepAffP1Map C)).obj T := q.2
  have hz : (divFunctorAff_genus_representableBy C).toIso.hom.app T z = q.1 := by
    exact (divFunctorAff_genus_representableBy C).toIso.inv_hom_id_app_apply T q.1
  refine ⟨z, ?_⟩
  change (divFunctorAff_genus_representableBy C).toIso.hom.app T z ∈
    (divRankOnePresentationPreimageAff (divRepAffP1Map C)).obj T
  rw [hz]
  exact hq

noncomputable def testApp2 (T : (Over (Spec (.of k)))ᵒᵖ)
    (lam : (PicRankOneOpen (divRepAffP1Map C)).toFunctor.obj T) :
    (divRankOnePresentationPreimageRepresenter (divRepAffP1Map C)).toFunctor.obj T := by
  let q := (canonicalSectionTrans (C := C)).app T lam
  have hq : q.1 ∈ (divRankOnePresentationPreimageAff (divRepAffP1Map C)).obj T := q.2
  refine ⟨(divFunctorAff_genus_representableBy C).toIso.inv.app T q.1, ?_⟩
  change (divFunctorAff_genus_representableBy C).toIso.hom.app T
      ((divFunctorAff_genus_representableBy C).toIso.inv.app T q.1) ∈
        (divRankOnePresentationPreimageAff (divRepAffP1Map C)).obj T
  have h := (divFunctorAff_genus_representableBy C).toIso.inv_hom_id_app_apply T q.1
  exact h ▸ hq

end
end AlgebraicGeometry
