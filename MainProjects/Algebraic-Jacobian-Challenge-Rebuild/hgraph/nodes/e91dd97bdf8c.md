---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.germGenericUnits_val
file: AlgebraicJacobian/Picard/MeromorphicPresentation.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.germGenericUnits_val
type: lean
updated: '2026-07-29T15:31:46'
---
lemma germGenericUnits_val {U : X.Opens} (hηU : genericPoint X ∈ U) (u : Γ(X, U)ˣ) :
    (germGenericUnits hηU u : X.functionField)
      = (X.presheaf.germ U (genericPoint X) hηU).hom (u : Γ(X, U)) :=
  rfl