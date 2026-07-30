---
author: sync
content_type: theorem
created: '2026-07-30T16:21:25'
decl: AlgebraicGeometry.ProjectiveSpace.affineChart.changeChartHom_over
file: AlgebraicJacobian/Picard/ProjectiveSpaceAffineChartIso.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.ProjectiveSpace.affineChart.changeChartHom_over
type: lean
updated: '2026-07-30T16:21:25'
---
private theorem changeChartHom_over :
    changeChartHom n S ≫ (𝔸(n; S) ↘ S) =
      pullback.fst (terminal.from S)
        (integralChartIncl n ≫
          terminal.from (Proj (homogeneousSubmodule (Option n) (ULift.{u} ℤ)))) := by
  change pullback.lift _ _ _ ≫ pullback.fst _ _ = _
  rw [pullback.lift_fst, Category.comp_id]

omit [Finite n] in
@[reassoc]