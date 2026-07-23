---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.universalQuotient_isLocallyFreeOfRank
docstring: '**The universal quotient sheaf is locally free of rank `d`**

  (`thm:grassmannian_universal_property`, first ingredient): the chart images

  `{ι_I(U^I)}` cover the glued scheme, and on each member the restriction of

  `universalQuotient` is identified with `O^d` by transporting the descent restriction

  isomorphism `universalQuotient_restrictionIso` along the factorization

  `ι_I = isoOpensRange.hom ≫ opensRange.ι`.'
file: AlgebraicJacobian/Picard/GrassmannianQuot.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.universalQuotient_isLocallyFreeOfRank
type: lean
updated: '2026-07-16T21:14:27'
---
theorem universalQuotient_isLocallyFreeOfRank (d r : ℕ) :
    SheafOfModules.IsLocallyFreeOfRank (universalQuotient d r) d := by
  refine ⟨(theGlueData d r).J, fun I => ((theGlueData d r).ι I).opensRange, ?_, fun I => ?_⟩
  · rw [eq_top_iff]
    intro x _
    obtain ⟨I, y, rfl⟩ := (theGlueData d r).ι_jointly_surjective x
    exact TopologicalSpace.Opens.mem_iSup.mpr ⟨I, y, rfl⟩
  · -- transport the chart restriction iso along `ι_I = isoOpensRange.hom ≫ opensRange.ι`,
    -- inverting the chart-parametrization iso via the pullback pseudofunctor
    refine ⟨?_⟩
    letI ι := (theGlueData d r).ι I
    letI e := ι.isoOpensRange
    exact (Scheme.Modules.pullbackId _).symm.app _ ≪≫
      (Scheme.Modules.pullbackCongr (Iso.inv_hom_id e).symm).app _ ≪≫
      ((Scheme.Modules.pullbackComp e.inv e.hom).app _).symm ≪≫
      (Scheme.Modules.pullback e.inv).mapIso
        ((Scheme.Modules.pullbackComp e.hom ι.opensRange.ι).app (universalQuotient d r) ≪≫
          (Scheme.Modules.pullbackCongr (ι.isoOpensRange_hom_ι)).app (universalQuotient d r) ≪≫
          universalQuotient_restrictionIso d r I) ≪≫
      Scheme.Modules.pullbackFreeIso e.inv (Fin d) ≪≫
      SheafOfModules.freeFunctor.mapIso (Equiv.ulift.symm.toIso)