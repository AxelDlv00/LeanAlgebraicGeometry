---
author: sync
content_type: definition
created: '2026-08-11T21:31:48'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.nativeAffinePushforwardRestriction
file: AlgebraicJacobian/Picard/Pic0RankOneNativeBaseChangeLocalizing.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.BasicOpenCocycleDatum.nativeAffinePushforwardRestriction
type: lean
updated: '2026-08-18T20:51:05'
---
private noncomputable def nativeAffinePushforwardRestriction (f : B) :=
  ((modulesSpecToSheaf.obj
    ((Scheme.Modules.pushforward
      (relCurve C B ↘ Spec (.of B))).obj D.nativeModule)).obj.map
        (PrimeSpectrum.basicOpen f).leTop.op).hom

set_option maxHeartbeats 1200000 in