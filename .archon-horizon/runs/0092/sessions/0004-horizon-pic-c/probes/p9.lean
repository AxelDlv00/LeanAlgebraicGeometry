import AlgebraicJacobian.Picard.Pic0ChartSubsingletonCollapse

set_option autoImplicit false
set_option maxSynthPendingDepth 3
universe u
open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry
variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {pi : C.left ⟶ P1 k} [IsAffineHom pi] {n : ℕ}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]
noncomputable section

theorem probe_dup {D : Over (Spec (.of k))}
    (rep : (divFunctor C pi n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (h : IsChartLocusFibre C pi n rep m Z hdeg) :
    IsChartUniv C pi n rep m Z hdeg ⊤ :=
  isChartUniv_of_isChartLocusFibre rep m Z hdeg h ⊤

theorem probe_mono_free {D : Over (Spec (.of k))}
    (rep : (divFunctor C pi n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    [Mono D.hom] (T : Scheme.{u}ᵒᵖ) :
    Function.Injective ((abelSigmaChart C pi n rep m Z hdeg).app T) := by
  intro u v h
  exact (cancel_mono D.hom).mp (congrArg Sigma.fst h)

end
end AlgebraicGeometry

#print axioms AlgebraicGeometry.probe_dup
#print axioms AlgebraicGeometry.probe_mono_free
