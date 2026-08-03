---
author: sync
content_type: theorem
created: '2026-08-03T12:35:24'
decl: AlgebraicGeometry.Grassmannian.isHQuasiProjective_toSpecZ_demand
docstring: '**Closed D4'' core producer.** The absolute Grassmannian is

  H-quasi-projective over `Spec Z`.


  The hypotheses are retained because this is the exact ledger signature exposed

  to D4''; the stronger producer does not need them.'
file: AlgebraicJacobian/Projective/DemandLedger.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Grassmannian.isHQuasiProjective_toSpecZ_demand
type: lean
updated: '2026-08-03T14:50:49'
---
theorem isHQuasiProjective_toSpecZ_demand (d r : ℕ)
    (_hd : 1 ≤ d) (_hdr : d ≤ r) :
    (toSpecZ d r).IsHQuasiProjective :=
  isHQuasiProjective_toSpecZ d r