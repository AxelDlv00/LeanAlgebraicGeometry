---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.DivisorAdaptation.gluedVanishingSnd
docstring: The chart-1 assembly of a global datum section, on `⊤ ⊓ V₁`.
file: AlgebraicJacobian/Picard/DivSchemeCertificate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.gluedVanishingSnd
type: lean
updated: '2026-07-30T15:46:02'
---
noncomputable def gluedVanishingSnd (s : A.ThetaIdealSections a ⊤) :
    Γ(relCurve C R, ⊤ ⊓ (relCover C R (fiberTwoCover π)).V₁) :=
  gluedToIdeal₁ A a
    (inf_le_right : ⊤ ⊓ (relCover C R (fiberTwoCover π)).V₁
      ≤ (relCover C R (fiberTwoCover π)).V₁)
    (secRes ((A.thetaIdealDatum a).sheaf)
      (inf_le_left : ⊤ ⊓ (relCover C R (fiberTwoCover π)).V₁ ≤ ⊤) s)