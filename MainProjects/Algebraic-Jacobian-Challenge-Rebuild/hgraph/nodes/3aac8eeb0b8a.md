---
author: sync
content_type: theorem
created: '2026-08-14T14:17:15'
decl: AlgebraicJacobian.GaloisDescent.StableAffineOpen.gluedQuotientBaseChangeLift_isEquivariant
docstring: 'The inverse global base-change isomorphism intertwines the given action

  with the canonical action on the base change.'
file: AlgebraicJacobian/Descent/GaloisQuotientOverlap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.StableAffineOpen.gluedQuotientBaseChangeLift_isEquivariant
type: lean
updated: '2026-08-14T14:17:15'
---
theorem gluedQuotientBaseChangeLift_isEquivariant
    [FiniteDimensional K L] [IsGalois K L] [HasStableAffineCover K L ρ] :
    ρ.IsEquivariant (pullbackSemilinearGalAction K L (gluedQuotientMap ρ))
      (gluedQuotientBaseChangeLift ρ) := by
  intro gamma
  apply pullback.hom_ext
  · simp only [Category.assoc, gluedQuotientBaseChangeLift_fst,
      pullbackSemilinearGalAction_act_hom, pullbackGalMap_fst]
    exact act_hom_gluedQuotientProjection ρ gamma
  · simp only [Category.assoc, gluedQuotientBaseChangeLift_snd,
      pullbackSemilinearGalAction_act_hom, pullbackGalMap_snd]
    rw [← Category.assoc, gluedQuotientBaseChangeLift_snd]
    exact ρ.compat gamma