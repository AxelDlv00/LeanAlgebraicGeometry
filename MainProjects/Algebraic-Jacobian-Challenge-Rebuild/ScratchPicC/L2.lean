import AlgebraicJacobian.Picard.Pic0VanishingAffineReduction

set_option autoImplicit false
universe u
open CategoryTheory

namespace AlgebraicGeometry

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

/-- CLAIM: plus -> relPic collapse is free. -/
example
    (hrel : ∀ (A : Type u) [CommRing A] [Algebra k A],
      Subsingleton (relPic C (overSpec k A)))
    (A : Type u) [CommRing A] [Algebra k A] : Subsingleton (PicEtAff C A) := by
  refine ⟨fun q q' => ?_⟩
  induction q using PicEtAff.ind with
  | mk E x =>
    induction q' using PicEtAff.ind with
    | mk F y =>
      have hx : x.1 = 1 := @Subsingleton.elim _ (hrel E.Carrier) _ _
      have hy : y.1 = 1 := @Subsingleton.elim _ (hrel F.Carrier) _ _
      rw [show x = 1 from Subtype.ext hx, show y = 1 from Subtype.ext hy,
        PicEtAff.mk_one, PicEtAff.mk_one]

end AlgebraicGeometry
