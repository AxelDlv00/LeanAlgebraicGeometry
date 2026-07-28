---
author: sync
content_type: theorem
created: '2026-07-28T18:12:20'
decl: AlgebraicGeometry.P1.algebraMap_awayToOverlapLeft
docstring: The algebra structure of the overlap ring over the left chart ring is restriction.
file: AlgebraicJacobian/RiemannRoch/Ledger/P1Points.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1.algebraMap_awayToOverlapLeft
type: lean
updated: '2026-07-28T18:12:20'
---
theorem algebraMap_awayToOverlapLeft :
    algebraMap (Away 𝒜 (X (0 : Fin 2)))
        (Away 𝒜 ((X 0 : MvPolynomial (Fin 2) k) * X 1)) = awayToOverlapLeft k :=
  rfl