---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.gluedTriv_gluedQsmul
docstring: 'The piece trivializations intertwine the componentwise action with

  restrict-and-multiply.'
file: AlgebraicJacobian/Cohomology/GluedSheafQcoh.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.gluedTriv_gluedQsmul
type: lean
updated: '2026-08-01T09:44:09'
---
lemma gluedTriv_gluedQsmul (hc : Scheme.IsGluingCocycle U g) {V W : X.Opens}
    (hWV : W ≤ V) {j : J} (hWj : W ≤ U j) (r : Γ(X, V))
    (s : ↥(gluedSubmodule k U g W)) :
    gluedTriv k hc j hWj (gluedQsmul k U g hWV r s) =
      X.resHom hWV r * gluedTriv k hc j hWj s := by
  rw [gluedTriv_apply, gluedTriv_apply, gluedQsmul_coe, map_mul]
  simp only [Scheme.resHom_resHom]