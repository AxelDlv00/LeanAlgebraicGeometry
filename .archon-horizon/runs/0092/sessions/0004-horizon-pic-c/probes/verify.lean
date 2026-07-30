import AlgebraicJacobian.Picard.Pic0ChartSubsingletonCollapse

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u
open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} [IsAffineHom π] {n : ℕ}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

/-- REVIEWER'S REFUTATION, re-derived: Mono D.hom alone gives injectivity, at arbitrary n,
with no subsingleton anywhere. If this elaborates, my hypothesis is far stronger than needed. -/
theorem verify_mono_free {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    [Mono D.hom] (T : Scheme.{u}ᵒᵖ) :
    Function.Injective ((abelSigmaChart C π n rep m Z hdeg).app T) := by
  intro u v h
  exact (cancel_mono D.hom).mp (congrArg Sigma.fst h)

/-- And: does my subsingleton hypothesis IMPLY Mono D.hom?  If yes, the Mono form is the
genuinely general statement and mine is its corollary. -/
theorem verify_mono_of_subsingleton {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (hsub : DivFunctorObjSubsingleton C π n) :
    Mono D.hom := by
  refine ⟨fun {W} u v huv => ?_⟩
  exact Functor.RepresentableBy.eq_of_comp_hom_eq_of_subsingleton rep (hsub _) huv

/-- REVIEWER'S CLAIM (e): isChartUniv_of_isChartLocusFibre already gives arbitrary V, so my
isChartUniv_top_of_isChartLocusFibre is a strict instance. -/
theorem verify_dup {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (h : IsChartLocusFibre C π n rep m Z hdeg) :
    IsChartUniv C π n rep m Z hdeg ⊤ :=
  isChartUniv_of_isChartLocusFibre rep m Z hdeg h ⊤

end AlgebraicGeometry
