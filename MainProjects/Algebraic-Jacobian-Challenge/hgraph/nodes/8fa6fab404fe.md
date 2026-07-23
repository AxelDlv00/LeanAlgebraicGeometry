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
updated: '2026-07-16T21:14:28'
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

/-- **N1 (gate) — `HasDedekindChart`.** Packages "every nonempty affine chart of
`X` has a Dedekind coordinate ring". On a smooth (or normal) curve this holds
because each chart is a one-dimensional regular Noetherian domain; where mathlib's
`smooth ⇒ regular chart` bridge is unavailable we supply this as a `HasPicScheme`-
style gate class (no global instance — an honest hypothesis), to be discharged
later via `isDedekindDomain_of_forall_localization_dvr` (design §4). -/
class HasDedekindChart (X : Scheme.{u}) [IsIntegral X] : Prop where
  /-- Every nonempty affine chart is a Dedekind domain. -/
  isDedekindDomain : ∀ (U : X.Opens), IsAffineOpen U → [Nonempty U] →
    IsDedekindDomain Γ(X, U)