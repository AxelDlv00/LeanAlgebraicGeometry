import AlgebraicJacobian.Picard.Pic0ChartSeamPairDecided

set_option autoImplicit false
set_option maxSynthPendingDepth 3
universe u
open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry
namespace ProbeC10

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {pi : C.left ⟶ P1 k} [IsAffineHom pi]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
variable [IsIntegral (C ⊗ overSpec k k).left]

-- Q: from bijective apps, get IsLocallySurjective and IsOpenImmersion.presheaf
example (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - ((0 : ℕ) : ℤ))
    (hvan : ∀ S : Over (Spec (.of k)), Subsingleton (pic0Subgroup C S)) :
    IsOpenImmersion.presheaf (abelSigmaChartZero (C := C) (pi := pi) m Z hdeg) ∧
      Presheaf.IsLocallySurjective Scheme.zariskiTopology
        (abelSigmaChartZero (C := C) (pi := pi) m Z hdeg) := by
  set f := abelSigmaChartZero (C := C) (pi := pi) m Z hdeg with hf
  haveI : IsIso f := by
    haveI : ∀ T, IsIso (f.app T) := fun T => (isIso_iff_bijective (f.app T)).mpr
      ⟨injective_abelSigmaChartZero C pi m Z hdeg T,
       surjective_app_abelSigmaChartZero_of_subsingleton C pi m Z hdeg hvan T⟩
    exact NatIso.isIso_of_isIso_app f
  exact ⟨MorphismProperty.of_isIso (P := IsOpenImmersion.presheaf) f, inferInstance⟩

theorem controlSorry : (1:ℕ) = 1 := by sorry

end ProbeC10
end AlgebraicGeometry
