---
author: sync
content_type: lemma
created: '2026-07-17T08:41:24'
decl: AlgebraicGeometry.gluedPieceEquiv_symm_apply
file: AlgebraicJacobian/Cohomology/GluedSheafModule.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.gluedPieceEquiv_symm_apply
type: lean
updated: '2026-08-01T09:44:09'
---
lemma gluedPieceEquiv_symm_apply (hc : Scheme.IsGluingCocycle U g)
    (hP : ∀ i : ι, X.basicOpen (h i) ≤ U (σ i)) (i : ι)
    (t : Γ(X, X.basicOpen (h i))) :
    (gluedPieceEquiv k U g hc hP i).symm t = (gluedTriv k hc (σ i) (hP i)).symm t :=
  rfl