---
author: sync
content_type: theorem
created: '2026-08-03T12:35:24'
decl: AlgebraicGeometry.Grassmannian.isHQuasiProjective_toSpecZ_demand
docstring: '**Open D4'' core producer.** The absolute Grassmannian is

  H-quasi-projective over `Spec Z`.


  This is the exact Plucker/projective-space certificate absent from the current

  Grassmannian construction.  Its existing properness theorem is not enough.'
file: AlgebraicJacobian/Projective/DemandLedger.lean
generated: lean
lean_status: sorry
title: AlgebraicGeometry.Grassmannian.isHQuasiProjective_toSpecZ_demand
type: lean
updated: '2026-08-03T12:35:24'
---
theorem isHQuasiProjective_toSpecZ_demand (d r : ℕ)
    (_hd : 1 ≤ d) (_hdr : d ≤ r) :
    (toSpecZ d r).IsHQuasiProjective := by
  sorry