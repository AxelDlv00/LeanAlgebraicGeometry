---
author: sync
content_type: theorem
created: '2026-07-30T21:44:02'
decl: AlgebraicGeometry.overSpecFieldExtension_mem_fpqcTopology
docstring: A field extension gives a singleton fpqc cover of the base field.
file: AlgebraicJacobian/Picard/Pic0ChartFiniteExtension.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.overSpecFieldExtension_mem_fpqcTopology
type: lean
updated: '2026-07-31T20:14:50'
---
theorem overSpecFieldExtension_mem_fpqcTopology :
    Sieve.generate (Presieve.singleton (overSpec k L).hom) ∈
      Scheme.fpqcTopology (Spec (.of k)) :=
  Precoverage.generate_mem_toGrothendieck
    (overSpec k L).hom.singleton_mem_fpqcPrecoverage

variable (C) in