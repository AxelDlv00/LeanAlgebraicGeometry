---
author: sync
content_type: definition
created: '2026-07-29T07:37:19'
decl: AlgebraicGeometry.cechPicTransportLeftEquiv
docstring: The same seam as a group isomorphism of Čech Picard groups.
file: AlgebraicJacobian/Tangent/CechPicIsoTransport.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechPicTransportLeftEquiv
type: lean
updated: '2026-07-29T15:31:50'
---
noncomputable def cechPicTransportLeftEquiv :
    (relCurve C k).CechPic ≃* (C ⊗ Over.mk (𝟙 (Spec (CommRingCat.of k)))).left.CechPic :=
  Scheme.cechPicMapEquivOfIso (transportLeft k C)