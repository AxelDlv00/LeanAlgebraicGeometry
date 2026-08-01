---
author: sync
content_type: theorem
created: '2026-08-01T13:18:07'
decl: Algebra.DescentDatum.Hom.ext
file: AlgebraicJacobian/Descent/AlgebraDescent.lean
generated: lean
lean_status: lean_ok
title: Algebra.DescentDatum.Hom.ext
type: lean
updated: '2026-08-01T13:18:07'
---
theorem ext {f g : Hom D₁ D₂} (h : f.hom = g.hom) : f = g := by
  cases f
  cases g
  cases h
  rfl