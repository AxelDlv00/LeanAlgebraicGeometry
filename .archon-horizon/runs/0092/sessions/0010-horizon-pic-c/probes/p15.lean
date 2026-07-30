import AlgebraicJacobian.Picard.Pic0ChartSeamPairDecided
set_option autoImplicit false
set_option maxSynthPendingDepth 3
universe u
open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory
namespace AlgebraicGeometry
namespace ProbeC15
variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {pi : C.left ⟶ P1 k} [IsAffineHom pi]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
variable [IsIntegral (C ⊗ overSpec k k).left]

-- the honest conclusion shape: pic0TypeFunctor is representable by SOME object
example (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - ((0 : ℕ) : ℤ))
    (hvan : ∀ S : Over (Spec (.of k)), Subsingleton (pic0Subgroup C S)) :
    ∃ J : Over (Spec (.of k)), Nonempty ((pic0TypeFunctor C).RepresentableBy J) := by
  set f := fun _ : PUnit.{u+1} => abelSigmaChartZero (C := C) (pi := pi) m Z hdeg with hfdef
  have hpair := seamPair_abelSigmaChartZero_of_subsingleton C pi m Z hdeg hvan
  haveI : Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f) := by
    haveI := hpair.2
    exact Presheaf.isLocallySurjective_of_isLocallySurjective_fac
      (J := Scheme.zariskiTopology)
      (f₁ := Sigma.ι (fun _ : PUnit.{u+1} =>
        yoneda.obj (Over.mk (𝟙 (Spec (CommRingCat.of k)))).left) PUnit.unit)
      (f₂ := Sigma.desc f) (Sigma.ι_desc f PUnit.unit)
  exact ⟨_, ⟨pic0RepresentableByOfCharts C f (fun _ => hpair.1)⟩⟩

theorem controlSorry : (1:ℕ) = 1 := by sorry
end ProbeC15
end AlgebraicGeometry
