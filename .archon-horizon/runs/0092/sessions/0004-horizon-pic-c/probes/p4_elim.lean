import AlgebraicJacobian.Picard.Pic0ChartSubsingletonCollapse

open CategoryTheory AlgebraicGeometry

section
variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} [IsAffineHom π]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

-- (C1) CONVERSE direction: does the "eliminated" form IMPLY the coupled one at general V?
-- i.e. is the new statement strictly weaker (fewer conclusions) or just an instance?
-- Test: can I recover pic0RepresentableBy_of_isChartLocusFibre_of_coverage's hypotheses
-- from the coupled assembly's hypotheses at V := top, with no extra work?
example {ι : Type u} (nn : ι → ℕ) (D : ι → Over (Spec (.of k)))
    (rep : ∀ i, (divFunctor C π (nn i)).RepresentableBy (D i))
    (m : ι → ℕ) (Z : ι → (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : ∀ i, Scheme.CurveDivisor.deg k (Z i)
      = (m i : ℤ) * classDeg k (thetaCechClass C) - (nn i : ℤ))
    (huniv : ∀ i, RestrictedChartFibre C π (nn i) (rep i) (m i) (Z i) (hdeg i) ⊤)
    (hcov : ∀ (T : Scheme.{u}) (s : (pic0SigmaSheaf C).1.obj (Opposite.op T)) (t : ↥T),
      ∃ (W : T.Opens) (_ : t ∈ W) (i : ι) (x : (W : Scheme.{u}) ⟶ (D i).left),
        (abelSigmaChart C π (nn i) (rep i) (m i) (Z i) (hdeg i)).app
            (Opposite.op (W : Scheme.{u})) x
          = (pic0SigmaSheaf C).1.map (W.ι).op s ∧
        Set.range (x.base) ⊆ Set.range ((⊤ : (D i).left.Opens).ι.base)) :
    Σ J : Over (Spec (.of k)), (pic0TypeFunctor C).RepresentableBy J :=
  pic0RepresentableBy_of_restrictedChartFibre_of_coverage C π nn D rep m Z hdeg
    (fun _ => ⊤) huniv hcov

-- (C2) IS THE hcov TRANSLATION ACTUALLY FREE, i.e. is the plain PointwiseCoverage
-- DEFINITIONALLY the containment-augmented one at top?  If rfl works, the "elimination"
-- of containment is definitional.
example {ι : Type u} (nn : ι → ℕ) (D : ι → Over (Spec (.of k)))
    (rep : ∀ i, (divFunctor C π (nn i)).RepresentableBy (D i))
    (m : ι → ℕ) (Z : ι → (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : ∀ i, Scheme.CurveDivisor.deg k (Z i)
      = (m i : ℤ) * classDeg k (thetaCechClass C) - (nn i : ℤ)) :
    True := trivial
end
