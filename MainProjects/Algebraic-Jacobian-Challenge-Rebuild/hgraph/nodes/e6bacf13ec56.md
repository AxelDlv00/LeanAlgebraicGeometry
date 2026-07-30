---
author: sync
content_type: lemma
created: '2026-07-31T03:02:19'
decl: AlgebraicGeometry.DivisorAdaptation.thetaIdealInclFst_smul
file: AlgebraicJacobian/Picard/DivisorThetaSheafSequence.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.DivisorAdaptation.thetaIdealInclFst_smul
type: lean
updated: '2026-07-31T03:02:19'
---
private lemma thetaIdealInclFst_smul (W : (relCurve C R).Opens) (r : R)
    (s : A.ThetaIdealSections a W) :
    A.thetaIdealInclFst a W (r • s) = r • A.thetaIdealInclFst a W s := by
  change gluedToIdeal₀ A a inf_le_right
      (secRes ((A.thetaIdealDatum a).sheaf) inf_le_left (r • s)) =
    r • gluedToIdeal₀ A a inf_le_right
      (secRes ((A.thetaIdealDatum a).sheaf) inf_le_left s)
  rw [map_smul, gluedToIdeal₀_smul]