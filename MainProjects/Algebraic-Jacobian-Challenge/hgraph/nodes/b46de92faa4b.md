---
author: sync
content_type: lemma
created: '2026-07-24T17:02:56'
decl: AlgebraicGeometry.wpEqProd_hom_π
file: AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.wpEqProd_hom_π
type: lean
updated: '2026-07-28T13:22:16'
---
private lemma wpEqProd_hom_π (f : (i : ι) → Z i ⟶ S) (m : ℕ) (l : Fin m) :
    (widePullback_overX_eq_prod (fun _ : Fin m => Limits.Sigma.desc f)).hom ≫
      Pi.π (fun _ : Fin m => Over.mk (Limits.Sigma.desc f)) l = overWPproj f m l :=
  IsLimit.conePointUniqueUpToIso_hom_comp _ _ (Discrete.mk l)

set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 1600000 in
-- The successor case unfolds seven distributivity isos; its nested fibre powers exceed
-- the default kernel reduction budget.