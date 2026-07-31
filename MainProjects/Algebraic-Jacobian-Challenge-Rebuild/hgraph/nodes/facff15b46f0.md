---
author: sync
content_type: theorem
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.ker_graphSectionEval_eq_span_graphChartEqn
docstring: '**The kernel presentation of the graph ideal** (the multiplicity input
  of G-D8''s

  degree-1 certificate): on the graph chart, the kernel of the evaluation at the graph

  section is the principal ideal on the graph equation.  The pushed B0 diagonal-ideal
  engine

  (`ker_pointEv_map_localization_eq`), read through the basic-open localization seam.'
file: AlgebraicJacobian/RiemannRoch/GraphChart.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.ker_graphSectionEval_eq_span_graphChartEqn
type: lean
updated: '2026-07-31T20:14:52'
---
theorem ker_graphSectionEval_eq_span_graphChartEqn :
    RingHom.ker (graphSectionEval t (graphPoint_mem_graphChart C t))
      = Ideal.span {graphChartEqn C t} := by
  classical
  set B := Γ(C.left, graphBaseChart C t)
  set F := Γ((overSpec k K).left, ⊤)
  letI : Algebra (Polynomial k) B :=
    (Over.diagonalChartData C).coordAlgebra (t.left.base default)
  haveI : IsScalarTower k (Polynomial k) B :=
    (Over.diagonalChartData C).isScalarTower (t.left.base default)
  letI : Algebra (Polynomial k) F :=
    ((graphCoordEval C t).toRingHom.comp (algebraMap (Polynomial k) B)).toAlgebra
  haveI : IsScalarTower k (Polynomial k) F := .of_algebraMap_eq fun p => by
    rw [show algebraMap (Polynomial k) F
        = (graphCoordEval C t).toRingHom.comp (algebraMap (Polynomial k) B) from rfl,
      RingHom.comp_apply, ← IsScalarTower.algebraMap_apply k (Polynomial k) B]
    exact ((graphCoordEval C t).commutes _).symm
  set c : B →ₐ[Polynomial k] F :=
    { toRingHom := (graphCoordEval C t).toRingHom, commutes' := fun p => rfl } with hc
  -- the localization structure on the chart sections
  letI : Algebra (B ⊗[k] F) Γ((C ⊗ overSpec k K).left, graphChart C t) :=
    ((algebraMap Γ((C ⊗ overSpec k K).left,
          Over.productChart C (overSpec k K) (graphBaseChart C t) ⊤)
        Γ((C ⊗ overSpec k K).left, graphChart C t)).comp
      (Over.productChartSections C (overSpec k K) (isAffineOpen_graphBaseChart C t)
        (isAffineOpen_top_overSpec k K)).toRingHom).toAlgebra
  haveI hlocz : IsLocalization.Away (1 - AlgebraicJacobian.Diagonal.mapRight c
        ((Over.diagonalChartData C).elift (t.left.base default)))
      Γ((C ⊗ overSpec k K).left, graphChart C t) := by
    have hbr : AlgebraicJacobian.Diagonal.mapRight c
        ((Over.diagonalChartData C).elift (t.left.base default)) = graphElift C t := rfl
    rw [hbr]
    exact Over.isLocalization_away_basicOpen_productChartSections C (overSpec k K)
      (isAffineOpen_graphBaseChart C t) (isAffineOpen_top_overSpec k K)
      (1 - graphElift C t)
  -- the pushed diagonal-ideal keystone
  have hkey := AlgebraicJacobian.Diagonal.ker_pointEv_map_localization_eq c
    ((Over.diagonalChartData C).elift (t.left.base default))
    ((Over.diagonalChartData C).isIdempotentElem_baseChange_elift (t.left.base default))
    ((Over.diagonalChartData C).ker_lmul'_eq_span_baseChange_elift (t.left.base default))
    Γ((C ⊗ overSpec k K).left, graphChart C t)
  -- identify the two evaluations and the two generators
  have hev : AlgebraicJacobian.Diagonal.pointEv c = graphTensorEval C t := rfl
  have hgen : AlgebraicJacobian.Diagonal.pointGen k B F = graphGen C t := rfl
  have halg : ∀ y : B ⊗[k] F,
      algebraMap (B ⊗[k] F) Γ((C ⊗ overSpec k K).left, graphChart C t) y
        = ((C ⊗ overSpec k K).left.presheaf.map
            (homOfLE (graphChart_le_productChart C t)).op).hom
            (Over.productChartSections C (overSpec k K)
              (isAffineOpen_graphBaseChart C t) (isAffineOpen_top_overSpec k K) y) :=
    fun _ => rfl
  have hEqn : algebraMap (B ⊗[k] F) Γ((C ⊗ overSpec k K).left, graphChart C t)
      (graphGen C t) = graphChartEqn C t := rfl
  -- the evaluation on the chart is the localized tensor evaluation
  have hεalg : ∀ y : B ⊗[k] F,
      graphSectionEval t (graphPoint_mem_graphChart C t)
          (algebraMap (B ⊗[k] F) Γ((C ⊗ overSpec k K).left, graphChart C t) y)
        = graphTensorEval C t y := by
    intro y
    rw [halg y, graphSectionEval_res t (graphPoint_mem_graphChart C t)
      (graphChart_le_productChart C t), graphSectionEval_productChartSections]
  refine le_antisymm ?_ ?_
  · -- ker ε ⊆ span: clear denominators into the tensor ring
    intro z hz
    rw [RingHom.mem_ker] at hz
    obtain ⟨⟨b, s⟩, hb⟩ := IsLocalization.surj
      (M := Submonoid.powers (1 - AlgebraicJacobian.Diagonal.mapRight c
        ((Over.diagonalChartData C).elift (t.left.base default)))) z
    obtain ⟨n, hs⟩ := s.2
    have hεs : graphSectionEval t (graphPoint_mem_graphChart C t)
        (algebraMap (B ⊗[k] F) Γ((C ⊗ overSpec k K).left, graphChart C t) (s : B ⊗[k] F))
        = 1 := by
      rw [hεalg, ← hs, map_pow]
      rw [show AlgebraicJacobian.Diagonal.mapRight c
          ((Over.diagonalChartData C).elift (t.left.base default)) = graphElift C t from rfl]
      rw [map_sub, map_one, graphTensorEval_graphElift, sub_zero, one_pow]
    have hεb : graphTensorEval C t b = 0 := by
      have := congrArg (graphSectionEval t (graphPoint_mem_graphChart C t)) hb
      rw [map_mul, hz, zero_mul, hεalg] at this
      exact this.symm
    have hbmem : algebraMap (B ⊗[k] F) Γ((C ⊗ overSpec k K).left, graphChart C t) b
        ∈ (RingHom.ker (AlgebraicJacobian.Diagonal.pointEv c)).map
          (algebraMap (B ⊗[k] F) Γ((C ⊗ overSpec k K).left, graphChart C t)) := by
      refine Ideal.mem_map_of_mem _ ?_
      rw [RingHom.mem_ker, hev]
      exact hεb
    rw [hkey] at hbmem
    have hunit : IsUnit (algebraMap (B ⊗[k] F)
        Γ((C ⊗ overSpec k K).left, graphChart C t) (s : B ⊗[k] F)) :=
      IsLocalization.map_units _ s
    have hz' : z = algebraMap (B ⊗[k] F) Γ((C ⊗ overSpec k K).left, graphChart C t) b
        * ↑hunit.unit⁻¹ := by
      rw [eq_comm, Units.mul_inv_eq_iff_eq_mul]
      rw [← hb]
      rfl
    rw [hz', ← hEqn]
    exact Ideal.mul_mem_right _ _ hbmem
  · -- span ⊆ ker ε: the generator evaluates to zero
    rw [Ideal.span_le, Set.singleton_subset_iff, SetLike.mem_coe, RingHom.mem_ker,
      ← hEqn, hεalg, ← hgen, ← hev]
    exact AlgebraicJacobian.Diagonal.pointEv_pointGen c