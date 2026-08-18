---
author: sync
content_type: definition
created: '2026-08-11T17:13:18'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.nativePullbackIso
docstring: The canonical native-module pullback isomorphism for an arbitrary affine
  base change.
file: AlgebraicJacobian/Picard/Pic0RankOneNativeBaseChangePullback.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCocycleDatum.nativePullbackIso
type: lean
updated: '2026-08-18T20:51:05'
---
noncomputable def nativePullbackIso :
    (Scheme.Modules.pullback (relCurveMap C B B')).obj D.nativeModule ≅
      (D.baseChange B').nativeModule := by
  letI := D.isIso_nativePullbackComparison B'
  exact asIso (D.nativePullbackComparison B')