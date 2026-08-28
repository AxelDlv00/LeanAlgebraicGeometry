---
author: sync
content_type: definition
created: '2026-07-17T10:19:50'
decl: AlgebraicGeometry.DivisorAdaptation.gluedTopEquiv
docstring: The equalizer as the whole product, when the glued submodule is `⊤`.
file: AlgebraicJacobian/Picard/DivisorFamilyFieldDegree.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.gluedTopEquiv
type: lean
updated: '2026-08-01T09:44:13'
---
noncomputable def gluedTopEquiv (h : A.gluedSubmodule = ⊤) : A.Glued ≃ₗ[K] A.chartProd :=
  (LinearEquiv.ofEq _ _ h).trans Submodule.topEquiv