---
author: sync
content_type: definition
created: '2026-08-11T21:31:48'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.nativePrincipalOpenRestriction
file: AlgebraicJacobian/Picard/Pic0RankOneNativeBaseChangeLocalizing.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.BasicOpenCocycleDatum.nativePrincipalOpenRestriction
type: lean
updated: '2026-08-18T20:51:05'
---
private noncomputable def nativePrincipalOpenRestriction (f : B) :
    Γ(D.nativeModule, ⊤) →ₗ[B]
      Γ(D.nativeModule,
        (relCurve C B ↘ Spec (.of B)) ⁻¹ᵁ
          PrimeSpectrum.basicOpen f) :=
  ((Scheme.toModuleKSheafOfModules
    (Over.mk (relCurve C B ↘ Spec (.of B))) D.nativeModule).obj.map
      (homOfLE le_top).op).hom

set_option maxHeartbeats 1200000 in