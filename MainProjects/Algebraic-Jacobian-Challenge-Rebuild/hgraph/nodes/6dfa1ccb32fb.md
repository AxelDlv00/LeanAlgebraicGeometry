---
author: sync
content_type: definition
created: '2026-07-30T20:44:26'
decl: AlgebraicGeometry.AffAdaptation.ThetaOverlapProd
docstring: Product of the intrinsic divisor-restricted theta modules on pairwise overlaps.
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaDescent.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.ThetaOverlapProd
type: lean
updated: '2026-07-31T20:14:45'
---
noncomputable abbrev ThetaOverlapProd (A : AffAdaptation D d) (a : ℕ) : Type u :=
  ∀ p : D.index × D.index, A.ThetaOverlapQuotient (π := π) a p.1 p.2