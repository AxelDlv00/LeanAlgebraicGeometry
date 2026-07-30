import AlgebraicJacobian.Picard.Pic0VanishingFieldGenusZero
import AlgebraicJacobian.Picard.Pic0VanishingAffineReduction

set_option autoImplicit false
set_option maxHeartbeats 1600000
universe u
open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

/-- At genus 0: a plus class over a FIELD test of degree zero is trivial. -/
example (K : Type u) [Field K] [Algebra k K] (hg : genus C = 0)
    (q : PicEtAff C K) (hq : PicEtAff.degAff (C := C) K q = 0) : q = 1 := by
  induction q using PicEtAff.ind with
  | mk E x =>
    obtain ⟨L, hLf, hLa, hLfin, hLsep, ⟨j⟩⟩ := E.exists_finiteSeparableField_algHom
    letI := hLf; letI := hLa; letI := hLfin; letI := hLsep
    letI : Algebra k L := ((algebraMap K L).comp (algebraMap k K)).toAlgebra
    haveI : IsScalarTower k K L := IsScalarTower.of_algebraMap_eq fun _ => rfl
    have hdeg : relPicDeg (C := C) L (relPicAlgMap C (j.restrictScalars k)
        (x : relPic C (overSpec k E.Carrier))) = 0 := by
      rw [← PicEtAff.degAff_mk (C := C) (K := K) E x L j]
      exact hq
    have htriv : relPicAlgMap C (j.restrictScalars k)
        (x : relPic C (overSpec k E.Carrier)) = 1 :=
      relPic_eq_one_of_relPicDeg_eq_zero_of_genus_zero C L hg _ hdeg
    -- the class is 1 because it becomes 1 on a refinement (the field cover)
    -- x becomes 1 after transport to the field cover, and the plus class is unchanged there
    have hstep : PicEtAff.mk C (Algebra.EtaleCover.ofField (K := K) L)
        (descentMap C ((Algebra.EtaleCover.ofFieldEquiv (K := K) L).symm.toAlgHom.comp j) x)
        = PicEtAff.mk C E x := PicEtAff.mk_descentMap C _ x
    rw [← hstep]
    convert PicEtAff.mk_one C (Algebra.EtaleCover.ofField (K := K) L) using 2
    refine Subtype.ext ?_
    rw [descentMap_coe]
    have : ((Algebra.EtaleCover.ofFieldEquiv (K := K) L).symm.toAlgHom.comp j).restrictScalars k
        = ((Algebra.EtaleCover.ofFieldEquiv (K := K) L).symm.toAlgHom.restrictScalars k).comp
          (j.restrictScalars k) := rfl
    rw [this, relPicAlgMap_comp, htriv, map_one]
    rfl

/-- CONSEQUENCE: at genus 0, pic0Subgroup vanishes at every FIELD test. -/
example (K : Type u) [Field K] [Algebra k K] (hg : genus C = 0)
    (hplus : ∀ (L : Type u) (_ : Field L) (_ : Algebra k L) (q : PicEtAff C L),
      PicEtAff.degAff (C := C) L q = 0 → q = 1) :
    Subsingleton (pic0Subgroup C (overSpec k K)) := by
  refine ⟨fun s t => Subtype.ext ?_⟩
  refine (picEtAffineEquiv C K).injective ?_
  have hs : PicEtAff.degAff (C := C) K (picEtAffineEquiv C K s.1) = 0 := by
    have := s.2 K (𝟙 (overSpec k K))
    rwa [degAt, picEtMap_id] at this
  have ht : PicEtAff.degAff (C := C) K (picEtAffineEquiv C K t.1) = 0 := by
    have := t.2 K (𝟙 (overSpec k K))
    rwa [degAt, picEtMap_id] at this
  have h1 := hplus K ‹Field K› ‹Algebra k K› (picEtAffineEquiv C K s.1) hs
  have h2 := hplus K ‹Field K› ‹Algebra k K› (picEtAffineEquiv C K t.1) ht
  exact h1.trans h2.symm

end AlgebraicGeometry
