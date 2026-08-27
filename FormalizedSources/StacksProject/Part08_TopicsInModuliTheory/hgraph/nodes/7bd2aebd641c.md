---
author: sync
content_type: theorem
created: '2026-08-28T00:07:20'
decl: StacksPart08.FamilyOfCurves.reindex_hasRationalTail
file: StacksPart08Lib/ModuliCurves.lean
generated: lean
lean_status: lean_ok
title: StacksPart08.FamilyOfCurves.reindex_hasRationalTail
type: lean
updated: '2026-08-28T00:07:20'
---
theorem FamilyOfCurves.reindex_hasRationalTail
    {GeometricFiber : Type u} {J : Type v}
    (f : FamilyOfCurves GeometricFiber) (g : J → GeometricFiber) (j : J) :
    (f.reindex g).hasRationalTail j = f.hasRationalTail (g j) := rfl

@[simp]