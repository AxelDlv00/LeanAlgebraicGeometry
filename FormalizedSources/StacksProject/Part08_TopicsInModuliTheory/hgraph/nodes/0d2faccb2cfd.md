---
author: sync
content_type: theorem
created: '2026-08-28T00:07:20'
decl: StacksPart08.FamilyOfCurves.reindex_semistable
docstring: Reindexing preserves semistability.
file: StacksPart08Lib/ModuliCurves.lean
generated: lean
lean_status: lean_ok
title: StacksPart08.FamilyOfCurves.reindex_semistable
type: lean
updated: '2026-08-28T00:07:20'
---
theorem FamilyOfCurves.reindex_semistable {GeometricFiber : Type u} {J : Type v}
    (f : FamilyOfCurves GeometricFiber) (g : J → GeometricFiber)
    (hf : Semistable f) : Semistable (f.reindex g) := by
  refine ⟨f.reindex_prestable g hf.1, ?_⟩
  intro j
  simpa [FamilyOfCurves.reindex] using hf.2 (g j)