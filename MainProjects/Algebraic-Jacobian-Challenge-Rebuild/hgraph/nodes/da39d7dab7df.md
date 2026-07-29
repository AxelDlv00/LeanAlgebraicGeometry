---
author: sync
content_type: definition
created: '2026-07-30T03:30:39'
decl: AlgebraicGeometry.AffAdaptation.pieceStalkEval
docstring: 'The stalk evaluation of a piece over the supported points it sees, as
  one linear map

  into the product of local models.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffStalkEval.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.pieceStalkEval
type: lean
updated: '2026-07-30T03:30:39'
---
noncomputable def pieceStalkEval (j : D.index) :
    A.colength j →ₗ[K]
      ∀ p : {p // p ∈ (Scheme.presentationDivisor K d.presentation).support.filter
        (fun p => p.1 ∈ D.pieces j)},
        ((relCurve C K).presheaf.stalk p.1.1 ⧸ d.stalkIdeal p.1.1) :=
  LinearMap.pi fun p =>
    (A.stalkColEval j (Finset.mem_filter.mp p.2).2).toLinearMap

open scoped Classical in