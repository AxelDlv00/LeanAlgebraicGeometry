---
author: sync
content_type: theorem
created: '2026-07-29T04:25:58'
decl: CategoryTheory.MonObj.permAutIso_hom
file: AlgebraicJacobian/Albanese/GrpObjFoldSum.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.MonObj.permAutIso_hom
type: lean
updated: '2026-07-29T04:25:58'
---
theorem permAutIso_hom (C : K) {n : ℕ} (σ : Equiv.Perm (Fin n)) :
    (permAutIso C σ).hom = permAut C σ := rfl