import AlgebraicJacobian.Picard.Pic0ChartSubsingletonCollapse

open CategoryTheory AlgebraicGeometry

section
variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} [IsAffineHom π] {n : ℕ}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

-- (E1) isChartUniv_top_of_isChartLocusFibre is a SPECIAL CASE of the landed
-- isChartUniv_of_isChartLocusFibre, which holds at ARBITRARY V.  One application:
example {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (h : IsChartLocusFibre C π n rep m Z hdeg) :
    IsChartUniv C π n rep m Z hdeg ⊤ :=
  isChartUniv_of_isChartLocusFibre rep m Z hdeg h ⊤
end
