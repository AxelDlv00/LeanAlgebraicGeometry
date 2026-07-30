---
author: sync
content_type: definition
created: '2026-07-30T16:21:25'
decl: AlgebraicGeometry.ProjectiveSpace.affineChart.flattenIso
file: AlgebraicJacobian/Picard/ProjectiveSpaceAffineChartIso.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.ProjectiveSpace.affineChart.flattenIso
type: lean
updated: '2026-07-30T16:21:25'
---
private def flattenIso :
    affineChart n S ≅
      pullback (terminal.from S)
        (integralChartIncl n ≫
          terminal.from (Proj (homogeneousSubmodule (Option n) (ULift.{u} ℤ)))) :=
  pullbackLeftPullbackSndIso
    (terminal.from S)
    (terminal.from (Proj (homogeneousSubmodule (Option n) (ULift.{u} ℤ))))
    (integralChartIncl n)