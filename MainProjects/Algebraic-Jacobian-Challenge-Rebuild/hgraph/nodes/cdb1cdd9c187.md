---
author: sync
content_type: theorem
created: '2026-08-01T13:18:07'
decl: Algebra.DescentDatum.Hom.comp_id
file: AlgebraicJacobian/Descent/AlgebraDescent.lean
generated: lean
lean_status: lean_ok
title: Algebra.DescentDatum.Hom.comp_id
type: lean
updated: '2026-08-01T13:18:07'
---
theorem comp_id (f : Hom D₁ D₂) : comp f (id D₂) = f := by
  ext
  rfl

@[simp]