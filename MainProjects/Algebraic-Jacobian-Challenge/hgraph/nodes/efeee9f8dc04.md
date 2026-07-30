---
author: sync
content_type: theorem
created: '2026-07-31T02:29:40'
decl: AlgebraicGeometry.ProjectiveSpace.affineChartAt.opensRange_incl
docstring: 'The arbitrary chart is the inverse image of `D_+(X_i)` under the integral

  projection.'
file: AlgebraicJacobian/Picard/ProjectiveSpaceAffineChartAt.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjectiveSpace.affineChartAt.opensRange_incl
type: lean
updated: '2026-07-31T02:29:40'
---
theorem opensRange_incl :
    (incl J i S).opensRange =
      toProjInt J S ⁻¹ᵁ Proj.basicOpen P[J] (X i) := by
  change (pullback.fst (toProjInt J S)
      (Proj.awayι P[J] (X i) (X_i_mem_deg_one J i) Nat.zero_lt_one)).opensRange = _
  rw [Scheme.Hom.opensRange_pullbackFst, Proj.opensRange_awayι]

section IsoAffineSpace

variable [Finite J]