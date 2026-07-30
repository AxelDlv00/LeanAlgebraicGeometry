---
author: sync
content_type: theorem
created: '2026-07-26T00:52:50'
decl: AlgebraicGeometry.isCompatible_of_isDivRepClassify_divRepPullAt
docstring: '**The F5 overlap obligation collapses to a per-chart clause** (the corollary
  the

  separation theorem was for): if each chart pullback of `U` satisfies the characterizing

  clause for its own chart morphism, then `U` is compatible.


  `DivRepChartFamily.IsCompatible`''s docstring says the universal family will prove
  it "from

  its ε identity AND the total mono theorem".  The mono leg is now unnecessary: two
  chart

  points presenting the SAME morphism `q` give two classes both classified by `q`,
  and

  `eq_of_isDivRepClassify` identifies them.  What is left is exactly the per-chart
  clause —

  i.e. exactly the DDR9-U ε-identity U2 — so the F5 overlap obligation is no longer
  a second,

  separate thing to prove.'
file: AlgebraicJacobian/Picard/DivRepAffPullbackReduce.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isCompatible_of_isDivRepClassify_divRepPullAt
type: lean
updated: '2026-07-30T15:46:01'
---
theorem isCompatible_of_isDivRepClassify_divRepPullAt
    (U : ∀ (i : (glueData k g r1).J) (j : (glueData k g r2).J),
      DivFamZar C (ChartRing i j) pi g)
    (hcl : ∀ {S : Type u} [CommRing S] [Algebra k S]
      (i : (glueData k g r1).J) (j : (glueData k g r2).J)
      (omega : ChartRing i j →ₐ[k] S),
      IsDivRepClassify hpi g r1 r2 b1 b2
        (divRepPullAt (hpi := hpi) g r1 r2 b1 b2 U i j omega)
        (Spec.map (CommRingCat.ofHom omega.toRingHom) ≫ ChartMap i j)) :
    DivRepChartFamily.IsCompatible (hpi := hpi) g r1 r2 b1 b2 U := by
  intro S _ _ i j i' j' omega omega' hq
  refine eq_of_isDivRepClassify hpi g hO hchi r1 r2 b1 b2 _ _ (v := ?_) ?_ ?_
  · exact Spec.map (CommRingCat.ofHom omega.toRingHom) ≫ ChartMap i j
  · exact hcl i j omega
  · exact hq ▸ hcl i' j' omega'

include hO hchi in