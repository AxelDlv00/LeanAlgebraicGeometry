---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.trivialisation_restrict_dual_leg
docstring: "**Step C (blueprint `lem:trivialisation_dual_chain_leg`): the dual-chain\
  \ leg under\nrestriction.**\n`(restrictFunctor j).mapIso c` (where `c = dual_restrict_iso\
  \ U.ι L ≪≫ (dualIsoOfIso eM).symm\n≪≫ dual_unit_iso`) equals `ρ_{dL}.symm ≪≫ c_V\
  \ ≪≫ u_j.symm`, where\n`ρ_{dL} = restrictCompReindex j hjι (dual L)`,\n`c_V = dual_restrict_iso\
  \ V.ι L ≪≫\n  (dualIsoOfIso (restrictIsoUnitOfLE hVU eM)).symm ≪≫ dual_unit_iso`,\n\
  and `u_j = unitRestrictIso j`.  This is the hard kernel of the Seam-1 chain."
file: AlgebraicJacobian/Picard/TensorObjInverse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.trivialisation_restrict_dual_leg
type: lean
updated: '2026-07-25T02:33:16'
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
  -- Map the three factors separately, rewrite them using S3, dual naturality, and S4a,
  -- cancel the two internal dual-restriction pairs, and fuse the remaining dual transports
  -- with `dualIsoOfIso_trans`.
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
  -- target's `restrictIsoUnitOfLE` by the keystone and contravariant
  -- `dualIsoOfIso_trans`, then close by `Iso.trans_assoc`; the two internal
  -- `dual_restrict_iso j` pairs cancel.
  rw [Functor.mapIso_trans, Functor.mapIso_trans, Functor.mapIso_symm,
    hleg1, hleg2, hleg3, restrictIsoUnitOfLE_eq_restrict hVU j hjι eM,
    dualIsoOfIso_trans, dualIsoOfIso_trans]
  simp only [Iso.trans_assoc, Iso.trans_symm, Iso.symm_self_id_assoc]