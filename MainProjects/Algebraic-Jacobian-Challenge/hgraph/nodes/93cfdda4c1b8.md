---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.trivialisation_restrict_eM_leg
docstring: '**Step B (blueprint `lem:trivialisation_em_leg`): the `eM`-leg under restriction.**

  `(restrictFunctor j).mapIso eM` equals `ρ_L.symm ≪≫ restrictIsoUnitOfLE hVU eM ≪≫
  u_j.symm`,

  where `ρ_L = restrictCompReindex j hjι L` and `u_j = unitRestrictIso j`.  Follows
  from the

  keystone `restrictIsoUnitOfLE_eq_restrict` (`TrivialisationRestrict.lean`), which
  states

  `restrictIsoUnitOfLE hVU eM = ρ_L ≪≫ (rf j) eM ≪≫ u_j`, by cancelling `ρ_L` and
  `u_j`.'
file: AlgebraicJacobian/Picard/TensorObjInverse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.trivialisation_restrict_eM_leg
type: lean
updated: '2026-07-25T02:33:16'
---
private lemma trivialisation_restrict_eM_leg {X : Scheme.{u}} {L : X.Modules}
    {U V : X.Opens} (hVU : V ≤ U)
    (eM : L.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf)
    (j : (V : Scheme) ⟶ (U : Scheme)) [IsOpenImmersion j] (hjι : j ≫ U.ι = V.ι) :
    (restrictFunctor j).mapIso eM
      = (restrictCompReindex j hjι L).symm
          ≪≫ restrictIsoUnitOfLE hVU eM
          ≪≫ (unitRestrictIso j).symm := by
  -- Substitute the keystone equality, then cancel the outer reindexing and unit
  -- isomorphisms.
  rw [restrictIsoUnitOfLE_eq_restrict hVU j hjι eM]
  simp only [Iso.trans_assoc, Iso.symm_self_id_assoc, Iso.self_symm_id, Iso.trans_refl]