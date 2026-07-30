---
author: sync
content_type: theorem
created: '2026-07-30T23:35:09'
decl: AlgebraicGeometry.Adelic.LaurentChartData.FiniteMapGenerators.range_liftedBB
file: AlgebraicJacobian/Picard/FiniteMapLaurentGenerators.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.LaurentChartData.FiniteMapGenerators.range_liftedBB
type: lean
updated: '2026-07-30T23:35:09'
---
theorem LaurentChartData.FiniteMapGenerators.range_liftedBB
    {D : LaurentChartData Y} {pi : C ⟶ Y} (G : D.FiniteMapGenerators pi) :
    Set.range G.liftedBB = Set.range G.bb := by
  ext z
  constructor
  · rintro ⟨i, rfl⟩
    exact ⟨i.down, rfl⟩
  · rintro ⟨i, rfl⟩
    exact ⟨ULift.up i, rfl⟩