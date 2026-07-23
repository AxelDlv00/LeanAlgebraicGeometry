---
author: sync
content_type: instance
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.AffineCoverMVSquare.instModuleH1Cok
file: AlgebraicJacobian/RiemannRoch/Adelic/Cokernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.AffineCoverMVSquare.instModuleH1Cok
type: lean
updated: '2026-07-24T03:02:13'
---
noncomputable instance AffineCoverMVSquare.instModuleH1Cok
    (S : X.AffineCoverMVSquare) : Module k (S.H1Cok F) :=
  inferInstanceAs (Module k (_ ⧸ LinearMap.range (S.sectionDiff F)))