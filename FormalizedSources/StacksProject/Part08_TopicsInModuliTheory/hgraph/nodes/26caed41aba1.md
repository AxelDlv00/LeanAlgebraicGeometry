---
author: sync
content_type: theorem
created: '2026-08-27T21:56:28'
decl: StacksPart08.Stable.prestable
docstring: Every stable family is prestable.
file: StacksPart08Lib/ModuliCurves.lean
generated: lean
lean_status: lean_ok
title: StacksPart08.Stable.prestable
type: lean
updated: '2026-08-27T21:56:28'
---
theorem Stable.prestable {GeometricFiber : Type u}
    {f : FamilyOfCurves GeometricFiber} (hf : Stable f) : Prestable f :=
  hf.1