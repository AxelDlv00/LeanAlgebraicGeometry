import AlgebraicJacobian.Picard.Pic0AbelianVariety
open CategoryTheory AlgebraicGeometry AlgebraicGeometry.Scheme
universe u v

/-- abstract converse (already verified standalone) -/
theorem abs_converse
    {K : Type*} {L : Type*} [Field K] [Field L]
    {V : Type v} [AddCommGroup V] [Module K V] [FiniteDimensional K V]
    {W : Type v} [AddCommGroup W] [Module L W] [FiniteDimensional L W]
    (e : K ≃+* L) (h : Module.finrank K V = Module.finrank L W) :
    ∃ (i : K → L) (j : V ≃+ W), Function.Bijective i ∧ ∀ r x, j (r • x) = i r • j x := by
  classical
  set bV := Module.finBasis K V
  set bW := (Module.finBasis L W).reindex (finCongr h.symm)
  refine ⟨e, (bV.equivFun.toAddEquiv.trans
      ((AddEquiv.piCongrRight fun _ => e.toAddEquiv).trans
        bW.equivFun.toAddEquiv.symm)), e.bijective, ?_⟩
  intro r x
  apply bW.equivFun.injective
  simp only [AddEquiv.trans_apply, LinearEquiv.coe_toAddEquiv, map_smul]
  funext a
  simp [Module.Basis.equivFun_apply, map_mul]

namespace AlgebraicGeometry.Scheme.Pic0

theorem probe_converse {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C]
    (S : C.left.AffineCoverMVSquare)
    (h : Module.finrank
        (IsLocalRing.ResidueField
          ((Pic0Scheme C).left.presheaf.stalk ((identitySection C).base default)))
        (Module.Dual
          (IsLocalRing.ResidueField
            ((Pic0Scheme C).left.presheaf.stalk ((identitySection C).base default)))
          (IsLocalRing.CotangentSpace
            ((Pic0Scheme C).left.presheaf.stalk ((identitySection C).base default))))
      = Module.finrank k (S.H1Cok (Scheme.toModuleKSheaf C))) :
    ∃ (i : (IsLocalRing.ResidueField
              ((Pic0Scheme C).left.presheaf.stalk ((identitySection C).base default))) → k)
      (j : (Module.Dual
              (IsLocalRing.ResidueField
                ((Pic0Scheme C).left.presheaf.stalk ((identitySection C).base default)))
              (IsLocalRing.CotangentSpace
                ((Pic0Scheme C).left.presheaf.stalk ((identitySection C).base default))))
            ≃+ S.H1Cok (Scheme.toModuleKSheaf C)),
      Function.Bijective i ∧ ∀ r x, j (r • x) = i r • j x := by
  haveI : LocallyOfFiniteType (Pic0Scheme C).hom := locallyOfFiniteType C
  haveI := finiteDimensional_cotangentSpace_of_locallyOfFiniteType (Pic0Scheme C)
    ((identitySection C).base default)
  haveI : Module.Finite k (S.H1Cok (Scheme.toModuleKSheaf C)) :=
    Module.Finite.equiv (S.hModuleOneEquivH1Cok_curve (k := k))
  haveI : FiniteDimensional k (S.H1Cok (Scheme.toModuleKSheaf C)) := inferInstance
  obtain ⟨e⟩ := residueFieldIso_of_section_over_field (Pic0Scheme C) (identitySection C)
    (identitySection_isSection C)
  exact abs_converse (e.commRingCatIsoToRingEquiv) h

end AlgebraicGeometry.Scheme.Pic0

#print axioms abs_converse
#print axioms AlgebraicGeometry.Scheme.Pic0.probe_converse
