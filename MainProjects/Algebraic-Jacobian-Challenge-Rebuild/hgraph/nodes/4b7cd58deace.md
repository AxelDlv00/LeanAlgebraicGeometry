---
author: sync
content_type: theorem
created: '2026-08-01T13:18:07'
decl: Algebra.DescentDatum.Hom.id_comp
file: AlgebraicJacobian/Descent/AlgebraDescent.lean
generated: lean
lean_status: lean_ok
title: Algebra.DescentDatum.Hom.id_comp
type: lean
updated: '2026-08-01T13:18:07'
---
theorem id_comp (f : Hom D₁ D₂) : comp (id D₁) f = f := by
  ext
  rfl

@[simp]