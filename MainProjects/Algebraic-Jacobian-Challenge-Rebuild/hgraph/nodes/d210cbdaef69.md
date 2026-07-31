---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicJacobian.RigidEngine.comp_ker_subtype
docstring: '`δ` composed with the inclusion of its kernel is the zero map.'
file: AlgebraicJacobian/Cohomology/RigidEngine3Rigidity.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.RigidEngine.comp_ker_subtype
type: lean
updated: '2026-07-31T20:15:18'
---
theorem comp_ker_subtype : δ ∘ₗ (LinearMap.ker δ).subtype = 0 := by
  ext x
  exact LinearMap.mem_ker.mp x.2