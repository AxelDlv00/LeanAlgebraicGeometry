---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.ProjTwist.triple_range_le
docstring: The triple-overlap inclusion `T ⟶ Proj` lands in `D₊(XᵢXⱼXₖ)`.
file: AlgebraicJacobian/Picard/SerreTwist.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjTwist.triple_range_le
type: lean
updated: '2026-07-16T21:14:28'
---
lemma triple_range_le (i j k : n) :
    Set.range (pullback.fst ((glueData n).f i j) ((glueData n).f i k) ≫
        (glueData n).f i j ≫ (basicOpenCover n).f i).base ⊆
      Set.range ((Proj.basicOpen (homogeneousSubmodule n (ULift.{u} ℤ))
        (X i * X j * X k)).ι).base := by
  have fi : pullback.fst ((glueData n).f i j) ((glueData n).f i k) ≫
        (glueData n).f i j ≫ (basicOpenCover n).f i
      = (pullback.fst ((glueData n).f i j) ((glueData n).f i k) ≫ (glueData n).f i j) ≫
          (basicOpenCover n).f i := by rw [Category.assoc]
  have fj : pullback.fst ((glueData n).f i j) ((glueData n).f i k) ≫
        (glueData n).f i j ≫ (basicOpenCover n).f i
      = (pullback.fst ((glueData n).f i j) ((glueData n).f i k) ≫
          pullback.snd ((basicOpenCover n).f i) ((basicOpenCover n).f j)) ≫
          (basicOpenCover n).f j := by
    rw [chart_overlap_swap n i j, ← Category.assoc]
  have fk : pullback.fst ((glueData n).f i j) ((glueData n).f i k) ≫
        (glueData n).f i j ≫ (basicOpenCover n).f i
      = (pullback.snd ((glueData n).f i j) ((glueData n).f i k) ≫
          pullback.snd ((basicOpenCover n).f i) ((basicOpenCover n).f k)) ≫
          (basicOpenCover n).f k := by
    rw [← Category.assoc, pullback.condition, Category.assoc, chart_overlap_swap n i k,
      ← Category.assoc]
  rw [Scheme.Opens.range_ι, Proj.basicOpen_mul, Proj.basicOpen_mul,
    TopologicalSpace.Opens.coe_inf, TopologicalSpace.Opens.coe_inf]
  refine Set.subset_inter (Set.subset_inter ?_ ?_) ?_
  · rw [← Scheme.Opens.range_ι ((Proj.basicOpen _ (X i))), fi, Scheme.Hom.comp_base,
      TopCat.coe_comp, Set.range_comp]
    exact Set.image_subset_range _ _
  · rw [← Scheme.Opens.range_ι ((Proj.basicOpen _ (X j))), fj, Scheme.Hom.comp_base,
      TopCat.coe_comp, Set.range_comp]
    exact Set.image_subset_range _ _
  · rw [← Scheme.Opens.range_ι ((Proj.basicOpen _ (X k))), fk, Scheme.Hom.comp_base,
      TopCat.coe_comp, Set.range_comp]
    exact Set.image_subset_range _ _