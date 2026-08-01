---
author: sync
content_type: definition
created: '2026-07-20T20:32:02'
decl: AlgebraicGeometry.Scheme.finiteMulMapTo
docstring: The finite product map corestricted to a specified multiplication span.
file: AlgebraicJacobian/Picard/DivSchemeMulSpanMap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.finiteMulMapTo
type: lean
updated: '2026-08-01T09:44:12'
---
noncomputable def Scheme.finiteMulMapTo
    (U T W : Submodule K X.functionField) (b : Module.Basis ι K U)
    (hW : Scheme.mulSpan K U T = W) : (ι → T) →ₗ[K] W :=
  (Scheme.finiteMulMap U T b).codRestrict W fun x => by
    rw [← hW, ← Scheme.range_finiteMulMap U T b]
    exact LinearMap.mem_range_self _ x