---
author: sync
content_type: theorem
created: '2026-07-30T07:28:28'
decl: AlgebraicGeometry.exists_uniform_bound_forall_baseChange
docstring: '**The threshold in DAT-0a''s own `∃ b` shape, with the `∃` OUTSIDE the
  quantifier over

  the field.**


  `exists_bound_subsingleton_hModule_one_of_isFinite_toP1` reads

  `∃ b, ∀ D, b ≤ deg D → H¹ = 0` at *one* curve over *one* field.  The coverage layer
  needs it

  at the splitting field of each test point, and the pricing in

  `Picard/Pic0ChartCoverageIndexSlack.lean` reasons about "the threshold `b_L`" as
  though the

  `∃` had to sit inside the choice of `L`.  It does not: this is the same shape with
  the

  quantifiers in the order that makes the calibration a single equation rather than
  a family of

  them.


  Stated separately from `subsingleton_h1_of_ledger_bound` because *this* is the statement
  the

  residue was priced against, and having it as an `∃` makes the comparison mechanical
  rather

  than a reading of two docstrings.  The witness is the ledger value, which is why
  it does not

  depend on `L`.'
file: AlgebraicJacobian/Picard/Pic0ChartCoverageThreshold.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_uniform_bound_forall_baseChange
type: lean
updated: '2026-07-30T07:28:28'
---
theorem exists_uniform_bound_forall_baseChange {π : C.left ⟶ P1 k} [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k)) (g : ℕ)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ)) :
    ∃ b : ℤ, ∀ (L : Type u) (_ : Field L) (_ : Algebra k L),
      ∀ (_ : IsIntegral (relCurve C L))
        (_ : SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (CommRingCat.of L)))
        (_ : QuasiCompact (relCurve C L ↘ Spec (CommRingCat.of L)))
        (_ : Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0))
        (_ : Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1)),
      ∀ D : (relCurve C L).CurveDivisor, b ≤ Scheme.CurveDivisor.deg L D →
        Subsingleton (Sheaf.HModule ((relCurve C L).divisorSheaf L D) 1) :=
  ⟨(windowM_choice π hπ g : ℤ) * windowδ π + (g : ℤ),
    fun L _ _ _ _ _ _ _ D hD => subsingleton_h1_of_ledger_bound hπ g hχ L D hD⟩

/-! ## Coverage with the threshold discharged

`mem_chartLocus_of_vanishing_bound` (`Picard/Pic0ChartCoverageNoDrop.lean:154`) takes `hb`
(the threshold) and `hdeg` (the calibration).  The threshold is now available at the
splitting field, so the composite below carries only the calibration — which is what
`Pic0ChartCoverageIndexSlack`'s `index_of_threshold` is about. -/