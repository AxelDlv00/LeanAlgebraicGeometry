---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.unitHomEquiv_scalarEnd
docstring: '`scalarEnd c` corresponds to the global section `c` under `unitHomEquiv`.'
file: AlgebraicJacobian/Picard/GrassmannianQuot.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.unitHomEquiv_scalarEnd
type: lean
updated: '2026-07-24T03:02:11'
---
lemma unitHomEquiv_scalarEnd (c : Γ(X, ⊤)) :
    (SheafOfModules.unit X.ringCatSheaf).unitHomEquiv (scalarEnd c) = globalUnitSection c := by
  rw [scalarEnd, Equiv.apply_symm_apply]