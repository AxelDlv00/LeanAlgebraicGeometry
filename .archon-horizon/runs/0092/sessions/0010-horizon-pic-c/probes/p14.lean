import AlgebraicJacobian.Picard.Pic0ChartSeamPairDecided
set_option autoImplicit false
set_option maxSynthPendingDepth 3
universe u
open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory
namespace AlgebraicGeometry
namespace ProbeC14
variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {pi : C.left ⟶ P1 k} [IsAffineHom pi]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
variable [IsIntegral (C ⊗ overSpec k k).left]

-- THE SEAM FIRED: pic0RepresentableByOfCharts at the PUnit family of the terminal chart
noncomputable example (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - ((0 : ℕ) : ℤ))
    (hvan : ∀ S : Over (Spec (.of k)), Subsingleton (pic0Subgroup C S)) :
    (pic0TypeFunctor C).RepresentableBy
      (Over.mk ((Scheme.LocalRepresentability.representableBy
        (fun _ : PUnit.{u+1} => (seamPair_abelSigmaChartZero_of_subsingleton
          C pi m Z hdeg hvan).1)).homEquiv
        (𝟙 (Scheme.LocalRepresentability.glueData
          (fun _ : PUnit.{u+1} => (seamPair_abelSigmaChartZero_of_subsingleton
            C pi m Z hdeg hvan).1)).glued)).1) := by
  haveI : Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (Sigma.desc (fun _ : PUnit.{u+1} => abelSigmaChartZero (C := C) (pi := pi) m Z hdeg)) := by
    haveI := (seamPair_abelSigmaChartZero_of_subsingleton C pi m Z hdeg hvan).2
    exact Presheaf.isLocallySurjective_of_isLocallySurjective_fac
      (J := Scheme.zariskiTopology)
      (f₁ := Sigma.ι (fun _ : PUnit.{u+1} =>
        yoneda.obj (Over.mk (𝟙 (Spec (CommRingCat.of k)))).left) PUnit.unit)
      (f₂ := Sigma.desc (fun _ : PUnit.{u+1} => abelSigmaChartZero (C := C) (pi := pi) m Z hdeg))
      (Sigma.ι_desc _ PUnit.unit)
  exact pic0RepresentableByOfCharts C _
    (fun _ : PUnit.{u+1} => (seamPair_abelSigmaChartZero_of_subsingleton C pi m Z hdeg hvan).1)

theorem controlSorry : (1:ℕ) = 1 := by sorry
end ProbeC14
end AlgebraicGeometry
