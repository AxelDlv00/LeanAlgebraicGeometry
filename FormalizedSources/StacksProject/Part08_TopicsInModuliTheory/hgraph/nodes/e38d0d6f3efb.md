---
author: sync
content_type: theorem
created: '2026-08-27T21:56:28'
decl: StacksPart08.prestable_iff
file: StacksPart08Lib/ModuliCurves.lean
generated: lean
lean_status: lean_ok
title: StacksPart08.prestable_iff
type: lean
updated: '2026-08-27T21:56:28'
---
theorem prestable_iff {GeometricFiber : Type u} (f : FamilyOfCurves GeometricFiber) :
    Prestable f ↔
      f.atWorstNodalOfRelativeDimensionOne ∧
        f.pushforwardStructureSheafUniversallyTrivial :=
  Iff.rfl