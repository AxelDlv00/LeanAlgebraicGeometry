---
author: sync
content_type: theorem
created: '2026-07-20T00:31:14'
decl: AlgebraicGeometry.ThetaGeneratorSeed.forall_flat_colength_quotient
docstring: '**`ψ_z ⟹ Flat(colength ⧸ N z)` at every point** — the `hflat` package
  of the DD-4

  capstone.  From the per-point colength finiteness/flatness (`hcolFin`/`hcolFlat`,
  both

  landed at the seed) and the carve fibre-injective law `FibreInjective z` at every
  point,

  produces `∀ z, Module.Flat R ((Γ(D(h z)) ⧸ (eqn z)) ⧸ N z)` — exactly the `hflat`
  argument

  of `dvd_of_flat_quotient_of_field_vanishing`.'
file: AlgebraicJacobian/Picard/DivSchemeUnivFibreKerInj.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.ThetaGeneratorSeed.forall_flat_colength_quotient
type: lean
updated: '2026-07-30T15:28:04'
---
theorem forall_flat_colength_quotient [IsNoetherianRing R] [Module.Finite R ↥K]
    (hcolFin : ∀ z : relCurve C R,
      Module.Finite R (Γ(relCurve C R, D.piece z) ⧸ Ideal.span {D.eqn z}))
    (hcolFlat : ∀ z : relCurve C R,
      Module.Flat R (Γ(relCurve C R, D.piece z) ⧸ Ideal.span {D.eqn z}))
    (hinj : ∀ z : relCurve C R, D.FibreInjective z) :
    ∀ z : relCurve C R,
      Module.Flat R ((Γ(relCurve C R, D.piece z) ⧸ Ideal.span {D.eqn z})
        ⧸ D.sideColengthSubmodule z) := fun z => by
  haveI := hcolFin z
  haveI := hcolFlat z
  exact D.flat_colength_quotient z (hinj z)

set_option synthInstance.maxHeartbeats 400000 in
-- deriving the colength `Module.Finite`/quotient instances re-elaborates the heavy relCurve
-- section-ring quotient type past the default budget (as in `sideColengthSubmodule_finite`)