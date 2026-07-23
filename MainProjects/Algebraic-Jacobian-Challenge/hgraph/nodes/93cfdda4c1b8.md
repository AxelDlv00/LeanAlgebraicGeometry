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
updated: '2026-07-16T21:14:28'
---
private lemma trivialisation_restrict_eM_leg {X : Scheme.{u}} {L : X.Modules}
    {U V : X.Opens} (hVU : V ≤ U)
    (eM : L.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf)
    (j : (V : Scheme) ⟶ (U : Scheme)) [IsOpenImmersion j] (hjι : j ≫ U.ι = V.ι) :
    (restrictFunctor j).mapIso eM
      = (restrictCompReindex j hjι L).symm
          ≪≫ restrictIsoUnitOfLE hVU eM
          ≪≫ (unitRestrictIso j).symm := by
  /- Planner strategy:
     1.  `have hkey := restrictIsoUnitOfLE_eq_restrict hVU j hjι eM` (keystone, `TrivialisationRestrict.lean`).
         This gives `restrictIsoUnitOfLE hVU eM = restrictCompReindex j hjι L ≪≫ (rf j).mapIso eM ≪≫ unitRestrictIso j`.
     2.  `apply Iso.ext`; then at the `.hom` level rewrite `hkey` and cancel `ρ_L.hom`/`ρ_L.inv`
         (via `Iso.hom_inv_id_assoc` or `Iso.symm_hom_assoc`) and `u_j.hom`/`u_j.inv`
         (via `Iso.inv_hom_id`).
     Alternatively: `rw [← hkey]` after isolating `(rf j).mapIso eM` on the LHS via
     `Iso.ext` + `simp [Iso.trans_hom, Iso.symm_hom, Category.assoc, Iso.hom_inv_id_assoc]`. -/
  rw [restrictIsoUnitOfLE_eq_restrict hVU j hjι eM]
  simp only [Iso.trans_assoc, Iso.symm_self_id_assoc, Iso.self_symm_id, Iso.trans_refl]