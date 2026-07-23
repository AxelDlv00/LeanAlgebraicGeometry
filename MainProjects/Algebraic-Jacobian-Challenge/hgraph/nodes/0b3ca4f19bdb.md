---
author: sync
content_type: definition
created: '2026-07-16T21:14:25'
decl: AlgebraicGeometry.SectionCechModule.cechCofaceLin
docstring: 'R-linear underlying map of the localised coface `cechCoface` (the `comparison`

  before `.toAddMonoidHom`).'
file: AlgebraicJacobian/Cohomology/CechAcyclic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.SectionCechModule.cechCofaceLin
type: lean
updated: '2026-07-16T21:14:25'
---
noncomputable def cechCofaceLin (r : ι) (m : ℕ) (σ : Fin (m + 1) → ι) (j : Fin (m + 1)) :
    cechCoeff s M r (σ ∘ j.succAbove) →ₗ[R] cechCoeff s M r σ :=
  comparison
    (LocalizedModule.mkLinearMap (Submonoid.powers (s r * sprod s (σ ∘ j.succAbove))) M)
    (LocalizedModule.mkLinearMap (Submonoid.powers (s r * sprod s σ)) M)
    (Inverts.of_dvd (mul_dvd_mul_left (s r) (sprod_succAbove_dvd s σ j))
      (LocalizedModule.mkLinearMap (Submonoid.powers (s r * sprod s σ)) M))