---
author: sync
content_type: lemma
created: '2026-07-29T06:43:23'
decl: AlgebraicGeometry.fiberCoordUnit_inv_val
file: AlgebraicJacobian/RiemannRoch/Ledger/FiberDivisor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.fiberCoordUnit_inv_val
type: lean
updated: '2026-07-29T06:43:23'
---
lemma fiberCoordUnit_inv_val : ((fiberCoordUnit π)⁻¹).val
    = (Y.presheaf.germ (fiberChart₁ π) (genericPoint Y)
        (genericPoint_mem_preimage_inf π).2).hom (fiberCoord₁ π) := rfl