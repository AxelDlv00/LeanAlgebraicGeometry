---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.picEtMap_val
file: AlgebraicJacobian/Picard/PicEtMap.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.picEtMap_val
type: lean
updated: '2026-07-29T15:26:31'
---
lemma picEtMap_val (f : T' ⟶ T) (s : picEt C T) (W : T'.left.affineOpens) :
    (picEtMap C f s).1 W = picEtMapVal C f s W :=
  rfl