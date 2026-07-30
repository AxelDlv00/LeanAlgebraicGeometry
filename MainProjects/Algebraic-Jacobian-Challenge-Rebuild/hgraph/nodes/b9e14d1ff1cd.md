---
author: sync
content_type: theorem
created: '2026-07-22T13:02:45'
decl: AlgebraicGeometry.universalMulMap_piSingle
file: AlgebraicJacobian/Picard/DivSchemeHighWindowTransitionRelationZero.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: AlgebraicGeometry.universalMulMap_piSingle
type: lean
updated: '2026-07-30T15:28:03'
---
private theorem universalMulMap_piSingle
    (t : Fin (Module.finrank k HS))
    (x : ↥(divUniversalFstWindow C pi hpi g r1 r2 b1 b2 i j).toSubmodule) :
    universalMulMap (hπ := hpi) g r1 r2 b1 b2 i j (Pi.single t x) =
      LinearMap.baseChange RZ
        (windowShiftMul hpi g ((Module.finBasis k HS) t)) x.1 := by
  classical
  rw [universalMulMap_eq_finiteComponentSum
    (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j,
    finiteComponentSum_piSingle]
  rfl

set_option maxHeartbeats 1600000 in
-- A single basis product is one coordinate of the universal multiplication map.
set_option synthInstance.maxHeartbeats 400000 in
-- Constructing the supported finite source requires the carve-chart module instance.