---
author: sync
content_type: definition
created: '2026-07-28T15:48:27'
decl: AlgebraicGeometry.Scheme.Modules.pullbackTopIsoSelf
docstring: 'Restriction to `⊤` undone: pulling back along `T.topIso.inv` inverts

  `Modules.pullback (⊤ : T.Opens).ι`, since the composite of the two morphisms is
  `𝟙 T`

  (`Scheme.toIso_inv_ι`).'
file: AlgebraicJacobian/Picard/OnePointRelPicCollapse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.pullbackTopIsoSelf
type: lean
updated: '2026-07-28T15:48:27'
---
noncomputable def Modules.pullbackTopIsoSelf {T : Scheme.{u}} (N : T.Modules) :
    (Scheme.Modules.pullback (T.topIso).inv).obj
        ((Scheme.Modules.pullback (⊤ : T.Opens).ι).obj N) ≅ N :=
  (Scheme.Modules.pullbackComp (T.topIso).inv (⊤ : T.Opens).ι).app N ≪≫
    (Scheme.Modules.pullbackCongr (T.toIso_inv_ι)).app N ≪≫
    (Scheme.Modules.pullbackId T).app N