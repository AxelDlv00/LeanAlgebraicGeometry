---
author: sync
content_type: lemma
created: '2026-07-20T17:01:58'
decl: AlgebraicGeometry.FlatRangeBridge.exact_imageInQuotient_subtype_quotientMapOfLE
file: AlgebraicJacobian/Picard/DivSchemeRedesignRangeFlatBridge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FlatRangeBridge.exact_imageInQuotient_subtype_quotientMapOfLE
type: lean
updated: '2026-07-31T20:15:22'
---
lemma exact_imageInQuotient_subtype_quotientMapOfLE {L P : Submodule R M}
    (hLP : L ≤ P) :
    Function.Exact (imageInQuotient L P).subtype (quotientMapOfLE hLP) := by
  rw [LinearMap.exact_iff, Submodule.range_subtype, ker_quotientMapOfLE hLP]