import AlgebraicJacobian.Picard.DivisorFamilyDegreeZeroUseSite
import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u
open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry
namespace ProbeC3

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

variable (C) in
/-- collapse from PLAIN injectivity -- weaker input than chartIso_of_seam's hf. -/
theorem chartIso_of_injective {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    (hinj : ∀ T : Scheme.{u}ᵒᵖ, Function.Injective (f.app T))
    (hcov : Presheaf.IsLocallySurjective Scheme.zariskiTopology f) :
    IsIso (chartSheafHom C f) := by
  haveI : Presheaf.IsLocallyInjective Scheme.zariskiTopology (chartSheafHom C f).hom :=
    Presheaf.isLocallyInjective_of_injective _ _ hinj
  haveI : Presheaf.IsLocallySurjective Scheme.zariskiTopology (chartSheafHom C f).hom := hcov
  exact (Sheaf.isLocallyBijective_iff_isIso (chartSheafHom C f)).mp ⟨inferInstance, inferInstance⟩

variable (C) in
/-- and then the app is bijective at every test. -/
theorem bijective_app_of_injective {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    (hinj : ∀ T : Scheme.{u}ᵒᵖ, Function.Injective (f.app T))
    (hcov : Presheaf.IsLocallySurjective Scheme.zariskiTopology f)
    (T : Scheme.{u}ᵒᵖ) : Function.Bijective (f.app T) := by
  letI : IsIso f := by
    haveI := chartIso_of_injective C f hinj hcov
    exact (inferInstance : IsIso ((sheafToPresheaf Scheme.zariskiTopology (Type u)).map
      (chartSheafHom C f)))
  exact (isIso_iff_bijective (f.app T)).mp inferInstance

theorem controlSorry : (1:ℕ) = 1 := by sorry

end ProbeC3
end AlgebraicGeometry
