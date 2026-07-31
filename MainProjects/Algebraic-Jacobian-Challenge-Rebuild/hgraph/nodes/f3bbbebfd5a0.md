---
author: sync
content_type: definition
created: '2026-07-28T14:44:52'
decl: AlgebraicGeometry.DivisorAdaptation.cokerDiffCongr
docstring: The difference cokernels are equivalent.
file: AlgebraicJacobian/Picard/DivisorFamilyAffCompare.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivisorAdaptation.cokerDiffCongr
type: lean
updated: '2026-07-31T20:14:52'
---
noncomputable def cokerDiffCongr :
    (A.ovlProd ⧸ LinearMap.range (A.deltaLeft - A.deltaRight)) ≃ₗ[R]
      (A.toAff.ovlProd ⧸ LinearMap.range (A.toAff.deltaLeft - A.toAff.deltaRight)) :=
  Submodule.Quotient.equiv _ _ A.ovlProdCongr A.range_sub_toAff.symm