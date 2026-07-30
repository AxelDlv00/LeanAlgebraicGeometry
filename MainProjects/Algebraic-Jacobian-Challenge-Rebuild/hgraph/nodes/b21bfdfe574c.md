---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.picEtMap_val
file: AlgebraicJacobian/Picard/PicEtMap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.picEtMap_val
type: lean
updated: '2026-07-30T15:46:06'
---
lemma picEtMap_val (f : T' ⟶ T) (s : picEt C T) (W : T'.left.affineOpens) :
    (picEtMap C f s).1 W = picEtMapVal C f s W :=
  rfl