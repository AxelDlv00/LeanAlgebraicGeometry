---
author: sync
content_type: definition
created: '2026-07-30T13:03:21'
decl: AlgebraicGeometry.Scheme.Modules.zeroQuasicoherentData
file: AlgebraicJacobian/Picard/DivFamilyZero.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.zeroQuasicoherentData
type: lean
updated: '2026-07-30T16:21:06'
---
noncomputable def zeroQuasicoherentData {M : Y.Modules} (hM : IsZero M) :
    M.QuasicoherentData where
  I := PUnit.{u+1}
  X _ := (⊤ : TopologicalSpace.Opens (Y : TopCat))
  coversTop := coversTop_singleton_top
  presentation _ := zeroPresentation (isZero_over_of_isZero hM _)

set_option synthInstance.maxHeartbeats 1600000 in -- as `zeroQuasicoherentData` above
set_option maxHeartbeats 2000000 in