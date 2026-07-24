---
author: sync
content_type: theorem
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Adelic.isDedekindDomain_of_forall_localization_dvr
docstring: '**N1 — the Dedekind-from-DVR bridge** (pure ring theory, `IsDedekindDomainDvr`).

  A Noetherian integral domain whose localization at every nonzero prime is a

  discrete valuation ring is a Dedekind domain. This is exactly the criterion under

  which a smooth (equivalently: regular, on a curve) affine chart `Γ(X, U)` is

  Dedekind; the missing input is that every nonzero prime of the chart is

  height-one, i.e. that `X` is a curve.'
file: AlgebraicJacobian/RiemannRoch/Adelic/Substrate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.isDedekindDomain_of_forall_localization_dvr
type: lean
updated: '2026-07-24T17:02:57'
---
theorem isDedekindDomain_of_forall_localization_dvr {R : Type*} [CommRing R]
    [IsDomain R] [IsNoetherianRing R]
    (h : ∀ (P : Ideal R) [P.IsPrime], P ≠ ⊥ →
      IsDiscreteValuationRing (Localization.AtPrime P)) :
    IsDedekindDomain R := by
  haveI : IsDedekindDomainDvr R := by
    refine { is_dvr_at_nonzero_prime := fun P hP hPp => ?_ }
    haveI := hPp
    exact h P hP
  infer_instance