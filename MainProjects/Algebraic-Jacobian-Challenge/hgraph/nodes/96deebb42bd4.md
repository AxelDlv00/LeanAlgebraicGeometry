---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.toModuleKSheaf.algebraMap_eq_kToSection
docstring: 'Phase A step 5 main, helper (3): unfolding lemma for the algebra map.'
file: AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.toModuleKSheaf.algebraMap_eq_kToSection
type: lean
updated: '2026-07-24T03:02:10'
---
lemma algebraMap_eq_kToSection (C : Over (Spec (CommRingCat.of k)))
    (U : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ) :
    (algebraMap k (C.left.presheaf.obj U)) = (kToSection C U).hom :=
  rfl