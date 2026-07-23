---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.toModuleKPresheaf_obj
docstring: 'Object-evaluation simp lemma for `toModuleKPresheaf`. Definitionally true

  by construction; tagged `@[simp]` so consumers can rewrite without unfolding

  the constructor. Phase A step 5 polish (iter-007).'
file: AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.toModuleKPresheaf_obj
type: lean
updated: '2026-07-24T03:02:10'
---
@[simp] lemma toModuleKPresheaf_obj (C : Over (Spec (CommRingCat.of k)))
    (U : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ) :
    (toModuleKPresheaf C).obj U = ModuleCat.of k (C.left.presheaf.obj U) :=
  rfl