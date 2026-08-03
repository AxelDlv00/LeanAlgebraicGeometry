---
author: sync
content_type: theorem
created: '2026-08-03T13:09:52'
decl: AlgebraicGeometry.divRepClassifyZarAff_surjective_of_chartClause_at
docstring: The clause form implies surjectivity of the classifier at an independent
  curve parameter.
file: AlgebraicJacobian/Picard/DivRepClassifyZarAffSurj.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divRepClassifyZarAff_surjective_of_chartClause_at
type: lean
updated: '2026-08-03T13:09:52'
---
theorem divRepClassifyZarAff_surjective_of_chartClause_at
    (hOAt : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
    {gamma : ℕ} (hgamma : gamma ≤ g)
    (hchiGamma : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (gamma : ℤ))
    (U : ∀ (i : (glueData k g r1).J) (j : (glueData k g r2).J),
      DivFamZarAff C (ChartRing i j) g)
    (hU : DivRepChartFamilyAff.IsChartClause (hpi := hpi) g r1 r2 b1 b2 U)
    (S : Type u) [CommRing S] [Algebra k S] :
    Function.Surjective
      (divRepClassifyZarAff_at (C := C) (pi := pi) (S := S) (gamma := gamma)
        hpi g r1 r2 b1 b2 hgamma hchiGamma) :=
  fun v => exists_divRepClassifyZarAff_eq_of_chartRange_at
    (hpi := hpi) (g := g) (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2)
    (hOAt := hOAt) (gamma := gamma) (hgamma := hgamma)
    (hchiGamma := hchiGamma) U
    (divRepClassifyZarAff_left_eq_chartMap_at
      (hpi := hpi) (g := g) (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2)
      (gamma := gamma) (hgamma := hgamma) (hchiGamma := hchiGamma) U hU) S v