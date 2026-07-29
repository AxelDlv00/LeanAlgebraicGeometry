---
author: sync
content_type: definition
created: '2026-07-24T17:02:47'
decl: AlgebraicGeometry.DivisorAdaptation.gluedToVanishingₗ
docstring: The forward junction, as an `R`-linear map.
file: AlgebraicJacobian/Picard/DivSchemeCertificateEngine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.gluedToVanishingₗ
type: lean
updated: '2026-07-29T15:31:39'
---
noncomputable def gluedToVanishingₗ :
    A.ThetaIdealSections a ⊤ →ₗ[R]
      ↥(d.vanishingSubmodule R (relCover C R (fiberTwoCover π)).V₀
        (relCover C R (fiberTwoCover π)).V₁ (relThetaCocycle C R π a)) where
  toFun := gluedToVanishing A a
  map_add' s t := by
    refine Subtype.ext (Subtype.ext (Prod.ext ?_ ?_))
    · change gluedToIdeal₀ A a
          (inf_le_right : ⊤ ⊓ (relCover C R (fiberTwoCover π)).V₀
            ≤ (relCover C R (fiberTwoCover π)).V₀)
          (secRes ((A.thetaIdealDatum a).sheaf)
            (inf_le_left : ⊤ ⊓ (relCover C R (fiberTwoCover π)).V₀ ≤ ⊤) (s + t))
        = gluedToIdeal₀ A a inf_le_right
            (secRes ((A.thetaIdealDatum a).sheaf) inf_le_left s)
          + gluedToIdeal₀ A a inf_le_right
              (secRes ((A.thetaIdealDatum a).sheaf) inf_le_left t)
      rw [map_add, gluedToIdeal₀_add]
    · change gluedToIdeal₁ A a
          (inf_le_right : ⊤ ⊓ (relCover C R (fiberTwoCover π)).V₁
            ≤ (relCover C R (fiberTwoCover π)).V₁)
          (secRes ((A.thetaIdealDatum a).sheaf)
            (inf_le_left : ⊤ ⊓ (relCover C R (fiberTwoCover π)).V₁ ≤ ⊤) (s + t))
        = gluedToIdeal₁ A a inf_le_right
            (secRes ((A.thetaIdealDatum a).sheaf) inf_le_left s)
          + gluedToIdeal₁ A a inf_le_right
              (secRes ((A.thetaIdealDatum a).sheaf) inf_le_left t)
      rw [map_add, gluedToIdeal₁_add]
  map_smul' r s := by
    refine Subtype.ext (Subtype.ext (Prod.ext ?_ ?_))
    · change gluedToIdeal₀ A a
          (inf_le_right : ⊤ ⊓ (relCover C R (fiberTwoCover π)).V₀
            ≤ (relCover C R (fiberTwoCover π)).V₀)
          (secRes ((A.thetaIdealDatum a).sheaf)
            (inf_le_left : ⊤ ⊓ (relCover C R (fiberTwoCover π)).V₀ ≤ ⊤) (r • s))
        = r • gluedToIdeal₀ A a inf_le_right
            (secRes ((A.thetaIdealDatum a).sheaf) inf_le_left s)
      rw [map_smul, gluedToIdeal₀_smul]
    · change gluedToIdeal₁ A a
          (inf_le_right : ⊤ ⊓ (relCover C R (fiberTwoCover π)).V₁
            ≤ (relCover C R (fiberTwoCover π)).V₁)
          (secRes ((A.thetaIdealDatum a).sheaf)
            (inf_le_left : ⊤ ⊓ (relCover C R (fiberTwoCover π)).V₁ ≤ ⊤) (r • s))
        = r • gluedToIdeal₁ A a inf_le_right
            (secRes ((A.thetaIdealDatum a).sheaf) inf_le_left s)
      rw [map_smul, gluedToIdeal₁_smul]