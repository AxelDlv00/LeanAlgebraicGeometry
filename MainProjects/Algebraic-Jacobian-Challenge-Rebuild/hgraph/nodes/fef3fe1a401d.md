---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: Algebra.EtaleCover.prod_refines_left
file: AlgebraicJacobian/Algebra/EtaleCover.lean
generated: lean
lean_status: lean_ok
title: Algebra.EtaleCover.prod_refines_left
type: lean
updated: '2026-07-29T15:31:34'
---
theorem prod_refines_left (E E' : EtaleCover A) : (E.prod E').Refines E :=
  ⟨E.prodInl E'⟩