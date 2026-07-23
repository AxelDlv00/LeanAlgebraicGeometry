---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.IsAffineOpen.dCoeffSectionsLinearEquiv
docstring: '**Čech coefficients are section modules**: over an affine open `U`, the

  abstract structure-sheaf Čech coefficient

  `SectionCechModule.dCoeff g Γ(X, U) σ = Γ(X, U)_{g_σ}` is `Γ(X, U)`-linearly the

  honest section module `Γ(X, D(g_σ))` — which is `Γ(X, ⨅ k, D(g_{σ k}))` by

  `Scheme.basicOpen_sprod`.  Sends `x/1` to the restriction of `x`

  (`dCoeffSectionsLinearEquiv_mk_one`) and intertwines the Čech coface with the

  presheaf restriction (`dCoeffSectionsLinearEquiv_dCoface`).'
file: AlgebraicJacobian/Cohomology/CechCoboundarySplitting.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.IsAffineOpen.dCoeffSectionsLinearEquiv
type: lean
updated: '2026-07-24T03:02:09'
---
noncomputable def IsAffineOpen.dCoeffSectionsLinearEquiv (hU : IsAffineOpen U)
    {ι : Type*} (g : ι → Γ(X, U)) {m : ℕ} (σ : Fin m → ι) :
    SectionCechModule.dCoeff g (↥Γ(X, U)) σ
      ≃ₗ[↥Γ(X, U)] ↥Γ(X, X.basicOpen (CechLocalized.sprod g σ)) :=
  haveI := hU.isLocalizedModule_linearMap_basicOpen (CechLocalized.sprod g σ)
  IsLocalizedModule.iso (Submonoid.powers (CechLocalized.sprod g σ))
    (Algebra.linearMap ↥Γ(X, U) ↥Γ(X, X.basicOpen (CechLocalized.sprod g σ)))