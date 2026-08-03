---
author: sync
content_type: theorem
created: '2026-08-03T12:35:24'
decl: AlgebraicGeometry.Scheme.Grassmannian.representingScheme_isHQuasiProjective_of_field_demand
docstring: '**Closed D4'' ambient demand.** Over a field, the chosen scheme representing
  a

  Grassmannian of locally free quotients is H-quasi-projective over that field.


  This is the projective-space certificate that D4'' can consume after D3'' supplies

  its locally closed locus in the Grassmannian base.'
file: AlgebraicJacobian/Projective/DemandLedger.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.Grassmannian.representingScheme_isHQuasiProjective_of_field_demand
type: lean
updated: '2026-08-03T14:50:49'
---
theorem representingScheme_isHQuasiProjective_of_field_demand
    {K : Type} [Field K]
    {V : (Spec (CommRingCat.of K)).Modules} {r d : ℕ}
    (hV : SheafOfModules.IsLocallyFreeOfRank V r)
    (hd : 1 ≤ d) (hdr : d ≤ r) :
    (representingScheme hV hd hdr).hom.IsHQuasiProjective :=
  representingScheme_isHQuasiProjective_of_field hV hd hdr