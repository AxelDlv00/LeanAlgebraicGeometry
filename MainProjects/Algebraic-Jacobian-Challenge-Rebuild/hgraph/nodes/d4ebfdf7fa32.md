---
author: sync
content_type: lemma
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.jumpProj_apply
file: AlgebraicJacobian/RiemannRoch/Devissage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.jumpProj_apply
type: lean
updated: '2026-07-29T15:31:49'
---
lemma jumpProj_apply (U : X.Opens) (hxU : x ∈ U) (s : divisorSections K D U) :
    jumpProj K hx D U hxU s =
      Submodule.Quotient.mk ⟨(s : X.functionField),
        divisorSections_le_pointLattice K hx D U hxU s.2⟩ :=
  rfl