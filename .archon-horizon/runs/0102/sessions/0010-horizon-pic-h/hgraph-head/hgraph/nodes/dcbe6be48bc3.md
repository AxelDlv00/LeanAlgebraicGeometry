---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Grassmannian.matrixPoint
docstring: '**The matrix-presented Grassmannian point**: the kernel of a surjective
  matrix

  presentation, with its free rank-`d` quotient certificate.'
file: AlgebraicJacobian/Picard/GrassmannianMatrixPoint.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.matrixPoint
type: lean
updated: '2026-08-01T09:44:15'
---
noncomputable def matrixPoint (X : Matrix (Fin d) (Fin r) S)
    (hX : Function.Surjective (matrixProj k d r S X)) :
    grFunctorAff k (Fin r → k) d S where
  toSubmodule := LinearMap.ker (matrixProj k d r S X)
  finite_quotient := Module.Finite.equiv (matrixQuotEquiv k d r S X hX).symm
  projective_quotient := Module.Projective.of_equiv (matrixQuotEquiv k d r S X hX).symm
  rankAtStalk_eq p := by
    haveI : Nontrivial S := by
      rcases subsingleton_or_nontrivial S with hS | hS
      · exact absurd (p.asIdeal.eq_top_iff_one.mpr
          (by rw [Subsingleton.elim (1 : S) 0]; exact zero_mem _)) p.isPrime.ne_top
      · exact hS
    rw [show Module.rankAtStalk (R := S)
          (TensorProduct k S (Fin r → k) ⧸ LinearMap.ker (matrixProj k d r S X)) p
        = Module.rankAtStalk (R := S) (Fin d → S) p from
      congrFun (Module.rankAtStalk_eq_of_equiv (matrixQuotEquiv k d r S X hX)) p,
      show Module.rankAtStalk (R := S) (Fin d → S) p
        = Module.finrank S (Fin d → S) from
      congrFun Module.rankAtStalk_eq_finrank_of_free p,
      Module.finrank_fin_fun]

@[simp]