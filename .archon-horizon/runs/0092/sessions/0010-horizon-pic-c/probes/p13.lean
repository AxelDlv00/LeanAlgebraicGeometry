import AlgebraicJacobian.Picard.Pic0ChartSeamPairDecided
set_option autoImplicit false
set_option maxSynthPendingDepth 3
universe u
open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory
namespace AlgebraicGeometry
namespace ProbeC13
variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {pi : C.left ⟶ P1 k} [IsAffineHom pi] {n : ℕ}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

-- (A) arbitrary n, Mono D.hom: coverage implies antecedent 1 for the GENERAL Abel chart
example {D : Over (Spec (.of k))} (rep : (divFunctor C pi n).RepresentableBy D) [Mono D.hom]
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (hcov : Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (abelSigmaChart C pi n rep m Z hdeg)) :
    IsOpenImmersion.presheaf (abelSigmaChart C pi n rep m Z hdeg) :=
  isOpenImmersion_presheaf_of_injective C _
    (injective_abelSigmaChart_of_mono rep m Z hdeg) hcov

-- (B) the Sigma.desc form the producer actually consumes, at a PUnit family
example {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    (h : Presheaf.IsLocallySurjective Scheme.zariskiTopology f) :
    Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (Sigma.desc (fun _ : PUnit.{u+1} => f)) := by
  haveI := h
  exact Presheaf.isLocallySurjective_of_isLocallySurjective_fac
    (J := Scheme.zariskiTopology)
    (f₁ := Sigma.ι (fun _ : PUnit.{u+1} => yoneda.obj X) PUnit.unit)
    (f₂ := Sigma.desc (fun _ : PUnit.{u+1} => f))
    (Sigma.ι_desc (fun _ : PUnit.{u+1} => f) PUnit.unit)

theorem controlSorry : (1:ℕ) = 1 := by sorry
end ProbeC13
end AlgebraicGeometry
