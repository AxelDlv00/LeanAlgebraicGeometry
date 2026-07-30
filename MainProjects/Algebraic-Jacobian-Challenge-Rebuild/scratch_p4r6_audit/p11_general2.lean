import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

theorem controlSorry : True := by sorry
#print axioms AlgebraicGeometry.Jacobian

open CategoryTheory Limits Opposite
namespace AlgebraicGeometry
universe u

-- Does the collapse need ANY curve datum? State it for an arbitrary target sheaf.
theorem chartIso_of_seam_general (G : Sheaf Scheme.zariskiTopology.{u} (Type u))
    {X : Scheme.{u}} (f : yoneda.obj X ⟶ G.1)
    (hf : IsOpenImmersion.presheaf f)
    (hcov : Presheaf.IsLocallySurjective Scheme.zariskiTopology f) :
    IsIso (Sheaf.Hom.mk f : chartSourceSheaf X ⟶ G) := by
  haveI : Presheaf.IsLocallyInjective Scheme.zariskiTopology
      (Sheaf.Hom.mk f : chartSourceSheaf X ⟶ G).hom :=
    Presheaf.isLocallyInjective_of_injective _ _ (fun T =>
      (mono_iff_injective (f.app T)).mp ((NatTrans.mono_iff_mono_app f).mp
        (MorphismProperty.presheaf_mono_of_le IsOpenImmersion.le_monomorphisms hf) T))
  haveI : Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (Sheaf.Hom.mk f : chartSourceSheaf X ⟶ G).hom := hcov
  exact (Sheaf.isLocallyBijective_iff_isIso (Sheaf.Hom.mk f : chartSourceSheaf X ⟶ G)).mp
    ⟨inferInstance, inferInstance⟩

end AlgebraicGeometry
