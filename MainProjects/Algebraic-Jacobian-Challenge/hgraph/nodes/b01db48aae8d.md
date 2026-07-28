---
author: sync
content_type: instance
created: '2026-07-28T18:12:20'
decl: AlgebraicGeometry.Scheme.divisorSheafLE_mono
file: AlgebraicJacobian/RiemannRoch/Ledger/DivisorSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.divisorSheafLE_mono
type: lean
updated: '2026-07-28T18:12:20'
---
instance divisorSheafLE_mono {D D' : X.CurveDivisor} (h : D ≤ D') :
    Mono (divisorSheafLE K h) := by
  haveI happ : ∀ U, Mono ((divisorPresheafLE K h).app U) := fun U => by
    rw [ModuleCat.mono_iff_injective]
    exact Submodule.inclusion_injective (divisorSections_mono K h U.unop)
  haveI hpre : Mono (divisorPresheafLE K h) := NatTrans.mono_of_mono_app _
  have hmap : (sheafToPresheaf _ _).map (divisorSheafLE K h) = divisorPresheafLE K h :=
    (fullyFaithfulSheafToPresheaf _ _).map_preimage
      (X := divisorSheaf K D) (Y := divisorSheaf K D') (divisorPresheafLE K h)
  apply (sheafToPresheaf _ _).mono_of_mono_map
  rw [hmap]
  exact hpre