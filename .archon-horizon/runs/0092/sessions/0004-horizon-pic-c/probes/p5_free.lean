import AlgebraicJacobian.Picard.Pic0ChartSubsingletonCollapse
import AlgebraicJacobian.Picard.DivisorFamilyDegreeZeroRep

open CategoryTheory AlgebraicGeometry Opposite

section
variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} [IsAffineHom π] {n : ℕ}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

-- (B1) IS THE CONSEQUENT FREE FROM A WEAKER, NON-SUBSINGLETON HYPOTHESIS?
-- The Sigma first component of abelSigmaChart at u is u >>= D.hom.  If D.hom is MONO the
-- chart is injective on every test, with NO subsingleton anywhere.
example {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    [Mono D.hom] (T : Scheme.{u}ᵒᵖ) :
    Function.Injective ((abelSigmaChart C π n rep m Z hdeg).app T) := by
  intro u v h
  have h1 := congrArg Sigma.fst h
  exact (cancel_mono D.hom).mp h1

-- (B2) AT THE LANDED rep (D = Over.mk (id (Spec k))) the structure map IS an iso, hence mono,
-- so injectivity is FREE THERE with no subsingleton hypothesis.
example : Mono (Over.mk (𝟙 (Spec (CommRingCat.of k)))).hom := by
  have : (Over.mk (𝟙 (Spec (CommRingCat.of k)))).hom = 𝟙 _ := rfl
  rw [this]; infer_instance
end
