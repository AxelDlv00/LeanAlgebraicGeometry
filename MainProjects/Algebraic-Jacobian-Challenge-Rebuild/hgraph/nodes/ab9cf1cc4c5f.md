---
author: sync
content_type: lemma
created: '2026-07-17T23:01:28'
decl: AlgebraicGeometry.divFamZar.ext
file: AlgebraicJacobian/Picard/DivisorFamilyZarVehicle.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divFamZar.ext
type: lean
updated: '2026-07-17T23:01:28'
---
lemma ext {s t : divFamZar C π n T} (h : ∀ U : T.left.affineOpens, s.1 U = t.1 U) :
    s = t :=
  Subtype.ext (funext h)

variable (C π n T) in