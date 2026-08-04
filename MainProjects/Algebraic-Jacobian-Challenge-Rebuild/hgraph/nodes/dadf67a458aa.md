---
author: sync
content_type: theorem
created: '2026-08-04T10:53:20'
decl: AlgebraicGeometry.pic0SigmaFunctor_ulift_isSheaf_etale
docstring: 'The universe-raised raw Pic0 Sigma presheaf satisfies the big-etale sheaf

  condition in its sieve form.'
file: AlgebraicJacobian/Picard/Pic0SigmaEtaleSheafificationComparison.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0SigmaFunctor_ulift_isSheaf_etale
type: lean
updated: '2026-08-04T10:53:20'
---
theorem pic0SigmaFunctor_ulift_isSheaf_etale :
    Presieve.IsSheaf Scheme.etaleTopology
      (pic0SigmaFunctor C ⋙ uliftFunctor.{u + 1}) :=
  Presieve.isSheaf_comp_uliftFunctor Scheme.etaleTopology
    (pic0SigmaFunctor_isSheaf_etale C)