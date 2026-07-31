---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.gluedTriv_symm_coe
file: AlgebraicJacobian/Cohomology/GluedSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.gluedTriv_symm_coe
type: lean
updated: '2026-07-31T20:15:17'
---
lemma gluedTriv_symm_coe (j : J) {W : X.Opens} (hW : W ≤ U j) (t : Γ(X, W)) (i : J) :
    ((gluedTriv k hc j hW).symm t).val i =
      X.resHom (le_inf inf_le_right (inf_le_left.trans hW) : W ⊓ U i ≤ U i ⊓ U j)
          (g i j : Γ(X, U i ⊓ U j)) *
        X.resHom (inf_le_left : W ⊓ U i ≤ W) t :=
  rfl