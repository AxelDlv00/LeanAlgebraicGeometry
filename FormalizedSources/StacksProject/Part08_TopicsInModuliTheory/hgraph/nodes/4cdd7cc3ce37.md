---
author: sync
content_type: theorem
created: '2026-08-28T00:07:20'
decl: StacksPart08.NumericalSituation.locusOn_isOpen
file: StacksPart08Lib/Numerical.lean
generated: lean
lean_status: lean_ok
title: StacksPart08.NumericalSituation.locusOn_isOpen
type: lean
updated: '2026-08-28T00:07:20'
---
theorem locusOn_isOpen {X I : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) (J : Set I) (hJ : J.Finite) :
    IsOpen (s.locusOn J) :=
  (s.locusOn_isClopen J hJ).isOpen