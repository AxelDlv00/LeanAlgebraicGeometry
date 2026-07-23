---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.trivialisation_restrict_dual_leg
docstring: '**Step C (blueprint `lem:trivialisation_dual_chain_leg`): the dual-chain
  leg under restriction.**

  `(restrictFunctor j).mapIso c` (where `c = dual_restrict_iso U.ι L ≪≫ (dualIsoOfIso
  eM).symm

  ≪≫ dual_unit_iso`) equals `ρ_{dL}.symm ≪≫ c_V ≪≫ u_j.symm`, where

  `ρ_{dL} = restrictCompReindex j hjι (dual L)`,

  `c_V = dual_restrict_iso V.ι L ≪≫ (dualIsoOfIso (restrictIsoUnitOfLE hVU eM)).symm
  ≪≫ dual_unit_iso`,

  and `u_j = unitRestrictIso j`.  This is the hard kernel of the Seam-1 chain.'
file: AlgebraicJacobian/Picard/TensorObjInverse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.trivialisation_restrict_dual_leg
type: lean
updated: '2026-07-16T21:14:28'
---
private lemma trivialisation_restrict_dual_leg {X : Scheme.{u}} {L : X.Modules}
    {U V : X.Opens} (hVU : V ≤ U)
    (eM : L.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf)
    (j : (V : Scheme) ⟶ (U : Scheme)) [IsOpenImmersion j] (hjι : j ≫ U.ι = V.ι) :
    (restrictFunctor j).mapIso
        (dual_restrict_iso U.ι L ≪≫ (dualIsoOfIso eM).symm ≪≫ dual_unit_iso)
      = (restrictCompReindex j hjι (dual L)).symm
          ≪≫ (dual_restrict_iso V.ι L ≪≫
                (dualIsoOfIso (restrictIsoUnitOfLE hVU eM)).symm ≪≫ dual_unit_iso)
          ≪≫ (unitRestrictIso j).symm := by
  /- Planner strategy (per-leg recipe):
     Step 1 — distribute `(rf j).mapIso` over the three-factor composition:
       `simp only [Functor.mapIso_trans]`
       → `(rf j)(dual_restrict_iso U.ι L) ≪≫ (rf j)(dualIsoOfIso eM).symm ≪≫ (rf j)(dual_unit_iso U)`.

     Step 2 — rewrite leg 1 (`dual_restrict_iso U.ι L`) using S3 `dual_restrict_iso_restrict_compat j hjι L`
       (`~L1471` in this file; rearrange to solve for `(rf j)(dual_restrict_iso U.ι L)`):
         `dual_restrict_iso V.ι L = ρ_{dL} ≪≫ (rf j)(dual_restrict_iso U.ι L) ≪≫ θ_j ≪≫ dualIsoOfIso ρ_L`
         where `θ_j = dual_restrict_iso j (L.restrict U.ι)`.
       Rearranged: `(rf j)(dual_restrict_iso U.ι L) = ρ_{dL}.symm ≪≫ dual_restrict_iso V.ι L ≪≫
         (θ_j ≪≫ dualIsoOfIso ρ_L).symm`.

     Step 3 — rewrite leg 2 (`(rf j)(dualIsoOfIso eM).symm`) using T2 `dual_restrict_iso_natural j eM`
       (`~L1069` in this file):
         `(rf j).mapIso (dualIsoOfIso eM) = dual_restrict_iso j (L.restrict U.ι)
            ≪≫ dualIsoOfIso ((rf j).mapIso eM) ≪≫ (dual_restrict_iso j unit_U).symm`.
       Taking `.symm`: `(rf j)(dualIsoOfIso eM).symm = dual_restrict_iso j unit_U
            ≪≫ (dualIsoOfIso ((rf j).mapIso eM)).symm ≪≫ θ_j.symm`.

     Step 4 — cancel the `θ_j` pair: the trailing `θ_j.symm` from Step 2 and the leading
       `dual_restrict_iso j (L.restrict U.ι) = θ_j` from Step 3 (pre-symm) meet and cancel
       by `Iso.hom_inv_id_assoc` at the `.hom` level.

     Step 5 — rewrite leg 3 (`(rf j)(dual_unit_iso U)`) using S4a `dual_unit_iso_restrict_compat j hjι`
       (`~L1858` in this file; rearrange):
         `dual_unit_iso V = dualIsoOfIso u_j ≪≫ (dual_restrict_iso j unit_U).symm ≪≫
            (rf j)(dual_unit_iso U) ≪≫ u_j`.
       Rearranged: `(rf j)(dual_unit_iso U) = (dualIsoOfIso u_j).symm ≪≫ dual_restrict_iso j unit_U
          ≪≫ dual_unit_iso V ≪≫ u_j.symm`.

     Step 6 — cancel the `dual_restrict_iso j unit_U` pair from Steps 3 and 5:
       `dual_restrict_iso j unit_U` (from Step 3 tail) meets `(dual_restrict_iso j unit_U)` (from Step 5 head)
       — but Step 3 has `(dual_restrict_iso j unit_U).symm.symm = dual_restrict_iso j unit_U` and Step 5
       has `dual_restrict_iso j unit_U`; compose: identity cancels.

     Step 7 — fuse the three `dualIsoOfIso` fragments via `dualIsoOfIso_trans` (`~L136`):
       remaining after cancellations:
         `(dualIsoOfIso ρ_L).symm ≪≫ (dualIsoOfIso ((rf j) eM)).symm ≪≫ (dualIsoOfIso u_j).symm`
       = `(dualIsoOfIso u_j ≪≫ dualIsoOfIso ((rf j) eM) ≪≫ dualIsoOfIso ρ_L).symm`  (by `dualIsoOfIso_trans`)
       = `(dualIsoOfIso (ρ_L ≪≫ (rf j) eM ≪≫ u_j)).symm`  (by two applications of `dualIsoOfIso_trans`)
       = `(dualIsoOfIso (restrictIsoUnitOfLE hVU eM)).symm`  (by keystone `restrictIsoUnitOfLE_eq_restrict`).

     Step 8 — collect: the result is
       `ρ_{dL}.symm ≪≫ dual_restrict_iso V.ι L ≪≫ (dualIsoOfIso (restrictIsoUnitOfLE hVU eM)).symm
          ≪≫ dual_unit_iso V ≪≫ u_j.symm`
       = `ρ_{dL}.symm ≪≫ c_V ≪≫ u_j.symm`  (where `c_V` is the V-side dual chain). ∎ -/
  -- Leg 1: solve S3 for `(restrict j) (dual_restrict_iso U.ι L)`.
  have hleg1 : (restrictFunctor j).mapIso (dual_restrict_iso U.ι L)
      = (restrictCompReindex j hjι (dual L)).symm ≪≫ dual_restrict_iso V.ι L
          ≪≫ (dualIsoOfIso (restrictCompReindex j hjι L)).symm
          ≪≫ (dual_restrict_iso j (L.restrict U.ι)).symm := by
    rw [dual_restrict_iso_restrict_compat j hjι L]
    simp only [Iso.trans_assoc, Iso.symm_self_id_assoc, Iso.self_symm_id_assoc, Iso.self_symm_id,
      Iso.trans_refl]
  -- Leg 2: T2 (`dual_restrict_iso_natural`) for the inverse `((restrict j)(dualIsoOfIso eM)).symm`.
  have hleg2 : ((restrictFunctor j).mapIso (dualIsoOfIso eM)).symm
      = dual_restrict_iso j (L.restrict U.ι)
          ≪≫ (dualIsoOfIso ((restrictFunctor j).mapIso eM)).symm
          ≪≫ (dual_restrict_iso j (SheafOfModules.unit (U : Scheme).ringCatSheaf)).symm := by
    rw [dual_restrict_iso_natural j eM]
    simp only [Iso.trans_symm, Iso.symm_symm_eq, Iso.trans_assoc]
  -- Leg 3: solve S4a for `(restrict j) (dual_unit_iso U)`.
  have hleg3 : (restrictFunctor j).mapIso (dual_unit_iso (Y := (U : Scheme)))
      = dual_restrict_iso j (SheafOfModules.unit (U : Scheme).ringCatSheaf)
          ≪≫ (dualIsoOfIso (unitRestrictIso j)).symm
          ≪≫ dual_unit_iso (Y := (V : Scheme))
          ≪≫ (unitRestrictIso j).symm := by
    rw [dual_unit_iso_restrict_compat j hjι]
    simp only [Iso.trans_assoc, Iso.symm_self_id_assoc, Iso.self_symm_id_assoc, Iso.self_symm_id,
      Iso.trans_refl]
  -- Distribute `(restrict j).mapIso` over the U-chain, substitute the three solved legs, expand the
  -- target's `restrictIsoUnitOfLE` by the keystone + contravariant `dualIsoOfIso_trans` fusion, then
  -- close by `Iso.trans_assoc` cocycle collapse (the two internal `dual_restrict_iso j` pairs cancel).
  rw [Functor.mapIso_trans, Functor.mapIso_trans, Functor.mapIso_symm,
    hleg1, hleg2, hleg3, restrictIsoUnitOfLE_eq_restrict hVU j hjι eM,
    dualIsoOfIso_trans, dualIsoOfIso_trans]
  simp only [Iso.trans_assoc, Iso.trans_symm, Iso.symm_symm_eq, Iso.symm_self_id_assoc,
    Iso.symm_self_id, Iso.self_symm_id, Iso.self_symm_id_assoc, Iso.trans_refl]