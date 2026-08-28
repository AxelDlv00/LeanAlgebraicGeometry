import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u
open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry
namespace ProbeC7

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

variable (C) in
theorem chartIso_of_injective {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    (hinj : ∀ T : Scheme.{u}ᵒᵖ, Function.Injective (f.app T))
    (hcov : Presheaf.IsLocallySurjective Scheme.zariskiTopology f) :
    IsIso (chartSheafHom C f) := by
  haveI : Presheaf.IsLocallyInjective Scheme.zariskiTopology (chartSheafHom C f).hom :=
    Presheaf.isLocallyInjective_of_injective _ _ hinj
  haveI : Presheaf.IsLocallySurjective Scheme.zariskiTopology (chartSheafHom C f).hom := hcov
  exact (Sheaf.isLocallyBijective_iff_isIso (chartSheafHom C f)).mp ⟨inferInstance, inferInstance⟩

variable (C) in
/-- THE REPRICING: given coverage, antecedent 1 IS plain elementwise injectivity. -/
theorem isOpenImmersion_presheaf_of_injective {X : Scheme.{u}}
    (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    (hinj : ∀ T : Scheme.{u}ᵒᵖ, Function.Injective (f.app T))
    (hcov : Presheaf.IsLocallySurjective Scheme.zariskiTopology f) :
    IsOpenImmersion.presheaf f := by
  letI : IsIso f := by
    haveI := chartIso_of_injective C f hinj hcov
    exact (inferInstance : IsIso ((sheafToPresheaf Scheme.zariskiTopology (Type u)).map
      (chartSheafHom C f)))
  exact MorphismProperty.of_isIso (P := IsOpenImmersion.presheaf) f

theorem controlSorry : (1:ℕ) = 1 := by sorry

end ProbeC7
end AlgebraicGeometry
